using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Newtonsoft.Json;

namespace Importer {

    public class NodeJson {
        public string name;
        public string category;
        public int amount;

        public NodeJson(string name, string category, string amount) {
            this.name = name;
            this.category = category;
            this.amount = Convert.ToInt32(amount);
        }
    }

    public class LinkJson {
        public int source;
        public int target;
        public int value;

        public LinkJson(string sourceId, string targetId, string count) {
            this.source = Convert.ToInt32(sourceId) ;
            this.target = Convert.ToInt32(targetId);
            this.value = Convert.ToInt32(count)
                ;
        }
    }

    public class Node {
        public string Name;
        public string Category;
        public string Id;
        public int Count;

        public Node (string name, string category, string id) {
            Name = name;
            Category = category;
            Id = id;

            Count = 1;
        } 
        public string Key () {
            return Name + Category;
        }
        public NodeJson NodeJson() {
            return new NodeJson(
                Name
                , Category
                , Count.ToString()
            );
        }
    }
    

    public class Link {
        public Node SourceNode;
        public Node TargetNode;
        public int Count;

        public Link(Node sourceNode, Node targetNode) {
            SourceNode = sourceNode;
            TargetNode = targetNode;
            Count = 1;
        }
        public string Key() {
            return SourceNode.Key() + TargetNode.Key();
        }
        public LinkJson LinkJson() {
            return new LinkJson(
                SourceNode.Id
                , TargetNode.Id
                , Count.ToString()
            );
        }
    }

    public class NodesAndLinks {
        public List<NodeJson> nodes;
        public List<LinkJson> links;
        public NodesAndLinks(List<NodeJson> nodes, List<LinkJson> links) {
            this.nodes = nodes;
            this.links = links;
        }
    }


    public class Lobbyists {

        private static Dictionary<string, Node> nodes;
        private static Dictionary<string, Link> links;

        public static void Import(string path) {

            nodes = new Dictionary<string, Node>();
            links = new Dictionary<string, Link>();

            MakeNodesAndLinks();
            MakeJson(path);

            Console.WriteLine("Nodes: " + nodes.Count().ToString());
            Console.WriteLine("Links: " + links.Count().ToString());
            Console.ReadLine();
        }

        public static void MakeNodesAndLinks() {
            var reader = Util.Query("SELECT * FROM LobbyistView WHERE AgencyID = 63");  // 46
            while (reader.Read()) {
                var client = AddNode(reader["Client"].ToString(), "Client");
                var firm = AddNode(reader["Firm"].ToString(), "Firm");
                var staffer = AddNode(reader["Staffer"].ToString(), "Staffer");

                AddLink(client, firm);
                AddLink(firm, staffer);
            }
        }

        private static void MakeJson(string path) {
            
            var nodeList = new List<NodeJson>();
            foreach (Node node in nodes.Values)
                nodeList.Add(node.NodeJson());

            List<LinkJson> linkJsons = new List<LinkJson>();
            foreach (Link link in links.Values) {
                linkJsons.Add(link.LinkJson());
            }

            var data = new NodesAndLinks(nodeList, linkJsons);

            string json = JsonConvert.SerializeObject(data);
            var niceJson = Newtonsoft.Json.Linq.JToken.Parse(json).ToString();
            
            System.IO.File.WriteAllText(path + "lobbyists.json", niceJson);
        }
        

        private static Node AddNode(string name, string category) {
            if (nodes.ContainsKey(name + category)) {
                nodes[name + category].Count++;
            } else {
                var node = new Node(name, category, nodes.Count.ToString());
                nodes.Add(node.Key(), node);
            }
            return nodes[name + category];
        }

        private static void AddLink(Node source, Node target) {
            var key = source.Key() + target.Key();

            if (links.ContainsKey(key)) {
                links[key].Count++;
            } else {
                var link = new Link(source, target);
                links.Add(key, link);
            }
        }
    }
}
