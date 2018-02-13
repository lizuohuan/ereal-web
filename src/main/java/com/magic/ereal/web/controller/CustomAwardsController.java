package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.CustomAwards;
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
import java.util.HashMap;
import java.util.Map;

/**
 * 自定义奖项 控制器
 * Created by Eric Xie on 2017/8/21 0021.
 */

@RestController
@RequestMapping("/customAwards")
public class CustomAwardsController extends BaseController {


    @Resource
    private CustomAwardsService customAwardsService;


    /**
     * 更新自定义奖项
     * @return
     */
    @RequestMapping("/queryCustomAwardsByType")
    public ViewData queryCustomAwardsByType(Integer type){
        if(CommonUtil.isEmpty(type)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"操作成功",
                customAwardsService.queryCustomAwardsByType(type));
    }


    /**
     * 更新自定义奖项
     * @param awardsName
     * @param isValid
     * @param id
     * @return
     */
    @RequestMapping("/updateCustomAwards")
    public ViewData updateCustomAwards(String awardsName,Integer isValid,Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(CommonUtil.isEmpty(awardsName) && CommonUtil.isEmpty(isValid)){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"没有修改");
        }
        CustomAwards customAwards = new CustomAwards();
        customAwards.setId(id);
        customAwards.setAwardsName(awardsName);
        customAwards.setIsValid(isValid);
        customAwardsService.updateCustomAwards(customAwards);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 动态获取自定义奖项
     * @param pageArgs
     * @param type
     * @param awardsName
     * @return
     */
    @RequestMapping("/queryCustomAwards")
    public ViewDataPage queryCustomAwards(PageArgs pageArgs,Integer type,String awardsName){
        Map<String,Object> baseParams = new HashMap<>();
        baseParams.put("type",type);
        baseParams.put("awardsName",awardsName);
        PageList<CustomAwards> data = customAwardsService.queryCustomAwardsByItems(pageArgs, baseParams);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",data.getTotalSize(),data.getList());
    }

    /**
     * 新增自定义奖项
     * @param type
     * @param awardsName
     * @return
     */
    @RequestMapping("/addCustomAwards")
    public ViewData addCustomAwards(Integer type,String awardsName){
        if(CommonUtil.isEmpty(awardsName) || CommonUtil.isEmpty(type)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if( 0 != type && 1 != type){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        CustomAwards customAwards = new CustomAwards();
        customAwards.setType(type);
        customAwards.setAwardsName(awardsName);
        customAwardsService.addCustomAwards(customAwards);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



}
