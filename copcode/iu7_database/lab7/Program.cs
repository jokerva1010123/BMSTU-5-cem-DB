using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Reflection;


namespace lab7
{
    class Client
    {
        public int id { get; set; }
        public string name { get; set; }
        public string surname { get; set; }
        public string phone { get; set; }
        public int age { get; set; }
    }
    class Game
    {
        public int id { get; set; }
        public string title { get; set; }
        public string genre { get; set; }
        public int year { get; set; }
        public int client { get; set; }
    }

    [Table (Name = "Client")]
    public class ClientTable
    {
        [Column (IsPrimaryKey = true)]
        public int Clid { get; set; }
        [Column]
        public string Clname { get; set; }
        [Column]
        public string Clsurname { get; set; }
        [Column]
        public string Clphone { get; set; }
        [Column]
        public int Clage { get; set; }
    }
    [Table (Name="Developer")]
    public class DeveloperTable
    {
        [Column (IsPrimaryKey=true)]
        public int Devid { get; set; }
        [Column]
        public string Devtitle { get; set; }
        [Column]
        public string Devcountry { get; set; }
    }
    [Table (Name ="Platform")]
    public class PlatformTable
    {
        [Column (IsPrimaryKey =true)]
        public int Plid { get; set; }
        [Column]
        public string Pltitle { get; set; }
        [Column]
        public string Pldeveloper { get; set; }
        [Column]
        public int Plyear { get; set; }
    }
    [Table (Name ="Game")]
    public class GameTable
    {
        [Column (IsPrimaryKey =true)]
        public int Gid { get; set; }
        [Column]
        public string Gtitle { get; set; }
        [Column]
        public string Ggenre { get; set; }
        [Column]
        public int Devid { get; set; }
        [Column]
        public int Plid { get; set; }
        [Column]
        public int Gyear { get; set; }
        [Column]
        public int Gprice { get; set; }
        [Column]
        public int Clid { get; set; }
    }

    public class UserDataContext : DataContext
    {
        public UserDataContext(string connectionString)
            : base(connectionString)
        {

        }
        public Table<ClientTable> Users { get { return this.GetTable<ClientTable>(); } }

