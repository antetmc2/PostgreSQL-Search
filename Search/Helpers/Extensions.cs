using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Search.Models;

namespace Search.Helpers
{
    public static class Extensions
    {
        public static string SearchTypeWhere(this string add, SearchTypes type, Operators oper, string expression)
        {
            switch(type)
            {
                case SearchTypes.ExactStringMatching:
                    return add += String.Format("\t{0} LOWER(title) LIKE LOWER('%{1}%')\n", oper.ToString(), expression);
                case SearchTypes.UseDictionaries:
                    return add += String.Format("\t{0} titletsv @@ to_tsquery('english',LOWER('{1}'))\n", oper.ToString(), expression.Trim());
                case SearchTypes.FuzzyStringMatching:
                    return add += String.Format("\t{0} LOWER(title) % LOWER('{1}')\n", oper.ToString(), expression);
                default:
                    return add;
            }
        }


        public static string ConvertSearchTermForSQL(this string text, string oper)
        {
            List<string> term = new List<string>();
            string a;
            var quotes = text.Count(ch => ch == '"');

            var splitted = text.Split('"');
            for (int i = 0; i < splitted.Length; i++)
            {
                a = splitted[i];
                if (!string.IsNullOrWhiteSpace(a) && i < quotes) term.Add("(" + a.Trim().Replace(" ", " & ") + ")");
                else if (!string.IsNullOrWhiteSpace(a) && i == quotes) term.Add(a.Trim().Replace(" ", oper));
            }
            
            return String.Join(oper, term);
        }

        public static List<String> ConvertSearchTermForSQLList(this string text, string oper)
        {
            List<string> term = new List<string>();
            string a;
            int AdditionalSplit = 0;
            var quotes = text.Count(ch => ch == '"');

            var splitted = text.Split('"');
            for (int i = 0; i < splitted.Length; i++)
            {
                a = splitted[i];
                if (!string.IsNullOrWhiteSpace(a) && i < quotes) term.Add(a.Trim().Replace(" ", " & "));
                else if (!string.IsNullOrWhiteSpace(a) && i == quotes)
                {
                    AdditionalSplit = 1;
                    break;
                }
            }

            if(AdditionalSplit == 1)
            {
                var newSplitted = splitted[quotes].Split(' ');
                foreach (var str in newSplitted) if (!string.IsNullOrWhiteSpace(str)) term.Add(str.Trim());
            }

            return term;
        }

        public static string ConvertSearchTermForPivot(this string text, string oper)
        {
            List<string> term = new List<string>();
            string a;
            var quotes = text.Count(ch => ch == '"');

            var splitted = text.Split('"');
            for (int i = 0; i < splitted.Length; i++)
            {
                a = splitted[i];
                if (!string.IsNullOrWhiteSpace(a) && i < quotes) term.Add("''" + a.Trim() + "''");
                else if (!string.IsNullOrWhiteSpace(a) && i == quotes) term.Add("''" + a.Trim().Replace(" ", "''" + oper + "''") + "''");
            }

            return String.Join(oper, term);
        }

        public static List<String> ConvertSearchTermIntoList(this string text, string oper)
        {
            List<string> result = new List<string>();
            string a;
            int AdditionalSplit = 0;
            var quotes = text.Count(ch => ch == '"');

            var splitted = text.Split('"');
            for (int i = 0; i < splitted.Length; i++)
            {
                a = splitted[i];
                if (!string.IsNullOrWhiteSpace(a) && i < quotes) result.Add(splitted[i]);
                else if (!string.IsNullOrWhiteSpace(a) && i == quotes)
                {
                    AdditionalSplit = 1;
                    break;
                }
            }

            var newSplit = splitted[quotes].Trim().Split(' ');
            if(AdditionalSplit == 1) foreach (var i in newSplit) result.Add(i);

            return result;
        }

        public static string ChangeOperatorIDToString(this Operators text)
        {
            switch (text)
            {
                case Operators.AND:
                    return " & ";
                case Operators.OR:
                    return " | ";
                default:
                    return "";
            }
        }
    }
}