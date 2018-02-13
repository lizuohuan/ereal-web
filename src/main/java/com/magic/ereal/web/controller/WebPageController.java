package com.magic.ereal.web.controller;

import com.magic.ereal.business.util.LoginHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * web页面访问控制器
 */
@Controller
@RequestMapping("/page")
public class WebPageController {

    /**父级页面模版*/
    @RequestMapping("/index")
    public String index() { return "web/index"; }

    /**主页*/
    @RequestMapping("/main")
    public String main() { return "web/main"; }

    /**404*/
    @RequestMapping("/error")
    public String error() { return "web/error"; }

    /**登录*/
    @RequestMapping("/login")
    public String login(HttpServletRequest request) {
        Object currentUser = LoginHelper.getCurrentUser();
        if(null != currentUser){
            return "web/index";
        }
        return "web/login";
    }

    /**角色管理--添加页面*/
    @RequestMapping("/role/add")
    public String roleAdd() { return "web/role/add"; }

    /**角色管理--列表页面*/
    @RequestMapping("/role/list")
    public String roleList() { return "web/role/list"; }

    /**角色管理--修改页面*/
    @RequestMapping("/role/edit")
    public String roleEdit() { return "web/role/edit"; }

    /**公司管理--添加页面*/
    @RequestMapping("/company/add")
    public String companyAdd() { return "web/company/add"; }

    /**公司管理--列表页面*/
    @RequestMapping("/company/list")
    public String companyList() { return "web/company/list"; }

    /**公司管理--修改页面*/
    @RequestMapping("/company/edit")
    public String companyEdit() { return "web/company/edit"; }

    /**部门管理--添加页面*/
    @RequestMapping("/department/add")
    public String departmentAdd() { return "web/department/add"; }

    /**部门管理--列表页面*/
    @RequestMapping("/department/list")
    public String departmentList() { return "web/department/list"; }

    /**部门管理--修改页面*/
    @RequestMapping("/department/edit")
    public String departmentEdit() { return "web/department/edit"; }

    /**用户管理--添加页面*/
    @RequestMapping("/user/add")
    public String userAdd() { return "web/user/add"; }

    /**用户管理--列表页面*/
    @RequestMapping("/user/list")
    public String userList() { return "web/user/list"; }

    /**用户管理--修改页面*/
    @RequestMapping("/user/edit")
    public String userEdit() { return "web/user/edit"; }

    /**用户管理--详情页面*/
    @RequestMapping("/user/detail")
    public String userDetail() { return "web/user/detail"; }

    /**用户管理--个人资料页面*/
    @RequestMapping("/user/personalDetail")
    public String personalDetail() { return "web/user/personalDetail"; }

    /**用户管理--多选角色列表页面*/
    @RequestMapping("/user/selectRole")
    public String selectRole() { return "web/user/selectRole"; }

    /**用户管理--修改密码页面*/
    @RequestMapping("/user/updatePassword")
    public String updatePassword() { return "web/user/updatePassword"; }

    /**用户回收站管理--列表页面*/
    @RequestMapping("/recycleBin/list")
    public String recycleBinList() { return "web/recycleBin/list"; }

    /**用户回收站管理--修改页面*/
    @RequestMapping("/recycleBin/edit")
    public String recycleBinEdit() { return "web/recycleBin/edit"; }

    /**传递卡管理--添加页面*/
    @RequestMapping("/workDiary/add")
    public String workDiaryAdd() { return "web/workDiary/add"; }

    /**传递卡管理--列表页面*/
    @RequestMapping("/workDiary/list")
    public String workDiaryList() { return "web/workDiary/list"; }

    /**传递卡管理--进度页面*/
    @RequestMapping("/workDiary/speed")
    public String workDiarySpeed() { return "web/workDiary/speed"; }

    /**传递卡管理--选择抄送人页面*/
    @RequestMapping("/workDiary/selectUser")
    public String selectUser() { return "web/workDiary/selectUser"; }

