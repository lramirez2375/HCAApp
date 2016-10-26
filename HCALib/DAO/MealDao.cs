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
    public class MealDao : HibernateDao<Meal>{

        public IList<Meal> GetAllMealsByGroupByDate(int groupId, string date) {
            ISession session = Session();
            string sql = 
                            "select m.*  " +
                            "from Meals m " +
	                        "    inner join meal_dates d on d.mealId=m.Id " +
                            "where m.MealGroupId=" + groupId + " and DATEDIFF(d,d.dateavailable,'" + date + "')=0";
            List<Meal> meals =
                session.CreateSQLQuery(sql)
                .AddEntity(typeof(Meal))
                .List<Meal>()
                .ToList<Meal>();
            return meals;
        }



    }
}
