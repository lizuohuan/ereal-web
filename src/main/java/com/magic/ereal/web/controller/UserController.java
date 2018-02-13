package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.mail.EmailUtil;
import com.magic.ereal.business.service.DepartmentService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.business.util.TextMessage;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.MessageFormat;
import java.util.Date;
import java.util.List;

/**
 * @author lzh
 * @create 2017/4/13 14:42
 */
@Controller
@RequestMapping("/user")
public class UserController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private UserService userService;
    @Resource
    private DepartmentService departmentService;







    /**
     * @return
     */
    @RequestMapping("/queryUserByItemsOfV2")
    @ResponseBody
    public ViewData queryUserByItemsOfV2(Integer companyId,Integer departmentId,Integer roleId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"操作成功",
                userService.queryUserByItemsOfV2(companyId,departmentId,roleId));
    }



    /**
     * @return
     */
    @RequestMapping("/queryAllUser")
    @ResponseBody
    public ViewData queryAllUser(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"操作成功",
                userService.queryAllUser());
    }

    /**
     * 设置用户 离职 转正等状态
     * @param userId
     * @param incumbency
     * @return
     */
    @RequestMapping("/setUserStatus")
    @ResponseBody
    public ViewData setUserStatus(Integer userId,Integer incumbency){
        if(CommonUtil.isEmpty(userId,incumbency)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User info = userService.queryBaseInfo(userId);
        if(null == info){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"用户不存在");
        }
        User user = new User();
        user.setId(userId);
        user.setIncumbency(incumbency);
        if(incumbency == 3){
            user.setDimissionTime(new Date());
        }
        if(incumbency == 2){
            user.setPositiveTime(new Date());
        }
        try {
            userService.updateUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(incumbency == 3 && !CommonUtil.isEmpty(info.getToken())){
            //如果设为离职后，强行下线
            LoginHelper.delObject(info.getToken());
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 获取用户详情
     * @param id
     * @return
     */
    @RequestMapping("/getUserById")
    @ResponseBody
    public ViewData getUserById(Integer id){
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",userService.getUserById(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取用户详情失败");
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取用户详情失败");
        }
    }


    @RequestMapping("/logout")
    @ResponseBody
    public ViewData logout(){
        LoginHelper.clearToken();
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"退出成功");
    }




    /**
     * 登录
     * @param account 用户实体
     * @param password 分页实体
     * @return
     */
    @RequestMapping("/login")
    @ResponseBody
    public ViewData login(String account, String password,HttpServletRequest request) {
        try {
            User user = userService.checkLogin(account,password);
//            request.getSession().setAttribute(LoginHelper.SESSION_USER,user);
            // 之前缓存
            if(!CommonUtil.isEmpty(user.getToken())){
                LoginHelper.delObject(user.getToken());
            }
            User temp = new User();
            temp.setId(user.getId());
            temp.setLastLoginTime(new Date());
            temp.setPassword(null);

            user.setLastLoginTime(new Date());
            //user.setPassword(null);
            // 设置缓存
            String token = LoginHelper.addToken(user);
            temp.setToken(token);
            user.setToken(token);
            // 更新用户信息
            userService.updateUser(temp);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"登录成功",user);
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，登录失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，登录失败");
        }
    }

    /**
     * 分页查询用户（web）
     * @param user 用户实体
     * @param pageArgs 分页实体
     * @return
     */
    @RequestMapping("/findUserPageForWeb")
    @ResponseBody
    public ViewDataPage findUserPageForWeb(PageArgs pageArgs, User user) {
        try {
            PageList<User> pageList = userService.findUserPageForWeb(pageArgs,user);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取分页用户列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取分页用户列表失败");
        }
    }

    /**
     * 分页查询用户（web）
     * @param user 用户实体
     * @param pageArgs 分页实体
     * @return
     */
    @RequestMapping("/findUserPageForWeb2")
    @ResponseBody
    public ViewDataPage findUserPageForWeb2(PageArgs pageArgs, User user) {
        try {
            PageList<User> pageList = userService.findUserPageForWeb2(pageArgs,user);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取分页用户列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取分页用户列表失败");
        }
    }
  /**
     * 分页查询用户（web）
     * @param pageArgs 分页实体
     * @return
     */
    @RequestMapping("/findUserPageFoIsValid")
    @ResponseBody
    public ViewDataPage findUserPageFoIsValid(PageArgs pageArgs,User user) {
        try {
            PageList<User> pageList = userService.findUserPageFoIsValid(pageArgs,user);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取分页用户列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取分页用户列表失败");
        }
    }

    /**
     * 添加用户
     * @param user
     */
    @RequestMapping("/insert")
    @ResponseBody
    public ViewData insert(User user) {
        if(CommonUtil.isEmpty(user.getEmail())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {

            if(RoleEnum.SECRETARY.ordinal() == user.getRoleId()){
                // 查询秘书长  只能存在一个秘书长
                List<User> users = userService.queryUserByRole(RoleEnum.SECRETARY.ordinal(), null, null);
                if(null != users && users.size() > 0){
                    return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"秘书长已经存在");
                }
            }
            userService.insert(user);
            // 添加成功 发送邮件
            EmailUtil.sendEmail(new Email(user.getEmail(), TextMessage.EMAIL_ADD_USER_TITLE,
                    MessageFormat.format(TextMessage.EMAIL_ADD_USER_CONTENT,user.getAccount())));
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildSuccessCodeJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，添加失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }

    /**
     * 更新用户
     * @param user
     */
    @RequestMapping("/updateUser")
    @ResponseBody
    public ViewData updateUser(User user) {
        if(null == user.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            userService.updateUser(user);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            return buildSuccessCodeJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }


    @RequestMapping("/verifyWordDiary")
    @ResponseBody
    public ViewData verifyWordDiary(Integer userId) {
        if(null == userId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"更新成功",
                    userService.verifyWordDiary(userId));
    }

    /**
     * 根据角色 查询用户
     * @param roleId
     * @return
     */
    @RequestMapping("/queryUserByRole")
    @ResponseBody
    public ViewData queryUserByRole(Integer roleId,Integer departmentId) {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",userService.queryUserByRole(roleId,departmentId,null));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 根据角色 查询用户
     * @return
     */
    @RequestMapping("/queryUserForWeb")
    @ResponseBody
    public ViewData queryUserForWeb(Integer companyId,Integer departmentId) {
        try {
            if(null == companyId){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",userService.queryUserForWeb(companyId,departmentId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * @return
     */
    @RequestMapping("/getUserByDepartment2")
    @ResponseBody
    public ViewData getUserByDepartment2(Integer departmentId) {
        try {
            if(null == departmentId){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",userService.queryUserByDepartment2(departmentId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 根据角色 查询用户（当前公司下）
     * @param roleId
     * @return
     */
    @RequestMapping("/getCompanyIdRole")
    @ResponseBody
    public ViewData getCompanyIdRole(Integer roleId,Integer departmentId) {
        try {
            if (null == departmentId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.getCompanyIdRole(roleId,departmentId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 根据公司ID 查询用户
     * @return
     */
    @RequestMapping("/queryUserByCompany")
    @ResponseBody
    public ViewData queryUserByCompany(Integer companyId) {
        if(null == companyId){
            User user = (User)LoginHelper.getCurrentUser();
            if(null == user.getCompanyId()){
                companyId = departmentService.info(user.getDepartmentId()).getCompanyId();
            }else{
                companyId = user.getCompanyId();
            }
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                userService.queryUserByCompany(companyId));
    }

    /**
     *  修改密码 接口
     * @param oldPwd
     * @param newPwd
     * @return
     */
    @RequestMapping("/editPassword")
    public @ResponseBody ViewData editPassword(String oldPwd,String newPwd){
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"已离职，帐号不可能用");
        }
        if(CommonUtil.isEmpty(oldPwd,newPwd)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User baseUser = userService.queryBaseInfo(user.getId());
        if(null == baseUser){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"用户不存在");
        }
        if(!oldPwd.equals(baseUser.getPassword())){
            return buildFailureJson(StatusConstant.Fail_CODE,"旧密码不正确");
        }
        User wait = new User();
        try {
            wait.setId(user.getId());
            wait.setPassword(newPwd);
            userService.updateUser(wait);
            // 发送邮件
            EmailUtil.sendEmail(new Email(baseUser.getEmail(), TextMessage.EMAIL_EDIT_PWD_TITLE,TextMessage.EMAIL_EDIT_PWD_CONTENT));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE, "更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE, "修改成功");

    }

    /**
     * 重置密码 接口
     * @param userId
     * @return
     */
    @RequestMapping("/resetPassword")
    public @ResponseBody ViewData resetPassword (Integer userId, String password) {
        User baseUser = userService.queryBaseInfo(userId);
        if (!CommonUtil.isEmpty(baseUser.getToken())) {
            LoginHelper.delObject(baseUser.getToken());
        }
        User user = new User();
        try {
            user.setId(userId);
            user.setPassword(password);
            user.setIsFirst(0);
            userService.updateUser(user);
            // 发送邮件
            EmailUtil.sendEmail(new Email(baseUser.getEmail(), TextMessage.EMAIL_EDIT_PWD_TITLE_RESET,TextMessage.EMAIL_EDIT_PWD_CONTENT_RESET));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE, "更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE, "修改成功");
    }

    /**
     * 锁屏密码验证 接口
     * @param account
     * @param password
     * @return
     */
    @RequestMapping("/lockPassword")
    public @ResponseBody ViewData lockPassword (String account, String password) {
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        try {
            User user = userService.queryUserByPhoneOrAccountForWeb(account);
            if (null == user) {
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"用户不存在");
            }
            if (!user.getPassword().equals(password)) {
                return buildFailureJson(StatusConstant.PASSWORD_ERROR,"密码错误!");
            }
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE, "更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE, "解锁成功");
    }



}
