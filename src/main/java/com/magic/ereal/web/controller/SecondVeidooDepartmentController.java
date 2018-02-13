package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.SecondVeidooDepartment;
import com.magic.ereal.business.service.SecondVeidooDepartmentService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 第二维职能部门 公式配置
 * Created by Eric Xie on 2017/7/19 0019.
 */
@RestController
@RequestMapping("/secondVeidooDepartment")
public class SecondVeidooDepartmentController extends BaseController {

    @Resource
    private SecondVeidooDepartmentService secondVeidooDepartmentService;


    @RequestMapping("/addSecondVeidooDepartment")
    public ViewData addSecondVeidooDepartment(Integer departmentId,Integer method){
        if(CommonUtil.isEmpty(departmentId,method)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(method != 1 && method != 2 && method != 3){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        SecondVeidooDepartment secondVeidooDepartment = new SecondVeidooDepartment();
        secondVeidooDepartment.setDepartmentId(departmentId);
        secondVeidooDepartment.setMethod(method);
        secondVeidooDepartmentService.addSecondVeidooDepartment(secondVeidooDepartment);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 通过公司ID 获取 部门配置信息
     * @param companyId 公司ID
     * @return
     */
    @RequestMapping("/querySecondVeidooDepartment")
    public ViewData querySecondVeidooDepartment(Integer companyId){
        if(CommonUtil.isEmpty(companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                secondVeidooDepartmentService.queryDepartmentMethod(companyId));
    }


}
