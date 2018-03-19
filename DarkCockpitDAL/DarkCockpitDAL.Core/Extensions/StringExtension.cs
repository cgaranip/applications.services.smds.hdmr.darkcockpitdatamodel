using System;
using System.Collections.Generic;
using System.Text;

namespace DarkCockpitDAL.Core.Extensions
{
    public static class StringExtension
    {
        public static string ToExtendStringName(this string name, string extendName, StringExtensionType stringExtensionType = StringExtensionType.EndOfString)
        {
            if (stringExtensionType == StringExtensionType.StartOfString)
                return $"{extendName}{name}";

            return $"{name}{extendName}";
        }
    }

    public enum StringExtensionType
    {
        StartOfString,
        EndOfString
    }
}
