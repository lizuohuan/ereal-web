<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>全局配置</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .layui-form-pane .layui-form-label{width: 30%;}
        .layui-form-pane .layui-input-block{margin-left: 30%;}
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>全局配置</legend>
    </fieldset>
    <form class="layui-form layui-form-pane" action="" id="formData" ng-controller="editAllConfigCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">1天等于多少小时默认8.5小时<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="dayHour" lay-verify="required|isDouble" placeholder="1天等于多少小时默认8.5小时" class="layui-input" value="{{allConfig.dayHour}}">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">1K等于多少小时默认135小时<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="kHour" lay-verify="required|isDouble" placeholder="1K等于多少小时默认135小时" class="layui-input" value="{{allConfig.kHour}}">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">k目标基数<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="kTarget" lay-verify="required|isDouble" placeholder="k目标基数" class="layui-input" value="{{allConfig.kTarget}}">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">基本薪资<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="baseSalary" lay-verify="required|isDouble" placeholder="基本薪资" class="layui-input" value="{{allConfig.baseSalary}}">
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
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("editAllConfigCtr", function($scope,$http,$timeout){
        $scope.allConfig = null;
        YZ.ajaxRequestData("get", false, YZ.ip + "/allConfig/getConfig", {} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.allConfig = result.data;
            }
        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer;

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
                data.field.id = $scope.allConfig.id;
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/allConfig/updateAllConfig", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        var index = layer.alert('更新成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            //location.reload();
                            layer.close(index);
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
