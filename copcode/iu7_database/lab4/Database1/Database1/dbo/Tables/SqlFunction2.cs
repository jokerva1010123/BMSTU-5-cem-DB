using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Collections;
using System.Collections.Generic;

public partial class UserDefinedFunctions
{
    [SqlFunction(FillRowMethodName = "FillRow",
        TableDefinition = "GId int, GYear int",
        DataAccess = DataAccessKind.Read, SystemDataAccess = SystemDataAccessKind.Read)]
    public static IEnumerable ListOfGame(SqlString year)
    {
        using (SqlConnection connect = new SqlConnection("context connection = true"))
        {
            List<NameRow> list = new List<NameRow>();
            SqlCommand cmd = new SqlCommand(
                "select GId, GYear from Game where GYear > @year", connect);
            cmd.Parameters.AddWithValue("@year", year);
            connect.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                list.Add(new NameRow(reader.GetInt32(0), reader.GetInt32(1)));
            }
            connect.Close();
            return list;
        }
    }
    public static void FillRow(object row, out int gid, out int gyear)
    {
        // азбор строки на столбцы
        gid = ((NameRow)row).gid;
        gyear = ((NameRow)row).gyear;
    }
}

public class NameRow
{
    public Int32 gid;
    public Int32 gyear;
    public NameRow(Int32 c, Int32 i)
    {
        gid = c;
        gyear = i;
    }
}
