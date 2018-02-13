<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>颁发奖项</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>颁发奖项</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">类型<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="type" lay-verify="required" lay-filter="type">
                        <option value="">选择类型</option>
                        <option value="0">个人奖项</option>
                        <option value="1">团队奖项</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">选择奖项<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select id="customAwardsId" name="customAwardsId"  lay-search="" lay-verify="required">
                        <option value="">选择或搜索</option>
                        <option value="0" disabled>暂无</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">选择获奖者<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select id="targetId" name="targetId"  lay-search="" lay-verify="required">
                        <option value="">选择或搜索</option>
                        <option value="0" disabled>暂无</option>
                    </select>
                </div>
            </div>

            <div class="layui-inline">
                <label class="layui-form-label">时间</label>
                <div class="layui-input-block">
                    <input class="layui-input" id="month" name="month" placeholder="时间" lay-verify="required"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM'})" readonly>
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

        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            //自定义验证规则
            form.verify({

            });




            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.month = new Date(data.field.month).getTime();

                if(data.field.customAwardsId == 0 || data.field.customAwardsId == ''){
                    layer.msg("没有选择奖项");
                    return false;
                }
                if(data.field.targetId == 0 || data.field.targetId == ''){
                    layer.msg("没有选择获奖者");
                    return false;
                }
                console.log(data);
                YZ.ajaxRequestData("post", false, YZ.ip + "/offerAward/addAwards", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('操作成功.', {
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

            //获奖者过滤器
            form.on('select(type)', function(data){
                console.log(data.value);
                if(data == ''){
                    return;
                }
                var html = "";
                var awardsNameHtml = "";
                YZ.ajaxRequestData("post", false, YZ.ip + "/customAwards/queryCustomAwardsByType", {type:data.value} , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        if(result.data != undefined && result.data.length > 0){
                            for (var i = 0; i < result.data.length; i++){
                                awardsNameHtml += "<option value='"+result.data[i].id+"'>"+result.data[i].awardsName+"</option>";
                            }
                        }
                    }
                });
                if(data.value == 0){
                    // 查询所有用户 除了管理员
                    YZ.ajaxRequestData("post", false, YZ.ip + "/user/queryAllUser", null , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            console.log(result.data);
                            if(result.data != undefined && result.data.length > 0){
                                for (var i = 0; i < result.data.length; i++){
                                    var targetName = result.data[i].name +
                                            "("+result.data[i].departmentName+"-"+result.data[i].companyName+")";
                                    html += "<option value='"+result.data[i].id+"'>"+targetName+"</option>";
                                }
                            }
                        }
                    });

                }
                else if(data.value == 1){
                    // 查询所有部门
                    YZ.ajaxRequestData("post", false, YZ.ip + "/department/queryAllDepartment", null , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            if(result.data != undefined && result.data.length > 0){
                                console.log(result.data);
                                for (var i = 0; i < result.data.length; i++){
                                    var targetName = result.data[i].departmentName +
                                            "("+result.data[i].companyName+")";
                                    html += "<option value='"+result.data[i].id+"'>"+targetName+"</option>";
                                }
                            }
                        }
                    });
                }
                if(awardsNameHtml.length == 0){
                    awardsNameHtml = '<option value="0" disabled>暂无</option>';
                }

                if(html.length == 0){
                    html = '<option value="0" disabled>暂无</option>';
                }

                $("#targetId").html(html);
                $("#customAwardsId").html(awardsNameHtml);
                form.render();
            });
            form.render(); //重新渲染
        });


    </script>
</body>
</html>
