<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>第二维度配置</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .col-xs-5{float: left; width: 50%;}
    </style>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>第二维度配置</legend>
    </fieldset>

    <div class="col-xs-5">
        <fieldset class="layui-elem-field">
            <legend>项目部</legend>
            <div class="layui-field-box" style="height: 500px;">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <label class="layui-form-label">考核方式<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="method" value="1" title="考核方式一：项目结项数/目标结项数*100%" checked>
                            <br>
                            <input type="radio" name="method" value="2" title="考核方式二：（（K内+K外）/（1.7*0.7））/目标结项数*100%">
                            <br>
                            <input type="radio" name="method" value="3" title="外部项目内部结项数 / 目标结项数 * 100%">
                            <br>
                            <input type="radio" name="method" value="4" title="外部项目外部结项数 / 目标结项数 * 100%">
                        </div>
                    </div>

                    <input type="hidden" name="id" id="id1">

                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>

                </form>
            </div>
        </fieldset>
    </div>


    <div class="col-xs-5">
        <fieldset class="layui-elem-field">
            <legend>其他职能部门</legend>
            <div class="layui-field-box" style="height: 500px;">
                <form class="layui-form" action="" id="formData1">

                    <div class="layui-form-item layui-hide">
                        <label class="layui-form-label">选择公司<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="companyId" lay-verify="required" lay-search="" lay-filter="company">
                                <option value="">选择或搜索公司</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide">
                        <label class="layui-form-label">选择部门<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="departmentId" lay-verify="required" lay-search="" lay-filter="department">
                                <option value="">选择或搜索部门</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide">
                        <label class="layui-form-label">考核方式<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="method" value="1" lay-filter="mode" title="考核方式一：完成任务数（量化的指标）/目标完成数（量化的指标）* 100%">
                            <br>
                            <input type="radio" name="method" value="2" lay-filter="mode" title="考核方式二：值总评价分数 * 值总权重 + 总经理评价分数 * 总经理权重">
                            <br>
                            <input type="radio" name="method" value="3" lay-filter="mode" title="考核方式三：指标权重 * 分数">
                            <br>
                            <input type="radio" name="method" value="4" lay-filter="mode" title="外部项目内部结项数 / 目标结项数 * 100%" disabled>
                            <br>
                            <input type="radio" name="method" value="5" lay-filter="mode" title="外部项目外部结项数 / 目标结项数 * 100%" disabled>
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide">
                        <label class="layui-form-label">总经理权重(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" name="weightManager" lay-verify="" placeholder="请输入总经理权重" autocomplete="off" class="layui-input" maxlength="5">
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide">
                        <label class="layui-form-label">值总权重(%)<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="text" name="dutyManager" lay-verify="" placeholder="请输入值总权重" autocomplete="off" class="layui-input" maxlength="5">
                        </div>
                    </div>

                    <input type="hidden" name="id" id="id2">
                    <input type="hidden" id="id3">

                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" lay-submit="" lay-filter="demo2">立即提交</button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>

                </form>
            </div>
        </fieldset>
    </div>

</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    layui.use(['form', 'layedit', 'laydate'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getCompanyListType(null, 0);

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

        //公司过滤器
        form.on('select(company)', function(data){
            console.log(data);
            $("#formData1 input[name='method']").parent().parent().hide();
            $("input[name='weightManager']").parent().parent().hide();
            $("input[name='dutyManager']").parent().parent().hide();
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidooDepartment/querySecondVeidooDepartment", {companyId : Number(data.value)} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var html = "<option value=\"\">选择或搜索部门</option>";
                    for (var i = 0; i < result.data.length; i++) {
                        html += "<option title=\"" + result.data[i].method + "," + result.data[i].id + "\" value=\"" + result.data[i].departmentId + "\">" + result.data[i].departmentName + "</option>";
                    }
                    if (result.data.length == 0) {
                        html += "<option value=\"0\" disabled>暂无</option>";
                    }
                    $("select[name='departmentId']").html(html);
                    $("select[name='departmentId']").parent().parent().show();
                }
            });
            form.render('select');
        });

        //部门过滤器
        form.on('select(department)', function(data){
            console.log(data);
            console.log(data.elem[data.elem.selectedIndex].title);
            if (data.elem[data.elem.selectedIndex].title != "null,null") {
                var method = data.elem[data.elem.selectedIndex].title.split(",");
                $("#formData1 input[name='method']").each(function () {
                    if (Number($(this).val()) == Number(method[0])) {
                        $(this).attr("checked", true);
                        $(this).click();
                    }
                });
                $("#id2").val(method[1]);
                if (Number(method[0]) == 2) {
                    YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidoo/getSecondVeidoo", {type : 2} , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            var data = result.data;
                            $("#id3").val(data.id);
                            $("input[name='weightManager']").val(data.weightManager);
                            $("input[name='dutyManager']").val(data.dutyManager);
                        }
                    });
                    $("input[name='weightManager']").attr("lay-verify", "required|isNumber");
                    $("input[name='dutyManager']").attr("lay-verify", "required|isNumber");
                    $("input[name='weightManager']").parent().parent().show();
                    $("input[name='dutyManager']").parent().parent().show();
                }
                else {
                    $("input[name='weightManager']").removeAttr("lay-verify");
                    $("input[name='dutyManager']").removeAttr("lay-verify");
                    $("input[name='weightManager']").parent().parent().hide();
                    $("input[name='dutyManager']").parent().parent().hide();
                }
            }
            else{
                $("#formData1 input[name='method']").attr("checked", false);
            }

            $("#formData1 input[name='method']").parent().parent().show();
            form.render();
        });

        form.on('radio(mode)', function(data){
            console.log(data.value); //被点击的radio的value值
            if (data.value == 2) {
                YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidoo/getSecondVeidoo", {type : 2} , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        var data = result.data;
                        $("#id3").val(data.id);
                        $("input[name='weightManager']").val(data.weightManager);
                        $("input[name='dutyManager']").val(data.dutyManager);
                    }
                });
                $("input[name='weightManager']").attr("lay-verify", "required|isNumber");
                $("input[name='dutyManager']").attr("lay-verify", "required|isNumber");
                $("input[name='weightManager']").parent().parent().show();
                $("input[name='dutyManager']").parent().parent().show();
            }
            else {
                $("input[name='weightManager']").removeAttr("lay-verify");
                $("input[name='dutyManager']").removeAttr("lay-verify");
                $("input[name='weightManager']").parent().parent().hide();
                $("input[name='dutyManager']").parent().parent().hide();
            }
        });

        //获取项目部
        YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidoo/getSecondVeidoo", {type : 1} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var data = result.data;
                $("#id1").val(data.id);
                $("#formData").find("input").each(function () {
                    if (Number($(this).val()) == Number(data.method)) {
                        console.log(Number($(this).val()) == Number(data.method));
                        $(this).attr("checked", true);
                        $(this).click();
                    }
                });
            }
        });

        form.render();


        form.on('submit(demo1)', function(data) {
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidoo/updateSecondVeidoo", data.field , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('更新成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        //location.reload();
                        layer.close(index);
                    });
                }
            });
            return false;
        });

        form.on('submit(demo2)', function(data) {
            if (data.field.method == 2) {
                var sum = Number(data.field.weightManager) + Number(data.field.dutyManager);
                if (sum != 100) {
                    layer.msg('总经理权重和值总权重比例相加必须等于100.', {icon: 2});
                    return false;
                }
            }
            console.log(data.field);
            var arr = {
                id : $("#id3").val(),
                weightManager : data.field.weightManager,
                dutyManager : data.field.dutyManager
            }
            console.log(arr);
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidooDepartment/addSecondVeidooDepartment", data.field , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    if ($("#id3").val() == "") {
                        var index = layer.alert('更新成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 3 //动画类型
                        }, function(){
                            location.reload();
                            //layer.close(index);
                        });
                    }
                    else {
                        YZ.ajaxRequestData("post", false, YZ.ip + "/secondVeidoo/updateSecondVeidoo", arr , null , function(result) {
                            if (result.flag == 0 && result.code == 200) {
                                var index = layer.alert('更新成功.', {
                                    skin: 'layui-layer-molv' //样式类名
                                    ,closeBtn: 0
                                    ,anim: 3 //动画类型
                                }, function(){
                                    location.reload();
                                    //layer.close(index);
                                });
                            }
                        });
                    }
                }
            });
            return false;
        });
    });

</script>
</body>
</html>
