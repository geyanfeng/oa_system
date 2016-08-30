#计算客户评价
DROP PROCEDURE IF EXISTS calcuate_customer_evaluate;

create procedure calcuate_customer_evaluate()
begin
/*
客户初始分数
违约5日及以内扣除点数 
违约超5日扣除点数
违约超10日扣除点数 
违约超15日扣除点数
违约超30日扣除点数 
客户撤销合同扣除点数  7 
客户正常付款增加点数
客户提前10日以上付款增加点数 
*/
set @eval_type1 = 5;
set @eval_type2 = 10;
set @eval_type3 = 15;
set @eval_type4 = 20;
set @eval_type5 = 25;
set @eval_type6 = 35;
set @eval_type7 = 40;
set @eval_type8 = 45;
set @eval_type9 = 50;

select value into @eval_point1 from oa_customer_eval_setting where eval_type = @eval_type1;
select value into @eval_point2 from oa_customer_eval_setting where eval_type = @eval_type2;
select value into @eval_point3 from oa_customer_eval_setting where eval_type = @eval_type3;
select value into @eval_point4 from oa_customer_eval_setting where eval_type = @eval_type4;
select value into @eval_point5 from oa_customer_eval_setting where eval_type = @eval_type5;
select value into @eval_point6 from oa_customer_eval_setting where eval_type = @eval_type6;
select value into @eval_point7 from oa_customer_eval_setting where eval_type = @eval_type7;
select value into @eval_point8 from oa_customer_eval_setting where eval_type = @eval_type8;
select value into @eval_point9 from oa_customer_eval_setting where eval_type = @eval_type9;

insert into oa_customer_evaluate(customer_id,customer_eval_type,point,create_date) select id,@eval_type1,@eval_point1,now() from oa_customer where used_flag = 1 and del_flag = 0 and evaluate is NULL;
update oa_customer set evaluate = @eval_point1 where used_flag = 1 and del_flag = 0 and evaluate is NULL;
#客户评价
insert into oa_customer_evaluate(customer_id,customer_eval_type,contract_id,payment_id,plan_pay_date,pay_date,point,create_date)
select c.customer_id,
       CASE 
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=5 AND DATEDIFF(f.pay_date,f.plan_pay_date)>0  THEN @eval_type2
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=10 AND DATEDIFF(f.pay_date,f.plan_pay_date)>5 THEN @eval_type3
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=15 AND DATEDIFF(f.pay_date,f.plan_pay_date)>10 THEN @eval_type4
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=30 AND DATEDIFF(f.pay_date,f.plan_pay_date)>15 THEN @eval_type5
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date)>30 THEN @eval_type6
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <= 0 AND DATEDIFF(f.pay_date,f.plan_pay_date) >= -10 THEN @eval_type8
						WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <-10 THEN @eval_type9
				END AS customer_eval_type,
			 f.contract_id,
       f.id,
       f.plan_pay_date,
       f.pay_date,
       CASE 
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=5 AND DATEDIFF(f.pay_date,f.plan_pay_date)>0  THEN -@eval_point2
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=10 AND DATEDIFF(f.pay_date,f.plan_pay_date)>5 THEN -@eval_point3
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=15 AND DATEDIFF(f.pay_date,f.plan_pay_date)>10 THEN -@eval_point4
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <=30 AND DATEDIFF(f.pay_date,f.plan_pay_date)>15 THEN -@eval_point5
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date)>30 THEN -@eval_point6
            WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <= 0 AND DATEDIFF(f.pay_date,f.plan_pay_date) >= -10 THEN @eval_point8
						WHEN DATEDIFF(f.pay_date,f.plan_pay_date) <-10 THEN @eval_point9
				END AS point,
       now()
 from oa_contract_finance f inner join oa_contract c 
 on f.contract_id = c.id 
 where f.del_flag=0 and f.status=3 and f.id not in(select payment_id from oa_customer_evaluate where payment_id is not null); 

#select e.eval_type,e.`value`,d.label from oa_customer_eval_setting e inner join sys_dict d on e.eval_type = d.value where d.type = 'oa_customer_eval_type' order by -eval_type desc;
end