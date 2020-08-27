{crmTitle string="Contributions coming from mailings"}
<h1><span id="totalQty"></span> contributions for a total of <span id="totalAmount"></span> (avg. <span id="totalAvg"></span>)</h1>


<div class="row">
<div class="col-md-12" id="mailingtable">
</div>
<script>
    'use strict';

    var data = {crmSQL file="WMEMailingContribute"};
    var i = {crmAPI entity="OptionValue" option_group_id="10"}; {*todo on 4.4, use the payment_instrument as id *}

    {literal}
        if(!data.is_error){
            var instrumentLabel = {};
            i.values.forEach (function(d) {
                instrumentLabel[d.value] = d.label;
            });

            var numberFormat = d3.format(".2f");
            var volumeChart=null,dayOfWeekChart=null,moveChart=null,pieinstrument,pietype;  


            cj(function($) {
                var dateFormat = d3.timeFormat("%Y-%m-%d");
                var dateTimeFormat= d3.timeFormat("%Y-%m-%d %H:%M:%S");
                //data.values.forEach(function(d){data.values[i].dd = new Date(d.receive_date)});

                data.values.forEach(function(d){d.dd = dateTimeFormat.parse(d.date)});
                var min = d3.min(data.values, function(d) { return d.dd;} );
                var max = d3.max(data.values, function(d) { return d.dd;} );
                var ndx                 = crossfilter(data.values),
                all = ndx.groupAll();

drawNumbers();
//                drawType();
//                drawTable('#table');
//                drawInstrument();
//                drawAmount('#amountg .graph');
//                drawDump();
drawMailingTable('#mailingtable');

                dc.renderAll();
                //  pietype.render();

function drawMailingTable(dom) {

var dim = ndx.dimension(function (d) {return [d.m_id,d.name];});
  var group = dim.group().reduceSum(function(d) { return d.amount; });
console.log(group.top(19));
//  var graph=dc.dataGrid(dom).dimension(dim).group(group).html(function(d) {
//    console.log(d);
//  });
};


function drawNumbers (){
  var average = function(d) {
      return d.qty ? d.total / d.qty : 0;
  };

  var group = ndx.groupAll().reduce(
          function (p, v) {
              p.qty++;
              p.total += v.amount;
              return p;
          },
          function (p, v) {
              p.qty--;
              p.total -= v.amount;
              return p;
          },
          function () { return {qty:0,total:0}; }
      );

      dc.numberDisplay("#totalAvg") 
      .valueAccessor(average)
      .html({
        some:"%number",
        none:"no mandate"
      })
      .group(group);

      dc.numberDisplay("#totalQty") 
      .valueAccessor(function(d){ return d.qty})
      .html({
        some:"%number",
        none:"no mandate"
      })
      .group(group);

      dc.numberDisplay("#totalAmount") 
      .valueAccessor(function(d){ return d.total})
      .html({
        some:"%number€",
        none:""
      })
      .group(group);
}

function drawDataTable(dom) {
  var columns=[];
  d3.keys(data.values[0]).forEach(function(d){
    var r={};
    r.data=d;
    r.title=d.replace(/_/g, ' ');
    columns.push(r);
  });

  $(dom)
  .on( 'init.dt', function () {
    $(dom+"_filter").removeClass("dataTables_filter");
  })
  .DataTable({
   dom: "<'row'<'col-md-2'l><'col-md-3'i><'col-md-4'B><'col-md-3'f>>" +
"<'row'<'col-md-12'rt>><'row'<'col-md-12'ip>>", //'Blfrtip',
   "pageLength": 50,
  "lengthMenu": [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
   buttons: [ 'excel','copy','colvis'],
    colReorder: true,
    stateSave: true,
    responsive: false,
    order: [],
    data:data.values,
    columns:columns
  });
}

function drawAmount(dom) {
  var graph = dc.barChart(dom);
  var dim = ndx.dimension(function (d) {return d.amount;});
  var group = dim.group().reduceSum(function(d) { return 1; });
  graph.width(200)
                    .height(200)
                    .centerBar(true)
                    .gap(1)
                    .x(d3.scaleLinear().domain([0, 100]))
//                    .round(d3.timeMonth.round)
//                    .xUnits(d3.timeMonths);
                    .margins({top: 20, left: 40, right: 10, bottom: 20})
                    .group(group)
                    .dimension(dim)
                    .ordinalColors(["#d95f02","#1b9e77","#7570b3","#e7298a","#66a61e","#e6ab02","#a6761d"]);
  graph.yAxis().ticks(10, ",.0f").tickSize(5, 0);
  return graph;
}

function drawDump () {
                volumeChart = dc.barChart("#monthly-volume-chart");
                dayOfWeekChart = dc.rowChart("#day-of-week-chart");
                moveChart = dc.lineChart("#monthly-move-chart");
                var byMonth     = ndx.dimension(function(d) { return d3.timeMonth(d.dd); });
                var byDay       = ndx.dimension(function(d) { return d.dd; });
                var volumeByMonthGroup  = byMonth.group().reduceSum(function(d) { return d.count; });
                var totalByDayGroup     = byDay.group().reduceSum(function(d) { return d.total; });

                var dayOfWeek = ndx.dimension(function (d) { 
                    var day = d.dd.getDay(); 
                    var name=["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
                    return day+"."+name[day]; 
                }); 


                var group=ndx.groupAll().reduce(
                    function(a, d) { 
                        a.total += d.total; 
                        a.count += d.count; 
                        return a;
                    },
                    function(a, d) { 
                        a.total -= d.total; 
                        a.count -= d.count; 
                        return a; 
                    },
                    function() { 
                        return {total:0, count:0};
                    }
                );

                var contribND   = dc.numberDisplay("#nbcontrib")
                    .group(group)
                    .valueAccessor(function (d) {
                    return d.count;})
                    .formatNumber(d3.format("3.3s"));

                var amountND    = dc.numberDisplay("#amount")
                    .group(group)
                    .valueAccessor(function(d) {return d.total});



                var dayOfWeekGroup = dayOfWeek.group(); 
                
                dayOfWeekChart.width(300)
                    .height(220)
                    .margins({top: 20, left: 10, right: 10, bottom: 20})
                    .group(dayOfWeekGroup)
                    .dimension(dayOfWeek)
                    .ordinalColors(["#d95f02","#1b9e77","#7570b3","#e7298a","#66a61e","#e6ab02","#a6761d"])
                    .label(function (d) {
                        return d.key.split(".")[1];
                    })
                    .title(function (d) {
                        return d.value;
                    })
                    .elasticX(true)
                    .xAxis().ticks(4);



                //.round(d3.timeMonth.round)
                //.interpolate('monotone')
                moveChart.width(850)
                    .height(200)
                    .transitionDuration(1000)
                    .margins({top: 30, right: 50, bottom: 25, left: 40})
                    .dimension(byDay)
                    .mouseZoomable(true)
                    .x(d3.scaleTime().domain([min,max]))
                    .xUnits(d3.timeMonths)
                    .elasticY(true)
                    .renderHorizontalGridLines(true)
                    .legend(dc.legend().x(800).y(10).itemHeight(13).gap(5))
                    .brushOn(false)
                    .rangeChart(volumeChart)
                    .group(totalByDayGroup)
                    .valueAccessor(function (d) { 
                        return d.value;
                    })
                    .title(function (d) {
                        var value = d.value;
                        if (isNaN(value)) value = 0;
                        return dateFormat(d.key) + "\n" + numberFormat(value);
                    });

                volumeChart.width(850)
                    .height(200)
                    .margins({top: 0, right: 50, bottom: 20, left:40})
                    .dimension(byMonth)
                    .group(volumeByMonthGroup)
                    .centerBar(true)
                    .gap(1)
                    .x(d3.scaleTime().domain([min, max]))
                    .round(d3.timeMonth.round)
                    .xUnits(d3.timeMonths);


}

function drawTable(dom) {
  var dim = ndx.dimension(function(d) {return d.date;});

  var graph=dc.dataTable(dom)
    .dimension(dim)
    .group(function(d) {
        return d.date.substr(0, 10);//dateFormat(d.dd);
    })
    .sortBy(function (d) { return d.key })
    .order(d3.descending)
    .size(9999)
    .columns([function(d){return "<a href='/civicrm/contact/view?cid="+d.contact_id+"' title='view the contact' target='_blank'>&#x1F60D;</a>"},
              function(d){ return d.status_id},
              function(d){ return d.amount +" "+d.currency},
              function(d){return d.created_age},
              function(d){return d.instrument},
              function(d){return d.utm_campaign},
              function(d){return d.utm_medium},
              function(d){return d.utm_source},
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


function drawType() {
                pietype = dc.pieChart("#type").innerRadius(20).radius(90);
                var type        = ndx.dimension(function(d) {return d.financial_type;});
                var typeGroup   = type.group().reduceSum(function(d) { return 1; });
                pietype
                    .width(200)
                    .height(200)
                    .dimension(type)
                    .colors(d3.scaleOrdinal(d3.schemeCategory10))
                    .group(typeGroup);

   return pietype;
}
function drawInstrument () {
                pieinstrument = dc.pieChart("#instrument").innerRadius(50).radius(90);
                var instrument        = ndx.dimension(function(d) {return d.instrument;});
                var instrumentGroup   = instrument.group().reduceSum(function(d) { return 1; });
                pieinstrument
                    .width(200)
                    .height(200)
                    .dimension(instrument)
                    .group(instrumentGroup)
/*                    .title(function(d) {
                        return instrumentLabel[d.key]+":"+d.value;
                    })
                    .label(function(d) {
                        return instrumentLabel[d.key];
                    })
*/
;	   

   return pieinstrument;
}

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

            });//end cj
        }
        else{
            cj('.eventsoverview').html('<div style="color:red; font-size:18px;">Civisualize Error. Please contact Admin.'+data.error+'</div>');
        }

    {/literal}
</script>
<div class="clear"></div>
