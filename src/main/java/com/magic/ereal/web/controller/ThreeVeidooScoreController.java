package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.ThreeVeidooScore;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.ThreeVeidooScoreService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 第三维 评分 -- 控制器
 */
@RequestMapping("/threeVeidooScore")
@Controller
public class ThreeVeidooScoreController extends BaseController {

    @Resource
    private ThreeVeidooScoreService threeVeidooScoreService;

    /**
     * 获取第三维 评分列表
     * @param pageArgs
     * @param departmentId
     * @param date
     * @param type 0:周  1：月
     * @return
     */
    @RequestMapping("/list")
    public @ResponseBody ViewData list (PageArgs pageArgs, Integer departmentId, Integer userId, Long date,Integer type) {
        try {
            PageList<ThreeVeidooScore> pageList = threeVeidooScoreService.list(pageArgs,departmentId,userId, date == null ? null : new Date(date),type);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器失败，获取外部项目列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器失败，获取外部项目列表失败");
        }
    }

    /**
     * 新增
     * @param type 0:周打分  1:月打分
     * @return
     */
    @RequestMapping("/add")
    public @ResponseBody ViewData add (ThreeVeidooScore threeVeidooScore,Integer type) {
        User user = (User) LoginHelper.getCurrentUser();
        try {
            threeVeidooScore.setCreateUserId(user.getId());
            threeVeidooScoreService.insert(threeVeidooScore,type);
        }catch (InterfaceCommonException e){
            logger.error(e.getMessage(),e);
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }
        catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 修改
     * @param threeVeidooScore
     * @return
     */
    @RequestMapping("/update")
    public @ResponseBody ViewData update (ThreeVeidooScore threeVeidooScore) {
        if (null == threeVeidooScore.getId()) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            threeVeidooScoreService.update(threeVeidooScore);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

}
