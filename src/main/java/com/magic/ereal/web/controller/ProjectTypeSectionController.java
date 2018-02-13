package com.magic.ereal.web.controller;

import com.magic.ereal.business.service.ProjectTypeSectionService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 项目类型 / 课题分类 -- 控制器
 * @author lzh
 * @create 2017/5/5 16:27
 */
@RestController
@RequestMapping("/projectTypeSection")
public class ProjectTypeSectionController extends BaseController {

    @Resource
    private ProjectTypeSectionService projectTypeSectionService;

    /**
     * 根据项目id获取阶段数据
     * @param projectId 项目id
     * @return
     */
    @RequestMapping("/getByProjectId")
    public ViewData getByProjectId(Integer projectId) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    projectTypeSectionService.getByProjectId(projectId));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
