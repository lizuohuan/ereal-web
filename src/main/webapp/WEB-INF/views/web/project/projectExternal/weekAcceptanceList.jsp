<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>周验收详情</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/speed.css">
    <style>
        .padding-top{padding-top: 10px}
        .layui-bg-orange{color: #fff;}
        .acceptanceMan{padding: 15px;padding-left: 20%;font-size: 18px;font-weight: bold;}
        .noDistribution{color: #4CAF50}
        .intro-list-content p{margin-bottom: 10px;}
        /*.intro-list-right{width: 100%;}*/

        .col-xs-3 {
            float: left;
            width: 25%;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="weekAcceptanceListCtr" ng-cloak>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;周验收情况&nbsp;&nbsp;&nbsp;
            <button ng-if="userInfo.id == aTeacherId && isDistribution" ng-click="distribution()" class="layui-btn layui-btn-small layui-btn-warm">成员比例分配</button>
        </blockquote>
        <div class="intro-flow">
            <div class="acceptanceMan">验收人：{{bTeacherName}}</div>
            <br>
            <div class="acceptanceMan" style="font-size: 13px;font-weight: normal;color: #666;" ng-if="projectInteriorInfo.acceptances.length == 0">暂无验收记录</div>
            <div class="intro-list" ng-repeat="acceptance in acceptanceList">
                <div class="intro-list-left">
                    <%--<button class="layui-btn layui-btn-small layui-btn-normal">查看详情</button>--%>
                </div>
                <div class="intro-list-right">
                    <span>{{ acceptanceList.length - $index }}</span>
                    <div class="intro-list-content">
                        <p>进度完成：
                            <span ng-if="acceptance.progress == null">0</span>
                            <span ng-if="acceptance.progress != null">{{acceptance.totalK / initK * 100 | number:0}}</span>
                            %　　　　　{{ acceptance.createTime | date:'yyyy-MM-dd HH:mm:ss'}} </p>
                        <p>总K值：
                            <span ng-if="acceptance.sumK == null">0K</span>
                            <span ng-if="acceptance.sumK != null">{{acceptance.totalK | number:2}}K</span>
                            <span class="noDistribution" ng-if="acceptanceList.length > 1 && acceptance.isAdd == 1">　　<span style="font-size: 12px;font-weight: bold;margin-right: 5px;">↑</span>{{acceptance.sumK | number:2}}K</span>
                            <span class="noDistribution" ng-if="acceptanceList.length > 1 && acceptance.isAdd == 0">　　<span style="font-size: 12px;font-weight: bold;margin-right: 5px;">↓</span>{{acceptance.sumK | number:2}}K</span>
                        </p>
                        <p>
                            各阶段进度：
                            <span ng-if="acceptance.sectionDetail == null">无</span>
                            <span ng-repeat="section in acceptance.sectionDetail" ng-if="acceptance.sectionDetail != null">
                                <span ng-if="section.sectionNum == 1">一阶段{{section.schedule}}%　</span>
                                <span ng-if="section.sectionNum == 2">二阶段{{section.schedule}}%　</span>
                                <span ng-if="section.sectionNum == 3">三阶段{{section.schedule}}%　</span>
                                <span ng-if="section.sectionNum == 4">四阶段{{section.schedule}}%</span>
                            </span>
                        </p>
                        <div>
                            成员分配：
                            <span class="noDistribution" ng-if="acceptance.status == 1 || acceptance.status == 0">未成员分配</span>
                            <table class="layui-table admin-table table-bordered" width="100%" ng-if="acceptance.status == 2" style="border: 1px solid #e1e1e1;">
                                <tbody>
                                    <tr>
                                        <td>一阶段</td>
                                        <td ng-repeat="week in acceptance.stage1">{{week.userName}}：{{week.ratio}}%</td>
                                    </tr>
                                    <tr>
                                        <td>二阶段</td>
                                        <td ng-repeat="week in acceptance.stage2">{{week.userName}}：{{week.ratio}}%</td>
                                    </tr>
                                    <tr>
                                        <td>三阶段</td>
                                        <td ng-repeat="week in acceptance.stage3">{{week.userName}}：{{week.ratio}}%</td>
                                    </tr>
                                    <tr>
                                        <td>四阶段</td>
                                        <td ng-repeat="week in acceptance.stage4">{{week.userName}}：{{week.ratio}}%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <p>验收人备注：
                            <span ng-if="acceptance.remark == null || acceptance.remark == ''">无</span>
                            <span ng-if="acceptance.remark != null && acceptance.remark != ''">{{acceptance.remark}}</span>
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
        webApp.controller("weekAcceptanceListCtr", function($scope,$http,$timeout){
            $scope.userInfo = YZ.getUserInfo();
            $scope.aTeacherId = YZ.getUrlParam("aTeacherId"); // A导师
            $scope.projectExternalId = YZ.getUrlParam("projectExternalId"); //项目ID
            $scope.objectId = YZ.getUrlParam("objectId"); // 周验收ID
            $scope.bTeacherName = localStorage.getItem("bTeacherName");
            $scope.initK = YZ.getUrlParam("initK"); /**初始工作量*/
            $scope.isDistribution = false;//获取是否可分配
            $scope.isDistributionId = null; //存放可分配ID
            $scope.sectionDetail = null; //存放可分配的JSON数据
            $scope.lastAcceptancesExternal = null; //存放上一次周验收、内部结项验收、外部结项验收
            YZ.ajaxRequestData("get", false, YZ.ip + "/projectWeekAcceptance/list", {projectId : $scope.projectExternalId}, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    $scope.acceptanceList = result.data;
                    //循环解析json
                    for (var i = 0; i < $scope.acceptanceList.length; i++) {
                        $scope.sumSchedule = 0; //存放所有阶段相加的百分比
                        $scope.acceptanceList[i].sectionDetail = JSON.parse($scope.acceptanceList[i].sectionDetail);
                        if ($scope.acceptanceList[i].sectionDetail != null) {
                            for (var j = 0; j < $scope.acceptanceList[i].sectionDetail.length; j++) {
                                $scope.sumSchedule += $scope.acceptanceList[i].sectionDetail[j].schedule;
                            }
                            $scope.acceptanceList[i].progress = $scope.sumSchedule / 4;
                        }
                    }

                    //获取可分配的周验收ID
                    for (var i = 0; i < $scope.acceptanceList.length; i++) {
                        if ($scope.acceptanceList[i].status == 1) { //表示已经有可以分配的数据了
                            $scope.isDistribution = true;
                            $scope.isDistributionId = $scope.acceptanceList[i].id;
                            $scope.sectionSumK = $scope.acceptanceList[i].sumK;
                            $scope.sectionDetail = JSON.stringify($scope.acceptanceList[i].sectionDetail);
                            break;
                        }
                    }

                    //存放上一次的周验收、内部结项验收、外部结项验收
                    for (var i = 0; i < $scope.acceptanceList.length; i++) {
                        if ($scope.acceptanceList[i].status == 2) {
                            $scope.lastAcceptancesExternal = $scope.acceptanceList[i];
                            break;
                        }
                    }

                    //封装数据
                    for (var i = 0; i < $scope.acceptanceList.length; i++) {
                        var obj = $scope.acceptanceList[i];
                        var stage = [];
                        var arr1 = [];
                        var arr2 = [];
                        var arr3 = [];
                        var arr4 = [];
                        for (var j = 0; j < obj.projectWeekKAllocations.length; j++) {
                            var obj2 = obj.projectWeekKAllocations[j];
                            if (obj2.sectionNum == 1) {
                                arr1.push(obj2);
                            }
                            if (obj2.sectionNum == 2) {
                                arr2.push(obj2);
                            }
                            if (obj2.sectionNum == 3) {
                                arr3.push(obj2);
                            }
                            if (obj2.sectionNum == 4) {
                                arr4.push(obj2);
                            }
                        }
                        stage.push(arr1);
                        stage.push(arr2);
                        stage.push(arr3);
                        stage.push(arr4);
                        obj.stage1 = arr1;
                        obj.stage2 = arr2;
                        obj.stage3 = arr3;
                        obj.stage4 = arr4;
                    }

                    console.log("------------------------------------------");
                    console.log($scope.acceptanceList);
                    console.log("------------------------------------------");
                }
            });

            //成员分配比例
            $scope.distribution = function () {
                localStorage.setItem("sectionDetail", $scope.sectionDetail);
                localStorage.setItem("lastAcceptancesExternal", JSON.stringify($scope.lastAcceptancesExternal));
                layer.open({
                    type: 2,
                    title: '成员分配比例',
                    maxmin: true, //开启最大化最小化按钮
                    area: ['900px', '500px'],
                    content: YZ.ip + "/page/project/projectExternal/distributionProportion?objectId=" + $scope.objectId +
                    "&projectTypeSectionId=" + $scope.isDistributionId +
                    "&projectExternalId=" + $scope.projectExternalId +
                    "&sumK=" + $scope.sectionSumK
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
            var index = layer.load(1, {shade: [0.5,'#eee']});
            setTimeout(function () {layer.close(index);}, 600);
        }


    </script>
</body>
</html>
