/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.BonusRecord;

/**
 * 奖金发放记录DAO接口
 * @author anthony
 * @version 2016-10-19
 */
@MyBatisDao
public interface BonusRecordDao extends CrudDao<BonusRecord> {
	
}