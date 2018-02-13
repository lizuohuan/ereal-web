package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.SecondTargetScoreDepartment;
import com.magic.ereal.business.service.SecondTargetScoreDepartmentService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/7/6 0006.
 */
@RestController
@RequestMapping("/secondTargetScoreDepartment")
public class SecondTargetScoreDepartmentController extends BaseController {


    @Resource
    private SecondTargetScoreDepartmentService secondTargetScoreDepartmentService;


    /**
     * 获取第二维 打分 列表
     * @param time 时间戳
     * @param timeType 时间类型 0：周  1：月   暂时固定时间 为   1
     * @param departmentId 部门ID
     * @return
     */
    @RequestMapping("/queryByItems")
    public ViewDataPage queryByItems(Long time, Integer timeType, Integer departmentId, PageArgs pageArgs){

        if(CommonUtil.isEmpty(timeType)){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Date date = null == time ? null : new Date(time);
        try {
            PageList<SecondTargetScoreDepartment> departmentPageList = secondTargetScoreDepartmentService.queryByItems(date, timeType, departmentId, pageArgs);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",departmentPageList.getTotalSize(),
                    departmentPageList.getList());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    /**
     * 更新打分
     * @param id
     * @param dutyGrade 值总分数
     * @param managerGrade 总经理分数
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(Integer id, Double dutyGrade, Double managerGrade){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null == dutyGrade && null == managerGrade){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            SecondTargetScoreDepartment scoreDepartment = new SecondTargetScoreDepartment();
            scoreDepartment.setId(id);
            scoreDepartment.setDutyGrade(dutyGrade);
            scoreDepartment.setManagerGrade(managerGrade);
            secondTargetScoreDepartmentService.updateScoreDepartment(scoreDepartment);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
    }




}
