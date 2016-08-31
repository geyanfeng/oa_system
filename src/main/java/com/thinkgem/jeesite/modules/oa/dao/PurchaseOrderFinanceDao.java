/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrderFinance;

/**
 * 采购订单财务相关DAO接口
 * @author anthony
 * @version 2016-08-31
 */
@MyBatisDao
public interface PurchaseOrderFinanceDao extends CrudDao<PurchaseOrderFinance> {
	
}