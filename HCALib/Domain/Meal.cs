using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace HCA.HCAApp.Domain
{
    public class Meal{


        public Meal() { 
        }

        public virtual int Id { get; set; }
        public virtual string MealDescription { get; set; }
        public virtual decimal Price { get; set; }
        public virtual string Image { get; set; }
        public virtual MealGroup MealGroup { get; set; }

    }
}
