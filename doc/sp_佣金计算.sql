#contract_id合同Id
set @contract_id='f88ac295e92146e3a008085005048f41';
#支付金额
set @payment_amount = 10000;
#账期
#amount 销售额SV
#customer_cost 客户费用CC
#物流方式成本LC
#更新季度参数

#create_by 销售员ID SALE_ID
set @LC=0;
select amount, customer_cost,create_by  into @SV,@CC,@SALE_ID from oa_contract where id=@contract_id and del_flag=0;
#采购总成本COG
select sum(amount) into @COG from oa_po where contract_id = @contract_id and del_flag=0;
#毛利GP=销售额SV-采购成本COG-客户费用CC*1.1
set @GP = (@SV - @COG - @CC *1.1);
#select @SV, @COG, @CC, @GP

#K1...K5,支付金额占销售额的百分比
#K分组采购总成本，K_PAYMENT_AMOUNT付款金额,K_COST_AMOUNT采购成功，K_RATE百分比
select sum(cp.amount) as K_Amount,pg.id as K_ID, pg.`name` as K_NAME, ((sum(cp.amount)/@SV) * @payment_amount) as K_PAYMENT_AMOUNT,((sum(cp.amount)/@SV) * (@payment_amount/@SV) * @COG) as K_COST_AMOUNT,((sum(cp.amount)/@SV) * (@payment_amount/@SV)) as K_RATE from oa_contract_product cp inner join oa_product_type pt on 
cp.product_type=pt.id INNER JOIN oa_product_type_group pg on pg.id=pt.type_group where cp.contract_id = @contract_id and cp.parent_id is NULL and cp.del_flag=0 group by pg.id;



#税收点数TR
#调整系数AC
#激励系数EC
#账期点数PCC
#提成系数（SCC)