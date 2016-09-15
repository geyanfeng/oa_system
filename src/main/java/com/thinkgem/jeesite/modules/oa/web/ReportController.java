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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.CookieUtils;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.dao.AlertSettingDao;
import com.thinkgem.jeesite.modules.oa.dao.ReportDao;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.entity.SearchParams;
import com.thinkgem.jeesite.modules.oa.entity.Supplier;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import com.thinkgem.jeesite.modules.oa.service.SupplierService;

@Controller
@RequestMapping(value = "${adminPath}/report")
public class ReportController extends BaseController {
	@Autowired
	private ReportDao reportDao;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private CustomerService customerService;

	@RequiresPermissions("oa:report:view")
	@RequestMapping(value = { "list", "" })
	public String list(SearchParams searchParams, HttpServletRequest request,
			HttpServletResponse response, Model model) {

		if (StringUtils.isNumeric(request.getParameter("reportType"))) {
			int reportType = Integer.parseInt(request
					.getParameter("reportType"));

			Page page = new Page(request, response);
			String sqlCondition = "";

			if (searchParams.getStartTime() != null) {
				if (reportType == 1 || reportType == 2) {
					sqlCondition += " and pay_date>='"
							+ new java.text.SimpleDateFormat("yyyy-MM-dd")
									.format(searchParams.getStartTime()) + "'";
				} else if (reportType == 3) {
					sqlCondition += " and year>="
							+ new java.text.SimpleDateFormat("yyyy")
									.format(searchParams.getStartTime());
				}
			}
			if (searchParams.getEndTime() != null) {
				if (reportType == 1 || reportType == 2) {
					sqlCondition += " and pay_date<='"
							+ new java.text.SimpleDateFormat("yyyy-MM-dd")
									.format(searchParams.getEndTime()) + "'";
				} else if (reportType == 3) {
					sqlCondition += " and year<="
							+ new java.text.SimpleDateFormat("yyyy")
									.format(searchParams.getEndTime());
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
				if (!StringUtils.isBlank(searchParams.getSupplierId())) {
					sqlCondition += "  and supplier_id='"
							+ searchParams.getSupplierId() + "'";
				}
				model.addAttribute("title", "付款统计报表");
				headers.put("name", "供应商名称");
				headers.put("evaluateValue", "评分");
				headers.put("finishedCount", "订单数(已完)");
				headers.put("unfinishedCount", "订单数(未完)");
				headers.put("avgAmount", "平均订单金额");
				headers.put("totalAmount", "完成总金额");

				// 获取所有供应商
				List<Supplier> supplierList = supplierService
						.findList(new Supplier());
				model.addAttribute("supplierList", supplierList);
				list = reportDao.reportSupplierStatistics(queryMap);
				break;
			case 2:
				if (!StringUtils.isBlank(searchParams.getCustomerId())) {
					sqlCondition += "  and customer_id='"
							+ searchParams.getCustomerId() + "'";
				}
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

				// 获取所有客户
				List<Customer> customerList = customerService
						.findList(new Customer());
				model.addAttribute("customerList", customerList);
				list = reportDao.reportCustomerStatistics(queryMap);
				break;
			case 3:
				if (!StringUtils.isBlank(searchParams.getCustomerId())) {
					sqlCondition += "  and customer_id='"
							+ searchParams.getCustomerId() + "'";
				}
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

				// 获取所有客户
				List<Customer> customerList1 = customerService
						.findList(new Customer());
				model.addAttribute("customerList", customerList1);
				list = reportDao.reportContractStatistics(queryMap);
				List<Map> achievementList = reportDao
						.reportAchievementStatistics(queryMap);
				model.addAttribute("achievementList", achievementList);
				break;
			}

			if (list != null && list.size() > 0) {
				Set set = list.get(0).entrySet();
				Iterator i = set.iterator();
				while (i.hasNext()) {
					Map.Entry me = (Map.Entry) i.next();
					if (me.getKey().toString().equals("recordCount")) {
						page.setCount(Long.parseLong(me.getValue().toString()));
						break;
					}
				}
				// page.setCount(list.get(0).values().g);
			} else {
				page.setCount(0);
			}

			page.setList(list);
			model.addAttribute("page", page);
			model.addAttribute("headers", headers);
		}

		return "modules/oa/reportList";
	}

}