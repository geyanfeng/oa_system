/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.Logistics;
import com.thinkgem.jeesite.modules.oa.dao.LogisticsDao;

/**
 * 物流信息Service
 * @author anthony
 * @version 2016-07-17
 */
@Service
@Transactional(readOnly = true)
public class LogisticsService extends CrudService<LogisticsDao, Logistics> {

	public Logistics get(String id) {
		return super.get(id);
	}
	
	public List<Logistics> findList(Logistics logistics) {
		return super.findList(logistics);
	}
	
	public Page<Logistics> findPage(Page<Logistics> page, Logistics logistics) {
		return super.findPage(page, logistics);
	}
	
	@Transactional(readOnly = false)
	public void save(Logistics logistics) {
		super.save(logistics);
	}
	
	@Transactional(readOnly = false)
	public void delete(Logistics logistics) {
		super.delete(logistics);
	}
	
}