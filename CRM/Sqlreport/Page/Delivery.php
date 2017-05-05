<?php

class CRM_Sqlreport_Page_Delivery extends CRM_Core_Page {

  public function run() {
    // Example: Set the page-title dynamically; alternatively, declare a static title in xml/Menu/*.xml
    CRM_Utils_System::setTitle(ts('Delivery'));

    $smarty= CRM_Core_Smarty::singleton( );

    $request = CRM_Utils_System::currentPath();
    if (false !== strpos($request, '..')) {
      die ("SECURITY FATAL: the url can't contain '..'. Please report the issue on the forum at civicrm.org");
    }

    $request = explode('/',$request);
    $id = 0;
    if (CRM_Utils_Array::value(2, $request)) {
      $id += $request[2];
    }
    require_once 'CRM/Core/Smarty/plugins/function.crmSQL.php';
    $smarty->register_function("crmSQL", "smarty_function_crmSQL");

    $r = smarty_function_crmSQL(array("json"=>"Delivery", "id"=>$id));

    $filename = "delivery_".$id;

//    header("Content-type: text/csv");
//    header("Content-Disposition: attachment; filename={$filename}.csv");
    header("Pragma: no-cache");
    header("Expires: 0");
    $csv= fopen("php://output", 'w');
    fputs($csv, chr(0xEF) . chr(0xBB) . chr(0xBF) ); //excel bom fix utf
    $max=count($r["values"]);
    for ($i = 0; $i <= $max; $i+=2) {
      fputcsv($csv,array_merge(array_values($r["values"][$i]),array_values($r["values"][$i+1])));
    }
    fclose($csv);
die ("");
  }

}
