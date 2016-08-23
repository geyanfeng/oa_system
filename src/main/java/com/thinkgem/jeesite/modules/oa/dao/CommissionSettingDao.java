/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.CommissionSetting;

/**
 * 佣金参数设置DAO接口
 * @author anthony
 * @version 2016-08-23
 */
@MyBatisDao
public interface CommissionSettingDao extends CrudDao<CommissionSetting> {
	
}