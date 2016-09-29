package com.thinkgem.jeesite.modules.oa.service;

import com.thinkgem.jeesite.common.config.Global;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Locale;

/**
 * Created by Ge on 2016/8/27.
 */
@Service
@Lazy(false)
@Component("taskJob")
public class OATaskService {
    @Autowired
    private AlertService alertService;

    @Scheduled(cron = "0 0/9 * * * ?")
    public void job1() {
        if(Global.getConfig("alert.isOn")!=null && Boolean.parseBoolean(Global.getConfig("alert.isOn"))) {
            alertService.scheduleAlert();
            String time = new SimpleDateFormat("MMM d，yyyy KK:mm:ss a", Locale.ENGLISH).format(System.currentTimeMillis());
            System.out.println("time:" + time);
        }
    }
}
