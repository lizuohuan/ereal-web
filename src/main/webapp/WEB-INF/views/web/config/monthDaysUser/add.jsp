<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加员工本月的出勤情况</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加员工本月的出勤情况</legend>
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
            <label class="layui-form-label">天数类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required">
                    <option value="">请选择天数类型</option>
                    <%--<option value="1">请假</option>--%>
                    <option value="2">转正前上的天数</option>
                    <option value="3">月中入职未上天数</option>
                    <option value="4">离职后未上的天数</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">选择月配置<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="monthDaysId" lay-verify="required">
                    <option value="">选择或搜索月配置</option>
                    <option value="0" disabled>暂无</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">天数<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="dayNum" lay-verify="required|isDouble|isZero" placeholder="请输入天数" autocomplete="off" class="layui-input" maxlength="10">
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

        getCompanyListType(null, 0);
        listForSelect();

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

        //监听提交
        form.on('submit(demo1)', function(data) {
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/monthDaysUser/save", data.field , null , function(result) {
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
