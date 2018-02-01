{crmTitle string="sepa mandates"}

<h1><span id="totalQty"></span> (<span id="totalOOFF"></span> <span id="totalRCUR"></span>)</h1>

<div class="row">
<div id="type" class="col-md-2">
    <strong>Type</strong>
    <a class="reset" href="javascript:graphs.type.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <div class="graph"></div>
</div>

<div id="status" class="col-md-2">
    <strong>Status</strong>
    <a class="reset" href="javascript:graphs.status.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <div class="graph"></div>
</div>

<div id="country" class="col-md-8">
    <strong>Country</strong>
    <a class="reset" href="javascript:graphs.country.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <div class="graph"></div>
</div>
</div>

<div class="row">
    <div id="monthly-move-chart" class="col-md-6">
        <strong>Mandates by month</strong>
        <span class="reset" style="display: none;">range: <span class="filter"></span></span>
        <a class="reset" href="javascript:graphs.month.filterAll();dc.redrawAll();"
style="display: none;">reset</a>
    <div class="graph"></div>
    </div>
</div>

<div id="monthly-volume-chart" class="col-md-6">
        <strong>Volumne by month</strong>
        <span class="reset" style="display: none;">range: <span class="filter"></span></span>
        <a class="reset" href="javascript:graphs.month.filterAll();dc.redrawAll();"
style="display: none;">reset</a>
    <div class="graph"></div>
</div>

</div>


<div class="row">
<button class'btn btn-primary btn-lg'><span class="glyphicon glyphicon-download-alt"></span><span id='csv'>CSV</span></button>
<table class="table table-striped" id="table">
<thead><tr>
<th>type</th>
<th>status</th>
<th>qty</th>
<th>amount</th>
<th>average</th>
</tr></thead>
<tbody>
</tbody>
</table>

<div class="row">
  <div></div> 
</div>
<script>
    'use strict';
var data = {crmSQL file="Sepa" debug=1};
{literal}
if (data.is_error) {
  CRM.alert("error in the sql query:"+data.error_message);
}

var ndx  = crossfilter(data.values)
  , all = ndx.groupAll()
  , graphs = {};

