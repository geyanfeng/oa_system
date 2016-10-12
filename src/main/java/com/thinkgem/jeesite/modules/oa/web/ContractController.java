/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.utils.Encodes;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ExportExcel;
import com.thinkgem.jeesite.common.utils.excel.ImportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.dao.ContractFinanceDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractProductDao;
import com.thinkgem.jeesite.modules.oa.dao.PeopleSettingDao;
import com.thinkgem.jeesite.modules.oa.dao.StockInDao;
import com.thinkgem.jeesite.modules.oa.entity.*;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeService;
import com.thinkgem.jeesite.modules.oa.service.PurchaseOrderService;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.activiti.engine.TaskService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * 各种合同Controller
 * @author anthony
 * @version 2016-07-28
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/contract")
public class ContractController extends BaseController {

	@Autowired
	private ContractService contractService;
	@Autowired
	private CustomerService customerService;
	@Autowired
	private ProductTypeService productTypeService;
	@Autowired
	private TaskService taskService;
	@Autowired
	private ActTaskService actTaskService;
	@Autowired
	private PeopleSettingDao peopleSettingDao;
	@Autowired
	private ContractFinanceDao contractFinanceDao;
	@Autowired
	private ContractProductDao contractProductDao;
	@Autowired
	private PurchaseOrderService purchaseOrderService;
	@Autowired
	private StockInDao stockInDao;
	
