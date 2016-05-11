using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.Mvc;
using Npgsql;
using Search.Models;
using Search.Helpers;

namespace Search.Controllers
{
    public class PivotController : Controller
    {

        public string HourForSQL(int i)
        {
            return i < 10 ? "0" + i.ToString() : i.ToString();
        }
        // GET: Pivot
        public ActionResult Index(int redirected = 0)
        {
            PivotModel model = new PivotModel();
            if (redirected == 0) TempData["MessageDates"] = "";
            return View(model);
        }

        [HttpPost]
        public ActionResult Index(PivotModel model)
        {
            if (String.IsNullOrWhiteSpace(model.DateFromFormat) || String.IsNullOrWhiteSpace(model.DateUntilFormat))
            {
                TempData["MessageDates"] = "Dates can't be empty!";
                return RedirectToAction("Index", new { redirected = 1 });
            }
            model.DateFrom = Convert.ToDateTime(model.DateFromFormat);
            model.DateUntil = Convert.ToDateTime(model.DateUntilFormat);
            List<string> proba = new List<string>();
            if(model.DateUntil < model.DateFrom)
            {
                TempData["MessageDates"] = "End date cannot be earlier than start date!";
                return RedirectToAction("Index", new { redirected = 1 });
            }
            switch (model.Analysis)
            {
                case AnalysisGranulation.Day:
                    var Timespan = Math.Round((model.DateUntil - model.DateFrom).TotalDays, 0);
                    string DaysForString = "";
                    PivotDay ListForQueryD = new PivotDay();
                    List<PivotDay> ListDays = new List<PivotDay>();
                    using (var conn = new NpgsqlConnection("Server=localhost;Port=5432;User ID=postgres;Password=AnteT3876;Database=Projekt"))
                    {
                        conn.Open();
                        using (var cmd = new NpgsqlCommand())
                        {
                            cmd.Connection = conn;
                            cmd.CommandText = "CREATE TEMP TABLE dates(DateInt date);";
                            cmd.ExecuteNonQuery();
                            for (DateTime i = model.DateFrom; i <= model.DateUntil; i = i.AddDays(1))
                            {
                                cmd.CommandText = String.Format("INSERT INTO dates VALUES('{0}');", i);
                                cmd.ExecuteNonQuery();
                                DaysForString += String.Format(", d{0}{1}{2} integer", HourForSQL(i.Day), HourForSQL(i.Month), i.Year);
                            }

                            cmd.CommandText = String.Format(@"SELECT *
FROM crosstab('SELECT CAST(query AS character varying(500)) AS query,
	    CAST(to_date(to_char(""timestamp"", ''YYYY-mm-dd''), ''YYYY-mm-dd'') AS date) AS chosenDate,
        CAST(COUNT(*) AS integer) AS brUpita
        FROM public.""Queries""
        WHERE ""timestamp"" BETWEEN ''{1}''
        AND ''{2}''
	    GROUP BY query, chosenDate
        ORDER BY query, chosenDate',
	'SELECT DateInt FROM dates ORDER BY DateInt')
AS pivotTable(query character varying(500){0})
ORDER BY query;", DaysForString, model.DateFromFormat, model.DateUntilFormat);
                            model.SqlPivotString = cmd.CommandText;
                            using (var reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    ListForQueryD = new PivotDay();
                                    ListForQueryD.QueryString = reader.GetString(0);
                                    ListForQueryD.DayValues = new List<int>();
                                    for (int i = 1; i <= Timespan; i++)
                                    {
                                        if (!reader.IsDBNull(i)) ListForQueryD.DayValues.Add(reader.GetInt32(i));
                                        else ListForQueryD.DayValues.Add(0);
                                    }
                                    ListDays.Add(ListForQueryD);
                                }
                            }
                            model.ListByDays = ListDays;
                            model.DaysTimespan = Timespan;
                        }
                    }
                    break;
                case AnalysisGranulation.Hour:
                    string HoursForString = "";
                    PivotHour ListForQuery = new PivotHour();
                    List<PivotHour> ListHours = new List<PivotHour>();
                    using (var conn = new NpgsqlConnection("Server=localhost;Port=5432;User ID=postgres;Password=AnteT3876;Database=Projekt"))
                    {
                        conn.Open();
                        using (var cmd = new NpgsqlCommand())
                        {
                            cmd.Connection = conn;
                            cmd.CommandText = "CREATE TEMP TABLE hour(brHour INT);";
                            cmd.ExecuteNonQuery();
                            for(int i = 0; i < 24; i++)
                            {
                                cmd.CommandText = String.Format("INSERT INTO hour VALUES({0});", HourForSQL(i));
                                cmd.ExecuteNonQuery();
                                HoursForString += String.Format(", h_{0}_{1} integer", HourForSQL(i), HourForSQL(i + 1));
                            }

                            cmd.CommandText = String.Format(@"SELECT *
FROM crosstab('SELECT CAST(query AS character varying(500)) AS query,
	    CAST(EXTRACT(hour FROM ""timestamp"") AS integer) AS hour,
        CAST(COUNT(*) AS integer) AS brUpita
        FROM public.""Queries""
        WHERE ""timestamp"" BETWEEN ''{1}''
        AND ''{2}''
        GROUP BY query, hour
        ORDER BY query, hour',
    'SELECT brHour FROM hour ORDER BY brHour')
AS pivotTable(query character varying(500){0})
ORDER BY query;", HoursForString, model.DateFromFormat, model.DateUntilFormat);
                            model.SqlPivotString = cmd.CommandText;
                            using (var reader = cmd.ExecuteReader())
                            {
                                while(reader.Read())
                                {
                                    ListForQuery = new PivotHour();
                                    ListForQuery.QueryString = reader.GetString(0);
                                    ListForQuery.HourValues = new List<int>();
                                    for (int i = 1; i < 25; i++)
                                    {
                                        if (!reader.IsDBNull(i)) ListForQuery.HourValues.Add(reader.GetInt32(i));
                                        else ListForQuery.HourValues.Add(0);
                                    }
                                    ListHours.Add(ListForQuery);
                                }
                            }
                            model.ListByHours = ListHours;
                        }
                    }
                    break;
                default:
                    break;
            }

            return View(model);
        }
    }
}