START TRANSACTION ;
DELIMITER @@@
DROP FUNCTION IF EXISTS dontusSetGroupContact@@@
CREATE FUNCTION dontusSetGroupContact(gid INT, cid INT, gst VARCHAR(8)) RETURNS INT(11)
  READS SQL DATA
  DETERMINISTIC
  BEGIN
    DECLARE i INT DEFAULT 0;
    IF (SELECT id FROM civicrm_group_contact WHERE group_id = gid AND contact_id = cid) THEN
      UPDATE civicrm_group_contact
      SET status = gst
      WHERE group_id = gid AND contact_id = cid AND status != gst ;
      SET i = ROW_COUNT();
    ELSE
      INSERT INTO civicrm_group_contact (group_id, contact_id, status)
      VALUES(gid, cid, gst);
      SET i = 1;
    END IF;
    IF i THEN
      INSERT INTO civicrm_subscription_history (group_id, contact_id, date, method, status)
      VALUES (gid, cid, NOW(), 'Admin', gst);
    END IF;
    RETURN i;
  END@@@
DELIMITER ;
COMMIT ;
