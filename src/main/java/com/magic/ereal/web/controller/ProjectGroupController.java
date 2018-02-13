package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.ProjectGroup;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.ProjectGroupService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.View;

import javax.annotation.Resource;

/**
 * 项目组
 * @author lzh
 * @create 2017/4/25 15:43
 */
@RestController
@RequestMapping("/projectGroup")
public class ProjectGroupController extends BaseController {

    @Resource
    private ProjectGroupService projectGroupService;


    /**
     * 新建项目组
     * @param projectGroup 项目组实体
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(ProjectGroup projectGroup){
        try {
            User user = (User) LoginHelper.getCurrentUser();
            projectGroup.setCreateUserId(user.getId());
            projectGroupService.addProjectGroup(projectGroup);
            return buildFailureJson(StatusConstant.SUCCESS_CODE," 新增成功");
        } catch (Exception e) {
            logger.error("服务器超时，新增项目组失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增项目组失败");
        }
    }

    /**
     * 更新项目组
     * @param projectGroup 项目组实体
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(ProjectGroup projectGroup){
        try {
            projectGroupService.updateProjectGroup(projectGroup);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新项目组失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新项目组失败");
        }
    }

    /**
     * 项目组集合
     * @param departmentId
     * @param isValid
     * @param pageArgs
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(Integer departmentId, Integer isManager, String projectName, Integer isValid, PageArgs pageArgs){
        try {
            PageList<ProjectGroup> pageList = projectGroupService.list( departmentId, isManager, projectName, isValid,  pageArgs);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE," 获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取项目组列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取项目组列表失败");
        }
    }

    /**
     * 项目组集合(下拉列表)
     * @param departmentId
     * @return
     */
    @RequestMapping("/listSelect")
    public ViewData listSelect(Integer departmentId){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE," 获取成功",projectGroupService.listSelect(departmentId));
        } catch (Exception e) {
            logger.error("服务器超时，获取项目组列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取项目组列表失败");
        }
    }

    /**
     * 获取项目组
     * @param departmentId
     * @return
     */
    @RequestMapping("/queryProjectGroupManager")
    public ViewData queryProjectGroupManager(Integer departmentId){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE," 获取成功"
                    ,projectGroupService.queryProjectGroupManagerByDepartmentId(departmentId));
        } catch (Exception e) {
            logger.error("服务器超时，获取项目组列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取项目组列表失败");
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
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE," 获取成功", projectGroupService.queryProjectGroupIncludeUsersById(id));
        } catch (Exception e){
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

}
