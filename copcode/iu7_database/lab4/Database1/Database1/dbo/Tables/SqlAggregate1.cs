using System;
using System.IO;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[SqlUserDefinedAggregate(Format.UserDefined, MaxByteSize = 8000)
]
public class Concatenate : IBinarySerialize
{
    private StringBuilder Res;
    
    public void Init()
    {
        this.Res = new StringBuilder();
    }
    
    public void Accumulate(SqlString value)
    {
        Res.Append(value);
        Res.Append(',');
    }

    public void Merge(Concatenate other)
    {
        Accumulate(other.ToString());
    }
    
    public SqlString Terminate()
    {
        string output = string.Empty;
        if (Res != null && Res.Length > 0)
        {
            output = Res.ToString(0, Res.Length - 1);
        }

        return new SqlString(output);
    }

    public void Read(BinaryReader r)
    {
        Res = new StringBuilder(r.ReadString());
    }

    public void Write(BinaryWriter w)
    {
        w.Write(Res.ToString());
    }
}