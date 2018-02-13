package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.service.SecondTargetService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

/**
 * Created by Eric Xie on 2017/5/22 0022.
 */
@Controller
@RequestMapping("/secondTarget")
public class SecondTargetController extends BaseController {

    @Resource
    private SecondTargetService secondTargetService;


    /**
     * 更新配置
     * @param secondTarget
     * @return
     */
    @RequestMapping("/updateSecondTarget")
    public @ResponseBody ViewData updateSecondTarget(SecondTarget secondTarget){
        if(null == secondTarget.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            secondTargetService.updateSecondTarget(secondTarget);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 删除配置
     * @return
     */
    @RequestMapping("/delSecondTarget")
    public @ResponseBody ViewData delSecondTarget(Integer id){
        User currentUser = (User)LoginHelper.getCurrentUser();
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            secondTargetService.delSecondTarget(id);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 新增配置
     * @param secondTarget
     * @param timeType 0：周   1：月
     * @return
     */
    @RequestMapping("/addSecondTarget")
    public @ResponseBody ViewData addSecondTarget(SecondTarget secondTarget,Integer timeType){
        User currentUser = (User)LoginHelper.getCurrentUser();
        if((null == secondTarget.getDepartmentId() || null == secondTarget.getTargetMsg()
                || null == secondTarget.getTargetName() || null == secondTarget.getTargetWeight()
                || null == secondTarget.getTargetTime() || null == timeType)
                ){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        secondTarget.setCreateUserId(currentUser.getId());
        //secondTarget.setTargetTime(new Date(secondTarget.getTargetTime()));

        try {
            secondTargetService.addSecondTarget(secondTarget,timeType);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 第二维新增打分配置
     * @param secondTarget
     * @param timeType 0：周   1：月
     * @return
     */
    @RequestMapping("/addSecondTargetScore")
    public @ResponseBody ViewData addSecondTargetScore(Date time,Integer timeType,Double dutyGrade, Double managerGrade,
                                                       Integer departmentId){
        User currentUser = (User)LoginHelper.getCurrentUser();

        if(null == time || null == timeType || null == departmentId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(RoleEnum.GENERAL_MANAGER.ordinal() == currentUser.getRoleId() && null == managerGrade){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        else if(RoleEnum.GENERAL_MANAGER_ON_DUTY.ordinal() == currentUser.getRoleId() && null == dutyGrade){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        else if(RoleEnum.GENERAL_MANAGER_ON_DUTY.ordinal() != currentUser.getRoleId() &&
                RoleEnum.GENERAL_MANAGER.ordinal() != currentUser.getRoleId()) {
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        try {
            secondTargetService.addSecondTarget(time,timeType,dutyGrade,managerGrade,departmentId,currentUser.getId());
        } catch (ParseException e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }





    /**
     * 获取 二维 指标配置项
     * @param pageArgs 分页参数
     * @param departmentId 部门ID
     * @param date 月份日期 时间戳
     * @param  isScore  是否是打分列表 0：不是  1：是
     * @return
     */
    @RequestMapping("/querySecondTarget")
    public @ResponseBody ViewData querySecondTarget(PageArgs pageArgs, Integer departmentId, Long date,Integer timeType,
                                                    Integer isScore, Integer isProjectDepartment){
        try {
            PageList<SecondTarget> pageList = secondTargetService.querySecondTarget(pageArgs,departmentId,date == null ? null : new Date(date),
                    timeType,isScore, isProjectDepartment);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器失败，获取外部项目列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器失败，获取外部项目列表失败");
        }
    }




}
