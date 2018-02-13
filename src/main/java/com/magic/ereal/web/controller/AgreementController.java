package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Agreement;
import com.magic.ereal.business.service.AgreementService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/5/24 0024.
 */
@Controller
@RequestMapping("/agreement")
public class AgreementController extends BaseController {

    @Resource
    private AgreementService agreementService;


    @RequestMapping("/getAgreement")
    public @ResponseBody ViewData getAgreement(){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                agreementService.queryAgreement());
    }



    @RequestMapping("/updateAgreement")
    public @ResponseBody ViewData updateAgreement(Agreement agreement){
        if(null == agreement.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            agreementService.updateAgreement(agreement);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功");
    }


}