    /**传递卡子项管理--添加页面*/
    @RequestMapping("/workDiarySub/add")
    public String workDiarySubAdd() { return "web/workDiarySub/add"; }

    /**传递卡子项管理--列表页面*/
    @RequestMapping("/workDiarySub/list")
    public String workDiarySubList() { return "web/workDiarySub/list"; }

    /**传递卡子项管理--修改页面*/
    @RequestMapping("/workDiarySub/edit")
    public String workDiarySubEdit() { return "web/workDiarySub/edit"; }

    /**工作类型管理--添加页面*/
    @RequestMapping("/jobType/add")
    public String jobTypeAdd() { return "web/jobType/add"; }

    /**工作类型管理--列表页面*/
    @RequestMapping("/jobType/list")
    public String jobTypeList() { return "web/jobType/list"; }

    /**工作类型管理--修改页面*/
    @RequestMapping("/jobType/edit")
    public String jobTypeEdit(Integer id, Model model) {
        model.addAttribute("id",id);
        return "web/jobType/edit"; }

    /**事务类别管理--添加页面*/
    @RequestMapping("/transactionType/add")
    public String transactionTypeAdd() { return "web/transactionType/add"; }

    /**事务类别管理--列表页面*/
    @RequestMapping("/transactionType/list")
    public String transactionTypeList() { return "web/transactionType/list"; }

    /**事务类别管理--修改页面*/
    @RequestMapping("/transactionType/edit")
    public String transactionTypeEdit() { return "web/transactionType/edit"; }

    /**内部项目专业管理--添加页面*/
    @RequestMapping("/project/projectMajor/add")
    public String projectMajorAdd() { return "web/project/projectMajor/add"; }

    /**内部项目专业管理--列表页面*/
    @RequestMapping("/project/projectMajor/list")
    public String projectMajorList() { return "web/project/projectMajor/list"; }

    /**内部项目专业管理--修改页面*/
    @RequestMapping("/project/projectMajor/edit")
    public String projectMajorEdit() { return "web/project/projectMajor/edit"; }

    /**内部项目管理--添加页面*/
    @RequestMapping("/project/projectInterior/add")
    public String projectInteriorAdd() { return "web/project/projectInterior/add"; }

    /**内部项目管理--列表页面*/
    @RequestMapping("/project/projectInterior/list")
    public String projectInteriorList() { return "web/project/projectInterior/list"; }

    /**内部项目管理--修改页面*/
    @RequestMapping("/project/projectInterior/edit")
    public String projectInteriorEdit() { return "web/project/projectInterior/edit"; }

    /**内部项目管理--分配项目组页面*/
    @RequestMapping("/project/projectInterior/distribution")
    public String projectInteriorDistribution() { return "web/project/projectInterior/distribution"; }

    /**内部项目管理--权限转移页面*/
    @RequestMapping("/project/projectInterior/permissionToTransfer")
    public String projectInteriorPermissionToTransfer() { return "web/project/projectInterior/permissionToTransfer"; }

    /**内部项目管理--详情页面*/
    @RequestMapping("/project/projectInterior/detail")
    public String projectInteriorDetail() { return "web/project/projectInterior/detail"; }

    /**内部项目管理--周验收页面*/
    @RequestMapping("/project/projectInterior/weekAcceptance")
    public String projectInteriorWeekAcceptance() { return "web/project/projectInterior/weekAcceptance"; }

    /**内部项目管理--成员比例分配页面*/
    @RequestMapping("/project/projectInterior/distributionProportion")
    public String projectInteriorDistributionProportion() { return "web/project/projectInterior/distributionProportion"; }

    /**内部项目管理--批量审核页面*/
    @RequestMapping("/project/projectInterior/listC")
    public String projectInteriorListC() { return "web/project/projectInterior/listC"; }

