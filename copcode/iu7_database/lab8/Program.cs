using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace lab8
{
    class Program
    {
        private static readonly string connectionString = @"Data Source=DESKTOP-4B5E6BP; Initial Catalog=SHOP_GAMES; Integrated Security=True";

        static void Connection_Info()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                Console.WriteLine("Свойства подключения:\n" +
                    "Строка подключения: {0}\n" +
                    "База данных: {1}\n" +
                    "Сервер: {2}\n" +
                    "Версия серввера: {3}\n" +
                    "Статус: {4}\n", connection.ConnectionString, connection.Database, connection.DataSource,
                    connection.ServerVersion, connection.State);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. "+ex);
            }
            finally
            {
                connection.Close();
            }
        }

        // 2. Запрос, выводящий количество игр с жанром 'Action'
        static void Action()
        {
            string sql = "select count(*) from game where ggenre = 'Action'";
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(sql, connection);
            try
            {
                connection.Open();
                Console.WriteLine("Количество игр с жанром 'Action': {0}", command.ExecuteScalar());
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        //Запрос, выводящий количество разработчиков в каждой стране
        static void NumberOfDeveloper()
        {
            string sql = "select count(DevId) AS [Count developers], DevCountry from Developer group by DevCountry \n update Developer set DevId = DevId+10000 \n go";
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(sql, connection);
            try
            {
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                Console.WriteLine("  Количество разработчиков\tСтрана\n----------------------------------------------");
                while(reader.Read())
                    Console.WriteLine("\t{0}\t\t\t{1}", reader.GetValue(0), reader.GetValue(1));
                reader.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        // Добавление разработчика
        static void AddObject()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            string id = "select max(devid) from developer";
            string insert = "insert developer values(@devid, @devtitle, @devcountry)";

            SqlCommand commandId = new SqlCommand(id, connection);
            SqlCommand commandInsert = new SqlCommand(insert, connection);
            commandInsert.Parameters.Add("@devid", SqlDbType.Int);
            commandInsert.Parameters.Add("@devtitle", SqlDbType.NVarChar, 30);
            commandInsert.Parameters.Add("@devcountry", SqlDbType.NVarChar, 30);
            Console.WriteLine("Добавление нового разработчика");

            try
            {
                connection.Open();
                int maxId = Convert.ToInt32(commandId.ExecuteScalar());

                Console.Write("\nВведите название разработчика: ");
                string titleInsert = Console.ReadLine();
                Console.Write("\nВведите страну разработчика: ");
                string countryInsert = Console.ReadLine();

                maxId++;

                commandInsert.Parameters["@devid"].Value = maxId;
                commandInsert.Parameters["@devtitle"].Value = titleInsert;
                commandInsert.Parameters["@devcountry"].Value = countryInsert;

                commandInsert.ExecuteNonQuery();
                Console.WriteLine("Запись добавлена");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        // Обновление. Изменение цены игры с заданным Id
        static void UpdateObject()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            string insert = "update game set gprice = @gprice where gid = @gid";
            
            SqlCommand commandInsert = new SqlCommand(insert, connection);
            commandInsert.Parameters.Add("@gid", SqlDbType.Int);
            commandInsert.Parameters.Add("@gprice", SqlDbType.Int);
            Console.WriteLine("Изменение цены игры с заданным Id");

            try
            {
                connection.Open();

                Console.Write("\nВведите Id игры: ");
                string idInsert = Console.ReadLine();
                Console.Write("\nВведите новую цену игры: ");
                string priceInsert = Console.ReadLine();
                
                
                commandInsert.Parameters["@gid"].Value = idInsert;
                commandInsert.Parameters["@gprice"].Value = priceInsert;

                commandInsert.ExecuteNonQuery();
                Console.WriteLine("Запись обновлена");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        // Хранимая процедура с параметрами
        static void Procedure()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "sp_GetAgeRange";

                Console.WriteLine("Процедура, выводящая количество клиентов с заданным именем и их средний возраст");

                SqlParameter parameterName = command.Parameters.Add("@name", SqlDbType.NVarChar, 50);
                parameterName.Direction = ParameterDirection.Input;
                Console.Write("Введите имя клиента: ");
                string nameInsert = Console.ReadLine();
                parameterName.Value = nameInsert;

                SqlParameter parameterCount = command.Parameters.Add("@count", SqlDbType.Int);
                parameterCount.Direction = ParameterDirection.Output;

                SqlParameter parameterAvg = command.Parameters.Add("@avg", SqlDbType.Int);
                parameterAvg.Direction = ParameterDirection.Output;

                command.ExecuteNonQuery();

                Console.WriteLine("Для пользователей с именем {0} средний возраст: {1}," +
                    " количество клиентов с этим именем {2}", nameInsert, command.Parameters["@avg"].Value, 
                    command.Parameters["@count"].Value);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        // Вывод платформ, вышедших после 2019 года
        static void OutputPlatform()
        {
            string sql = "select pltitle, plyear from platform where plyear > 2019";
            SqlConnection connection = new SqlConnection(connectionString);
            Console.WriteLine("\nПлатформы, вышедшие после 2019 года");
            try
            {
               //connection.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(sql, connection);
                DataSet dataSet = new DataSet();
                adapter.Fill(dataSet, "Platform");
                DataTable dataTable = dataSet.Tables["Platform"];
                foreach (DataRow row in dataTable.Rows)
                    Console.WriteLine(row[0]);
                
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        // Добавление разработчика
        static void AddElement()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            string id = "select max(devid) from developer";
            string data = "select * from developer";
            string insert = "insert developer values(@devid, @devtitle, @devcountry)";

            SqlCommand commandId = new SqlCommand(id, connection);
            Console.WriteLine("Добавление нового разработчика");

            try
            {
                connection.Open();
                int maxId = Convert.ToInt32(commandId.ExecuteScalar());

                Console.Write("\nВведите название разработчика: ");
                string titleInsert = Console.ReadLine();
                Console.Write("\nВведите страну разработчика: ");
                string countryInsert = Console.ReadLine();

                maxId++;

                SqlDataAdapter adapter = new SqlDataAdapter(new SqlCommand(data, connection));
                DataSet dataSet = new DataSet();
                adapter.Fill(dataSet, "Developer");
                DataTable dataTable = dataSet.Tables["Developer"];
                DataRow insertRow = dataTable.NewRow();
                insertRow["devid"] = maxId;
                insertRow["devtitle"] = titleInsert;
                insertRow["devcountry"] = countryInsert;
                dataTable.Rows.Add(insertRow);
                SqlCommand commandInsert = new SqlCommand(insert, connection);
                commandInsert.Parameters.Add("@devid", SqlDbType.Int, 4, "devid");
                commandInsert.Parameters.Add("@devtitle", SqlDbType.NVarChar, 30, "devtitle");
                commandInsert.Parameters.Add("@devcountry", SqlDbType.NVarChar, 30, "devcountry");
                adapter.InsertCommand = commandInsert;
                adapter.Update(dataSet, "Developer");


                Console.WriteLine("Запись добавлена");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }
        
        static void DeleteElement()
        {
            string data = "select * from game";
            string delete = "delete from game where gid = @id";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                //connection.Open();
                Console.Write("Введите Id удаляемого элемента из таблицы 'Game': ");
                int id = Convert.ToInt32(Console.ReadLine());

                SqlDataAdapter adapter = new SqlDataAdapter(new SqlCommand(data, connection));
                DataSet dataSet = new DataSet();
                adapter.Fill(dataSet, "Game");
                DataTable dataTable = dataSet.Tables["Game"];

                string filter = "gid = " + id;
                foreach(DataRow row in dataTable.Select(filter))
                    row.Delete();
                SqlCommand command = new SqlCommand(delete, connection);
                command.Parameters.Add("@id", SqlDbType.Int, 4, "gid");
                adapter.DeleteCommand = command;
                adapter.Update(dataSet, "Game");

                Console.WriteLine("Запись удалена");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }
        // Фильтрация и сортировка
        // клиенты старше 18 с играми жанра Action
        static void Filter()
        {
            string sql = "select * from Client join game on client.clid = game.clid";
            SqlConnection connection = new SqlConnection(connectionString);
            Console.WriteLine("GGenre\tClId\tClAge\tClName");
            try
            {
                SqlDataAdapter adapter = new SqlDataAdapter(new SqlCommand(sql, connection));
                DataSet dataSet = new DataSet();
                adapter.Fill(dataSet, "Client");
                DataTableCollection dataTableCollection = dataSet.Tables;

                string filter = "ClAge > 18 and GGenre = 'Action'";
                string sort = "clage asc";
                foreach (DataRow row in dataTableCollection["Client"].Select(filter, sort))
                    Console.WriteLine("{0}\t{1}\t{2}\t{3}", row["ggenre"], row["clid"],
                        row["clage"], row["clname"]);

            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            finally
            {
                connection.Close();
            }
        }

        static void XML()
        {
            string sql = "select * from Client";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                SqlDataAdapter adapter = new SqlDataAdapter(new SqlCommand(sql, connection));
                DataSet dataSet = new DataSet();
                adapter.Fill(dataSet, "Client");
                dataSet.WriteXml("Client.xml");
                Console.WriteLine("\nXML создан");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. " + ex);
            }
            //finally
            //{
            //    connection.Close();
            //}
        }

        static void Main(string[] args)
        {
            try
            {
                while (true)
                {
                    Console.WriteLine("\nMenu:\n" +
                        "Присоединенные объекты:\n" +
                        "  1. Информация о подключении\n" +
                        "  2. Скалярный запрос, выводящий количество игр с жанром 'Action'\n" +
                        "  3. Запрос, выводящий количество разработчиков в каждой стране\n" +
                        "  4. Добавление объектов\n" +
                        "  5. Обновление объектов\n" +
                        "  6. Хранимая процедура\n" +
                        "Отсоединенные объекты:\n" +
                        "  7. Вывод платформ, вышедших после 2019 года\n" +
                        "  8. Добавление элемента\n" +
                        "  9. Удаление элемента\n" +
                        "  10. Фильтрация и сортировка\n" +
                        "  11. XML\n");
                    string answer = Console.ReadLine();
                    if (int.TryParse(answer, out int num) && num > 0 && num <= 11)
                    {
                        switch (num)
                        {
                            case 1: 
                                Connection_Info();
                                break;
                            case 2:
                                Action();
                                break;
                            case 3:
                                NumberOfDeveloper();
                                break;
                            case 4:
                                AddObject();
                                break;
                            case 5:
                                UpdateObject();
                                break;
                            case 6:
                                Procedure();
                                break;
                            case 7:
                                OutputPlatform();
                                break;
                            case 8:
                                AddElement();
                                break;
                            case 9:
                                DeleteElement();
                                break;
                            case 10:
                                Filter();
                                break;
                            case 11:
                                XML();
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. "+ex);
            }
        }
    }
}
