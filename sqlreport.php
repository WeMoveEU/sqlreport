<?php

require_once 'sqlreport.civix.php';

function sqlreport_civicrm_pageRun(&$page) {
  $pageName = $page->getVar('_name');
  if ($pageName == 'CRM_Civisualize_Page_Main') {
    CRM_Core_Resources::singleton()
    ->addStyleFile('eu.wemove.sqlreport', 'public/datatables.min.css')
    ->addScriptFile('eu.wemove.sqlreport', 'public/datatables.min.js', 110, 'html-header', FALSE)
    ->addScriptFile('eu.wemove.sqlreport', 'node_modules/reductio/reductio.min.js', 110, 'html-header', FALSE);
  }
}
/**
 * Implementation of hook_civicrm_config
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_config
 */
function sqlreport_civicrm_config(&$config) {
  _sqlreport_civix_civicrm_config($config);
}

/**
 * Implementation of hook_civicrm_xmlMenu
 *
 * @param $files array(string)
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_xmlMenu
 */
function sqlreport_civicrm_xmlMenu(&$files) {
  _sqlreport_civix_civicrm_xmlMenu($files);
}

/**
 * Implementation of hook_civicrm_install
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_install
 */
function sqlreport_civicrm_install() {
  _sqlreport_civix_civicrm_install();
}

/**
 * Implementation of hook_civicrm_uninstall
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_uninstall
 */
function sqlreport_civicrm_uninstall() {
  _sqlreport_civix_civicrm_uninstall();
}

/**
 * Implementation of hook_civicrm_enable
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_enable
 */
function sqlreport_civicrm_enable() {
  _sqlreport_civix_civicrm_enable();
}

/**
 * Implementation of hook_civicrm_disable
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_disable
 */
function sqlreport_civicrm_disable() {
  _sqlreport_civix_civicrm_disable();
}

/**
 * Implementation of hook_civicrm_upgrade
 *
 * @param $op string, the type of operation being performed; 'check' or 'enqueue'
 * @param $queue CRM_Queue_Queue, (for 'enqueue') the modifiable list of pending up upgrade tasks
 *
 * @return mixed  based on op. for 'check', returns array(boolean) (TRUE if upgrades are pending)
 *                for 'enqueue', returns void
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_upgrade
 */
function sqlreport_civicrm_upgrade($op, CRM_Queue_Queue $queue = NULL) {
  return _sqlreport_civix_civicrm_upgrade($op, $queue);
}

/**
 * Implementation of hook_civicrm_managed
 *
 * Generate a list of entities to create/deactivate/delete when this module
 * is installed, disabled, uninstalled.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_managed
 */
function sqlreport_civicrm_managed(&$entities) {
  _sqlreport_civix_civicrm_managed($entities);
}

/**
 * Implementation of hook_civicrm_caseTypes
 *
 * Generate a list of case-types
 *
 * Note: This hook only runs in CiviCRM 4.4+.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_caseTypes
 */
function sqlreport_civicrm_caseTypes(&$caseTypes) {
  _sqlreport_civix_civicrm_caseTypes($caseTypes);
}

/**
 * Implementation of hook_civicrm_alterSettingsFolders
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_alterSettingsFolders
 */
function sqlreport_civicrm_alterSettingsFolders(&$metaDataFolders = NULL) {
  _sqlreport_civix_civicrm_alterSettingsFolders($metaDataFolders);
}

/**
 * Update petition metrics analytics table to indicate that
 * aggregate recipient counts need to be re-computed for the campaign of this mailing
 */
function sqlreport_civicrm_postMailing($mailingId) {
  $mailing = civicrm_api3('Mailing', 'get', ['sequential' => 1, 'id' => $mailingId, 'return' => ['campaign_id']]);
  $campaignId = @(int)$mailing['values'][0]['campaign_id'];
  if ($campaignId) {
    $query =
      "UPDATE analytics_petition_metrics SET need_refresh = 1"
      . " WHERE campaign_id = %1"
      . "   AND activity = %2"
    ;
    $params = [
      1 => [$campaignId, 'Integer'],
      2 => ['unique_recipient', 'String']
    ];
    CRM_Core_DAO::executeQuery($query, $params);

    $campaign = civicrm_api3('Campaign', 'get', ['sequential' => 1, 'id' => $campaignId, 'return' => ['parent_id']]);
    $parentId = @(int)$campaign['values'][0]['parent_id'];
    if ($parentId) {
      $params = [
        1 => [$parentId, 'Integer'],
        2 => ['gunique_recipient', 'String']
      ];
      CRM_Core_DAO::executeQuery($query, $params);
    }
  }
}

/**
 * @param $info
 * @param $tableName
 */
function sqlreport_civicrm_triggerInfo(&$info, $tableName) {
  // fixme workaround
  // fixme triggers on custom fields for contact - update query fails
  foreach ($info as $k => $v) {
    foreach ($v['table'] as $n => $table) {
      if (in_array($table, ['civicrm_value_contact_segments'])) {
        unset($info[$k]['table'][$n]);
      }
    }
  }
}
