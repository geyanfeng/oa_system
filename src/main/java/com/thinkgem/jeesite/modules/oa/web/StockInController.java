package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.StockIn;
import com.thinkgem.jeesite.modules.oa.service.StockInService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Created by Administrator on 2016/9/18.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/stockin")
public class StockInController extends BaseController {
    @Autowired
    private StockInService stockInService;

    @RequestMapping(value = "{poId}/save")
    @ResponseBody
    public void save(@PathVariable String poId, @RequestBody List<StockIn> stockInList, HttpServletResponse response) throws Exception {
        try{
            stockInService.saveList(poId, stockInList);
             renderString(response, "转入库存成功!");
        }
       catch(Exception e){
           renderString(response, "转入库存失败!");
       }
    }
}
