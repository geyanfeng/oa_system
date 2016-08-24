/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractFinance;

/**
 * 合同财务相关DAO接口
 * @author anthony
 * @version 2016-08-24
 */
@MyBatisDao
public interface ContractFinanceDao extends CrudDao<ContractFinance> {
	
}