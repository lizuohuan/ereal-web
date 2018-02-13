<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改员工请假记录</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改员工请假记录</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editMonthDaysUserCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">选择公司<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="companyId" name="companyId" lay-filter="company" lay-search="" lay-verify="required">
                    <option value="">选择或搜索公司</option>
                    <option value="0" disabled>暂无</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">选择部门<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="departmentId" name="departmentId" lay-filter="departmentId" lay-search="" lay-verify="required">
                    <option value="">选择或搜索部门</option>
                    <option value="0" disabled>暂无</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">选择员工<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="userId" name="userId" lay-search="" lay-verify="required">
                    <option value="">选择或搜索员工</option>
                    <option value="0" disabled>暂无</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">选择配置的月份<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="monthDaysId" lay-search="" lay-verify="required">
                    <option value="">选择配置的月份</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">天数<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="dayNum" value="{{monthDaysLeave.dayNum}}" lay-verify="required|isNumber|isZero" placeholder="请输入天数" autocomplete="off" class="layui-input" maxlength="10">
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
    webApp.controller("editMonthDaysUserCtr", function($scope,$http,$timeout){
        $scope.monthDaysLeave = JSON.parse(localStorage.getItem("monthDaysLeave")); //目标配置信息
        layui.use(['form', 'layedit', 'laydate'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            getCompanyListType(null, $scope.monthDaysLeave.companyId);
            getDepartmentListType($scope.monthDaysLeave.companyId, null, null, $scope.monthDaysLeave.departmentId);
            getDepartmentIdUser($scope.monthDaysLeave.departmentId, $scope.monthDaysLeave.userId);
            listForSelect($scope.monthDaysLeave.monthDaysId);

            //公司过滤器
            form.on('select(company)', function(data){
                console.log(data);
                getDepartmentListType(Number(data.value), null, null, 0);
                $("select[name='userId']").parent().parent().hide();
                form.render();
            });

            //部门过滤器
            form.on('select(departmentId)', function(data){
                console.log(data);
                getDepartmentIdUser(Number(data.value), 0);
                form.render();
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
                console.log(data.field);
                data.field.id = $scope.monthDaysLeave.id;
                YZ.ajaxRequestData("post", false, YZ.ip + "/monthDaysUser/update", data.field , null , function(result) {
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

    /**
     * 获取配置列表
     * @return
     */
    function listForSelect(selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/monthDays/listForSelect", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索配置</option>";
                for (var i = 0; i < result.data.length; i++) {
                    result.data[i].dateTime = new Date(result.data[i].dateTime).format("yyyy-MM");
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].dateTime + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].dateTime + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='monthDaysId']").html(html);
                $("select[name='monthDaysId']").parent().parent().show();
            }
        });
    }

</script>
</body>
</html>
