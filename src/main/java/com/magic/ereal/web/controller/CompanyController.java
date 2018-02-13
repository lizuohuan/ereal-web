package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Company;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.CompanyService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * 公司 -- 控制器
 * @author lzh
 * @create 2017/4/21 10:03
 */
@RestController
@RequestMapping("/company")
public class CompanyController extends BaseController {

    @Resource
    private CompanyService companyService;



    /**
     * 删除公司
     * @param companyId
     */
    @RequestMapping("/delCompany")
    public ViewData delCompany(Integer companyId, HttpServletRequest request){
        if(null == companyId || companyId == 0){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        Company company = new Company();
        company.setId(companyId);
        company.setIsValid(0); // 无效
        User user = (User)LoginHelper.getCurrentUser();
        try {
            companyService.delCompany(company,request.getRemoteAddr(),user.getId());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 公司列表
     */
    @RequestMapping("/listForWeb")
    public ViewData listForWeb(){
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取公司列表成功", companyService.listForWeb());
        } catch (Exception e) {
            logger.error("获取公司列表失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"获取公司列表失败");
        }

    }


    /**
     *  添加公司
     * @param company
     */
    @RequestMapping("/addCompany")
    public ViewData addCompany(Company company){
        try {
            companyService.addCompany(company);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加公司成功");
        } catch (Exception e) {
            logger.error("添加公司失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"添加公司失败");
        }

    }

    /**
     * 更新公司
     * @param company
     */
    @RequestMapping("/updateCompany")
    public ViewData updateCompany(Company company){
        try {
            companyService.updateCompany(company);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新公司成功");
        } catch (Exception e) {
            logger.error("更新公司失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"更新公司失败");
        }

    }
}
