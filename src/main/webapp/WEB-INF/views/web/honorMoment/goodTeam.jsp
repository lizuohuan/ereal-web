<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>月度优秀团队</title>

    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .name{font-size: 16px;font-weight: bold;margin-top: 15px;}
        .title{font-size: 12px;margin-top: 15px;color: #0c9076}
        .head{background: #4BC792;
            width: 80px;
            height: 80px;
            line-height: 80px;
            border-radius: 50%;
            text-align: center;
            font-size: 30px;
            color: #fff;
            font-weight: bold;display: inline-block;}
    </style>
<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">时间</label>
                            <div class="layui-input-block">
                                <input class="layui-input" id="month" name="month" placeholder="时间" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button type="button" class="layui-btn" onclick="initData()"><i class="layui-icon">&#xe615;</i> 搜索</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <!--月度优秀团队-->
    <div id="dHtml"></div>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    //默认本月
    window.onload = function () {
        var date = new Date();
        $("#month").val(date.getFullYear() + "-" + (date.getMonth() + 1));
    }
    goodTeam(new Date());

    function initData() {
        var month = $("#month").val();
        if (month == "") {
            month = new Date();
        }
        else {
            month = new Date(month);
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        goodTeam(month);
        setTimeout(function () {layer.close(index);}, 600);
    }

    //获取优秀团队
    function goodTeam (date) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/statistics/statisticsGoodTeam", {month : date} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var html = "";
                if (result.data.length == 0) {
                    html = '<fieldset class="layui-elem-field" style="width: 33%;float: left;">' +
                                '<legend>月度优秀团队</legend>' +
                                '<div class="layui-field-box layui-form" style="text-align: center">' +
                                '<span class="head">无</span>' +
                                '<div class="name">--</div>' +
                                '<div class="name">--</div>' +
                                '<div class="title">' + date.getFullYear() + "-" + (date.getMonth() + 1) + '</div><br>' +
                                '</div>' +
                            '</fieldset>';
                }
                else {
                    for (var i = 0; i < result.data.length; i++) {
                        var sub = result.data[i].departmentName.substring(0, 1);
                        html += '<fieldset class="layui-elem-field" style="width: 33%;float: left;">' +
                                '<legend>月度优秀团队</legend>' +
                                '<div class="layui-field-box layui-form" style="text-align: center">' +
                                '<span class="head">' + sub + '</span>' +
                                '<div class="name">' + result.data[i].departmentName + '</div>' +
                                '<div class="name">' + result.data[i].score + '</div>' +
                                '<div class="title">' + date.getFullYear() + "-" + (date.getMonth() + 1) + '</div><br>' +
                                '</div>' +
                                '</fieldset>';
                    }
                }
                $("#dHtml").html(html);
            }
        });
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

    });

</script>
</body>
</html>
