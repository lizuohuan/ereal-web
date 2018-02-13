<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加外部项目</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .layui-form-label{width: 150px;}
        .layui-input-block{margin-left: 180px;}
    </style>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加外部项目</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">项目编号<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="projectNumber" lay-verify="required" placeholder="请输入项目编号" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="projectName" lay-verify="required" placeholder="请输入项目名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目简称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="projectNameShort" lay-verify="required" placeholder="请输入项目简称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="projectTypeId" lay-verify="required" lay-search="">
                    <option value="">请选择或搜索项目类型</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户单位名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="customerUnit" lay-verify="required" placeholder="请输入客户单位名称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户专业部门名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="customerDepartment" lay-verify="required" placeholder="请输入客户专业部门名称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">承接时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="receiveTime" lay-verify="required" placeholder="承接时间" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目启动书提交时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="submitTime" lay-verify="required" placeholder="项目启动书提交时间" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户定位<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea type="text" name="customerRemarks" lay-verify="required" placeholder="请输入客户定位" autocomplete="off" class="layui-textarea" maxlength="200"></textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">风险说明<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea type="text" name="riskRemarks" lay-verify="required" placeholder="请输入风险说明" autocomplete="off" class="layui-textarea" maxlength="200"></textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">其他市场信息备注<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea type="text" name="otherRemarks" lay-verify="required" placeholder="请输入其他市场信息备注" autocomplete="off" class="layui-textarea" maxlength="200"></textarea>
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

    //获取内部项目专业
    function getProjectTypeList () {
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectType/listSelect", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择或搜索项目类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].projectTypeName + "</option>";
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectTypeId']").html(html);
            }
        });
    }

    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;


        //自定义验证规则
        form.verify({

        });

        getProjectTypeList();

        form.render();
        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.receiveTime = new Date(data.field.receiveTime);
            data.field.submitTime = new Date(data.field.submitTime);
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/save", data.field , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    layer.alert('添加外部项目成功.', {
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
