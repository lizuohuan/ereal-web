<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加应出勤天数</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加应出勤天数</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">月份<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="dateTime" lay-verify="required" placeholder="请选择月份" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">应出勤天数<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="days" lay-verify="required|isNumber|isZero" placeholder="请输入应出勤天数" autocomplete="off" class="layui-input" maxlength="10">
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

        getAllDepartment(0);

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
            }
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.dateTime = new Date(data.field.dateTime);
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/monthDays/save", data.field , null , function(result) {
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
