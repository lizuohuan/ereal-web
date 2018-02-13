package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.DepartmentAwards;
import com.magic.ereal.business.entity.SpiritAwards;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.AwardsService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 *
 * 奖项数据  确认
 *
 * Created by Eric Xie on 2017/7/3 0003.
 */
@RestController
@RequestMapping("/awards")
public class AwardsController extends BaseController {

    @Resource
    private AwardsService awardsService;


    /**
     *  新增 团队绩效奖
     * @param departmentAwards
     * @param time 针对月份 时间戳
     * @return
     */
    @RequestMapping("/addDepartmentAwards")
    public ViewData addDepartmentAwards(DepartmentAwards departmentAwards,Long time){
        if(CommonUtil.isEmpty(departmentAwards.getType(),departmentAwards.getDepartmentId(),departmentAwards.getRanking())
                || null == time  ){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        departmentAwards.setMonth(new Date(time));
        departmentAwards.setCreateUserId(((User)LoginHelper.getCurrentUser()).getId());
        try {
            awardsService.addAwards(departmentAwards);
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e);
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功");
    }


    /**
     *  新增 确认 月度K王 奖
     * @param time 针对月份 时间戳
     * @return
     */
    @RequestMapping("/addMaxK")
    public ViewData addMaxK(Integer userId ,Long time){
        if(CommonUtil.isEmpty(userId) || null == time  ){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            SpiritAwards spiritAwards = new SpiritAwards();
            spiritAwards.setUserId(userId);
            spiritAwards.setMonth(new Date(time));
            spiritAwards.setType(2);
            spiritAwards.setCreateUserId(((User)LoginHelper.getCurrentUser()).getId());
            awardsService.addAwards(spiritAwards);
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e);
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功");
    }


}
