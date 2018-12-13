<script>
var campaigns= {crmSQL file="Campaigns"};
{literal}
jQuery(function($){
  var html="";
  $(".crm-container").removeClass("crm-container");
  campaigns.values.sort(function (a, b) { return b.id - a.id; });
  campaigns.values.forEach(function (d) {
    if (d.type_id == 4 || d.type_id == 6) {
      html += "<option value='"+d.id+"'>"+(d.name || d.utm_campaign)+"</option>";
    }
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
