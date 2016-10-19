/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.Encodes;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.CommissionSettingDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderFinanceDao;
import com.thinkgem.jeesite.modules.oa.dao.RefundMainDao;
import com.thinkgem.jeesite.modules.oa.dao.StockInDao;
import com.thinkgem.jeesite.modules.oa.entity.*;
import com.thinkgem.jeesite.modules.oa.service.*;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * 采购订单Controller
 * @author anthony
 * @version 2016-08-13
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/purchaseOrder")
public class PurchaseOrderController extends BaseController {

	@Autowired
	private PurchaseOrderService purchaseOrderService;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private ProductTypeService productTypeService;
	@Autowired
	private ProductTypeGroupService productTypeGroupService;
	@Autowired
	private ContractService contractService;
	@Autowired
	private PurchaseOrderFinanceDao purchaseOrderFinanceDao;
	@Autowired
	private RefundMainDao refundMainDao;
	@Autowired
	private StockInDao stockInDao;

	@Autowired
	private CommissionSettingDao commissionSettingDao;
	
	@ModelAttribute
	public PurchaseOrder get(@RequestParam(required=false) String id) {
		PurchaseOrder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = purchaseOrderService.get(id);
		}
		if (entity == null){
			entity = new PurchaseOrder();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:purchaseOrder:view")
	@RequestMapping(value = {"list", ""})
	public String list(PurchaseOrder purchaseOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PurchaseOrder> page = purchaseOrderService.findPage(new Page<PurchaseOrder>(request, response), purchaseOrder); 
		model.addAttribute("page", page);
		//获取所有供应商
		List<Supplier> supplierList = supplierService.findList(new Supplier());
		model.addAttribute("supplierList", supplierList);
		return "modules/oa/purchaseOrderList";
	}

	@RequiresPermissions("oa:purchaseOrder:view")
	@RequestMapping(value = "form")
	public String form(PurchaseOrder purchaseOrder, Model model, @RequestParam(value="fromModal", required=false) String fromModal) {
		String view = "purchaseOrderForm";
		//资金日利率
		CommissionSetting commissionSetting =commissionSettingDao.get("ceee7d108d684470ba028f7e9f8a57d7");
		model.addAttribute("dayRate", commissionSetting.getAvalue());
		//获取所有供应商
		List<Supplier> supplierList = supplierService.findList(new Supplier());
		model.addAttribute("supplierList", supplierList);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));

