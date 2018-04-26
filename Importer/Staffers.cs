using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Newtonsoft.Json;

namespace Importer {

    public class StafferJson {
        public string id;
        public string agency_id;
        public string name;
        public string slug;
        public string agency_name;
        public string position_title_1;
        public string position_title_2;
        public string position_title_3;
        public string grade_level;
        public string start_date;
        public string end_date;
        public string financial_disclosure_url;
        public string ethics_waiver_url;
        public string linkedin_url;
        public string outside_bio;
        public string bio_source;
        public string bio_url;
        public string propublica_bio;
    }

    public class Staffers {

        public static void Import(string path) {
            var staffers = new List<StafferJson>();
            var reader = Util.Query("SELECT * FROM StafferView");
            while (reader.Read()) {
                var s = new StafferJson();
                s.id = reader["id"].ToString();
                s.agency_id = reader["agency_id"].ToString();
                s.name = reader["name"].ToString();
                s.slug = reader["slug"].ToString();
                s.agency_name = reader["agency_name"].ToString();
                s.position_title_1 = reader["position_title_1"].ToString();
                s.position_title_2 = reader["position_title_2"].ToString();
                s.position_title_3 = reader["position_title_3"].ToString();
                s.grade_level = reader["grade_level"].ToString();
                s.start_date = reader["start_date"].ToString();
                s.end_date = reader["end_date"].ToString();
                s.financial_disclosure_url = reader["financial_disclosure_url"].ToString();
                s.ethics_waiver_url = reader["ethics_waiver_url"].ToString();
                s.linkedin_url = reader["linkedin_url"].ToString();
                s.outside_bio = reader["outside_bio"].ToString();
                s.bio_source = reader["bio_source"].ToString();
                s.bio_url = reader["bio_url"].ToString();
                s.propublica_bio = reader["propublica_bio"].ToString();
                staffers.Add(s);


                string json = JsonConvert.SerializeObject(s);
                var niceJson = Newtonsoft.Json.Linq.JToken.Parse(json).ToString();

                System.IO.File.WriteAllText(path + s.id + ".json", niceJson);
            }
            Console.WriteLine(staffers.Count().ToString() + " staffers");
        }
    }
}
