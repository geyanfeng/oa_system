/*
alter VIEW `oa_view_forecast` AS 
select p.contract_id, c.create_by as saler_id, c.create_date ,c.amount as sv,p.amount as product_sv, po.amount as product_cog, (p.amount/c.amount)*c.customer_cost as customer_cost,(c.amount - p.amount - ((p.amount/c.amount)*c.customer_cost)*1.1) as gp, g.id as k_type, g.name as k_name
from oa_contract_product p
inner join oa_contract c on p.contract_id = c.id
inner join oa_product_type t on t.id = p.product_type
inner join oa_product_type_group g on g.id= t.type_group
inner join oa_po_product po on po.contract_product_id = p.id
where p.parent_id is NULL and p.cancel_flag=0 and p.del_flag=0 
and c.cancel_flag=0 and c.del_flag=0
and po.cancel_flag=0 and po.del_flag =0
and c.`status` >=10;
*/
DROP PROCEDURE IF EXISTS report_forecast_statistics;

create procedure report_forecast_statistics(
IN sqlCondition VARCHAR(500)
)
begin

	SET @COUNTSTMT := CONCAT("select year(create_date) year,month(create_date) as month,FLOOR(sum(gp)) as gp from oa_view_forecast where 1=1 ", sqlCondition,"  group by year(create_date),month(create_date)");
	PREPARE STMT FROM @COUNTSTMT; 
	EXECUTE STMT; 

end

