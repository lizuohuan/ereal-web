package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.WorkDiaryService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.DateUtil;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 传递卡 -- 控制器
 * @author lzh
 * @create 2017/4/21 14:36
 */
@RestController
@RequestMapping("/workDiary")
public class WorkDiaryController extends BaseController{

    @Resource
    private WorkDiaryService workDiaryService;


    /**
     * 统计 工时 详情
     * @param companyId
     * @param departmentId
     * @param time
     * @return
     */
    @RequestMapping("/queryWorkDiaryByTime")
    public ViewData queryWorkDiaryByTime(Integer companyId,Integer departmentId,Long time){

        if(null == companyId && null == departmentId){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        Date date = null == time ? new Date() : new Date(time);
        try {
            return  buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    workDiaryService.queryWorkDiaryByTime(companyId,departmentId,date));
        }catch (Exception e){
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    /**
     * 添加传递卡
     * @param workDiary 传递卡/工作日志 entity
     * @return
     */
    @RequestMapping("/addWorkDiary")
    public ViewData addWorkDiary(WorkDiary workDiary) {
        User user = (User)LoginHelper.getCurrentUser();
        try {
            workDiary.setUserId(user.getId());
           WorkDiary workDiary1 = workDiaryService.queryWorkDiaryByUser(user.getId(),workDiary.getWorkTime());
            if (null != workDiary1) {
                logger.error("此时间段已存在，不能添加");
                return buildSuccessCodeJson(StatusConstant.OBJECT_EXIST,"此时间段已存在，不能添加");
            }
            workDiaryService.addWorkDiary(workDiary);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加传递卡失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加传递卡失败");
        }
    }


    /**
     * 根据条件筛选 传递卡/工作日志 集合 web端
     * @param workDiary ：传递卡/工作日志 entity(
     *                  高级查询{
     *                      verifierName ：审核人名字
     *                      createTime ：创建时间
     *                      userName ：创建人名字
     *                      workTime ：工作日期
     *                      status ： 状态
     *                  } )
     * @param pageArgs ： 分页 entity
     * @param type 1：查看我的  2：我的团队  3: 查看其他团队
     * @return
     */
    @RequestMapping("/listForWeb")
    public ViewDataPage listForWeb(WorkDiary workDiary,PageArgs pageArgs,Integer type ,Integer departmentId,
                                   Integer companyId) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null != type ) {
                if (type == 3 && null == departmentId) {
                    return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
                if (type == 2) {
                    departmentId = user.getDepartmentId();
                }
            }
            workDiary.setUserId(user.getId());
            PageList<WorkDiary> pageList = workDiaryService.listForWeb(workDiary, pageArgs,type,departmentId,companyId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取传递卡列表失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取传递卡列表失败");
        }
    }

    /**
     *  更新传递卡 状态 更新第一次  如果更新前的状态为 拒绝后 再次更新的， 则不用此业务方法
     * @param workDiary 对象中 需包含 审核人的ID 和 用户ID 用于创建订单进度
     *                   更新时间字段
     *
     * @param notes 备注字段 可为空
     * @param userIds 审核通过 是 此字段必传 被抄送人id 以逗号隔开
     */
    @RequestMapping("/updateWorkDiaryStatus")
    public ViewData updateWorkDiaryStatus(WorkDiary workDiary,String notes,String userIds) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            WorkDiary workDiary1 = workDiaryService.queryWorkDiaryById(workDiary.getId(),null);
            workDiary1.setStatus(workDiary.getStatus());
            workDiaryService.updateWorkDiaryStatus(workDiary1, notes,user,userIds,user.getId());
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            return buildFailureJsonPage(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新传递卡信息失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，更新传递卡信息失败");
        }
    }

    /**
     *  更新传递卡
     * @param workDiary 对象中 需包含 审核人的ID 和 用户ID 用于创建订单进度
     *                   更新时间字段
     *
     */
    @RequestMapping("/update")
    public ViewData update(WorkDiary workDiary) {
        try {
            workDiaryService.update(workDiary);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新传递卡信息失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，更新传递卡信息失败");
        }
    }

    /**
     * 批量更新传递卡状态
     * @param ids 要更新的传递卡id 集合 可以为空
     * @param type 1：ids不能为空  更新传回来的ids集合  2:更新我的团队 3：综合部经理更新全部
     */
    @RequestMapping("/updateListStatus")
    public ViewData updateListStatus(String ids ,Integer type) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == type) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            workDiaryService.updateListStatus(ids,type ,user.getRoleId() ,user.getDepartmentId(),user.getId());
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新传递卡信息失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新传递卡信息失败");
        }
    }


    /**
     * 通过ID 查询所有信息
     * @param id
     * @return
     */
    @RequestMapping("/queryWorkDiaryById")
    public ViewData queryWorkDiaryById(Integer id) {
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == id) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",workDiaryService.queryWorkDiaryById(id,user));
        } catch (Exception e) {
            logger.error("服务器超时，获取传递卡列表失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取传递卡列表失败");
        }
    }

    /**
     * 统计日志 工作时长等
     *  userId、companyId、departmentId 不能同时存在 只能单选
     * @param userId 用户ID
     * @param companyId 分公司ID
     * @param departmentId 部门ID
     * @param time 时间 年月日 / 年月 当 flag:0 时，统计年月日 flag:1 统计 年月 不能为空
     * @param flag 当 flag:0 时，统计年月日 flag:1 统计 年月
     * @return
     */
    @RequestMapping("/countWorkDiary")
    public @ResponseBody ViewData countWorkDiary(Integer userId,Integer departmentId,Integer companyId,Integer flag,Long time){
        Object obj = LoginHelper.getCurrentUser();
        if(null == obj){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(!(obj instanceof User)){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        if(CommonUtil.isEmpty(flag)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null == userId && departmentId == null && null == companyId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(null == time || time == 0){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            Date date = null;
            if(flag == 0){
                date = DateUtil.dateFortimestamp(time,"yyyy-MM-dd",null);
            }
            if(flag == 1){
                date = DateUtil.dateFortimestamp(time,"yyyy-MM",null);
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    workDiaryService.countWorkDiary(userId,companyId,departmentId,flag,date));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"统计失败");
        }
    }

}
