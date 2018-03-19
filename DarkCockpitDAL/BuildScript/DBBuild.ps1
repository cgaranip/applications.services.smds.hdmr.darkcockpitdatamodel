#------------------------------------------------------------------
#Receive the environment specific config elements along with debug flag to output debug info to console
#------------------------------------------------------------------
param([string]$ConfigFile="Placeholder.Config", [string]$BuildAgentDefaultWorkingDirectory="", [int]$IsDebug=0) 

#------------------------------------------------------------------
#Get the DB config values from the file
#------------------------------------------------------------------
Get-Content $ConfigFile | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }


If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nConfig Settings`n------------------------------------------------------------------`n"
    $str = $h  | Out-String
    Write-Host $str  
}

[string] $DatabaseServerName = $h.Item("DatabaseServerName")
[string] $DatabaseName = $h.Item("DatabaseName")
[string] $DataBaseBackupFilePath = $BuildAgentDefaultWorkingDirectory + $h.Item("DataBaseBackupFilePath")
[string] $DataBaseBackupFileName = $h.Item("DataBaseBackupFileName")
[string] $FullDataBaseBackupPath = $DataBaseBackupFilePath+ "\" + $DataBaseBackupFileName
[string] $MigrationScriptFolderPath = $BuildAgentDefaultWorkingDirectory + $h.Item("MigrationScriptFolderPath")
[string] $ApplicationDataBaseArtifactsFolderPath = $BuildAgentDefaultWorkingDirectory + $h.Item("ApplicationDataBaseArtifactsFolderPath")
[string] $ApplicationDataBaseArtifactsCleanupFilePath = $BuildAgentDefaultWorkingDirectory + $h.Item("ApplicationDataBaseArtifactsCleanupFilePath")
[string] $DataBaseRestore = $h.Item("DataBaseRestore")


