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

            string connString = "Server=PC\\SQLExpress;Database=TrumpTown;Trusted_Connection=True;";

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
    }
}
