package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.enums.SystemInfoEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.push.PushMessageUtil;
import com.magic.ereal.business.service.ProjectService;
import com.magic.ereal.business.service.ProjectTypeSectionService;
import com.magic.ereal.business.service.SystemInfoService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.business.util.TextMessage;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.xml.soap.Text;
import java.text.MessageFormat;
import java.util.*;

/**
 * 外部项目 -- 控制器
 * @author lzh
 * @create 2017/5/3 13:53
 */
@RestController
@RequestMapping("/project")
public class ProjectController extends BaseController {

    @Resource
    private ProjectService projectService;
    @Resource
    private UserService userService;
    @Resource
    private ProjectTypeSectionService projectTypeSectionService;
    @Resource
    private SystemInfoService systemInfoService;




    /**
     * 删除项目
     * @param projectId 项目ID
     * @return
     */
    @RequestMapping("/delProject")
    public @ResponseBody ViewData delProject(Integer projectId){
        if(CommonUtil.isEmpty(projectId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Project project = projectService.queryBaseProjectById(projectId);
        if(null == project){
            return buildFailureJson(StatusConstant.Fail_CODE,"项目不存在");
        }
//        if(project.getConnectStatus() != -1){
//            return buildFailureJson(StatusConstant.Fail_CODE,"项目已启动，不能删除");
//        }
        project.setIsValid(0);
        projectService.updateProject(project);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"删除成功");
    }




    /**
     * 通过项目ID  查询参与项目的用户集合
     * @param projectId 项目ID
     * @return
     */
    @RequestMapping("/getProjectUser")
    public @ResponseBody ViewData getProjectUser(Integer projectId){
        Object obj = LoginHelper.getCurrentUser();
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"帐号无效");
        }
        if(CommonUtil.isEmpty(projectId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                userService.queryWeekUserHByProject(projectId));
    }

    /**
     * 通过项目ID  查询参与项目的课题类型的阶段 集合
     * @param projectId 项目ID
     * @return
     */
    @RequestMapping("/getProjectType")
    public @ResponseBody ViewData getProjectType(Integer projectId){
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"帐号无效");
        }
        if(CommonUtil.isEmpty(projectId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                projectTypeSectionService.getByProjectId(projectId));
    }


    /**
     * 立项
     * @param project
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(Project project) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            project.setCreateUserId(user.getId());
            projectService.addProject(project);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"立项成功");
        } catch (Exception e) {
            logger.error("服务器超时，外部项目立项失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，外部项目立项失败");
        }
    }



    /**
     * 分页查询外部项目列表
     * @param pageArgs 分页
     * @param status 状态
     * @param departmentId 部门id
     * @param projectTypeId 项目课型id
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs,String projectNumber, String projectName, Integer projectGroupId, Integer status, Integer departmentId,
                             Integer projectTypeId, Integer isManagerId,Integer isTerminate) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            PageList<Project> pageList = projectService.list(user.getId(),user.getRoleId(),
                    pageArgs, projectNumber, projectName, projectGroupId, status, departmentId, projectTypeId, isManagerId,
                    isTerminate);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器失败，获取外部项目列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器失败，获取外部项目列表失败");
        }
    }



    /**
     * 项目管理处分配 更新
     * @param project
     * @return
     */
    @RequestMapping("/updateProjectManagerCommittee")
    public ViewData updateProjectManagerCommittee(Project project) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == project) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == project.getDepartmentId() || null == project.getInitWorkload() ||
                        null == project.getbTeacherId() || null == project.getcTeacherId()
                        || null == project.getId() || null == project.getaTeacher()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
