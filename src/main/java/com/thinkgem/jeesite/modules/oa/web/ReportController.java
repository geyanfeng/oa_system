/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.dao.AlertSettingDao;
import com.thinkgem.jeesite.modules.oa.dao.ReportDao;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.entity.SearchParams;
import com.thinkgem.jeesite.modules.oa.entity.Supplier;
import com.thinkgem.jeesite.modules.oa.service.SupplierService;

@Controller
@RequestMapping(value = "${adminPath}/report")
public class ReportController extends BaseController {
	@Autowired
	private ReportDao reportDao;
	@Autowired
	private SupplierService supplierService;

	@RequestMapping(value = { "list", "" })
	public String list(SearchParams searchParams, HttpServletRequest request,
			HttpServletResponse response, Model model) {

		// 获取所有供应商
		List<Supplier> supplierList = supplierService.findList(new Supplier());
		model.addAttribute("supplierList", supplierList);
		Page page = new Page(request, response);
		page.setPageSize(1);
		String sqlCondition = "";
		if (!StringUtils.isBlank(searchParams.getSupplierId())) {
			sqlCondition += "  and supplier_id='"
					+ searchParams.getSupplierId() + "'";
		}
		Map queryMap = new HashMap();
		queryMap.put("pageNo", page.getPageNo());
		queryMap.put("pageSize", 1);
		queryMap.put("sqlCondition", sqlCondition);
		queryMap.put("orderBy", "");
		List<Map> list = reportDao.reportSupplierStatistics(queryMap);
		if (list.size() > 0) {

			page.setCount(2);
		} else {
			page.setCount(0);
		}

		page.setList(list);
		model.addAttribute("page", page);

		// return JSONArray.fromObject(listIis2).toString();
		model.addAttribute("title", "付款统计报表");
		Map headers = new HashMap();
		headers.put("name", "供应商名称");
		headers.put("evaluateValue", "评分");
		headers.put("finishedCount", "订单数(已完)");
		headers.put("unfinishedCount", "订单数(未完)");
		headers.put("avgAmount", "平均订单金额");
		headers.put("totalAmount", "完成总金额");
		model.addAttribute("headers", headers);

		return "modules/oa/reportList";
	}

}