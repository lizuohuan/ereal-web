package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.entity.WorkDiary;
import com.magic.ereal.business.entity.WorkDiarySub;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.WorkDiaryService;
import com.magic.ereal.business.service.WorkDiaryStatusDetailService;
import com.magic.ereal.business.service.WorkDiarySubService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 传递卡 详情列 -- 控制器
 * @author lzh
 * @create 2017/4/24 14:13
 */
@RestController
@RequestMapping("/workDiarySub")
public class WorkDiarySubController extends BaseController {


    @Resource
    private WorkDiaryService workDiaryService;

    @Resource
    private WorkDiarySubService workDiarySubService;

    @Resource
    private WorkDiaryStatusDetailService workDiaryStatusDetailService;





    /**
     * @param workDiaryId
     * @return
     */
    @RequestMapping("/queryNewSub")
    public ViewData queryNewSub(Integer workDiaryId) {
        if (null == workDiaryId) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL, "字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE, "获取成功",
                workDiarySubService.queryNewSub(workDiaryId));
    }



    /**
     *  根据 传递卡  查询 传递卡的状态进度详情集合/通过 传递卡 查询 该传递卡下的详情数据
     * @param workDiaryId
     * @return
     */
    @RequestMapping("/queryWorkDiarySubByWorkDiary")
    public ViewData queryWorkDiarySubByWorkDiary(Integer workDiaryId) {
        try {
            if (null == workDiaryId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Map<String,Object> map = new HashMap<>();
            //通过 传递卡 查询 该传递卡下的详情数据
            map.put("workDiaryStatusDetail",workDiaryStatusDetailService.queryByWorkDiary(workDiaryId));
            //根据 传递卡  查询 传递卡的状态进度详情集合
            map.put("workDiarySub",workDiarySubService.queryWorkDiarySubByWorkDiary(workDiaryId));
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",map);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 新增单个 工作日志 详情
     * @param workDiarySub
     */
    @RequestMapping("/addWorkDiarySub")
    public ViewData addWorkDiarySub(WorkDiarySub workDiarySub){
        User user = (User) LoginHelper.getCurrentUser();
        try {
            WorkDiary workDiary = workDiaryService.queryWorkDiaryById(workDiarySub.getWorkDiaryId(),null);
            if (null == workDiary) {
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"数据错误");
            }
//            if (!(user.getId().equals(workDiary.getUserId()))) {
//                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"不是你的工作日志，您没有权限删除");
//            }
//            if (user.getIsManager() != 1) {
//                if (StatusConstant.WORKDIARY_STATUS_APPROVED.equals(workDiary.getStatus()) ||
//                        StatusConstant.WORKDIARY_SYNTHESIZE_STATUS_APPROVED.equals(workDiary.getStatus()) ) {
//                    return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"状态错误");
//                }
//            } else {
//                if (StatusConstant.WORKDIARY_SYNTHESIZE_STATUS_APPROVED.equals(workDiary.getStatus()) ) {
//                    return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"状态错误");
//                }
//            }
            if (null != workDiarySub.getProjectId()) {
                workDiarySub.setJobTypeId(workDiarySub.getProjectId());
            } else {
                if (null == workDiarySub.getJobTypeId()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"请选择工作类型");
                }
            }
            workDiarySubService.addWorkDiarySub(workDiarySub,workDiary.getWorkTime(),user.getId());
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 更新单个 工作日志 详情
     * @param workDiarySub
     */
    @RequestMapping("/batchUpdateWorkDiarySub")
    public ViewData batchUpdateWorkDiarySub(WorkDiarySub workDiarySub){
        try {
            User user = (User) LoginHelper.getCurrentUser();
            if (null == workDiarySub) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            } else {
                if (null == workDiarySub.getId()) {
                    return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
                }
            }
            WorkDiary workDiary = workDiaryService.queryWorkDiaryById(workDiarySub.getWorkDiaryId(),null);
            if (null == workDiary) {
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"数据错误");
            }
            if (user.getIsManager() != 1) {
                if (StatusConstant.WORKDIARY_STATUS_APPROVED.equals(workDiary.getStatus()) ||
                        StatusConstant.WORKDIARY_SYNTHESIZE_STATUS_APPROVED.equals(workDiary.getStatus()) ) {
                    return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"状态错误");
                }
            } else {
                if (StatusConstant.WORKDIARY_SYNTHESIZE_STATUS_APPROVED.equals(workDiary.getStatus()) ) {
                    return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"状态错误");
                }
            }
            workDiarySubService.batchUpdateWorkDiarySub(workDiarySub,workDiary.getWorkTime(),workDiary, (User) LoginHelper.getCurrentUser());
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }  catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 删除单个 工作日志 详情
     * @param id
     */
    @RequestMapping("/delWorkDiarySub")
    public ViewData delWorkDiarySub(Integer id){
        User user = (User) LoginHelper.getCurrentUser();
        try {
            if (null == id) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            WorkDiarySub workDiarySub = workDiarySubService.info(id);
            if (null == workDiarySub) {
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"数据错误");
            }
            WorkDiary workDiary = workDiaryService.queryWorkDiaryById(workDiarySub.getWorkDiaryId(),null);
            if (null == workDiary) {
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"数据错误");
            }
            if (!(user.getId().equals(workDiary.getUserId()))) {
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"不是你的工作日志，您没有权限删除");
            }
            if (StatusConstant.WORKDIARY_STATUS_APPROVED.equals(workDiary.getStatus()) ) {
                return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"已审核通过，不能删除");
            }
            workDiarySubService.delWorkDiarySub(id,workDiary.getId());
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"删除成功");
        } catch (Exception e) {
            logger.error("服务器超时，删除失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，删除失败");
        }
    }

    /**
     * 根据id查看详情
     * @param id
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",workDiarySubService.info(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 是否此时间段已存在
     * @param startTime
     * @param endTime
     * @param worKDiaryId
     * @return
     */
   /* @RequestMapping("/isHave")
    public ViewData isHave(Long startTime, Long endTime,Integer worKDiaryId ,Integer id){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",workDiarySubService.isHave(startTime,endTime,worKDiaryId,id));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }*/

}
