package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderFinanceDao;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrderFinance;
import com.thinkgem.jeesite.modules.oa.entity.RefundMain;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.PurchaseOrderService;
import com.thinkgem.jeesite.modules.oa.service.RefundService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Created by Ge on 2016/9/18.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/refund")
public class RefundController extends BaseController {
    @Autowired
    private RefundService refundService;
    @Autowired
    private ContractService contractService;
    @Autowired
    private PurchaseOrderService purchaseOrderService;
    @Autowired
    private PurchaseOrderFinanceDao purchaseOrderFinanceDao;

    @ModelAttribute
    public RefundMain get(@RequestParam(required=false) String id) {
        RefundMain entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = refundService.get(id);
        }
        if (entity == null){
            entity = new RefundMain();
        }
        return entity;
    }

    @RequestMapping(value = "{poId}/save")
    @ResponseBody
    public String save(@PathVariable String poId, @RequestBody RefundMain main, HttpServletResponse response) throws Exception {
        try{
            refundService.saveRefund(poId, main);
            return renderString(response, "退款成功!");
        }
        catch(Exception e){
            return renderString(response, "退款失败!");
        }
    }

    @RequestMapping(value = "auditView")
    public String auditView(RefundMain refundMain, Model model){
        model.addAttribute("contract", contractService.get(refundMain.getContractId()));
        PurchaseOrder purchaseOrder = purchaseOrderService.get(refundMain.getPoId());
        model.addAttribute("purchaseOrder", purchaseOrder);
        model.addAttribute("refundMain", refundMain);
        PurchaseOrderFinance filter = new PurchaseOrderFinance(purchaseOrder,2);
        List<PurchaseOrderFinance> finances = purchaseOrderFinanceDao.findList(filter);
        if(finances.size()>0) {
            Double sumFAmount = 0.00;
            for(PurchaseOrderFinance finance : finances){
                sumFAmount += finance.getAmount();
            }
            model.addAttribute("sumFAmount", sumFAmount);
        }
        return "modules/oa/refundAuditView";
    }

    @RequestMapping(value = "audit")
    public String audit(RefundMain refundMain, @RequestParam(value="sUrl", required=false) String sUrl, HttpServletRequest request, RedirectAttributes redirectAttributes){
        try {
            refundService.audit(refundMain);
            addMessage(redirectAttributes, "操作成功，请等待下一环节操作");
        }
        catch(Exception e){
            addMessage(redirectAttributes, e.getMessage());
            return "redirect:" + request.getHeader("referer");
        }
        return autoRedirect(sUrl);
    }
}
