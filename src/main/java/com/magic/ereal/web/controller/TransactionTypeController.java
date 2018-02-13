package com.magic.ereal.web.controller;

import com.magic.ereal.business.service.TransactionTypeService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 事务类别 -- 控制器
 * @author lzh
 * @create 2017/4/27 15:23
 */
@RestController
@RequestMapping("/transactionType")
public class TransactionTypeController extends BaseController {

    @Resource
    private TransactionTypeService transactionTypeService;

    /**
     * 获取事务类别列表
     * @return
     */
    @RequestMapping("/list")
    public ViewData list(){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",transactionTypeService.list());
        } catch (Exception e) {
            logger.error("服务器超时，获取事务类别列表失败");
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取事务类别列表失败");
        }
    }
}
