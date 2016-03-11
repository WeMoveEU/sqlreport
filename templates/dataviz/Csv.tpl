{crmTitle string="CSV export $id"}


<div class="row">
<button class'btn btn-primary btn-lg'><span class="glyphicon glyphicon-download-alt"></span><span id='csv'>CSV</span></button>
<table class="table table-striped" id="table">
<thead><tr>
</tr></thead>
<tbody>
</tbody>
</table>


<script>
var data = {crmSQL file="$id" debug=1};
if (data.is_error) {
  CRM.alert("error in the sql query:"+data.error_message);
}

{literal}
var ndx  = crossfilter(data.values)
  , all = ndx.groupAll();

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

var totalCount = dc.dataCount("#datacount")
      .dimension(ndx)
      .group(all);

function cell(d,i) {
  return d[i];
}

function drawTable(dom) {
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

  drawTable("#table");
 // dc.renderAll();
});
</script>

<style>
.clear {clear:both;}

</style>
{/literal}
