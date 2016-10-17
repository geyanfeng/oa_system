/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.ReportDao;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.entity.ProductTypeGroup;
import com.thinkgem.jeesite.modules.oa.entity.SearchParams;
import com.thinkgem.jeesite.modules.oa.entity.Supplier;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeGroupService;
import com.thinkgem.jeesite.modules.oa.service.SupplierService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value = "${adminPath}/report")
public class ReportController extends BaseController {
	@Autowired
	private ReportDao reportDao;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private CustomerService customerService;
	@Autowired
	private ProductTypeGroupService productTypeGroupService;

	@RequiresPermissions("oa:report:view")
	@RequestMapping(value = { "list", "" })
	public String list(SearchParams searchParams, HttpServletRequest request,
			HttpServletResponse response, Model model) {

		if (StringUtils.isNumeric(request.getParameter("reportType"))) {
			int reportType = Integer.parseInt(request
					.getParameter("reportType"));

			Page page = new Page(request, response);
			String sqlCondition = "";

			if (!StringUtils.isBlank(searchParams.getStartTime())) {
				if (reportType == 1 || reportType == 2) {
					sqlCondition += " and pay_date>='"
							+ searchParams.getStartTime() + "'";
				} else if (reportType == 3) {
					sqlCondition += " and year>=" + searchParams.getStartTime();
				} else if (reportType == 7) {
					sqlCondition += " and billing_date>='"
							+ searchParams.getStartTime() + "'";
				}
			}
			if (!StringUtils.isBlank(searchParams.getEndTime())) {
				if (reportType == 1 || reportType == 2) {
					sqlCondition += " and pay_date<='"
							+ searchParams.getEndTime() + "'";
				} else if (reportType == 3) {
					sqlCondition += " and year<=" + searchParams.getEndTime();
				} else if (reportType == 7) {
					sqlCondition += " and billing_date<='"
							+ searchParams.getEndTime() + "'";
				}
			}

			if (reportType == 1 || reportType == 6) {
				// 获取所有供应商
				List<Supplier> supplierList = supplierService
						.findList(new Supplier());
				model.addAttribute("supplierList", supplierList);
				if (!StringUtils.isBlank(searchParams.getSupplierId())) {
					sqlCondition += "  and supplier_id='"
							+ searchParams.getSupplierId() + "'";
				}
				if (reportType == 6) {
					if (!StringUtils.isBlank(searchParams.getPayCondition())) {
						sqlCondition += "  and pay_condition='"
								+ searchParams.getPayCondition() + "'";
					}
				}
			}

			
			if (!StringUtils.isBlank(searchParams.getInvoiceType())) {
				sqlCondition += "  and invoice_type='"
						+ searchParams.getInvoiceType() + "'";
			}
			
			if (reportType == 2 || reportType == 3 || reportType == 5 || reportType == 7) {
				if (!StringUtils.isBlank(searchParams.getCustomerId())) {
					sqlCondition += "  and customer_id='"
							+ searchParams.getCustomerId() + "'";
				}
				// 获取所有客户
				List<Customer> customerList = customerService
						.findList(new Customer());
				model.addAttribute("customerList", customerList);
				
				if (reportType == 5) {
					List<User> salerList = UserUtils
							.getUsersByRoleEnName("saler");
					model.addAttribute("salerList", salerList);
		
					if (!StringUtils.isBlank(searchParams.getSalerId())) {
						sqlCondition += "  and saler_id='"
								+ searchParams.getSalerId() + "'";
					}
					if (!StringUtils.isBlank(searchParams.getCompanyId())) {
						sqlCondition += "  and company_id='"
								+ searchParams.getCompanyId() + "'";
					}
					if (!StringUtils.isBlank(searchParams.getBillingStatus())) {
						if (searchParams.getBillingStatus().equals("2")) {
							sqlCondition += "  and finance_status in (2,3) ";
						} else {
							sqlCondition += "  and finance_status =1 ";
						}
					}
					if (!StringUtils.isBlank(searchParams.getPayStatus())) {
						if (searchParams.getPayStatus().equals("2")) {
							sqlCondition += "  and finance_status = 3 ";
						} else {
							sqlCondition += "  and finance_status in (1,2) ";
						}
					}
					if (!StringUtils.isBlank(searchParams.getOverStatus())) {
						if (searchParams.getOverStatus().equals("2")) {
							sqlCondition += "  and billing_date is not null and ((pay_date is null and NOW()>plan_pay_date) OR (pay_date is not null and pay_date>plan_pay_date)) ";
						} else {
							sqlCondition += "  and billing_date is not null and ((pay_date is null and NOW()<=plan_pay_date) OR (pay_date is not null and pay_date<=plan_pay_date))";
						}
					}
				}
			}

			if (reportType == 3 || reportType == 4) {
				boolean isSaler = UserUtils.IsRoleByRoleEnName("saler");
				if (isSaler && !UserUtils.IsRoleByRoleEnName("cso")) {
					sqlCondition += "  and saler_id='"
							+ UserUtils.getUser().getId() + "'";
				} else {
					List<User> salerList = UserUtils
							.getUsersByRoleEnName("saler");
					if (searchParams.getSalerIds() != null
							&& searchParams.getSalerIds().length > 0) {
						String salerIds = "";
						for (String salerId : searchParams.getSalerIds()) {
							salerIds += "'" + salerId + "',";
						}
						sqlCondition += "  and saler_id in("
								+ salerIds.substring(0, salerIds.length() - 1)
								+ ")";
					} else {
						String[] selectedSalerIds = new String[salerList.size()];
						for (int i = 0; i < selectedSalerIds.length; i++) {
							selectedSalerIds[i] = salerList.get(i).getId();
						}
						searchParams.setSalerIds(selectedSalerIds);
					}
					model.addAttribute("salerList", salerList);
				}
				model.addAttribute("isSaler", isSaler);
			}
			// 设置排序参数
			String orderBy = request.getParameter("orderBy");
			if (!StringUtils.isNotBlank(orderBy)) {

			}

			if (reportType == 6 || reportType == 5) {
				orderBy = "order by plan_pay_date desc";
			} 
			else if (reportType == 7) {
				orderBy = "order by billing_date desc";
			}
			else {
				orderBy = "";
			}
			Map queryMap = new LinkedHashMap();
			queryMap.put("pageNo", page.getPageNo());
			queryMap.put("pageSize", page.getPageSize());
			queryMap.put("sqlCondition", sqlCondition);
			queryMap.put("orderBy", orderBy);

			List<Map> list = null;
			Map headers = new LinkedHashMap();

			model.addAttribute("reportType", reportType);
			switch (reportType) {
			case 1:
				model.addAttribute("title", "付款统计报表");
				headers.put("name", "供应商名称");
				headers.put("evaluateValue", "评分");
				headers.put("finishedCount", "订单数(已完)");
				headers.put("unfinishedCount", "订单数(未完)");
				headers.put("avgAmount", "平均订单金额");
				headers.put("totalAmount", "完成总金额");

				list = reportDao.reportSupplierStatistics(queryMap);

				if(list.size()>0) {
					Integer finishedCount = 0;
					Integer unfinishedCount = 0;
					Double avgAmount = 0.00;
					Double totalAmount = 0.00;
					for (Map map : list) {
						finishedCount += Integer.parseInt(map.get("finishedCount").toString());
						unfinishedCount += Integer.parseInt(map.get("unfinishedCount").toString());
						avgAmount += Double.parseDouble(map.get("avgAmount").toString());
						totalAmount += Double.parseDouble(map.get("totalAmount").toString());
					}
					model.addAttribute("finishedCount", finishedCount);
					model.addAttribute("unfinishedCount", unfinishedCount);
					model.addAttribute("avgAmount", avgAmount / list.size());
					model.addAttribute("totalAmount", totalAmount);
				}
				break;
			case 2:
				model.addAttribute("title", "回款统计报表");
				headers.put("name", "客户名称");
				headers.put("evaluateValue", "评分");
				headers.put("finishedCount", "合同数(已完)");
				headers.put("avgPayDay", "平均付款期");
				headers.put("unfinishedCount", "合同数(未完)");
				headers.put("totalAmount", "总金额");
				headers.put("overdueTimes", "逾期次数");
				headers.put("avgOverdueDay", "平均逾期时间");
				headers.put("overdueAmount", "逾期损失");
				list = reportDao.reportCustomerStatistics(queryMap);

				if(list.size()>0) {
					Integer finishedCount = 0;
					Double avgPayDay = 0.0;
					Integer unfinishedCount = 0;
					Double totalAmount = 0.00;
					Integer overdueTimes = 0;
					Double avgOverdueDay = 0.0;
					Double overdueAmount = 0.00;
					for (Map map : list) {
						finishedCount += Integer.parseInt(map.get("finishedCount").toString());
						avgPayDay += Double.parseDouble(map.get("avgPayDay").toString());
						unfinishedCount += Integer.parseInt(map.get("unfinishedCount").toString());
						totalAmount += Double.parseDouble(map.get("totalAmount").toString());
						overdueTimes += Integer.parseInt(map.get("overdueTimes").toString());
						avgOverdueDay += Double.parseDouble(map.get("avgOverdueDay").toString());
						overdueAmount += Double.parseDouble(map.get("overdueAmount").toString());
					}
					model.addAttribute("finishedCount", finishedCount);
					model.addAttribute("avgPayDay", avgPayDay/list.size());
					model.addAttribute("unfinishedCount", unfinishedCount);
					model.addAttribute("totalAmount", totalAmount);
					model.addAttribute("overdueTimes", overdueTimes);
					model.addAttribute("avgOverdueDay", avgOverdueDay / list.size());
					model.addAttribute("overdueAmount", overdueAmount);
				}
				break;
			case 3:
				model.addAttribute("title", "业绩统计报表");
				headers.put("createDate", "日期");
				headers.put("no", "合同号");
				headers.put("companyName", "公司抬头");
				headers.put("customerName", "客户");
				headers.put("name", "合同名称");
				headers.put("amount", "合同金额");
				headers.put("status", "合同状态");
				headers.put("salerName", "销售");
				headers.put("businessName", "商务协同");
				headers.put("artisanName", "技术协同");

				list = reportDao.reportContractStatistics(queryMap);
				List<Map> achievementList = reportDao
						.reportAchievementStatistics(queryMap);
				model.addAttribute("achievementList", achievementList);

				break;
			case 4:
				model.addAttribute("title", "来单预测报表");
				List<Map> forecastList = reportDao
						.reportForecastStatistics(queryMap);
				model.addAttribute("forecastList", forecastList);
				model.addAttribute("productTypeGroup_list",
						productTypeGroupService
								.findList(new ProductTypeGroup()));
				break;
			case 5:
				model.addAttribute("title", "应收列表");
				headers.put("finance_no", "收款流水号");
				headers.put("company_name", "单位");
				headers.put("saler_name", "销售");
				headers.put("customer_name", "客户");
				headers.put("contract_name", "项目名称");
				headers.put("contract_status_name", "合同状态");
				headers.put("receivable_amount", "应收金额");
				headers.put("billing_date", "开票日期");
				headers.put("payment_days", "账期");
				headers.put("plan_pay_date", "应收日期");
				headers.put("finance_status_name", "收款状态");
				headers.put("finance_amount", "收款金额");
				headers.put("pay_date", "实收日期");
				headers.put("over_days", "逾期天数");
				list = reportDao.reportReceivableAmount(queryMap);
				break;
			case 6:
				model.addAttribute("title", "应付列表");
				headers.put("finance_no", "付款流水号");
				headers.put("company_name", "单位");
				headers.put("supplier_name", "收款方");
				headers.put("plan_pay_date", "到期日");
				headers.put("amount", "金额");
				headers.put("pay_condition_name", "付款条件");
				headers.put("pay_method_name", "付款方式");
				headers.put("pay_status_name", "状态");
				headers.put("pay_date", "付款日期");
				list = reportDao.reportPayAmount(queryMap);
				break;
			case 7:
				model.addAttribute("title", "开票列表");
				headers.put("billing_no", "发票流水号");
				headers.put("company_name", "我司抬头");
				headers.put("contract_name", "合同名称");
				headers.put("customer_name", "客户名称");
				headers.put("receivable_amount", "发票金额");
				headers.put("invoice_type_name", "发票类型");
				headers.put("billing_date", "实际开票时间");
				list = reportDao.reportBillingAmount(queryMap);
				break;
			}

			if (reportType != 4) {
				if (list != null && list.size() > 0) {
					Set set = list.get(0).entrySet();
					Iterator i = set.iterator();
					while (i.hasNext()) {
						Map.Entry me = (Map.Entry) i.next();
						if (me.getKey().toString().equals("recordCount")) {
							page.setCount(Long.parseLong(me.getValue()
									.toString()));
							break;
						}
					}
					// page.setCount(list.get(0).values().g);
				} else {
					page.setCount(0);
				}

				page.setList(list);
				model.addAttribute("page", page);
			}
			model.addAttribute("headers", headers);

		}

		return "modules/oa/reportList";
	}

