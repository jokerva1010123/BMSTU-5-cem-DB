using System;
using System.Xml;
using System.Xml.Schema;

namespace _4
{
    class Program
    {
        private static bool flag;
        static void Main(string[] args)
        {
            flag = true;
            XmlSchemaCollection sc = new XmlSchemaCollection
            {
                { "", "3_2test.xsd" }
            };
            XmlTextReader tr = new XmlTextReader("3_2.xml");
            XmlValidatingReader vr = new XmlValidatingReader(tr)
            {
                ValidationType = ValidationType.Schema
            };
            vr.ValidationEventHandler += new ValidationEventHandler(MyHandler);
            vr.Schemas.Add(sc);
            try
            {
                while (vr.Read())
                {
                    if (vr.NodeType == XmlNodeType.Element && vr.LocalName == "clid")
                    {
                        int num = XmlConvert.ToInt32(vr.ReadElementString());
                        Console.WriteLine("Client ID: " + num);
                    }
                }
            }
            catch (XmlException ex)
            {
                flag = false;
                Console.WriteLine("XMLException occurred: " + ex.Message);
            }
            finally
            {
                vr.Close();
            }

            if (flag == true)
            {
                Console.WriteLine("OK");
            }
            Console.ReadKey();

        }

        // Validation event handler method 
        public static void MyHandler(object sender, ValidationEventArgs e)
        {
            flag = false;
            Console.WriteLine("Validation Error: " + e.Message);
        }
    }
}
