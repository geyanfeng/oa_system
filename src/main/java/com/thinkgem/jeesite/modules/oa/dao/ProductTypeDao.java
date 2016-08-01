/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.oa.entity.ProductType;

/**
 * 商品类型DAO接口
 * @author anthony
 * @version 2016-08-01
 */
@MyBatisDao
public interface ProductTypeDao extends CrudDao<ProductType> {
	
}