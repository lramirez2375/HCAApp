using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using HCA.HCAApp.Controllers;
using HCA.HCAApp.Domain;
using HCA.HCAApp.Forms;

namespace HCA.HCAApp
{
    /// <summary>
    /// Summary description for AdminPageWS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class AdminPageWS : System.Web.Services.WebService{

        private readonly AdminPageController controller=new AdminPageController();

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<StudentForm> GetAllStudents() {
            return controller.GetAllStudents();
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<Meal> GetAllMealsByGroup(int groupId) {
            return controller.GetAllMealsByGroup(groupId);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void SaveMeal(MenuForm[] menus) {
            controller.SaveMeal(menus);
        }
    }
}
