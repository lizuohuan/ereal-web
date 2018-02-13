<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>内部结项成员比例分配</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .layui-form-label{width: 200px !important;}
        .layui-input-block{margin-left: 200px !important;}
    </style>
</head>
<body ng-app="webApp" ng-controller="distributionProportionCtr" ng-cloak>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote layui-quote-nm">
            内部结项得分{{score | number : 2}}分
        </blockquote>

        <fieldset class="layui-elem-field">
            <legend>成员当期工时</legend>
            <div style="margin: 15px;">
                <span ng-repeat="user in projectKList.userH">{{user.userName}}：{{user.time}}h　　　</span>
            </div>
        </fieldset>

        <fieldset class="layui-elem-field">
            <legend>成员总工时</legend>
            <div style="margin: 15px;">
                <span ng-repeat="user in projectKList.userH">{{user.userName}}：{{user.totalTime}}h　　　</span>
            </div>
        </fieldset>

        <fieldset class="layui-elem-field">
            <legend>成员分配(按照新增工作量分配)</legend>
            <div style="margin: 15px;">
                <form class="layui-form layui-form-pane" action="" id="formData">
                    <div class="layui-form-item userH" ng-repeat="user in projectKList.userH">
                        <label class="layui-form-label">{{user.userName}}(%)<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="text" userName="{{user.userName}}" userId="{{user.userId}}" value="{{projectExternalInfo.projectNumber}}" lay-verify="required|isDouble|isZero" onkeyup="YZ.clearNoNum(this)" onblur="YZ.clearNoNum(this)" placeholder="请输入{{user.userName}}的比例" autocomplete="off" class="layui-input" maxlength="50">
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
        </fieldset>
    </div>

</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("distributionProportionCtr", function($scope,$http,$timeout){
        $scope.projectExternalId = YZ.getUrlParam("projectExternalId"); //外部项目ID
        $scope.projectRecordId = YZ.getUrlParam("projectRecordId"); // 可分配记录ID
        $scope.score = YZ.getUrlParam("score"); // 内部结项得分
        $scope.projectKList = null; //存放k值分配 和 耗时
        //获取外部项目 k值分配 和 耗时
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectK/getKAndUser", {projectRecordId : $scope.projectRecordId, type : 0} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.projectKList = result.data;
            }
        });

        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            //自定义验证规则
            form.verify({
                isDouble: function(value) {
                    if(value.length > 0 && !YZ.isDouble.test(value)) {
                        return "请输入一个整数或小数";
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
                var jsonArray = new Array();
                var sum = 0;
                $(".userH").each(function () {
                    var json = {
                        projectRecordId : $scope.projectRecordId,
                        userId : $(this).find("input").attr("userId"),
                        userName : $(this).find("input").attr("userName"),
                        ratio : $(this).find("input").val(),
                    };
                    sum = (sum + Number($(this).find("input").val()));
                    jsonArray.push(json);
                });
                if (sum != 100) {
                    layer.msg('成员比例相加必须等于100%，当前' + sum, {icon: 2, anim: 6});
                    return false;
                }

                console.log(jsonArray);

                YZ.ajaxRequestData("post", false, YZ.ip + "/projectK/save", {projectKs : JSON.stringify(jsonArray)} , null , function(result) {
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
