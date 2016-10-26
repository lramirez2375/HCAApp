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
    public class PurchaseDao : HibernateDao<Purchase>{

        public IList<Purchase> GetAllPurchaseStudents(int studentId) {
            ISession session = Session();
            string sql = 
                            "select p.* " +
                            "from dbo.Purchases p " +
	                        "    inner join Meals m on p.MealId=m.Id " +
	                        "    inner join Student s on s.Id=p.StudentId " +
                            "where s.Id=" + studentId;
            List<Purchase> purchases =
                session.CreateSQLQuery(sql)
                .AddEntity(typeof(Purchase))
                .List<Purchase>()
                .ToList<Purchase>();
            return purchases;
        }

        

    }
}
