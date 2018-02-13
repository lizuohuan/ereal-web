<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>评分一次</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>评分一次</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">选择部门<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="departmentId" lay-verify="required" lay-search="" lay-filter="department">
                    <option value="">选择或搜索部门</option>
                </select>
            </div>
        </div>

        <%--<div class="layui-form-item">
            <label class="layui-form-label">针对时间类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="timeType">
                    <option value="">请选择</option>
                    <option value="0">周</option>
                    <option value="1">月</option>
                </select>
            </div>
        </div>--%>

        <div class="layui-form-item">
            <label class="layui-form-label">针对月份<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="targetTime" lay-verify="required" placeholder="请选择针对月份" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">总经理评分<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="managerGrade" lay-verify="required|isZero" placeholder="请输入总经理评分" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">值总评分<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="dutyGrade" lay-verify="required|isZero" placeholder="请输入值总评分" autocomplete="off" class="layui-input" maxlength="10">
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

    layui.use(['form', 'layedit', 'laydate'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        if (YZ.getUserInfo().roleId == 3) {
            $("input[name='managerGrade']").parent().parent().show();
            $("input[name='dutyGrade']").parent().parent().hide();
            $("input[name='dutyGrade']").removeAttr("lay-verify");
            $("input[name='managerGrade']").attr("lay-verify", "required|isZero");
        }
        else if (YZ.getUserInfo().roleId == 5) {
            $("input[name='managerGrade']").parent().parent().hide();
            $("input[name='dutyGrade']").parent().parent().show();
            $("input[name='managerGrade']").removeAttr("lay-verify");
            $("input[name='dutyGrade']").attr("lay-verify", "required|isZero");
        }

        getAllDepartment(0);

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
            data.field.time = new Date(data.field.targetTime);
            data.field.timeType = 1;
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondTarget/addSecondTargetScore", data.field , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    layer.alert('添加成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
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
</script>
</body>
</html>
