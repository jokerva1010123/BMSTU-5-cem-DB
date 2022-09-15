using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void FindNames(string name)
    {
        using (SqlConnection connect = new SqlConnection("context connection = true"))
        {
            SqlCommand cmd = new SqlCommand("select @name as 'name', count(clid) as 'count'," +
                " avg(clage) as 'age' from client where clname = @name", connect);
            cmd.Parameters.AddWithValue("@name", name);
            connect.Open();

            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }
}
