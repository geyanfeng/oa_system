/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface ReportDao {
	public List<Map> reportSupplierStatistics(Map map);	
	public List<Map> reportCustomerStatistics(Map map);	
}