package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.MonthDays;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.MonthDaysService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 *
 * 配置 每月 应出勤天数 -- 控制器
 * @author lzh
 * @create 2017/6/8 11:03
 */
@RestController
@RequestMapping("/monthDays")
public class MonthDaysController extends BaseController {

    @Resource
    private MonthDaysService monthDaysService;

    /**
     * 配置
     * @param monthDays
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(MonthDays monthDays) {
        try {
            Calendar c = Calendar.getInstance();
            c.setTime(monthDays.getDateTime());
            Integer days = c.getActualMaximum(Calendar.DAY_OF_MONTH);
            if (monthDays.getDays() > days) {
                return buildFailureJson(StatusConstant.Fail_CODE,"不能大于当月天数,当月最大天数为：" + days + "天");
            }
            monthDaysService.save(monthDays);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"配置成功");
        } catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，配置失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，配置失败");
        }
    }

    /**
     * 更新配置
     * @param monthDays
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(MonthDays monthDays) {
        try {
            monthDaysService.update(monthDays);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新配置成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新配置失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新配置失败");
        }
    }

    /**
     * 获取配置列表
     * @param monthDays
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(MonthDays monthDays , PageArgs pageArgs) {
        try {
            PageList<MonthDays> pageList = monthDaysService.list(monthDays, pageArgs);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取配置列表成功",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取配置列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取配置列表失败");
        }
    }

  /**
     * 获取配置列表
     * @return
     */
    @RequestMapping("/listForSelect")
    public ViewData listForSelect() {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",monthDaysService.queryMonth());
        } catch (Exception e) {
            logger.error("服务器超时，获取配置列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取配置列表失败");
        }
    }


}
