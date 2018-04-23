using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Importer {

    public class Util {

        //using (SqlConnection conn = new SqlConnection(connString)) {
        //       using (SqlCommand cmd = new SqlCommand(query, conn)) {
        //           cmd.CommandType = CommandType.Text;
        //           conn.Open();
        //           SqlDataReader reader = cmd.ExecuteReader();

        public static SqlDataReader Query(string query) {

            // Desktop
            string connString = "Server=SCOTT-PC\\SQLExpress;Database=TrumpTown;Trusted_Connection=True;";

            // Laptop
            //string connString = "Server=PC\\SQLExpress;Database=TrumpTown;Trusted_Connection=True;";

            SqlDataReader reader = null;
            using (SqlCommand command = new SqlConnection(connString).CreateCommand()) {
                command.CommandText = query;
                try {
                    command.Connection.Open();
                    reader = command.ExecuteReader(CommandBehavior.CloseConnection);
                }
                catch (Exception ex) {
                    ex.Data.Add("SQL", query + " Query Error: " + ex.Message);
                    throw ex;
                }
            }
            return reader;
        }

        public static string UnCapitalize(string text) {
            if (!IsAllUpper(text))
                return text;

            var allCaps = new string[] { "LLC", "LLP" };

            var words = text.Split(' ');
            var newWords = new List<string>();
            foreach (string word in words) {
                if (allCaps.Contains(word))
                    newWords.Add(word);
                else
                    newWords.Add(UpperCaseFirstChar(word.ToLower())); 
            }
            return String.Join(" ", newWords); 
        }

        private static bool IsAllUpper(string text) {
            for (int i = 0; i < text.Length; i++) {
                if (Char.IsLetter(text[i]) && !Char.IsUpper(text[i]))
                    return false;
            }
            return true;
        }

        private static string UpperCaseFirstChar(string str) {
            if (string.IsNullOrEmpty(str)) {
                return string.Empty;
            }
            return char.ToUpper(str[0]) + str.Substring(1);
        }
    }
}
