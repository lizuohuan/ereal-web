package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.enums.SystemInfoEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.push.PushMessageUtil;
import com.magic.ereal.business.service.ProjectInteriorService;
import com.magic.ereal.business.service.SystemInfoService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.business.util.TextMessage;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.text.MessageFormat;
import java.util.*;

/**
 * 内部项目 -- 控制器
 * @author lzh
 * @create 2017/4/28 11:01
 */
@RestController
@RequestMapping("/projectInterior")
public class ProjectInteriorController extends BaseController {

    @Resource
    private ProjectInteriorService projectInteriorService;
    @Resource
    private UserService userService;
    @Resource
    private SystemInfoService systemInfoService;


    /**
     * 删除内部项目
     * @return
     */
    @RequestMapping("/delProjectInterior")
    public ViewData delProjectInterior(Integer projectId) {
        if(CommonUtil.isEmpty(projectId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        ProjectInterior project = projectInteriorService.queryBaseInfo(projectId);
        if(null == project){
            return buildFailureJson(StatusConstant.Fail_CODE,"项目不存在");
        }
//        if(project.getStatus() != 0){
//            return buildFailureJson(StatusConstant.Fail_CODE,"项目已审核，不能删除");
//        }
        project.setIsValid(0);
        projectInteriorService.update(project);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"删除成功");
    }


    /**
     * 分页查询内部项目列表
     * @param projectInterior
     * @param pageArgs
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(ProjectInterior projectInterior, Integer isManagerId, PageArgs pageArgs) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            //如果角色是团队长 只能看自己的项目 并且是审核通过的
            if (user.getRoleId() == RoleEnum.C_TEACHER.ordinal()) {
                projectInterior.setStatus(1);
                projectInterior.setAllocationUserId(user.getId());
            }

            PageList<ProjectInterior> pageList = projectInteriorService.list(projectInterior,user.getRoleId(), pageArgs,user.getId(), isManagerId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器失败，获取内部项目列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器失败，获取内部项目列表失败");
        }
    }

    /**
     * 内部项目 立项
     * @param projectInterior
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(ProjectInterior projectInterior) {
        try {
            if (null == projectInterior.getDepartmentId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            User user = (User) LoginHelper.getCurrentUser();
            //创建人id
            projectInterior.setCreateUserId(user.getId());
            projectInteriorService.save(projectInterior);

            // 推送给值总集合
            List<User> users = userService.queryUserByRole(RoleEnum.GENERAL_MANAGER_ON_DUTY.ordinal(), null, null);
            List<SystemInfo> infos = new ArrayList<>();
            Map<String,String> params = new HashMap<>();
            params.put("type",SystemInfoEnum.PROJECT_INFO.ordinal()+"");
            for (User temp : users) {
                SystemInfo info = new SystemInfo();
                info.setUserId(temp.getId());
                info.setTitle(TextMessage.PROJECT_INTERIOR_AUDIT_TITLE);
                info.setContent(MessageFormat.format(TextMessage.PROJEC_INTERIORT_AUDIT_CONTENT,projectInterior.getShortName()));
                info.setType(SystemInfoEnum.PROJECT_INTERIOR_INFO.ordinal());
                infos.add(info);
                PushMessageUtil.pushMessages(temp,info.getContent(),params);
            }
            if(infos.size() > 0){
                systemInfoService.addSystemInfo(infos);
            }
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器失败，添加内部项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，添加内部项目失败");
        }
    }




    /**
     * 更新项目信息
     * @param projectInterior
     * @param isPower 权限转移调用  1
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(ProjectInterior projectInterior,Integer isPower) {
        try {
            if(null != isPower && isPower == 1){
                // 权限转移调用
                // 设置团队长
                User user = userService.queryManagerByDepartment(projectInterior.getDepartmentId());
                if(null == user){
                    return buildFailureJson(StatusConstant.Fail_CODE,"部门不存在团队长");
                }
                projectInterior.setAllocationUserId(user.getId());
            }
            projectInteriorService.update(projectInterior);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器失败，更新内部项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，更新内部项目失败");
        }
    }


    /**
     * 更新项目信息 A导师（团队长）分配
     * @param projectInterior
     * @return 分配
     */
    @RequestMapping("/updateAAllocation")
    public ViewData updateAAllocation(ProjectInterior projectInterior) {
        try {
            projectInterior.setAllocationTime(new Date());
            projectInteriorService.update(projectInterior);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器失败，更新内部项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，更新内部项目失败");
        }
    }

    /**
     * 更新项目状态（值总审核）
     * @param projectInterior
     * @return
     */
    @RequestMapping("/updateStatus")
    public ViewData updateStatus(ProjectInterior projectInterior) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == projectInterior) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == projectInterior.getStatus()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
//            if (user.getRoleId() != RoleEnum.GENERAL_MANAGER_ON_DUTY.ordinal()) {
//                return buildFailureJson(StatusConstant.Fail_CODE,"对不起，您不是值总，您没有审核权限");
//            }
            ProjectInterior temp = projectInteriorService.queryBaseInfo(projectInterior.getId());
            if(null == temp){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"项目不存在");
            }
            if(1 == temp.getStatus()){
                return buildFailureJson(StatusConstant.Fail_CODE,"已经审核通过");
            }
            projectInterior.setReviewerUserId(user.getId());
            projectInterior.setReviewerTime(new Date());
            projectInteriorService.update(projectInterior);
            // 推送
            User teacher = userService.queryBaseInfo(temp.getAllocationUserId());
            teacher = projectInterior.getStatus() == 1 ? teacher : userService.queryBaseInfo(temp.getCreateUserId());
            if(null != teacher){
                SystemInfo info  =  new SystemInfo();
                info.setUserId(teacher.getId());
                info.setTitle(
                        projectInterior.getStatus() == 1 ? TextMessage.PROJECT_INTERIOR_NEW_TITLE :
                                TextMessage.PROJECT_INTERIOR_NEW_REJECT_TITLE);
                info.setContent(MessageFormat.format(projectInterior.getStatus() == 1 ? TextMessage.PROJECT_INTERIOR_NEW_CONTENT
                        : TextMessage.PROJECT_INTERIOR_NEW_REJECT_CONTENT,temp.getShortName()));
                info.setType(SystemInfoEnum.PROJECT_INTERIOR_INFO.ordinal());
                systemInfoService.addSystemInfo(info);
                Map<String,String> extendsParams = new HashMap<>();
                extendsParams.put("type",SystemInfoEnum.PROJECT_INFO.ordinal()+"");
                PushMessageUtil.pushMessages(teacher,info.getTitle(),extendsParams);
            }
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器失败，更新内部项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，更新内部项目失败");
        }
    }

    /**
     * 更新项目全部信息 （包括为空时）
     * @param projectInterior
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(ProjectInterior projectInterior) {
        try {
            projectInteriorService.updateAll(projectInterior);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器失败，更新内部项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，更新内部项目失败");
        }
    }

    /**
     * 项目详情
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectInteriorService.info(id));
        } catch (Exception e) {
            logger.error("服务器失败，获取内部项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，获取内部项目失败");
        }
    }


    /**
     * 传递卡 内部项目筛选
     * @return
     */
    @RequestMapping("/getWorkDiaryProInterior")
    public ViewData getWorkDiaryProInterior() {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    projectInteriorService.getWorkDiaryProInterior(user.getId()));
        } catch (Exception e) {
            logger.error("服务器失败，获取内部项目列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器失败，获取内部项目列表失败");
        }
    }



}
