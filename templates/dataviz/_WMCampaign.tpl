{crmTitle string="All Campaigns"}

<div class="row">
	<div class="col-md-12">
		<div class="panel panel-default" id="date">
			<div class="panel-heading" title="when was the campaign created?">Date
        <select id="date_select" class="hidden">
          <option value="Infinity">All</option>
          <option value="today">Today</option>
          <option value='1'>last 24 hours</option>
          <option value="week">This week</option>
          <option value="month">This month</option>
          <option value='30'>last 30 days</option>
          <option value='90'>last 90 days</option>
        </select>
      </div>
			<div class="panel-body"> <graph /> </div>
		</div>
	</div>
</div>

<div class="row">

  <div class="col-md-4">
    <div class="well">
      <b>Work in progress</b>. this page aim at providing you an overview of what's happening now (say past 24 hours). Right now, it's just to provide you a link to the different campaign viz
    </div>
  </div>

  <div class="col-md-3 col-sm-6 col-xs-6">
    <div id="overview">
      <ul class="list-group">
        <li class="list-group-item">
          <span class="summary_total"></span> total
          <a class="btn btn-danger bt-xs pull-right" id="resetall" 
              href="javascript: jQuery('#btn-date .active').removeClass('active');dc.filterAll();dc.redrawAll();">
            <span class="glyphicon glyphicon-refresh"></span>
          </a>
        </li>
        <li class="list-group-item list-group-item-success">
          <span class="hidden badge total_percent"></span>
          <span class="total"></span> Campaigns
        </li>
      </ul>
    </div>
  </div>

  <div class="col-md-4 col-sm-6 col-xs-6">
    <div class="panel" id="type"> <graph/> </div>
  </div>
</div>

<div class="row">
  <div class="col-md-12">
    <table class="table table-striped" id="activities">
      <thead><tr>
        <th>Date</th>
        <th>Name</th>
        <th>Parent Campaign</th>
        <th title='nb of unique recipients of our mailings'>Targeted</th>
        <th title='nb of unique clicks of our mailings'>Click</th>
        <th>Signature</th>
        <th>New member</th>
        <th>Activated</th>
        <th>Share</th>
        <th>Donations</th>
      </tr></thead>
      <tbody></tbody>
    </table>

    since {$request.since}
  </div>
</div>



<script>
////    'use strict';

//custom_8=url custom_11=utm custom_4=language
{if $request.since}
var campaigns= {crmSQL json="CampaignsSince" since=$request.since debug=1};
{else}
var campaigns= {crmSQL file="Campaigns"};
{/if}
var types = {crmAPI entity='Campaign' action='getoptions' sequential=0 field="campaign_type_id"};

{literal}
jQuery.urlParam = function(name){
  var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
  if (results==null) {
    return null;
  }
  else {
    return decodeURI(results[1]) || 0;
  }
};

