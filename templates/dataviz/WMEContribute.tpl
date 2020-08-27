{crmTitle string="Contributions"}
<h1><span id="totalQty"></span> contributions for a total of <span id="totalAmount"></span> (avg. <span id="totalAvg"></span>) since a month ago</h1>
	<div class="row">
        <div id="lang" class="col-md-3">
          <div class="panel panel-default compact"><div class="panel-heading">Lang</div>
          <div class="panel-body"> <div class="graph"><graph /></div></div></div>
        </div>

	<div id="date" class="col-md-9"><div class="panel panel-default"><div class="panel-heading">Date

	<div class="btn-group" id="btn-date"></div>

	</div>
	<div class="panel-body"> <div class="graph"></div></div></div>
	</div>
	</div>
<div class="row">
<div id="recur" class="col-md-3">
          <div class="panel panel-default compact"><div class="panel-heading">Recurring
             <a class="reset" href="javascript:graphs.recur.filterAll();dc.redrawAll();" style="display: none;">reset</a>
          </div>
          <div class="panel-body"> <div class="graph"><graph /></div></div></div>
</div>

<div id="status" class="col-md-3">
    <strong>Status</strong>
    <a class="reset" href="javascript:graphs.recur.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <graph />
    <div class="clearfix"></div>
</div>

<div id="contact_type" class="col-md-4 hidden">
    <strong>Type</strong>
    <a class="reset" href="javascript:pietype.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <div class="clearfix"></div>
</div>

<div id="instrument" class="col-md-3">
    <strong>Payment instrument</strong>
    <a class="reset" href="javascript:pieinstrument.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <div class="clearfix"></div>
</div>

<div id="amountg" class="col-md-3">
			<div class="panel-heading" title="Campaigns"><input id="input-filter" placeholder="Campaign"/></div>

    <strong>Donations by amount</strong>
    <a class="reset" href="javascript:dayOfWeekChart.filterAll();dc.redrawAll();" style="display: none;">reset</a>
    <div class="graph"></div>
</div>
</div>

<div class="row clear">
    <div id="monthly-move-chart">
        <strong>Amount by month</strong>
        <span class="reset" style="display: none;">range: <span class="filter"></span></span>
        <a class="reset" href="javascript:moveChart.filterAll();volumeChart.filterAll();dc.redrawAll();"
style="display: none;">reset</a>
        <div class="clearfix"></div>
    </div>
</div>

<div id="monthly-volume-chart"></div>

