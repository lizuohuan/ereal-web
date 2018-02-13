<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>权限转移</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>权限转移</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">选择部门<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="departmentId" lay-verify="required" lay-search="">
                        <option value="">请选择或搜索部门</option>
                    </select>
                </div>
            </div>

            <input type="hidden" name="id" id="id">
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

        $("#id").val(YZ.getUrlParam("id"));
        var projectId = YZ.getUrlParam("id");
        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;
            getDepartmentForProject(YZ.getUserInfo().companyId, 1, projectId,0);
            form.render();

            //监听提交
            form.on('submit(demo1)', function(data) {
                console.log(data.field);
                data.field.isPower = 1;
                YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProject", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    }
                });
                return false;
            });
        });

    </script>
</body>
</html>
