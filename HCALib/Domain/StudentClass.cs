using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace HCA.HCAApp.Domain
{
    public class StudentClass{


        public StudentClass() { 
        }

        public virtual int Id { get; set; }
        public virtual string Class { get; set; }
    }
}
