using System.Collections.Generic;
using System.Linq;
using HCA.HCAApp.DAO;
using HCA.HCAApp.Domain;
using NHibernate;
using NHibernate.Criterion;
using NHibernate.Impl;
using HCA.HCAApp.Dao;

namespace HCA.HCAApp.Dao
{
    public class MealGroupDao : HibernateDao<MealGroup>{
        
        public IList<MealGroup> GetAllMealGroups() {
            ISession session = Session();
            string sql = "select * from mealgroups order by MealGroup";
            List<MealGroup> groups =
                session.CreateSQLQuery(sql)
                .AddEntity(typeof(MealGroup))
                .List<MealGroup>()
                .ToList<MealGroup>();
            return groups;
        }



    }
}