		model.addAttribute("purchaseOrder", purchaseOrder);
		//判断是否使用不同的视图
		if(isNotBlank(fromModal)){
			view = "purchaseOrderForm_ajax";
		}
		return "modules/oa/" + view;
	}

	@RequiresPermissions("oa:purchaseOrder:view")
	@RequestMapping(value = "view")
	public String view(PurchaseOrder purchaseOrder, Model model, HttpServletRequest request) {
		String view = "purchaseOrderView";
		//获取所有供应商
		List<Supplier> supplierList = supplierService.findList(new Supplier());
		model.addAttribute("supplierList", supplierList);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));
		//得到合同全部信息
		purchaseOrder.setContract(contractService.get(purchaseOrder.getContract().getId()));
		model.addAttribute("purchaseOrder", purchaseOrder);

		// 查看审批申请单
		if (isNotBlank(purchaseOrder.getId()) && isNotBlank(purchaseOrder.getProcInsId())) {
			// 环节编号
			String taskDefKey = purchaseOrder.getAct().getTaskDefKey();

			//财务总监确认可付款
			if("cfo_confirm_payment_1".equals(taskDefKey) || "cfo_confirm_payment_2".equals(taskDefKey) || "cfo_confirm_payment_3".equals(taskDefKey)){

				view = "purchaseOrderAudit_cfo";
			}

			//财务确认付款
			if("payment_first".equals(taskDefKey) || "payment_all".equals(taskDefKey) || "payment".equals(taskDefKey)){
				view = "purchaseOrderAudit_fk";
				//获取供应商完整信息
				purchaseOrder.setSupplier(supplierService.get(purchaseOrder.getSupplier().getId()));
			}

			//得到第一笔付款数据
			if("cfo_confirm_payment_1".equals(taskDefKey) || "cfo_confirm_payment_2".equals(taskDefKey) || "cfo_confirm_payment_3".equals(taskDefKey) ||
					"payment_first".equals(taskDefKey) || "payment_all".equals(taskDefKey) || "payment".equals(taskDefKey)){
				PurchaseOrderFinance filter = new PurchaseOrderFinance(purchaseOrder,1);
				List<PurchaseOrderFinance> finances = purchaseOrderFinanceDao.findList(filter);
				if(finances.size()>0)
					model.addAttribute("finance", finances.get(0));
			}
		}
		//源url地址
		model.addAttribute("sUrl", Encodes.urlEncode(request.getHeader("referer")));
		return "modules/oa/" + view;
	}

	@RequestMapping(value = "save")
	public String save(PurchaseOrder purchaseOrder, Model model, RedirectAttributes redirectAttributes) throws Exception {
		if (!beanValidator(model, purchaseOrder)){
			return form(purchaseOrder, model, null);
		}
		purchaseOrderService.save(purchaseOrder);
		addMessage(redirectAttributes, "保存采购订单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/purchaseOrder/?repage";
	}

	@SuppressWarnings("Duplicates")
	@RequestMapping(value = "ajaxSave")
	@ResponseBody
	public Map<String, Object> ajaxSave(PurchaseOrder purchaseOrder, Model model, RedirectAttributes redirectAttributes) {
		Map<String, Object> map = Maps.newHashMap();
		try {
			save(purchaseOrder, model, redirectAttributes);
			map.put("status",1);//1成功,
			map.put("contractId", purchaseOrder.getContract().getId());
			/*purchaseOrder.setContract(contractService.get(purchaseOrder.getContract().getId()));
			map.put("data", purchaseOrder);*/
		}
		catch(Exception e){
			map.put("status",0);//1失败
			map.put("msg", e.getMessage());
		}
		return map;
	}
	
	@RequiresPermissions("oa:purchaseOrder:edit")
	@RequestMapping(value = "delete")
	public String delete(PurchaseOrder purchaseOrder, RedirectAttributes redirectAttributes) {
		purchaseOrderService.delete(purchaseOrder);
		addMessage(redirectAttributes, "删除采购订单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/purchaseOrder/?repage";
	}

	@RequiresPermissions("oa:purchaseOrder:audit")
	@RequestMapping(value = "audit")
	public String audit(HttpServletRequest request, PurchaseOrder purchaseOrder, Model model, RedirectAttributes redirectAttributes,@RequestParam(value="sUrl", required=false) String sUrl) {
		if(isNotBlank(purchaseOrder.getAct().getFlag()) || isNotBlank(purchaseOrder.getAct().getTaskDefKey()))
		{
			try {
				purchaseOrderService.audit(purchaseOrder);//审核
				addMessage(redirectAttributes, "操作成功，请等待下一环节操作");
			}catch(Exception e){
				addMessage(redirectAttributes, e.getMessage());
				return "redirect:" + request.getHeader("referer");
			}
			return autoRedirect(sUrl);
		}
		return "redirect:"+Global.getAdminPath()+"/oa/purchaseOrder";
	}

	@RequestMapping(value = "poList/contract/{contractId}")
	@ResponseBody
	public List<PurchaseOrder> getPoByContractId(@PathVariable String contractId)
	{
		List<PurchaseOrder> purchaseOrderList = purchaseOrderService.getPoListByContractId(contractId);
		for(PurchaseOrder po : purchaseOrderList){
			Double refundMainAmount =0.00;
			Double stockInAmount = 0.00;
			//得到退款金额
			RefundMain refundMainFilter = new RefundMain();
			refundMainFilter.setPoId(po.getId());
			List<RefundMain> refundMainList = refundMainDao.findList(refundMainFilter);
			for (RefundMain main : refundMainList){
				refundMainAmount += main.getAmount();
			}
			po.setRefundMainAmount(refundMainAmount);

			//得到转库存金额
			StockIn stockInFilter = new StockIn();
			stockInFilter.setPoId(po.getId());
			List<StockIn> stockInList = stockInDao.findList(stockInFilter);
			for (StockIn stockIn : stockInList){
				stockInAmount += stockIn.getAmount();
			}
			po.setStockInAmount(stockInAmount);
		}
		return purchaseOrderList;
	}
}