package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.KStatisticsService;
import com.magic.ereal.business.service.ThreeVeidooService;
import com.magic.ereal.business.service.UsersStatisticsService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

/**
 * K 值统计 -- 控制器
 * @author lzh
 * @create 2017/5/17 15:53
 */
@RestController
@RequestMapping("/kStatistics")
public class KStatisticsController extends BaseController {

    @Resource
    private KStatisticsService kStatisticsService;
    @Resource
    private ThreeVeidooService threeVeidooService;
    @Resource
    private UsersStatisticsService usersStatisticsService;
    /**
     * 查询时间段的k值
     * @param time 时间
     * @param timeType 查询时间阶段类型 1:周 2：月 3：年
     * @return
     */
    @RequestMapping("/getByTimePersonage")
    public ViewData getByTimePersonage(Long time ,Integer timeType ,Integer userId) {
        try {
            if (null == timeType) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            User user = (User) LoginHelper.getCurrentUser();
            if (null == userId) {
                userId = user.getId();
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    kStatisticsService.getByTimePersonage(time , userId ,timeType  ,user));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取k统计失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取k统计失败");
        }
    }


    /**
     * 一维统计 web
     * @param time 时间
     * @param userId 用户id
     * @param departmentId 团队id
     * @param companyId 公司id
     * @param type 查询类型 0 :个人 1:部门 2：公司
     * @param groupType 分组类型  0 :个人 1:部门 2：公司
     * @return
     */
    @RequestMapping("/oneDimensional")
    public ViewDataPage oneDimensional(Long time ,Integer userId , Integer departmentId ,
                                       Integer companyId ,Integer type , Integer timeType,
                                       Integer groupType,PageArgs pageArgs) {
        try {
            if (null == timeType || null == type || null == groupType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PageList<OneStatistics> pageList = kStatisticsService.oneDimensional(time, userId, departmentId, companyId, type, timeType, groupType, pageArgs);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取一维列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取一维列表失败");
        }
    }

    /**
     * 一维统计 web 不分页
     * @param time 时间
     * @param userId 用户id
     * @param departmentId 团队id
     * @param companyId 公司id
     * @param type 查询类型 0 :个人 1:部门 2：公司
     * @param groupType 分组类型  0 :个人 1:部门 2：公司
     * @return
     */
    @RequestMapping("/oneDimensionalNOPage")
    public ViewData oneDimensionalNOPage(Long time ,Integer userId , Integer departmentId ,
                                       Integer companyId ,Integer type , Integer timeType,
                                       Integer groupType) {
        try {
            if (null == timeType || null == type || null == groupType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            if(groupType != 0 || type != 2){
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",kStatisticsService.oneDimensionalNOPage(time, userId, departmentId, companyId, type, timeType, groupType));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取一维列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取一维列表失败");
        }
    }





    /**
     *  获取已确认，待审核的数据
     * @param pageArgs 分页参数
     * @param companyId 公司ID
     * @param time 时间
     * @param timeType 时间类型  1: 周数据  2：月数据  3：年数据
     * @param veidooType 维度 类型 1：一维数据 2：二维数据 3：三维数据
     * @return
     */
    @RequestMapping("/queryPendingData")
    public ViewDataPage queryPendingData(PageArgs pageArgs,Integer companyId,Long time,Integer timeType,Integer veidooType ){
        if(null == time || CommonUtil.isEmpty(timeType,veidooType,companyId)){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            PageList<UsersStatistics> pendingVeidooPageList = usersStatisticsService.queryPendingData(companyId, time, timeType, veidooType, pageArgs.getPage() + 1, pageArgs.getPageSize());
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                    pendingVeidooPageList.getTotalSize(),pendingVeidooPageList.getList());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"获取失败");
        }
    }




    /**
     *  获取已确认，待审核的数据
     * @param companyId 公司ID
     * @param time 时间
     * @param timeType 时间类型  1: 周数据  2：月数据  3：年数据
     * @param veidooType 维度 类型 1：一维数据 2：二维数据 3：三维数据
     * @return
     */
    @RequestMapping("/queryPendingDataNoPage")
    public ViewData queryPendingData(Integer companyId,Long time,Integer timeType,Integer veidooType ){
        if(null == time || CommonUtil.isEmpty(timeType,veidooType,companyId)){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            List<UsersStatistics> data = usersStatisticsService.queryPendingDataNoPage(companyId, time, timeType, veidooType);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    data);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    /**
     *  获取已确认，待审核的数据
     * @param companyId 公司ID
     * @param time 时间
     * @param timeType 时间类型  1: 周数据  2：月数据  3：年数据
     * @return
     */
    @RequestMapping("/excel/downLoadPendingData")
    public void downLoadPendingData(Integer companyId, Long time, Integer timeType , HttpServletResponse response){
        if(null == time || CommonUtil.isEmpty(timeType,companyId)){
            return ;
        }
        try {
            List<UsersStatistics> data = usersStatisticsService.queryPendingDataNoPage(companyId, time, timeType, 1);
            usersStatisticsService.downLoadVeidooData(data,response);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
        }
    }


    /**
     * 修改 三维数据
     * @param usersStatistics
     * @return
     */
    @RequestMapping("/updateUserStatistics")
    public ViewData updateUserStatistics(UsersStatistics usersStatistics){
        if(CommonUtil.isEmpty(usersStatistics.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            usersStatisticsService.updateUsersStatistics(usersStatistics);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"修改成功");
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"修改失败");
        }
    }










