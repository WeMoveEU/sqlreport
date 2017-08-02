{crmTitle string="Campaign Activities"}
{if !isset($id)}
  {include file='dataviz/_WMCampaign.tpl'}
    <script type="text/javascript">
//        location.replace('events');
    </script>
{else}
<nav id="campaign-nav" class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Campaign</a>
    </div>

    <div class="collapse navbar-collapse" id="campaign-navbar">
      <ul class="nav navbar-nav nav-subcampaign">
        <li class="dropdown lang-dropdown campaign" data-index="[index]">
          <a href="#" title="[name]" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="badge"></span>[lang]<span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li>CiviCRM</li>
            <li><a href="/civicrm/campaign/add?reset=1&action=update&id=[id]">Edit</a></li>
            <li role="separator" class="divider"></li>
            <li>Speakout</li>
            <li><a href="https://act.wemove.eu/campaigns/[external_id]">View</a></li>
            <li><a href="https://act.wemove.eu/campaigns/[external_id]/edit">Edit</a></li>
            <li><a href="https://act.wemove.eu/campaigns/[external_id]/share_links">Share</a></li>
          </ul>
        </li>
      </ul>
<ul class="nav navbar-nav navbar-right">
  <li><a href="/civicrm/dataviz/WMCampaign"><span title="All campaigns" aria-hidden="true" class="glyphicon glyphicon-home"></span></a></li>
   <li><a class="btn resetall navbar-btn" href="javascript:graphs.signature.filterAll();dc.redrawAll();"><span class="glyphicon glyphicon-refresh"></span>Reset</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
<br>
<div class="row">
	<div class="col-md-3">
		<div id="overview">
			<ul class="list-group">
				<li class="list-group-item"><span class="badge nb_signature"></span>Signatures</li>
				<li class="list-group-item"><span class="badge nb_new_member"></span>New Members</li>
			<li class="list-group-item"><span class="badge nb_pending"></span><span class="glyphicon glyphicon-chevron-right"></span><i>pending</i></li>
			<li class="list-group-item"><span class="badge nb_bounced" title="signatures from invalid emails"></span><span class="glyphicon glyphicon-chevron-right"></span><strike>bounced</strike></li>
				<li class="list-group-item"><span class="badge nb_share"></span>Shares</li>
				<li class="list-group-item"><span class="badge nb_recipient"></span>Emails sent</li>
				<li class="list-group-item"><span class="badge nb_open"></span><span class="glyphicon glyphicon-chevron-right"></span><i>opened</i></li>
				<li class="list-group-item"><span class="badge nb_click"></span><span class="glyphicon glyphicon-chevron-right"></span><i>clicked</i></li>
				<li class="list-group-item"><span class="badge nb_donation">?</span>Donations</li>
			</ul>
		</div>
	</div>
	<div class="col-md-3 hidden">
		<div class="panel panel-default" id="signature">
			<div class="panel-heading">Signatures</div>
			<div class="panel-body"><graph />
			</div>
		</div>
	</div>
	<div class="col-md-3">
		<div class="panel panel-default" id="new_member">
			<div class="panel-heading" title="new members, pending and optout">Growth</div>
			<div class="panel-body"><graph />
			</div>
		</div>
	</div>
	<div class="col-md-3">
		<div class="panel panel-default" id="media">
			<div class="panel-heading" title="New members, based on the utm_media parameter">Aquisition media</div>
			<div class="panel-body"><graph />
			</div>
		</div>
	</div>
	<div class="col-md-3">
		<div class="panel panel-default" id="source">
			<div class="panel-heading" title="New members, based on the utm_source parameter">Aquisition source</div>
			<div class="panel-body"><graph />
			</div>
		</div>
	</div>
</div>


<div class="row">
<div class="col-md-12">
<table class="table table-striped" id="activities">
<thead><tr>
<th>Lang</th>
<th>Media</th>
<th>Source</th>
<th>Signatures</th>
<th title="signatures of new members, or pending or optout">New<br>Signatures</th>
<th>New members</th>
<th>Pending</th>
<th>Optout</th>
<th>Share</th>
<th>Leave</th>
</tr></thead>
<tbody>
</tbody>
</table>
</div>
</div>



