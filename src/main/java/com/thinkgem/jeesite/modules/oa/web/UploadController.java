package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.utils.UploadUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Administrator on 2016/10/11.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/upload")
public class UploadController {

    @RequestMapping(value = {"upload", ""})
    @ResponseBody
    public String[] importProduct(HttpServletRequest request) throws Exception {
        try {
            UploadUtils utils = new UploadUtils();
            return utils.uploadFile(request);
        }
        catch (Exception e) {
            throw new Exception("上传失败!");
        }
    }
}
