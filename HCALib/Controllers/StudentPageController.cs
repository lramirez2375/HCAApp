using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HCA.HCAApp.Domain;
using HCA.HCAApp.Managers;

namespace HCA.HCAApp.Controllers
{
    public class StudentPageController {

        private readonly MealGroupManager groupManager = new MealGroupManager();
        private readonly MealManager mealManager = new MealManager();
        private readonly StudentClassManager classManager = new StudentClassManager();
        private readonly PurchaseManager purchaseManager=new PurchaseManager();

        public List<MealGroup> GetAllMealGroups() {
            return groupManager.GetAllMealGroups();
        }

        public List<Meal> GetAllMealsByGroupByDate(int groupId, string date) {
            return mealManager.GetAllMealsByGroupByDate(groupId, date);
        }

        public List<Student> GetAllStudentsByClass(int classId) {
            return classManager.GetAllStudentsByClass(classId).ToList();
        }

        public List<StudentClass> GetAllStudentClasses() {
            return classManager.GetAllStudentClasses();
        }

        public void SaveMeal(int studentId, int[] meals) {
            purchaseManager.SaveMeal(studentId, meals);
        }
        
    }
}
