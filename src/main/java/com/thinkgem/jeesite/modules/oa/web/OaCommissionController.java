/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.ReportDao;
import com.thinkgem.jeesite.modules.oa.entity.BonusRecord;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.entity.OaCommission;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import com.thinkgem.jeesite.modules.oa.service.OaCommissionService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 佣金统计Controller
 * @author frank
 * @version 2016-09-07
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommission")
public class OaCommissionController extends BaseController {
	@Autowired
	private ContractService contractService;
	@Autowired
	private CustomerService customerService;
	@Autowired
	private OaCommissionService oaCommissionService;
	@Autowired
	private ReportDao reportDao;
	
	@ModelAttribute
	public OaCommission get(@RequestParam(required=false) String id) {
		OaCommission entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommissionService.get(id);
		}
		if (entity == null){
			entity = new OaCommission();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:oaCommission:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaCommission oaCommission, HttpServletRequest request, HttpServletResponse response, Model model) {

		//加载季度
		String currentYear = DateUtils.getYear();
		Integer currentQuarter = DateUtils.getSeason(new Date());
		List<String> yearQuarters =  Lists.newArrayList();
		//当年和季度
		String defaultYearQuarter = String.format("%s-%d",currentYear, currentQuarter);
		yearQuarters.add(defaultYearQuarter);
		//当年剩下的季度
		for(Integer i = currentQuarter-1;i>0;i--){
			yearQuarters.add(String.format("%s-%d",currentYear,i));
		}

		//向前走3年的所有
		for (Integer i = Integer.parseInt(currentYear) - 1;i>Integer.parseInt(currentYear) -3;i--){
			for(Integer j=4;j>0;j--){
				yearQuarters.add(String.format("%d-%d",i, j));
			}
		}
		model.addAttribute("yearQuarters",yearQuarters);

		//设置季度默认值
		if(StringUtils.isBlank(oaCommission.getYearQuarter()))
		{
			oaCommission.setYearQuarter(defaultYearQuarter);
		}

		if(oaCommission.getStatus() == null)
			oaCommission.setStatus(0);

		//设置过滤的年和季度
		String[] yearQuarterArray = oaCommission.getYearQuarter().split("-");
		oaCommission.setYear(Integer.parseInt(yearQuarterArray[0]));
		oaCommission.setQuarter(Integer.parseInt(yearQuarterArray[1]));

		//重新计算
		if("reCalc".equals(oaCommission.getFlag())){
			oaCommissionService.reCalc(oaCommission);
		} else if("confirm".equals(oaCommission.getFlag())){ //确认
			oaCommissionService.updateStatus(oaCommission);
		}

		Page<OaCommission> page = oaCommissionService.findPage(new Page<OaCommission>(request, response), oaCommission); 
		model.addAttribute("page", page);
		Map queryMap = new LinkedHashMap();
		queryMap.put("salerId", oaCommission.getSaler()==null?null:oaCommission.getSaler().getId());
		queryMap.put("currentyear", oaCommission.getYear());
		queryMap.put("currentquarter", oaCommission.getQuarter());
		queryMap.put("status", oaCommission.getStatus());
		model.addAttribute("summary",  reportDao.comminssionSummary(queryMap).get(0));
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		return "modules/oa/oaCommissionList";
	}

	@RequiresPermissions("oa:oaCommission:editList")
	@RequestMapping(value = {"editList"})
	public String editList(Contract contract, HttpServletRequest request, HttpServletResponse response, Model model) {
		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		//排除框架合同
		contract.setSearchTypeArray(new String[]{"2","3"});
		Page<Contract> page = contractService.findPage(new Page<Contract>(request, response), contract);
		model.addAttribute("page", page);
		return "modules/oa/oaCommissionEditList";
	}

	@RequestMapping(value = "contract/{contractId}")
	@RequiresPermissions("oa:oaCommission:edit")
	public String edit(@PathVariable String contractId, @RequestBody Map<String, Object> map,HttpServletResponse response){
		try{
			oaCommissionService.saveBonusRecord(contractId, map);
			return renderString(response, "成功调整!");
		}catch(Exception e){
			return renderString(response, "调整失败!");
		}
	}

	@RequestMapping(value = "contract/{contractId}/bonusRecord")
	@ResponseBody
	public List<BonusRecord> getBonusRecords(@PathVariable String contractId){
		return oaCommissionService.getBonusRecords(contractId);
	}

	@RequiresPermissions("oa:oaCommission:view")
	@RequestMapping(value = "form")
	public String form(OaCommission oaCommission, Model model) {
		model.addAttribute("oaCommission", oaCommission);
		return "modules/oa/oaCommissionForm";
	}

	@RequiresPermissions("oa:oaCommission:edit")
	@RequestMapping(value = "save")
	public String save(OaCommission oaCommission, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaCommission)){
			return form(oaCommission, model);
		}
		oaCommissionService.save(oaCommission);
		addMessage(redirectAttributes, "保存佣金统计成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommission/?repage";
	}
	
	@RequiresPermissions("oa:oaCommission:edit")
	@RequestMapping(value = "delete")
	public String delete(OaCommission oaCommission, RedirectAttributes redirectAttributes) {
		oaCommissionService.delete(oaCommission);
		addMessage(redirectAttributes, "删除佣金统计成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommission/?repage";
	}

}