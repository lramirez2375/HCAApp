﻿using System;
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
    /// Summary description for StudentAdminPageWS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class StudentAdminPageWS : System.Web.Services.WebService {

        private readonly StudentAdminPageController controller = new StudentAdminPageController();

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public StudentForm GetStudentData(int id) {
            return controller.GetStudentData(id);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<PurchaseForm> GetStudentPurchases(int id) {
            return controller.GetStudentPurchases(id);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<StudentTransferForm> GetStudentMoneyTransfers(int id) {
            return controller.GetStudentTransfers(id);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<StudentTransferForm> AddEditCheckToStudent(int id, int transferId,string checkNo, decimal checkAmount) {
            controller.AddCheckToStudent(id, transferId, checkNo, checkAmount);
            return controller.GetStudentTransfers(id);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<StudentTransferForm> DeleteCheckFromStudent(int id, int transferId) {
            controller.DeleteCheckFromStudent(transferId);
            return controller.GetStudentTransfers(id);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void EditParent(int id, string parentName, string parentEmail) {
            controller.EditParent(id, parentName, parentEmail);
        }
    }
}
