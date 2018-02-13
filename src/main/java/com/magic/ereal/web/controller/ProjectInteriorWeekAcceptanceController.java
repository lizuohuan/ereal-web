package com.magic.ereal.web.controller;

import com.alibaba.fastjson.JSONArray;
import com.magic.ereal.business.entity.ProjectInteriorWeekAcceptance;
import com.magic.ereal.business.entity.ProjectInteriorWeekKAllocation;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.ProjectInteriorWeekAcceptanceService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * 周验收 -- 控制器
 * @author lzh
 * @create 2017/5/2 17:22
 */
@RestController
@RequestMapping("/projectInteriorWeekAcceptance")
public class ProjectInteriorWeekAcceptanceController extends BaseController {

    @Resource
    private ProjectInteriorWeekAcceptanceService projectInteriorWeekAcceptanceService;



    /**
     * 获取待分配 K值的 周验收 基础数据 以及员工工时列表
     * @param weekId 周ID
     * @return
     */
    @RequestMapping("/getAllocationWeekData")
    public ViewData getWeekData(Integer weekId){
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        if(null == weekId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                projectInteriorWeekAcceptanceService.queryAcceptanceIncludeUserH(weekId));
    }


    /**
     * 新增/申请内部周验收
     * @param acceptance
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(ProjectInteriorWeekAcceptance acceptance) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == acceptance) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == acceptance.getProjectInteriorId()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
//            if (!user.getRoleId().equals(RoleEnum.PROJECT_MANAGER.ordinal())) {
//                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
//            }

            projectInteriorWeekAcceptanceService.addProjectInteriorWeekAcceptance(acceptance);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"申请周验收成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，申请周验收失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，申请周验收失败");
        }
    }

    /**
     * 内部周验收 通过审核
     * @param acceptance 周验收对象 总进度必须有值
     */
    @RequestMapping("/update")
    public ViewData update( ProjectInteriorWeekAcceptance acceptance,Integer isFinish) {
        try {
            projectInteriorWeekAcceptanceService.approvedProjectInteriorWeek(acceptance,isFinish);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"周验收成功");
        } catch (Exception e) {
            logger.error("服务器超时，周验收失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，周验收失败");
        }
    }

    /**
     * 比例分配
     * @param projectInteriorWeekKAllocation 比例分配数据集合 ProjectInteriorWeekKAllocation封装的json对象
     *                    之前需要判断 当周的状态 必须为审核之后
     * @throws Exception
     */
    @RequestMapping("/allocationRatio")
    public ViewData allocationRatio(String projectInteriorWeekKAllocation) {
        try {
            if (null == projectInteriorWeekKAllocation || "".equals(projectInteriorWeekKAllocation)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            List<ProjectInteriorWeekKAllocation> list = JSONArray.parseArray(projectInteriorWeekKAllocation,ProjectInteriorWeekKAllocation.class);
            projectInteriorWeekAcceptanceService.allocationRatio(list);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"周验收成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，周验收失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，周验收失败");
        }
    }


}
