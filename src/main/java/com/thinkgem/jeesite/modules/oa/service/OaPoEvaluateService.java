/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.OaPoEvaluate;
import com.thinkgem.jeesite.modules.oa.dao.OaPoEvaluateDao;

/**
 * 供应商评价Service
 * @author frank
 * @version 2016-08-23
 */
@Service
@Transactional(readOnly = true)
public class OaPoEvaluateService extends CrudService<OaPoEvaluateDao, OaPoEvaluate> {

	public OaPoEvaluate get(String id) {
		return super.get(id);
	}
	
	public List<OaPoEvaluate> findList(OaPoEvaluate oaPoEvaluate) {
		return super.findList(oaPoEvaluate);
	}
	
	public Page<OaPoEvaluate> findPage(Page<OaPoEvaluate> page, OaPoEvaluate oaPoEvaluate) {
		return super.findPage(page, oaPoEvaluate);
	}
	
	@Transactional(readOnly = false)
	public void save(OaPoEvaluate oaPoEvaluate) {
		super.save(oaPoEvaluate);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaPoEvaluate oaPoEvaluate) {
		super.delete(oaPoEvaluate);
	}
	
}