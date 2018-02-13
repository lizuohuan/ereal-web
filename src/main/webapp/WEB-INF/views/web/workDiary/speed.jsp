<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>传递卡进度</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/speed.css">
</head>
<body ng-app="webApp">
<div style="margin: 15px;" ng-controller="speedCtr" ng-cloak>
    <div class="intro-flow">
        <div class="intro-list" ng-repeat="detail in details">
            <div class="intro-list-left">
                <%--业务受理--%>
            </div>
            <div class="intro-list-right">
                <span>{{ details.length - $index }}</span>
                <div class="intro-list-content">
                    <img class="intro-img" ng-if="detail.avatar == null" src="<%=request.getContextPath()%>/resources/img/0.jpg" >
                    <img class="intro-img" ng-if="detail.avatar != null" src="<%=imgPath%>/{{detail.avatar}}" >
                    <div class="content">
                        <p>{{detail.departmentName}}　{{detail.userName}}</p>
                        <p>{{detail.statusDescribe}}</p>
                        <p>备注：<span ng-if="detail.notes == null">无</span><span ng-if="detail.notes != null">{{detail.notes}}</span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("speedCtr", function($scope,$http,$timeout){
        $scope.details = JSON.parse(localStorage.getItem("details"));
    });


</script>
</body>
</html>
