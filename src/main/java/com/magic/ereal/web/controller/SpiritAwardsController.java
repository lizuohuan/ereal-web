package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.SpiritAwards;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.SpiritAwardsService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/6/6 0006.
 */

@Controller
@RequestMapping("/spiritAwards")
public class SpiritAwardsController extends BaseController {


    @Resource
    private SpiritAwardsService spiritAwardsService;

    /**
     * 新增奖项
     * @param awards
     * @return
     */
    @RequestMapping("/addSpiritAwards")
    public @ResponseBody ViewData addSpiritAwards(SpiritAwards awards){
        User currentUser = (User) LoginHelper.getCurrentUser();
        try {
            awards.setCreateUserId(currentUser.getId());
            spiritAwardsService.addSpiritAwards(awards);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"添加失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
    }


    /**
     * 获取列表
     * @param  type 0:精神奖  1: 优秀执委奖
     * @return
     */
    @RequestMapping("/getSpiritAwards")
    public @ResponseBody ViewData getSpiritAwards(Date month, PageArgs pageArgs,Integer type){
        PageList<SpiritAwards> data = spiritAwardsService.querySpiritAwardsByItems(month, pageArgs, type);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",data.getTotalSize(),
                data.getList());
    }






}
