DROP PROCEDURE IF EXISTS `proc_get_vl_age_outcomes`;
DELIMITER //
CREATE PROCEDURE `proc_get_vl_age_outcomes`
(IN filter_year INT(11), IN filter_month INT(11))
BEGIN
  SET @QUERY =    "SELECT 
						`ac`.`name`, 
						SUM(`vna`.`less5000`+`vna`.`above5000`) AS `nonsuppressed`, 
						SUM(`vna`.`Undetected`+`vna`.`less1000`) AS `suppressed` 
						FROM `vl_national_age` `vna`
						LEFT JOIN `agecategory` `ac` 
						ON `vna`.`age` = `ac`.`ID`
					WHERE `ac`.`ID` > '5'";

    IF (filter_month != 0 && filter_month != '') THEN
       SET @QUERY = CONCAT(@QUERY, " AND `year` = '",filter_year,"' AND `month`='",filter_month,"' ");
    ELSE
        SET @QUERY = CONCAT(@QUERY, " AND `year` = '",filter_year,"' ");
    END IF;

    SET @QUERY = CONCAT(@QUERY, " GROUP BY `name` ORDER BY `suppressed` DESC, `nonsuppressed` ");
    
    PREPARE stmt FROM @QUERY;
    EXECUTE stmt;
END //
DELIMITER ;