/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.Logistics;

/**
 * 物流信息DAO接口
 * @author anthony
 * @version 2016-07-17
 */
@MyBatisDao
public interface LogisticsDao extends CrudDao<Logistics> {
	
}