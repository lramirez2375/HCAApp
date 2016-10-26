using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace HCA.HCAApp.Domain
{
    public class Student{
        

        public Student() { 
        }

        public virtual int Id { get; set; }
        public virtual string Name { get; set; }
        public virtual string Parent { get; set; }
        public virtual string Email { get; set; }
        public virtual bool Reduced { get; set; }
        public virtual int ClassId { get; set; }
    }
}
