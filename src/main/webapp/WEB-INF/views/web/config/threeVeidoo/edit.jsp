<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改第三维配置</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改第三维配置</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editThreeVeidooCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">指标名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" disabled name="targetName" value="{{threeVeidoo.targetName}}" lay-verify="required" placeholder="请输入指标名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">指标权重<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="weight" value="{{threeVeidoo.weight}}" lay-verify="required|isDouble|isZero" placeholder="请输入指标权重" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">描述</label>
            <div class="layui-input-inline">
                <textarea name="describe" disabled lay-verify="" placeholder="请输入描述" autocomplete="off" class="layui-textarea" maxlength="200">{{threeVeidoo.describe}}</textarea>
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
    webApp.controller("editThreeVeidooCtr", function($scope,$http,$timeout){
        $scope.threeVeidoo = JSON.parse(localStorage.getItem("threeVeidoo")); //目标配置信息
        console.log($scope.threeVeidoo);
        layui.use(['form', 'layedit', 'laydate'], function() {
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
                data.field.id = $scope.threeVeidoo.id;
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/threeVeidoo/update", data.field , null , function(result) {
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
