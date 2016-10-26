using System.Collections.Generic;
using System.Linq;
using HCA.HCAApp.Dao;
using HCA.HCAApp.Domain;

namespace HCA.HCAApp.Managers
{
    public class StudentClassManager{
        private readonly ClassDao dao = new ClassDao();

        public IList<Student> GetAllStudentsByClass(int classId) {
            return dao.GetAllStudentsByClass(classId);
        }

        public List<StudentClass> GetAllStudentClasses() {
            return dao.GetAll().ToList();
        }
    }
}
