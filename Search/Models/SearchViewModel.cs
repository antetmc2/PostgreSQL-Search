using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System.Data;

namespace Search.Models
{
    public enum Operators
    {
        AND = 0,
        OR = 1
    }
    public enum SearchTypes
    {
        ExactStringMatching = 0,
        UseDictionaries = 1,
        FuzzyStringMatching = 2
    }

    public enum AnalysisGranulation
    {
        Day = 0,
        Hour = 1
    }

    public class Results
    {
        public string Title { get; set; }
        public string Headline { get; set; }
        public float Rank { get; set; }
    }

    public class PivotHour
    {
        public string QueryString { get; set; }
        public List<int> HourValues { get; set; }
    }

    public class PivotDay
    {
        public string QueryString { get; set; }
        public List<int> DayValues { get; set; }
    }

    public class SearchModel
    {
        public string Term { get; set; }
        public Operators Operator { get; set; }
        public SearchTypes SearchType { get; set; }

        public string SqlString { get; set; }
        public List<Results> SearchResults { get; set; }
    }
    public class AddNewDataModel
    {
        public string Data { get; set; }
    }

    public class PivotModel
    {
        public DateTime DateFrom { get; set; }
        public DateTime DateUntil { get; set; }
        public string DateFromFormat { get; set; }
        public string DateUntilFormat { get; set; }
        public string SqlPivotString { get; set; }
        public AnalysisGranulation Analysis { get; set; }
        public List<PivotHour> ListByHours { get; set; }
        public List<PivotDay> ListByDays { get; set; }
        public double DaysTimespan { get; set; }
    }
}