    /**
     * 二维统计 web
     * @param time 时间
     * @param userId 用户id
     * @param departmentId 团队id
     * @param companyId 公司id
     * @param type 查询类型 0 :个人 1:部门 2：公司
     * @param groupType 分组类型  0 :个人 1:部门 2：公司
     * @return
     */
    @RequestMapping("/towListForWeb")
    public ViewDataPage towListForWeb(Long time ,Integer userId , Integer departmentId ,
                                       Integer companyId ,Integer type , Integer timeType,
                                       Integer groupType,PageArgs pageArgs) {
        try {
            if (null == timeType || null == type || null == groupType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            departmentId = null == departmentId ? ((User)LoginHelper.getCurrentUser()).getDepartmentId() :departmentId;
            PageList<TwoStatistics> pageList = kStatisticsService.towListForWeb(time, userId, departmentId, companyId, type, timeType, groupType, pageArgs);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取列表失败");
        }
    }


    /**
     * 二维统计 web
     * @param time 时间
     * @param userId 用户id
     * @param departmentId 团队id
     * @param companyId 公司id
     * @param type 查询类型 0 :个人 1:部门 2：公司
     * @param groupType 分组类型  0 :个人 1:部门 2：公司
     * @return
     */
    @RequestMapping("/towListForWebNoPage")
    public ViewData towListForWebNoPage(Long time ,Integer userId , Integer departmentId ,
                                       Integer companyId ,Integer type , Integer timeType,
                                       Integer groupType) {
        try {
            if (null == timeType || null == type || null == groupType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            departmentId = null == departmentId ? ((User)LoginHelper.getCurrentUser()).getDepartmentId() :departmentId;
            List<TwoStatistics> pageList = kStatisticsService.towListForWebNoPage(time, userId, departmentId, companyId, type, timeType, groupType);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",pageList);
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取一维列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取一维列表失败");
        }
    }

    /**
     * 三维统计 web
     * @param time 时间
     * @param type 查询类型 0 :个人 1:部门 2：公司
     * @return
     */
    @RequestMapping("/threeListForWeb")
    public ViewDataPage threeListForWeb(Long time ,User user,Integer type , Integer timeType ,Integer groupType
                                       ,PageArgs pageArgs) {
        try {
            if (null == timeType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PageList<ThreeVeidooTemp> pageList = threeVeidooService.threeListForWeb(time, type, timeType,user, pageArgs ,groupType);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取一维列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取一维列表失败");
        }
    }


    /**
     * 三维统计 web
     * @param time 时间
     * @param type 查询类型 0 :个人 1:部门 2：公司
     * @return
     */
    @RequestMapping("/threeListForWebNoPage")
    public ViewData threeListForWebNoPage(Long time ,User user,Integer type , Integer timeType ,Integer groupType) {
        try {
            if (null == timeType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            List<ThreeVeidooTemp> pageList = threeVeidooService.threeListForWebNoPage(time, type, timeType,user ,groupType);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",pageList);
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取一维列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取一维列表失败");
        }
    }



    /**
     * 发布 一维 二维 三维 分开发布 单条 发布
     * @param usersStatistics 实体
     * @param time 时间
     * @param timeType 时间类型 1：周  2：月
     * @param tieUpType 发布类型 1：一维 2：二维 3：三维
     * @param usersStatisticsThree 发布第三维时  不能为空 UsersStatisticsThree json
     * @throws ParseException
     */
    @RequestMapping("/save")
    public ViewData save(UsersStatistics usersStatistics,Long time ,Integer timeType ,Integer tieUpType ,String usersStatisticsThree) {
        try {
            if (null == timeType || null == tieUpType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            usersStatisticsService.save(usersStatistics, time, timeType, tieUpType, usersStatisticsThree);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"发布成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，发布失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，发布失败");
        }
    }

    /**
     * 发布 一维 二维 三维 分开发布 多条 发布
     * @param usersStatistics 实体
     * @param time 时间
     * @param companyId 公司id
     * @param timeType 时间类型 1：周  2：月
     * @param tieUpType 发布类型 1：一维 2：二维 3：三维
     * @param usersStatisticsThree 发布第三维时  不能为空 UsersStatisticsThree json
     * @throws ParseException
     */
    @RequestMapping("/saveList")
    public ViewData saveList(String usersStatistics,Long time ,Integer timeType ,Integer tieUpType ,String usersStatisticsThree,Integer companyId) {
        try {
            if (null == timeType || null == tieUpType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            usersStatisticsService.saveList(usersStatistics, time, timeType, tieUpType, usersStatisticsThree,companyId);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"发布成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，发布失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，发布失败");
        }
    }

    /**
     * 数据公示 三维绩效考核得分 统计
     * @param time 时间
     * @param timeType 1：周 2：月
     * @param companyId 公司id
     * @return
     */
    @RequestMapping("/getCompanySta")
    public ViewData getCompanySta(Long time ,Integer timeType,Integer companyId) {
        try {
            if (null == timeType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            User user = (User) LoginHelper.getCurrentUser();
            if (null == companyId) {
                companyId = user.getCompanyId();
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",usersStatisticsService.getCompanySta( time, timeType, companyId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 三维绩效总汇表
     * @param time 时间
     * @param timeType 1：周 2：月
     * @param companyId 公司id
     * @return
     */
    @RequestMapping("/getTotalAchievements")
    public ViewData getTotalAchievements(Long time ,Integer timeType,Integer companyId) {
        try {
            if (null == timeType) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            User user = (User) LoginHelper.getCurrentUser();
            if (null == companyId) {
                companyId = user.getCompanyId();
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",usersStatisticsService.getTotalAchievements( time, timeType, companyId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



}
