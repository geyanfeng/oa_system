/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractAttachment;

/**
 * 各种合同DAO接口
 * @author anthony
 * @version 2016-08-03
 */
@MyBatisDao
public interface ContractAttachmentDao extends CrudDao<ContractAttachment> {
	
}