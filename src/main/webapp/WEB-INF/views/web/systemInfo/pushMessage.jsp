<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>推送消息</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
    <div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>推送消息</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

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
            <label class="layui-form-label">消息标题<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="title" lay-verify="required" placeholder="请输入消息标题" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">消息内容<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <textarea type="text" name="content" lay-verify="required" placeholder="请输入消息内容" autocomplete="off" class="layui-input" maxlength="10"></textarea>
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
        layui.use(['form', 'layedit', 'laydate'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            getCompanyListType(null, 0);

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

            form.render(); //重新渲染

            //自定义验证规则
            form.verify({

            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/systemInfo/pushMessage", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('推送消息成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 3 //动画类型
                        }, function(){
                            //关闭iframe页面
                            location.reload();
                        });
                    }
                });
                return false;
            });
        });
    </script>
</body>
</html>
