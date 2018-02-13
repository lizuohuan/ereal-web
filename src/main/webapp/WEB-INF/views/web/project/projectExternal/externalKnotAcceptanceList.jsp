<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>外部结项详情</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/speed.css">
    <style>
        .padding-top{padding-top: 10px}
        .layui-bg-orange{color: #fff;}
        .acceptanceMan{padding: 15px;padding-left: 20%;font-size: 18px;font-weight: bold;}
        .noDistribution{color: #4CAF50;}
        .red{color:red;margin-left: 20px;}
        .intro-list-content p{margin-bottom: 10px;}
        /*.intro-list-right{width: 100%;}*/
    </style>
</head>
<body ng-app="webApp" ng-controller="insideKnotAcceptanceListCtr" ng-cloak>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote">外部结项情况&nbsp;&nbsp;&nbsp;
        <button ng-if="userInfo.id == aTeacherId && isDistribution && !isAllocated" ng-click="distribution()" class="layui-btn layui-btn-small layui-btn-warm">成员比例分配</button>
    </blockquote>
    <div class="intro-flow">
        <div class="acceptanceMan">验收人：{{commissionerName}}</div>
        <br>
        <div class="acceptanceMan" style="font-size: 13px;font-weight: normal;color: #666;" ng-if="projectInteriorInfo.acceptances.length == 0">暂无验收记录</div>
        <div class="intro-list" ng-repeat="acceptance in acceptanceList">
            <div class="intro-list-left">
                <%--<button class="layui-btn layui-btn-small layui-btn-normal">查看详情</button>--%>
            </div>
            <div class="intro-list-right">
                <span>{{ acceptanceList.length - $index }}</span>
                <div class="intro-list-content">
                    <p>
                        <span ng-if="acceptance.status == 0">提交外部结项申请</span>
                            <span ng-if="acceptance.status == 1">
                                结项得分：<span>{{acceptance.score | number : 2}}分</span>
                            </span>
                            <span ng-if="acceptance.status == 2">
                                结项得分：<span>{{acceptance.score | number : 2}}分</span>
                                <%--<span class="red">结项失败</span>--%>
                            </span>
                        　　　　　{{ acceptance.createTime | date:'yyyy-MM-dd HH:mm:ss'}} </p>
                    <p ng-if="acceptance.status == 1">总K值：
                        <span ng-if="acceptance.sumK == null">0K</span>
                        <span ng-if="acceptance.sumK != null">{{acceptance.sumK | number:2}}K</span>
                    </p>
                    <p ng-if="acceptance.status == 1 || acceptance.status == 2">
                        成员分配：
                        <span class="noDistribution" ng-if="acceptance.projectKs.length == 0">未成员分配</span>
                            <span ng-repeat="user in acceptance.projectKs">
                                {{user.userName}}：{{user.ratio}}% &nbsp;&nbsp;&nbsp;
                            </span>
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

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("insideKnotAcceptanceListCtr", function($scope,$http,$timeout){
        $scope.userInfo = YZ.getUserInfo();
        $scope.aTeacherId = YZ.getUrlParam("aTeacherId"); // B导师ID--团队长
        $scope.projectExternalId = YZ.getUrlParam("projectExternalId"); //项目ID
        $scope.commissionerName = localStorage.getItem("commissionerName");
        $scope.isDistribution = false;//获取是否可分配
        $scope.projectRecordId = null; //存放可分配ID
        $scope.isAllocated = false; //是否已经分配了
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectAcceptanceRecord/list", {projectId : $scope.projectExternalId, type : 2}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.acceptanceList = result.data;
                //获取可分配的ID
                for (var i = 0; i < $scope.acceptanceList.length; i++) {
                    if ($scope.acceptanceList[i].status == 1 || $scope.acceptanceList[i].status == 2) { //表示已经有可以分配的数据了
                        $scope.isDistribution = true;
                        $scope.projectRecordId = $scope.acceptanceList[i].id;
                        $scope.score = $scope.acceptanceList[i].score; //存放分数
                        if ($scope.acceptanceList[i].projectKs.length > 0) {
                            $scope.isAllocated = true;
                        }
                        break;
                    }
                }
            }
        });

        //成员分配比例
        $scope.distribution = function () {
            layer.open({
                type: 2,
                title: '成员分配比例',
                maxmin: true, //开启最大化最小化按钮
                area: ['700px', '500px'],
                content: YZ.ip + "/page/project/projectExternal/distributionExternalKnot?projectRecordId=" + $scope.projectRecordId +
                "&projectExternalId=" + $scope.projectExternalId +
                "&score=" + $scope.score
            });
        }


    });
    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

    });

    //提供给子页面
    var closeNodeIframe = function () {
        location.reload();
        layer.msg('操作成功.', {icon: 1});
    }


</script>
</body>
</html>