	@ModelAttribute
	public Contract get(@RequestParam(required=false) String id) {
		Contract entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = contractService.get(id);
		}
		if (entity == null){
			entity = new Contract();
		}
		return entity;
	}

	@RequestMapping(value = {"get"})
	@ResponseBody
	public Map<String, Object> getData(@RequestParam(required=false) String id) {
		Contract entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = contractService.get(id);
		}
		if (entity == null){
			entity = new Contract();
		}
		Map<String, Object> map = Maps.newHashMap();
		map.put("data",entity);
		return map;
	}
	
	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = {"list", ""})
	public String list(Contract contract, HttpServletRequest request, HttpServletResponse response, Model model) {
		String view="contractList";
		BaseService.dataScopeFilter(contract, "dsf", "","id=a.create_by");//过滤数据授权
		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		Page<Contract> page = contractService.findPage(new Page<Contract>(request, response), contract); 
		model.addAttribute("page", page);
		String isSelect = request.getParameter("isSelect");
		if (StringUtils.isNotBlank(isSelect)) {
			model.addAttribute("isSelect", isSelect);
		}
		if(contract.getContractType().equals("1"))
			view = "contractList_kj";
		return "modules/oa/"+view;
	}

	//@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = {"contractSelectList"})
	public String selectList(Contract contract,@RequestParam(value="targetType", required=false) String targetType,  HttpServletRequest request, HttpServletResponse response, Model model) {
		BaseService.dataScopeFilter(contract, "dsf", "","id=a.create_by");//过滤数据授权
		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		//要么搜索contractType, 要么搜索typeArray
		if("2".equals(targetType)){
			contract.setContractType("1");
		}
		else if("3".equals(targetType))
		{
			contract.setSearchTypeArray(new String[]{"1","2"});
		}
		else if("4".equals(targetType))//新建订单时
		{
			contract.setSearchTypeArray(new String[]{"2","3"});
		}
		Page<Contract> page = contractService.findPage(new Page<Contract>(request, response), contract);
		model.addAttribute("page", page);
		model.addAttribute("targetType",targetType);
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		return "modules/oa/contractSelectList";
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "form")
	public String form(Contract contract, @RequestParam(value="originalId", required=false) String originalId, Model model) {
		String view = "contractForm";
		//如果是来自父级,复制部分数据
		if(originalId !=null){
			Contract originalContract = contractService.get(originalId);
			contract.setParentId(originalContract.getId());
			contract.setParentName(originalContract.getName());
			contract.setParentNo(originalContract.getName());
			contract.setCustomer(originalContract.getCustomer());
			contract.setInvoiceType(originalContract.getInvoiceType());
			contract.setInvoiceCustomerName(originalContract.getInvoiceCustomerName());
			contract.setInvoiceNo(originalContract.getInvoiceNo());
			contract.setInvoiceBank(originalContract.getInvoiceBank());
			contract.setInvoiceBankNo(originalContract.getInvoiceBankNo());
			contract.setInvoiceAddress(originalContract.getInvoiceAddress());
			contract.setInvoicePhone(originalContract.getInvoicePhone());
			contract.setCompanyName(originalContract.getCompanyName());
			contract.setPaymentCycle(originalContract.getPaymentCycle());
			contract.setPaymentDetail(originalContract.getPaymentDetail());
			contract.setContractType("2"); //设置默认合同类型为客户合同*/
		}
		/*if (contract.getContractType() == null)
			contract.setContractType("2"); //设置默认合同类型为客户合同*/
		if (contract.getCompanyName() == null)
			contract.setCompanyName("1"); //设置默认我司抬头为上海精鲲
		if (contract.getInvoiceType() == null)
			contract.setInvoiceType("2"); //设置默认发票类型为增值税普票
		if (contract.getPaymentCycle() == null)
			contract.setPaymentCycle("2");//设置默认付款周期为分期付款
		if (contract.getShipMode() == null)
			contract.setShipMode("3");//设置默认发货方式为同城第三方物流

		//如果为新建设置默认商务和技术
		if(StringUtils.isBlank(contract.getId())){
			PeopleSetting peopleSetting = peopleSettingDao.getBySalerId(UserUtils.getUser().getId());
			if(peopleSetting!=null){
				contract.setBusinessPerson(peopleSetting.getBusinessPerson());
				contract.setArtisan(peopleSetting.getArtisan());
			}
		}

		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取附件
		setContractAttachment(contract);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));

		//设置合同号
		contractService.setContractNo(contract);

		model.addAttribute("contract", contract);

		//获取商务人员
		model.addAttribute("businessPeopleList", UserUtils.getUsersByRoleEnName("businesser"));
		//获取技术人员
		model.addAttribute("artisanList", UserUtils.getUsersByRoleEnName("tech"));

		//如果是框架性合同显示不同的界面
		if(isNotBlank(contract.getContractType()) && contract.getContractType().equals("1"))
			view ="contractForm_kj";

		return "modules/oa/" + view;
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "view")
	public String view(Contract contract, HttpServletRequest request, HttpServletResponse response, Model model) {
		String view = "contractView";
		model.addAttribute("contract", contract);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));
		//获取附件
		setContractAttachment(contract);
		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取商务人员
		model.addAttribute("businessPeopleList", UserUtils.getUsersByRoleEnName("businesser"));
		//获取技术人员
		model.addAttribute("artisanList", UserUtils.getUsersByRoleEnName("tech"));

		// 查看审批申请单
		if (isNotBlank(contract.getId())) {//.getAct().getProcInsId())){
			// 环节编号
			String taskDefKey = contract.getAct().getTaskDefKey();

			/*// 查看工单
			if(contract.getAct().isFinishTask()){
				view = "testAuditView";
			}
			// 修改环节
			else if ("modify".equals(taskDefKey)){
				view = "testAuditForm";
			}*/
			if("split_po".equals(taskDefKey)){//拆分po
				if(actTaskService.getVarValue(contract.getProcInsId(),"recall_id") != null) {
					model.addAttribute("is_recall", true);
					//得到已付款金额
					ContractFinance filter = new ContractFinance(contract,3);
					List<ContractFinance> finances = contractFinanceDao.findList(filter);
					Double fkTotalAmount = 0.00;
					if(finances.size()>0) {
						for(ContractFinance finance : finances){
							fkTotalAmount+=finance.getAmount();
						}
					}
					model.addAttribute("fkTotalAmount", fkTotalAmount);
				}
			}
			else if("contract_edit".equals(taskDefKey)){//合同修改
				view = "contractForm";

				if(actTaskService.getVarValue(contract.getProcInsId(),"recall_id") != null) {
					model.addAttribute("is_recall", true);
					//得到已付款金额
					ContractFinance filter = new ContractFinance(contract,3);
					List<ContractFinance> finances = contractFinanceDao.findList(filter);
					model.addAttribute("fkFinances", finances);
				}
			}
			else if("saler_audit".equals(taskDefKey) || "cso_audit".equals(taskDefKey)){//销售审核和总监审核
				//检查是否为撤回并得到老的采购数据
				if(UserUtils.IsRoleByRoleEnName("cso") && actTaskService.getVarValue(contract.getProcInsId(),"recall_id") != null) {
					model.addAttribute("is_recall", true);
					ContractProduct filter = new ContractProduct(contract);
					filter.setOldFlag(1);
					model.addAttribute("old_product_list", contractProductDao.findList(filter));
					//库存金额
					StockIn filter1 = new StockIn();
					filter1.setContractId(contract.getId());
					List<StockIn> stockInList = stockInDao.findList(filter1);
					Double stockInSumAmount = 0.00;
					for (StockIn in : stockInList){
						stockInSumAmount+=in.getAmount();
					}
					model.addAttribute("stockInSumAmount", stockInSumAmount);
				}
				view = "contractView_includeCost";
			}
			else if("can_invoice".equals(taskDefKey) || "can_invoice2".equals(taskDefKey) || "cw_kp".equals(taskDefKey) || "cw_kp2".equals(taskDefKey)){//商务确认开票和财务开票
				ContractFinance filter = new ContractFinance(contract,1);
				List<ContractFinance> finances = contractFinanceDao.findList(filter);
				if(finances.size()>0)
					model.addAttribute("finance", finances.get(0));
				view = "contractView_kp";
			}
			else if("verify_sk".equals(taskDefKey) || "verify_sk2".equals(taskDefKey)){//财务收款
				ContractFinance filter = new ContractFinance(contract,2);
				List<ContractFinance> finances = contractFinanceDao.findList(filter);
				if(finances.size()>0) {
					ContractFinance finance = finances.get(0);
					model.addAttribute("finance", finances.get(0));
					//付款进程
					if(contract.getContractFinanceList().size() == 1){
						model.addAttribute("jc", "");
					} else if(finance.getSort() == 1){
						model.addAttribute("jc", "首款");
					} else if(finance.getSort() == contract.getContractFinanceList().size()){
						model.addAttribute("jc", "尾款");
					} else{
						model.addAttribute("jc", "第 "+ finance.getSort()+" 笔");
					}
				}
				view = "contractView_sk";
			} else if("cfo_audit".equals(taskDefKey)){//财务总监审批
				List<PurchaseOrder> purchaseOrderList = purchaseOrderService.getPoListByContractId(contract.getId());
				model.addAttribute("purchaseOrderList",purchaseOrderList);
				view = "contractView_cfo";
			} else if("recall_cso_audit".equals(taskDefKey) || "recall_cfo_audit".equals(taskDefKey)){
				if(contract.getAct() !=null && isNotBlank(contract.getAct().getTaskId())) {
					Map<String, Object> currentTaskVars = taskService.getVariables(contract.getAct().getTaskId());
					if(currentTaskVars.containsKey("recall_type"))
						model.addAttribute("recall_type", currentTaskVars.get("recall_type"));
					if(currentTaskVars.containsKey("recall_remark"))
						model.addAttribute("recall_remark", currentTaskVars.get("recall_remark"));
				}
				view = "contractRecall_audit";
			}

			model.addAttribute("taskDefKey",taskDefKey);
		}
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));
		//源url地址
		if(isNotBlank(request.getHeader("referer")))
			model.addAttribute("sUrl", Encodes.urlEncode(request.getHeader("referer")));
		return "modules/oa/"+view;
	}

	private void setContractAttachment(Contract contract){
		//获取附件
		if(contract.getContractAttachmentList()==null || contract.getContractAttachmentList().size()==0){
			ArrayList<ContractAttachment> attachmentList = new ArrayList<ContractAttachment>();
			List<Dict> attachmentTypes =  DictUtils.getDictList("oa_contract_attachment_type");
			for (Dict attachType : attachmentTypes){
				ContractAttachment attachment = new ContractAttachment();
				attachment.setType(attachType.getValue());
				attachmentList.add(attachment);
			}
			contract.setContractAttachmentList(attachmentList);
		}
	}

	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "save")
	public String save(HttpServletRequest request, Contract contract, Model model, RedirectAttributes redirectAttributes) {

		if (!beanValidator(model, contract)){
			return form(contract, null, model);
		}
		//设置合同号
		contractService.setContractNo(contract);

		contractService.save(contract);
		//执行审批
		if((!contract.getContractType().equals("1") && isNotBlank(contract.getAct().getFlag())) || isNotBlank(contract.getAct().getTaskDefKey())){
			//return "redirect:" + adminPath + "/act/task/todo/";
			audit(request, contract, redirectAttributes, null);
		} else {
			addMessage(redirectAttributes, "保存合同成功");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/contract/?contractType=" + contract.getContractType() + "&repage";
	}

	@RequiresPermissions("oa:contract:audit")
	@RequestMapping(value = "audit")
	public String audit(HttpServletRequest request, Contract contract, RedirectAttributes redirectAttributes,@RequestParam(value="sUrl", required=false) String sUrl) {
		if(!contract.getContractType().equals("1") && isNotBlank(contract.getAct().getFlag()) || isNotBlank(contract.getAct().getTaskDefKey()))
		{
			try {
				contractService.audit(contract);
				addMessage(redirectAttributes, "操作成功，请等待下一环节操作");
			}
			catch(Exception e){
				addMessage(redirectAttributes, e.getMessage());
				return "redirect:" + request.getHeader("referer");
			}
			return autoRedirect(sUrl);
		}
		return "redirect:"+Global.getAdminPath()+"/oa/contract/?contractType="+contract.getContractType()+"&repage";
	}
	
	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "delete")
	public String delete(Contract contract, RedirectAttributes redirectAttributes) {
		contractService.delete(contract);
		addMessage(redirectAttributes, "删除合同成功");
		return "redirect:"+Global.getAdminPath()+"/oa/contract?contractType="+ contract.getContractType() +"&repage";
	}

	/**
	 * 验证名称是否有效
	 * @param oldName
	 * @param name
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "checkName")
	public String checkName(String oldName, String name) {
		if (name !=null && name.equals(oldName)) {
			return "true";
		} else if (name !=null && contractService.getByName(name) == null) {
			return "true";
		}
		return "false";
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "export", method=RequestMethod.POST)
	public String exportFile(Contract contract, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String contractType = isNotBlank(contract.getContractType())? DictUtils.getDictLabel(contract.getContractType(),"oa_contract_type","合同列表"):"合同列表";
			String fileName = contractType+ DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
			Page<Contract> page = contractService.findPage(new Page<Contract>(request, response,-1), contract);
			new ExportExcel(contractType, Contract.class).setDataList(page.getList()).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出合同列表！失败信息："+e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()+"/oa/contract?contractType="+ contract.getContractType() +"&repage";
	}

	@RequestMapping(value = "{contractId}/saveProduct")
	@ResponseBody
	public void saveProduct(@PathVariable String contractId,@RequestBody List<ContractProduct> contractProductList) throws Exception {
		Contract contract = get(contractId);
		if(actTaskService.getVarValue(contract.getProcInsId(),"recall_id") == null) {
			for (ContractProduct contractProduct : contract.getContractProductList()) {
				if (contractProduct.getHasSendNum() > 0) {
					throw new Exception("已经下单不能修改");
				}
				for (ContractProduct childProduct : contractProduct.getChilds()) {
					if (childProduct.getHasSendNum() > 0) {
						throw new Exception("已经下单不能修改");
					}
				}
			}
		}
		contract.setContractProductList(contractProductList);
		contractService.saveProducts(contract);
	}

	/*
	@RequestMapping(value = "{contractId}/jump")
	public void jump(@PathVariable String contractId){
		contractService.jump(contractId);
	}*/

	/*
	撤销合同
	 */
	@RequestMapping(value = "{contractId}/cancel")
	@RequiresPermissions("oa:contract:cancel")
	public String cancelContract(@PathVariable String contractId, @RequestBody Map<String, Object> content,HttpServletResponse response){
		try{
			contractService.cancelContract(contractId, content);
			return renderString(response, "成功撤销合同!");
		}catch(Exception e){
			return renderString(response, "撤销合同失败!");
		}
	}

	/*
撤回合同
 */
	@RequestMapping(value = "{contractId}/recallApprove")
	@RequiresPermissions("oa:contract:recall")
	public String recallApprove(@PathVariable String contractId, @RequestBody ContractRecallApprove recallApprove,HttpServletResponse response){
		try{
			contractService.recallApprove(contractId, recallApprove);
			return renderString(response, "撤回申请提交成功!");
		}catch(Exception e){
			return renderString(response, "撤回申请提交失败!");
		}
	}

	@RequestMapping(value = "import/productTemplate")
	public void importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "销售清单数据导入模板.xlsx";
			List<ContractProduct> list = Lists.newArrayList();
			new ExportExcel("销售清单", ContractProduct.class, 2).setDataList(list).write(response, fileName).dispose();
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
	}

	/**
	 * 导入销售清单数据
	 * @param file
	 * @param response
     * @return
     */
	@RequestMapping(value = "importProduct")
	@ResponseBody
	public List<ContractProduct> importProduct(MultipartFile file, HttpServletResponse response){
		try {
			ImportExcel ei = new ImportExcel(file, 1, 0);
			return  ei.getDataList(ContractProduct.class);
		}
		catch (Exception e) {
			renderString(response, "导入出错!");
		}
		return null;
	}
}