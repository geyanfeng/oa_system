/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;

import java.util.Date;

/**
 * 各种合同DAO接口
 * @author anthony
 * @version 2016-07-30
 */
@MyBatisDao
public interface ContractDao extends CrudDao<Contract> {

    Contract getByName(String name);

    Contract getByProcInsId(String procInsId);

    Integer getCountByNoPref(String noPref);

    void cancelContract(Contract contract);
}