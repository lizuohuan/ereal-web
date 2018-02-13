<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>月度K王</title>

    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .name{font-size: 16px;font-weight: bold;margin-top: 15px;}
        .title{font-size: 12px;margin-top: 15px;color: #0c9076}
        .avatar{border-radius: 50%;width: 80px;height: 80px;}
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

    <!--月度K王-->
    <div id="kWang"></div>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    //默认本月
    window.onload = function () {
        var date = new Date();
        $("#month").val(date.getFullYear() + "-" + (date.getMonth() + 1));
    }
    theKingOfMonthly(new Date());

    function initData() {
        var month = $("#month").val();
        if (month == "") {
            month = new Date();
        }
        else {
            month = new Date(month);
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        theKingOfMonthly(month);
        layer.close(index);
    }

    //获取月度K王
    function theKingOfMonthly (date) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/statistics/staticsMaxK", {month : date} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var html = "";
                if (result.data.length == 0) {
                    html += '<fieldset class="layui-elem-field" style="width: 33%;float: left;">' +
                                '<legend>月度K王</legend>' +
                                    '<div class="layui-field-box layui-form" style="text-align: center">' +
                                    '<img id="avatar" class="avatar" src="' + YZ.ip + '/resources/img/0.jpg" /><div class="name">--</div>' +
                                    '<div class="title">--</div><br>' +
                                '</div>' +
                            '</fieldset>';
                }
                for (var i = 0; i < result.data.length; i++) {
                    result.data[i].avatar = result.data[i].avatar == "" || result.data[i].avatar == null ? YZ.ip + "/resources/img/0.jpg" : YZ.ipImg + "//" +result.data[i].avatar;
                    html += '<fieldset class="layui-elem-field" style="width: 33%;float: left;">' +
                                '<legend>月度K王</legend>' +
                                '<div class="layui-field-box layui-form" style="text-align: center">' +
                                    '<img id="avatar" class="avatar" src="' + result.data[i].avatar + '" /><div class="name">' + result.data[i].name + '</div>' +
                                    '<div class="title">' + result.data[i].departmentName + "&nbsp;&nbsp;-&nbsp;&nbsp;" + result.data[i].roleName + '</div><br>' +
                                    '<div class="title">K值：'  + "&nbsp;&nbsp;&nbsp;&nbsp;" + result.data[i].totalK + '</div><br>' +
                                    '<div class="title"><button type="button" onclick="issue(' + result.data[i].id + ', \'' + result.data[i].name + '\')" class="layui-btn layui-btn-warm layui-btn-small">确认发布</button></div><br>' +
                                '</div>' +
                            '</fieldset>';
                }
                $("#kWang").html(html);
            }
        });
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

    });

    //确认发布
    function issue (userId, userName) {
        if ($("#month").val() == "") {
            layer.msg('时间不能为空.', {icon: 2, anim: 6});
            return false;
        }
        layer.confirm("是否确定发布<span style=\"color: red;font-weight: bold\">&nbsp;" + userName + "&nbsp;</span>为月度K王？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/awards/addMaxK", {userId : userId, time : YZ.getTimeStamp($("#month").val())} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('发布成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
                        layer.close(index);
                    });
                }
            });
        }, function(){
            //layer.msg('已取消.', {icon: 2});
        });
    }

</script>
</body>
</html>
