package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.service.*;
import com.magic.ereal.business.util.DateTimeHelper;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 后台统计 接口
 * Created by Eric Xie on 2017/6/6 0006.
 */
@RequestMapping("/statistics")
@Controller
public class StatisticsController extends BaseController {


    @Resource
    private DepartmentService departmentService;
    @Resource
    private StatisticsService statisticsService;
    @Resource
    private KStatisticsService kStatisticsService;
    @Resource
    private UserService userService;
    @Resource
    private UsersStatisticsService usersStatisticsService;




    /**
     * 后台 工时统计
     * @param companyId 分公司ID
     * @param departmentId 部门ID
     * @param type 0:个人工作时间统计  1:个人学习时间统计 2:个人运动时间统计  3:个人工作学习总时间
     */
    @RequestMapping("/statisticsWorkTime")
    public @ResponseBody ViewData statisticsWorkTime(Integer companyId,Integer departmentId,Integer type,
                                                     Long start,Long end){
        if(CommonUtil.isEmpty(type)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Date startTime = null == start ? null : new Date(start);
        Date endTime = null == end ? null : new Date(end);
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                usersStatisticsService.statisticsWorkTime(companyId,departmentId,type,startTime,endTime));
    }


    /**
     * 后台统计第三维  文化工程
     * companyId、departmentId、userId 三者传一
     * @param type 0：统计团队文化工程得分   1：团队文化工程完成率  2：个人文化工程得分  3： 团队K总完成率 4：团队结项完成率
     * @param date 日期
     * @param dateType 0：周统计   1：月统计
     * @param companyId 公司ID
     * @param departmentId 部门ID
     * @param userId  用户ID
     * @return
     */
    @RequestMapping("/queryKCulture")
    public @ResponseBody ViewData queryKCulture(Integer companyId,Integer departmentId,Integer userId,
                                  Integer type,Date date,Integer dateType,Integer ccId) throws ParseException {

        if(CommonUtil.isEmpty(type,dateType) || null == date){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                usersStatisticsService.queryKCulture(type,date,dateType,companyId,departmentId,userId,ccId));

    }


    /**
     * 后台个人K可比 统计
     * @param time 日期时间戳
     * @param userId 用户ID
     * @param departmentId  部门ID
     * @param companyId 分公司ID
     * @param timeType 1：周统计   2：月统计
     */
    @RequestMapping("/personKk")
    public  @ResponseBody ViewData personKk(Long time , Integer userId , Integer departmentId ,
                      Integer companyId , Integer timeType){

        if(null == time || null == timeType ){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null == userId && null == departmentId && null == companyId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    kStatisticsService.personKk(time, userId, departmentId, companyId, timeType));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"统计失败");
        }

    }


    /**
     * 首页统计 K值
     * @return
     */
    @RequestMapping("/homeKStatistics")
    @ResponseBody
    public ViewData homeKStatistics() throws ParseException {
        User user = (User) LoginHelper.getCurrentUser();
        if (null == user ) {
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(null == user.getCompanyId()){
            // 查询用户的分公司ID
            Department info = departmentService.info(user.getDepartmentId());
            user.setCompanyId(info.getCompanyId());
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,
                "获取成功",statisticsService.statisticsHomeK(user, new Date()));
    }




    /**
     * 统计月度 优秀团队
     * @return
     */
    @RequestMapping("/statisticsGoodTeam")
    @ResponseBody
    public ViewData statisticsGoodTeam(Date month,Integer companyId) throws ParseException {
        companyId = null == companyId ? ((User)(LoginHelper.getCurrentUser())).getCompanyId() : companyId;
        List<TotalAchievements> achievements = usersStatisticsService.getTotalAchievements(null == month ? System.currentTimeMillis() : month.getTime(),
                2, companyId);
        List<GoodTeam> teamList = new ArrayList<>();
        if(null != achievements && achievements.size() > 0){
            for (TotalAchievements achievement : achievements) {
                if(achievement.getTotalScore() >= 100){
                    GoodTeam goodTeam = new GoodTeam();
                    goodTeam.setDepartmentName(achievement.getDepartmentName());
                    goodTeam.setMonth(month);
                    goodTeam.setDepartmentId(achievement.getDepartmentId());
                    goodTeam.setScore(achievement.getTotalScore());
                    goodTeam.setRanking(achievement.getRanking());
                    teamList.add(goodTeam);
                }
            }
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,
                "获取成功",teamList);
    }

    /**
     * 统计月度K王
     * @return
     */
    @RequestMapping("/staticsMaxK")
    public @ResponseBody ViewData staticsMaxK(Date month){
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
        if(null == user.getCompanyId()){
            Department info = departmentService.info(user.getDepartmentId());
            user.setCompanyId(info.getCompanyId());
        }
        List<User> data = null;
        try {
            data = userService.staticsMaxK(user.getCompanyId(), month == null ? new Date() : month);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",data);
    }






    /**
     * 统计月度 结项奖
     * @return
     */
    @RequestMapping("/statisesProjectAdwards")
    @ResponseBody
    public ViewData statisesProjectAdwards(Long time,Integer companyId) throws ParseException {
        if(null == time){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        companyId = null == companyId ? ((User)(LoginHelper.getCurrentUser())).getCompanyId() : companyId;
        try {
            List<ProjectAdwards> data  = departmentService.statisesProjectAdwards(companyId, time);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,
                    "获取成功", data);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }















}
