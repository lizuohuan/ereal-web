package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.OfferAward;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.service.CustomAwardsService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 自定义奖项 颁发
 * Created by Eric Xie on 2017/8/21 0021.
 */

@RestController
@RequestMapping("/offerAward")
public class OfferAwardController extends BaseController {


    @Resource
    private CustomAwardsService customAwardsService;



    @RequestMapping("/delAwards")
    public ViewData delAwards(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        customAwardsService.delOfferAward(id);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 动态获取自定义奖项
     * @param pageArgs
     * @param type
     * @return
     */
    @RequestMapping("/queryAwards")
    public ViewDataPage queryAwards(PageArgs pageArgs, Integer type, Date month){
        Map<String,Object> baseParams = new HashMap<>();
        baseParams.put("type",type);
        baseParams.put("month",month);
        PageList<OfferAward> data = customAwardsService.queryOfferAwardByItems(pageArgs, baseParams);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",data.getTotalSize(),data.getList());
    }

    /**
     * 颁发自定义奖项
     * @return
     */
    @RequestMapping("/addAwards")
    public ViewData addAwards(Integer customAwardsId,Long month,Integer targetId){
        if(CommonUtil.isEmpty(customAwardsId) || CommonUtil.isEmpty(month) || CommonUtil.isEmpty(targetId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        OfferAward offerAward = new OfferAward();
        offerAward.setCustomAwardsId(customAwardsId);
        offerAward.setMonth(new Date(month));
        offerAward.setTargetId(targetId);
        customAwardsService.addAdwards(offerAward);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



}
