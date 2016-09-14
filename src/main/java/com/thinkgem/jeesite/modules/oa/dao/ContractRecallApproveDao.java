/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractRecallApprove;

/**
 * 合同撤回申请DAO接口
 * @author anthony
 * @version 2016-09-14
 */
@MyBatisDao
public interface ContractRecallApproveDao extends CrudDao<ContractRecallApprove> {
	
}