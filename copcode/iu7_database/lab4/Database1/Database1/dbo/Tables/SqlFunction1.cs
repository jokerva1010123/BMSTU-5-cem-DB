using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


public partial class SqlServerUDF
{
        [Microsoft.SqlServer.Server.SqlFunction]
        public static SqlInt32 DifferenceNum(SqlInt32 num1, SqlInt32 num2)
        {
            return (num2-num1);
        }
};
