package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.CompanyBanner;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.CompanyBannerService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/8/22 0022.
 */
@RestController
@RequestMapping("/companyBanner")
public class CompanyBannerController extends BaseController {


    @Resource
    private CompanyBannerService companyBannerService;


    /**
     * 删除banner
     * @param id
     * @return
     */
    @RequestMapping("/delCompanyBanner")
    public ViewData delCompanyBanner(Integer id){
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        companyBannerService.delCompanyBanner(id);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 更新公司banner
     * @param companyBanner
     * @return
     */
    @RequestMapping("/updateCompanyBanner")
    public ViewData updateCompanyBanner(CompanyBanner companyBanner){
        if(null == companyBanner.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        companyBannerService.updateCompanyBanner(companyBanner);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 获取公司banner
     * @param pageArgs
     * @param type
     * @param companyId
     * @return
     */
    @RequestMapping("/queryCompanyBanner")
    public ViewDataPage queryCompanyBanner(PageArgs pageArgs,Integer type,Integer companyId){

        Map<String,Object> params = new HashMap<>();
        params.put("type",type);
        params.put("companyId",companyId);
        PageList<CompanyBanner> pageList = companyBannerService.queryCompanyBannerByItems(pageArgs, params);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),
                pageList.getList());
    }

    /**
     * 新增公司banner
     * @param title
     * @param context
     * @param imgUrl
     * @param companyId
     * @param type
     * @return
     */
    @RequestMapping("/addCompanyBanner")
    public ViewData addCompanyBanner(String title,String context,String imgUrl,Integer companyId,
                                     Integer type){

        if(CommonUtil.isEmpty(title,context,imgUrl) || CommonUtil.isEmpty(companyId,type)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(0 != type && 4 != type){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        CompanyBanner banner = new CompanyBanner();
        banner.setType(type);
        banner.setCompanyId(companyId);
        banner.setContext(context);
        banner.setImgUrl(imgUrl);
        banner.setTitle(title);
        banner.setCreateUserId(((User)(LoginHelper.getCurrentUser())).getId());
        companyBannerService.addCompanyBanner(banner);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 新增公司banner
     * @return
     */
    @RequestMapping("/queryBannerById")
    public ViewData queryBannerById(Integer bannerId){

        if(CommonUtil.isEmpty(bannerId) ){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"操作成功",
                companyBannerService.queryBannerById(bannerId));
    }



}