<script>
////    'use strict';
var campaign = {crmAPI action="get" entity="campaign" option_limit=1000 return="id,name,parent_id,external_identifier,custom_4,custom_8,custom_11" parent_id=$id};
if (campaign.count==0) //need to fix so it has a parent...
  campaign.values=[{id:$id,name:"Fix #"+$id}];
//custom_8=url custom_11=utm custom_4=language
var activities= {crmSQL json="AllCampaignActivities" id=$id};
var mailings= {crmSQL json="AllCampaignMailings" id=$id};
{literal}
var ndx = crossfilter(activities.values);
var graphs = [];
var color = d3.scale.linear().range(["red", "green"]).domain([0,1]).interpolate(d3.interpolateHcl).clamp(true);

jQuery(function($) {

	$(".crm-container").removeClass("crm-container");
  $("h1.page-header,.breadcrumb,#page-header").hide();
  $(".navbar-brand").html(campaign.values[0].name.slice(0,-3));
  var dd=$("#campaign-navbar .nav-subcampaign").html();
  var html="";
  if (campaign.count <= 10) {
    $.each( campaign.values, function( i, d ){
      html += dd.replace("[lang]",d.custom_4.slice(-2))
              .replace("[index]",i)
              .replace("[name]",d.name)
              .replace(/\[id\]/g, d.id)
              .replace(/\[external_id\]/g, d.external_identifier);
    });
  } else {
    var l = "";
    campaign.values.sort(function(x, y){
      return d3.ascending(x.custom_4, y.custom_4)
    });
   

    $.each( campaign.values, function( i, d ){
      if (d.custom_4 != l) { // new language
        if (l) html += "</ul></li>";
        html += "<li class='dropdown lang-dropdown' ><a href='' class='dropdown-toggle' data-toggle='dropdown' role='button' aria-haspopup='true' aria-expanded='false'>"+d.custom_4.slice(-2)+"<span class='caret'></span></a><ul class='dropdown-menu' style='width:300px;'>";
        l = d.custom_4;
      }
      html += "<li class='campaign' data-index='"+i+"'><a href='#camp_"+d.id+"' title='"+d.name+"'><span class='badge pull-right'></span>"+ d.name.slice(0,-3) + "</a></li>";
    });
  }
  html +="</ul>";
  $("#campaign-navbar ul.nav-subcampaign").html(html);

  $('#campaign-nav .nav-subcampaign').on('click',"a", function () {
    
    var i=$(this).parent().data("index");
    $(this).closest(".dropdown").addClass("active");
    graphs.signature.filterAll();
    if (!i) {
      $(this).parent().find("li").each(function(){
         graphs.signature.filter(campaign.values[$(this).data("index")].name);
      });
      
    } else {
      graphs.signature.filter(campaign.values[i].name);      
    }
    dc.redrawAll();    
  }) 
});

(function ($){
  
	if(campaign.is_error){
		 alert(campaign.error_message);
	}
	var instrumentLabel = {};
	var numberFormat = d3.format(".2f");
	var dateFormat = d3.time.format("%Y-%m-%d");
	var dateTimeFormat= d3.time.format("%Y-%m-%d %H:%M:%S");
  var mailing_type = {winner:"Final mailing",experiment:"AB Test",standalone:"civimail",unrelated:"other civimail"};

  activities.values.forEach(function(d) {
    if (d.source.substring(0,9) == "civimail-" && d.media) {
      var mid=d.source.substring(9);
      d.mailing= CRM._.find(mailings.values, function(d) {return d.id==mid;});
      if (!d.mailing) {
        d.mailing = {id:mid
          ,mailing_type:"unrelated"
          ,lang:""
          ,name:"mailing #"+mid
          ,recipient:0
          ,open:0
          ,'click':0
          ,scheduled_date:"?"
          ,v_new_member:0
          ,subject:"mailing not associated with this campaign"
        };
      }
      if (d.mailing && d.mailing.mailing_type && mailing_type[d.mailing.mailing_type]) {
        d.mailing.mailing_type = mailing_type[d.mailing.mailing_type];
      }
    }
  });

	cj(function($) {

//			all = ndx.groupAll();

			drawNumbers(graphs);
			graphs.media = drawMedia('#media');
			graphs.source = drawSource('#source','completed_new_member');
			graphs.signature= drawPie('#signature','total');
			graphs.new_member = drawNewMember('#new_member');
//			graphs.new_member = drawPie('#new_member','completed_new_member');
			graphs.table = drawTable('#activities');
//                drawInstrument();
//                drawAmount('#amountg .graph');
//                drawDump();

			dc.renderAll();
	 });

})(cj);


