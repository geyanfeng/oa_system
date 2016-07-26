/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractProduct;

/**
 * 各种合同DAO接口
 * @author anthony
 * @version 2016-07-26
 */
@MyBatisDao
public interface ContractProductDao extends CrudDao<ContractProduct> {
	
}