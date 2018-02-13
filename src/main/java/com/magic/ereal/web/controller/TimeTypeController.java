package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.TimeType;
import com.magic.ereal.business.service.TimeTypeService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 时间类型 -- 控制器
 * @author lzh
 * @create 2017/4/21 14:20
 */
@RestController
@RequestMapping("/timeType")
public class TimeTypeController extends BaseController {


    @Resource
    private TimeTypeService timeTypeService;

    /**
     * 新增时间类型
     * @param timeType
     * @return
     */
    @RequestMapping("/addTimeType")
    public ViewData addTimeType(TimeType timeType) {
        try {
            timeTypeService.addTimeType(timeType);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }

    /**
     *  更新时间类型名称
     * @param timeType
     * @return
     */
    @RequestMapping("/updateTimeType")
    public ViewData updateTimeType(TimeType timeType) {

        try {
            timeTypeService.updateTimeType(timeType);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 查询所有有效的 时间类型
     * @return
     */
    @RequestMapping("/queryAllTimeType")
    public ViewData queryAllTimeType() {

        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",timeTypeService.queryAllTimeType());
        } catch (Exception e) {
            logger.error("服务器超时，获取时间类型列表失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取时间类型列表失败");
        }
    }


}
