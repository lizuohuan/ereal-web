<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>进行周验收</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp" ng-controller="weekAcceptanceCtr" ng-cloak>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>进行周验收</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">总进度(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="progress" lay-verify="required|isNumber|isZero" placeholder="请输入总进度" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="lastAcceptances.progress != null">(上次进度为{{lastAcceptances.progress}}%)</div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">P着力点(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="p" lay-verify="required|isNumber|isHundred" placeholder="请输入着力点" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="lastAcceptances.p != null">(上次P着力点{{lastAcceptances.p}}%)</div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">A战略(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="a" lay-verify="required|isNumber|isHundred" placeholder="请输入战略" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="lastAcceptances.a != null">(上次A战略{{lastAcceptances.a}}%)</div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">N文字水平(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="n" placeholder="请输入文字水平" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="lastAcceptances.n != null">(上次N文字水平{{lastAcceptances.n}}%)</div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">E简单可操作性(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="e" placeholder="请输入简单可操作性" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="lastAcceptances.e != null">(上次E简单可操作性{{lastAcceptances.e}}%)</div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">L系统逻辑性(%)<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="l" placeholder="请输入系统逻辑性" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux" ng-show="lastAcceptances.l != null">(上次L系统逻辑性{{lastAcceptances.l}}%)</div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-inline">
                    <textarea type="text" name="remarks" lay-verify="" placeholder="请输入备注" autocomplete="off" class="layui-textarea"></textarea>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">是否结项</label>
                <div class="layui-input-inline">
                    <input type="radio" name="isFinish" value="0" checked title="否">
                    <input type="radio" name="isFinish" value="1"  title="是">
                </div>
            </div>

            <input name="id" type="hidden" id="id">
            <input name="projectInteriorId" type="hidden" id="projectInteriorId">

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
        webApp.controller("weekAcceptanceCtr", function($scope,$http,$timeout){
            $("#id").val(YZ.getUrlParam("projectInteriorWeekAcceptanceId"));
            $("#projectInteriorId").val(YZ.getUrlParam("projectInteriorId"));
            var atHome = YZ.getUrlParam("atHome"); // 获取是否是对内或者对外
            $scope.lastAcceptances = JSON.parse(localStorage.getItem("lastAcceptances"));
            console.log($scope.lastAcceptances);
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
                    },
                    isHundred : function (value) {
                        if(value < 0 || value > 1000) {
                            return "请输入(0-1000)";
                        }
                    }
                });

                $("input[name='progress']").bind('input propertychange', function() {
                    if ($(this).val() < 50) {
                        $("input[name='p']").parent().parent().show();
                        $("input[name='a']").parent().parent().show();
                        $("input[name='n']").parent().parent().hide();
                        $("input[name='e']").parent().parent().hide();
                        $("input[name='l']").parent().parent().hide();
                        $("input[name='n']").removeAttr("lay-verify");
                        $("input[name='e']").removeAttr("lay-verify");
                        $("input[name='l']").removeAttr("lay-verify");
                    }
                    else if (atHome == 0) {
                        //alert(atHome); //TODO atHome = null 明天来验证
                        $("input[name='p']").parent().parent().show();
                        $("input[name='a']").parent().parent().show();
                        $("input[name='e']").parent().parent().show();
                        $("input[name='l']").parent().parent().show();
                        $("input[name='n']").parent().parent().hide();
                        $("input[name='n']").removeAttr("lay-verify");
                        $("input[name='e']").attr("lay-verify", "required|isNumber|isHundred");
                        $("input[name='l']").attr("lay-verify", "required|isNumber|isHundred");
                    }
                    else {
                        //alert(atHome);
                        $("input[name='p']").parent().parent().show();
                        $("input[name='a']").parent().parent().show();
                        $("input[name='n']").parent().parent().show();
                        $("input[name='e']").parent().parent().show();
                        $("input[name='l']").parent().parent().show();
                        $("input[name='n']").attr("lay-verify", "required|isNumber|isHundred");
                        $("input[name='e']").attr("lay-verify", "required|isNumber|isHundred");
                        $("input[name='l']").attr("lay-verify", "required|isNumber|isHundred");
                    }
                });

                //监听提交
                form.on('submit(demo1)', function(data) {
                    console.log(data.field);
                    YZ.ajaxRequestData("post", false, YZ.ip + "/projectInteriorWeekAcceptance/update", data.field , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            layer.alert('周验收成功.', {
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