function drawNumbers (graphs){
  var average = function(d) {
      return d.qty ? d.total / d.qty : 0;
  };

  var group = ndx.groupAll().reduce(
		function (p, v) {
				p.new_member += +v.completed_new_member;
				p.bounced += +v.bounced;
				p.optout += +v.optout;
				p.pending += +v.pending;
				p.share+= +v.share;
				p.signature += +v.total;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.recipient += +v.mailing.recipient;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.open += +v.mailing.open;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.click += +v.mailing.click;
				return p;
		},
		function (p, v) {
				p.optout -= +v.optout;
				p.new_member -= +v.completed_new_member;
				p.bounced -= +v.bounced;
				p.pending -= +v.pending;
				p.share -= +v.share;
				p.signature -= +v.total;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.recipient -= +v.mailing.recipient;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.open -= +v.mailing.open;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.click -= +v.mailing.click;
				return p;
		},
		function () { return {share:0,new_member:0,optout:0,pending:0,signature:0,recipient:0,click:0,open:0,bounced:0}; }
	);

	function renderLetDisplay(chart,factor, ref) {
		 ref = ref || graphs.nb_recipient.value() || 1;
		 factor= factor || 1;
		 d3.selectAll(chart.anchor()).style("background-color", color(factor*chart.value()/ref) )
		 .classed("tip",true)
		 .attr("data-original-title", d3.format(".2%")(chart.value()/ref))
		 .attr("title", d3.format(".2%")(chart.value()/ref));
	}
	graphs.nb_signature=dc.numberDisplay(".nb_signature") 
	.valueAccessor(function(d){ return d.signature})
	.html({some:"%number",none:"no signature"})
	.renderlet(function(chart) {renderLetDisplay(chart,20)})
	.group(group);

	dc.numberDisplay(".nb_new_member") 
	.valueAccessor(function(d){ return d.new_member})
	.html({some:"%number",none:"nobody joined"})
	.renderlet(function(chart) {renderLetDisplay(chart,20, graphs.nb_signature.data())})
	.group(group);

	dc.numberDisplay(".nb_pending") 
	.valueAccessor(function(d){ return d.pending})
	.html({some:"%number",none:"no signature pending"})
	.renderlet(function(chart) {renderLetDisplay(chart,20)})
	.group(group);

	dc.numberDisplay(".nb_bounced") 
	.valueAccessor(function(d){ return d.bounced})
	.html({some:"%number",none:"all good"})
	.renderlet(function(chart) {renderLetDisplay(chart,-5, graphs.nb_signature.data())})
	.group(group);

	graphs.nb_recipient= dc.numberDisplay(".nb_recipient") 
	.valueAccessor(function(d){ return d.recipient})
	.html({some:"%number",none:"nobody mailed"})
	.group(group)
	.renderlet(function(c) {
			if (ndx.groupAll().value() == ndx.size())
				d3.selectAll(".resetall").style("display","none");
			else
				d3.selectAll(".resetall").style("display","block");


	//  			var total=c.dimension().size();
	//   			var filtered= c.group().value();
	//	  		var disabled= (total == filtered);
	})
	;
	dc.numberDisplay(".nb_share") 
	.valueAccessor(function(d){ return d.share})
	.html({some:"%number",none:"nobody shared"})
	.renderlet(function(chart) {renderLetDisplay(chart,20, graphs.nb_signature.data())})
	.group(group);
	dc.numberDisplay(".nb_leave") 
	.valueAccessor(function(d){ return d.leave})
	.html({some:"%number",none:"nobody left"})
	.group(group);

	dc.numberDisplay(".nb_click") 
	.valueAccessor(function(d){ return d.click/d.recipient})
	.html({some:"%number",none:"nobody clicked"})
	.renderlet(function(chart) {renderLetDisplay(chart,10,1)})
	 .formatNumber(d3.format(".0%"))
	.group(group);

	dc.numberDisplay(".nb_open") 
	.valueAccessor(function(d){ return d.open/d.recipient})
	 .formatNumber(d3.format(".0%"))
	.on("renderlet.display",function(chart) {renderLetDisplay(chart,3,1)})
	.html({some:"%number",none:"nobody opened"})
	.group(group)
        .on("renderlet.tootltip", function(){
          jQuery("#overview .tip").tooltip('fixTitle');
        })


}