cj(function($){

function toCsv (dom,array) {

  var str = '';

  var line = '';
  for (var index in array[0]) {
    if (line != '') line += ','
    line += index;
  }
  var str = line + '\r\n';

  for (var i = 0; i < array.length; i++) {
    var line = '';
    for (var index in array[i]) {
      if (line != '') line += ','
      line += array[i][index];
    }
    str += line + '\r\n';
  }
   

  var data = "text/csv;charset=utf-8," + encodeURIComponent(str);
  $(dom).html('<a href="data:' + data + '" download="data.csv">Download</a>');
} 


function cell(d,i) {
  return d[i];
}

function drawNumbers (){
  var group = ndx.groupAll().reduce(
          function (p, v) {
              p.qty +=v.qty;
              if (v.type == "OOFF")
                p.ooff += v.total
              else 
                p.rcur += v.total

              p.total += v.total;
              return p;
          },
          function (p, v) {
              p.qty -= v.qty;
              p.total -= v.total;
              if (v.type == "OOFF")
                p.ooff -= v.total
              else 
                p.rcur -= v.total
              return p;
          },
          function () { return {qty:0,total:0, ooff:0, rcur:0}; }
      );

      dc.numberDisplay("#totalQty") 
      .valueAccessor(function(d){ return d.qty})
      .html({
        one:"%number mandate",
        some:"%number SEPA mandates",
        none:"no mandate"
      })
      .group(group);

      dc.numberDisplay("#totalRCUR") 
      .valueAccessor(function(d){ return d.rcur})
      .html({
        some:"recurring %number€",
        none:""
      })
      .group(group);
      dc.numberDisplay("#totalOOFF") 
      .valueAccessor(function(d){ return d.ooff})
      .html({
        some:" one off %number€ & ",
        none:""
      })
      .group(group);
}

function drawCountry(dom) {
  var graph = dc.barChart(dom);
  var dim = ndx.dimension(function (d) {return d.country;});
  var group = dim.group().reduceSum(function(d) { return d.qty; });
  graph.width(500)
                    .height(130)
                    .centerBar(true)
                    .gap(1)
.x(d3.scale.ordinal()) // Need empty val to offset first value
.xUnits(dc.units.ordinal) 
//                    .round(d3.time.month.round)
//                    .xUnits(d3.time.months);
                    .margins({top: 10, left: 40, right: 10, bottom: 20})
                    .group(group)
                    .dimension(dim)
  graph.yAxis().ticks(5, ",.0f").tickSize(5, 0);
  return graph;
}
function drawType (dom) {
  var dim = ndx.dimension(function(d) {return d.type;});
  var group = dim.group().reduceSum(function(d) { return d.qty; });
  var graph = dc.pieChart(dom)
    .innerRadius(10).radius(50)
    .width(100).height(100)
    .dimension(dim).group(group)
    .colors(d3.scale.category10());
  return graph;
}

function drawStatus (dom) {
  var dim = ndx.dimension(function(d) {return d.status;});
  var group = dim.group().reduceSum(function(d) { return d.qty; });
  var graph = dc.pieChart(dom)
    .innerRadius(10).radius(50)
    .width(100).height(100)
    .dimension(dim).group(group)
    .colors(d3.scale.category10());
  return graph;
}
function drawDate (dom) {
  var graph = dc.barChart(dom);


}

function drawMonth() {
            var numberFormat = d3.format(".2f");
                //var graph = dc.lineChart("#monthly-move-chart");
                var graph = dc.compositeChart("#monthly-move-chart");
                var dateFormat = d3.time.format("%Y-%m-%d");
                //data.values.forEach(function(d){data.values[i].dd = new Date(d.receive_date)});

                data.values.forEach(function(d){d.dd = dateFormat.parse(d.date)});
                var min = d3.min(data.values, function(d) { return d.dd;} );
                var max = d3.max(data.values, function(d) { return d.dd;} );


                var dim     = ndx.dimension(function(d) { return d3.time.month(d.dd); });
                var groupRCUR   = dim.group().reduceSum(function(d) {
                   if (d.type != 'RCUR') return 0;
                   return d.qty; });
                var groupOOFF   = dim.group().reduceSum(function(d) { 
                   if (d.type != 'OOFF') return 0;
                   return d.qty; });


                //var byDay       = ndx.dimension(function(d) { return d.dd; });
//                var volumeByMonthGroup  = byMonth.group().reduceSum(function(d) { return d.qty; });
//                var totalByDayGroup     = byDay.group().reduceSum(function(d) { return d.total; });
                graph.width(850)
                    .height(200)
                    .transitionDuration(1000)
                    .margins({top: 30, right: 50, bottom: 25, left: 40})
                    .dimension(dim)
                    .mouseZoomable(true)
                    .x(d3.time.scale().domain([min,max]))
                    .xUnits(d3.time.months)
                    .elasticY(true)
                    .renderHorizontalGridLines(true)
                    .legend(dc.legend().x(800).y(10).itemHeight(13).gap(5))
                    .brushOn(false)
//                    .rangeChart(volumeChart)
                    .valueAccessor(function (d) { 
                        return d.value;
                    })
                    .compose([
                      dc.lineChart(graph).group(groupOOFF,"OOFF"),
                      dc.lineChart(graph).group(groupRCUR,"RCUR"),
                    ])
                    .title(function (d) {
                        var value = d.value;
                        if (isNaN(value)) value = 0;
                        return dateFormat(d.key) + "\n" + numberFormat(value);
                    });

  return graph;

}
function drawTable(dom) {
  var dim = ndx.dimension(function(d) {return d.date;});

  var graph=dc.dataTable(dom)
    .dimension(dim)
    .group(function(d) {
        return d.date;
    })
    .sortBy(function (d) { return d.key })
    .size(10000)
    .order(d3.descending)
    .columns([function(d){return d.type},
              function(d){ return d.status},
              function(d){ return d.qty},
              function(d){return d.total},
              function(d){return d.avg},
              function(d){return d.country}
             ])
    ;
/*              {
                  label: 'Date',
                  format: function(d) {
                      return '$' + d.Spent;
                  }
              },
              'Year',
              {
                  label: 'Percent of Total',
                  format: function(d) {
                      return Math.floor((d.Spent / allDollars.value()) * 100) + '%';
                  }
              }]);
*/
  toCsv('#csv',data.values );
  return graph;
}

function drawDirectTable(dom) {
  var i=0;
/*  var dim = ndx.dimension (function(d) {return i++;});
  i=0;
  toCsv('#csv',dim.top(Infinity) );

*/
 toCsv('#csv',data.values );
 
 var thead = d3.select("thead").selectAll("th")
  .data(d3.keys(data.values[0]))
  .enter().append("th").text(function(d){return d.replace(/_/g, ' ')});
  // fill the table
  // create rows
  var tr = d3.select("tbody").selectAll("tr")
  .data(data.values).enter().append("tr")
  // cells
  var td = tr.selectAll("td")
    .data(function(d){return d3.values(d)})
    .enter().append("td")
    .text(function(d) {return d})
/*
  var graph = dc.dataTable(dom)
    .dimension(dim)
    .group(function(d){ return ""; })
    .size(9999)
    .order(d3.descending)
    .columns(
	[
	    function (d) {return cell(d,"date");},
	    function (d) {return cell(d,"total");},
	]
    );

  return graph;
*/
}

  drawNumbers();
  graphs.country = drawCountry("#country .graph");
  graphs.type = drawType("#type .graph");
  graphs.status = drawStatus("#status .graph");
  graphs.table = drawTable("#table");
  graphs.month = drawMonth("#monthly-move-chart .graph");

  ["SENT","OOFF","FRST","RCUR"].forEach(function(d) {
    graphs.status.filter(d);
  });
  dc.renderAll();
});
</script>

<style>
.clear {clear:both;}

</style>
{/literal}
