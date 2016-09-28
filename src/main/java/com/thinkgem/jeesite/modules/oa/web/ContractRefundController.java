package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.utils.Encodes;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.ContractFinanceDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.ContractFinance;
import com.thinkgem.jeesite.modules.oa.entity.ContractRefund;
import com.thinkgem.jeesite.modules.oa.service.ContractRefundService;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by Administrator on 2016/9/28.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/contractrefund")
public class ContractRefundController extends BaseController {
    @Autowired
    private ContractRefundService contractRefundService;
    @Autowired
    private ContractService contractService;
    @Autowired
    private ContractFinanceDao contractFinanceDao;


    @ModelAttribute
    public ContractRefund get(@RequestParam(required=false) String id) {
        ContractRefund entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = contractRefundService.get(id);
        }
        if (entity == null){
            entity = new ContractRefund();
        }
        return entity;
    }


    @RequestMapping(value = "auditView")
    public String auditView(ContractRefund contractRefund,Model model){
        Contract contract = contractService.get(contractRefund.getContractId());
        model.addAttribute("contract", contract);
        model.addAttribute("contractRefund", contractRefund);
        ContractFinance filter = new ContractFinance(contract,3);
        List<ContractFinance> finances = contractFinanceDao.findList(filter);
        if(finances.size()>0) {
            Double sumFAmount = 0.00;
            Integer skCount = 0;
            for(ContractFinance finance : finances){
                sumFAmount += finance.getAmount();
                skCount++;
            }
            model.addAttribute("sumFAmount", sumFAmount);
            model.addAttribute("skCount", skCount);
        }
        return "modules/oa/contractRefundAuditView";
    }

    @RequestMapping(value = "audit")
    public String audit(ContractRefund contractRefund, @RequestParam(value="sUrl", required=false) String sUrl, HttpServletRequest request, RedirectAttributes redirectAttributes){
        try {
            contractRefundService.audit(contractRefund);
            addMessage(redirectAttributes, "操作成功，请等待下一环节操作");
        }
        catch(Exception e){
            addMessage(redirectAttributes, e.getMessage());
            return "redirect:" + request.getHeader("referer");
        }
        if(StringUtils.isBlank(sUrl))
            return "redirect:" + adminPath + "/act/task/todo/";
        else
            return "redirect:" + Encodes.urlDecode(sUrl);
    }
}
