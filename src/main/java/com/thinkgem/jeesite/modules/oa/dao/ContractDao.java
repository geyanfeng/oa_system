/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.TestAudit;

/**
 * 各种合同DAO接口
 * @author anthony
 * @version 2016-07-30
 */
@MyBatisDao
public interface ContractDao extends CrudDao<Contract> {

    Contract getByName(String name);

    TestAudit getByProcInsId(String procInsId);
}