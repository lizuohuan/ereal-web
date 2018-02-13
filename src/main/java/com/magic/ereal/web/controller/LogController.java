package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Log;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.service.LogService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/7/5 0005.
 */
@RestController
@RequestMapping("/log")
public class LogController extends BaseController {



    @Resource
    private LogService logService;


    @RequestMapping("/queryLogByItems")
    public ViewDataPage queryLogByItems(Long start, Long end, PageArgs pageArgs){

        Date startTime = null == start ? null : new Date(start);
        Date endTime = null == end ? null : new Date(end);
        PageList<Log> logPageList = logService.queryLogByItems(pageArgs.getPage() + 1, pageArgs.getPageSize(),
                startTime, endTime);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                logPageList.getTotalSize(),logPageList.getList());
    }

}
