Below is the text to create Security database dbContext

Scaffold-DbContext "Data Source=.;Initial Catalog=SCDev;Integrated Security=SSPI;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models

**  -OutputDir Models is where your folder located for your model generation.

Below is the text to create FabMps database dbContext

Scaffold-DbContext "Data Source=azsctssqlserver.amr.corp.intel.com,1433;Initial Catalog=DarkCockpit;Integrated Security=SSPI;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir DarkCockpit.Models
