using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.IO;


// чтобы программно искал комментарии


namespace ConsoleApp1
{
    class Program
    {
        private XmlDocument _myDocument;

        private XmlDocument myDocument
        {
            get
            {
                if (_myDocument == null)
                {
                    Console.WriteLine("Файл не был загружен, выполняется загрузка");
                    Load_file();
                }
                return _myDocument;
            }
            set { _myDocument = value; }
        }

        private void Load_file()
        {
            myDocument = new XmlDocument();
            FileStream myFile = null;
            try
            {
                myFile = new FileStream("1.xml", FileMode.Open);
                XmlValidatingReader reader = new XmlValidatingReader(myFile, XmlNodeType.Document, null);
                myDocument.Load(reader);
                Console.WriteLine("Файл загружен.");
            }
            catch (Exception exp)
            {
                Console.WriteLine(exp);
            }
            finally
            {
                if (myFile != null)
                {
                    myFile.Close();
                }
            }
            Menu();
        }
        /// <summary>
        /// Поиск
        /// </summary>
        private void Find_info()
        {
            Console.WriteLine("\n1. с помощью метода GetElementByTagName\n" +
                "2. с помощью метода GetElementById\n" +
                "3. с помощью метода SelectNodes\n" +
                "4. с помощью метода SelectSingleNode");
            string answer = Console.ReadLine();
            if (int.TryParse(answer, out int num) && num > 0 && num <= 4)
            {
                switch (num)
                {
                    case 1:
                        GetByTagName();
                        break;
                    case 2:
                        GetById();
                        break;
                    case 3:
                        GetByNode();
                        break;
                    case 4:
                        GetBySingleNode();
                        break;
                }
            }
        }
        private void GetByTagName()
        {
            Console.Write("Введите тег:");
            string tag = Console.ReadLine();
            if (tag != null)
            {
                XmlNodeList name = myDocument.GetElementsByTagName(tag);
                if (name.Count == 0)
                    Console.WriteLine("Не найдено");
                //foreach (XmlNode element in taglist)
                for (int i = 0; i < name.Count; i++)
                    Console.WriteLine(name[i].ChildNodes[0].Value);
            }
            else
                Console.WriteLine("Некорректный ввод.");
            Menu();
        }
        private void GetById()
        {
            Console.Write("Введите ID:");
            string tag = Console.ReadLine();
            if (tag != null)
            {
                XmlElement element = myDocument.GetElementById(tag);
                if (element == null)
                {
                    Console.WriteLine("Ничего не найдено");
                }
                else
                {
                    Console.WriteLine(element.ChildNodes[0].ChildNodes[0].Value);
                }
            }
            else
            {
                Console.WriteLine("Плохой ID");
            }
            Menu();
        }
        private void GetByNode()
        {
            Console.WriteLine("Имена клиентов: которым 33 года.");
            XmlNodeList node = myDocument.SelectNodes("//client[clage='33']");
            for (int i = 0; i < node.Count; i++)
                Console.WriteLine(node[i].ChildNodes[0].ChildNodes[0].Value);
            Menu();
        }
        private void GetBySingleNode()
        {
            Console.Write("Введите возраст: ");
            string n = Console.ReadLine();
            XmlNode node = myDocument.SelectSingleNode($"//client[clage='{n}']");
            Console.WriteLine(node.ChildNodes[0].ChildNodes[0].Value);
            Menu();
        }
        /// <summary>
        /// /////////////////////////////
        /// </summary>
        private void Access()
        {
            Console.WriteLine("\n1. к узлам типа XmlElement.\n" +
                "2. к узлам типа XmlText.\n" +
                "3. к узлам типа XmlComment.\n" +
                "4. к узлам типа XmlProcessingInstruction.\n" +
                "5. к атрибутам узлов.");
            string answer = Console.ReadLine();
            if (int.TryParse(answer, out int num) && num > 0 && num <= 5)
            {
                switch (num)
                {
                    case 1:
                        Element();
                        break;
                    case 2:
                        Text();
                        break;
                    case 3:
                        Comment();
                        break;
                    case 4:
                        ProcessingInstruction();
                        break;
                    case 5:
                        Attribute();
                        break;
                }
            }
            else
            {
                Console.WriteLine("\nНекорректный ввод\n");
                Menu();
            }
        }
        private void Element()
        {
            Console.WriteLine("Номер телефона клиента №3");
            XmlElement element = (XmlElement)myDocument.DocumentElement.ChildNodes[2];
            Console.WriteLine(element.ChildNodes[2].ChildNodes[0].Value);
            Menu();
        }
        private void Text()
        {
            Console.WriteLine(myDocument.DocumentElement.ChildNodes[10].ChildNodes[1].Value);
            Menu();
        }
        private void Comment()
        {
            foreach (XmlNode node in myDocument.ChildNodes)
            {
                foreach(XmlNode nodeChildN in node.ChildNodes)
                {
                    for (int i = 0; i < nodeChildN.ChildNodes.Count; i++)
                    {
                        if (nodeChildN.ChildNodes[i] is XmlComment)
                            Console.WriteLine(nodeChildN.ChildNodes[i].Value);
                    }
                }
            }
            Menu();
        }
        private void ProcessingInstruction()
        {
            XmlProcessingInstruction m = (XmlProcessingInstruction)
                myDocument.DocumentElement.ChildNodes[11].ChildNodes[1];
            Console.WriteLine("Name: " + m.Name);
            Console.WriteLine("data: " + m.Data);
            Menu();
        }
        private void Attribute()
        {
            Console.WriteLine();
            Console.Write(myDocument.DocumentElement.GetAttribute("clid"));

            foreach (XmlNode node in myDocument.ChildNodes)
            {
                foreach (XmlNode nodeChildNode in node.ChildNodes)
                {
                    XmlAttributeCollection myAttributes1 = nodeChildNode.Attributes;
                    if (myAttributes1 != null)
                    {
                        foreach (XmlAttribute atr in myAttributes1)
                        {
                            Console.Write("Атрибуты: " + atr.Name + " = " + atr.Value + "\r\n");
                        }
                    }
                }
            }
            Menu();
        }

