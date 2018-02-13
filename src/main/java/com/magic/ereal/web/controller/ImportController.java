package com.magic.ereal.web.controller;

import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.JobTypeService;
import com.magic.ereal.business.service.ProjectInteriorService;
import com.magic.ereal.business.service.ProjectService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 *  导入
 * Created by Eric Xie on 2017/9/18 0018.
 */
@Controller
@RequestMapping("/import")
public class ImportController extends BaseController {

    @Resource
    private JobTypeService jobTypeService;
    @Resource
    private UserService userService;
    @Resource
    private ProjectInteriorService projectInteriorService;
    @Resource
    private ProjectService projectService;


    /**
     * 导入 外部项目
     * @param url
     * @return
     */
    @RequestMapping("/importProject")
    public @ResponseBody ViewData importProject(String url){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            projectService.importExcelProject(url);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"导入失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"导入成功");
    }




    /**
     * 导入 内部项目
     * @param url
     * @return
     */
    @RequestMapping("/importProjectInterior")
    public @ResponseBody ViewData importProjectInterior(String url){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            projectInteriorService.importExcelProjectInterior(url);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"导入失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"导入成功");
    }


    /**
     * 导入 用户
     * @param url
     * @return
     */
    @RequestMapping("/importUser")
    public @ResponseBody ViewData importUser(String url){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            userService.importExcelUser(url);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"导入失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"导入成功");
    }

    /**
     * 导入 工作类型
     * @param url
     * @return
     */
    @RequestMapping("/importJobType")
    public @ResponseBody ViewData importJobType(String url){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            jobTypeService.importExcelJobType(url);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"导入失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"导入成功");
    }


}
