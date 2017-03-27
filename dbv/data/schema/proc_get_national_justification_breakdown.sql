DROP PROCEDURE IF EXISTS `proc_get_national_justification_breakdown`;
DELIMITER //
CREATE PROCEDURE `proc_get_national_justification_breakdown`
(IN justification INT(11), IN filter_year INT(11), IN from_month INT(11), IN to_month INT(11))
BEGIN
  SET @QUERY =    "SELECT 
                        SUM(`Undetected`) AS `Undetected`,
                        SUM(`less1000`) AS `less1000`, 
                        SUM(`less5000`) AS `less5000`,
                        SUM(`above5000`) AS `above5000`
                    FROM `vl_national_justification` 
                    WHERE 1";

  
    IF (from_month != 0 && from_month != '') THEN
      IF (to_month != 0 && to_month != '') THEN
            SET @QUERY = CONCAT(@QUERY, " AND `year` = '",filter_year,"' AND `month` BETWEEN '",from_month,"' AND '",to_month,"' ");
        ELSE
            SET @QUERY = CONCAT(@QUERY, " AND `year` = '",filter_year,"' AND `month`='",from_month,"' ");
        END IF;
    ELSE
        SET @QUERY = CONCAT(@QUERY, " AND `year` = '",filter_year,"' ");
    END IF;

    SET @QUERY = CONCAT(@QUERY, " AND `justification` = '",justification,"' ");

    PREPARE stmt FROM @QUERY;
    EXECUTE stmt;
END //
DELIMITER ;
