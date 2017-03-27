DROP PROCEDURE IF EXISTS `proc_get_national_sustxfail_regimen`;
DELIMITER //
CREATE PROCEDURE `proc_get_national_sustxfail_regimen`
(IN filter_year INT(11), IN from_month INT(11), IN to_month INT(11))
BEGIN
  SET @QUERY =    "SELECT `vp`.`name`, SUM(`vnr`.`sustxfail`) AS `sustxfail`
                    FROM `vl_national_regimen` `vnr`
                    JOIN `viralprophylaxis` `vp`
                        ON `vnr`.`regimen` = `vp`.`ID`
                WHERE 1";

    

    IF (from_month != 0 && from_month != '') THEN
      IF (to_month != 0 && to_month != '') THEN
            SET @QUERY = CONCAT(@QUERY, " AND `vnr`.`year` = '",filter_year,"' AND `vnr`.`month` BETWEEN '",from_month,"' AND '",to_month,"' ");
        ELSE
            SET @QUERY = CONCAT(@QUERY, " AND `vnr`.`year` = '",filter_year,"' AND `vnr`.`month`='",from_month,"' ");
        END IF;
    ELSE
        SET @QUERY = CONCAT(@QUERY, " AND `vnr`.`year` = '",filter_year,"' ");
    END IF;

    SET @QUERY = CONCAT(@QUERY, "  GROUP BY `vp`.`name` ");

    PREPARE stmt FROM @QUERY;
    EXECUTE stmt;
    
END //
DELIMITER ;
