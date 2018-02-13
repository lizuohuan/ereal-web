package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.SecondVeidoo;
import com.magic.ereal.business.service.SecondVeidooService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/5/22 0022.
 */
@Controller
@RequestMapping("/secondVeidoo")
public class SecondVeidooController extends BaseController {

    @Resource
    private SecondVeidooService secondVeidooService;


    @RequestMapping("/getSecondVeidoo")
    public @ResponseBody ViewData getSecondVeidoo(Integer type){
        if(null == type){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                secondVeidooService.querySecondVeidoo(type));
    }





    @RequestMapping("/updateSecondVeidoo")
    public @ResponseBody ViewData updateSecondVeidoo(SecondVeidoo secondVeidoo){
        if(null == secondVeidoo.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            if(null == secondVeidoo.getDutyManager() && null == secondVeidoo.getMethod() && null == secondVeidoo.getWeightManager()){
                return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
            }
            secondVeidooService.updateSecondVeidoo(secondVeidoo);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
        }catch (Exception e){
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
    }





}
