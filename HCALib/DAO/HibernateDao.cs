using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using HCA.HCAApp.Dao;
using NHibernate;
using NHibernate.Criterion;
using Iesi.Collections;
using NHibernate.Mapping;
using Set = Iesi.Collections.Set;

namespace HCA.HCAApp.DAO
{
    public class HibernateDao<T>
    {
        public virtual void Update(T obj)
        {
            Session().Update(obj);
            Session().Flush();
            
        }

        public void Delete(T obj)
        {
            ISession session = Session();
            try {
                session.Delete(obj);
                session.Flush();
            } catch (Exception e) {
                throw;
            }
            
        }

        public virtual void Create(T obj)
        {
            Session().Save(obj);
        }

        public virtual Object AddNew(T obj) {
            try {
                return Session().Save(obj);
            } catch (Exception) {
                
                throw;
            }
        }

        public Object FindById(Type type, Object id)
        {
            return Session().Get(type, id);
        }

        public virtual T FindById(Object id)
        {
            return (T)Session().Get(typeof(T), id);
        }

        public virtual T GetById(Object id)
        {
            return (T)Session().Get(typeof(T), id);
        }

        public IList<T> GetByNameInCompany(long companyId, string name, bool filterObsolete)
        {
            ICriteria crt = Session().CreateCriteria(typeof(T))
                .Add(Restrictions.Eq("CompanyId", companyId))
                .Add(Restrictions.Eq("Name", name));
            if (filterObsolete)
            {
                crt.Add(Restrictions.Eq("Obsolete", false));
            }
            return crt.List<T>();
        }

        public IList<T> GetByCompany(long companyId)
        {
            ICriteria crt = Session().CreateCriteria(typeof(T))
                .Add(Restrictions.Eq("CompanyId", companyId));
            return crt.List<T>();
        }

        public T GetUniqueByName(string name)
        {
            ICriteria crt = Session().CreateCriteria(typeof(T))
                .Add(Restrictions.Eq("Name", name));
            return crt.UniqueResult<T>();
        }

        public void DeleteById(Object id)
        {
            T obj = FindById(id);
            if (obj != null)
            {
                Delete(obj);
                Session().Flush();
            }
        }

        public void CreateOrUpdate(T obj)
        {
            
            ISession session = Session();
            
            try {
                session.SaveOrUpdate(obj);
                session.Flush();

            } catch (Exception) {
                
                throw;
            }
        }

        public IList List(IQuery query)
        {
            IList result = query.List();
            return result ?? new ArrayList();
        }

        public IQuery GetNamedQuery(string name)
        {
            return Session().GetNamedQuery(name);
        }

        public ISession Session()
        {
            return NHibernateSessionFactory.Session();
        }

        public void EvictAll(IList<T> items)
        {
            foreach (T item in items)
            {
                Session().Evict(item);
            }
        }

        public void Evict(T item)
        {
            Session().Evict(item);
        }

        public IDbConnection Connection()
        {
            return Session().Connection;
        }

        public IDbCommand CreateCommand(IDbConnection connection)
        {
            ISession session = Session();
            IDbCommand command = connection.CreateCommand();
            if (session.Transaction != null && session.Transaction.IsActive)
            {
                session.Transaction.Enlist(command);
            }
            return command;
        }

        // "if you fetch a collection, hibernate doesn't return
        // a disting result list"  - hibernate in action
        public ArrayList Distinct(IList list)
        {
            ListSet set = new ListSet(list);
            return new ArrayList(set);
        }

        // materializes a lazy association
        public void Materialize(object o)
        {
            if (!NHibernateUtil.IsInitialized(o))
            {
                NHibernateUtil.Initialize(o);
            }
        }

        protected IList RemoveDuplicateItems(IList queryResult)
        {
            Set set = new ListSet();
            set.AddAll(queryResult);
            IList result = new ArrayList();
            foreach (object obj in set)
            {
                result.Add(obj);
            }
            return result;
        }

        public int ExecuteSqlNoResult(string sql)
        {
            int value;
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                value = cmd.ExecuteNonQuery();
            }
            return value;
        }

