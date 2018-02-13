<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>内部项目详情</title>
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
<body ng-app="webApp" ng-controller="projectInteriorCtr" ng-cloak>
<div class="admin-main">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;内部项目详情&nbsp;&nbsp;&nbsp;
        <%--<a href="javascript:history.go(-1)" class="layui-btn layui-btn-primary layui-btn-small">返回</a>--%>
    </blockquote>
    <div class="layui-field-box layui-form">

        <fieldset class="layui-elem-field">
            <legend>内部项目详情</legend>
            <div class="layui-field-box">
                <div class="project-context">
                    <span class="groupName">{{projectInteriorInfo.department.departmentName | limitTo:1}} </span>
                    <p class="project-title">{{projectInteriorInfo.projectName}}</p>
                    <p>{{projectInteriorInfo.shortName}}</p>
                    <p>{{projectInteriorInfo.projectMajorName}}</p>
                    <p>项目经理：{{projectInteriorInfo.projectManagerName}}</p>
                    <p>A导师：{{projectInteriorInfo.allocationUser.name}}</p>
                    <p>汇报人：{{projectInteriorInfo.directReportPersonUserName}}</p>
                    <p>项目效率：{{projectInteriorInfo.efficiency * 100 | number:2}}%</p>
                    <p>项目开始时间：{{ projectInteriorInfo.startTime | date:'yyyy-MM-dd'}}</p>
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
            <legend>内部项目基本信息</legend>
            <div class="layui-field-box">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">项目编号</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.projectNumber}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目名</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.projectName}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目简称</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.shortName}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">项目专业</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.projectMajorName}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">初始工作量</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.initWorkload}} 天</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目组名</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.projectGroupName}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">所属部门</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.department.departmentName}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目启动时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectInteriorInfo.startTime | date:'yyyy-MM-dd'}}
                            </div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">项目截止时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectInteriorInfo.endTime | date:'yyyy-MM-dd'}}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">审核人</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.reviewerUser.name}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">创建人</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.createUser.name}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">被推送人</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.allocationUser.name}}</div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">直接汇报人</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >{{projectInteriorInfo.directReportPersonUserName}}</div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">创建时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectInteriorInfo.createTime | date:'yyyy-MM-dd HH:mm:ss'}}
                            </div>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">审核时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectInteriorInfo.reviewerTime | date:'yyyy-MM-dd HH:mm:ss'}}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">项目分配时间</label>
                        <div class="layui-input-inline">
                            <div class="layui-input" >
                                {{ projectInteriorInfo.allocationTime | date:'yyyy-MM-dd HH:mm:ss'}}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </fieldset>

    </div>

    <blockquote class="layui-elem-quote">周验收情况&nbsp;&nbsp;&nbsp;
        <button ng-if="projectInteriorInfo.projectStatus == 1" class="layui-btn layui-btn-small layui-btn-disabled">该项目已结项</button>
        <button ng-if="userInfo.id == projectInteriorInfo.allocationUserId && !isApplied && !isDistribution && projectInteriorInfo.projectStatus != 1" ng-click="applyWeekAcceptance()" class="layui-btn layui-btn-small layui-btn-normal hide checkBtn_77">申请周验收</button>
        <button ng-if="userInfo.id == projectInteriorInfo.allocationUserId && isApplied" class="layui-btn layui-btn-small layui-btn-disabled">您已提交申请周验收，正在等待验收...</button>
        <button ng-if="isApplied && userInfo.id == projectInteriorInfo.directReportPersonUserId && !isDistribution && projectInteriorInfo.projectStatus != 1" class="layui-btn layui-btn-small layui-btn-warm hide checkBtn_78" ng-click="weekAcceptance()">进行周验收</button>
        <button ng-if="userInfo.id == projectInteriorInfo.allocationUserId && isDistribution" ng-click="distribution()" class="layui-btn layui-btn-small layui-btn-normal hide checkBtn_79">成员比例分配</button>
    </blockquote>
    <div style="margin: 15px;">
        <div class="intro-flow">
            <div class="acceptanceMan">验收人：{{projectInteriorInfo.directReportPersonUserName}}</div>
            <div class="acceptanceMan" style="font-size: 13px;font-weight: normal;color: #666;" ng-if="projectInteriorInfo.acceptances.length == 0">暂无验收记录</div>
            <div class="intro-list" ng-repeat="acceptance in projectInteriorInfo.acceptances.slice().reverse()">
                <div class="intro-list-left">
                    <%--<button class="layui-btn layui-btn-small layui-btn-normal">查看详情</button>--%>
                </div>
                <div class="intro-list-right">
                    <span>{{ projectInteriorInfo.acceptances.length - $index }}</span>
                    <div class="intro-list-content">
                        <p>进度完成：
                            <span ng-if="acceptance.progress == null">0</span>
                            <span ng-if="acceptance.progress != null">{{acceptance.progress}}</span>
                            %　　　　　{{ acceptance.createTime | date:'yyyy-MM-dd HH:mm:ss'}} </p>
                        <p>总K值：
                            <span ng-if="acceptance.sumK == null">0</span>
                            <span ng-if="acceptance.sumK != null">{{acceptance.totalK | number:2}}K</span>
                            <span class="noDistribution" ng-if="projectInteriorInfo.acceptances.length > 1 && acceptance.isAdd == 1">　　<span style="font-size: 12px;font-weight: bold;margin-right: 5px;">↑</span>{{acceptance.sumK | number:2}}K</span>
                            <span class="noDistribution" ng-if="projectInteriorInfo.acceptances.length > 1 && acceptance.isAdd == 0">　　<span style="font-size: 12px;font-weight: bold;margin-right: 5px;">↓</span>{{acceptance.sumK | number:2}}K</span>
                            <span class="noDistribution" ng-if="acceptance.status == 1">　　　　　未成员分配</span></p>
                        <p>
                            <span ng-if="acceptance.p == null">P0　　　</span>
                            <span ng-if="acceptance.p != null">P{{acceptance.p}}　　　</span>
                            <span ng-if="acceptance.a == null">A0　　　</span>
                            <span ng-if="acceptance.a != null">A{{acceptance.a}}　　　</span>
                            <span ng-if="acceptance.n == null">N0　　　</span>
                            <span ng-if="acceptance.n != null">N{{acceptance.n}}　　　</span>
                            <span ng-if="acceptance.e == null">E0　　　</span>
                            <span ng-if="acceptance.e != null">E{{acceptance.e}}　　　</span>
                            <span ng-if="acceptance.l == null">L0　　　</span>
                            <span ng-if="acceptance.l != null">L{{acceptance.l}}　　　</span>
                        </p>
                        <p ng-repeat="week in acceptance.weekAllocations">
                            <span>{{week.userName}}&nbsp;{{week.ratio}}%　　　</span>
                        </p>
                        <p>验收人备注：
                            <span ng-if="acceptance.remarks == null || acceptance.remarks == ''">无</span>
                            <span ng-if="acceptance.remarks != null && acceptance.remarks != ''">{{acceptance.remarks}}</span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("projectInteriorCtr", function($scope,$http,$timeout){
        $scope.projectInteriorId = YZ.getUrlParam("projectInteriorId");
        $scope.userInfo = YZ.getUserInfo();
        $scope.projectInteriorInfo = null;
        $scope.isApplied = false;//获取是否已经申请过叻
        $scope.isDistribution = false;//获取是否可分配
        $scope.isAppliedId = null; //存放已经申请的周验收ID
        $scope.isDistributionId = null; //存放可分配ID
        $scope.acceptances = new Array(); //存放已通过的周验收
        $scope.isShowInfo = false; //显示/隐藏基本信息
        $scope.lastAcceptances = null; //存放上一次周验收
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectInterior/info", {id : $scope.projectInteriorId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.projectInteriorInfo = result.data;
                console.log($scope.projectInteriorInfo.acceptances);



                //技术百分比 userK
                $scope.userKs = $scope.projectInteriorInfo.userKs;
                $scope.totalUserK = 0;
                $scope.totalUserK2 = 0;
                for (var i = 0 ; i < $scope.userKs.length ; i ++) {
                    $scope.totalUserK += $scope.userKs[i].userK;
                    $scope.totalUserK2 += $scope.userKs[i].userK;
                }
                if ($scope.totalUserK2 == 0) {
                    $scope.totalUserK2 = 1;
                }

               /* for (var i = 0; $scope.projectInteriorInfo.acceptances.length; i++) {
                    //存放已申请的周验收
                    if ($scope.projectInteriorInfo.acceptances[i].status > 0) {
                        $scope.acceptances.push($scope.projectInteriorInfo.acceptances[i]);
                    }
                }*/

                console.log($scope.acceptances);

                for (var i = 0; i < $scope.projectInteriorInfo.acceptances.length; i++) {
                    if ($scope.projectInteriorInfo.acceptances[i].status == 0) { //表示已经有申请的数据了
                        $scope.isApplied = true;
                        $scope.isAppliedId = $scope.projectInteriorInfo.acceptances[i].id;
                        break;
                    }
                    if ($scope.projectInteriorInfo.acceptances[i].status == 1) { //表示已经有可以分配的数据了
                        $scope.isDistribution = true;
                        $scope.isDistributionId = $scope.projectInteriorInfo.acceptances[i].id;
                        break;
                    }
                }

                //存放上一次的周验收和成员分配
                for (var i = 0; i < $scope.projectInteriorInfo.acceptances.length; i++) {
                    if ($scope.projectInteriorInfo.acceptances[i].status == 2) {
                        $scope.lastAcceptances = $scope.projectInteriorInfo.acceptances[i];
                        break;
                    }
                }

            }
        });

        //团队长申请周验收
        $scope.applyWeekAcceptance = function () {
            layer.confirm('您确定申请验收？', {
                btn: ['确定','取消'] //按钮
            }, function(){
                YZ.ajaxRequestData("post", false, YZ.ip + "/projectInteriorWeekAcceptance/save", {projectInteriorId : $scope.projectInteriorId} , null , function(result) {
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
        $scope.weekAcceptance = function () {
            localStorage.setItem("lastAcceptances", JSON.stringify($scope.lastAcceptances));
            var index = layer.open({
                type: 2,
                title: '进行周验收',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectInterior/weekAcceptance?projectInteriorWeekAcceptanceId=" + $scope.isAppliedId + "&atHome=" + $scope.projectInteriorInfo.atHome + "&projectInteriorId=" + $scope.projectInteriorId
            });
            layer.full(index);
        }

        //成员分配比例
        $scope.distribution = function () {
            localStorage.setItem("lastAcceptances", JSON.stringify($scope.lastAcceptances));
            var index = layer.open({
                type: 2,
                title: '成员分配比例',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectInterior/distributionProportion?weekId=" + $scope.isDistributionId
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
            for (var i = 0; i < $scope.projectInteriorInfo.userKs.length; i++ ) {
                var sum = $scope.projectInteriorInfo.userKs[i].userK / $scope.totalUserK2 * 100;
                var userK = Number($scope.projectInteriorInfo.userKs[i].userK).toFixed(2);
                html += '<div class="layui-form-item">' +
                        '<label class="layui-form-label" style="width: 200px;">' + $scope.projectInteriorInfo.userKs[i].name + ' (' + userK + 'K)</label>' +
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
        location.reload();
        layer.msg('操作成功.', {icon: 1});
    }



</script>
</body>
</html>
