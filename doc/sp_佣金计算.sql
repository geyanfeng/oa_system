#获取季度佣金参数
DROP PROCEDURE IF EXISTS calcuate_quarter_commission;

create procedure calcuate_quarter_commission(IN paymentid varchar(64))
begin
/*
contract_id			合同Id
payment_amount	支付金额
billing_date		开票时间
pay_date  			支付时间
PCCDAY							账期天数
*/

select cast(contract_id as char),amount,billing_date,pay_date,datediff(pay_date,billing_date) INTO @contract_id,@payment_amount,@billing_date,@pay_date,@PCCDAY from oa_contract_finance WHERE id= paymentid;
set @PCCDAY = cast(@PCCDAY as signed integer);
#佣金参数获取
set @current_Date = CURRENT_DATE;
set @year = year(@Current_Date);
set @quarter = quarter(@Current_Date);
select tr_k1,tr_k2,tr_k3,tr_k4,tr_k5,ac_k1,ac_k2,ac_k3,ac_k4,ac_k5,ec_k1,ec_k2,ec_k3,ec_k4,ec_k5,scc_p1,scc_p2,scc_p3,scc_p4,scc_p5,pcc_p1,pcc_p2,pcc_p3,pcc_p4,pcc_p5,lc_p1,lc_p2,lc_p3,lc_p4,lc_p5 into @tr_k1,@tr_k2,@tr_k3,@tr_k4,@tr_k5,@ac_k1,@ac_k2,@ac_k3,@ac_k4,@ac_k5,@ec_k1,@ec_k2,@ec_k3,@ec_k4,@ec_k5,@scc_p1,@scc_p2,@scc_p3,@scc_p4,@scc_p5,@pcc_p1,@pcc_p2,@pcc_p3,@pcc_p4,@pcc_p5,@lc_p1,@lc_p2,@lc_p3,@lc_p4,@lc_p5 from oa_quarter_setting where year=@year and quarter = @quarter;

#账期
#amount 销售额	SV
#customer_cost 客户费用	CC
#物流方式成本LC LC
#create_by 销售员ID SALER_ID

select amount, customer_cost,create_by,  
         CASE ship_mode
            WHEN '1' THEN @lc_p1
            WHEN '2' THEN @lc_p2
            WHEN '3' THEN @lc_p3
            WHEN '4' THEN @lc_p4
            WHEN '5' THEN @lc_p5
         END into @SV,@CC,@SALER_ID,@LC from oa_contract where id=@contract_id and del_flag=0;

#采购总成本COG
select sum(amount) into @COG from oa_po where contract_id = @contract_id and del_flag=0;

#毛利指标为GPI,即本Q指标
select gpi into @GPI from oa_quarter_sale_setting WHERE `year` = @year and `quarter` = @quarter and sale_id = @SALER_ID;

#佣金计算
SELECT count(1) into @count FROM oa_commission WHERE `YEAR` = @year and `QUARTER` = @quarter and PAYMENT_ID = paymentid;
IF @count > 0 THEN
    UPDATE oa_commission SET update_date = now() WHERE `year` = @year and `quarter` = @quarter and PAYMENT_ID = paymentid;
ELSE
    INSERT INTO oa_commission (`YEAR`, `QUARTER`, PAYMENT_ID , UPDATE_DATE) VALUES (@year,@quarter,paymentid,now());
END IF;

