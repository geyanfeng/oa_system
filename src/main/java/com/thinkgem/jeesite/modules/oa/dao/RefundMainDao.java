/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.RefundMain;

/**
 * 退款主数据DAO接口
 * @author anthony
 * @version 2016-09-18
 */
@MyBatisDao
public interface RefundMainDao extends CrudDao<RefundMain> {
	
}