    /**项目组管理--添加页面*/
    @RequestMapping("/project/projectGroup/add")
    public String projectGroupAdd() { return "web/project/projectGroup/add"; }

    /**项目组管理--列表页面*/
    @RequestMapping("/project/projectGroup/list")
    public String projectGroupList() { return "web/project/projectGroup/list"; }

    /**项目组管理--修改页面*/
    @RequestMapping("/project/projectGroup/edit")
    public String projectGroupEdit() { return "web/project/projectGroup/edit"; }

    /**项目组管理--选择组员页面*/
    @RequestMapping("/project/projectGroup/selectMember")
    public String selectMember() { return "web/project/projectGroup/selectMember"; }

    /**外部项目管理--添加页面*/
    @RequestMapping("/project/projectExternal/add")
    public String projectExternalAdd() { return "web/project/projectExternal/add"; }

    /**外部项目管理--列表页面*/
    @RequestMapping("/project/projectExternal/list")
    public String projectExternalList() { return "web/project/projectExternal/list"; }

    /**外部项目管理--修改页面*/
    @RequestMapping("/project/projectExternal/edit")
    public String projectExternalEdit() { return "web/project/projectExternal/edit"; }

    /**外部项目管理--分配项目组页面*/
    @RequestMapping("/project/projectExternal/distribution")
    public String projectExternalDistribution() { return "web/project/projectExternal/distribution"; }

    /**外部项目管理--权限转移页面*/
    @RequestMapping("/project/projectExternal/permissionToTransfer")
    public String projectExternalPermissionToTransfer() { return "web/project/projectExternal/permissionToTransfer"; }

    /**外部项目管理--项目分配页面*/
    @RequestMapping("/project/projectExternal/projectDistribution")
    public String projectExternalProjectDistribution() { return "web/project/projectExternal/projectDistribution"; }

    /**外部项目管理--项目分配页面*/
    @RequestMapping("/project/projectExternal/detail")
    public String projectExternalDetail() { return "web/project/projectExternal/detail"; }

    /**外部项目管理--周验收页面*/
    @RequestMapping("/project/projectExternal/weekAcceptance")
    public String projectExternalWeekAcceptance() { return "web/project/projectExternal/weekAcceptance"; }

    /**外部项目管理--周验列表页面*/
    @RequestMapping("/project/projectExternal/weekAcceptanceList")
    public String projectExternalWeekAcceptanceList() { return "web/project/projectExternal/weekAcceptanceList"; }

    /**外部项目管理--内部结项列表页面*/
    @RequestMapping("/project/projectExternal/insideKnotAcceptanceList")
    public String projectExternalInsideKnotAcceptanceList() { return "web/project/projectExternal/insideKnotAcceptanceList"; }

    /**外部项目管理--外部结项列表页面*/
    @RequestMapping("/project/projectExternal/externalKnotAcceptanceList")
    public String projectExternalExternalKnotAcceptanceList() { return "web/project/projectExternal/externalKnotAcceptanceList"; }

    /**外部项目管理--分配比例页面*/
    @RequestMapping("/project/projectExternal/distributionProportion")
    public String projectExternalDistributionProportion() { return "web/project/projectExternal/distributionProportion"; }

    /**外部项目管理--内部结项分配比例页面*/
    @RequestMapping("/project/projectExternal/distributionInsideKnot")
    public String projectExternalDistributionInsideKnot() { return "web/project/projectExternal/distributionInsideKnot"; }

    /**外部项目管理--外部结项分配比例页面*/
    @RequestMapping("/project/projectExternal/distributionExternalKnot")
    public String projectExternalDistributionExternalKnot() { return "web/project/projectExternal/distributionExternalKnot"; }

    /**外部项目管理--批量审核页面*/
    @RequestMapping("/project/projectExternal/listC")
    public String projectExternalListC() { return "web/project/projectExternal/listC"; }

    /**项目类型管理--添加页面*/
    @RequestMapping("/project/projectType/add")
    public String projectTypeAdd() { return "web/project/projectType/add"; }

