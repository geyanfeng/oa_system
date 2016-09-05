/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.OaCustomerEvaluate;

/**
 * 客户评价DAO接口
 * @author frank
 * @version 2016-09-05
 */
@MyBatisDao
public interface OaCustomerEvaluateDao extends CrudDao<OaCustomerEvaluate> {
	
}