<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>一维已发布数据</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .layui-form-label{width: 150px;}
        .layui-input-block{margin-left: 180px;}
    </style>
</head>
<body ng-app="webApp" ng-controller="editCtr" ng-cloak>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改已发布数据</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">k外<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kw" value="{{usersStatistics.kw}}" lay-verify="required" placeholder="k外" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k内<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kn" value="{{usersStatistics.kw}}" lay-verify="required" placeholder="k内" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k临时<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kl" value="{{usersStatistics.kl}}" lay-verify="required" placeholder="k临时" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k常规<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kc" value="{{usersStatistics.kc}}" lay-verify="required" placeholder="k常规" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k目标<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kmb" value="{{usersStatistics.kmb}}" lay-verify="required" placeholder="k目标" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k可比<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kkb" value="{{usersStatistics.kkb}}" lay-verify="required" placeholder="k可比" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k值完成率<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kwcl" value="{{usersStatistics.kwcl}}" lay-verify="required" placeholder="k值完成率" autocomplete="off" class="layui-input" maxlength="10">
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
    webApp.controller("editCtr", function($scope,$http,$timeout){
        $scope.usersStatistics = JSON.parse(localStorage.getItem("usersStatistics"));
        $scope.usersStatistics.kkb = $scope.usersStatistics.kkb == null ? 0 : $scope.usersStatistics.kkb;
        $scope.usersStatistics.kmb = $scope.usersStatistics.kmb == null ? 0 : $scope.usersStatistics.kmb;
        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer;

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.id = $scope.usersStatistics.id;
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/updateUserStatistics", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('修改成功.', {
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
