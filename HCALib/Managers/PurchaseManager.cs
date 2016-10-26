using System;
using System.Collections.Generic;
using System.Linq;
using HCA.HCAApp.Dao;
using HCA.HCAApp.Domain;

namespace HCA.HCAApp.Managers
{
    public class PurchaseManager {
        private readonly PurchaseDao  pDao= new PurchaseDao();
        private readonly StudentDao studentDao = new StudentDao();
        private readonly MealDao mealDao = new MealDao();

        public IList<Purchase> GetAllPurchaseStudents(int studentId) {
            return pDao.GetAllPurchaseStudents(studentId);
        }

        public void SaveMeal(int studentId, int[] meals) {
            Student student = studentDao.GetById(studentId);
            foreach(int m in meals) {
                Purchase purchase = new Purchase();
                purchase.Id = 0;
                purchase.Student = student;
                Meal meal=mealDao.GetById(m);
                purchase.Meal = meal;
                purchase.PurchaseDate = DateTime.Now;
                purchase.PurchasePrice = meal.Price;
                pDao.CreateOrUpdate(purchase);
            }
        }
    }
}
