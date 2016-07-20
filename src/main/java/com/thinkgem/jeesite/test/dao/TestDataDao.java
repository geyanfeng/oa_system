/**
 * 
 */
package com.thinkgem.jeesite.test.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.test.entity.TestData;

/**
 * 单表生成DAO接口
 * @author ThinkGem
 * @version 2016-07-21
 */
@MyBatisDao
public interface TestDataDao extends CrudDao<TestData> {
	
}