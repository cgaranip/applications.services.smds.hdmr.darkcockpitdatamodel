IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_ApplicationRole]'))
DROP VIEW [dbo].[v_ApplicationRole]
GO

CREATE VIEW [dbo].[v_ApplicationRole]
/*TEST HARNESS ----------

 DECLARE @VersionId INT = 33
 SELECT * FROM [dbo].[v_ApplicationRole] 
 
----TEST HARNESS ---- */
AS
SELECT [RoleID]
      ,[RoleName]
      ,[RoleDescription]
      ,[RootTopic]   
  FROM [dbo].[ApplicationRole] (nolock)
GO

GRANT SELECT on [dbo].[v_ApplicationRole] to PUBLIC
GO
