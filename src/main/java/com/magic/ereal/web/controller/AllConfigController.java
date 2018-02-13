package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.AllConfig;
import com.magic.ereal.business.service.AllConfigService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 全局配置 -- 控制器
 * @author lzh
 * @create 2017/6/8 18:09
 */
@RestController
@RequestMapping("/allConfig")
public class AllConfigController extends BaseController {

    @Resource
    private AllConfigService allConfigService;

    /**
     * 更新全局配置
     * @param allConfig
     * @return
     */
    @RequestMapping("/updateAllConfig")
    public ViewData updateAllConfig(AllConfig allConfig) {
        try {
            allConfigService.updateAllConfig(allConfig);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 获取全局配置
     * @return
     */
    @RequestMapping("/getConfig")
    public ViewData getConfig() {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",allConfigService.getConfig());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
