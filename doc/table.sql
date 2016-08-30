DROP TABLE IF EXISTS `oa_commission`;
CREATE TABLE `oa_commission` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `YEAR` int(4) unsigned NOT NULL COMMENT '年',
  `QUARTER` smallint(1) unsigned NOT NULL COMMENT '季度',
  `CONTRACT_ID` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin COMMENT '合同ID',
  `PAYMENT_ID` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '支付ID',
  `SV` decimal(20,4) COMMENT '合同金额',
  `COG` decimal(20,4) COMMENT '合同采购成本',
  `CC` decimal(20,4)COMMENT '客户费用',
  `LC` decimal(20,4) COMMENT '物流费用',
  `BILLING_DATE` datetime COMMENT '开票日期',
  `PAY_DATE` datetime COMMENT '收款日期',
  `PCCDAY` int(5) signed  COMMENT '账期天数',
  `PAYMENT` decimal(20,4) COMMENT '支付金额(所有产品组)',
  `RATE` decimal(20,10) COMMENT '产品组占比支付百分比',
  `K_SALER_ID` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin COMMENT ' 销售人员ID',
  `K_ID` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin COMMENT ' 销售人员ID',
  `K_NAME` varchar(255) COMMENT ' 产品组名称',
  `K_SV` decimal(20,4) COMMENT '付款金额',
  `K_COG` decimal(20,4) COMMENT '采购成本',
  `K_CC` decimal(20,4) COMMENT '客户费用',
  `K_LC` decimal(20,4) COMMENT '物流费用',
  `K_GP` decimal(20,4) COMMENT '毛利GP=销售额SV-采购成本COG-客户费用CC*1.1',
  `K_GPI` decimal(20,4) COMMENT '毛利指标为GPI,本Q指标',
  `K_TR` decimal(20,4) COMMENT '税收点数TR',
  `K_AC` decimal(20,4) COMMENT 'AC调整系数AC 如净利（NP)<0，则调整系数 AC=1',
  `K_EC` decimal(20,4) COMMENT '激励系数EC 如净利（NP)<0，则激励系数 EC=1',
  `K_PCC` decimal(20,4) COMMENT '账期点数PCC',
  `K_COS` decimal(20,4) COMMENT '销售费用COS=销售额SV*税收点数TR+采购成本COG*账期点数PCC+物流费用LC',
  `K_NP` decimal(20,4) COMMENT '净利NP=毛利GP-销售费用COS',
  `K_SCC` decimal(20,4) COMMENT '提成系数SCC',
  `K_SC` decimal(20,4) COMMENT '提成SC=净利NP*提成系数SCC*调整系数AC+(销售额SV-客户费用CC*1.1-销售额（SV)*税收点数TR)*激励系数EC',
  `GP` decimal(20,4) COMMENT '实际完成毛利为GP',
  `UPDATE_DATE` datetime NOT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='佣金计算';

DROP TABLE IF EXISTS `oa_quarter_setting`;
CREATE TABLE `oa_quarter_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `year` int(4) unsigned NOT NULL COMMENT '年',
  `quarter` smallint(1) unsigned COMMENT '季度',
  `tr_k1` decimal(10,3) COMMENT '税收点数TR（根据产品组或税收情况调整）',
  `tr_k2` decimal(10,3) COMMENT '税收点数TR',
  `tr_k3` decimal(10,3) COMMENT '税收点数TR',
  `tr_k4` decimal(10,3) COMMENT '税收点数TR',
  `tr_k5` decimal(10,3) COMMENT '税收点数TR',
  `ac_k1` decimal(10,3) COMMENT '调整系数AC（根据公司业务调整）如净利（NP)<0，则调整系数 AC=1',
  `ac_k2` decimal(10,3) COMMENT '调整系数AC',
  `ac_k3` decimal(10,3) COMMENT '调整系数AC',
  `ac_k4` decimal(10,3) COMMENT '调整系数AC',
  `ac_k5` decimal(10,3) COMMENT '调整系数AC',
  `ec_k1` decimal(10,3) COMMENT '激励系数EC（根据公司业务调整） 如净利（NP)<0，则激励系数 EC=1',
  `ec_k2` decimal(10,3) COMMENT '激励系数EC',
  `ec_k3` decimal(10,3) COMMENT '激励系数EC',
  `ec_k4` decimal(10,3) COMMENT '激励系数EC',
  `ec_k5` decimal(10,3) COMMENT '激励系数EC',
  `scc_p1` decimal(10,3) COMMENT '提成系数（SCC)毛利指标为GPI实际完成毛利为GP',
  `scc_p2` decimal(10,3) COMMENT '提成系数（SCC)',
  `scc_p3` decimal(10,3) COMMENT '提成系数（SCC)',
  `scc_p4` decimal(10,3) COMMENT '提成系数（SCC)',
  `scc_p5` decimal(10,3) COMMENT '提成系数（SCC)',
  `pcc_p1` decimal(10,3) COMMENT '账期点数PCC (IF PC<0,PCC=0)  如果账期为负数，则账期点数为零',
  `pcc_p2` decimal(10,3) COMMENT '账期点数PCC (IF PC<0,PCC=0)  如果账期为负数，则账期点数为零',
  `pcc_p3` decimal(10,3) COMMENT '账期点数PCC (IF PC<0,PCC=0)  如果账期为负数，则账期点数为零',
  `pcc_p4` decimal(10,3) COMMENT '账期点数PCC (IF PC<0,PCC=0)  如果账期为负数，则账期点数为零',
  `pcc_p5` decimal(10,3) COMMENT '账期点数PCC (IF PC<0,PCC=0)  如果账期为负数，则账期点数为零',
  `lc_p1` decimal(10,3) COMMENT '物流费用（LC)',
  `lc_p2` decimal(10,3) COMMENT '物流费用（LC)',
  `lc_p3` decimal(10,3) COMMENT '物流费用（LC)',
  `lc_p4` decimal(10,3) COMMENT '物流费用（LC)',
  `lc_p5` decimal(10,3) COMMENT '物流费用（LC)',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='佣金季度参数设置';


DROP TABLE IF EXISTS `oa_quarter_sale_setting`;
CREATE TABLE `oa_quarter_sale_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `year` int(4) unsigned NOT NULL,
  `quarter` smallint(1) unsigned NOT NULL,
  `sale_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '销售人员的ID',
  `gp` decimal(12,2) COMMENT '本Q完成',
  `gpi` decimal(12,2) COMMENT '本Q指标GPI',
  `update_date` datetime NOT NULL COMMENT '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售人员的本Q指标';

DROP TABLE IF EXISTS `oa_customer_evaluate`;
CREATE TABLE `oa_customer_evaluate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(64) NOT NULL COMMENT '客户ID',
  `customer_eval_type` varchar(100) NOT NULL COMMENT '客户评价参数类型',
  `contract_id` varchar(64) COMMENT '合同ID',
  `payment_id` varchar(64) COMMENT '支付ID',
  `plan_pay_date` datetime COMMENT '应付款时间',
  `pay_date` datetime COMMENT '实际付款时间',
  `point` decimal(10,1) NOT NULL COMMENT '点数',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户评价';
