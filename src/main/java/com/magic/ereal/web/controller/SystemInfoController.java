package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.SystemInfo;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.enums.SystemInfoEnum;
import com.magic.ereal.business.push.PushMessageUtil;
import com.magic.ereal.business.service.SystemInfoService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 *  后台消息管理
 * Created by Eric Xie on 2017/6/13 0013.
 */
@Controller
@RequestMapping("/systemInfo")
public class SystemInfoController extends BaseController {

    @Resource
    private UserService userService;
    @Resource
    private SystemInfoService systemInfoService;


    /**
     * 后台自定义推送 消息
     * @param info 消息类型
     * @return
     */
    @RequestMapping("/pushMessage")
    public @ResponseBody ViewData pushMessage(SystemInfo info){
        if(CommonUtil.isEmpty(info.getUserId()) || CommonUtil.isEmpty(info.getContent(),info.getTitle())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User user = userService.queryBaseInfo(info.getUserId());
        if(null == user){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"用户不存在");
        }
        try {
            info.setType(SystemInfoEnum.OTHER_INFO.ordinal());
            systemInfoService.addSystemInfo(info);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"发送失败");
        }
        // 推送
        Map<String,String> extendsParams = new HashMap<>();
        extendsParams.put("type",info.getType().toString());
        PushMessageUtil.pushMessages(user,info.getTitle(),extendsParams);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"发送成功");
    }



}
