/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.OaCommission;
import com.thinkgem.jeesite.modules.oa.dao.OaCommissionDao;

/**
 * 佣金统计Service
 * @author frank
 * @version 2016-09-07
 */
@Service
@Transactional(readOnly = true)
public class OaCommissionService extends CrudService<OaCommissionDao, OaCommission> {

	public OaCommission get(String id) {
		return super.get(id);
	}
	
	public List<OaCommission> findList(OaCommission oaCommission) {
		return super.findList(oaCommission);
	}
	
	public Page<OaCommission> findPage(Page<OaCommission> page, OaCommission oaCommission) {
		return super.findPage(page, oaCommission);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommission oaCommission) {
		super.save(oaCommission);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommission oaCommission) {
		super.delete(oaCommission);
	}
	
}