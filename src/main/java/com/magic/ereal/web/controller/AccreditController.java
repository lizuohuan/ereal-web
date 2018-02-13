package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Accredit;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.AccreditService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 授权用户 控制器
 * Created by Eric Xie on 2017/5/23 0023.
 */
@Controller
@RequestMapping("/accredit")
public class AccreditController extends BaseController {

    @Resource
    private AccreditService accreditService;



    /**
     * 获取 授权人 列表
     * @param type
     * @return
     */
    @RequestMapping("/queryAccreditByToUser")
    public @ResponseBody ViewData queryAccreditByToUser(Integer type){
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"已离职，帐号不可能用");
        }
        if(null == type){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }

        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                accreditService.queryAccreditByToUser(user.getId(),type));
    }


    /**
     * 获取被授权者 目录
     * @param type
     * @return
     */
    @RequestMapping("/queryAccredit")
    public @ResponseBody ViewData queryAccredit(Integer type){
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"已离职，帐号不可能用");
        }
        List<Accredit> data = accreditService.queryAccredit(user.getId(), type);
        Map<String,Object> result = new HashMap<>();
        List<Accredit> works = new ArrayList<>();
        List<Accredit> projects = new ArrayList<>();
        for (Accredit accredit :data){
            if(accredit.getType() == 1){
                projects.add(accredit);
            }else {
                works.add(accredit);
            }
        }
        result.put("projects",projects); // 项目列表
        result.put("works",works); // 工作日志
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",result);
    }

    /**
     * 新增 或者 更新授权目录
     * @return
     */
    @RequestMapping("/addAccredit")
    public @ResponseBody ViewData addAccredit(String toUserIds, Integer type){

        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        User user = (User)obj;
        if(StatusConstant.USER_STATUE_DIMISSION.equals(user.getIncumbency())){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"已离职，帐号不可能用");
        }
        try {
            if(type != null && CommonUtil.isEmpty(toUserIds)){
                accreditService.delAccredit(user.getId(),type);
            }
            List<Accredit> accredits = new ArrayList<>();
            if(!CommonUtil.isEmpty(toUserIds)){
                String[] split = toUserIds.split(",");
                for (String id : split){
                    Accredit accredit = getAccredit(type, user, id);
                    accredits.add(accredit);
                }
            }
            if(accredits.size() > 0){
                accreditService.addAccredit(accredits,user.getId(),type);
            }
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"设置成功");
        }catch (Exception e){
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"设置失败");
        }
    }



    private Accredit getAccredit(Integer type, User user, String id) {
        Accredit accredit = new Accredit();
        accredit.setFromUserId(user.getId());
        accredit.setType(type);
        accredit.setToUserId(Integer.parseInt(id));
        return accredit;
    }


}
