<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加事务类型</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改事务类型</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">事务类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="transactionSubId" lay-verify="required" >
                    <option value="">选择事务类型</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">选择公司<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="companyId"  lay-search="" lay-filter="company">
                    <option value="">选择或搜索公司</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">选择部门<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="departmentId" lay-verify="required" lay-search="">
                    <option value="">选择或搜索部门</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">事务类型名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="jobTypeName" id="jobTypeName" lay-verify="required" placeholder="请输入事务类型名称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>


        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
    <input type="hidden" value="${id}" id="id">
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var jobType = null;

    //获取事务类型列表-- 排除内部、外部
    function getTransactionListThis (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/transactionSub/list", {isShow : 1}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择事务类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == 3 || result.data[i].id == 4) {
                        continue;
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" transactionTypeName=\"" + result.data[i].transactionTypeName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].transactionSubName + "</option>";
                    }
                    else {
                        html += "<option transactionTypeName=\"" + result.data[i].transactionTypeName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].transactionSubName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='transactionSubId']").html(html);
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

        YZ.ajaxRequestData("post", false, YZ.ip + "/jobType/queryJobType", {id:$("#id").val()}, null , function(result){
            console.log(result)
            if(result.flag == 0 && result.code == 200){
                jobType = result.data;
            }else{
                layer.alert(result.msg);
            }
        });

        getTransactionListThis(jobType.transactionSubId);
        queryAllCompany(0,"companyId",null);
        getDepartmentList(null, null,jobType.departmentId);
        $("#jobTypeName").val(jobType.jobTypeName);
        form.render('select');



        //事务过滤器
        form.on('select(transactionType)', function(data){
            if (Number(data.value) == 1) {
                $("input[name='jobTypeTime']").parent().parent().show();
                $("input[name='jobTypeTime']").attr("lay-verify", "required");
            }
            else {
                $("input[name='jobTypeTime']").removeAttr("lay-verify");
                $("input[name='jobTypeTime']").parent().parent().hide();

            }
            if (Number(data.value) < 2 ) {
                $("select[name='type']").parent().parent().show();
                $("select[name='companyId']").attr("lay-verify", "required");
                $("select[name='departmentId']").attr("lay-verify", "required");
                $("select[name='type']").attr("lay-verify", "required");
            }
            else {
                $("select[name='companyId']").removeAttr("lay-verify");
                $("select[name='departmentId']").removeAttr("lay-verify");
                $("select[name='type']").removeAttr("lay-verify");
                $("select[name='companyId']").parent().parent().hide();
                $("select[name='departmentId']").parent().parent().hide();
                $("select[name='type']").parent().parent().hide();
            }
            form.render('select');
        });

        //部门类型过滤器
        form.on('select(type)', function(data) {
            if (Number(data.value) == 0) {
                getDepartmentList(0, 0);
                $("select[name='companyId']").removeAttr("lay-verify");
                $("select[name='companyId']").parent().parent().hide();
                form.render('select');
            }
            else {
                getCompanyList();
                $("select[name='companyId']").attr("lay-verify", "required");
                form.render('select');
            }
        });

        //公司过滤器
        form.on('select(company)', function(data){
            getDepartmentList(Number(data.value));
            form.render('select');
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.transactionType = Number(data.field.transactionType);
            data.field.companyId = Number(data.field.companyId);
            data.field.departmentId = Number(data.field.departmentId);
            data.field.id = $("#id").val();
            YZ.ajaxRequestData("post", false, YZ.ip + "/jobType/updateJobType", data.field , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    layer.alert('修改事务类型成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
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