<div class="row">
<div class="col-md-12">
<button class'btn btn-primary btn-lg'><span class="glyphicon glyphicon-download-alt"></span><span id='csv'>CSV</span></button>
<table class="table table-striped" id="table">
<thead><tr>
<th>Donor</th>
<th>status</th>
<th>amount</th>
<th>since (days)</th>
<th>Campaign</th>
<th>Medium</th>
<th>Source</th>
</tr></thead>
<tbody>
</tbody>
</table>
</div>
</div>
<script>
    'use strict';

    var data = {crmSQL file="WMEContribute"};
    var mailings = {crmSQL file="WMMailingCampaign"};
    var i = {crmAPI entity="OptionValue" option_group_id="10"};
    var statuses = {crmAPI entity="OptionValue" option_group_id="11"};

    {literal}
	  jQuery.urlParam = function(name, value){
            if (arguments.length == 2) {
              name = encodeURIComponent(name); value = encodeURIComponent(value);

              var s = document.location.search;
              var kvp = name+"="+value;

              var r = new RegExp("(&|\\?)"+name+"=[^\&]*");

              s = s.replace(r,"$1"+kvp);

              if(!RegExp.$1) {s += (s.length>0 ? '&' : '?') + kvp;};
              
              history.pushState({"name":value},"filter on "+value, window.location.pathname + s);
              return s;
            }

	    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
	    if (results==null){
	       return null;
	    }
	    else{
	       return decodeURI(results[1]) || 0;
	    }
	};
    var graphs={};

        if(!data.is_error){
            var instrumentLabel = {};
            var statusLabel = {};
            var _getMailing = {};
            mailings.values.forEach(function(d,i){
              _getMailing[d.id]=i;
            });

            var getMailing = function(id){
              return mailings.values[_getMailing[+id]];
            };

            i.values.forEach (function(d) {
                instrumentLabel[d.value] = d.label;
            });

            statuses.values.forEach (function(d) {
                statusLabel[d.value] = d.label;
            });
            data.values.forEach(function(d){
              if (d.utm_source.indexOf("civimail-") == 0){
                var m= getMailing(d.utm_source.substring(9));
                if (!m) return;
                d.campaign_id = m.campaign_id;
                d.mailing = m.name;
              }
            });

            var numberFormat = d3.format(".2f");
            var volumeChart=null,dayOfWeekChart=null,moveChart=null,pieinstrument,pietype;  
var pastel2= ["#fbb4ae","#b3cde3","#ccebc5","#decbe4","#fed9a6","#ffffcc","#e5d8bd","#fddaec","#f2f2f2"];
var colorType = d3.scaleOrdinal().range(pastel2);


            cj(function($) {
                var dateFormat = d3.timeFormat("%Y-%m-%d");
                var dateTimeFormat= d3.timeFormat("%Y-%m-%d %H:%M:%S");
	      $(".crm-container").removeClass("crm-container");
                //data.values.forEach(function(d){data.values[i].dd = new Date(d.receive_date)});

                data.values.forEach(function(d){d.dd = dateTimeFormat.parse(d.date)});
                var min = d3.min(data.values, function(d) { return d.dd;} );
                var max = d3.max(data.values, function(d) { return d.dd;} );
                var ndx                 = crossfilter(data.values),
                all = ndx.groupAll();

drawNumbers();
//                drawType();
                graphs.table=drawTable('#table');
                graphs.instrument=drawInstrument();
                graphs.amount=drawAmount('#amountg .graph');
                graphs.recur=drawRecur('#recur graph');
                graphs.status=drawStatus('#status graph');
                graphs.lang=drawLang('#lang .graph');
                graphs.date= drawDate('#date .graph');
  		graphs.search = drawTextSearch('#input-filter');
                graphs.btn_date = drawDateButton("#date .btn-group",graphs.date);
//                drawDump();

                dc.renderAll();
                //  pietype.render();

function drawTextSearch (dom) {
  var dom=dom; //so it's accessible in inner functions

  var dim = ndx.dimension(function(d) { 
       return d.utm_source.toLowerCase() 
       + (d.mailing ? " " + d.mailing.toLowerCase() : "")
       || "?"
     });

	function debounce(fn, delay) {
		var timer = null;
		return function () {
			var context = this, args = arguments;
			clearTimeout(timer);
			timer = setTimeout(function () {
				fn.apply(context, args);
			}, delay);
		};
	}

  d3.select(dom).on("keyup",debounce (function () {
    var s= d3.select(this).property("value").toLowerCase();
    dim.filterAll();
    dim.filterFunction(function (d) { return d.indexOf (s) !== -1;} );
    jQuery.urlParam("name",s);
    dc.redrawAll();
  },250));

  (function () {
    var s= jQuery.urlParam("name");
    if (!s) return;
    d3.select(dom).property("value",s);
    dim.filterFunction(function (d) { return d.indexOf (s) !== -1;} );
  })();
  return dim;

}

function drawDateButton(dom, graph) {
var data = [
    { key: "today", label: "Today" },
    { key: "yesterday", label: "Yesterday" },
    { key: "1", label: "Last 24h" },
    { key: "7", label: "Last 7 days" },
    { key: "month", label: "This month" },
    { key: "future", label: "Planned" }
];
  d3.select(dom)
    .selectAll("button")
    .data(data)
    .enter()
    .append ("button")
    .text(function (d) {return d.label})
    .classed("btn",true)
    .classed("btn-default",true)
    .on("click", function () {
       var btn=d3.select(this);
       d3.selectAll(dom +" .active").classed("active", false);
       btn.classed("active",true);
	    var s = new Date(), e = new Date();
	    switch (btn.data()[0].key) {
	      case "today":
		s = d3.timeDay.utc(e);
		break;
	      case "yesterday":
		e = d3.timeDay.utc(s);
		s = d3.timeDay.utc.offset(e, -1);
		break;
	      case "week":
		s = d3.timeMonday.utc(e);
		break;
	      case "future":
	        e = Number.POSITIVE_INFINITY;
		break;
	      case "month":
		s = d3.timeMonth.utc(e);
		break;
	      default:
		s = d3.timeDay.offset(e, - + btn.data()[0].key);
	    }

	    graph.filterAll(); //reset filter
	    graph.filter(dc.filters.RangedFilter(s,e));
	    graph.redrawGroup();
    });


}

function drawDate (dom) {
  var dim = ndx.dimension(function(d){
    return d3.timeDay.utc(d.dd);
  });
  var group = dim.group().reduceSum(function(d){return d.amount;});

  //var graph=dc.lineChart(dom)
  var graph=dc.compositeChart(dom)
   .margins({top: 0, right: 50, bottom: 20, left:30})
    .height(150)
    .width(0)
    .dimension(dim)
    .brushOn(true)
    .mouseZoomable(false)
    .renderHorizontalGridLines(true)
    .title (function(d) {return dateFormat(d.key)+": "+d.value+" amount"})
    .x(d3.scaleUtc().domain([dim.bottom(1)[0].dd,dim.top(1)[0].dd]))
    .round(d3.timeDay.utc.round)
    .elasticY(true)
    .xUnits(d3.timeDays.utc);

    function line (group,name) {
      return dc.lineChart(graph)
       .group(group)
//       .colors(colorType)
//       .colorAccessor(function () { return name})
       .ordinalColors(["orange"])
       .title (function(d) {return dateFormat(d.key)+": "+d.value+" donations"})
       .renderDataPoints({radius: 1, fillOpacity: 0.8, strokeOpacity: 0})
       .interpolate('monotone');
    };
    
    function today (chart) {
        var x_vert = d3.timeDay.utc(new Date());
        var extra_data = [
            {x: chart.x()(x_vert), y: 0},
            {x: chart.x()(x_vert), y: chart.effectiveHeight()}
        ];
        var line = d3.svg.line()
            .x(function(d) { return d.x; })
            .y(function(d) { return d.y; })
            .interpolate('linear');
        var chartBody = chart.select('g');
        var path = chartBody.selectAll('line#today').data([extra_data]);
        var path = path.enter()
                .append('path')
                .attr('class', 'today')
                .attr('stroke', 'red')
                .attr('id', 'today')
                .attr("stroke-width", 1)
                .style("stroke-dasharray", ("10,3"));
        path.attr('d', line);
    };

  //graph.on('pretransition', today);

  var lang=[];

  graphs.lang.group().top(20).forEach(function(l){
     var group=dim.group().reduceSum(function(d){
        return (l.key == d.lang ? 1 : 0);
     });
     
     lang.push(line(group,l.key).renderArea(true).useRightYAxis(true));
});

  lang.push(line(group,"total Amount")
          .ordinalColors(["blue"])
          .renderArea(false));
  graph.compose(lang);
  graph
    .yAxisLabel("Amount")
    .rightYAxisLabel("Nb Donations")
/*
    graph.compose([
        line(group,"total")
          .on('pretransition', today)
          .renderArea(true),
        line(groupNew,"new")
          .renderArea(true),
        line(groupExisting,"existing"),
        line(groupPending,"pending"),
        line(groupShare,"share")
          .dashStyle([3,1,1,1]),
        line(groupActivated,"activated")
          .renderArea(true),
    ]);
*/
   graph.yAxis().ticks(5).tickFormat(d3.format(".2s"));
   graph.rightYAxis().ticks(5).tickFormat(d3.format(".2s"));
   graph.xAxis().ticks(7);

  return graph;
}

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

        function drawLang(dom){
          var dim = ndx.dimension(function(d) {return d.lang;});
          var group = dim.group().reduceSum(function(d) { return 1; });
          var graph = dc.pieChart(dom)
            .innerRadius(20)
            .radius(0)
            .dimension(dim)
            .group(group)
            .label(function (d) { return d.key;})
            .title(function (d) { return (d.key +": "+d.value);});
          ;
          return graph;
        }

        function drawStatus(dom){
          var dim = ndx.dimension(function(d) {return d.status_id;});
          var group = dim.group().reduceSum(function(d) { return 1; });
          var graph = dc.pieChart(dom)
            .innerRadius(20)
            .radius(90)
            .dimension(dim)
            .group(group)
            .label(function (d) { return statusLabel[d.key];})
            .title(function (d) { return (d.key +": "+d.value);});
          ;
          return graph;
        }
        function drawRecur(dom){
          var dim = ndx.dimension(function(d) {return d.recurring;});
          var group = dim.group().reduceSum(function(d) { return 1; });
          var graph = dc.pieChart(dom)
            .innerRadius(20)
            .radius(90)
            .dimension(dim)
            .group(group)
//            .label(function (d) { ;return d.key? "Recurring":"One Off";})
//            .title(function (d) { return (d.key? "Recurring":"One Off") +": "+d.value;});
          ;
          graph.filter("one_off");
          graph.filter("first_recur");
          return graph;
        }

function drawAmount(dom) {
  var graph = dc.barChart(dom);
  var dim = ndx.dimension(function (d) {return d.amount;});
  var group = dim.group().reduceSum(function(d) { return 1; });
  graph.width(200)
                    .height(100)
                    .centerBar(true)
                     .elasticY(true)
                    .gap(1)
                    .x(d3.scaleLinear().domain([0, 100]))
//                    .round(d3.timeMonth.round)
//                    .xUnits(d3.timeMonths);
                    .margins({top: 20, left: 40, right: 10, bottom: 20})
                    .group(group)
                    .dimension(dim)
                    .ordinalColors(["#d95f02","#1b9e77","#7570b3","#e7298a","#66a61e","#e6ab02","#a6761d"]);
  graph.yAxis().ticks(3, ",.0f").tickSize(2, 0);
   graph.xAxis().ticks(4);
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
  var currency = function(name) {
    var symbol = {"EUR":"€","GBP":"£","PLN":"zł"};
    return symbol[name];
  };

  var graph=dc.dataTable(dom)
    .dimension(dim)
    .group(function(d) {
        return d.date.substr(0, 10);//dateFormat(d.dd);
    })
    .sortBy(function (d) { return d.key })
    .order(d3.descending)
    .size(999)
    .columns([function(d){return "<a href='/civicrm/contact/view?cid="+d.contact_id+"' title='view the contact' target='_blank'>"+d.first_name+"</a>"},
              function(d){ return d.recurring.replace("_"," ") +" " +statusLabel[d.status_id].toLowerCase()},
              function(d){ 
                return d.amount +" "+currency(d.currency)},
              function(d){return d.created_age},
//              function(d){return instrumentLabel[d.instrument_id]},
              function(d){return "<span title='campaign "+d.campaign_id + "'>" +d.utm_campaign+"</span>"},
              function(d){return d.utm_medium},
              function(d){return d.mailing || d.utm_source},
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
                var instrument        = ndx.dimension(function(d) {return d.instrument_id;});
                var instrumentGroup   = instrument.group().reduceSum(function(d) { return 1; });
                pieinstrument
                    .width(200)
                    .height(200)
                    .dimension(instrument)
                    .group(instrumentGroup)
                    .title(function(d) {
                        return instrumentLabel[d.key]+":"+d.value;
                    })
                    .label(function(d) {
                        return instrumentLabel[d.key];
                    })
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

<style>{literal}
  .compact .panel-heading {
    padding:5px;
    position:absolute;
    border-bottom-right-radius: 4px;
    border-right-style:solid;
    border-right-width:1px;
    color:grey;
  }
  .compact .panel-body {
    padding:0;
    position:relative;
    padding-top:5px;
  }

{/literal}
</style>
