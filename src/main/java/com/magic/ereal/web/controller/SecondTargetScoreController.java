package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.SecondTargetScore;
import com.magic.ereal.business.service.SecondTargetScoreService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 第二维 配置 打分  第二维 第三种计算方式的时候
 * Created by Eric Xie on 2017/7/3 0003.
 */
@RestController
@RequestMapping("/secondTargetScore")
public class SecondTargetScoreController extends BaseController {

    @Resource
    private SecondTargetScoreService secondTargetScoreService;


    /**
     *  新增打分 第二维
     * @param secondTargetId 第二维配置ID
     * @param score  分数  [0-100]
     */
    @RequestMapping("/addSecondTargetScore")
    public ViewData addSecondTargetScore(Integer secondTargetId,Double score){
        if(null == secondTargetId || null == score){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if( 0 == secondTargetId || score < 0 || score > 100){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        SecondTargetScore secondTargetScore = new SecondTargetScore();
        secondTargetScore.setScore(score);
        secondTargetScore.setSecondTargetId(secondTargetId);
        try {
            secondTargetScoreService.addSecondTargetScore(secondTargetScore);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



}
