package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.Banner;
import com.magic.ereal.business.entity.PageArgs;
import com.magic.ereal.business.entity.PageList;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.BannerService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import net.sf.json.JSONArray;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * banner消息 -- 控制器
 * @author lzh
 * @create 2017/5/24 16:58
 */
@RestController
@RequestMapping("/banner")
public class BannerController extends BaseController {


    @Resource
    private BannerService bannerService;





    /**
     * 添加banner
     * @param banner
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(Banner banner) {
        try {
            if(null != banner.getType() && banner.getType() == 3){
                // 如果设置的是 生日消息banner
                // 只能设置一张
                List<Banner> banners = bannerService.queryBannerByType(banner.getType());
                if(null != banners && banners.size() > 1){
                    return buildFailureJson(StatusConstant.Fail_CODE,"生日消息只能设置一条数据");
                }
            }
            if(banner.getType() != 2){
                banner.setImgUrl(banner.getImgUrl().replaceAll(",",""));
            }
            List<Integer> ids = new ArrayList<>();
            if(banner.getType() == 2){
                // 如果是三维 数据banner 必须传 三维数据ID集合列表
                if(CommonUtil.isEmpty(banner.getUserStatisticsIds())){
                    return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
                }
                String[] split = banner.getUserStatisticsIds().split(",");
                for (String o : split) {
                    ids.add(Integer.parseInt(o));
                }
            }

            User user = (User) LoginHelper.getCurrentUser();
            banner.setCreateUserId(user.getId());
            bannerService.save(banner,ids);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加banner失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，添加banner失败");
        }
    }

    /**
     * 更新banner
     * @param banner
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(Banner banner) {
        try {
            if (null == banner) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == banner.getId()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
            if(null != banner.getType() && banner.getType() == 3){
                // 如果设置的是 生日消息banner
                // 只能设置一张
                List<Banner> banners = bannerService.queryBannerByType(banner.getType());
                if(!banners.get(0).getId().equals(banner.getId())){
                    if(banners.size() > 1){
                        return buildFailureJson(StatusConstant.Fail_CODE,"生日消息只能设置一条数据");
                    }
                }
            }
            bannerService.update(banner);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新banner成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新banner信息失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新banner信息失败");
        }
    }


    /**
     * 三维审核 更改状态
     * @param status
     * @param id
     * @return
     */
    @RequestMapping("/updateStatus")
    public ViewData updateStatus(Integer status ,Integer id) {
        try {
            if (null == status || null == id) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            User user = (User) LoginHelper.getCurrentUser();
            Banner banner = new Banner();
            banner.setId(id);
            banner.setStatus(status);
            banner.setAuditUserId(user.getId());
            bannerService.update(banner);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新banner信息失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新banner信息失败");
        }
    }


    /**
     * 更新banner 所有字段
     * @param banner
     * @return
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(Banner banner) {
        try {
            if (null == banner) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == banner.getId()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
            bannerService.updateAll(banner);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新banner成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新banner信息失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新banner信息失败");
        }
    }

    /**
     * 详情
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id) {
        try {
            if (null == id) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",bannerService.info(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取banner详情失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取banner详情失败");
        }
    }

    /**
     * web端banner列表
     * @param banner 实体 name isShow title 查询条件
     * @param pageArgs 分页实体
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(Banner banner , PageArgs pageArgs) {
        try {
            PageList<Banner> pageList = bannerService.list(banner, pageArgs);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取banner详情失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取banner列表失败");
        }
    }
}
