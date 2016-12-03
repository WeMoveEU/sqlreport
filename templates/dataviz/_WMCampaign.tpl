{crmTitle string="All Campaigns"}

<div class="row">
<div class="col-md-12">
<div class="well">
<b>Work in progress</b>. this page aim at providing you an overview of what's happening now (say past 24 hours). Right now, it's just to provide you a link to the different campaign viz
</div>
</div>
</div>
<div class="row">
<div class="col-md-12">
<table class="table table-striped" id="activities">
<thead><tr>
<th>Date</th>
<th>Name</th>
<th>Parent Campaign</th>
<th>Action</th>
<th>New signatures</th>
<th>New members</th>
</tr></thead>
<tbody>
</tbody>
</table>
</div>
</div>



<script>
////    'use strict';

//custom_8=url custom_11=utm custom_4=language
var campaigns= {crmSQL file="Campaigns"};
var types = {crmAPI entity='Campaign' action='getoptions' sequential=0 field="campaign_type_id"};
{literal}
var ndx = crossfilter(campaigns.values);
var graphs = [];

(function ($){
	if(campaigns.is_error){
		 alert(campaigns.error_message);
	}
	var instrumentLabel = {};
	var numberFormat = d3.format(".2f");
	var dateFormat = d3.time.format("%Y-%m-%d");
	var dateTimeFormat= d3.time.format("%Y-%m-%d %H:%M:%S");


//			all = ndx.groupAll();

//			drawNumbers(graphs);
  graphs.table = drawTable('#activities');
	dc.renderAll();

	function drawTable(dom) {
		var dim = ndx.dimension(function(d) {return d.name;});

		var graph=dc.dataTable(dom)
			.dimension(dim)
			.group(function(d) {
					return '<h2>'+types.values[d.type_id]+'</h2>';
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
            return "<i><a href='"+CRM.url("civicrm/campaign/add",{action:"update",id:d.id})+"'>FIX needed</a></i>";
          return d.utm_campaign},
				function(d){return '<a href="/civicrm/dataviz/WMCampaign/'+d.id+'">'+d.name+'</a>';},
				function(d){return '<a href="'+d.url+'">Speakout</a>'},
				function(d){return ''},
				function(d){return ''},
			 ]);
		return graph;
	}
})(cj);



</script>
<style>
.row .dc-chart .pie-slice {fill:white;}
</style>
{/literal}
