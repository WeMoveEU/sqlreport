<?php
function _civicrm_api3_sql_runupdate_spec(&$params) {
  $params['file']['api.required'] = 1;
}

function civicrm_api3_sql_runupdateall ($params) {
  $load=sys_getloadavg();
  $load = $load[0];
  if ($load > 2)
    throw new API_Exception ("load too high, try later $load");
  $config = CRM_Core_Config::singleton();
  foreach (new DirectoryIterator(dirname( __FILE__ ) .'/../../sql') as $file) {
    if ($file->isFile() && substr ($file->getFilename(),-4,4) == ".sql") {
      $filename = substr ($file->getFilename(),0,-4);
      $r=civicrm_api3("sql","runupdate",array('file'=>$filename));
      $results["$filename"]=array ("file"=>$filename,"result"=>$r);
  }
} 
  return civicrm_api3_create_success($results, $params);

}

function civicrm_api3_sql_runupdate ($params) {
 $config = CRM_Core_Config::singleton();
  //run the query
  $file =  $params['file'];
  if (false !== strpos($file, '..')) {
    die ("SECURITY FATAL: the file can't contain '..'. Please report the issue on the forum at civicrm.org");
  }

  $sql = file_get_contents(dirname( __FILE__ ) .'/../../sql/'.$file.'.sql', true);
  if (!$sql) {
    throw new API_Exception ("unknown file or empty one");
  }
echo "running $file\n";
  CRM_Utils_File::sourceSQLFile($config->dsn, $sql, NULL, true, false);
  return civicrm_api3_create_success(array("query"=>$sql), $params);

}

