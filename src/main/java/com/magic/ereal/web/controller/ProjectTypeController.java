package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.ProjectType;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.ProjectTypeService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 项目类型 / 课题类型 -- 控制器
 * @author lzh
 * @create 2017/5/4 9:59
 */
@RestController
@RequestMapping("/projectType")
public class ProjectTypeController extends BaseController {


    @Resource
    private ProjectTypeService projectTypeService;

    /**
     * 新增 项目类型 同时新增阶段
     * @param projectType 课题类型
     * @param projectTypeSectionJson 阶段json数据
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(ProjectType projectType ,String projectTypeSectionJson){
        try {
            projectTypeService.addProjectType(projectType ,projectTypeSectionJson);
            return buildFailureJson(StatusConstant.SUCCESS_CODE," 新增成功");
        } catch (Exception e) {
            logger.error("服务器超时，新增项目组失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增项目组失败");
        }
    }


    /**
     * 更新项目类型 不为空的字段 通过ID
     * @param projectType 课题类型
     * @param projectTypeSectionJson 阶段json数据
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(ProjectType projectType ,String projectTypeSectionJson){
        try {
            projectTypeService.updateProjectType(projectType ,projectTypeSectionJson);
            return buildFailureJson(StatusConstant.SUCCESS_CODE," 更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新项目类型失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新项目类型失败");
        }
    }


    /**
     * 分页查询 项目课题类型  不包括 阶段数据
     * @param pageArgs 分页实体
     * @param isShow 是否显示   null :查询所有，1：查询 显示的 0: 查询不显示的
     * @return
     */
    @RequestMapping("/list")
    @ResponseBody
    public ViewDataPage list(PageArgs pageArgs, Integer isShow) {
        try {
            PageList<ProjectType> pageList = projectTypeService.queryProjectType(pageArgs,isShow);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取分页项目课题类型列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取分页项目课题类型列表失败");
        }
    }

    /**
     * 根据ID 查询 阶段数据 包括 阶段数据
     * @param id
     * @return
     */
    @RequestMapping("/info")
    @ResponseBody
    public ViewData info(Integer id) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectTypeService.queryProjectTypeById(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取课题类型失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取课题类型失败");
        }
    }

    /**
     * 下拉列表使用
     * @return
     */
    @RequestMapping("/listSelect")
    @ResponseBody
    public ViewData listSelect() {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectTypeService.listSelect());
        } catch (Exception e) {
            logger.error("服务器超时，获取课题类型列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取课题类型列表失败");
        }
    }




}
