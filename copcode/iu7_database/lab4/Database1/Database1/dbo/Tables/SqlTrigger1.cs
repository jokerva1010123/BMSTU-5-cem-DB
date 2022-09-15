using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public partial class Triggers
{        
    // Введите существующую таблицу или представление для целевого объекта и раскомментируйте строку атрибута.
    // [Microsoft.SqlServer.Server.SqlTrigger (Name="SqlTrigger1", Target="Table1", Event="FOR UPDATE")]
    public static void SqlTrigger1 ()
    {
        SqlTriggerContext context = SqlContext.TriggerContext;
        if (context.TriggerAction == TriggerAction.Insert)
        {
            using (SqlConnection connect = new SqlConnection("context connection = true"))
            {
                var cmd = new SqlCommand
                {
                    Connection = connect,
                    CommandText = "select plyear from inserted",
                };
                connect.Open();
                int year = (int)cmd.ExecuteScalar();
                connect.Close();
                if (year > 2020)
                {
                    SqlContext.Pipe.Send("Сработал триггер");
                    throw new FormatException("Некорректный год выхода платформы." +
                        " Платформа еще не вышла.");
                }
            }

        }
    }
}

