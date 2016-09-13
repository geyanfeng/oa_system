DROP PROCEDURE IF EXISTS report_supplier_statistics;

create procedure report_supplier_statistics(
IN pageNo INT, 
IN pageSize INT,   
IN sqlCondition VARCHAR(500),  
IN orderBy VARCHAR(100)
)
begin
#select * from oa_po_finance

#已完成订单数
#select supplier_id,COUNT(*) as finishedcount from oa_po where status in ('90','100') group by supplier_id;

#未完成订单数
#select supplier_id,COUNT(*) as finishedcount from oa_po where status not in ('90','100') group by supplier_id;
/*
alter VIEW `oa_view_supplier` AS 
select f.po_id,p.`status`,p.supplier_id,s.`name`,(s.shipping_speed + s.communication_efficiency + s.product_quality + s.service_attitude)/4 as evaluate_value ,f.pay_date,f.amount 
from oa_po_finance f inner join oa_po p on f.po_id = p.id 
INNER JOIN oa_supplier s on s.id= p.supplier_id
where f.cancel_flag = '0' and f.del_flag = '0' and f.pay_date is not NULL;
*/
#select * from oa_view_supplier
SET pageNo = (pageNo-1 ) * pageSize;  

SET @COUNTSTMT := CONCAT("select COUNT(a.supplier_id) into @COUNT from (select supplier_id from oa_view_supplier where 1=1 ", sqlCondition," GROUP BY supplier_id) a");
PREPARE STMT FROM @COUNTSTMT; 
EXECUTE STMT;  

SET @STMT := CONCAT("select @COUNT as count,a.supplier_id as supplierId, a.name, a.evaluate_value as evaluateValue,
CASE
    WHEN b.finished_count is null THEN 0
	  ELSE b.finished_count
END as finishedCount,
CASE
    WHEN c.unfinished_count is null THEN 0
	  ELSE c.unfinished_count
END as unfinishedCount,
CASE
    WHEN b.finished_count is null THEN (a.total_amount/(c.unfinished_count))
    WHEN c.unfinished_count is null THEN (a.total_amount/(b.finished_count))
	  ELSE (a.total_amount/(b.finished_count + c.unfinished_count))
END as avgAmount,
a.total_amount as totalAmount from 
(select supplier_id,name, evaluate_value,SUM(amount) as total_amount from oa_view_supplier where 1=1 ", sqlCondition," GROUP BY supplier_id) a 
left join (select supplier_id,COUNT(DISTINCT(po_id)) as finished_count from oa_view_supplier where status in ('90','100') ", sqlCondition," group by supplier_id ) b on a.supplier_id=b.supplier_id
left join (select supplier_id,COUNT(DISTINCT(po_id)) as unfinished_count from oa_view_supplier where status not in('90','100') ", sqlCondition," group by supplier_id) c on c.supplier_id = a.supplier_id ",
" ", orderBy,
" limit ",pageNo,",",pageSize);
PREPARE STMT FROM @STMT; 
EXECUTE STMT;  
end