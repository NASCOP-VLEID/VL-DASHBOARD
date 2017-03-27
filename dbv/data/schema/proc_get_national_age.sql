DROP PROCEDURE IF EXISTS `proc_get_national_age`;
DELIMITER //
CREATE PROCEDURE `proc_get_national_age`
(IN filter_year INT(11), IN from_month INT(11), IN to_month INT(11))
BEGIN
  SET @QUERY =    "SELECT
                    `ac`.`name`, 
                    SUM(`vna`.`tests`) AS `agegroups`, 
                    SUM(`vna`.`undetected`+`vna`.`less1000`) AS `suppressed`,
                    SUM(`vna`.`less5000`+`vna`.`above5000`) AS `nonsuppressed`
                FROM `vl_national_age` `vna`
                JOIN `agecategory` `ac`
                    ON `vna`.`age` = `ac`.`ID`
                WHERE 1";

    
    IF (from_month != 0 && from_month != '') THEN
      IF (to_month != 0 && to_month != '') THEN
            SET @QUERY = CONCAT(@QUERY, " AND `vna`.`year` = '",filter_year,"' AND `vna`.`month` BETWEEN '",from_month,"' AND '",to_month,"' ");
        ELSE
            SET @QUERY = CONCAT(@QUERY, " AND `vna`.`year` = '",filter_year,"' AND `vna`.`month`='",from_month,"' ");
        END IF;
    ELSE
        SET @QUERY = CONCAT(@QUERY, " AND `vna`.`year` = '",filter_year,"' ");
    END IF;


    SET @QUERY = CONCAT(@QUERY, " GROUP BY `ac`.`ID` ORDER BY `ac`.`ID` ASC ");

    PREPARE stmt FROM @QUERY;
    EXECUTE stmt;
END //
DELIMITER ;
