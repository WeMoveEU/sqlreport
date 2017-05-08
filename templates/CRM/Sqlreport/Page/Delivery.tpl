<script>
var campaigns= {crmSQL file="Campaigns"};
{literal}
jQuery(function($){
  var html="";
  $(".crm-container").removeClass("crm-container");
  campaigns.values.forEach(function (d){
    html += "<option value='"+d.id+"'>"+(d.utm_campaign||d.name)+"</option>";
  });  
  $("#campaign").html(html).on('change', function() {
    window.location.href="/civicrm/delivery/"+this.value;
  });
});
{/literal}

</script>

<div class="row">
<div class="panel panel-default">
<div class="panel-heading">
<h2 class="panel-title">Select a campaign</h2>
</div>
<div class="panel-body">
  <select id="campaign">
    <option value="">(select)</option>
  </select>
</div>
</div>
</div>
