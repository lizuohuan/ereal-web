package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.service.DepartmentService;
import com.magic.ereal.business.service.ProjectService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * 部门 -- 控制器
 * @author lzh
 * @create 2017/4/21 9:02
 */
@RestController
@RequestMapping("/department")
public class DepartmentController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private DepartmentService departmentService;
    @Resource
    private ProjectService projectService;





    /**
     * @return
     */
    @RequestMapping("/queryAllDepartment")
    public ViewData queryAllDepartment(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"操作成功",
                departmentService.queryAllDepartment());
    }


    /**
     * 删除部门
     * @param departmentId
     * @return
     */
    @RequestMapping("/delDepartment")
    public ViewData delDepartment(Integer departmentId, HttpServletRequest request){
        if(null == departmentId || departmentId == 0){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        User currentUser = (User) LoginHelper.getCurrentUser();
        Department department = new Department();
        department.setId(departmentId);
        department.setIsValid(0); // 无效
        try {
            departmentService.delDepartment(department,currentUser.getId(),request.getRemoteAddr());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 获取公司下所有部门
     * @param companyId 公司id
     * @param type 部门类型  0：平台部门   1：分公司部门
     * @param isProjectDepartmentId 是否查询项目部门  0：职能部门  1：项目部门
     * @return
     */
    @RequestMapping("/getAllDepartmentByCompanyIdForWeb")
    public ViewData getAllDepartmentByCompanyIdForWeb(Integer companyId, Integer type,Integer isProjectDepartmentId) {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    departmentService.getAllDepartmentByCompanyIdForWeb(companyId, type,isProjectDepartmentId));
        } catch (Exception e) {
            logger.error("服务器超时，获取部门列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取部门列表失败");
        }
    }

    /**
     * 获取公司下所有部门
     * @param companyId 公司id
     * @param isProjectDepartmentId 是否查询项目部门  0：职能部门  1：项目部门
     * @return
     */
    @RequestMapping("/queryDepartmentByCompany")
    public ViewData queryDepartmentByCompany(Integer companyId, Integer isProjectDepartmentId) {
        try {
            if(null != isProjectDepartmentId && 0 != isProjectDepartmentId && 1 != isProjectDepartmentId){
                isProjectDepartmentId = null;
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    departmentService.getAllDepartmentByCompanyIdForWeb(companyId, null,isProjectDepartmentId));
        } catch (Exception e) {
            logger.error("服务器超时，获取部门列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取部门列表失败");
        }
    }

 /**
     * 获取公司下所有部门
     * @param companyId 公司id
     * @param type 部门类型  0：平台部门   1：分公司部门
     * @param isProjectDepartment 是否查询项目部门  0：职能部门  1：项目部门
     * @return
     */
    @RequestMapping("/list")
    public ViewData list(Integer companyId, Integer type,Integer isProjectDepartment) {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    departmentService.getAllDepartmentByCompanyIdForWeb(companyId, type,isProjectDepartment));
        } catch (Exception e) {
            logger.error("服务器超时，获取部门列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取部门列表失败");
        }
    }


    /**
     * 权限转移时，获取能转移的部门
     * isProject 是否是 外部项目  1：是外部  0：内部项目
     * @return
     */
    @RequestMapping("/getDepartmentByProject")
    public ViewData getDepartmentByProject(Integer projectId,Integer isProject) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if(1 == isProject){
                Project project = projectService.queryBaseProjectById(projectId);
                if(null == project){
                    return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"对象不存在");
                }
                if(null == project.getDepartmentId()){
                    return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"项目未分配项目组");
                }
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    departmentService.getDepartmentByProject(user.getCompanyId(),projectId,isProject));
        } catch (Exception e) {
            logger.error("服务器超时，获取部门列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取部门列表失败");
        }
    }


    /**
     * 新增部门
     * @param department
     * @return
     */
    @RequestMapping("/addDepartment")
    public ViewData addDepartment(Department department) {
        try {
            departmentService.addDepartment(department);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"新增成功");
        } catch (Exception e) {
            logger.error("服务器超时，新增部门失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增部门失败");
        }
    }

    /**
     * 更新部门
     * @param department
     * @return
     */
    @RequestMapping("/updateDepartment")
    public ViewData updateDepartment(Department department) {
        try {
            departmentService.updateDepartment(department);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新部门失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新部门失败");
        }
    }


    /**
     * 获取公司下所有部门（下拉列表使用）
     * @return
     */
    @RequestMapping("/getAllForWeb")
    public ViewData getAllForWeb() {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    departmentService.getAllForWeb());
        } catch (Exception e) {
            logger.error("服务器超时，获取部门列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取部门列表失败");
        }
    }


    /**
     * 获取公司下所有部门（下拉列表使用）（存在A导师的部门）
     * @return
     */
    @RequestMapping("/getAllForWebGroup")
    public ViewData getAllForWebGroup() {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    departmentService.getAllForWebGroup());
        } catch (Exception e) {
            logger.error("服务器超时，获取部门列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取部门列表失败");
        }
    }

}
