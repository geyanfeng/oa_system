DROP TABLE IF EXISTS `oa_commission`;
CREATE TABLE `oa_commission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '支付ID',
  `contract_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '合同ID',
  `k_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '产品组ID，K1...K5',
  `k_payment_amount` decimal(12,3) NOT NULL COMMENT '产品组付款金额',
  `k_cost_amount` decimal(12,3) NOT NULL COMMENT '产品组采购成本',
  `k_rate` decimal(12,3) NOT NULL COMMENT '金额比例',
  `k_ship_amount` decimal(12,3) NOT NULL COMMENT '物流费用',
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