	@RequiresPermissions("oa:report:saleStatistics")
	@RequestMapping(value = { "saleStatistics" })
	public String sale_statistics(SearchParams searchParams, HttpServletRequest request, HttpServletResponse response, Model model) {
		//设置默认类型
		if (StringUtils.isBlank(searchParams.getReportType())) {
			searchParams.setReportType("3");
		}

		List<User> salerList = UserUtils.getUsersByRoleEnName("saler");
		if (searchParams.getSalerIds() == null) {
			String[] selectedSalerIds = new String[salerList.size()];
			for (int i = 0; i < selectedSalerIds.length; i++) {
				selectedSalerIds[i] = salerList.get(i).getId();
			}
			searchParams.setSalerIds(selectedSalerIds);
		}
		model.addAttribute("salerList", salerList);//销售员列表

		model.addAttribute("customerList", customerService.findList(new Customer()));//客户列表


		String sqlCondition = "";


		if (searchParams.getSalerIds() != null
				&& searchParams.getSalerIds().length > 0) {
			String salerIds = "";
			for (String salerId : searchParams.getSalerIds()) {
				salerIds += "'" + salerId + "',";
			}

			sqlCondition += "  and c.create_by in("
					+ salerIds.substring(0, salerIds.length() - 1)
					+ ")";
		}
		SimpleDateFormat dataFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (StringUtils.isNotBlank(searchParams.getStartTime())) {
			Calendar cc = Calendar.getInstance();
			sqlCondition += StringUtils.isNotBlank(sqlCondition) ? " and " : "";
			String[] startTimes = searchParams.getStartTime().split("-");
			cc.set(Calendar.YEAR, Integer.parseInt(startTimes[0]));
			cc.set(Calendar.MONTH, Integer.parseInt(startTimes[1]) - 1);
			cc.set(Calendar.DAY_OF_MONTH, 1);
			cc.set(Calendar.HOUR_OF_DAY, 0);
			cc.set(Calendar.SECOND, 0);
			cc.set(Calendar.MINUTE, 0);
			cc.set(Calendar.MILLISECOND, 0);
			sqlCondition += "c.create_date>='" + dataFormat.format(cc.getTime()) + "'";
		}

		if (StringUtils.isNotBlank(searchParams.getEndTime())) {
			Calendar cc = Calendar.getInstance();
			String[] endTimes = searchParams.getEndTime().split("-");
			cc.set(Calendar.YEAR, Integer.parseInt(endTimes[0]));
			cc.set(Calendar.MONTH, Integer.parseInt(endTimes[1]));
			cc.set(Calendar.DAY_OF_MONTH, 1);
			cc.add(Calendar.DATE, -1);
			cc.set(Calendar.HOUR_OF_DAY, 24);
			cc.set(Calendar.SECOND, 0);
			cc.set(Calendar.MINUTE, 0);
			cc.set(Calendar.MILLISECOND, 0);
			sqlCondition += " and c.create_date<='" + dataFormat.format(cc.getTime()) + "'";
		}

		if (StringUtils.isNotBlank(searchParams.getCustomerId())) {
			sqlCondition += " and c.customer_id='" + searchParams.getCustomerId() + "'";
		}

		Page page = new Page(request, response);

		Map queryMap = new LinkedHashMap();
		queryMap.put("pageNo", page.getPageNo());
		queryMap.put("pageSize", page.getPageSize());
		queryMap.put("orderBy", page.getOrderBy());
		queryMap.put("sqlCondition", sqlCondition);
		queryMap.put("type", searchParams.getReportType().equals("3") ? 1 : 3);
		List<Map> list  = reportDao.reportSaleStatistics(queryMap);
		if(list.size()>0 && list.get(0).containsKey("recordCount"))
				page.setCount(Long.parseLong(list.get(0).get("recordCount").toString()));
		page.setList(list);
		model.addAttribute("page", page);
		queryMap.put("type", searchParams.getReportType().equals("3") ? 2 : 4);
		List<Map> summary = reportDao.reportSaleStatistics(queryMap);
		if (summary.size() > 0)
			model.addAttribute("summary", summary.get(0));


		return "modules/oa/reportSaleStatistics";
	}
}