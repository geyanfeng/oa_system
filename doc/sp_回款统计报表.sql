DROP PROCEDURE IF EXISTS report_customer_statistics;

create procedure report_customer_statistics(
IN pageNo INT, 
IN pageSize INT,   
IN sqlCondition VARCHAR(500),  
IN orderBy VARCHAR(100)
)
begin

/*
alter VIEW `oa_view_customer` AS 
select
cu.id as customer_id,
cu.`name`,
cu.evaluate as evaluate_value,
f.plan_pay_date,
f.pay_date,
f.amount,
f.contract_id,
c.`status`,
datediff(f.pay_date,f.plan_pay_date) as pay_day,
CASE
  WHEN datediff(f.pay_date,f.plan_pay_date) >0 THEN datediff(f.pay_date,f.plan_pay_date)
	ELSE 0
END AS overdue_day,
CASE
  WHEN datediff(f.pay_date,f.plan_pay_date) >0 THEN 1
	ELSE 0
END AS overdue_times,
CASE
  WHEN datediff(f.pay_date,f.plan_pay_date) >0 THEN (f.amount * datediff(f.pay_date,f.plan_pay_date))
	ELSE 0
END AS overdue_amount
from oa_contract_finance f 
inner join oa_contract c on c.id = f.contract_id
inner join oa_customer cu on cu.id = c.customer_id
where f.cancel_flag = '0' and f.del_flag = '0' and f.pay_date is not NULL and f.status=3;
*/
#select * from oa_view_supplier
SET pageNo = (pageNo-1 ) * pageSize;  

SET @COUNTSTMT := CONCAT("select COUNT(a.customer_id) into @COUNT from (select customer_id from oa_view_customer where 1=1 ", sqlCondition," GROUP BY customer_id) a");
PREPARE STMT FROM @COUNTSTMT; 
EXECUTE STMT;  
#资金日利率
select avalue into @RATE from oa_commission_setting where id='ceee7d108d684470ba028f7e9f8a57d7';
SET @STMT := CONCAT("select @COUNT as recordCount,a.customer_id as customerId, a.name, a.evaluate_value as evaluateValue,
CASE
    WHEN b.finished_count is null THEN 0
	  ELSE b.finished_count
END as finishedCount,
avgPayDay,
CASE
    WHEN c.unfinished_count is null THEN 0
	  ELSE c.unfinished_count
END as unfinishedCount,
a.total_amount as totalAmount,
overdueTimes,
avgOverdueDay,
overdueAmount
 from 
(select customer_id,name, evaluate_value,SUM(amount) as total_amount,ROUND(sum(pay_day)/count(*),1) as avgPayDay,sum(overdue_times) as overdueTimes,ROUND(sum(overdue_day)/count(*),1) as avgOverdueDay,ROUND(sum(overdue_amount)*@RATE,1) as overdueAmount from oa_view_customer where 1=1 ", sqlCondition," GROUP BY customer_id) a 
left join (select customer_id,COUNT(DISTINCT(contract_id)) as finished_count from oa_view_customer where status in ('100') ", sqlCondition," group by customer_id ) b on a.customer_id=b.customer_id
left join (select customer_id,COUNT(DISTINCT(contract_id)) as unfinished_count from oa_view_customer where status not in('100') ", sqlCondition," group by customer_id) c on c.customer_id = a.customer_id ",
" ", orderBy,
" limit ",pageNo,",",pageSize);
PREPARE STMT FROM @STMT; 
EXECUTE STMT;  
end