//            if (!user.getRoleId().equals(RoleEnum.PROJECT_MANAGER_COMMITTEE.ordinal())) {
//                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
//            }

            Project t = projectService.queryBaseProjectById(project.getId());
            if(null == t){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"项目不存在");
            }

            project.setAllocationUserId(user.getId());
            project.setAllocationTime(new Date());
            projectService.updateProjectManagerCommittee(project);

            // 推送给值总集合
            List<User> users = userService.queryUserByRole(RoleEnum.GENERAL_MANAGER_ON_DUTY.ordinal(), null, null);
            List<SystemInfo> infos = new ArrayList<>();
            Map<String,String> params = new HashMap<>();
            params.put("type",SystemInfoEnum.PROJECT_INFO.ordinal()+"");
            for (User temp : users) {
                SystemInfo info = new SystemInfo();
                info.setUserId(temp.getId());
                info.setTitle(TextMessage.PROJECT_INTERIOR_AUDIT_TITLE);
                info.setContent(MessageFormat.format(TextMessage.PROJEC_INTERIORT_AUDIT_CONTENT,t.getProjectNameShort()));
                info.setType(SystemInfoEnum.PROJECT_INTERIOR_INFO.ordinal());
                infos.add(info);
                PushMessageUtil.pushMessages(temp,info.getContent(),params);
            }
            if(infos.size() > 0){
                systemInfoService.addSystemInfo(infos);
            }
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，外部项目更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，外部项目更新失败");
        }
    }

    /**
     * 更新值总审核
     * @param project
     * @return
     */
    @RequestMapping("/updateProjectGeneralManagerOnDuty")
    public ViewData updateProjectGeneralManagerOnDuty(Project project) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == project) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == project.getConnectStatus()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
//            if (!user.getRoleId().equals(RoleEnum.GENERAL_MANAGER_ON_DUTY.ordinal())) {
//                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
//            }
            Project temp = projectService.queryBaseProjectById(project.getId());
            if(null == temp){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"项目不存在");
            }
            if(3 == temp.getConnectStatus()){
                return buildFailureJson(StatusConstant.Fail_CODE,"已经审核过");
            }

            project.setReviewerTime(new Date());
            projectService.updateProjectGeneralManagerOnDuty(project);
            // 外部项目 值总审核后，需要推送给团队长
            User teacher = userService.queryBaseInfo(temp.getaTeacher());
            if(null != teacher){
                SystemInfo info  =  new SystemInfo();
                info.setUserId(teacher.getId());
                info.setTitle(TextMessage.PROJECT_NEW_TITLE);
                info.setContent(MessageFormat.format(TextMessage.PROJECT_NEW_CONTENT,temp.getProjectNameShort()));
                info.setType(SystemInfoEnum.PROJECT_INFO.ordinal());
                systemInfoService.addSystemInfo(info);
                Map<String,String> extendsParams = new HashMap<>();
                extendsParams.put("type",info.getType().toString());
                PushMessageUtil.pushMessages(teacher,info.getTitle(),extendsParams);
            }


            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，外部项目更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，外部项目更新失败");
        }
    }

    /**
     * 团队长分配
     * @param project
     * @return
     */
    @RequestMapping("/updateProjectProjectManager")
    public ViewData updateProjectProjectManager(Project project) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == project) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == project.getProjectGroupId()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
