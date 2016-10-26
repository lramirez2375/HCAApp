using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace HCA.HCAApp.Domain
{
    public class MealGroup{


        public MealGroup() { 
        }

        public virtual int Id { get; set; }
        public virtual string MealGroupDescription { get; set; }
    }
}
