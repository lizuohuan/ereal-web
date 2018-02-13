package com.magic.ereal.web.controller;

import com.magic.ereal.business.entity.ProjectWeekAcceptance;
import com.magic.ereal.business.entity.ProjectWeekKAllocation;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.enums.RoleEnum;
import com.magic.ereal.business.exception.InterfaceCommonException;
import com.magic.ereal.business.service.ProjectWeekAcceptanceService;
import com.magic.ereal.business.service.ProjectWeekKAllocationService;
import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.util.CommonUtil;
import com.magic.ereal.web.util.ViewData;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 项目周验收报告后的 K值结果分配  -- 控制器
 * @author lzh
 * @create 2017/5/5 11:33
 */
@RestController
@RequestMapping("/projectWeekKAllocation")
public class ProjectWeekKAllocationController extends BaseController {


    @Resource
    private ProjectWeekKAllocationService projectWeekKAllocationService;
    @Resource
    private ProjectWeekAcceptanceService projectWeekAcceptanceService;

    /**
     * 分配周验收成果
     * @return
     */
    @RequestMapping("/save")
    public ViewData save(String projectWeekKAllocation,Integer weekId) {
        try {
            User user = (User) LoginHelper.getCurrentUser();

//            if (!user.getRoleId().equals(RoleEnum.PROJECT_MANAGER.ordinal())) {
//                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
//            }
            if (CommonUtil.isEmpty(projectWeekKAllocation) || CommonUtil.isEmpty(weekId)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            ProjectWeekAcceptance weekAcceptance = projectWeekAcceptanceService.queryProjectWeekAcceptanceById(weekId);
            if(null == weekAcceptance){
                return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"对象不存在");
            }

            // id:用户Id、ratio:分配的比例、k:阶段K值 sectionId:阶段ID
            JSONArray jsonArray = JSONArray.fromObject(projectWeekKAllocation);
            List<ProjectWeekKAllocation> allocations = new ArrayList<>();
            for (Object arr : jsonArray){
                ProjectWeekKAllocation allocation = new ProjectWeekKAllocation();
                JSONObject json = JSONObject.fromObject(arr);
                allocation.setCreateUserId(user.getId());
                allocation.setUserId(json.getInt("id"));
                allocation.setProjectTypeSectionId(json.getInt("sectionId"));
                allocation.setProjectWeekAcceptanceId(weekId);
                allocation.setRatio(json.getDouble("ratio"));
                allocation.setSectionSumK(weekAcceptance.getIsAdd() == 0 ? -json.getDouble("k") : json.getDouble("k"));
                allocations.add(allocation);
            }
            if(allocations.size() > 0){
                projectWeekKAllocationService.save(allocations,weekId);
            }
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"分配成功");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，分配失败");
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，分配失败");
        }
    }
}
