/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.DBHelper;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.OaPoEvaluate;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.entity.Supplier;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.OaPoEvaluateService;
import com.thinkgem.jeesite.modules.oa.service.PurchaseOrderService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 供应商评价Controller
 * 
 * @author frank
 * @version 2016-08-23
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaPoEvaluate")
public class OaPoEvaluateController extends BaseController {

	@Autowired
	private OaPoEvaluateService oaPoEvaluateService;
	@Autowired
	private PurchaseOrderService purchaseOrderService;
	@Autowired
	private ContractService contractService;

	@ModelAttribute
	public OaPoEvaluate get(@RequestParam(required = false) String id) {
		OaPoEvaluate entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = oaPoEvaluateService.get(id);
		}
		if (entity == null) {
			entity = new OaPoEvaluate();
		}
		return entity;
	}

	@RequiresPermissions("oa:oaPoEvaluate:view")
	@RequestMapping(value = { "list", "" })
	public String list(OaPoEvaluate oaPoEvaluate, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<OaPoEvaluate> page = oaPoEvaluateService.findPage(
				new Page<OaPoEvaluate>(request, response), oaPoEvaluate);
		model.addAttribute("page", page);
		return "modules/oa/oaPoEvaluateList";
	}

	@RequestMapping(value = "form")
	public String form(OaPoEvaluate oaPoEvaluate, Model model,
			@RequestParam(value = "poid", required = true) String poid) {
		oaPoEvaluate.setPoId(poid);
		model.addAttribute("oaPoEvaluate", oaPoEvaluate);
		return "modules/oa/oaPoEvaluateForm";
	}

	@RequestMapping(value = "save")
	public String save(OaPoEvaluate oaPoEvaluate, Model model,
			RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaPoEvaluate)) {
			return form(oaPoEvaluate, model, oaPoEvaluate.getPoId());
		}
		if (oaPoEvaluateService.get(oaPoEvaluate.getPoId()) != null) {
			addMessage(redirectAttributes, "订单只能评一次");
		}
		oaPoEvaluateService.save(oaPoEvaluate);
		addMessage(redirectAttributes, "保存供应商评价成功");
		return null;
	}

	@RequestMapping(value = "ajaxSave")
	@ResponseBody
	public Map<String, Object> ajaxSave(OaPoEvaluate oaPoEvaluate, Model model,
			RedirectAttributes redirectAttributes) {
		int status = 0;
		String msg = "评价不能为空";
		Map<String, Object> map = Maps.newHashMap();
		try {
			if (beanValidator(model, oaPoEvaluate)) {
				PurchaseOrder purchaseOrder = purchaseOrderService
						.get(oaPoEvaluate.getPoId());
				if (purchaseOrder == null) {
					msg = "订单不存在";
				} else {
					if ("70".equals(purchaseOrder.getStatus())
							|| "100".equals(purchaseOrder.getStatus())) {
						Contract contract = contractService.get(purchaseOrder
								.getContract().getId());
						if (contract == null) {
							msg = "合同不存在";
						} else {
							if (contract.getBusinessPerson() == null) {
								msg = "商务人员不存在";
							} else {
								if (UserUtils
										.getUser()
										.getId()
										.equals(contract.getBusinessPerson()
												.getId())) {
									OaPoEvaluate ev = oaPoEvaluateService.get(oaPoEvaluate.getPoId());
									if (ev == null) {
										msg = "保存数据失败";
										oaPoEvaluateService.save(oaPoEvaluate);
										purchaseOrder.setEvaluateFlag("1");
										purchaseOrderService
												.common_save(purchaseOrder);
										
						                DBHelper.executeSP(purchaseOrder.getSupplier().getId());
										status = 1;
										msg = "保存供应商评价成功";
										map.put("data", oaPoEvaluate);
									} else {
										msg = "订单只能评价一次";
									}
								} else {
									msg = "只有合同指定的商务人员才能评价";
								}
							}
						}
					} else {
						msg = "订单收货验收之后，才能进行评价";
					}

				}

			}
		} catch (Exception e) {
			map.put("status", 0);// 1失败
		}
		map.put("msg", msg);
		map.put("status", status);// 1成功,
		return map;
	}

	@RequiresPermissions("oa:oaPoEvaluate:edit")
	@RequestMapping(value = "delete")
	public String delete(OaPoEvaluate oaPoEvaluate,
			RedirectAttributes redirectAttributes) {
		oaPoEvaluateService.delete(oaPoEvaluate);
		addMessage(redirectAttributes, "删除供应商评价成功");
		return "redirect:" + Global.getAdminPath() + "/oa/oaPoEvaluate/?repage";
	}

}