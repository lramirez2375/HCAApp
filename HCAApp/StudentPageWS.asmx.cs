using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using HCA.HCAApp.Controllers;
using HCA.HCAApp.Domain;

namespace HCA.HCAApp
{
    /// <summary>
    /// Summary description for StudentPageWS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class StudentPageWS : System.Web.Services.WebService {

        private readonly StudentPageController controller = new StudentPageController();

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<MealGroup> GetAllMealGroups() {
            return controller.GetAllMealGroups();
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<Meal> GetAllMealsByGroupByDate(int groupId, string date) {
            return controller.GetAllMealsByGroupByDate(groupId, date);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<Student> GetAllStudentsByClass(int classId) {
            return controller.GetAllStudentsByClass(classId);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<StudentClass> GetAllStudentClasses() {
            return controller.GetAllStudentClasses();
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void SaveMeal(int studentId,int[] meals) {
            controller.SaveMeal(studentId, meals);
        }
    
    }
}