        private void Changes()
        {
            Console.WriteLine("\n1. удаление содержимого.\n" +
                "2. внесение изменений в содержимое.\n" +
                "3. создание нового содержимого.\n" +
                "4. вставка содержимого.\n" +
                "5. добавление атрибутов.");
            string answer = Console.ReadLine();
            if (int.TryParse(answer, out int num) && num > 0 && num <= 5)
            {
                switch (num)
                {
                    case 1:
                        Delete();
                        break;
                    case 2:
                        Change();
                        break;
                    case 3:
                        Create();
                        break;
                    case 4:
                        Insert();
                        break;
                    case 5:
                        Add();
                        break;
                }
            }
            else
            {
                Console.WriteLine("\nНекорректный ввод\n");
                Menu();
            }
        }
        private void Delete()
        {
            // удаление sampleCode
            Console.WriteLine("\nУдаление sampleCode");
            XmlElement deleteElement = (XmlElement)myDocument.GetElementsByTagName("sampleCode")[0];
            myDocument.DocumentElement.RemoveChild(deleteElement);
            myDocument.Save("delete.xml");
            Menu();
        }
        private void Change()
        {
            Console.WriteLine("\nИзменяет возраст на год рождения.");
            XmlNodeList change = myDocument.SelectNodes("//client/clage/text()");
            for (int i = 0; i < change.Count; i++)
                change[i].Value = Convert.ToString(2018 - (Convert.ToInt32(change[i].Value)));
            myDocument.Save("change.xml");
            Menu();
        }
        private void Create()
        {
            Console.WriteLine("\nСоздание нового клиента.");
            XmlElement element = myDocument.CreateElement("client");
            XmlElement elementName = myDocument.CreateElement("clname");
            XmlElement elementSurname = myDocument.CreateElement("surname");
            XmlText textName = myDocument.CreateTextNode("Sleep");
            XmlText textSurname = myDocument.CreateTextNode("Man");
            elementName.AppendChild(textName);
            elementSurname.AppendChild(textSurname);

            element.SetAttribute("clid", "cl11");
            element.AppendChild(elementName);
            element.AppendChild(elementSurname);

            myDocument.DocumentElement.AppendChild(element);
            myDocument.Save("create.xml");
            Menu();
        }
        private void Insert()
        {
            Console.WriteLine("\nДобавление комментарий к 3му клиенту.");

            XmlComment text = myDocument.CreateComment("Вставленный комментарий.");

            myDocument.DocumentElement.ChildNodes[2].AppendChild(text);

            myDocument.Save("insert.xml");
            Menu();
        }
        private void Add()
        {
            Console.WriteLine("\nДобавление атрибута (наверное как у всех).");
            myDocument.DocumentElement.SetAttribute("client", "cl0");
            myDocument.Save("add.xml");
            Menu();
        }
        private void Menu()
        {
            Console.WriteLine("\n1. Открытие документа, находящегося в файле.\n" +
                "2. Поиск информации, содержащейся в документе.\n" +
                "3. Доступ к содержимому узлов.\n" +
                "4. Внесение изменений в документ.");
            string answer = Console.ReadLine();
            if (int.TryParse(answer, out int num) && num > 0 && num <= 4)
            {
                switch (num)
                {
                    case 1:
                        Load_file();
                        break;
                    case 2:
                        Find_info();
                        break;
                    case 3:
                        Access();
                        break;
                    case 4:
                        Changes();
                        break;
                }
            }
            else
            {
                Console.WriteLine("\nНекорректный ввод\n");
                Menu();
            }
        }
        public Program()
        {
            Menu();
        }
    }
    class Lab
    {
        static void Main(string[] args)
        {
            Program prog = new Program();
        }
    }
}
