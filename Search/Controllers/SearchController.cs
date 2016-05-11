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
    public class SearchController : Controller
    {
        public List<Results> PostgreSQLConnection(string sql)
        {
            List<Results> ResultsList = new List<Results>();
            Results row = new Results();
            using (var conn = new NpgsqlConnection("Server=localhost;Port=5432;User ID=postgres;Password=AnteT3876;Database=Projekt"))
            {
                conn.Open();
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = sql;
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            row = new Results();
                            row.Title = reader.GetString(0);
                            row.Headline = reader.GetString(1);
                            row.Rank = reader.GetFloat(2);
                            ResultsList.Add(row);
                        }
                    }
                        return ResultsList;
                }
            }
        }

        public ActionResult Add(int redirected = 0)
        {
            if (redirected == 0) TempData["Message"] = "";
            return View();
        }

        [HttpPost, ActionName("Add")]
        public ActionResult AddNewData(AddNewDataModel model)
        {
            if (String.IsNullOrWhiteSpace(model.Data))
            {
                TempData["Message"] = "The row can't be empty!";
                return RedirectToAction("Add", new { redirected = 1 });
            }
            if (model.Data.Contains("'")) model.Data = model.Data.Replace("'", "''");
            try
                {
                using (var conn = new NpgsqlConnection("Server=localhost;Port=5432;User ID=postgres;Password=AnteT3876;Database=Projekt"))
                {
                    conn.Open();
                    using (var cmd = new NpgsqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandText = String.Format("SELECT title FROM public.\"SeriesMovies\" WHERE title='{0}'", model.Data);
                        using (var reader = cmd.ExecuteReader())
                        {
                            while(reader.Read())
                            {
                                if(reader.GetString(0) == model.Data)
                                {
                                    TempData["Message"] = "The row already exists!";
                                    return RedirectToAction("Add", new { redirected = 1 });
                                }
                            }
                        }
                        cmd.CommandText = String.Format("INSERT INTO public.\"SeriesMovies\"(title)VALUES('{0}');", model.Data);
                        cmd.ExecuteNonQuery();
                        TempData["Message"] = String.Format("\"{0}\" was added successfully!", model.Data);
                        return RedirectToAction("Add", new { redirected = 1 });
                    }
                }
            }
            catch (Exception)
            {
                TempData["Message"] = "Something went wrong, please try again!";
                return View(model);
            }
        }

        // GET: Search
        public ActionResult Index(int redirected = 0)
        {
            SearchModel model = new SearchModel();
            if (redirected == 0) TempData["Message"] = "";

            return View(model);
        }

        [HttpPost]
        public ActionResult Index(SearchModel model)
        {
            string SQL; string SqlWhere;
            string TermForSQL = model.Term;
            if (String.IsNullOrWhiteSpace(model.Term))
            {
                TempData["Message"] = "The row can't be empty!";
                return RedirectToAction("Index", new { redirected = 1 });
            }
            if (TermForSQL.Contains("'")) TermForSQL = TermForSQL.Replace("'", "''");
            var TermsList = TermForSQL.ConvertSearchTermIntoList(model.Operator.ChangeOperatorIDToString());
            string TermForPivot = TermForSQL.ConvertSearchTermForPivot(model.Operator.ChangeOperatorIDToString());
            List<String> SQLlist = TermForSQL.ConvertSearchTermForSQLList(model.Operator.ChangeOperatorIDToString());
            TermForSQL = TermForSQL.ConvertSearchTermForSQL(model.Operator.ChangeOperatorIDToString());


            using (var conn = new NpgsqlConnection("Server=localhost;Port=5432;User ID=postgres;Password=AnteT3876;Database=Projekt"))
            {
                conn.Open();
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = String.Format("INSERT INTO public.\"Queries\"(query, \"timestamp\") VALUES('{0}', '{1}');", TermForPivot, DateTime.Now);
                    cmd.ExecuteNonQuery();
                }
            }

            switch (model.SearchType)
            {
                case SearchTypes.ExactStringMatching:
                    SqlWhere = "WHERE LOWER(title) LIKE LOWER('%" + TermsList[0] + "%')\n";
                    for(int i = 1; i < TermsList.Count; i++)
                    {
                        SqlWhere = SqlWhere.SearchTypeWhere(model.SearchType, model.Operator, TermsList[i]);
                    }
                    SQL = String.Format("SELECT title, ts_headline(title, to_tsquery('{1}')),\n\t\tts_rank(to_tsvector(title), to_tsquery('{1}')) rank \n\tFROM public.\"SeriesMovies\" \n\t{0}\tORDER BY rank DESC;", SqlWhere, TermForSQL);
                    model.SqlString = SQL;
                    model.SearchResults = PostgreSQLConnection(SQL);
                    break;
                case SearchTypes.UseDictionaries:
                    SqlWhere = "WHERE titletsv @@ to_tsquery('english',LOWER('" + SQLlist[0].Trim() + "'))\n";
                    for (int i = 1; i < SQLlist.Count; i++)
                    {
                        SqlWhere = SqlWhere.SearchTypeWhere(model.SearchType, model.Operator, SQLlist[i]);
                    }
                    SQL = String.Format("SELECT title, ts_headline(title, to_tsquery('{1}')),\n\t\tts_rank(to_tsvector(title), to_tsquery('{1}')) rank \n\tFROM public.\"SeriesMovies\" \n\t{0}\tORDER BY rank DESC;", SqlWhere, TermForSQL);
                    model.SqlString = SQL;
                    model.SearchResults = PostgreSQLConnection(SQL);
                    break;
                case SearchTypes.FuzzyStringMatching:
                    SqlWhere = "WHERE LOWER(title) % LOWER('" + TermsList[0] + "')\n";
                    for (int i = 1; i < TermsList.Count; i++)
                    {
                        SqlWhere = SqlWhere.SearchTypeWhere(model.SearchType, model.Operator, TermsList[i]);
                    }
                    SQL = String.Format("SELECT title, ts_headline(title, to_tsquery('{1}')),\n\t\tts_rank(to_tsvector(title), to_tsquery('{1}')) rank \n\tFROM public.\"SeriesMovies\" \n\t{0}\tORDER BY rank DESC;", SqlWhere, TermForSQL);
                    model.SqlString = SQL;
                    model.SearchResults = PostgreSQLConnection(SQL);
                    break;
                default:
                    break;
            }

            return View(model);
        }
    }
}