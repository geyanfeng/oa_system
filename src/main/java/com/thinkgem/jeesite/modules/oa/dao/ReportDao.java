/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.dao;

import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

import java.util.List;
import java.util.Map;

@MyBatisDao
public interface ReportDao {
	public List<Map> reportSupplierStatistics(Map map);	
	public List<Map> reportCustomerStatistics(Map map);	
	public List<Map> reportContractStatistics(Map map);	
	public List<Map> reportAchievementStatistics(Map map);	
	public List<Map> reportForecastStatistics(Map map);	
	public List<Map> reportReceivableAmount(Map map);	
	public List<Map> reportPayAmount(Map map);	
	public List<Map> reportBillingAmount(Map map);	
	public List<Map> reportHomeFinance();	
	public List<Map> financeCalendar(Map map);	
	public List<Map> reportSalerHome(Map map);
	public List<Map> home_gauge(Map map);
	public List<Map> home_ld_group_by_salar(Map map);
	public List<Map> reportSaleStatistics(Map map);
	public List<Map> comminssionSummary(Map map);

}