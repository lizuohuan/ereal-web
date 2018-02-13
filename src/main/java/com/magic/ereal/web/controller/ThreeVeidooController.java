package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.ThreeVeidoo;
import com.magic.ereal.business.service.ThreeVeidooService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * 第三维配置--控制器
 */
@RequestMapping("/threeVeidoo")
@Controller
public class ThreeVeidooController extends BaseController{
    @Resource
    private ThreeVeidooService threeVeidooService;

    /**
     * 添加第三维配置
     * @param threeVeidoo
     * @return
     */
    @RequestMapping("/add")
    public @ResponseBody
    ViewData addThreeVeidoo (ThreeVeidoo threeVeidoo) {
        try{
            threeVeidooService.insert(threeVeidoo);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 修改第三维配置
     * @param threeVeidoo
     * @return
     */
    @RequestMapping("/update")
    public @ResponseBody
    ViewData updateThreeVeidoo (ThreeVeidoo threeVeidoo) {
        if (null == threeVeidoo.getId()) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            threeVeidooService.update(threeVeidoo);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 获取第三维配置
     * @return
     */
    @RequestMapping("/list")
    public @ResponseBody ViewData list () {
        try {
            List<ThreeVeidoo> list = threeVeidooService.queryAllThreeVeidoo();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",list);
        } catch (Exception e) {
            logger.error("服务器超时，获取第三维配置列表失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取第三维配置列表失败");
        }
    }

    /**
     * 获取排除一和二配置 -- 下拉框
     * @return
     */
    @RequestMapping("/selectList")
    public @ResponseBody ViewData queryExcludeOneOrTwo () {
        try {
            List<ThreeVeidoo> list = threeVeidooService.queryExcludeOneOrTwo();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",list);
        } catch (Exception e) {
            logger.error("服务器超时，获取第三维配置列表失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取第三维配置列表失败");
        }
    }
}
