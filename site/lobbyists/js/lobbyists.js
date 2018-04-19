
queue()
    .defer(d3.json, 'data/10.json')
    .defer(d3.json, 'data/agencies.json')
    .await(setup);

function setup(error, agency, agencyList) {
    drawSankey(agency);
}

function drawSankey(data) {
    const pct = d3.format(",.1%");

    const margin = {
        top: 20, right: 30, bottom: 6, left: 1
    };

    const nodeHeight = 30;

    const totalWidth = 700; // 700
    const totalHeight = nodeHeight * data.nodeCount;  // 600

    const width = totalWidth - margin.left - margin.right;
    const height = totalHeight - margin.top - margin.bottom;

    var colors = ['#1f77b4', '#bd9e39', '#ad494a', '#637939'];

    const formatNumber = d3.format(",.0f");
    const format = d => formatNumber(d);

    color = d3.scale.ordinal()
        .domain(['Client', 'Lobbying Firm', 'Lobbyist'])
        .range(colors);

    const svg = d3.select("#chart")
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    const sankey = d3.sankey()
        .nodeWidth(20)
        .nodePadding(25)
        .size([width - 150, height]);

    const path = sankey.link();

    sankey
        .nodes(data.nodes)
        .links(data.links)
        .layout(50);

    //sankey.extent([[0, 0], [600, 600]]);

    var link = svg.append("g").selectAll(".link")
        .data(data.links)
        .enter().append("path")
        .attr("class", "link")
        .attr("d", path)
        .style("stroke-width", function (d) { return Math.max(1, d.dy); })
        .sort(function (a, b) { return b.dy - a.dy; });

    link.append("title")
        .text(function (d) { return d.source.name + " → " + d.target.name; });

    var node = svg.append("g").selectAll(".node")
        .data(data.nodes)
        .enter().append("g")
        .attr("class", "node")
        .attr("transform", function (d) { return "translate(" + d.x + "," + d.y + ")"; })
        .call(d3.behavior.drag()
            .origin(function (d) { return d; })
            .on("dragstart", function () { this.parentNode.appendChild(this); })
            .on("drag", dragmove));

    node.append("rect")
        .attr("height", function (d) { return d.dy; })
        .attr("width", sankey.nodeWidth())
        .style("fill", function (d) { return color(d.category); })
        .append("title")
        .text(function (d) { return d.name; });

    node.append("text")
        .attr("x", 3 + sankey.nodeWidth())
        //.attr("y", function (d) { return (d.dy / 2) - 2; })
        .attr("y", function (d) { return (d.dy / 2) + 4; })
        .attr("text-anchor", "start")
        .attr("fill", "#404040")
        .attr("font-size", "10px")
        //.attr("font-weight", "bold")
        .text(d => d.name);

    //node.append("text")
    //    .attr("x", 8 + sankey.nodeWidth())
    //    .attr("y", function (d) { return (d.dy / 2) + 12; })
    //    .attr("text-anchor", "start")
    //    .attr("font-size", 11)
    //    .attr("fill", "grey")
    //    .text(function (d) {
    //        if (d.amount)
    //            return d.amount + "  (" + pct(+d.amount / 2600) + ")";
    //    });

    function dragmove(d) {
        d3.select(this)
            .attr("transform", "translate(" + (
                d.x = Math.max(0, Math.min(width - d.dx, d3.event.x))
            ) + "," + (d.y = Math.max(0, Math.min(height - d.dy, d3.event.y))) + ")");
        sankey.relayout();
        link.attr("d", path);
    }
}