#K1...K5,支付金额占销售额的百分比
/*
参与最后计算的,以K_开头
YEAR				年
QUARTER			季度
CONTRACT_ID 合同ID
PAYMENT_ID  支付ID
SV				合同金额
COG 			合同采购成本
CC     	  客户费用
LC		  	物流费用
BILLING_DATE 开票日期
PAY_DATE		 收款日期
PCCDAY		账期天数
PAYMENT		支付金额(所有产品组)
K_SALER_ID 销售人员ID
K_ID			产品组ID
K_NAME		产品组名称
K_SV			付款金额
K_COG			采购成本
K_CC      客户费用
K_LC			物流费用
K_TR			税收点数TR
K_AC			AC调整系数AC 如净利（NP)<0，则调整系数 AC=1
K_EC			激励系数EC 如净利（NP)<0，则激励系数 EC=1
K_PCC				账期点数PCC
RATE 		产品组占比支付百分比

*/
#K1
set @k1 = '23b0b11b486d48eba9c57c5240aab18b';
set @k2 = '873f3959aa0d48f787b8bc64cbc03ad0';
set @k3 = '35434dee2b684e7a866671d1d6c3ff27';
set @k4 = 'ebdfbb35d52347b6bc1da200275b72a7';
set @k5 = 'f91d39a4b25a4b9f8e9f510b35af784e';

select  
				@year as YEAR,
				@quarter as QUARTER,
				@contract_id as CONTRACT_ID,
				paymentid as PAYMENT_ID,
				@SV as SV,
				@COG as COG,
				@CC as CC,
				@LC as LC,
				@billing_date as BILLING_DATE,
				@pay_date as PAY_DATE,
				@PCCDAY AS PCCDAY,
				@payment_amount as PAYMENT,
				((sum(cp.amount)/@SV) * (@payment_amount/@SV)) as RATE,
				@SALER_ID AS K_SALER_ID,
				pg.id as K_ID, 
        pg.`name` as K_NAME, 
        ((sum(cp.amount)/@SV) * @payment_amount) as K_SV, 
        ((sum(cp.amount)/@SV) * (@payment_amount/@SV) * @COG) as K_COG, 
        ((sum(cp.amount)/@SV) * (@payment_amount/@SV) * @CC) as K_CC, 
        ((sum(cp.amount)/@SV) * (@payment_amount/@SV) * @LC) as K_LC,
				@GPI as K_GPI, 
				CASE pg.id
            WHEN @k1 THEN @tr_k1
            WHEN @k2 THEN @tr_k2
            WHEN @k3 THEN @tr_k3
            WHEN @k4 THEN @tr_k4
            WHEN @k5 THEN @tr_k5
				END AS K_TR,
        CASE 
            WHEN pg.id = @k1 THEN @ac_k1
            WHEN pg.id = @k2 THEN @ac_k2
            WHEN pg.id = @k3 THEN @ac_k3
            WHEN pg.id = @k4 THEN @ac_k4
            WHEN pg.id = @k5 THEN @ac_k5
				END AS K_AC,
        CASE pg.id
            WHEN @k1 THEN @ec_k1
            WHEN @k2 THEN @ec_k2
            WHEN @k3 THEN @ec_k3
            WHEN @k4 THEN @ec_k4
            WHEN @k5 THEN @ec_k5
				END AS K_EC,
				CASE
            WHEN @PCCDAY <0 THEN 0
            WHEN @PCCDAY <=30 THEN @pcc_p1
            WHEN @PCCDAY >30 AND @PCCDAY <=45 THEN @pcc_p2
            WHEN @PCCDAY >45 AND @PCCDAY <=60 THEN @pcc_p3
            WHEN @PCCDAY >60 AND @PCCDAY <=75 THEN @pcc_p4
            WHEN @PCCDAY >75 AND @PCCDAY <=90 THEN @pcc_p5
						ELSE (12 + 3*floor((@PCCDAY - 90)/15))
				END AS K_PCC
				from oa_contract_product cp inner join oa_product_type pt on cp.product_type=pt.id 
				INNER JOIN oa_product_type_group pg on pg.id=pt.type_group 
				where cp.contract_id = @contract_id and cp.parent_id is NULL and cp.del_flag=0 group by pg.id;
/*
K_DBP			进销差价DBP
K_GP			毛利GP=销售额SV-采购成本COG-客户费用CC*1.1
K_COS			销售费用COS=销售额SV*税收点数TR+采购成本COG*账期点数PCC+物流费用LC
K_NP			净利NP=毛利GP-销售费用COS
*/
end