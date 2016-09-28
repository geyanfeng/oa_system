/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractRefund;

/**
 * 合同退预付款DAO接口
 * @author anthony
 * @version 2016-09-27
 */
@MyBatisDao
public interface ContractRefundDao extends CrudDao<ContractRefund> {
	
}