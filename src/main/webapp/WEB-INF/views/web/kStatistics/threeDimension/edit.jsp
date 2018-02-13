<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>三维已发布数据</title>
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
            <label class="layui-form-label">个人贡献(Kg)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="kg" value="{{threeUserStatistics.kg}}" lay-verify="required" placeholder="个人贡献(Kg)" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">工作学习时间增长率(Tz)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="tz" value="{{threeUserStatistics.tz}}" lay-verify="required" placeholder="工作学习时间增长率(Tz)" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">运动及集体活动(Yd)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="yd" value="{{threeUserStatistics.yd}}" lay-verify="required" placeholder="运动及集体活动(Yd)" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">热心文化会议(Hy)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="hy" value="{{threeUserStatistics.hy}}" lay-verify="required" placeholder="热心文化会议(Hy)" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">文化故事及新闻撰稿(Wx)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="wx" value="{{threeUserStatistics.wx}}" lay-verify="required" placeholder="文化故事及新闻撰稿(Wx)" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">着装及办公5S(Zb)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="zb" value="{{threeUserStatistics.zb}}" lay-verify="required" placeholder="着装及办公5S(Zb)" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">个人K文化<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="personKCulture" value="{{threeUserStatistics.personKCulture}}" lay-verify="required" placeholder="个人K文化" autocomplete="off" class="layui-input" maxlength="10">
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
        $scope.threeUserStatistics = JSON.parse(localStorage.getItem("threeUserStatistics"));
        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer;

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.id = $scope.threeUserStatistics.id;
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
