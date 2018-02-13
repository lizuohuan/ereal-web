<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>外部项目详情</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/speed.css">

    <style>
        .padding-top{padding-top: 10px}
        .layui-bg-orange{color: #fff;}
        .acceptanceMan{padding: 15px;padding-left: 20%;font-size: 18px;font-weight: bold;}
        .noDistribution{color: #4CAF50}
        .intro-list-content p{margin-bottom: 10px;}

        .project-context{
            padding: 15px;
            padding-left: 120px;;
            position: relative;
            font-size: 14px;
        }
        .groupName{
            background: #4BC792;
            width: 80px;
            height: 80px;
            line-height: 80px;
            border-radius: 50%;
            text-align: center;
            font-size: 30px;
            color: #fff;
            font-weight: bold;
            position: absolute;
            left: 15px;
        }
        .project-title{
            font-size: 20px;
            font-weight: bold;
        }
        .project-context p{
            margin-bottom: 10px;
        }
        .basicInfo{
            display: none;
        }

    </style>
</head>
<body ng-app="webApp" ng-controller="projectExternalCtr" ng-cloak>
<div class="admin-main">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;外部项目详情&nbsp;&nbsp;&nbsp;
        <%--<a href="javascript:history.go(-1)" class="layui-btn layui-btn-primary layui-btn-small">返回</a>--%>
    </blockquote>
    <div class="layui-field-box layui-form">

        <fieldset class="layui-elem-field">
            <legend>外部项目详情</legend>
            <div class="layui-field-box">
                <div class="project-context">
                    <span class="groupName">{{projectExternalInfo.projectName | limitTo:1}} </span>
                    <p class="project-title">{{projectExternalInfo.projectName}}</p>
                    <p>{{projectExternalInfo.projectNameShort}}</p>
                    <p>项目经理：{{projectExternalInfo.projectManager}}</p>
                    <p>项目类型：{{projectExternalInfo.projectTypeName}}</p>
                    <p>A导师：{{projectExternalInfo.ateacherName}}　　　B导师：{{projectExternalInfo.bTeacherName}}　　　C导师：{{projectExternalInfo.cTeacherName}}</p>
                    <p>已用时：{{projectExternalInfo.useTime | number:2}}h　　　项目效率：
                        <span ng-if="projectExternalInfo.efficiency == null || projectExternalInfo.efficiency == ''">0</span>
                        <span ng-if="projectExternalInfo.efficiency != null && projectExternalInfo.efficiency != ''">{{projectExternalInfo.efficiency | number:2}}</span>
                    </p>
                    <p>破题状态：
                        <span ng-show="{{projectExternalInfo.status == 5000}}">未破</span>
                        <span ng-show="{{projectExternalInfo.status == 5001}}">破题审核中</span>
                        <span ng-show="{{projectExternalInfo.status == 5002}}">半破</span>
                        <span ng-show="{{projectExternalInfo.status == 5003}}">破题审核中</span>
                        <span ng-show="{{projectExternalInfo.status >= 5004}}">破</span>
                        　　<button ng-show="(projectExternalInfo.status == 5000 || projectExternalInfo.status == 5002) && userInfo.id == projectExternalInfo.aTeacher" ng-click="applyEssay()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_137">申请破题</button>
                        　　<button ng-show="(projectExternalInfo.status == 5001 || projectExternalInfo.status == 5003) && isTrue " ng-click="verification()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_138">破题验收</button>
                    </p>
                    <p>总值分配情况：<span style="color: #4CAF50">当前总K值 {{totalUserK | number:2}}K</span></p>
                    <button ng-if="!isShowInfo" class="layui-btn layui-btn-radius layui-btn-small" ng-click="basicInfoShow()">查看项目基本信息</button>
                    <button ng-if="isShowInfo" class="layui-btn layui-btn-radius layui-btn-small" ng-click="basicInfoHide()">收起</button>
                </div>
            </div>
        </fieldset>

        <fieldset class="layui-elem-field">
            <legend>成员比例情况</legend>
            <div class="layui-field-box" id="userKsList">

            </div>
        </fieldset>

        <fieldset class="layui-elem-field basicInfo">
            <legend>外部项目基本信息</legend>
            <div class="layui-field-box">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">项目编号</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.projectNumber}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目名称</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.projectName}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目简称</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.projectNameShort}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">项目类型</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.projectTypeName}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">客户单位名称</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.customerUnit}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">客户专业部门名称</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.customerDepartment}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">承接时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectExternalInfo.receiveTime | date:'yyyy-MM-dd'}}
                            </div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目启动书提交时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectExternalInfo.submitTime | date:'yyyy-MM-dd'}}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">内部结项时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectExternalInfo.overTime | date:'yyyy-MM-dd HH:mm:ss'}}
                            </div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">外部结项时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectExternalInfo.exteriorOverTime | date:'yyyy-MM-dd HH:mm:ss'}}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">破题时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectExternalInfo.poAllTime | date:'yyyy-MM-dd HH:mm:ss'}}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-block">
                        <label class="layui-form-label">客户定位</label>
                        <div class="layui-input-block">
                            <div class="layui-input" >{{projectExternalInfo.customerRemarks}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-block">
                        <label class="layui-form-label">风险说明</label>
                        <div class="layui-input-block">
                            <div class="layui-input" >{{projectExternalInfo.riskRemarks}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-block">
                        <label class="layui-form-label">其他市场信息备注</label>
                        <div class="layui-input-block">
                            <div class="layui-input" >{{projectExternalInfo.otherRemarks}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">初始工作量</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectExternalInfo.initWorkload}} 天</div>
                        </div>
                    </div>

                </div>
            </div>
        </fieldset>


    </div>

    <blockquote class="layui-elem-quote">项目进展状态显示&nbsp;&nbsp;&nbsp;
    </blockquote>
    <div style="margin: 15px;">
        <div class="intro-flow">
            <div class="intro-list" ng-show="acceptanceList.length == 0">
                <div class="intro-list-left">
                    周验收
                </div>
                <div class="intro-list-right">
                    <span>1</span>
                    <div class="intro-list-content">
                        <button ng-click="applyWeekAcceptance()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_95">申请周验收</button>
                    </div>
                </div>
            </div>
            <div ng-show="acceptanceList.length != 0">
                <div class="intro-list" ng-repeat="acceptance in acceptanceList">
                    <div class="intro-list-left">
                        <span ng-if="acceptance.type == 1">内部结项验收</span>
                        <span ng-if="acceptance.type == 2">外部结项验收</span>
                        <span ng-if="acceptance.type == 3">周验收</span>
                    </div>
                    <div class="intro-list-right">
                        <span>{{ acceptanceList.length - $index }}</span>
                        <div class="intro-list-content">
                            <!-- 周验收情况 -->
                            <div ng-if="acceptance.type == 3">
                                <p>进度已完成：
                                    {{acceptance.score * 100 | number:0}}%
                                    <span class="noDistribution" ng-if="acceptance.status == 0">　　　待验收</span>
                                    <span class="noDistribution" ng-if="acceptance.status == 1">　　　待分配</span>
                                </p>
                                <p>
                                    <button ng-click="weekAcceptanceList(acceptance.objectId)" class="layui-btn layui-btn-radius layui-btn-normal layui-btn-small hide checkBtn_92">查看验收详情</button>
                                    <button ng-show="userInfo.id == projectExternalInfo.aTeacher && acceptance.status == 2 && acceptanceList.length == 1" ng-click="applyWeekAcceptance()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_95">申请周验收</button>
                                    <button ng-show="userInfo.id == projectExternalInfo.bTeacherId && acceptance.status == 0" ng-click="weekAcceptance(acceptance.objectId)" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_96">进行周验收</button>
                                    <%--<button ng-show="acceptance.status == 1" ng-click="distribution(acceptance.objectId)" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm">成员分配比例</button>--%>
                                    <button ng-show="userInfo.id == projectExternalInfo.aTeacher && acceptanceList.length == 1 && projectExternalInfo.status >= 5004" ng-click="applyInsideKnot()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_97">申请内部结项</button>
                                </p>
                            </div>
                            <!-- 内部结项验收 -->
                            <div ng-if="acceptance.type == 1">
                                <p>当前打分数：
                                    {{acceptance.score | number : 2}}分
                                    <span class="noDistribution" ng-if="acceptance.status == 10">　　　待验收</span>
                                    <span class="noDistribution" ng-if="acceptance.status == 11 && userInfo.id != projectExternalInfo.cTeacherId">　　　等待C导师进行打分</span>
                                    <span class="noDistribution" ng-if="acceptance.status == 13 || acceptance.status == 12">　　　待分配</span>
                                </p>
                                <button ng-click="insideKnotAcceptanceList()" class="layui-btn layui-btn-radius layui-btn-normal layui-btn-small hide checkBtn_93">查看验收详情</button>
                                <button ng-show="userInfo.id == projectExternalInfo.bTeacherId && acceptance.status == 10" ng-click="insideKnotAcceptance()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_98">进行内部结项验收</button>
                                <button ng-show="userInfo.id == projectExternalInfo.cTeacherId && acceptance.status == 11 && acceptance.score >= 70" ng-click="adoptInsideKnot()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_99">通过内部结项</button>
                                <button ng-show="userInfo.id == projectExternalInfo.cTeacherId && acceptance.status == 11" ng-click="insideKnotAcceptanceCheck()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm">C导师进行打分</button>
                                <button ng-show="userInfo.id == projectExternalInfo.aTeacher && acceptance.status == 3 && acceptance.score < 70" ng-click="applyInsideKnot()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_97">申请内部结项</button>
                                <button ng-show="userInfo.id == projectExternalInfo.aTeacher && acceptance.status == 3 && acceptanceList.length == 2 && acceptance.score >= 70" ng-click="applyExternalKnot()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_101">申请外部结项</button>
                                <button ng-show="acceptance.status == 3 && acceptance.score >= 70" class="layui-btn layui-btn-disabled layui-btn-radius layui-btn-small">内部结项已完结</button>
                            </div>
                            <!-- 外部结项验收 -->
                            <div ng-if="acceptance.type == 2">
                                <p>当前打分数：
                                    {{acceptance.score}}分
                                    <span class="noDistribution" ng-if="acceptance.status == 0">　　　待验收</span>
                                    <span class="noDistribution" ng-if="acceptance.status == 1 || acceptance.status == 2">　　　待分配</span>
                                </p>
                                <button ng-click="externalKnotAcceptanceList()" class="layui-btn layui-btn-radius layui-btn-normal layui-btn-small hide checkBtn_94">查看验收详情</button>
                                <button ng-show="userInfo.roleId == 13 && acceptance.status == 0" ng-click="externalKnotAcceptance()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_102">进行外部结项验收</button>
                                <button ng-show="userInfo.id == projectExternalInfo.aTeacher && acceptance.status == 3 && projectExternalInfo.status != 5008" ng-click="applyExternalKnot()" class="layui-btn layui-btn-radius layui-btn-small layui-btn-warm hide checkBtn_101">申请外部结项</button>
                                <button ng-show="projectExternalInfo.status == 5008" class="layui-btn layui-btn-disabled layui-btn-radius layui-btn-small">外部结项已完结</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- 破题验收弹窗用的HTML -->
<div id="verificationHtml">

</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>

    var form = null;

    var webApp=angular.module('webApp',[]);
    webApp.controller("projectExternalCtr", function($scope,$http,$timeout){
        $scope.projectExternalId = YZ.getUrlParam("projectExternalId");
        $scope.userInfo = YZ.getUserInfo();
        $scope.projectExternalInfo = null;
        $scope.isShowInfo = false; //显示/隐藏基本信息
        $scope.acceptanceList = null; // 项目进展状态显示
        $scope.lastAcceptancesExternal = null; //存放上一次周验收、内部结项验收、外部结项验收
        YZ.ajaxRequestData("get", false, YZ.ip + "/project/info", {id : $scope.projectExternalId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.projectExternalInfo = result.data;
                localStorage.setItem("bTeacherName", $scope.projectExternalInfo.bTeacherName);// 周验收、内部结项验收人
                localStorage.setItem("commissionerName", $scope.projectExternalInfo.commissionerName);// 外部结项验收人
                console.log("***********************");
                console.log($scope.projectExternalInfo.acceptances);
                console.log("***********************");
                //技术百分比 userK
                $scope.userKs = $scope.projectExternalInfo.userKs;
                $scope.isTrue = YZ.getUserInfo().id == $scope.projectExternalInfo.cTeacherId;
                $scope.totalUserK = 0;
                $scope.totalUserK2 = 0;
                if ($scope.userKs != null) {
                    for (var i = 0 ; i < $scope.userKs.length ; i ++) {
                        $scope.totalUserK += $scope.userKs[i].userK;
                        $scope.totalUserK2 += $scope.userKs[i].userK;
                    }
                }
                if ($scope.totalUserK2 == 0) {
                    $scope.totalUserK2 = 1;
                }

                //存放上一次的周验收、内部结项验收、外部结项验收
                for (var i = 0; i < $scope.projectExternalInfo.acceptances.length; i++) {
                    if ($scope.projectExternalInfo.acceptances[i].status == 2) {
                        $scope.lastAcceptancesExternal = $scope.projectExternalInfo.acceptances[i];
                        break;
                    }
                }
            }
        });

        //获取周验收、内部结项验收、外部结项验收
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectAcceptanceRecord/acceptanceList", {projectId : $scope.projectExternalId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.acceptanceList = result.data;
            }
        });

        //申请破题
        $scope.applyEssay = function () {
            layer.confirm('您确定申请破题？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", {projectId : $scope.projectExternalId, status : 0, type : 0} , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('申请破题成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });
            }, function(){});
        }

        //破体验收
        $scope.verification = function () {
            var html = '<form class="layui-form layui-form-pane" action="">' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label">破题类型</label>' +
                                '<div class="layui-input-block">' +
                                    '<select id="ptStatus" lay-verify="required">' +
                                        '<option value="">选择破题类型</option>' +
                                        '<option value="5000">未破</option>' +
                                        '<option value="5002">半破</option>' +
                                        '<option value="5004">破</option>' +
                                    '</select>' +
                                '</div>' +
                            '</div>' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label">破题得分</label>' +
                                '<div class="layui-input-block">' +
                                    '<input type="text" id="score" autocomplete="off" placeholder="请输入破题得分(0-100)" class="layui-input" maxlength="10">' +
                                '</div>' +
                            '</div>' +
                        '</form>';

            YZ.formPopup(html, "破体验收", ["500px","500px"], function () {
                if ($("#ptStatus").val() == "") {
                    layer.msg('请选择破题类型.', {icon: 2, anim: 6});
                    return false;
                }
                if(!YZ.isDouble.test($("#score").val())) {
                    layer.msg('请输入一个整数或小数.', {icon: 2, anim: 6});
                    return false;
                }
                if ($("#score").val() > 100 || $("#score").val() < 0) {
                    layer.msg('请输入(0-100).', {icon: 2, anim: 6});
                    return false;
                }
                var status = 0; // 验收状态
                if ($("#score").val() > 70) status = 1;
                else  status = 2;
                $scope.arr = {
                    projectId : $scope.projectExternalId,
                    type : 0,
                    score : $("#score").val(),
                    status : status,
                    ptStatus : $("#ptStatus option:selected").val()
                }
                console.log($scope.arr);
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('破题验收成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });

            }, function () {
            });
            form.render();
        }

        //B导师进行内部结项验收
        $scope.insideKnotAcceptance = function () {
            var html = '<form class="layui-form layui-form-pane" action="">' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label">质量分</label>' +
                                '<div class="layui-input-block">' +
                                    '<input type="text" id="score" autocomplete="off" placeholder="请输入质量分" class="layui-input" maxlength="10">' +
                                '</div>' +
                            '</div>' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label">备注</label>' +
                                '<div class="layui-input-block">' +
                                    '<textarea type="text" id="remarks" autocomplete="off" placeholder="请输入备注" class="layui-textarea"></textarea>' +
                                '</div>' +
                            '</div>' +
                        '</form>';

            YZ.formPopup(html, "内部结项验收", ["600px","300px"], function () {
                if(!YZ.isDouble.test($("#score").val())) {
                    layer.msg('请输入一个整数或小数.', {icon: 2, anim: 6});
                    return false;
                }
                if ($("#score").val() > 1000 || $("#score").val() < 0) {
                    layer.msg('请输入(0-1000).', {icon: 2, anim: 6});
                    return false;
                }
                $scope.arr = {
                    projectId : $scope.projectExternalId,
                    type : 1,
                    status : 11,
                    score : $("#score").val(),
                    remarks : $("#remarks").val(),
                }
                console.log($scope.arr);
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('内部结项验收成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });

            }, function () {
            });
            form.render();
        }

        //C导师进行内部结项验收--打分
        $scope.insideKnotAcceptanceCheck = function () {
            var html = '<form class="layui-form layui-form-pane" action="">' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label">质量分</label>' +
                                '<div class="layui-input-block">' +
                                    '<input type="text" id="score" autocomplete="off" placeholder="请输入质量分" class="layui-input" maxlength="10">' +
                                '</div>' +
                            '</div>' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label">备注</label>' +
                                '<div class="layui-input-block">' +
                                    '<textarea type="text" id="remarks" autocomplete="off" placeholder="请输入备注" class="layui-textarea"></textarea>' +
                                '</div>' +
                            '</div>' +
                        '</form>';

            YZ.formPopup(html, "C导师打分", ["600px","300px"], function () {
                if(!YZ.isDouble.test($("#score").val())) {
                    layer.msg('请输入一个整数或小数.', {icon: 2, anim: 6});
                    return false;
                }
                if ($("#score").val() > 1000 || $("#score").val() < 0) {
                    layer.msg('请输入(0-1000).', {icon: 2, anim: 6});
                    return false;
                }
                var status = 0;
                if ($("#score").val() >= 70) {
                    status = 12;
                }
                else if ($("#score").val() < 70) {
                    status = 13;
                }
                $scope.arr = {
                    projectId : $scope.projectExternalId,
                    type : 1,
                    status : status,
                    score : $("#score").val(),
                    remarks : $("#remarks").val(),
                }
                console.log($scope.arr);
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('C导师打分成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });

            }, function () {
            });
            form.render();
        }

        //进行外部结项验收--绩效专员
        $scope.externalKnotAcceptance = function () {
            var html = '<form class="layui-form layui-form-pane" action="">' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label" style="width: 150px;">质量分</label>' +
                                '<div class="layui-input-block" style="margin-left: 150px;">' +
                                    '<input type="text" id="score" autocomplete="off" placeholder="请输入质量分" class="layui-input" maxlength="10">' +
                                '</div>' +
                            '</div>' +
                            '<div class="layui-form-item" pane>' +
                                '<label class="layui-form-label" style="width: 150px;">是否同意外部结项</label>' +
                                '<div class="layui-input-block" style="margin-left: 150px;">' +
                                    '<input type="radio" name="isOk" value="0" title="是" checked>' +
                                    '<input type="radio" name="isOk" value="1" title="否">' +
                                '</div>' +
                            '</div>' +
                            '<div class="layui-form-item">' +
                                '<label class="layui-form-label" style="width: 150px;">备注</label>' +
                                '<div class="layui-input-block" style="margin-left: 150px;">' +
                                    '<textarea type="text" id="remarks" autocomplete="off" placeholder="请输入备注" class="layui-textarea"></textarea>' +
                                '</div>' +
                            '</div>' +
                        '</form>';

            YZ.formPopup(html, "进行外部结项验收", ["600px","400px"], function () {
                if(!YZ.isDouble.test($("#score").val())) {
                    layer.msg('请输入一个整数或小数.', {icon: 2, anim: 6});
                    return false;
                }
                if ($("#score").val() > 1000 || $("#score").val() < 0) {
                    layer.msg('请输入(0-1000).', {icon: 2, anim: 6});
                    return false;
                }
                var status = 1;
                if ($("input[name='isOk']:checked").val() == 1) status = 2;
                $scope.arr = {
                    projectId : $scope.projectExternalId,
                    type : 2,
                    status : status,
                    score : $("#score").val(),
                    remarks : $("#remarks").val(),
                }
                console.log($scope.arr);
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('外部结项验收成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });

            }, function () {
            });
            form.render();
        }

        //B导师打分大于70可直接通过
        $scope.adoptInsideKnot = function () {
            $scope.arr = {
                projectId : $scope.projectExternalId,
                type : 1,
                status : 12
            }
            layer.confirm('您确定通过内部结项？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('通过内部结项成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });
            }, function(){});
        }

        //团队长申请周验收
        $scope.applyWeekAcceptance = function () {
            if ($scope.userInfo.id != $scope.projectExternalInfo.aTeacher) {
                layer.msg('抱歉,您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            layer.confirm('您确定申请验收？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectWeekAcceptance/save", {projectId : $scope.projectExternalId} , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('申请周验收成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });
            }, function(){});
        }

        //进行周验收
        $scope.weekAcceptance = function (objectId) {
            localStorage.setItem("lastAcceptancesExternal", JSON.stringify($scope.lastAcceptancesExternal));
            var index = layer.open({
                type: 2,
                title: '进行周验收',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectExternal/weekAcceptance?projectExternalId=" + $scope.projectExternalId + "&objectId=" + objectId
            });
            layer.full(index);
        }

        //成员分配比例--暂无用
        $scope.distribution = function (objectId) {
            layer.open({
                type: 2,
                title: '成员分配比例',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectExternal/distributionProportion?projectExternalId=" + $scope.projectExternalId + "&objectId=" + objectId
            });
            //layer.full(index);
        }

        //A导师申请内部结项
        $scope.applyInsideKnot = function () {
            $scope.arr = {
                projectId : $scope.projectExternalId,
                type : 1,
                status : 10,
            }
            layer.confirm('您确定申请内部结项？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('申请内部结项成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });
            }, function(){});
        }

        //A导师申请外部结项
        $scope.applyExternalKnot = function () {
            $scope.arr = {
                projectId : $scope.projectExternalId,
                type : 2,
                status : 0,
            }
            layer.confirm('您确定申请外部结项？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectAcceptanceRecord/save", $scope.arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('申请外部结项成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
                        });
                    }
                });
            }, function(){});
        }

        //查看项目项目进展详情 -- objectId ： 周验收ID
        $scope.weekAcceptanceList = function (objectId) {
            var index = layer.open({
                type: 2,
                title: '周验收详情',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectExternal/weekAcceptanceList?projectExternalId=" + $scope.projectExternalId + "&objectId=" + objectId + "&aTeacherId=" + $scope.projectExternalInfo.aTeacher + "&initK=" + $scope.projectExternalInfo.initK
            });
            layer.full(index);
        }

        //查看内部结项详情
        $scope.insideKnotAcceptanceList = function () {
            var index = layer.open({
                type: 2,
                title: '内部结项详情',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectExternal/insideKnotAcceptanceList?projectExternalId=" + $scope.projectExternalId + "&aTeacherId=" + $scope.projectExternalInfo.aTeacher
            });
            layer.full(index);
        }

        //查看外部结项详情
        $scope.externalKnotAcceptanceList = function () {
            var index = layer.open({
                type: 2,
                title: '外部结项详情',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectExternal/externalKnotAcceptanceList?projectExternalId=" + $scope.projectExternalId + "&aTeacherId=" + $scope.projectExternalInfo.aTeacher
            });
            layer.full(index);
        }

        //查看基本信息
        $scope.basicInfoShow = function () {
            $(".basicInfo").slideDown();
            $scope.isShowInfo = true;
        }
        //收起基本信息
        $scope.basicInfoHide = function () {
            $(".basicInfo").slideUp();
            $scope.isShowInfo = false;
        }

        layui.use(['form', 'layedit', 'laydate', 'layim', 'element'], function() {
            form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate,
                    element = layui.element(); //Tab的切换功能，切换事件监听等，需要依赖element模块;

            //封装成员比例情况
            var html = "";

            for (var i = 0; i < $scope.projectExternalInfo.userKs.length; i++ ) {
                var sum = $scope.projectExternalInfo.userKs[i].userK / $scope.totalUserK2 * 100;
                var userK = Number($scope.projectExternalInfo.userKs[i].userK).toFixed(2);
                html += '<div class="layui-form-item">' +
                        '<label class="layui-form-label" style="width: 200px;">' + $scope.projectExternalInfo.userKs[i].name + ' (' + userK + 'K)</label>' +
                        '<div class="layui-input-block padding-top" style="margin-left: 250px;width: 500px;">' +
                        '<div class="layui-progress layui-progress-big" lay-showPercent="yes">' +
                        '<div class="layui-progress-bar layui-bg-orange" lay-percent="' + sum + '%">' + sum + '%</div>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
            }
            $("#userKsList").html(html);

            form.render();
            element.init(); //这样element对动态生成的元素才会重新有效
        });

    });
    //提供给子页面
    var closeNodeIframe = function () {
        layer.msg('操作成功.', {icon: 1});
        location.reload();
    }



</script>
</body>
</html>
