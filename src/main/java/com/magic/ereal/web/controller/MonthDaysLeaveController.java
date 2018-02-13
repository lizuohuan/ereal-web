package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.MonthDaysLeave;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.MonthDaysLeaveService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 请假情况 -- 控制器
 * @author lzh
 * @create 2017/6/8 17:38
 */
@RestController
@RequestMapping("/monthDaysLeave")
public class MonthDaysLeaveController extends BaseController {

    @Resource
    private MonthDaysLeaveService monthDaysLeaveService;

    /**
     * 请假记录列表
     * @param monthDaysLeave
     * @return
     */
    @RequestMapping("/list")
    public ViewData list(MonthDaysLeave monthDaysLeave) {
        try {
            if (null == monthDaysLeave.getUserId() || null == monthDaysLeave.getMonthDaysId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",monthDaysLeaveService.list(monthDaysLeave));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 批量添加 请假时间
     * @param startTimeL
     * @param endTimeL
     * @param userId
     * @param monthDaysId
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(Long startTimeL ,Long endTimeL ,Integer userId ,Integer monthDaysId) {
        try {
            if (null == startTimeL || null == endTimeL || null == userId || null == monthDaysId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            monthDaysLeaveService.save(startTimeL, endTimeL, userId, monthDaysId);
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
     * 批量添加 请假时间
     * @param id
     * @param userId
     * @param monthDaysId
     * @return
     */
    @RequestMapping("/delete")
    public ViewData delete(Integer id,Integer userId ,Integer monthDaysId) {
        try {
            if (null == id || null == userId || null == monthDaysId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            monthDaysLeaveService.delete(id, userId, monthDaysId);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，操作失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
    }
}
