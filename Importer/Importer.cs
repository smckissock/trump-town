using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Importer {

    class Importer {

        static void Main(string[] args) {
            Lobbyists.Import("c:\\trump-town\\site\\lobbyists\\");
            Staffers.Import("c:\\trump-town\\site\\lobbyists\\data\\staffers\\");

            Console.ReadLine();
        }
    }
}