if($DataBaseRestore  -eq "True")
{
            #------------------------------------------------------------------
            #Create DB if it does not exist
            #------------------------------------------------------------------
            If ($isDebug -eq 1)
            {
             Write-Host "`n------------------------------------------------------------------`nCreating Database if it does not exist`n------------------------------------------------------------------`n"
            }

            sqlcmd -E -S "$DatabaseServerName" -Q "
		            USE MASTER; 
		            IF NOT EXISTS (SELECT * from sys.databases WHERE name = '$DatabaseName') 
		            BEGIN
			            PRINT 'Creating Database $DatabaseName'
			            CREATE DATABASE $DatabaseName
		            END
		            ELSE
		            BEGIN
			            PRINT 'Skipping Creating Database $DatabaseName'
		            END"		

            #------------------------------------------------------------------
            #Set DB to Single User mode
            #Restore DB from Bak
            #Reset DB back to Multi User mode
            #------------------------------------------------------------------
            If ($isDebug -eq 1)
            {
             Write-Host "`n------------------------------------------------------------------`nSet DB to Single User Mode`n------------------------------------------------------------------`n"
            }
            sqlcmd -E -S "$DatabaseServerName" -Q "
		            USE MASTER; 
                            ALTER DATABASE $DatabaseName
		            SET SINGLE_USER
		            WITH ROLLBACK IMMEDIATE;"

            #------------------------------------------------------------------
            #Restore DB from Bak
            #------------------------------------------------------------------
            If ($isDebug -eq 1)
            {
             Write-Host "`n------------------------------------------------------------------`nRestore DB`n------------------------------------------------------------------`n"
            }
            sqlcmd -E -S "$DatabaseServerName" -Q "
		            RESTORE DATABASE $DatabaseName
		            FROM DISK = '$FullDataBaseBackupPath'
		            WITH NOUNLOAD, REPLACE, STATS = 10;"


            #------------------------------------------------------------------
            #Reset DB back to Multi User mode
            #------------------------------------------------------------------
            If ($isDebug -eq 1)
            {
             Write-Host "`n------------------------------------------------------------------`nSet DB to Multi User Mode`n------------------------------------------------------------------`n"
            }
            sqlcmd -E -S "$DatabaseServerName" -Q "
	    	            ALTER DATABASE $DatabaseName
		            SET MULTI_USER;"

            #------------------------------------------------------------------
            #Fix Orphaned Users
            #------------------------------------------------------------------
            If ($isDebug -eq 1)
            {
             Write-Host "`n------------------------------------------------------------------`nFix Orphaned SQL Users`n------------------------------------------------------------------`n"
            }
            sqlcmd -E -S "$DatabaseServerName" -Q "
		            USE $DatabaseName

		            DECLARE @UserName nvarchar(255)
		            DECLARE @cmd      VARCHAR(100)
		            DECLARE orphanuser_cur cursor for
		            SELECT UserName = name
		            FROM sysusers
		            WHERE issqluser = 1 and (sid is not null and sid <> 0x0) and suser_sname(sid) is null
		            ORDER BY name
 
		            OPEN orphanuser_cur
		            FETCH NEXT FROM orphanuser_cur INTO @UserName
 
		            WHILE (@@fetch_status = 0)
		            BEGIN
 
 			            IF EXISTS ( SELECT 1 FROM master..syslogins WHERE name = @UserName )
			            BEGIN
				            SET @cmd = 'ALTER USER [' + @UserName + '] WITH LOGIN = [' + @UserName + ']'
		        	            PRINT @UserName + ' user name being resynced'
				            -- To be deprecated soon - EXEC sp_change_users_login 'Update_one', @UserName, @UserName
	    		                    EXECUTE(@cmd)
        	                    END  
    			            FETCH NEXT FROM orphanuser_cur INTO @UserName    
		            END 
		            CLOSE orphanuser_cur
		            DEALLOCATE orphanuser_cur"

            #------------------------------------------------------------------
            #Shrink DB
            #------------------------------------------------------------------
            If ($isDebug -eq 1)
            {
             Write-Host "`n------------------------------------------------------------------`nShrink DB`n------------------------------------------------------------------`n"
            }
            sqlcmd -E -S "$DatabaseServerName" -Q "
	            USE $DatabaseName   
	            GO
	            DBCC SHRINKDATABASE ($DatabaseName, 0) WITH NO_INFOMSGS
	            GO"

}
else # $DataBaseRestore  = False
{
	    If ($isDebug -eq 1)
	    {
	        Write-Host "Skipped Database Retore steps.`n"
	    }
}

#------------------------------------------------------------------
#Schema Migration
#------------------------------------------------------------------
If ($isDebug -eq 1)
{
    Write-Host "`n---------------------------------------------------------------------------------------------`nSchema Migration Start`n---------------------------------------------------------------------------------------------`n"
    Write-Host "`n------------------------------------------------------------------`nExtract Current Schema Migration Number from SchemaMigrations of Database`n"
}

try
{
    $MaxSchemaMigrationNumberAppliedRow = invoke-sqlcmd -ServerInstance "$DatabaseServerName" -DataBase "$DatabaseName"  -Query "SELECT ISNULL(MAX(SchemaMigrationNumber), 0) AS SchemaMigrationNumber  FROM SchemaMigrations"
    $CurrentSchemaMigrationNumber = $MaxSchemaMigrationNumberAppliedRow.SchemaMigrationNumber
    Write-Host "MaxSchemaMigrationNumberApplied set = " $CurrentSchemaMigrationNumber "`n------------------------------------------------------------------`n"
}
catch
{
    # OK to continue if the SchemaMigrations table not found. It will get created as part of apllying the schema migrations below
}


#------------------------------------------------------------------
#Extract Files From SchemaMigrations folder where file prefix greater than MaxSchemaMigrationNumberApplied
#------------------------------------------------------------------
$sqlFileList = Get-ChildItem $MigrationScriptFolderPath  -Filter "*.sql" |? {[Int][System.Text.RegularExpressions.Regex]::match($_.name,"^[^_]*").Value -gt $CurrentSchemaMigrationNumber }

