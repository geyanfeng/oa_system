package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.RefundDetail;
import com.thinkgem.jeesite.modules.oa.entity.StockIn;
import com.thinkgem.jeesite.modules.oa.service.RefundService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @RequestMapping(value = "{poId}/save")
    @ResponseBody
    public String save(@PathVariable String poId, @RequestBody List<RefundDetail> stockInList, HttpServletResponse response) throws Exception {
        try{
            refundService.saveList(poId, stockInList);
            return renderString(response, "退款成功!");
        }
        catch(Exception e){
            return renderString(response, "退款失败!");
        }
    }
}
