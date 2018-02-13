package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Role;
import com.magic.ereal.business.service.RoleService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author lzh
 * @create 2017/4/20 16:19
 */
@RestController
@RequestMapping("/role")
public class RoleController extends BaseController {


    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private RoleService roleService;


    /**
     * 角色列表
     * @param type 角色类型 0：总公司角色  1常规角色
     * @return
     */
    @RequestMapping("/list")
    public ViewData list(Integer type,Integer flag) {
        try {
            List<Role> list = roleService.list(type,flag);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",list);
        } catch (Exception e) {
            logger.error("服务器超时，获取角色列表失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取角色列表失败");
        }
    }

    /**
     * 添加角色
     * @param role 角色实体
     * @return
     */
    @RequestMapping("/insert")
    public ViewData insert(Role role) {
        try {
            roleService.insert(role);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }

    /**
     * 更新角色
     * @return
     */
    @RequestMapping("/updateRole")
    public ViewData insert(Integer id,String roleName,String describe,Integer isValid) {
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            roleName = CommonUtil.isEmpty(roleName) ? null : roleName;
            describe = CommonUtil.isEmpty(describe) ? null : describe;
            roleService.updateRole(roleName,describe,id,isValid);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }
}
