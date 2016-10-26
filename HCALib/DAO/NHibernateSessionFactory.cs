using System;
using System.Runtime.Remoting.Messaging;
using System.Web;
using NHibernate;
using NHibernate.Cfg;

namespace HCA.HCAApp.Dao{
    public static class NHibernateSessionFactory    {
        private static readonly object syncRoot = new Object();
        private static volatile ISessionFactory instance;

        private static ISessionFactory GetFactory()
        {
            if (instance == null)
            {
                lock (syncRoot)
                {
                    if (instance == null)
                    {
                        Configuration cfg = new Configuration();
                        cfg.Configure();
                        cfg.AddAssembly("HCA.HCAApp.HCALib");
                        instance = cfg.BuildSessionFactory();
                    }
                }
            }

            return instance;
        }

        public static ISession Session()
        {
            bool web = false;
            bool app = false;
            ISession session;
            if (HttpContext.Current != null)
            {
                session = (ISession)HttpContext.Current.Items["session"];
                web = true;
            }
            else
            {
                session = (ISession)CallContext.GetData("session");
                app = true;
            }
            if (session == null)
            {
                session = GetFactory().OpenSession();
                if (web)
                {
                    HttpContext.Current.Items["session"] = session;
                }
                else if (app)
                {
                    CallContext.SetData("session", session);
                }
            }
            return session;
        }

        public static void ClearAllSessions()
        {
            ISession session = (ISession)HttpContext.Current.Items["session"];
            if (session != null)
            {
                session.Dispose();
                HttpContext.Current.Items["session"] = null;
            }
        }
    }
}