/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.ProductTypeGroup;
import com.thinkgem.jeesite.modules.oa.dao.ProductTypeGroupDao;

/**
 * 商品类型组Service
 * @author anthony
 * @version 2016-08-01
 */
@Service
@Transactional(readOnly = true)
public class ProductTypeGroupService extends CrudService<ProductTypeGroupDao, ProductTypeGroup> {

	public ProductTypeGroup get(String id) {
		return super.get(id);
	}
	
	public List<ProductTypeGroup> findList(ProductTypeGroup productTypeGroup) {
		return super.findList(productTypeGroup);
	}
	
	public Page<ProductTypeGroup> findPage(Page<ProductTypeGroup> page, ProductTypeGroup productTypeGroup) {
		return super.findPage(page, productTypeGroup);
	}
	
	@Transactional(readOnly = false)
	public void save(ProductTypeGroup productTypeGroup) {
		super.save(productTypeGroup);
	}
	
	@Transactional(readOnly = false)
	public void delete(ProductTypeGroup productTypeGroup) {
		super.delete(productTypeGroup);
	}
	
}