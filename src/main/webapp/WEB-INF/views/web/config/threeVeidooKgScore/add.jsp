<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加第三维K团队评分</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .userInfo{
            min-width: 100px;
            text-align: center;
            padding: 10px;
            float: left;
            border: 1px solid #e1e1e1;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        .userInfo img{
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-bottom: 10px;
        }
        .userInfo input{
            width: 100px;
        }
        .user-name{
            font-size: 12px;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加第三维K团队评分</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">选择针对员工<span class="font-red">*</span></label>
            <div class="layui-input-block" id="userList">

            </div>
        </div>

        <%--<div class="layui-form-item">
            <label class="layui-form-label">选择针对员工<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <select name="userId" lay-verify="required" lay-search="" lay-filter="user">
                    <option value="">选择或搜索员工</option>
                </select>
            </div>
        </div>--%>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input class="layui-input" id="type" readonly>
                <input type="hidden" name="type">
            </div>
        </div>

        <%--<div class="layui-form-item">
            <label class="layui-form-label">评分数<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="score" lay-verify="required|isDouble|isZero" placeholder="请输入评分数" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>--%>

        <div class="layui-form-item">
            <label class="layui-form-label">时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="date" lay-verify="required" placeholder="请选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
            </div>
        </div>

        <%--<div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="msg" class="layui-textarea" placeholder="请输入备注"></textarea>
            </div>
        </div>--%>

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

    //获取当前登录所在部门下面的所有员工
    function isDepartmentIdUserList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByCompany", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索员工</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" title=\"" + result.data[i].isProjectDepartment + "\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "(" + result.data[i].departmentName + ")</option>";
                    }
                    else {
                        html += "<option title=\"" + result.data[i].isProjectDepartment + "\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "(" + result.data[i].departmentName + ")</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='userId']").html(html);
                $("select[name='userId']").parent().parent().show();
            }
        });
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        //isDepartmentIdUserList(0);

        var html = "";
//        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByCompany", {}, null , function(result){
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/findUserPageForWeb", {departmentId : YZ.getUserInfo().departmentId}, null , function(result){
            for (var i = 0; i < result.data.length; i++) {
                var obj = result.data[i];
                obj.avatar = obj.avatar == "" || obj.avatar == null ? YZ.ip+"/resources/img/0.jpg" : YZ.ipImg + "//" + obj.avatar;
                html += '<div class="userInfo">' +
                        '   <img src="' + obj.avatar + '">' +
                        '   <div class="user-name">' + obj.name + '</div>' +
                        '   <input type="number" userId="' + obj.id +  '" name="score" class="layui-input" lay-verify="required|isDouble|isZero" placeholder="请输入评分数" maxlength="10">' +
                        '</div>';
            }
            $("#userList").html(html);
        });

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
        form.on('select(user)', function(data) {
            console.log(data.elem[data.elem.selectedIndex].title);
            $("#type").val("个人K团队得分");
            $("input[name='type']").val(1);
//            if (data.elem[data.elem.selectedIndex].title == 0) {
//                $("#type").val("职能部门个人KG得分");
//                $("input[name='type']").val(0);
//            }
//            else{
//                $("#type").val("个人K团队得分");
//                $("input[name='type']").val(1);
//            }
            $("#type").parent().parent().show();
        });

        form.render();

        //监听提交
        form.on('submit(demo1)', function(data) {
            var userDatas = []
            $("input[name='score']").each(function () {
                var userJson = {
                    userId : $(this).attr("userId"),
                    score : $(this).val()
                }
                userDatas.push(userJson);
            });
            data.field.date = YZ.getTimeStamp(data.field.date);
            data.field.dateType = 1; //默认传月
            data.field.userDatas = JSON.stringify(userDatas);
            data.field.type = 1;
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/threeVeidooKg/addThreeVeidooKg", data.field , null , function(result) {
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
