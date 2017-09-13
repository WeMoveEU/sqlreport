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
<th title='nb of unique recipients of our mailings'>Targeted</th>
<th title='nb of unique clicks of our mailings'>Click</th>
<th>Signature</th>
<th>New member</th>
<th>Activated</th>
<th>Share</th>
<th>Donations</th>
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
	var numberformat = function(d) { return d? d3.format(".2s")(d) : ""};
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
					return '<h2 id="'+types.values[d.type_id]+'">'+types.values[d.type_id]+'</h2>';
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
				function(d){return '<a href="/civicrm/dataviz/WMCampaign/'+d.id+'">'+d.name+'</a>';},
				function(d){return '<a href="'+d.url+'" title="'+d.external_identifier+'">Speakout</a>'},
				function(d){return '<span class="tip" title="mails sent:'+numberformat(d.recipient)+"<br>avg:"+ numberformat(d.recipient/d.unique_recipient)+'">'+numberformat(d.unique_recipient)+'</span>'},
				function(d){return '<span class="tip" title="mails sent:'+numberformat(d.recipient)+"<br>seeder <i>more than 1 click</i>:"+ numberformat(d.click_1)+"<br>superseeder <i>more than 42 clicks</i>:"+ numberformat(d.click_42)+'">'+numberformat(d.signature)+'</span>'},
				function(d){return '<span class="tip" title="new signature:'+numberformat(d.new_signature)+'">'+numberformat(d.signature)+'</span>'},
				function(d){return '<span class="tip" title="with > 1 new signature:'+numberformat(d.effective_share)+'">'+numberformat(d.share)+'</span>'},
				function(d){return '<span class="tip" title="from speakout share:'+numberformat(d.new_member_share)+"<br>from mail fwd:"+ numberformat(d.new_member_mail)+'">'+numberformat(d.new_member)+'</span>'},
				function(d){return numberformat(d.activated)},
				function(d){return '<span class="tip" title="new members created:'+numberformat(d.new_member_share)+"<br>effective share (at least one member created):"+ numberformat(d.effective_share)+'">'+numberformat(d.share)+'</span>'},
				function(d){return '<a class="tip" href="/civicrm/dataviz/WM_contribution_campaign#campaign='+d.id+'" title="nb donations:'+( +d.donation + +d.donation_pending)+'<br>amount still pending:'+d.donation_pending_amount+'">'+numberformat(+d.donation_amount+ +d.donation_pending_amount)+'</a>'},
			 ])
            .on("renderlet.tootltip", function(){
              jQuery("table .tip").tooltip({html:true})});
		return graph;
	}
})(cj);



</script>
<style>
.row .dc-chart .pie-slice {fill:white;}
.tip {cursor: help;}

.tooltip-inner {
    max-width: 350px;
    width: 350px; 
}
</style>
{/literal}
