IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'TimeZoneInfo'
          AND Object_ID = Object_ID(N'WorkflowScheduleDefiniton'))
BEGIN
    Alter table dbo.WorkflowScheduleDefiniton ADD TimeZoneInfo VARCHAR(255)
END

GO
