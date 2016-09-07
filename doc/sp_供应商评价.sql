DROP PROCEDURE IF EXISTS calcuate_supplier_evaluate;

create procedure calcuate_supplier_evaluate(IN supplierid varchar(64))
begin
select 
sum(e.shipping_speed)/count(*),
sum(e.communication_efficiency)/count(*),
sum(e.product_quality)/count(*),
sum(service_attitude)/count(*)
into @shipping_speed,@communication_efficiency,@product_quality,@service_attitude
from oa_po_evaluate e 
inner join oa_po p on e.po_id = p.id 
where p.supplier_id = supplierid;
update oa_supplier set shipping_speed = @shipping_speed,
communication_efficiency = @communication_efficiency,
product_quality = @product_quality,
service_attitude = @service_attitude
where id = supplierid;
end