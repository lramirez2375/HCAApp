using System.Collections.Generic;
using System.Linq;
using HCA.HCAApp.Dao;
using HCA.HCAApp.Domain;

namespace HCA.HCAApp.Managers
{
    public class MealGroupManager {
        private readonly MealGroupDao dao = new MealGroupDao();

        public List<MealGroup> GetAllMealGroups() {
            return dao.GetAllMealGroups().ToList();
        }
    }
}
