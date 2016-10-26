using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace HCA.HCAApp.Domain
{
    public class Purchase{


        public Purchase() { 
        }

        public virtual int Id { get; set; }
        public virtual DateTime PurchaseDate { get; set; }
        public virtual decimal PurchasePrice { get; set; }
        public virtual Meal Meal{ get; set; }
        public virtual Student Student{ get; set; }

    }
}