    /**项目类型管理--列表页面*/
    @RequestMapping("/project/projectType/list")
    public String projectTypeList() { return "web/project/projectType/list"; }

    /**项目类型管理--修改页面*/
    @RequestMapping("/project/projectType/edit")
    public String projectTypeEdit() { return "web/project/projectType/edit"; }


    /**Banner管理--添加页面*/
    @RequestMapping("/companyBanner/add")
    public String companyBannerAdd() { return "web/companyBanner/add"; }

    /**Banner管理--列表页面*/
    @RequestMapping("/companyBanner/list")
    public String companyBannerList() { return "web/companyBanner/list"; }

    /**Banner管理--修改页面*/
    @RequestMapping("/companyBanner/edit")
    public String companyBannerEdit() { return "web/companyBanner/edit"; }

    /**Banner管理--添加页面*/
    @RequestMapping("/banner/add")
    public String bannerAdd() { return "web/banner/add"; }

    /**Banner管理--列表页面*/
    @RequestMapping("/banner/list")
    public String bannerList() { return "web/banner/list"; }

    /**Banner管理--修改页面*/
    @RequestMapping("/banner/edit")
    public String bannerEdit() { return "web/banner/edit"; }

    /**使用协议--修改页面*/
    @RequestMapping("/agreement/agreementEdit")
    public String agreementEdit() { return "web/agreement/agreementEdit"; }

    /**关于一真--修改页面*/
    @RequestMapping("/agreement/aboutEdit")
    public String aboutEdit() { return "web/agreement/aboutEdit"; }

    /**授权审批权限--编辑页面*/
    @RequestMapping("/accredit/edit")
    public String accreditEdit() { return "web/accredit/edit"; }

    /**授权审批权限--选择员工页面*/
    @RequestMapping("/accredit/selectUser")
    public String accreditUserList() { return "web/accredit/selectUser"; }

    /**三维管理--一维已发布的数据页面*/
    @RequestMapping("/kStatistics/oneDimension/dataList")
    public String oneDimensionDataList() { return "web/kStatistics/oneDimension/dataList"; }

    /**三维管理--一维列表页面*/
    @RequestMapping("/kStatistics/oneDimension/list")
    public String oneDimensionList() { return "web/kStatistics/oneDimension/list"; }

    /**三维管理--一维修改页面*/
    @RequestMapping("/kStatistics/oneDimension/edit")
    public String oneDimensionEdit() { return "web/kStatistics/oneDimension/edit"; }

    /**三维管理--二维已发布数据的页面*/
    @RequestMapping("/kStatistics/twoDimension/dataList")
    public String twoDimensionDataList() { return "web/kStatistics/twoDimension/dataList"; }

    /**三维管理--二维列表页面*/
    @RequestMapping("/kStatistics/twoDimension/list")
    public String twoDimensionList() { return "web/kStatistics/twoDimension/list"; }

    /**三维管理--二维修改页面*/
    @RequestMapping("/kStatistics/twoDimension/edit")
    public String twoDimensionEdit() { return "web/kStatistics/twoDimension/edit"; }

    /**三维管理--三维已发布数据的页面*/
    @RequestMapping("/kStatistics/threeDimension/dataList")
    public String threeDimensionDataList() { return "web/kStatistics/threeDimension/dataList"; }

    /**三维管理--三维列表页面*/
    @RequestMapping("/kStatistics/threeDimension/list")
    public String threeDimensionList() { return "web/kStatistics/threeDimension/list"; }

    /**三维管理--三维修改页面*/
    @RequestMapping("/kStatistics/threeDimension/edit")
    public String threeDimensionEdit() { return "web/kStatistics/threeDimension/edit"; }

    /**消息管理--推送消息页面*/
    @RequestMapping("/systemInfo/pushMessage")
    public String systemInfoPushMessage() { return "web/systemInfo/pushMessage"; }