function drawNewMember (dom) {

	var dim = ndx.dimension(function(d) {return d.lang.slice(-2);});
  var group = dim.group().reduce(
		function (p, v) {
				p.new_member += +v.completed_new_member;
				p.optout += +v.optout;
				p.pending+= +v.pending;
				p.signature += +v.total;
        if (!p.name)
				p.bounced += +v.bounced;
  				p.name = v.name;
/*				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.recipient += +v.mailing.recipient;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.open += +v.mailing.open;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.click += +v.mailing.click;
*/
				return p;
		},
		function (p, v) {
				p.optout -= +v.optout;
				p.bounced -= +v.bounced;
				p.new_member -= +v.completed_new_member;
				p.share -= +v.share;
				p.pending-= +v.pending;
				p.signature -= +v.total;
/*
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.recipient -= +v.mailing.recipient;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.open -= +v.mailing.open;
				if (v.mailing && v.mailing.campaign_id==v.campaign_id) p.click -= +v.mailing.click;
*/
				return p;
		},
		function () { return {name:"",share:0,new_member:0,optout:0,pending:0,signature:0,recipient:0,click:0,open:0,bounced:0}; }
	);


  function sel_stack(i) {
	  return function(d) {
			return d.value[i];
	  };
  }

  var graph = dc.barChart(dom)
		.width(250)
		.height(200)
//		.centerBar(true)
		.gap(1)
		.x(d3.scale.ordinal().domain(dim))
    .xUnits(dc.units.ordinal) 
		.margins({left: 50, top: 20, right: 10, bottom: 20})
		.brushOn(false)
		.clipPadding(10)
		.title(function(d) {
			return this.layer +' ' + d.value['name'] + ' : ' + d.value[this.layer];
		})
		.dimension(dim)
		.group(group, "new_member", sel_stack('new_member'))
		.renderLabel(true)
    .elasticY(true);
  
	graph.stack(group, 'pending', sel_stack('pending'));
 	graph.stack(group, 'optout', sel_stack('optout'));
 	graph.stack(group, 'bounced', sel_stack('bounced'));

  return graph;

}



