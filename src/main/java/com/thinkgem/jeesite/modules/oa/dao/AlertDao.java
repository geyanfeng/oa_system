/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.Alert;

/**
 * 消息提醒DAO接口
 * @author anthony
 * @version 2016-09-08
 */
@MyBatisDao
public interface AlertDao extends CrudDao<Alert> {
	
}