    /**意见反馈页面*/
    @RequestMapping("/suggest/list")
    public String suggestList() { return "web/suggest/list"; }

    /**日志页面*/
    @RequestMapping("/log/list")
    public String logList() { return "web/log/list"; }

    /*********************************************************配置管理**************************************************/

    /**配置管理--第二维度配置页面*/
    @RequestMapping("/config/allConfig")
    public String allConfig() { return "web/config/allConfig"; }

    /**配置管理--第二维度配置页面*/
    @RequestMapping("/config/secondVeidooConfig")
    public String secondVeidooConfig() { return "web/config/secondVeidooConfig"; }

    /**配置管理--目标指标配置页面 --- 项目部*/
    @RequestMapping("/config/secondTarget/list")
    public String secondTargetConfig() { return "web/config/secondTarget/list"; }

    /**配置管理--目标指标配置页面 --- 职能部*/
    @RequestMapping("/config/secondTarget/list2")
    public String secondTargetTwoConfig() { return "web/config/secondTarget/list2"; }

    /**配置管理--添加目标指标配置页面*/
    @RequestMapping("/config/secondTarget/add")
    public String addSecondTargetConfig() { return "web/config/secondTarget/add"; }

    /**配置管理--修改目标指标配置页面*/
    @RequestMapping("/config/secondTarget/edit")
    public String editSecondTargetConfig() { return "web/config/secondTarget/edit"; }

    /**第二维评分--列表页面*/
    @RequestMapping("/config/twoScore/list")
    public String twoScoreList() { return "web/config/twoScore/list"; }

    /**第二维评分--添加页面*/
    @RequestMapping("/config/twoScore/add")
    public String twoScoreAdd() { return "web/config/twoScore/add"; }

    /**第二维评分--修改页面*/
    @RequestMapping("/config/twoScore/edit")
    public String twoScoreEdit() { return "web/config/twoScore/edit"; }

    /**配置管理--查询第三维配置页面*/
    @RequestMapping("/config/threeVeidoo/list")
    public String threeVeidooList() { return "web/config/threeVeidoo/list"; }

    /**配置管理--添加第三维配置页面*/
    @RequestMapping("/config/threeVeidoo/add")
    public String threeVeidooAdd() { return "web/config/threeVeidoo/add"; }

    /**配置管理--修改第三维配置页面*/
    @RequestMapping("/config/threeVeidoo/edit")
    public String threeVeidooEdit() { return "web/config/threeVeidoo/edit"; }

    /**配置管理--查询第三维评分配置页面*/
    @RequestMapping("/config/threeVeidooScore/list")
    public String threeVeidooScoreList() { return "web/config/threeVeidooScore/list"; }

    /**配置管理--添加第三维评分配置页面*/
    @RequestMapping("/config/threeVeidooScore/add")
    public String threeVeidooScoreAdd() { return "web/config/threeVeidooScore/add"; }

    /**配置管理--修改第三维评分配置页面*/
    @RequestMapping("/config/threeVeidooScore/edit")
    public String threeVeidooScoreEdit() { return "web/config/threeVeidooScore/edit"; }

    /**第三维KG打分--列表页面*/
    @RequestMapping("/config/threeVeidooKgScore/list")
    public String threeVeidooKgList() { return "web/config/threeVeidooKgScore/list"; }

    /**第三维KG打分--添加页面*/
    @RequestMapping("/config/threeVeidooKgScore/add")
    public String threeVeidooKgAdd() { return "web/config/threeVeidooKgScore/add"; }

    /**第三维KG打分--修改页面*/
    @RequestMapping("/config/threeVeidooKgScore/edit")
    public String threeVeidooKgEdit() { return "web/config/threeVeidooKgScore/edit"; }


    /**第三维KG打分--列表页面*/
    @RequestMapping("/config/threeVeidooKgScoreNoProject/list")
    public String threeVeidooKgScoreNoProject() { return "web/config/threeVeidooKgScoreNoProject/list"; }

