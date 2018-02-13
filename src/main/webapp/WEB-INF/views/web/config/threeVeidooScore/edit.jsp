<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改第三维评分</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改第三维评分</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editThreeVeidooCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">选择指标<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="threeVerdooId" lay-verify="required" lay-search="" lay-filter="threeVerdoo">
                    <option value="">选择或搜索指标</option>
                </select>
            </div>
        </div>

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
            <label class="layui-form-label">选择针对员工<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="userId" lay-verify="required" lay-search="">
                    <option value="">选择或搜索员工</option>
                </select>
            </div>
        </div>

        <%--<div class="layui-form-item layui-hide">
            <label class="layui-form-label">选择类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required">
                    <option value="">请选择类型</option>
                    <option value="0">周打分</option>
                    <option value="1">月打分</option>
                </select>
            </div>
        </div>--%>

        <div class="layui-form-item">
            <label class="layui-form-label">评分数<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="score" value="{{threeVeidooScore.score}}" lay-verify="required|isDouble" placeholder="请输入评分数" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="monthTime" value="{{ threeVeidooScore.monthTime | date:'yyyy-MM'}}" lay-verify="required" placeholder="请选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="msg" class="layui-textarea" placeholder="请输入备注">{{threeVeidooScore.msg}}</textarea>
            </div>
        </div>

        <input type="hidden" id="weight">

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

    //获取角色列表
    function getThreeVeidoo(selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/threeVeidoo/selectList", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索指标</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        $("#weight").val(result.data[i].weight); //特殊处理 赋值权重
                        html += "<option selected=\"selected\" title=\"" + result.data[i].weight + "\" value=\"" + result.data[i].id + "\">" + result.data[i].targetName + "</option>";
                    }
                    else {
                        html += "<option title=\"" + result.data[i].weight + "\" value=\"" + result.data[i].id + "\">" + result.data[i].targetName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='threeVerdooId']").html(html);
                $("select[name='threeVerdooId']").parent().parent().show();
            }
        });
    }

    var webApp=angular.module('webApp',[]);
    webApp.controller("editThreeVeidooCtr", function($scope,$http,$timeout){
        $scope.threeVeidooScore = JSON.parse(localStorage.getItem("threeVeidooScore")); //目标配置信息
        console.log($scope.threeVeidooScore);
        layui.use(['form', 'layedit', 'laydate'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            getThreeVeidoo($scope.threeVeidooScore.threeVerdooId);

            getCompanyListType(null, $scope.threeVeidooScore.companyId);
            getDepartmentListType($scope.threeVeidooScore.companyId, null, null, $scope.threeVeidooScore.departmentId);
            getDepartmentIdUser($scope.threeVeidooScore.departmentId, $scope.threeVeidooScore.userId);

            //自定义验证规则
            form.verify({
                isDouble: function(value) {
                    if(value.length > 0 && !YZ.isDouble.test(value)) {
                        return "请输入一个整数或小数";
                    }
                },
                isZero : function (value) {
                    if(value < 0 || value > 10) {
                        return "请输入(0-10)";
                    }
                }
            });

            form.on('select(threeVerdoo)', function(data) {
                console.log(data.elem[data.elem.selectedIndex].title);
                $("#weight").val(data.elem[data.elem.selectedIndex].title);
                $("input[name='score']").attr("placeholder", "请输入(0-" + data.elem[data.elem.selectedIndex].title + ")");
                form.render();
            });
            form.render();

            //监听提交
            form.on('submit(demo1)', function(data) {
                if (Number(data.field.score) < 0 || Number(data.field.score) > Number($("#weight").val())) {
                    layer.msg('评分请输入(0-' + $("#weight").val() + ')', {icon: 2, anim: 6});
                    $("input[name='score']").focus();
                    return false;
                }
                data.field.id = $scope.threeVeidooScore.id;
                data.field.monthTime = new Date(data.field.monthTime);
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/threeVeidooScore/update", data.field , null , function(result) {
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
