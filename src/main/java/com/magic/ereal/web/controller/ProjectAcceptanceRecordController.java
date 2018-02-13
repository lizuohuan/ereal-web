package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.ProjectAcceptanceRecord;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.ProjectAcceptanceRecordService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 外部项目 结项记录 -- 控制器
 * @author lzh
 * @create 2017/5/3 15:59
 */
@RestController
@RequestMapping("/projectAcceptanceRecord")
public class ProjectAcceptanceRecordController extends BaseController {


    @Resource
    private ProjectAcceptanceRecordService projectAcceptanceRecordService;

    /**
     * 结项记录集合
     * @param projectId 外部项目id
     * @param type 验收类型 0：破题  1：内部  2：外部
     * @return
     */
    @RequestMapping("/list")
    public ViewData list(Integer projectId , Integer type) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    projectAcceptanceRecordService.list(projectId, type));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 项目进展状态显示
     * @param projectId 外部项目id
     * @return
     */
    @RequestMapping("/acceptanceList")
    public ViewData acceptanceList(Integer projectId) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    projectAcceptanceRecordService.acceptanceList(projectId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 进行记录
     * @param projectAcceptanceRecord
     * @param ptStatus 破题状态 5000 ：未破  5002：半破  5004：全破
     *
     *                 type: 0：破题  1：内部  2：外部
     *
     *
     * @throws Exception
     */
    @RequestMapping("/save")
    public ViewData save(ProjectAcceptanceRecord projectAcceptanceRecord ,Integer ptStatus) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if ( null == projectAcceptanceRecord.getStatus()
                    || null == projectAcceptanceRecord.getType() || null == projectAcceptanceRecord.getProjectId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            projectAcceptanceRecordService.save(projectAcceptanceRecord ,user ,ptStatus);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，操作失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
    }


}
