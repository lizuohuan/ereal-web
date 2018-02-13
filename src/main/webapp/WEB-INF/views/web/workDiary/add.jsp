<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加传递卡</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>添加传递卡</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">工作日期<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="workTime" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this, max: laydate.now()})" readonly>
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

        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            //监听提交
            form.on('submit(demo1)', function(data) {
                var date = new Date();
                var timeStr = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
                var hours = date.getHours() + ":" + date.getMinutes();
                var workTime = new Date(data.field.workTime).getFullYear() + "-" + (new Date(data.field.workTime).getMonth() + 1) + "-" + new Date(data.field.workTime).getDate();
                console.log(data.field.workTime);
                console.log(timeStr);
                console.log(hours);
                /*if (workTime == timeStr && hours < "18:00") {
                    layer.msg('请在18:00之后添加今天的传递卡.', {icon: 2, anim: 6});
                    return false;
                }*/
                data.field.workTime = new Date(data.field.workTime);
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/workDiary/addWorkDiary", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('添加传递卡成功.', {
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
