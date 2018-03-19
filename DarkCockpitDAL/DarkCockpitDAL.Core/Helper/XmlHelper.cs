using DarkCockpitDAL.Core.Utility;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace DarkCockpitDAL.Core.Helper
{
    public static class XmlHelper
    {
        public static XmlDocument CreateXmlDocument(XmlDocument xDoc, Dictionary<string, string> rowData)
        {
            return CreateXmlDocument(xDoc, rowData, new String[] { ColumnName.Quantity });
        }

        public static XmlDocument CreateXmlDocument(XmlDocument xDoc, Dictionary<string, string> rowData, string[] nonKeyColumnName)
        {
            //Check if node already exists
            string xQuery = GetXPathQueryString(rowData, nonKeyColumnName);
            XmlNode node = xDoc.SelectSingleNode(xQuery);

            //Remove "\r\n" from the value: they get added from Copy|Paste from Excel into Infragistics Gris ONLY for the last Cell
            Dictionary<string, string> rowDataCleaned = new Dictionary<string, string>();
            foreach (KeyValuePair<string, string> pair in rowData)
            {
                rowDataCleaned.Add(pair.Key, pair.Value.Replace("\r\n", ""));
            }
            rowData = rowDataCleaned;

            //add node if it does not exist
            if (node == null)
            {
                XmlNode newNode = xDoc.ChildNodes[0].AppendChild(xDoc.CreateElement("row"));

                //Set Key Attributes
                if (rowData.Count > 0)
                    xDoc = SetAttributes(rowData, newNode, xDoc);
            }
            //update data values for existing node
            else
            {
                for (int i = 0; i < nonKeyColumnName.Length; i++)
                    node.Attributes[nonKeyColumnName[i]].InnerText = rowData[nonKeyColumnName[i]];
            }
            return xDoc;
        }

        public static string GetXPathQueryString(Dictionary<string, string> keyList, string[] nonKeyColumnName)
        {
            ArrayList ar = new ArrayList();
            for (int i = 0; i < nonKeyColumnName.Length; i++)
                ar.Add(nonKeyColumnName[i]);

            StringBuilder sb = new StringBuilder("//row[");
            foreach (KeyValuePair<string, string> s in keyList)
            {
                if (!ar.Contains(s.Key))
                    sb.Append("@" + s.Key.ToString() + "='" + s.Value.ToString() + "' and ");
            }

            //remove the last " and "
            return sb.ToString().Substring(0, sb.ToString().Length - 5) + "]";
        }

        public static XmlDocument SetAttributes(Dictionary<string, string> rowData, XmlNode xNode, XmlDocument xDocIn)
        {
            foreach (KeyValuePair<string, string> s in rowData)
            {
                string attributeName = s.Key.ToString();
                XmlAttribute xAttribute = xDocIn.CreateAttribute(attributeName);
                xAttribute.Value = s.Value.ToString();
                xNode.Attributes.Append(xAttribute);
            }
            return xDocIn;
        }

    }
}
