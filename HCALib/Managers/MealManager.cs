using System.Collections.Generic;
using System.Linq;
using HCA.HCAApp.Dao;
using HCA.HCAApp.Domain;

namespace HCA.HCAApp.Managers
{
    public class MealManager {
        private readonly MealDao dao = new MealDao();

        public List<Meal> GetAllMealsByGroupByDate(int groupId, string date) {
            return dao.GetAllMealsByGroupByDate(groupId, date).ToList();
        }

        
    }
}