        protected int ExecuteSqlNoResult(string sql, int? timeOutSeconds)
        {
            int value;
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                if (timeOutSeconds.HasValue)
                {
                    cmd.CommandTimeout = timeOutSeconds.Value;
                }
                cmd.CommandText = sql;
                value = cmd.ExecuteNonQuery();
            }
            return value;
        }

        protected long ExecuteSqlLongScalar(string sql)
        {
            Object value;
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                value = cmd.ExecuteScalar();
            }
            return value != null ? Convert.ToInt64(value) : -1;
        }

        protected int ExecuteSqlIntScalar(string sql)
        {
            object scalar;
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                scalar = cmd.ExecuteScalar();
            }
            if (scalar == null)
            {
                return 0;
            }
            return (int)scalar;
        }

        protected double ExecuteSqlDoubleScalar(string sql)
        {
            object scalar;
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                scalar = cmd.ExecuteScalar();
            }
            if (scalar == null)
            {
                return 0.0;
            }
            double ret = 0;
            Double.TryParse(scalar.ToString(), out ret);
            return ret;
        }

        protected string ExecuteSqlStringScalar(string sql)
        {
            string value="";
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                object obj=cmd.ExecuteScalar();
                if (!(obj is DBNull)){
                    value = (string)obj;
                }
            }
            return value;
        }

        protected bool ExecuteSqlBoolScalar(string sql)
        {
            Object value;
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                value = cmd.ExecuteScalar();
            }
            bool ret;
            if (value == null)
            {
                return false;
            }
            if (!Boolean.TryParse(value.ToString(), out ret))
            {
                return false;
            }
            return ret;
        }

        public IDataReader GetReaderForQuery(string sql, IDbConnection connection)
        {
            return GetReaderForQuery(sql, null, connection);
        }

        public IDataReader GetReaderForQuery(string sql, int? timeOutSeconds, IDbConnection connection)
        {
            IDataReader reader;
            sql = sql.Replace('\t', ' ');
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                if (timeOutSeconds.HasValue)
                {
                    cmd.CommandTimeout = timeOutSeconds.Value;
                }
                reader = cmd.ExecuteReader();
            }
            return reader;
        }

        public DataTable GetDataTableForQuery(string sql, int? timeOutSeconds)
        {
            DataTable dataTable;
            sql = sql.Replace('\t', ' ');
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = sql;
                cmd.CommandTimeout = 50;
                //if (timeOutSeconds.HasValue)
                //{
                //    cmd.CommandTimeout = timeOutSeconds.Value;
                //}

                dataTable = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter();
                
                try {
                    adapter.SelectCommand = (SqlCommand)cmd;
                    adapter.Fill(dataTable);
                } catch (Exception) {
                    
                    throw;
                }
            }
            return dataTable;
        }

        public List<int> GetIntListForQuery(string sql, int? timeOutSeconds)
        {
            DataTable dataTable = GetDataTableForQuery(sql, timeOutSeconds);
            List<int> ret = new List<int>(dataTable.Rows.Count);
            foreach (DataRow row in dataTable.Rows)
            {
                string d = row[0].ToString();
                int n;
                if (Int32.TryParse(d, out n))
                {
                    ret.Add(n);
                }
            }
            return ret;
        }

        public virtual IList<T> GetAll()
        {
            ICriteria crt = Session()
                .CreateCriteria(typeof(T));
            IList<T> all = crt.List<T>();
            return all;
        }

        public T GetFirst()
        {
            ICriteria crt = Session()
                .CreateCriteria(typeof(T))
                .AddOrder(Order.Asc("Id"))
                .SetMaxResults(1);
            return crt.UniqueResult<T>();
        }

        public DataTable GetDataTableForSp(string spName, Dictionary<string, object> parameters, int? timeOutSeconds)
        {
            DataTable dataTable;
            spName = spName.Replace('\t', ' ');
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                {
                    foreach (KeyValuePair<string, object> parameter in parameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(parameter.Key, parameter.Value));
                    }
                }
                if (timeOutSeconds.HasValue)
                {
                    cmd.CommandTimeout = timeOutSeconds.Value;
                }
                dataTable = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = (SqlCommand)cmd;
                adapter.Fill(dataTable);
            }
            return dataTable;
        }

        public int ExecuteSp(string spName, Dictionary<string, object> parameters, int? timeOutSeconds)
        {
            int value;
            spName = spName.Replace('\t', ' ');
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                {
                    foreach (KeyValuePair<string, object> parameter in parameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(parameter.Key, parameter.Value));
                    }
                }
                if (timeOutSeconds.HasValue)
                {
                    cmd.CommandTimeout = timeOutSeconds.Value;
                }
                value = cmd.ExecuteNonQuery();
            }
            return value;
        }

        private object ExecuteSpScalar(string spName, Dictionary<string, object> parameters, int? timeOutSeconds)
        {
            object value;
            spName = spName.Replace('\t', ' ');
            IDbConnection connection = Session().Connection;
            using (IDbCommand cmd = CreateCommand(connection))
            {
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                {
                    foreach (KeyValuePair<string, object> parameter in parameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(parameter.Key, parameter.Value));
                    }
                }
                if (timeOutSeconds.HasValue)
                {
                    cmd.CommandTimeout = timeOutSeconds.Value;
                }
                value = cmd.ExecuteScalar();
            }
            return value;
        }

        public int ExecuteSpIntScalar(string spName, Dictionary<string, object> parameters, int? timeOutSeconds)
        {
            object scalar = ExecuteSpScalar(spName, parameters, timeOutSeconds);
            if (scalar == null || scalar == DBNull.Value)
            {
                return 0;
            }
            return (int)scalar;
        }

        public long ExecuteSpLongScalar(string spName, Dictionary<string, object> parameters, int? timeOutSeconds)
        {
            object scalar = ExecuteSpScalar(spName, parameters, timeOutSeconds);
            if (scalar == null || scalar == DBNull.Value)
            {
                return 0;
            }
            return (long)scalar;
        }

        public DateTime? ExecuteSpDateTimeScalar(string spName, Dictionary<string, object> parameters, int? timeOutSeconds)
        {
            object scalar = ExecuteSpScalar(spName, parameters, timeOutSeconds);
            if (scalar == null || scalar == DBNull.Value)
            {
                return null;
            }
            return (DateTime)scalar;
        }

        public int DeleteAll(string tableName)
        {
            return ExecuteSqlIntScalar("delete from " + tableName);
        }

        protected static bool VerifyDBParam(string s)
        {
            return ( !String.IsNullOrEmpty(s) ) && ( !s.Contains("'") && !s.Contains(";") );
        }
    }
}