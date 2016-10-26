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
    public class ClassDao : HibernateDao<StudentClass>{

        public IList<Student> GetAllStudentsByClass(int classId) {
            ISession session = Session();
            string sql = 
                            "select s.* " +
                            "from Student s " +
	                        "    inner join classes c on c.Id=s.ClassId " +
                            "where s.ClassId=" + classId;
            List<Student> students =
                session.CreateSQLQuery(sql)
                .AddEntity(typeof(Student))
                .List<Student>()
                .ToList<Student>();
            return students;
        }



    }
}