function drawTable(dom) {
  var dim = ndx.dimension(function(d) {return d.name;});

  var graph=dc.dataTable(dom)
    .dimension(dim)
    .group(function(d) {
        return "";//d.name;
    })
    .sortBy(function (d) { return d.total })
    .order(d3.descending)
    .size(9999)
    .columns([
              function(d){ 
                if (d.mailing && d.lang != d.mailing.lang) {
                  return d.mailing.lang.slice(-2)+'<span aria-hidden="true" class="glyphicon glyphicon-play"></span>'+d.lang.slice(-2);
                }
                return d.lang.slice(-2)},
              function(d){
                if (d.mailing) {
                  return d3.format(".2s")(d.mailing.recipient) + ' <abbr class="tip" title="'+d.mailing.mailing_type+'">'+d.media+'</abbr>';
                }
                return d.media;
              },
              function(d){
                if (d.mailing) {
                    return '<a href="/civicrm/mailing/report?mid='+d.mailing.id+'" title="'+d.mailing.subject+'" class="tip">'+d.mailing.name.substring(0,18)+'</a>';
                }
                if (d.media == "widget") return d.source + " " + d.name;
                return d.source},
              function(d){
                if (d.mailing && d.mailing.recipient) {
                    return "<span class='tip' title='"+ d3.format(".2%")(+d.total/+d.mailing.recipient) + " recipient signed'>"+d.total+'</span>';
                }
                return d.total
              },
              function(d){
                var newbies=d.completed_new_member+d.pending+d.optout;
                return "<span class='tip' title='"+newbies+"'>"+d3.format(".2%")(newbies/d.total)+"</span>"; 
                return d.completed_new_member+d.pending+d.optout},
              function(d){
                if (d.mailing && d.completed_new_member) {
                 return d.completed_new_member + '<span class="label label-default" class="tip" title="viral across all languages">+'+d.mailing.v_new_member+'</span>';
                }
                return d.completed_new_member;
              },
              function(d){return d.pending},
              function(d){return d.optout},
              function(d){return d.share},
              function(d){return d.leave},
             ])
    .on("renderlet.tootltip", function(){
       jQuery(dom + " .tip").tooltip();
    })
    ;
  return graph;
}


function drawPie(dom,attribute) {
	var dim = ndx.dimension(function(d) {return d.name;});
	var group   = dim.group().reduceSum(function(d) { return d[attribute]; });

  var graph = dc.pieChart(dom+ " graph").innerRadius(20).radius(90)
		.width(200)
		.height(200)
		.dimension(dim)
		.title(function(d) {
			 return d.key+": "+d.value;
		 })
		 .label(function(d) {
			return d.key.slice(-2);
		})
		.colors(d3.scale.category10())
		.renderlet(function(chart){
			 chart.data().forEach(function(d, i) {
				 d3.selectAll("#campaign-nav a[title='"+d.key+"']").select(".badge").html(d.value);
			 });
		})
		.group(group);

   return graph;
}

function drawSource(dom,attribute) {
	var dim = ndx.dimension(function(d) {
     if (d.mailing) {
       return "civimail " +d.mailing.name + "["+ d3.format(".2s")(d.mailing.recipient)+"]";
     }
    return d.source || "?";
  });
	var group   = dim.group().reduceSum(function(d) { return d[attribute]; });

  var graph = dc.rowChart(dom+ " graph")
		.width(220)
		.height(220)
    .fixedBarHeight(17)
    .colorCalculator(function(d){return '#941b80';})
		.dimension(dim)
    .ordering(function(d){return d[attribute];})
    .cap(9)
    .gap(0)
    .label(function(d) {
     if (d.key.substring(0,8) == "civimail") {
       var name=d.key.match(/\(([^)]+)\)/);
       if (name)
         return d.key.match(/\(([^)]+)\)/)[1];
      }
      return d.key;
    })
		.title(function(d) {
			 return d.key+": "+d.value;
		 })
		.colors(d3.scale.category10())
		.group(group)
    .elasticX(true);

    graph.xAxis().ticks(3, ",.2s").tickSize(5, 0);
   return graph;
}

function drawMedia(dom) {
  var graph = dc.pieChart(dom+ " graph").innerRadius(20).radius(90);
	var dim = ndx.dimension(function(d) {
   if (d.mailing) {
      return d.mailing.mailing_type;
    } 
    return d.media;
  });
	var group   = dim.group().reduceSum(function(d) { return d.completed_new_member; });
	graph
			.width(200)
			.height(200)
			.dimension(dim)
      .title(function(d) {
         return (d.key || '?') +": "+d.value;
       })
			 .label(function(d) {
				return d.key || "?";
			})
			.colors(d3.scale.category20())
			.group(group);

   return graph;
}
</script>
<style>
.row .dc-chart .pie-slice {fill:white;}
.row .dc-chart g.row text {fill:black;}
</style>
{/literal}
{/if}

