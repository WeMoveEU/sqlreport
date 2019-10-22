<?php
use CRM_Sqlreport_ExtensionUtil as E;

/**
 * Collection of upgrade steps.
 */
class CRM_Sqlreport_Upgrader extends CRM_Sqlreport_Upgrader_Base {

  // By convention, functions that look like "function upgrade_NNNN()" are
  // upgrade tasks. They are executed in order (like Drupal's hook_update_N).

  public function install() {
    $this->createCustomFields();
  }

  public function createCustomFields() {
    //Contact segments custom group
    $result = civicrm_api3('CustomGroup', 'get', ['name' => "contact_segments"]);
    if ($result['count'] == 0) {
      civicrm_api3('CustomGroup', 'create', [
        'title' => "Segments",
        'extends' => "Contact",
        'name' => "contact_segments",
        'table_name' => "civicrm_value_contact_segments",
      ]);
    }

    //Recurring donors segment
    $result = civicrm_api3('CustomField', 'get', ['name' => "recurring_donor"]);
    if ($result['count'] == 0) {
      civicrm_api3('CustomField', 'create', [
        'custom_group_id' => "contact_segments",
        'label' => "Recurring donor",
        'name' => "recurring_donor",
        'column_name' => "recurring_donor",
        'data_type' => "Int",
        'html_type' => "Radio",
        'is_view' => 1,
        'is_searchable' => 1,
        'option_type' => 1,
        'option_values' => [
          "Not a recurring donor",
          "Failed recurring donor",
          "Past recurring donor",
          "Current recurring donor"
        ],
      ]);

      //Active status
      $result = civicrm_api3('CustomField', 'get', ['name' => "active_status"]);
      if ($result['count'] == 0) {
        civicrm_api3('CustomField', 'create', [
          'custom_group_id' => "contact_segments",
          'label' => "Active status",
          'name' => "active_status",
          'column_name' => "active_status",
          'data_type' => "Int",
          'html_type' => "Radio",
          'is_view' => 1,
          'option_type' => 1,
          'option_values' => ["Not a member", "Inactive", "Active"],
        ]);
      }
    }
  }

}