    /**第三维KG打分--添加页面*/
    @RequestMapping("/config/threeVeidooKgScoreNoProject/add")
    public String threeVeidooKgScoreNoProjectAdd() { return "web/config/threeVeidooKgScoreNoProject/add"; }

    /**第三维KG打分--修改页面*/
    @RequestMapping("/config/threeVeidooKgScoreNoProject/edit")
    public String threeVeidooKgScoreNoProjectEdit() { return "web/config/threeVeidooKgScoreNoProject/edit"; }

    /**配置出勤天数--列表*/
    @RequestMapping("/config/monthDays/list")
    public String monthDaysList() { return "web/config/monthDays/list"; }

    /**配置出勤天数--添加*/
    @RequestMapping("/config/monthDays/add")
    public String monthDaysAdd() { return "web/config/monthDays/add"; }

    /**配置出勤天数--修改*/
    @RequestMapping("/config/monthDays/edit")
    public String monthDaysEdit() { return "web/config/monthDays/edit"; }

    /**员工本月的出勤情况--列表*/
    @RequestMapping("/config/monthDaysUser/list")
    public String monthDaysUserList() { return "web/config/monthDaysUser/list"; }

    /**员工本月的出勤情况--添加*/
    @RequestMapping("/config/monthDaysUser/add")
    public String monthDaysUserAdd() { return "web/config/monthDaysUser/add"; }

    /**员工本月的出勤情况--修改*/
    @RequestMapping("/config/monthDaysUser/edit")
    public String monthDaysUserEdit() { return "web/config/monthDaysUser/edit"; }

    /**员工请假情况--列表*/
    @RequestMapping("/config/monthDaysLeave/list")
    public String monthDaysLeaveList() { return "web/config/monthDaysLeave/list"; }

    /**员工请假情况--添加*/
    @RequestMapping("/config/monthDaysLeave/add")
    public String monthDaysLeaveAdd() { return "web/config/monthDaysLeave/add"; }

    /**员工请假情况--修改*/
    @RequestMapping("/config/monthDaysLeave/edit")
    public String monthDaysLeaveEdit() { return "web/config/monthDaysLeave/edit"; }

    /**权限管理--列表*/
    @RequestMapping("/jurisdiction/list")
    public String jurisdictionList() { return "web/jurisdiction/list"; }

    /**权限管理--添加*/
    @RequestMapping("/jurisdiction/add")
    public String jurisdictionAdd() { return "web/jurisdiction/add"; }

    /**权限管理--修改*/
    @RequestMapping("/jurisdiction/edit")
    public String jurisdictionEdit() { return "web/jurisdiction/edit"; }

    /**K常规比例分配--列表*/
    @RequestMapping("/config/kGeneralRatio/list")
    public String kGeneralRatioList() { return "web/config/kGeneralRatio/list"; }

    /**K常规比例分配--添加*/
    @RequestMapping("/config/kGeneralRatio/add")
    public String kGeneralRatioAdd() { return "web/config/kGeneralRatio/add"; }

    /**K常规比例分配--修改*/
    @RequestMapping("/config/kGeneralRatio/edit")
    public String kGeneralRatioEdit() { return "web/config/kGeneralRatio/edit"; }

    /*********************************************************荣誉时刻**************************************************/

    /**荣誉时刻--颁发自定义奖项*/
    @RequestMapping("/honorMoment/offerAwards/list")
    public String offerAwardsList() { return "web/honorMoment/offerAwards/list"; }

    /**荣誉时刻--颁发自定义奖项*/
    @RequestMapping("/honorMoment/offerAwards/add")
    public String offerAwardsAdd() { return "web/honorMoment/offerAwards/add"; }

    /**荣誉时刻--新增自定义奖项*/
    @RequestMapping("/honorMoment/customAwards/add")
    public String customAwardsAdd() { return "web/honorMoment/customAwards/add"; }

