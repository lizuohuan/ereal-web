<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改第三维K团队评分</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改第三维K团队评分</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editThreeVeidooKgCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">选择针对员工<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="userId" lay-verify="required" lay-filter="user" disabled>
                    <option value="">选择或搜索员工</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input class="layui-input" id="type" disabled>
                <input type="hidden" name="type">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">评分数<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="score" lay-verify="required|isDouble|isZero" value="{{threeVeidooKgScore.score}}" placeholder="请输入评分数" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input disabled type="text" name="date" lay-verify="required" placeholder="请选择时间" value="{{ threeVeidooKgScore.startTime | date:'yyyy-MM'}}" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
            </div>
        </div>

       <%-- <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="msg" class="layui-textarea" placeholder="请输入备注"></textarea>
            </div>
        </div>--%>

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

    //获取当前登录所在部门下面的所有员工
    function isDepartmentIdUserList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByCompany", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索员工</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" title=\"" + result.data[i].isProjectDepartment + "\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "(" + result.data[i].departmentName + ")</option>";
                    }
                    else {
                        html += "<option title=\"" + result.data[i].isProjectDepartment + "\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "(" + result.data[i].departmentName + ")</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='userId']").html(html);
                $("select[name='userId']").parent().parent().show();
            }
        });
    }

    var webApp=angular.module('webApp',[]);
    webApp.controller("editThreeVeidooKgCtr", function($scope,$http,$timeout){
        $scope.threeVeidooKgScore = JSON.parse(localStorage.getItem("threeVeidooKgScore"));
        console.log($scope.threeVeidooKgScore);
        layui.use(['form', 'layedit', 'laydate'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            isDepartmentIdUserList($scope.threeVeidooKgScore.userId);
            if ($scope.threeVeidooKgScore.type == 0) {
                $("#type").val("职能部门个人KG得分");
                $("input[name='type']").val(0);
                $("#type").parent().parent().show();
            }
            else {
                $("#type").val("个人K团队得分");
                $("input[name='type']").val(1);
                $("#type").parent().parent().show();
            }

            //监听提交
            form.on('select(user)', function(data) {
                console.log(data.elem[data.elem.selectedIndex].title);
                if (data.elem[data.elem.selectedIndex].title == 0) {
                    $("#type").val("职能部门个人KG得分");
                    $("input[name='type']").val(0);
                }
                else{
                    $("#type").val("个人K团队得分");
                    $("input[name='type']").val(1);
                }
                $("#type").parent().parent().show();
            });

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
                data.field.id = $scope.threeVeidooKgScore.id;
                data.field.date = YZ.getTimeStamp(data.field.date);
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/threeVeidooKg/updateThreeVeidooKg", data.field , null , function(result) {
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
