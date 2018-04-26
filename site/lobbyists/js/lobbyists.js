"use strict"


queue()
    .defer(d3.json, "site/lobbyists/data/agencies.json")
    .await(setup);

function setup(error, agencyList) {
    drawBars(agencyList);
    resetSankey(agencyList[0]);
}

var tipNodes = d3.tip()
    .attr('class', 'd3-tip d3-tip-nodes')
    .offset([-10, 0]);

function drawBars(agencyList) {

    const margin = {
        top: 20, right: 30, bottom: 6, left: 1
    };

    const totalWidth = 200;
    const totalHeight = 850; 

    const width = totalWidth - margin.left - margin.right;
    const height = totalHeight - margin.top - margin.bottom;

    const barHeight = 18;
    
    const svg = d3.select("#bars")
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    agencyList.sort((a, b) => b.lobbyists - a.lobbyists);
      
    
    svg.selectAll("rect")
        .data(agencyList)
        .enter()
        .append("rect")
        .attr("x", 0)
        .attr("width", d => d.lobbyists * 10)
        .attr("y", (d, i) => (i * barHeight) - barHeight - 1)
        .attr("height", barHeight - 4)
        .style("fill", "lightblue")
        .attr("cursor", "pointer")
        .on("click", d => resetSankey(d));

    svg.selectAll("text")
        .data(agencyList)
        .enter()
        .append("text")
        .text(d => d.agency + " " + d.lobbyists)
        .attr("x", 4)
        .attr("y", (d, i) => (i * barHeight) - 8)
        .attr("font-family", "sans-serif")
        .attr("font-size", "10px")
        .attr("cursor", "pointer")
        .on("click", d => resetSankey(d))
        .on("mouseover", d => d3.select(this).attr("font-weight", "bold"))
        .on("mouseout", d => d3.select(this).attr("font-weight", "normal"));
}

function resetSankey(agency) {
    d3.select("#agencyName")
        .text(agency.agency);

    d3.select("#chart")
        .select("svg")
        .remove();

    d3.json("site/lobbyists/data/" + agency.id + ".json", (err, data) => drawSankey(data));
}

function drawSankey(data) {
    const pct = d3.format(",.1%");

    const margin = {
        top: 20, right: 30, bottom: 6, left: 1
    };

    const nodeHeight = 30;

    const totalWidth = 750; 
    const totalHeight = nodeHeight * data.nodeCount;  

    const width = totalWidth - margin.left - margin.right;
    const height = totalHeight - margin.top - margin.bottom;

    const colors = ['#bd9e39', '#637939', '#ad494a'];

    const color = d3.scale.ordinal()
        .domain(['Client', 'Firm', 'Staffer'])
        .range(colors);

    // #bd9e39 gold


    const formatNumber = d3.format(",.0f");
    const format = d => formatNumber(d);

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


    var popup = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

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
        .text(d => d.source.name + " → " + d.target.name);

    var node = svg.append("g").selectAll(".node")
        .data(data.nodes)
        .enter().append("g")
        .attr("class", "node")
        .attr("transform", d => "translate(" + d.x + "," + d.y + ")")
        .on('mouseover', d => showNodePopup(d))
        .on('mouseout', () => hideNodePopup())
        .call(d3.behavior.drag()
            .origin(function (d) { return d; })
            .on("dragstart", function () { this.parentNode.appendChild(this); })
            .on("drag", dragmove));

    node.append("rect")
        .attr("height", d => d.dy)
        .attr("width", sankey.nodeWidth())
        .style("fill", d => color(d.category))
        .append("title")
        .text(d => d.name);

    node.append("text")
        .attr("x", 3 + sankey.nodeWidth())
        .attr("y", d => (d.dy / 2) + 4)
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

    function showNodePopup(d) {
        popup.transition()
            .duration(100)
            .style("opacity", 1.0);
        popup.html(d.name)
            .style("left", (d3.event.pageX) + "px")
            .style("top", (d3.event.pageY - 28) + "px");	
    }

    function hideNodePopup() {
        popup.transition()
            .duration(200)
            .style("opacity", 0);
    }
}   


