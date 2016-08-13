/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrderProduct;

/**
 * 采购订单DAO接口
 * @author anthony
 * @version 2016-08-13
 */
@MyBatisDao
public interface PurchaseOrderProductDao extends CrudDao<PurchaseOrderProduct> {
}