//            if (!user.getRoleId().equals(RoleEnum.PROJECT_MANAGER.ordinal())) {
//                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
//            }
            project.setAllocationTime(new Date());
            projectService.updateProject(project,null);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (Exception e) {
            logger.error("服务器超时，外部项目团队分配失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，外部项目团队分配失败");
        }
    }

    /**
     * 更新
     * @param project
     * @return
     */
    @RequestMapping("/updateProject")
    public ViewData updateProject(Project project,Integer isPower,Integer isStart) {
        try {
            if(null != isPower && isPower == 1){
                // 权限转移调用
                // 设置团队长
                User user = userService.queryManagerByDepartment(project.getDepartmentId());
                if(null == user){
                    return buildFailureJson(StatusConstant.Fail_CODE,"部门不存在团队长");
                }
                project.setaTeacher(user.getId());
            }
            if(null != project.getcTeacherId()){
                if(project.getaTeacher().equals(project.getbTeacherId()) ||
                        project.getaTeacher().equals(project.getcTeacherId())
                        || project.getbTeacherId().equals(project.getcTeacherId())){
                    return buildFailureJson(StatusConstant.Fail_CODE,"A导师、B导师、C导师不能为同一人");
                }
            }
            projectService.updateProject(project,null);
            if(null != isStart && 1 == isStart){
                // 开启项目  推送给所有的项目管理处
                List<User> users = userService.queryUserByRole(RoleEnum.PROJECT_MANAGER_COMMITTEE.ordinal(), null, null);
                if(null != users && users.size() > 0){
                    List<SystemInfo> infos = new ArrayList<>();
                    Map<String,String> extendsParams = new HashMap<>();
                    extendsParams.put("type",SystemInfoEnum.PROJECT_INFO.ordinal()+"");
                    for (User user : users) {
                        SystemInfo info = new SystemInfo();
                        info.setTitle("外部项目审核");
                        info.setContent("外部项目审核");
                        info.setUserId(user.getId());
                        info.setType(SystemInfoEnum.PROJECT_INFO.ordinal());
                        infos.add(info);
                        if(!com.magic.ereal.business.util.CommonUtil.isEmpty(user.getDeviceToken())){
                            PushMessageUtil.pushMessages(user,info.getTitle(),extendsParams);
                        }
                    }
                    if(infos.size() > 0){
                        systemInfoService.addSystemInfo(infos);
                    }
                }
            }
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，外部项目更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，外部项目更新失败");
        }
    }


    /**
     * 详情
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectService.queryProjectById(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     *  提交 状态审核
     * @param projectId 项目ID
     * @param flag 标记 0:通过半破审核  1：通过全破审核  2:通过内部结项  3:通过外部结项
     * @return
     */
    @RequestMapping("/approved")
    public ViewData approved(Integer projectId,Integer flag,ProjectAcceptanceRecord record){
        Object obj = LoginHelper.getCurrentUser();

        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"帐号无效");
        }
        if(CommonUtil.isEmpty(projectId,flag)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null == record.getScore() || record.getScore() == 0){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Project project = projectService.queryBaseProjectById(projectId);
        if(null == project){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"对象不存在");
        }
        if(flag != 0 && flag != 1 && flag != 2 && flag != 3){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        Project waitUpdate = new Project();
        waitUpdate.setId(projectId);
        record.setProjectId(projectId);

        if(flag == 0){
            // 通过 半坡审核
            if(!StatusConstant.PO_HALF_ING.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            waitUpdate.setStatus(StatusConstant.PO_HALF);
            record.setType(0);
            record.setStatus(1);
        }else if(flag == 1){
            // 通过 全破
            if(!StatusConstant.PO_HALF_ING.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            waitUpdate.setStatus(StatusConstant.PO_ALL);
            record.setType(0);
            record.setStatus(1);
        }else if(flag == 2){
            // 通过 内部结项
            if(!StatusConstant.INTERIOR_OVER_ING.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            // 记录
            waitUpdate.setStatus(StatusConstant.INTERIOR_OVER);
            waitUpdate.setOverTime(new Date());
            record.setType(1);
            record.setStatus(record.getScore() < 70 ? 2 : 1);
        }else{
            // 通过 外部结项
            if(!StatusConstant.EXTERIOR_OVER_ING.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            waitUpdate.setStatus(StatusConstant.EXTERIOR_OVER);
            record.setStatus(record.getScore() < 70 ? 2 : 1);
        }
        try {
            projectService.updateProject(waitUpdate,record);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"提交失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"提交成功");
    }


    /**
     * 申请项目 状态
     * @param projectId 项目ID
     * @param flag 0:申请半破  1:申请全破 2:申请内部结项  3:申请外部结项
     * @return
     */
    @RequestMapping("/applicationPO")
    public ViewData applicationPO(Integer projectId,Integer flag){
        Object obj = LoginHelper.getCurrentUser();

        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"帐号无效");
        }
//        if(RoleEnum.PROJECT_MANAGER.ordinal() != user.getRoleId()){
//            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
//        }
        if(CommonUtil.isEmpty(projectId,flag)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Project project = projectService.queryBaseProjectById(projectId);
        if(null == project){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"对象不存在");
        }
        if(flag != 0 && flag != 1 && flag != 2 && flag != 3){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        ProjectAcceptanceRecord record = null;
        Project waitUpdate = new Project();
        waitUpdate.setId(projectId);
        if(flag == 0){
            // 申请 半破
            if(!StatusConstant.PO_NONE.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            waitUpdate.setStatus(StatusConstant.PO_HALF_ING);
        }else if(flag == 1){
            // 申请 全破
            if(!StatusConstant.PO_HALF.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            waitUpdate.setStatus(StatusConstant.PO_ALL_ING);
        }else if(flag == 2){
            // 申请 内部结项
            if(!StatusConstant.PO_ALL.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            // 记录
            record = new ProjectAcceptanceRecord();
            record.setStatus(0);
            record.setProjectId(projectId);
            record.setType(1);  // 内部结项
            record.setScore(0.0);
            waitUpdate.setStatus(StatusConstant.INTERIOR_OVER_ING);
        }else{
            // 申请 外部结项
            if(!StatusConstant.INTERIOR_OVER.equals(project.getStatus())
                    && !StatusConstant.EXTERIOR_OVER.equals(project.getStatus())){
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"状态异常");
            }
            record = new ProjectAcceptanceRecord();
            record.setStatus(0);
            record.setProjectId(projectId);
            record.setType(2);  // 外部结项
            record.setScore(0.0);
            waitUpdate.setStatus(StatusConstant.EXTERIOR_OVER_ING);
        }
        try {
            projectService.updateProject(waitUpdate,record);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"提交失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"提交成功");
    }

    /**
     * 批量内部结项审核通过
     * @param projectIds 项目ids 以逗号隔开
     * @return
     */
    @RequestMapping("/saveUpdateList")
    public ViewData saveUpdateList(String projectIds) {
        try {
            if (null == projectIds) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            User user = (User) LoginHelper.getCurrentUser();
            projectService.saveUpdateList(projectIds,user.getId());
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (Exception e) {
            logger.error("服务器超时，批量通过内部审核失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，批量通过内部审核失败");
        }
    }


    /**
     * 获取需要可审核的项目
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getAuditProject")
    @ResponseBody
    public ViewDataPage getAuditProject(PageArgs pageArgs) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
//            if (!user.getRoleId().equals(RoleEnum.C_TEACHER.ordinal())) {
//                return buildFailureJsonPage(StatusConstant.NOT_AGREE,"你不是C导师，没有权限");
//            }
            PageList<Project> auditProjectForWeb = projectService.getAuditProjectForWeb(pageArgs.getPage()+1, pageArgs.getPageSize(), user.getId(), user.getRoleId());
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    auditProjectForWeb.getTotalSize(),auditProjectForWeb.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取需要可审核的项目失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取需要可审核的项目失败");
        }
    }


    /**
     * 根据时间段获取破题统计
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return
     */
    @RequestMapping("/getByTimeStatistics")
    @ResponseBody
    public ViewData getByTimeStatistics(Long startTime , Long endTime) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == startTime || null == endTime ) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    projectService.getByTimeStatistics(startTime,endTime,user.getDepartmentId(),user.getRoleId()));
        } catch (Exception e) {
            logger.error("服务器超时，获取需要可审核的项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取需要可审核的项目失败");
        }
    }

    /**
     * 根据时间段获取破题统计
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return
     */
    @RequestMapping("/getByTimeStatisticsData")
    @ResponseBody
    public ViewData getByTimeStatisticsData(Long startTime , Long endTime) {
        try {
            Object obj = LoginHelper.getCurrentUser();
            if(null == obj){
                return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
            }
            if(!(obj instanceof User)){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            User user = (User)obj;
            if (null == startTime || null == endTime ) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    projectService.getByTimeStatisticsData(startTime,endTime,user.getDepartmentId(),user.getRoleId()));
        } catch (Exception e) {
            logger.error("服务器超时，获取需要可审核的项目失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取需要可审核的项目失败");
        }
    }

    /**
     * 传递卡 外部项目筛选
     * @return
     */
    @RequestMapping("/getWorkDiaryPro")
    @ResponseBody
    public ViewData getWorkDiaryPro() {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    projectService.getWorkDiaryPro(user.getId(),user.getRoleId()));
        } catch (Exception e) {
            logger.error("服务器超时，获取项目列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取项目列表失败");
        }
    }


}
