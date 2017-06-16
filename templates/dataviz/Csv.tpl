{crmTitle string="$id"}

<div class="row">

<table id="t" class="table table-striped table-bordered" cellspacing="0" width="100%"></table>

<script>
var data = {crmSQL file="$id" debug=1};
if (data.is_error) {
  CRM.alert("error in the sql query:"+data.error_message);
}
var dtable=null;

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

function drawDataTable(dom) {
  var columns=[];
  d3.keys(data.values[0]).forEach(function(d){
    var r={};
    r.data=d;
    r.title=d.replace(/_/g, ' ');
    columns.push(r);
  });

  var table=$(dom)
  .on( 'init.dt', function () {
    $(dom+"_filter").removeClass("dataTables_filter");
  })
  .DataTable({
   dom: "<'row'<'col-md-2'l><'col-md-3'i><'col-md-4'B><'col-md-3'f>>" +
"<'row'<'col-md-12'rt>><'row'<'col-md-12 footer'ip>>", //'Blfrtip',
   "pageLength": 50,
  "lengthMenu": [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
   buttons: [ 'excel','copy','colvis','csv'],
    colReorder: true,
    stateSave: true,
    responsive: false,
    order: [],
    data:data.values,
    columns:columns
  });

  $(dom).append('<tfoot></tfoot>');
  $tfoot = $('tfoot', dom);
  table.columns().every( function(colIndex) {
    $tfoot.append('<th></th>');
    var first = this.data()[0];
    if (!isNaN(first)) {
      var sum = this.data().reduce( function(a,b) {
          return a + b;
      });
 
      if (!isNaN(sum)) {
        if (parseInt(sum) != sum) {
          sum = parseFloat(sum).toFixed(2);
        }
        $('th', $tfoot).eq(colIndex).html( "Global sum: " + sum );
      }
    }
  });
  return table;
}

  dtable=drawDataTable("#t");
});
</script>

<style>
.clear {clear:both;}

</style>
{/literal}