If ($isDebug -eq 1)
{
     Write-Host "`n------------------------------------------------------------------`nSchema Migration list that are applicable - Files with Schema migration number > $CurrentSchemaMigrationNumber`n"
     $str = $sqlFileList | Out-String
     Write-Host $str 
     Write-Host Total Count of applicable Schema Migrations: $sqlFileList.Count
     If ( $sqlFileList.Count -gt 0)
     {
 	        $NewMaxSchemaMigrationNumber = [Int][System.Text.RegularExpressions.Regex]::match($sqlFileList[$sqlFileList.Count -1],"^[^_]*").Value  
	        Write-Host New Max SchemaMigrationNumber: $NewMaxSchemaMigrationNumber 
     }
     Write-Host   "------------------------------------------------------------------`n"
     Write-Host "`n------------------------------------------------------------------`nStarting applicable Schema Migration`n"
}

#------------------------------------------------------------------
#If no Schema Migration files found 
#------------------------------------------------------------------
if ($sqlFileList.Count -eq 0)
{
	If ($isDebug -eq 1)
	{
	    Write-Host No Schema Migration files found. Skipping Schema Migration section
	}
}
else
{
	#------------------------------------------------------------------
	#Apply the applicable SchemaMigrations to DB
	#------------------------------------------------------------------
	for ($i=0; $i -lt $sqlFileList.Count; $i++) {
		$sqlfileName = $sqlFileList[$i].FullName
		If ($isDebug -eq 1)
		{
	 		Write-Host "Migrating schema: $sqlfileName`n"	
		}    

	    	Invoke-sqlcmd -ServerInstance $DatabaseServerName -Database $DatabaseName -InputFile $sqlfileName
	}
	If ($isDebug -eq 1)
	{
	    Write-Host "Completed applicable Schema Migration`n------------------------------------------------------------------`n"
	    Write-Host "`n------------------------------------------------------------------`nStarting Updating the new Schema Migration Number in Database to $NewMaxSchemaMigrationNumber`n"
	}
	#------------------------------------------------------------------
	#Update the SchemaMigrationNumber in SchemaMigrations in DB
	#------------------------------------------------------------------
	Invoke-Sqlcmd  -ServerInstance $DatabaseServerName -Database $DatabaseName -Query "
				DELETE FROM SchemaMigrations; 
				INSERT INTO SchemaMigrations (SchemaMigrationNumber) VALUES ($NewMaxSchemaMigrationNumber)"
	
	If ($isDebug -eq 1)
	{
	    Write-Host "Completed Updating the new Schema Migration Number in Database`n------------------------------------------------------------------`n"
	}
}

If ($isDebug -eq 1)
{
    Write-Host "`n---------------------------------------------------------------------------------------------`nSchema Migration End`n---------------------------------------------------------------------------------------------`n"
}

If ($isDebug -eq 1)
{
    Write-Host "`n---------------------------------------------------------------------------------------------`nDB Artifacts Start`n---------------------------------------------------------------------------------------------`n"
}

#------------------------------------------------------------------
#Clear All Db Artifacts
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
    Write-Host "`n`n------------------------------------------------------------------`nStarting clearing DB Artifacts in the Database using script $ApplicationDataBaseArtifactsCleanupFilePath `n"
}

Invoke-Sqlcmd  -ServerInstance $DatabaseServerName -Database $DatabaseName -InputFile $ApplicationDataBaseArtifactsCleanupFilePath
	

If ($isDebug -eq 1)
{
    Write-Host "Completed clearing DB Artificats in the Database`n------------------------------------------------------------------`n"
}


#------------------------------------------------------------------
#Apply Constants
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
  Write-Host "`n------------------------------------------------------------------`nStarting re-applying Constants in the Database `n"
}

$constantSqlFileList = Get-ChildItem $ApplicationDataBaseArtifactsFolderPath\Constants -Filter "*.sql" 

