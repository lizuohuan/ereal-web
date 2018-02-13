<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>成员比例分配</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .hint{color: #666;font-size: 12px;}
        .layui-form-label{width: 200px;}
        .layui-input-block{margin-left: 230px;}
    </style>
</head>
<body ng-app="webApp" ng-controller="distributionProportionCtr" ng-cloak>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>总进度</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">总进度(%)</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{projectInteriorWeekAcceptanceInfo.progress}}%</div>
                </div>
            </div>

            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>质量分</legend>
            </fieldset>

            <div class="layui-form-item" ng-if="projectInteriorWeekAcceptanceInfo.p != null && projectInteriorWeekAcceptanceInfo.p != ''">
                <label class="layui-form-label">P着力点(%)</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{projectInteriorWeekAcceptanceInfo.p}}%</div>
                </div>
            </div>

            <div class="layui-form-item" ng-if="projectInteriorWeekAcceptanceInfo.a != null && projectInteriorWeekAcceptanceInfo.a != ''">
                <label class="layui-form-label">A战略(%)</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{projectInteriorWeekAcceptanceInfo.a}}%</div>
                </div>
            </div>

            <div class="layui-form-item" ng-if="projectInteriorWeekAcceptanceInfo.n != null && projectInteriorWeekAcceptanceInfo.n != ''">
                <label class="layui-form-label">N文字水平(%)</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{projectInteriorWeekAcceptanceInfo.n}}%</div>
                </div>
            </div>

            <div class="layui-form-item" ng-if="projectInteriorWeekAcceptanceInfo.e != null && projectInteriorWeekAcceptanceInfo.e != ''">
                <label class="layui-form-label">E简单可操作性(%)</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{projectInteriorWeekAcceptanceInfo.e}}%</div>
                </div>
            </div>

            <div class="layui-form-item" ng-if="projectInteriorWeekAcceptanceInfo.l != null && projectInteriorWeekAcceptanceInfo.l != ''">
                <label class="layui-form-label">L系统逻辑性(%)</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{projectInteriorWeekAcceptanceInfo.l}}%</div>
                </div>
            </div>

            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>成员当期工时</legend>
            </fieldset>

            <div class="layui-form-item" ng-repeat="user in projectInteriorWeekAcceptanceInfo.userHs">
                <label class="layui-form-label">{{user.userName}}</label>
                <div class="layui-input-inline">
                    <div class="layui-input" ng-if="user.time == null">0h</div>
                    <div class="layui-input" ng-if="user.time != null">{{user.time}}h</div>
                </div>
            </div>

            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>成员分配 <span class="hint">(总分为100%)</span></legend>
            </fieldset>

            <div class="layui-form-item userHs" ng-repeat="user in projectInteriorWeekAcceptanceInfo.userHs" ng-if="lastAcceptances == null">
                <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <%--<input ng-show="projectInteriorWeekAcceptanceInfo.progress == 0" value="0" disabled type="text" userName="{{user.userName}}" userId="{{user.userId}}" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" autocomplete="off" class="layui-input">--%>
                    <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="weekAllocations.l != null">(上次L系统逻辑性{{lastAcceptances.l}}%)</div>
            </div>

            <div class="layui-form-item userHs" ng-repeat="user in lastAcceptances.weekAllocations" ng-if="lastAcceptances != null">
                <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="user.ratio != null">(上次比例分配{{user.ratio}}%)</div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>
    </div>

    <!--引入抽取公共js-->
    <%@include file="../../common/public-js.jsp" %>
    <script>

        var webApp=angular.module('webApp',[]);
        webApp.controller("distributionProportionCtr", function($scope,$http,$timeout){
            $scope.weekId = YZ.getUrlParam("weekId");
            $scope.projectInteriorWeekAcceptanceInfo = null; //周验收详情
            $scope.lastAcceptances = JSON.parse(localStorage.getItem("lastAcceptances"));
            console.log($scope.lastAcceptances);
            YZ.ajaxRequestData("get", false, YZ.ip + "/projectInteriorWeekAcceptance/getAllocationWeekData", {weekId : $scope.weekId}, null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    $scope.projectInteriorWeekAcceptanceInfo = result.data;
                }
            });

            $(function () {
                if ($scope.projectInteriorWeekAcceptanceInfo.progress == 0) {
                    $(".userHs").find("input").attr("disabled", true);
                    $(".userHs").find("input").val(0);
                }
            })

            layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
                var form = layui.form(),
                        layer = layui.layer,
                        laydate = layui.laydate;

                //自定义验证规则
                form.verify({
                    isNumber: function(value) {
                        if(value.length > 0 && !YZ.isNumber.test(value)) {
                            return "请输入一个整数";
                        }
                    },
                    isZero : function (value) {
                        if(value < 0 || value > 100) {
                            return "请输入(0-100)";
                        }
                    }
                });

                form.render();
                //监听提交
                form.on('submit(demo1)', function(data) {
                    var userArray = new Array();
                    var sumRatio = 0;
                    $(".userHs").each(function () {
                        var userJson = {
                            userId :  $(this).find("input").attr("userId"),
                            userName :  $(this).find("input").attr("userName"),
                            weekId :  $scope.weekId,
                            ratio :  $(this).find("input").val(),
                        }
                        userArray.push(userJson);
                        sumRatio += Number($(this).find("input").val());
                    });
                    if (Number(sumRatio) != 100 && $scope.projectInteriorWeekAcceptanceInfo.progress != 0) {
                        layer.msg('成员比例相加必须等于100%.', {icon: 2, anim: 6});
                        return false;
                    }
                    data.field.projectInteriorWeekKAllocation = JSON.stringify(userArray);
                    console.log(data.field);
                    YZ.ajaxRequestData("post", false, YZ.ip + "/projectInteriorWeekAcceptance/allocationRatio", data.field , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            layer.alert('分配比例成功.', {
                                skin: 'layui-layer-molv' //样式类名
                                ,closeBtn: 0
                                ,anim: 4 //动画类型
                            }, function(){
                                //关闭iframe页面
                                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                                parent.layer.close(index);
                                window.parent.closeNodeIframe();
                            });
                        }
                    });
                    return false;
                });
            });
        });

    </script>
</body>
</html>
