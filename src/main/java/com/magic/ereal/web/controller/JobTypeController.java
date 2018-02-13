package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.*;
import com.magic.ereal.business.enums.TransactionType;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.JobTypeService;
import com.magic.ereal.business.service.TransactionSubService;
import com.magic.ereal.business.service.UserService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import com.magic.ereal.web.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 工作类型 -- 控制器
 *
 * @author lzh
 * @create 2017/4/21 11:49
 */
@RestController
@RequestMapping("/jobType")
public class JobTypeController extends BaseController {


    @Resource
    private JobTypeService jobTypeService;
    @Resource
    private UserService userService;
    @Resource
    private TransactionSubService transactionSubService;

    /**
     * 分页查询 工作类型 （web）
     *
     * @param transaction  事务类型
     * @param departmentId 当事务类型为 临时类型时，字段必传
     * @param companyId    公司id
     * @param jobTypeName  工作名
     * @return 工作类型集合
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs, Integer transaction, Integer departmentId, Integer companyId, String jobTypeName) {
        try {
            PageList<JobType> pageList = jobTypeService.list(pageArgs, transaction, departmentId, companyId, jobTypeName);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE, "获取成功", pageList.getTotalSize(), pageList.getList());
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(), e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(), e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取工作类型列表失败", e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE, "服务器超时，获取工作类型列表失败");
        }
    }


    /**
     * 根据事务类型查询 工作类型 （web）(下拉列表)
     *
     * @param transaction  事务类型
     * @param departmentId 当事务类型为 临时类型时，字段必传
     * @param source       从什么地方传入 0 : 添加工作日志   1 ： 查询
     * @return 工作类型集合
     */
    @RequestMapping("/getJobTypeByTransactionForWeb")
    public ViewData getJobTypeByTransactionForWeb(Integer transaction, Integer departmentId, Integer source, Integer userId) {
        try {

            //添加工作日志 只能选择自己的部门
            if (source == 0) {
                User user = (User) LoginHelper.getCurrentUser();
                if (null != userId) {
                    user = userService.getUserById(userId);
                }
                if (null == user) {
                    return buildFailureJson(StatusConstant.USER_DOES_NOT_EXIST, "用户不存在");
                }
                userId = userId == null ? user.getId() : userId;
                Integer roleId = user.getRoleId();
                List<TransactionSub> data = transactionSubService.queryAllTransactionSub(userId, roleId);
                List<JobType> jobTypes = new ArrayList<>();

                for (TransactionSub sub : data) {
                    if (sub.getId().equals(transaction)) {
                        jobTypes.addAll(sub.getJobTypes());
                        break;
                    }
                }
                return buildSuccessJson(StatusConstant.SUCCESS_CODE, "获取成功",
                        jobTypes);
            }
            return buildSuccessJson(StatusConstant.SUCCESS_CODE, "获取成功",
                    jobTypeService.getJobTypeByTransactionForWeb(transaction, departmentId));
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(), e.getErrorCode());
            return buildFailureJsonPage(e.getErrorCode(), e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，获取工作类型列表失败", e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE, "服务器超时，获取工作类型列表失败");
        }
    }

    /**
     * 添加工作类型
     *
     * @param jobType
     */
    @RequestMapping("/addJobType")
    public ViewData addJobType(JobType jobType) {
        try {
            jobTypeService.addJobType(jobType);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE, "添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加失败", e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE, "服务器超时，添加失败");
        }
    }


    @RequestMapping("/queryJobType")
    public ViewData queryJobTypeById(Integer id) {
        if (null == id) {
            return buildFailureJson(StatusConstant.Fail_CODE, "字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                jobTypeService.queryJobTypeById(id));

    }

    /**
     * 根据ID 更新工作类型
     *
     * @param jobType
     * @return
     */
    @RequestMapping("/updateJobType")
    public ViewData updateJobType(JobType jobType) {

        try {
            jobTypeService.updateJobType(jobType);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE, "更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新失败", e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE, "服务器超时，更新失败");
        }
    }
}
