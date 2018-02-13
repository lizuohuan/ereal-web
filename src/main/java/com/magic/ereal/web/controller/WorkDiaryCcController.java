package com.magic.ereal.web.controller;

import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.WorkDiaryCcService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 抄送人 -- 控制器
 * @author lzh
 * @create 2017/4/25 18:09
 */
@RestController
@RequestMapping("/workDiaryCc")
public class WorkDiaryCcController extends BaseController {

    @Resource
    private WorkDiaryCcService workDiaryCcService;

    /**
     * 批量添加抄送人
     * @param userIds 被抄送人id （逗号隔开）
     * @param workDiaryId 日志id
     */
    @RequestMapping("/save")
    public ViewData save (String userIds,Integer workDiaryId) {
        try {
            workDiaryCcService.save(userIds,workDiaryId);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"抄送成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，抄送失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，抄送失败");
        }
    }
}
