using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DarkCockpitDAL
{
    public interface IRepository<TDbContext>
    {
        TDbContext GetDbContext();
    }
}
