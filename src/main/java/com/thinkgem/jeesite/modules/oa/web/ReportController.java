/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.StringUtils;
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
				}
			}
			if (!StringUtils.isBlank(searchParams.getEndTime())) {
				if (reportType == 1 || reportType == 2) {
					sqlCondition += " and pay_date<='"
							+ searchParams.getEndTime() + "'";
				} else if (reportType == 3) {
					sqlCondition += " and year<=" + searchParams.getEndTime();
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

			if (reportType == 2 || reportType == 3 || reportType == 5) {
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
					if (!StringUtils.isBlank(searchParams.getCompanyId())) {
						sqlCondition += "  and company_id='"
								+ searchParams.getCompanyId() + "'";
					}
					if (!StringUtils.isBlank(searchParams.getSalerId())) {
						sqlCondition += "  and saler_id='"
								+ searchParams.getSalerId() + "'";
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
				if (reportType == 6) {
					orderBy = " plan_pay_date desc";
				} else {
					orderBy = "";
				}
			}

			Map queryMap = new LinkedHashMap();
			queryMap.put("pageNo", page.getPageNo());
			queryMap.put("pageSize", page.getPageSize());
			queryMap.put("sqlCondition", sqlCondition);
			queryMap.put("orderBy", "");

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
				headers.put("plan_pay_date", "账期截止日");
				headers.put("finance_status_name", "收款状态");
				headers.put("finance_amount", "收款金额");
				headers.put("pay_date", "收款日期");
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

}