    /**荣誉时刻--自定义奖项*/
    @RequestMapping("/honorMoment/customAwards/list")
    public String customAwardsList() { return "web/honorMoment/customAwards/list"; }


    /**荣誉时刻--一真精神奖列表页面*/
    @RequestMapping("/honorMoment/spiritAwards/list")
    public String spiritAwardsList() { return "web/honorMoment/spiritAwards/list"; }

    /**荣誉时刻--一真精神奖发布页面*/
    @RequestMapping("/honorMoment/spiritAwards/add")
    public String spiritAwardsAdd() { return "web/honorMoment/spiritAwards/add"; }

    /**荣誉时刻--结项奖列表页面*/
    @RequestMapping("/honorMoment/projectAdwards/list")
    public String projectAdwardsList() { return "web/honorMoment/projectAdwards/list"; }

    /**荣誉时刻--结项奖发布页面*/
    @RequestMapping("/honorMoment/projectAdwards/add")
    public String projectAdwardsAdd() { return "web/honorMoment/projectAdwards/add"; }

    /**荣誉时刻--月度K王页面*/
    @RequestMapping("/honorMoment/kWang")
    public String kWang() { return "web/honorMoment/kWang"; }

    /**荣誉时刻--月度优秀团队页面*/
    @RequestMapping("/honorMoment/goodTeam")
    public String goodTeam() { return "web/honorMoment/goodTeam"; }


    /*********************************************************统计页面**************************************************/


    /**统计管理--工时统计页面*/
    @RequestMapping("/echars/workDiary/workingChart")
    public String workingChart() { return "web/echars/workDiary/workingChart"; }

    /**统计管理--破题统计页面*/
    @RequestMapping("/echars/theEssay/theEssayChart")
    public String theEssayChart() { return "web/echars/theEssay/theEssayChart"; }

    /**统计管理--个人K可比页面*/
    @RequestMapping("/echars/personKk/personKkChart")
    public String personKkChart() { return "web/echars/personKk/personKkChart"; }

    /**统计管理--个人工时页面*/
    @RequestMapping("/echars/personKk/personManHour")
    public String personManHour() { return "web/echars/personKk/personManHour"; }

    /**统计管理--三维统计--团队K总完成率页面*/
    @RequestMapping("/echars/threeDimensional/oneChart")
    public String oneChart() { return "web/echars/threeDimensional/oneChart"; }

    /**统计管理--三维统计--团队结项完成率页面*/
    @RequestMapping("/echars/threeDimensional/twoChart")
    public String twoChart() { return "web/echars/threeDimensional/twoChart"; }

    /**统计管理--三维统计--文化工程页面*/
    @RequestMapping("/echars/threeDimensional/threeChart")
    public String threeChart() { return "web/echars/threeDimensional/threeChart"; }

    /**统计管理--三维绩效考核得分页面*/
    @RequestMapping("/echars/check/checkChart")
    public String checkChart() { return "web/echars/check/checkChart"; }

    /**统计管理--三维绩效总汇表页面*/
    @RequestMapping("/echars/check/checkTable")
    public String checkTable() { return "web/echars/check/checkTable"; }

    /**统计管理--个人工作时间统计页面*/
    @RequestMapping("/echars/manHour/workChart")
    public String workChart() { return "web/echars/manHour/workChart"; }

    /**统计管理--个人学习时间统计页面*/
    @RequestMapping("/echars/manHour/studyChart")
    public String studyChart() { return "web/echars/manHour/studyChart"; }

    /**统计管理--个人运动时间统计页面*/
    @RequestMapping("/echars/manHour/exerciseChart")
    public String exerciseChart() { return "web/echars/manHour/exerciseChart"; }

    /**统计管理--个人工作学习总时间页面*/
    @RequestMapping("/echars/manHour/totalChart")
    public String totalChart() { return "web/echars/manHour/totalChart"; }


}
