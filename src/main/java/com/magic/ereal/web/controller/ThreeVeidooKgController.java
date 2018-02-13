package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.ThreeVeidooKg;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.ThreeVeidooKgService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Eric Xie on 2017/6/7 0007.
 */
@Controller
@RequestMapping("/threeVeidooKg")
public class ThreeVeidooKgController extends BaseController {

    @Resource
    private ThreeVeidooKgService threeVeidooKgService;


    /**
     *
     * @param pageArgs
     * @param departmentId 部门ID
     * @param type 0:职能部门个人KG得分 1：个人K团队得分 记录
     * @param dateType 0：周时间  1：月时间
     * @param date 时间
     * @return
     */
    @RequestMapping("/getThreeVeidooKg")
    public @ResponseBody ViewDataPage getThreeVeidooKg(PageArgs pageArgs, Integer departmentId, Integer type,
                                         Integer dateType, Long date){
        try {
            User currentUser = (User) LoginHelper.getCurrentUser();
            Integer companyId = null;
            if(null == departmentId){
                companyId =  null == currentUser ? null : currentUser.getCompanyId();
            }
            PageList<ThreeVeidooKg> threeVeidooKgPageList = threeVeidooKgService.queryThreeVeidooKgByItems(pageArgs, departmentId, type,
                    dateType, null == date ?  new Date() : new Date(date),companyId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",threeVeidooKgPageList.getTotalSize(),
                    threeVeidooKgPageList.getList());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"获取失败");
        }


    }



    /**
     * 新增KG 打分
     * @param threeVeidooKg
     * @return
     */
    @RequestMapping("/addThreeVeidooKg")
    public @ResponseBody ViewData addThreeVeidooKg(ThreeVeidooKg threeVeidooKg, Long date,String userDatas){

        if(CommonUtil.isEmpty(threeVeidooKg.getDateType(),threeVeidooKg.getType())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(CommonUtil.isEmpty(date)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User currentUser = (User) LoginHelper.getCurrentUser();
        threeVeidooKg.setCreateUserId(currentUser.getId());
        threeVeidooKg.setCreateTime(new Date());
        List<ThreeVeidooKg> dataList = new ArrayList<>();
        if (!CommonUtil.isEmpty(userDatas)) {
            JSONArray jsonArray = JSONArray.fromObject(userDatas);
            for (Object o : jsonArray) {
                JSONObject jsonObject = JSONObject.fromObject(o);
                ThreeVeidooKg data = new ThreeVeidooKg();
                data.setScore(jsonObject.getDouble("score"));
                data.setUserId(jsonObject.getInt("userId"));
                data.setType(threeVeidooKg.getType());
                data.setCreateUserId(currentUser.getId());
                data.setCreateTime(new Date());
                dataList.add(data);
            }
        }else{
            dataList.add(threeVeidooKg);
        }

        try {
            threeVeidooKgService.addThreeVeidooKg(dataList, date,threeVeidooKg.getDateType());
        } catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"新增失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
    }


    /**
     * 修改KG 打分
     * @return
     */
    @RequestMapping("/updateThreeVeidooKg")
    public @ResponseBody ViewData updateThreeVeidooKg(Integer id,Double score){

        if(CommonUtil.isEmpty(id) || null == score){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            ThreeVeidooKg threeVeidooKg = new ThreeVeidooKg();
            threeVeidooKg.setId(id);
            threeVeidooKg.setScore(score);
            threeVeidooKgService.updateThreeVeidooKg(threeVeidooKg);
        } catch (InterfaceCommonException e){
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
    }


}
