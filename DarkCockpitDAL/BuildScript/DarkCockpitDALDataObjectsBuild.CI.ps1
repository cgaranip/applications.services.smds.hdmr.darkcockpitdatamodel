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
[string] $DatabaseModelFolder = $h.Item("DatabaseModelFolder")

#------------------------------------------------------------------
# Generate the DarkCockpit Database Objects for DarkCockpitDAL
#------------------------------------------------------------------

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nDeleting the $DatabaseName Data Models`n"
}

Del $BuildAgentDefaultWorkingDirectory\DarkCockpitDAL\DarkCockpitDAL\$DatabaseModelFolder\*.*

If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`n"
}


If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`nRegenerating the Data Models from $DatabaseServerName for $DatabaseName`n"
}

CD .\DarkCockpitDAL\packages\Microsoft.EntityFrameworkCore.Tools.2.0.1\tools\net461


./ef.exe dbcontext scaffold "Data Source=$DatabaseServerName;Initial Catalog=$DatabaseName;Integrated Security=SSPI;" Microsoft.EntityFrameworkCore.SqlServer --json --output-dir $DatabaseModelFolder --force --verbose --prefix-output --assembly $BuildAgentDefaultWorkingDirectory\DarkCockpitDAL\DarkCockipitDAL.NetFramework.ConsoleApp\bin\Release\DarkCockpitDAL.dll --startup-assembly $BuildAgentDefaultWorkingDirectory\DarkCockpitDAL\DarkCockipitDAL.NetFramework.ConsoleApp\bin\Release\DarkCockpitDAL.NetFramework.ConsoleApp.exe  --project-dir $BuildAgentDefaultWorkingDirectory\DarkCockpitDAL\DarkCockpitDAL\
If ($isDebug -eq 1)
{
    Write-Host "`n------------------------------------------------------------------`n"
}