if ($constantSqlFileList.Count -eq 0)
{
	If ($isDebug -eq 1)
	{
	  Write-Host `nNo Constant Artifacts  found
	}
}
else
{
	for ($i=0; $i -lt $constantSqlFileList.Count; $i++) {
		$constSqlfileName = $constantSqlFileList[$i].FullName
		If ($isDebug -eq 1)
		{
	 		Write-Host "`nApplying: $constSqlfileName"	
		}    

	    	Invoke-sqlcmd -ServerInstance $DatabaseServerName -Database $DatabaseName -InputFile $constSqlfileName
	}
}
If ($isDebug -eq 1)
{
    Write-Host "`n`nCompleted re-applying Constants in the Database`n------------------------------------------------------------------`n"
}

#------------------------------------------------------------------
#Apply Views
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nStarting re-applying Views in the Database `n"
}

$viewSqlFileList = Get-ChildItem $ApplicationDataBaseArtifactsFolderPath\Views -Filter "*.sql"

if ($viewSqlFileList.Count -eq 0)
{
	If ($isDebug -eq 1)
	{
	     Write-Host `nNo View Artifacts  found
	}
}
else
{
	for ($i=0; $i -lt $viewSqlFileList.Count; $i++) {
		$vwSqlfileName = $viewSqlFileList[$i].FullName
		If ($isDebug -eq 1)
		{
	 		Write-Host "`nApplying: $vwSqlfileName"	
		}    
	   	Invoke-sqlcmd -ServerInstance $DatabaseServerName -Database $DatabaseName -InputFile $vwSqlfileName
	}
}

If ($isDebug -eq 1)
{
    Write-Host "`n`nCompleted re-applying Views in the Database`n------------------------------------------------------------------`n"
}

#------------------------------------------------------------------
#Apply Functions
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nStarting re-applying Functions in the Database `n"
}

$functionSqlFileList = Get-ChildItem $ApplicationDataBaseArtifactsFolderPath\Functions -Filter "*.sql" 

if ($functionSqlFileList.Count -eq 0)
{
	If ($isDebug -eq 1)
	{
	    Write-Host `nNo Function Artifacts  found
	}
}
else
{
	for ($i=0; $i -lt $functionSqlFileList.Count; $i++) {
		$funcSqlfileName = $functionSqlFileList[$i].FullName
		If ($isDebug -eq 1)
		{
	 		Write-Host "`nApplying: $funcSqlfileName"	
		}    
    	Invoke-sqlcmd -ServerInstance $DatabaseServerName -Database $DatabaseName -InputFile $funcSqlfileName
	}	
}
If ($isDebug -eq 1)
{
    Write-Host "`n`nCompleted re-applying Functions in the Database`n------------------------------------------------------------------`n"
}

#------------------------------------------------------------------
#Apply Procedures
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nStarting re-applying Procedures in the Database `n"
}

$procedureSqlFileList = Get-ChildItem $ApplicationDataBaseArtifactsFolderPath\Procedures -Filter "*.sql"

if ($procedureSqlFileList.Count -eq 0)
{
	If ($isDebug -eq 1)
	{
	    Write-Host `nNo Procedure Artifacts  found
	}
}
else
{
	for ($i=0; $i -lt $procedureSqlFileList.Count; $i++) {
		$procSqlfileName = $procedureSqlFileList[$i].FullName
		If ($isDebug -eq 1)
		{
	 		Write-Host "`nApplying: $procSqlfileName"	
		}    
    	Invoke-sqlcmd -ServerInstance $DatabaseServerName -Database $DatabaseName -InputFile $procSqlfileName
	}	
}
If ($isDebug -eq 1)
{
    Write-Host "`n`nCompleted re-applying Procedures in the Database`n------------------------------------------------------------------`n"
}

#------------------------------------------------------------------
#Execute UspCreateAllStaticIdNameCONSTFunctions - dynamically generates constants for the Static Table entries.. Example RefStatus
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nExecute UspCreateAllStaticIdNameCONSTFunctions to dynamically generates constants for the Static Table entries.. Example RefStatus `n"
}

sqlcmd -E -S "$DatabaseServerName" -Q "USE $DatabaseName EXEC UspCreateAllStaticIdNameCONSTFunctions"

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`n"
}

If ($isDebug -eq 1)
{
    Write-Host "`n---------------------------------------------------------------------------------------------`nDB Artifacts End`n---------------------------------------------------------------------------------------------`n"
}
