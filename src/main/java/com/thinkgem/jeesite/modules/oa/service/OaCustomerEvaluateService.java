/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.OaCustomerEvaluate;
import com.thinkgem.jeesite.modules.oa.dao.OaCustomerEvaluateDao;

/**
 * 客户评价Service
 * @author frank
 * @version 2016-09-05
 */
@Service
@Transactional(readOnly = true)
public class OaCustomerEvaluateService extends CrudService<OaCustomerEvaluateDao, OaCustomerEvaluate> {

	public OaCustomerEvaluate get(String id) {
		return super.get(id);
	}
	
	public List<OaCustomerEvaluate> findList(OaCustomerEvaluate oaCustomerEvaluate) {
		return super.findList(oaCustomerEvaluate);
	}
	
	public Page<OaCustomerEvaluate> findPage(Page<OaCustomerEvaluate> page, OaCustomerEvaluate oaCustomerEvaluate) {
		return super.findPage(page, oaCustomerEvaluate);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCustomerEvaluate oaCustomerEvaluate) {
		super.save(oaCustomerEvaluate);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCustomerEvaluate oaCustomerEvaluate) {
		super.delete(oaCustomerEvaluate);
	}
	
}