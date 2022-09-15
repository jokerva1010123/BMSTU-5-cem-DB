using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native)]
public struct polis: INullable
{
    public long seria;
    public long number;
    public override string ToString()
    {
        // Заменить на собственный код
        return seria+" "+number;
    }
    
    public bool IsNull
    {
        get
        {
            // Введите здесь код
            return _null;
        }
    }
    
    public static polis Null
    {
        get
        {
            polis h = new polis();
            h._null = true;
            return h;
        }
    }
    
    public static polis Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;
        polis u = new polis();
        string[] arr = s.Value.Split(' ');
        u.seria = (long)Convert.ToDouble(arr[0]);
        u.number = (long)Convert.ToDouble(arr[1]);
        if (u.seria > 999999 || u.seria < 100000)
            throw new FormatException("Некорректное значение серии. Длина серии должна быть равна 6.");
        else if (u.number > 9999999999 || u.number < 1000000000)
            throw new FormatException("Некорректное значение номера. Длина номера должна быть равна 10.");
        // Введите здесь код
        return u;
    }
    
    // Это метод-заполнитель
    public long Seria
    {
        get
        {
            return seria;
        }

        set
        {
            seria = value;
        }
    }
    
    // Это статический метод заполнителя
    public long Number
    {
        get
        {
            return number;
        }
        set
        {
            number = value;
        }
    }
    
    // Это поле элемента-заполнителя
    public int _var1;
 
    // Закрытый член
    private bool _null;
}