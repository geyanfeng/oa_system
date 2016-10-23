/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.OaCommission;

/**
 * 佣金统计DAO接口
 * @author frank
 * @version 2016-09-07
 */
@MyBatisDao
public interface OaCommissionDao extends CrudDao<OaCommission> {
	void reCalc(OaCommission commission);
    void updateStatus(OaCommission commission);
}