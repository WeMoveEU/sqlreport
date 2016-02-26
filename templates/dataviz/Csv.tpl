{crmTitle string="CSV export $1"}


<div class="row">

<table class="table table-striped" id="table">
<thead><tr>
</tr></thead>
</table>



<script>
var data = {crmSQL file="$1" debug=1};

{literal}


var ndx  = crossfilter(data.values)
  , all = ndx.groupAll();

function toCsv (dom,array) {

  var str = '';

  var line = '';
  for (var index in array[0]) {
    if (line != '') line += ','
    line += index;
  }
  var str = line;

  for (var i = 0; i < array.length; i++) {
    var line = '';
    for (var index in array[i]) {
      if (line != '') line += ','
      line += array[i][index];
    }
    str += line + '\r\n';
  }
   

  var data = "text/csv;charset=utf-8," + encodeURIComponent(str);
  jQuery (dom).html('<a href="data:' + data + '" download="data.csv">Download</a>');
} 

var totalCount = dc.dataCount("#datacount")
      .dimension(ndx)
      .group(all);


function drawTable(dom) {
  var i=0;
  var dim = ndx.dimension (function(d) {return i++;});
  toCsv('#csv',dim.top(Infinity) ); 
return;
  var graph = dc.dataTable(dom)
    .dimension(dim)
    .size(9999)
    .order(d3.descending)
    .columns(
	[
	    function (d) {return "aa";},
	]
    );

  return graph;
}


drawTable("#table");

dc.renderAll();

</script>

<style>
.clear {clear:both;}

</style>
{/literal}