var ndx = crossfilter(campaigns.values);
var graphs = [];
var summary= {};
var campid2idx = {};
for (var i = 0, len = campaigns.values.length; i < len; i++) {
  campid2idx[campaigns.values[i].id] = i;
}

 
(function ($){
	if(campaigns.is_error){
		 alert(campaigns.error_message);
	}

	var instrumentLabel = {};
	var formatNumber = function(d) {
    if (d == Infinity) return "";
    return d > 999 && d < 10000 ? d3.format('.0s')(d) : d >= 10000 ? d3.format('.3s')(d) : d;
  };
	var dateFormat = d3.time.format("%Y-%m-%d");
	var dateTimeFormat= d3.time.format("%Y-%m-%d %H:%M:%S");
  var day = d3.time.format("%Y%m%d");
  var formatPercent =d3.format(".2%");
  var blacklist = ["id","parent_id","type_id","external_identifier"];

  var metrics = Object.keys(campaigns.values[0]);
  metrics = metrics.filter( function( e ){
    if (typeof campaigns.values[0][e] == "string" && campaigns.values[0][e] != "") return false;
    return !blacklist.includes( e );
  });
  metrics.forEach(function(m){
    $("#overview ul").append(
      '<li class="list-group-item '+m+'"><span class="badge"></span><span class="value"></span>&nbsp;'+ m.replace(/_/g, " ")+'</li>'
    );
  });

  var getMetrics = function (d){
    var f="<dl>";
    metrics.forEach(function(k){
      f += "<dt>"+k.replace(/_/g, " ")+"</dt><dd>&nbsp;"+formatNumber(d[k])+"</dd>";
    });
    return f + "</dl>";
  }

  drawNumbers(graphs);
  summary.total = graphs.total.data();
  $(".summary_total").text(formatNumber(summary.total));
 
  graphs.date = drawDate('#date graph');
  graphs.table = drawTable('#activities');
  graphs.type=drawType('#type graph');
  dc.renderAll();

function drawDate (dom) {
  //var dim = ndx.dimension(function (d) {   return [+d.date, +d.amount, d.lang];  }); 
  var dim = ndx.dimension(function (d) {  return d.id;});// return dateTimeFormat.parse(d.date) });
  var group = dim.group().reduceSum(function(d) {return 1;});
  //var group = dim.group();
  var since = dim.bottom(1)[0].date;

  if (jQuery.urlParam("since")){
//    since = day.parse(jQuery.urlParam("since"))
//    dim.filterAll();
//    dim.filterRange([since, new Date()]);
  }
  //var range= [since, dim.top(1)[0].date];
  var range= [since, new Date()];
/*
  var graph= dc.lineChart(dom) //scatterPlot(dom) //lineChart(dom)
	.width(0).height(180)
	.dimension(dim)
    .group(group)
	.x(d3.time.scale().domain(range))
//.y(d3.scale.linear().domain([0., 100.]))
    //.valueAccessor(function(d) { return d.value.min; }) 
    .elasticX(true)
//    .elasticY(true)
    .mouseZoomable(true)
    //.rangeChart(graphs.month)
    //.brushOn(true)
    .margins({ top: 10, left: 50, right: 10, bottom: 50 });
    
  graph.xAxis().ticks(3);
*/
       function getCamp(p) {
          return campaigns.values[campid2idx[p.key]];
       };
       var graph = dc.bubbleChart(dom)
					.width(800)
					.height(430)
					.margins({top: 20, left: 50, right: 20, bottom: 40})
					.group(group)
					.dimension(dim)
          .on('renderlet', function(chart, filter){
            chart.svg().select(".chart-body").attr("clip-path",null);
          })
          .yAxisPadding(1)
          .xAxisPadding(1)
          .colorAccessor(function (p) {            return getCamp(p).type_id;})
          .keyAccessor(function (p) {
            return dateTimeFormat.parse(getCamp(p).date);
          })
          .valueAccessor(function (p) { return (p.value ?  getCamp(p).signature: 0)          })
          .radiusValueAccessor(function (p) { return (p.value? Math.sqrt(getCamp(p).new_member/3.14): 0);})
          .sortBubbleSize(true)
//          .colorCalculator (function (d,i) {return "#3695d8";})
	  .x(d3.time.scale().domain(range))
          .y(d3.scale.linear().domain([0, 400000]))
          .r(d3.scale.linear().domain([0, 984]))
					.elasticX(true)
          .label(function (p) {

            return p.value ? getCamp(p).utm_campaign.replace(/-/g, " ") || getCamp(p).name.replace(/-/g, " ") : "";
          })
	   .on("renderlet.tootltip", function(){
	       var $=jQuery;
               function setTooltip (){
                 var c=getCamp(d3.select(this).data()[0]);
                 return "<h4>"+c.name+ '</h4>'+getMetrics(c);
               };
               
	       $(dom +" .bubble").tooltip({title: setTooltip, container: 'body',html:true, placement:"auto right"});
	    })

          .title(function (p) {return ;})
         ;
  graph.yAxis().tickFormat(formatNumber);

  d3.select('#date_select').on('change', function(){ 
	  var nd = new Date(), now = new Date();
    switch (this.value) {
			case "today":
        nd = d3.time.day(now);
				break;
			case "week":
        nd = d3.time.monday(now);
				break;
			case "month":
        nd = d3.time.month(now);
				break;
			default:
        nd.setDate(nd.getDate() - +this.value);
		}
    dim.filterAll();
    dim.filterRange([nd, now]);
    //graph.replaceFilter(dc.RangedFilter(nd, now));
    graph.rescale();
    graph.redrawGroup();
//    dc.redrawAll();    
  });
  return graph;
//    .renderlet(function (chart) {chart.selectAll("g.x text").attr('dx', '-30').attr('dy', '-7').attr('transform', "rotate(-90)");});
}


function drawNumbers (graphs){
var dim = ndx.dimension(function(d) { return true; });
var reducer = reductio();

    reducer.count(true);
    metrics.forEach(function(d){
        reducer.value(d).count(true)
        .sum(d).avg(true);
    });
        var group=dim.group();
        reducer(group);

  var badging = function (attribute){
    dc.numberDisplay("#overview ."+attribute+ " .badge").group(group)
      .valueAccessor(function(d){return d.value[attribute].sum/d.value.signature.sum})
      .formatNumber(formatPercent);
  };

  graphs.total=dc.numberDisplay(".total") 
    .valueAccessor(function(d){ 
       summary.filtered=d.value.count;
       return d.value.count
    })
    .formatNumber(formatNumber)
    .group(group);

  graphs.total_percent=dc.numberDisplay(".total_percent") 
    .valueAccessor(function(d){
       if (d.value.count == summary.total){
         $(".summary_total").parent().slideUp();
         return 1;
       }
       $(".summary_total").parent().slideDown();
       return d.value.count/summary.total})
    .formatNumber(formatPercent)
    .group(group);

  metrics.forEach(function(m){
    graphs[m]=dc.numberDisplay("#overview ."+m +" .value").group(group)
    .valueAccessor(function(d){return d.value[m].sum})
    .formatNumber(formatNumber);
    badging (m);
  });


}


function drawType (dom) {
  var dim        = ndx.dimension(function(d) {
    return d.type_id;
  });

  var group   = dim.group().reduceSum(function(d) { return 1; });


  var graph     = dc.pieChart(dom).innerRadius(10).radius(90)
                                        .width(0)
                                        .height(0)
                                        .dimension(dim)
//  .colors(_colorType)
                                        .group(group)
                                        .label(function(d){
                                           return types.values[d.key];
                                        })
                                        .title (function (d) {
                                             return types.values[d.key] + ": " + d.value;
//                                          if (graph.hasFilter() && !graph.hasFilter(d.key))
//                                            return types[d.key] + "(0%)";
//                                           return types[d.key]+': '+d.value+" (" + Math.floor(d.value / all.reduceSum(function(d) {return d.count;}).value() * 100) + "%)";
                                        })
  ;
  return graph;
}

	function drawTable(dom) {
		var dim = ndx.dimension(function(d) {return d.name;});

		var graph=dc.dataTable(dom)
			.dimension(dim)
			.group(function(d) {
					return '<span class="hidden">'+(100-d.type_id )+'</span><h2 id="'+types.values[d.type_id]+'">'+types.values[d.type_id]+'</h2>';
			})
			.sortBy(function (d) { return d.date })
			.order(d3.descending)
			.size(9999)
			.columns([
				function(d){
          return d.date.substring(0,10);
          //return dateTimeFormat.parse(d.date)
        },
				function(d){
          if (d.id != d.parent_id)
            return "<i><a href='"+CRM.url("civicrm/campaign/add",{action:"update",id:d.id})+"FIX needed</a></i>";
          var name= d.utm_campaign.trim() ||"??";
          return "<a href='"+CRM.url("civicrm/campaign/add",{action:"update",id:d.id})+"'> "+name+"</a>";
          },
				function(d){return '<a href="/civicrm/dataviz/WMCampaign/'+d.id+'">'+d.name.replace("-PARENT","").replace(/_/g, '_<wbr>')+'</a>';},
//				function(d){return '<a href="'+d.url+'" title="'+d.external_identifier+'">Speakout</a>'},
				function(d){
console.log(d.recipient);
return '<span class="tip" title="mails sent:'+formatNumber(d.recipient)+"<br>avg:"+ formatNumber(d.recipient/d.unique_recipient)+'">'+formatNumber(d.unique_recipient)+'</span>'},
				function(d){return '<span class="tip" title="mails sent:'+formatNumber(d.recipient)+"<br>seeder <i>more than 1 click</i>:"+ formatNumber(d.click_1)+"<br>superseeder <i>more than 42 clicks</i>:"+ formatNumber(d.click_42)+'">'+formatNumber(d.signature)+'</span>'},
				function(d){return '<span class="tip" title="new signature:'+formatNumber(d.new_signature)+'">'+formatNumber(d.signature)+'</span>'},
				function(d){return '<span class="tip" title="with > 1 new signature:'+formatNumber(d.effective_share)+'">'+formatNumber(d.share)+'</span>'},
				function(d){return '<span class="tip" title="from speakout share:'+formatNumber(d.new_member_share)+"<br>from mail fwd:"+ formatNumber(d.new_member_mail)+'">'+formatNumber(d.new_member)+'</span>'},
				function(d){return formatNumber(d.activated)},
				function(d){return '<span class="tip" title="new members created:'+formatNumber(d.new_member_share)+"<br>effective share (at least one member created):"+ formatNumber(d.effective_share)+'">'+formatNumber(d.share)+'</span>'},
				function(d){return '<a class="tip" href="/civicrm/dataviz/WM_contribution_campaign#campaign='+d.id+'" title="nb donations:'+( +d.donation + +d.donation_pending)+'<br>amount still pending:'+d.donation_pending_amount+'">'+formatNumber(+d.donation_amount+ +d.donation_pending_amount)+'</a>'},
			 ])
            .on("renderlet.tootltip", function(){
              jQuery("table .tip").tooltip({html:true})});
		return graph;
	}
})(cj);



</script>
<style>
#crm-container .signature {width:auto}
.tooltip dt {float:left; width:"200px" }
.tooltip dd {text-align: right}

       .panel .panel-heading .nav-tabs li a {
                            padding:15px;
                            margin-bottom:1px;
                            border:solid 0 transparent;
        }
        .panel .panel-heading .nav-tabs li a:hover {
                            border-color: transparent;
                            }


        .panel .panel-heading .nav-tabs li.active a,.panel .panel-heading .nav-tabs li.active a:hover {
                                border:solid 0 transparent;
                            }

         #date path.area {fill-opacity:.2;}

         #date .brush rect.extent {fill:lightgrey;}

.row .dc-chart .pie-slice {fill:white;}
.tip {cursor: help;}

.tooltip-inner {
    max-width: 350px;
    width: 350px; 
}
</style>
{/literal}