        [Function(Name = "sp_GetAgeRange")]
        [return: Parameter(DbType = "Int")]
        public int GetAgeRange([Parameter(Name = "name", DbType = "NVarChar(50)")] string name,
            [Parameter(Name = "count", DbType = "Int")] ref int count,
            [Parameter(Name = "avg", DbType = "Int")] ref int agv)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), name, count, agv);
            count = ((int)(result.GetParameterValue(1)));
            agv = ((int)(result.GetParameterValue(2)));
            return ((int)(result.ReturnValue));
        }
    }

    class Program
    {
        static void ReadXML()
        {
            XDocument doc = XDocument.Load("1.xml");
            foreach (XElement el in doc.Elements("Row").Elements("row"))
            {
                XElement cid = el.Element("ClId");
                XElement cname = el.Element("ClName");
                XElement csurname = el.Element("ClSurname");
                XElement cphone = el.Element("ClPhone");
                XElement cage = el.Element("ClAge");

                Console.WriteLine("Id: " + cid);
                Console.WriteLine("Name: " + cname);
                Console.WriteLine("Surname: " + cid);
                Console.WriteLine("Phone: " + cid);
                Console.WriteLine("Age: " + cid);
                Console.WriteLine();
            }
        }

        static void UpdateXML()
        {
            XDocument doc = XDocument.Load("1.xml");
            var root = doc.Elements("Row");
            foreach (XElement el in root.Elements("row").ToList())
            {
                if (el.Element("ClId").Value == "2")
                    el.Element("ClName").Value = "Nik";
            }
            doc.Save("update.xml");
        }

        static void AddXML()
        {
            XDocument doc = XDocument.Load("1.xml");
            doc.Element("Row").Add(new XElement("row",
                new XElement("ClId", "121"),
                new XElement("ClName", "Sleep"),
                new XElement("ClSurname", "Man"), 
                new XElement("ClPhone", "89250170813"),
                new XElement("ClAge", "20")));
            doc.Save("add.xml");
        }

        static void Print(dynamic res)
        {
            foreach (var t in res)
                Console.WriteLine(t);
            Console.WriteLine();
        }

        

        static void Main(string[] args)
        {
            List<Client> clients = new List<Client>
            {
                new Client(){id = 1, name = "Kira", surname = "Volkova", phone = "89256326458", age = 33},
                new Client(){id = 2, name = "Nikita", surname = "Nikolaev", phone = "89255645184", age = 26},
                new Client(){id = 3, name = "Veronica", surname = "Stepanova", phone = "89255644826", age = 21},
                new Client(){id = 4, name = "Valentin", surname = "Sokolov", phone = "89155361184", age = 30},
                new Client(){id = 5, name = "Galina", surname = "Volkova", phone = "89165664584", age = 23},
                new Client(){id = 6, name = "Sergei", surname = "Sokolov", phone = "89532645162", age = 54}
            };
            List<Game> games = new List<Game>
            {
                new Game(){id = 1, title = "S.t.a.l.k.e.r.", genre = "Shooter", year = 2020, client = 3},
                new Game(){id = 2, title = "Starfield", genre = "Platform", year = 2021, client = 2},
                new Game(){id = 3, title = "GTA5", genre = "Shooter", year = 2017, client = 1},
                new Game(){id = 4, title = "Halo", genre = "Adventure", year = 2018, client = 6},
                new Game(){id = 5, title = "Dragon Age", genre = "Shooter", year = 2015, client = 4},
                new Game(){id = 6, title = "Hello", genre = "Adventure", year = 2010, client = 5},
                new Game(){id = 6, title = "Sleep", genre = "Shooter", year = 2000, client = 2}
            };

            Console.WriteLine("1. Выводит клиентов, чьи игры вышли позже 2019");
            var res1 = from cl in clients
                       join g in games on cl.id equals g.client
                       where g.year > 2019
                       orderby cl.id
                       select new {Id = cl.id, Name = cl.name, Game = g.title, Year = g.year};
            Print(res1);
            Console.WriteLine("---------------------------------------");

            Console.WriteLine("2. Выводит игры по жанрам");
            var res2 = from g in games
                       group g by g.genre
                       into res22
                       select res22;
            foreach (var gr in res2)
            {
                Console.WriteLine("Genre: {0}", gr.Key);
                foreach (var tit in gr)
                    Console.WriteLine(tit.title);
                Console.WriteLine();
            }
            Console.WriteLine("---------------------------------------");

            Console.WriteLine("3. Выводдит игры с жанром 'Adventure'");
            var res3 = from g in games
                       where g.genre == "Adventure"
                       select new { Game = g.title, Genre = g.genre};
            Print(res3);
            Console.WriteLine("---------------------------------------");

            Console.WriteLine("4. Количество игр у каждого клиента");
            var res4 = from g in games
                       join cl in clients on g.client equals cl.id
                       group cl by cl.name
                       into res44
                       select res44;
            foreach (var gr in res4)
            {
                Console.WriteLine("Client: {0}", gr.Key);
                //foreach (var tit in gr)
                    Console.WriteLine("{0}", gr.Count());
                Console.WriteLine();
            }
            Console.WriteLine("---------------------------------------");

            Console.WriteLine("5. Клиенты старше 22 и отсортированные по возрастанию");
            var res5 = from cl in clients
                       where cl.age > 22
                       orderby cl.age ascending
                       select new { Client = cl.name, Age = cl.age};
            Print(res5);


            ///////////////////////////////////////////////////////////////////////////////////
            ///
            // Чтение из XML документа
            ReadXML();

            ///////////////
            /// 
            // Обновление XML документа
            // UpdateXML();

            ///////////////
            // Добавление в XML документ
            //AddXML();



            ///////////////////////////////////////////////////////////////////////////////////

            // LINQ to SQL

            //
            Console.WriteLine("---------------------------------------");
            string connectionString = @"Data Source=DESKTOP-4B5E6BP; Initial Catalog=SHOP_GAMES; Integrated Security=True";
            DataContext db = new DataContext(connectionString);

            Console.WriteLine("Однотабличный запрос на выборку\nПлатформы: вышедшие после 2019 года");
            var zap1 = from pl in db.GetTable<PlatformTable>()
                            where pl.Plyear > 2019
                            select new { Platform = pl.Pltitle,  Year = pl.Plyear};
            Print(zap1);


            Console.WriteLine("---------------------------------------");
            Console.WriteLine("Многотабличный запрос на выборку\nВывести игры, разработчики которых из Австралии");
            var zap2 = from g in db.GetTable<GameTable>()
                       join dev in db.GetTable<DeveloperTable>() on g.Devid equals dev.Devid
                       where dev.Devcountry == "Austria"
                       select new { Game = g.Gtitle, Developer = dev.Devtitle, Country = dev.Devcountry};
            Print(zap2);


            Console.WriteLine("---------------------------------------");
            Console.WriteLine("\nЗапрос на добавление");
            var title = "Developer";
            var country = "Moscow";
            var id = from dev in db.GetTable<DeveloperTable>()
                     select dev.Devid;
            int maxId = id.Max()+1;

            DeveloperTable newDev = new DeveloperTable()
            {
                Devid = maxId,
                Devtitle = title,
                Devcountry = country
            };
            db.GetTable<DeveloperTable>().InsertOnSubmit(newDev);
            db.SubmitChanges();
            Console.WriteLine("Добавление завершено");


            Console.WriteLine("---------------------------------------");
            var change = db.GetTable<DeveloperTable>().Where(d => d.Devid == 2).FirstOrDefault();
            change.Devtitle = "NULL";
            db.SubmitChanges();
            Console.WriteLine("Изменение завершено");

            
            Console.WriteLine("---------------------------------------");
            var delete = db.GetTable<DeveloperTable>().Where(d => d.Devid == maxId).FirstOrDefault();
            db.GetTable<DeveloperTable>().DeleteOnSubmit(delete);
            db.SubmitChanges();
            Console.WriteLine("Элемент удален");

            /////////////////////////////////////////////////////////////////
            ///
            // Получение доступа к данным, выполнчч только хранимую процедуру
            UserDataContext db1 = new UserDataContext(connectionString);
            int count = 0, avg = 0;
            string name = "Kira";
            db1.GetAgeRange(name, ref count, ref avg);
            Console.WriteLine("Для пользователей с именем {0} средний возраст: {1}, количество клиентов с этим именем: {2}", name, avg, count);

            Console.ReadKey();
        }
    }
}
