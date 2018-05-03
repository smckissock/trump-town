"use strict"

queue()
    .defer(d3.json, "data/network/lobbyists.json")
    .await(setup);

function setup(error, data) {
    console.log(data);

    const categories = ['Client', 'Agency', 'Staffer'];
    // Green, orange, purple
    const colors = ['#1b9e77', '#d95f02', '#7570b3'];
    const dasheses = [
        {name: 'solid', ray: null},
        {name: 'dash', ray: [5,5]},
        {name: 'dot', ray: [1,5]},
        {name: 'dot-dash', ray: [15,10,5,10]}
    ];

    data.nodes.forEach(d => d.color = categories.indexOf(d.category));

    const diagram = dc_graph.diagram('#graph');

    const engine = dc_graph.spawn_engine("cola", {}, false);
    //apply_engine_parameters(engine);
    

    diagram
        .layoutEngine(engine)
        .timeLimit(5000)
        .transitionDuration(1000)
        .restrictPan(true)
        .margins({top: 5, left: 5, right: 5, bottom: 5})
        .autoZoom('once-noanim')
        .zoomDuration(1000)
        .altKeyZoom(true)
        .width(null)
        .height(null)
        .nodeFixed(function(n) { return n.value.fixed; })
        .nodeStrokeWidth(0) // turn off outlines
        .nodeLabel(function(v) { 
            return v.value.name; })
        //.nodeLabelFill(function(n) {
        //    var rgb = d3.rgb(diagram.nodeFillScale()(diagram.nodeFill()(n))),
                // https://www.w3.org/TR/AERT#color-contrast
        //        brightness = (rgb.r * 299 + rgb.g * 587 + rgb.b * 114) / 1000;
        //    return brightness > 127 ? 'black' : 'ghostwhite';
        //})
        .nodeFill(kv => kv.value.color)
        .nodeOpacity(0.75)
        .edgeOpacity(0.25)
        .timeLimit(1000)
        .nodeFillScale(d3.scale.ordinal().domain([0,1,2]).range(colors))
        .nodeTitle(dc.pluck('code'))
        .edgeStrokeDashArray(e => dasheses[e.value.dash].ray)
        //.edgeArrowhead(sync_url.vals.arrows === 'head' || sync_url.vals.arrows === 'both' ? 'vee' : null)
        //.edgeArrowtail(sync_url.vals.arrows === 'tail' || sync_url.vals.arrows === 'both' ? 'crow' : null)

    const edgef = dc_graph.flat_group.make(data.edges, d => d.code);
    const nodef = dc_graph.flat_group.make(data.nodes, d => d.code);

    const nodeDimension = nodef.crossfilter.dimension( n => n.name);
    const nodeGroup = nodeDimension.group();

    const row = dc.rowChart('#bars')
        .width(280).height(1200)
        .ordinalColors(colors)
        .colorAccessor(d => nodeColor(d.key, data.nodes))
        .dimension(nodeDimension)
        .group(nodeGroup);
        //.label(kv => dasheses[kv.key].name)
        
    diagram
        .nodeDimension(nodef.dimension).nodeGroup(nodef.group)
        .edgeDimension(edgef.dimension).edgeGroup(edgef.group)    
        .edgeSource(kv => kv.value.source)
        .edgeTarget(kv => kv.value.target)
        .child('validate', dc_graph.validate()); 
    
    dc.renderAll();
}

function nodeName(d) {
    return d;
}

function nodeColor(nodeName, nodes) {
    let node = nodes.filter(node => node.name == nodeName);
    console.log(node[0].category + " : " + node[0].name + " : " + node[0].color);
    
    // This returns the correct index, but colors for 0 and 1 are reversed!!  
    return node[0].color;
    //return categories.indexOf(node[0].category);
}