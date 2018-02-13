package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.TransactionSub;
import com.magic.ereal.business.service.TransactionSubService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 事务类型 -- 控制器
 * @author lzh
 * @create 2017/4/27 14:23
 */
@RestController
@RequestMapping("/transactionSub")
public class TransactionSubController extends BaseController {


    @Resource
    private TransactionSubService transactionSubService;

    /**
     * 事务类型列表
     * @param isShow
     * @return
     */
    @RequestMapping("/list")
    public ViewData list(Integer isShow) {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    transactionSubService.queryTransactionSubByItem(isShow));
        } catch (Exception e) {
            logger.error("服务器超时，事务类型列表获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，事务类型列表获取失败");
        }
    }

    /**
     * 添加事务类型
     * @param transactionSub
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(TransactionSub transactionSub) {
        try {
            transactionSubService.addTransactionSub(transactionSub);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，事务类型添加失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，事务类型添加失败");
        }
    }

    /**
     * 更新事务类型
     * @param transactionSub
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(TransactionSub transactionSub) {
        try {
            if (null == transactionSub.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            transactionSubService.updateTransactionSub(transactionSub);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，事务类型更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，事务类型更新失败");
        }
    }

}
