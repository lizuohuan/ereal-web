package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.ProjectMajor;
import com.magic.ereal.business.service.ProjectMajorService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 内部项目专业 -- 控制器
 * @author lzh
 * @create 2017/4/28 11:29
 */
@RestController
@RequestMapping("/projectMajor")
public class ProjectMajorController extends BaseController {

    @Resource
    private ProjectMajorService projectMajorService;

    /**
     * 列表
     * @return
     */
    @RequestMapping("/list")
    public ViewData list() {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectMajorService.list());
        } catch (Exception e) {
            logger.error("服务器超时，获取内部项目专业列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取内部项目专业列表失败");
        }
    }

    /**
     * 新增
     * @param projectMajor
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(ProjectMajor projectMajor) {
        try {
            projectMajorService.save(projectMajor);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"新增内部项目专业成功");
        } catch (Exception e) {
            logger.error("服务器超时，新增内部项目专业成功",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增内部项目专业成功");
        }
    }

    /**
     * 更新
     * @param projectMajor
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(ProjectMajor projectMajor) {
        try {
            projectMajorService.update(projectMajor);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新内部项目专业成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新内部项目专业成功",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新内部项目专业成功");
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
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",projectMajorService.info(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取内部项目专业详情失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取内部项目专业详情失败");
        }
    }

}
