package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.Suggest;
import com.magic.ereal.business.service.SuggestService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/6/20 0020.
 */
@Controller
@RequestMapping("/suggest")
public class SuggestController extends BaseController {

    @Resource
    private SuggestService suggestService;


    @RequestMapping("/querySuggest")
    public @ResponseBody ViewDataPage querySuggest(PageArgs pageArgs, Long startTime, Long endTime){
        Date start = startTime == null ? null : new Date(startTime);
        Date end = endTime == null ? null : new Date(endTime);
        PageList<Suggest> suggestPageList = suggestService.querySuggest(pageArgs.getPage() + 1, pageArgs.getPageSize(), start, end);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                suggestPageList.getTotalSize(),suggestPageList.getList());

    }




}
