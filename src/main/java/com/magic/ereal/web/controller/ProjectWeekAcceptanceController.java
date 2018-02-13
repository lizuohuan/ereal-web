package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Project;
import com.magic.ereal.business.entity.ProjectWeekAcceptance;
import com.magic.ereal.business.entity.SystemInfo;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.enums.SystemInfoEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.push.PushMessageUtil;
import com.magic.ereal.business.service.ProjectService;
import com.magic.ereal.business.service.ProjectWeekAcceptanceService;
import com.magic.ereal.business.service.SystemInfoService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.IsEmpty;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.business.util.TextMessage;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Map;

/**
 * 外部项目 周验收 -- 控制器
 * @author lzh
 * @create 2017/5/5 9:00
 */
@RestController
@RequestMapping("/projectWeekAcceptance")
public class ProjectWeekAcceptanceController extends BaseController {

    @Resource
    private ProjectWeekAcceptanceService projectWeekAcceptanceService;
    @Resource
    private UserService userService;
    @Resource
    private SystemInfoService systemInfoService;
    @Resource
    private ProjectService projectService;

    /**
     * 申请周验收
     * @param projectWeekAcceptance
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(ProjectWeekAcceptance projectWeekAcceptance) {
        try {
            if(null ==  projectWeekAcceptance.getProjectId()){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Project project = projectService.queryBaseProjectById(projectWeekAcceptance.getProjectId());
            if(null == project){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"项目不存在");
            }
            projectWeekAcceptanceService.save(projectWeekAcceptance);

            // 申请周验收后 推送给B导师
            User bTeahcher = userService.queryUserDeviceTypeAndToken(project.getbTeacherId()).get(0);
            SystemInfo info = new SystemInfo();
            info.setTitle(TextMessage.PROJECT_APPLICATION_WEEK_TITLE);
            info.setContent(MessageFormat.format(TextMessage.PROJECT_APPLICATION_WEEK_CONTENT,project.getProjectNumber()));
            info.setUserId(bTeahcher.getId());
            info.setType(SystemInfoEnum.PROJECT_INFO.ordinal());
            systemInfoService.addSystemInfo(info);
            Map<String,String> extendsParams = new HashMap<>();
            extendsParams.put("type",info.getType().toString());
            PushMessageUtil.pushMessages(bTeahcher,info.getTitle(),extendsParams);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"申请周验收成功");
        } catch (Exception e) {
            logger.error("服务器超时，申请周验收失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，申请周验收失败");
        }
    }

    /**
     * 进行验收
     * @param projectWeekAcceptance
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(ProjectWeekAcceptance projectWeekAcceptance) {
        try {
            if (null == projectWeekAcceptance) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == projectWeekAcceptance.getSectionDetail() || "".equals(projectWeekAcceptance.getSectionDetail())) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
            if(null ==  projectWeekAcceptance.getProjectId()){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Project project = projectService.queryBaseProjectById(projectWeekAcceptance.getProjectId());
            if(null == project){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"项目不存在");
            }
            projectWeekAcceptanceService.update(projectWeekAcceptance);
            // 周验收通过后 推送给A导师
            User aTeahcher = userService.queryUserDeviceTypeAndToken(project.getaTeacher()).get(0);
            SystemInfo info = new SystemInfo();
            info.setTitle(TextMessage.PROJECT_APPROVED_WEEK_TITLE);
            info.setContent(MessageFormat.format(TextMessage.PROJECT_APPROVED_WEEK_CONTENT,project.getProjectNumber()));
            info.setUserId(aTeahcher.getId());
            info.setType(SystemInfoEnum.PROJECT_INFO.ordinal());
            systemInfoService.addSystemInfo(info);

            Map<String,String> extendsParams = new HashMap<>();
            extendsParams.put("type",info.getType().toString());
            PushMessageUtil.pushMessages(aTeahcher,info.getTitle(),extendsParams);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"周验收成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，周验收失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，周验收失败");
        }
    }


    /**
     *  查询项目 的周验收列表详情
     * @param projectId 项目ID
     * @return 周验收集合
     */
    @RequestMapping("/list")
    public ViewData list(Integer projectId) {
        try {
            if (null == projectId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectWeekAcceptanceService.list(projectId));
        } catch (Exception e) {
            logger.error("服务器超时，获取周验收列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取周验收列表失败");
        }
    }

}
