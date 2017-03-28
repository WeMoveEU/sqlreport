<?php
function _civicrm_api3_sql_runupdate_spec(&$params) {
  $params['file']['api.required'] = 1;
}

/**
 * Action for all scripts.
 *
 * @param $params
 *
 * @return array
 * @throws \API_Exception
 */
function civicrm_api3_sql_runupdateall ($params) {
  $load = sys_getloadavg();
  $load = $load[0];
  if ($load > 2) {
    throw new API_Exception ("load too high, try later $load");
  }
  $config = CRM_Core_Config::singleton();
  foreach (new DirectoryIterator(dirname( __FILE__ ) .'/../../sql') as $file) {
    if ($file->isFile() && substr ($file->getFilename(),-4,4) == ".sql") {
      $filename = substr($file->getFilename(), 0, -4);
      $logId = addLog($filename, $load);
      $r = civicrm_api3("sql", "runupdate", array('file' => $filename));
      updateLog($logId);
      $results["$filename"] = array ("file" => $filename, "result" => $r);
    }
  }
  return civicrm_api3_create_success($results, $params);
}

/**
 * Action contains all scripts except of the slowest update-active-members.sql.
 *
 * @param $params
 *
 * @return array
 * @throws \API_Exception
 */
function civicrm_api3_sql_runupdatehourly ($params) {
  $load = sys_getloadavg();
  $load = $load[0];
  if ($load > 2) {
    throw new API_Exception ("load too high, try later $load");
  }
  foreach (new DirectoryIterator(dirname( __FILE__ ) .'/../../sql') as $file) {
    if ($file->isFile() && substr ($file->getFilename(), -4, 4) == ".sql") {
      $filename = substr($file->getFilename(), 0, -4);
      if ($filename != 'update-active-members') {
        $logId = addLog($filename, $load);
        $r = civicrm_api3("sql", "runupdate", array('file' => $filename));
        updateLog($logId);
        $results["$filename"] = array ("file" => $filename, "result" => $r);
      }
    }
  }
  return civicrm_api3_create_success($results, $params);
}

/**
 * Action for the slowest update-active-members.sql
 *
 * @param $params
 *
 * @return array
 * @throws \API_Exception
 */
function civicrm_api3_sql_runupdateactivemembers ($params) {
  $load = sys_getloadavg();
  $load = $load[0];
  if ($load > 2) {
    throw new API_Exception ("load too high, try later $load");
  }
  $filename = "update-active-members";
  $logId = addLog($filename, $load);
  $r = civicrm_api3("sql", "runupdate", array('file' => $filename));
  updateLog($logId);
  $results["$filename"] = array ("file" => $filename, "result" => $r);
  return civicrm_api3_create_success($results, $params);
}

/**
 * Action for given script (param file).
 *
 * @param $params
 *
 * @return array
 * @throws \API_Exception
 */
function civicrm_api3_sql_runupdate ($params) {
  $config = CRM_Core_Config::singleton();
  //run the query
  $file =  $params['file'];
  if (false !== strpos($file, '..')) {
    die ("SECURITY FATAL: the file can't contain '..'. Please report the issue on the forum at civicrm.org");
  }
  $sql = file_get_contents(dirname( __FILE__ ) . '/../../sql/' . $file . '.sql', true);
  if (!$sql) {
    throw new API_Exception ("unknown file or empty one");
  }
  echo "running $file\n";

  CRM_Core_DAO::executeQuery("SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;");
  CRM_Utils_File::sourceSQLFile($config->dsn, $sql, NULL, true, false);
  return civicrm_api3_create_success(array("query" => $sql), $params);
}


function addLog($script, $sysload) {
  $query = "INSERT INTO analytics_log (script, start, sysload)
            VALUES (%1, NOW(), %2)";
  $params = array(
    1 => array($script, 'String'),
    2 => array($sysload, 'Float'),
  );
  CRM_Core_DAO::executeQuery($query, $params);
  return CRM_Core_DAO::singleValueQuery('SELECT LAST_INSERT_ID()');
}

function updateLog($id) {
  $query = "UPDATE analytics_log
            SET stop = NOW(), duration = TIMESTAMPDIFF(SECOND, start, NOW())
            WHERE id = %1";
  $params = array(
    1 => array($id, 'Integer'),
  );
  $dao = CRM_Core_DAO::executeQuery($query, $params);
  return $dao->affectedRows();
}
