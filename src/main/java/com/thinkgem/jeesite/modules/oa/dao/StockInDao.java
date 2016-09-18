/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.StockIn;

/**
 * 转入库存DAO接口
 * @author anthony
 * @version 2016-09-18
 */
@MyBatisDao
public interface StockInDao extends CrudDao<StockIn> {
	
}