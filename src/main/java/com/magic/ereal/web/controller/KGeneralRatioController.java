package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.KGeneralRatio;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.KGeneralRatioService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * K常规 比例分配 控制器
 * Created by Eric Xie on 2017/6/30 0030.
 */
@RestController
@RequestMapping("/kGeneralRatio")
public class KGeneralRatioController extends BaseController {

    @Resource
    private KGeneralRatioService kGeneralRatioService;


    /**
     * 新增 K常规 比例分配
     *
     * 所有参数必传
     * @param timeType 时间类型 0：周  1：月
     * @param userId 被分配的用户ID
     * @param ratio 分配的比例 在 [0 - 100] (闭区间)
     * @param time 时间戳
     * @param jobTypeId 被分配的 常规事务 ID
     * @return
     */
    @RequestMapping("/addKGeneralRatio")
    public ViewData addKGeneralRatio(Integer timeType,Integer userId,Double ratio,Long time,
                                     Integer jobTypeId,Double score,Double jobTypeTime){

        if(CommonUtil.isEmpty(userId,timeType,jobTypeId) || null == ratio || CommonUtil.isEmpty(time) || null == score
                || null == jobTypeTime){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(ratio < 0 || ratio > 100 || 0 == time || (timeType != 0 && timeType != 1)){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        User currentUser = (User) LoginHelper.getCurrentUser();
        KGeneralRatio kGeneralRatio = new KGeneralRatio();
        kGeneralRatio.setUserId(userId);
        kGeneralRatio.setJobTypeId(jobTypeId);
        kGeneralRatio.setRatio(ratio);
        kGeneralRatio.setScore(score);
        kGeneralRatio.setJobTypeTime(jobTypeTime);
        kGeneralRatio.setCreateUserId(currentUser.getId());
        try {
            kGeneralRatioService.addKGeneralRatio(kGeneralRatio,timeType,time);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"添加失败");
        }

    }


    /**
     * 获取 K常规比例分配 列表
     * @param timeType 时间类型 0：周 1：月
     * @param time 时间戳
     * @param userId 用户ID (可选)
     * @param jobTypeId 常规事务类型ID (可选)
     * @param departmentId 部门ID (可选，默认当前用户的部门ID)
     * @param pageArgs 分页参数
     * @return
     */
    @RequestMapping("/queryKGeneralRatioByItems")
    public ViewDataPage queryKGeneralRatioByItems(Integer timeType, Long time, Integer userId,
                                                  Integer jobTypeId, Integer departmentId, PageArgs pageArgs){
        if(CommonUtil.isEmpty(timeType)  || CommonUtil.isEmpty(time)){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(timeType != 0 && timeType != 1){
            return buildFailureJsonPage(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }

        if(null == userId && null == departmentId){
            departmentId = ((User)LoginHelper.getCurrentUser()).getDepartmentId();
        }
        try {
            PageList<KGeneralRatio> kGeneralRatioPageList = kGeneralRatioService.queryKGeneralRatioByItems(timeType, time, userId, jobTypeId, departmentId,
                    pageArgs.getPage() + 1, pageArgs.getPageSize());
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    kGeneralRatioPageList.getTotalSize(),kGeneralRatioPageList.getList());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"添加失败");
        }

    }


    /**
     * 获取 K常规 用户 列表
     * @param timeType 时间类型 0：周 1：月
     * @param time 时间戳
     * @param jobTypeId 常规事务类型ID (可选)
     * @param departmentId 部门ID (可选，默认当前用户的部门ID)
     * @return
     */
    @RequestMapping("/queryKGeneralUser")
    public ViewData queryKGeneralUser(Integer timeType, Long time,
                                                  Integer jobTypeId, Integer departmentId){
        if(CommonUtil.isEmpty(timeType,jobTypeId)  || CommonUtil.isEmpty(time)){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(timeType != 0 && timeType != 1){
            return buildFailureJsonPage(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }

        if(null == departmentId){
            departmentId = ((User)LoginHelper.getCurrentUser()).getDepartmentId();
        }
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    kGeneralRatioService.queryKGeneralUserByDepartment(departmentId,jobTypeId,timeType,time));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }


    /**
     *  更新比例分配
     * @param id ID
     * @param ratio 分配的比例 [0-100](闭区间)
     * @return
     */
    @RequestMapping("/updateKGeneralRatio")
    public ViewData updateKGeneralRatio(Integer id,Double ratio,Double jobTypeTime,Double score){
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null == ratio && null == jobTypeTime && null == score){
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        }
        if(null == ratio || ratio < 0 || ratio > 100){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"分配比例填写错误");
        }
        if(null == jobTypeTime || jobTypeTime < 0 ){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"额定时间填写错误");
        }
        if(null == score || score < 0 ){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"质量分填写错误");
        }
        KGeneralRatio kGeneralRatio = new KGeneralRatio();
        kGeneralRatio.setId(id);
        kGeneralRatio.setRatio(ratio);
        kGeneralRatio.setJobTypeTime(jobTypeTime);
        kGeneralRatio.setScore(score);
        try {
            kGeneralRatioService.updateKGeneralRatio(kGeneralRatio);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功");
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
    }









}
