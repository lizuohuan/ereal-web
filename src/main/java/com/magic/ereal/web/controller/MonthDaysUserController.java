package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.MonthDaysUser;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.MonthDaysUserService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 员工本月的出勤情况 或其他情况 -- 控制器
 * @author lzh
 * @create 2017/6/8 14:20
 */
@RestController
@RequestMapping("/monthDaysUser")
public class MonthDaysUserController extends BaseController {

    @Resource
    private MonthDaysUserService monthDaysUserService;

    /**
     * 添加 员工本月的出勤情况 或其他情况
     * @param monthDaysUser
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(MonthDaysUser monthDaysUser) {
        try {
            monthDaysUserService.save(monthDaysUser);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，操作失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
    }

    /**
     * 更新 员工本月的出勤情况 或其他情况
     * @param monthDaysUser
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(MonthDaysUser monthDaysUser) {
        try {
            monthDaysUserService.update(monthDaysUser);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，操作失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
    }

    /**
     * 更新 员工本月的出勤情况 或其他情况
     * source 0: 请假  1:其他
     * @param monthDaysUser
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(MonthDaysUser monthDaysUser, PageArgs pageArgs,Integer source) {
        try {
            PageList<MonthDaysUser> list = monthDaysUserService.list(monthDaysUser, pageArgs.getPage() + 1, pageArgs.getPageSize(),source);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",list.getTotalSize(),list.getList());
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

}
