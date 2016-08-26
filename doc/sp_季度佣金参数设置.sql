#获取季度佣金参数
DROP PROCEDURE IF EXISTS quarter_setting;

create procedure quarter_setting()
begin

set @current_Date = CURRENT_DATE;
#年
set @year = year(@Current_Date);
#季度
set @quarter = quarter(@Current_Date);

SELECT count(1) into @count FROM oa_quarter_setting WHERE `year` = @year and `quarter` = @quarter;
IF @count > 0 THEN
    UPDATE oa_quarter_setting SET update_date = now() WHERE `year` = @year and `quarter` = @quarter;
ELSE
    INSERT INTO oa_quarter_setting (`year`, `quarter`, update_date) VALUES (@year,@quarter,now());
END IF;

#K1
set @k1 = '23b0b11b486d48eba9c57c5240aab18b';
set @k2 = '873f3959aa0d48f787b8bc64cbc03ad0';
set @k3 = '35434dee2b684e7a866671d1d6c3ff27';
set @k4 = 'ebdfbb35d52347b6bc1da200275b72a7';
set @k5 = 'f91d39a4b25a4b9f8e9f510b35af784e';

#设置K1..K5 税收点数TR 调整系数AC 激励系数EC
SELECT avalue,bvalue,cvalue into @tr_k1,@ac_k1,@ec_k1 from oa_product_type_group where id=@k1;
UPDATE oa_quarter_setting SET tr_k1=@tr_k1,ac_k1=@ac_k1,ec_k1 =@ec_k1 WHERE `year` = @year and `quarter` = @quarter;
SELECT avalue,bvalue,cvalue into @tr_k2,@ac_k2,@ec_k2 from oa_product_type_group where id=@k2;
UPDATE oa_quarter_setting SET tr_k2=@tr_k2,ac_k2=@ac_k2,ec_k2 =@ec_k2 WHERE `year` = @year and `quarter` = @quarter;
SELECT avalue,bvalue,cvalue into @tr_k3,@ac_k3,@ec_k3 from oa_product_type_group where id=@k3;
UPDATE oa_quarter_setting SET tr_k3=@tr_k3,ac_k3=@ac_k3,ec_k3 =@ec_k3 WHERE `year` = @year and `quarter` = @quarter;
SELECT avalue,bvalue,cvalue into @tr_k4,@ac_k4,@ec_k4 from oa_product_type_group where id=@k4;
UPDATE oa_quarter_setting SET tr_k4=@tr_k4,ac_k4=@ac_k4,ec_k4 =@ec_k4 WHERE `year` = @year and `quarter` = @quarter;
SELECT avalue,bvalue,cvalue into @tr_k5,@ac_k5,@ec_k5 from oa_product_type_group where id=@k5;
UPDATE oa_quarter_setting SET tr_k5=@tr_k5,ac_k5=@ac_k5,ec_k5 =@ec_k5 WHERE `year` = @year and `quarter` = @quarter;

#提成系数（SCC)
set @scc_p1_key = 'bd623a0e964b40c5811b7258be279485';
set @scc_p2_key = '642dc845d8c34d90980d659bab20c59d';
set @scc_p3_key = '39df0657cf524e609ce3b66de0f28653';
set @scc_p4_key = '8575b5cd6795443abb9bb7017b09a6af';
set @scc_p5_key = '665b9f6c97d041fd80e765730eeaae49';
select avalue into @scc_p1 from oa_commission_setting where id=@scc_p1_key;
select avalue into @scc_p2 from oa_commission_setting where id=@scc_p2_key;
select avalue into @scc_p3 from oa_commission_setting where id=@scc_p3_key;
select avalue into @scc_p4 from oa_commission_setting where id=@scc_p4_key;
select avalue into @scc_p5 from oa_commission_setting where id=@scc_p5_key;
UPDATE oa_quarter_setting SET scc_p1 =@scc_p1,scc_p2 =@scc_p2,scc_p3 =@scc_p3,scc_p4 =@scc_p4,scc_p5 =@scc_p5 WHERE `year` = @year and `quarter` = @quarter;

#账期点数PCC
set @pcc_p1_key = '19b24e54059f4d75840605274e8f0cd3';
set @pcc_p2_key = '37a8f486c6e64b6bb0ac9d04b444a0d6';
set @pcc_p3_key = 'f5f43f799eeb44a38f6dfff9b3950eea';
set @pcc_p4_key = '9d88434ea68540308542d19cda04f610';
set @pcc_p5_key = '6fbcd3f9b2084806b9f72ae24e476bb1';
select avalue into @pcc_p1 from oa_commission_setting where id=@pcc_p1_key;
select avalue into @pcc_p2 from oa_commission_setting where id=@pcc_p2_key;
select avalue into @pcc_p3 from oa_commission_setting where id=@pcc_p3_key;
select avalue into @pcc_p4 from oa_commission_setting where id=@pcc_p4_key;
select avalue into @pcc_p5 from oa_commission_setting where id=@pcc_p5_key;
UPDATE oa_quarter_setting SET pcc_p1 =@pcc_p1,pcc_p2 =@pcc_p2,pcc_p3 =@pcc_p3,pcc_p4 =@pcc_p4,pcc_p5 =@pcc_p5 WHERE `year` = @year and `quarter` = @quarter;

#物流费用（LC)
#同城包裹快递
set @lc_p1_key = 1;
select l.cost into @lc_p1 from sys_dict d inner join oa_logistics l on d.`value` = l.`name` WHERE type = 'oa_ship_mode' and value = @lc_p1_key;
#异地包裹快递
set @lc_p2_key = 2;
select l.cost into @lc_p2 from sys_dict d inner join oa_logistics l on d.`value` = l.`name` WHERE type = 'oa_ship_mode' and value = @lc_p2_key;
#同城第三方物流
set @lc_p3_key = 3;
select l.cost into @lc_p3 from sys_dict d inner join oa_logistics l on d.`value` = l.`name` WHERE type = 'oa_ship_mode' and value = @lc_p3_key;
#异地第三方物流
set @lc_p4_key = 4;
select l.cost into @lc_p4 from sys_dict d inner join oa_logistics l on d.`value` = l.`name` WHERE type = 'oa_ship_mode' and value = @lc_p4_key;
#自有物流/无需物流
set @lc_p5_key = 5;
select l.cost into @lc_p5 from sys_dict d inner join oa_logistics l on d.`value` = l.`name` WHERE type = 'oa_ship_mode' and value = @lc_p5_key;
UPDATE oa_quarter_setting SET lc_p1 =@lc_p1,lc_p2 =@lc_p2,lc_p3 =@lc_p3,lc_p4 =@lc_p4,lc_p5 =@lc_p5 WHERE `year` = @year and `quarter` = @quarter;

#销售人员本Q指标，即GPI  提成系数（SCC)计算（毛利指标为GPI，实际完成毛利为GP）
DELETE FROM oa_quarter_sale_setting WHERE `year` = @year and `quarter` = @quarter;
INSERT INTO oa_quarter_sale_setting (`year`, `quarter`, `sale_id`, `gpi`, `update_date`) select @year, @quarter, saler_id, gpi, now() from oa_people_setting;

end
