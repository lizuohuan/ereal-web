<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>使用协议</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>使用协议</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editAgreementCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">标题 <span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="title" value="{{agreement.title}}" lay-verify="required" placeholder="请输入标题" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">内容<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea name="context" class="layui-textarea" id="LAY_demo1" style="display: none"></textarea>
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
    webApp.controller("editAgreementCtr", function($scope,$http,$timeout){
        $scope.agreement = null; //协议信息
        YZ.ajaxRequestData("post", false, YZ.ip + "/agreement/getAgreement", {} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.agreement = result.data[0];
                $("#LAY_demo1").html($scope.agreement.content);
            }
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit;

            //添加富文本编辑器的上传图片接口
            layedit.set({
                uploadImage: {
                    url: YZ.ip + "/res/upload", //上传接口
                    type: 'post', //默认post
                }
            });

            //自定义验证规则
            form.verify({
                isNumber: function(value) {
                    if(value.length > 0 && !YZ.isNumber.test(value)) {
                        return "请输入一个整数";
                    }
                },
            });

            //构建一个默认的编辑器
            var index = layedit.build('LAY_demo1');

            form.render();

            //监听提交
            form.on('submit(demo1)', function(data) {

                data.field.content = layedit.getContent(index);
                if (data.field.content == "") {
                    layer.msg('请输入内容.', {icon: 2,anim: 6});
                    return false;
                }
                data.field.id = $scope.agreement.id;
                console.log(data.field);

                YZ.ajaxRequestData("post", false, YZ.ip + "/agreement/updateAgreement", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('修改成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            location.reload();
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
