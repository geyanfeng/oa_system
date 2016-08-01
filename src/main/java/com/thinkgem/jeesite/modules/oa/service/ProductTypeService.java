/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.ProductType;
import com.thinkgem.jeesite.modules.oa.dao.ProductTypeDao;

/**
 * 商品类型Service
 * @author anthony
 * @version 2016-08-01
 */
@Service
@Transactional(readOnly = true)
public class ProductTypeService extends CrudService<ProductTypeDao, ProductType> {

	public ProductType get(String id) {
		return super.get(id);
	}
	
	public List<ProductType> findList(ProductType productType) {
		return super.findList(productType);
	}
	
	public Page<ProductType> findPage(Page<ProductType> page, ProductType productType) {
		return super.findPage(page, productType);
	}
	
	@Transactional(readOnly = false)
	public void save(ProductType productType) {
		super.save(productType);
	}
	
	@Transactional(readOnly = false)
	public void delete(ProductType productType) {
		super.delete(productType);
	}
	
}