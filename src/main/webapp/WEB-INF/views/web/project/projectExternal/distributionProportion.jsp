<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 解决layer.open 不居中问题   -->
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>成员比例分配</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .layui-form-label{width: 200px !important;}
        .layui-input-block{margin-left: 200px !important;}
        .layui-hide{display: none !important;}
    </style>
</head>
<body ng-app="webApp" ng-controller="distributionProportionCtr" ng-cloak>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>成员当期工时</legend>
    </fieldset>

    <div class="layui-form-item" ng-repeat="user in userList">
        <label class="layui-form-label">{{user.userName}}</label>
        <div class="layui-input-inline">
            <div class="layui-input" ng-if="user.time == null">0h</div>
            <div class="layui-input" ng-if="user.time != null">{{user.time}}h</div>
        </div>
    </div>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>成员总工时</legend>
    </fieldset>

    <div class="layui-form-item" ng-repeat="user in userList">
        <label class="layui-form-label">{{user.userName}}</label>
        <div class="layui-input-inline">
            <div class="layui-input" ng-if="user.totalTime == null">0h</div>
            <div class="layui-input" ng-if="user.totalTime != null">{{user.totalTime}}h</div>
        </div>
    </div>

    <form class="layui-form layui-form-pane" action="" id="formData">

        <div class="layui-collapse" style="margin: 15px;">
            <div class="layui-colla-item stage1">
                <h2 class="layui-colla-title">一阶段比例分配(总占比100%)</h2>
                <div class="layui-colla-content layui-show">
                    <div class="layui-form-item" ng-repeat="user in userList" ng-if="lastAcceptancesExternal == null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                    </div>
                    <div class="layui-form-item" ng-repeat="user in arr1" ng-if="lastAcceptancesExternal != null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid layui-word-aux layui-hide">(上次比例{{user.ratio}}%)</div>
                    </div>
                </div>
            </div>
            <div class="layui-colla-item stage2">
                <h2 class="layui-colla-title">二阶段比例分配(总占比100%)</h2>
                <div class="layui-colla-content layui-show">
                    <div class="layui-form-item" ng-repeat="user in userList" ng-if="lastAcceptancesExternal == null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                    </div>
                    <div class="layui-form-item" ng-repeat="user in arr2" ng-if="lastAcceptancesExternal != null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid layui-word-aux layui-hide">(上次比例{{user.ratio}}%)</div>
                    </div>
                </div>
            </div>
            <div class="layui-colla-item stage3">
                <h2 class="layui-colla-title">三阶段比例分配(总占比100%)</h2>
                <div class="layui-colla-content layui-show">
                    <div class="layui-form-item" ng-repeat="user in userList" ng-if="lastAcceptancesExternal == null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                    </div>
                    <div class="layui-form-item" ng-repeat="user in arr3" ng-if="lastAcceptancesExternal != null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid layui-word-aux layui-hide">(上次比例{{user.ratio}}%)</div>
                    </div>
                </div>
            </div>
            <div class="layui-colla-item stage4">
                <h2 class="layui-colla-title">四阶段比例分配(总占比100%)</h2>
                <div class="layui-colla-content layui-show">
                    <div class="layui-form-item" ng-repeat="user in userList" ng-if="lastAcceptancesExternal == null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                    </div>
                    <div class="layui-form-item" ng-repeat="user in arr4" ng-if="lastAcceptancesExternal != null">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" autocomplete="off" lay-verify="required|isNumber|isZero" placeholder="请输入{{user.userName}}的比例" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid layui-word-aux layui-hide">(上次比例{{user.ratio}}%)</div>
                    </div>
                </div>
            </div>
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
        $scope.projectExternalId = YZ.getUrlParam("projectExternalId"); //外部项目ID
        $scope.projectTypeSectionId = YZ.getUrlParam("projectTypeSectionId"); // 项目周验收的 阶段ID
        $scope.objectId = YZ.getUrlParam("objectId"); // 周验收ID
        $scope.sumK = YZ.getUrlParam("sumK"); // 当前总K
        $scope.userList = null; //存放可分配比例的用户
        $scope.stageList = null; //存放阶段
        $scope.sectionDetail = JSON.parse(localStorage.getItem("sectionDetail")); //存放可分配的JSON数据
        $scope.lastAcceptancesExternal = JSON.parse(localStorage.getItem("lastAcceptancesExternal"));
        if ($scope.lastAcceptancesExternal != null) {
            console.log("***********************");
            console.log($scope.lastAcceptancesExternal);
            console.log("***********************");
            $scope.projectWeekKAllocations = $scope.lastAcceptancesExternal.projectWeekKAllocations;
            $scope.arr1 = [];
            $scope.arr2 = [];
            $scope.arr3 = [];
            $scope.arr4 = [];
            for (var j = 0; j < $scope.projectWeekKAllocations.length; j++) {
                var obj = $scope.projectWeekKAllocations[j];
                if (obj.sectionNum == 1) {
                    $scope.arr1.push(obj);
                }
                if (obj.sectionNum == 2) {
                    $scope.arr2.push(obj);
                }
                if (obj.sectionNum == 3) {
                    $scope.arr3.push(obj);
                }
                if (obj.sectionNum == 4) {
                    $scope.arr4.push(obj);
                }
            }
        }

        //获取成员
        YZ.ajaxRequestData("get", false, YZ.ip + "/project/getProjectUser", {projectId : $scope.projectExternalId} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.userList = result.data;
            }
        });
        //存放阶段
        YZ.ajaxRequestData("get", false, YZ.ip + "/project/getProjectType", {projectId : $scope.projectExternalId} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.stageList = result.data;
            }
        });

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

            //设置验收是否为0，如果为0：就不做分配
            $(function () {
                for (var i = 0; i < $scope.sectionDetail.length; i++) {
                    if (($scope.sectionDetail[i].quality * $scope.sectionDetail[i].schedule) == 0 && $scope.sectionDetail[i].sectionNum == (i + 1)) {
                        $(".stage" + (i + 1)).find("input").attr("disabled", true);
                        $(".stage" + (i + 1)).find("input").removeAttr("lay-verify");
                        $(".stage" + (i + 1)).find("input").val(0);
                    }
                }
            });

            form.render();
            //监听提交
            form.on('submit(demo1)', function(data) {

                console.log($scope.sectionDetail);
                var jsonArray = new Array();
                for (var i = 0; i < $scope.stageList.length; i++) {
                    var sum = 0;
                    if ($scope.stageList[i].sectionNum == (i + 1)) {
                        $(".stage" + (i + 1) + " .layui-form-item").each(function () {
                            var json = {
                                sectionNum : $scope.stageList[i].sectionNum,
                                id : $(this).find("input").attr("userId"),
                                userName : $(this).find("input").attr("userName"),
                                ratio : $(this).find("input").val(),
                                projectWeekAcceptanceId : $scope.objectId,
                                sectionId : $scope.stageList[i].id,
                                k : $scope.sectionDetail[i].k,
                            };
                            sum = (sum + Number($(this).find("input").val()));
                            jsonArray.push(json);
                        });
                    }
                    var str = "";
                    switch ((i + 1)) {
                        case 1 :
                            str = "一";
                            break;
                        case 2 :
                            str = "二";
                            break;
                        case 3 :
                            str = "三";
                            break;
                        case 4 :
                            str = "四";
                            break;
                    }
                    if (sum != 100 && ($scope.sectionDetail[i].quality * $scope.sectionDetail[i].schedule) != 0) {
                        layer.msg(str + '阶段比例相加必须等于100%，当前' + sum, {icon: 2, anim: 6});
                        return false;
                    }
                }

                console.log(jsonArray);

                YZ.ajaxRequestData("post", false, YZ.ip + "/projectWeekKAllocation/save", {projectWeekKAllocation : JSON.stringify(jsonArray), weekId : $scope.objectId} , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('提交分配结果成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            //关闭iframe页面
                            var index = parent.parent.layer.getFrameIndex(window.name); //获取窗口索引
                            parent.parent.layer.close(index);
                            window.parent.parent.closeNodeIframe();
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
