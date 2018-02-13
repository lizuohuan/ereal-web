<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>授权审批权限</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .userInfo{
            min-width: 100px;
            text-align: center;
            padding: 10px;
            float: left;
        }
        .userInfo img{
            width: 60px;
            height: 60px;
            border-radius: 50%;
        }
        .hint{color: #5FB878;font-size: 12px;}
        .layui-form-label{width: 200px !important;}
        .layui-input-block{margin-left: 230px !important;}
    </style>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote">授权审批权限&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></blockquote>
    <form class="layui-form" action="" id="formData">

        <fieldset class="layui-elem-field">
            <legend>日志审批授权</legend>
            <div class="layui-field-box">
                <div class="layui-form-item">
                    <label class="layui-form-label">选择人员<span class="font-red">*</span></label>
                    <div class="layui-input-block">
                        <button type="button" class="layui-btn layui-btn-small layui-btn-radius layui-btn-normal" onclick="selectUser(2)">选择人员</button>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">被授权人</label>
                    <div class="layui-input-block">
                        <div id="userInfo"></div>
                    </div>
                </div>
            </div>
            <input type="hidden" name="toUserIds" id="toUserIds">

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="button" class="layui-btn" onclick="logSubmit()">立即保存</button>
                </div>
            </div>
        </fieldset>

    </form>
    <form class="layui-form" action="" id="formData2">

        <fieldset class="layui-elem-field">
            <legend>项目审批授权</legend>
            <div class="layui-field-box">
                <div class="layui-form-item">
                    <label class="layui-form-label">选择人员<span class="font-red">*</span></label>
                    <div class="layui-input-block">
                        <button type="button" class="layui-btn layui-btn-small layui-btn-radius layui-btn-normal" onclick="selectUser(1)">选择人员</button>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">被授权人</label>
                    <div class="layui-input-block">
                        <div id="userInfo2"></div>
                    </div>
                </div>
            </div>
            <input type="hidden" name="toUserIds" id="toUserIds2">

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="button" class="layui-btn" onclick="projectSubmit()">立即保存</button>
                </div>
            </div>
        </fieldset>

    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var form = null;
    layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
        form = layui.form(),
                layer = layui.layer;
        var works = [];
        var projects = [];
        YZ.ajaxRequestData("get", false, YZ.ip + "/accredit/queryAccredit", {} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                works = result.data.works;
                projects = result.data.projects;
            }
        });

        var selectedUserList = [];
        var checkIds = [];
        for (var i = 0; i < works.length; i++) {
            checkIds.push(works[i].toUserId);
            var user = {
                id : works[i].toUserId,
                name : works[i].userName,
                avatar : works[i].avatar,
                departmentName : works[i].departmentName,
                roleName : works[i].roleName,
            }
            selectedUserList.push(user);
        }
        //装载被授权日志权限的人
        getIsIframe(JSON.stringify(selectedUserList), checkIds, 2);
        selectedUserList = [];
        checkIds = [];
        for (var i = 0; i < projects.length; i++) {
            checkIds.push(projects[i].toUserId);
            var user = {
                id : projects[i].toUserId,
                name : projects[i].userName,
                avatar : projects[i].avatar,
                departmentName : projects[i].departmentName,
                roleName : projects[i].roleName,
            }
            selectedUserList.push(user);
        }
        //装载被授权日志权限的人
        getIsIframe(JSON.stringify(selectedUserList), checkIds, 1);


        //自定义验证规则
        form.verify({

        });

        form.render();

    });

    //日志授权提交
    function logSubmit() {
        if ($("#toUserIds").val() == "") {
            layer.msg('请选择被授权人.', {icon: 2, anim: 6});
            return false;
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        var arr = {
            toUserIds : $("#toUserIds").val(),
            type : 2
        }
        YZ.ajaxRequestData("post", false, YZ.ip + "/accredit/addAccredit", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var index2 = layer.alert('保存成功.', {
                    skin: 'layui-layer-molv' //样式类名
                    ,closeBtn: 0
                    ,anim: 4 //动画类型
                }, function(){
                    layer.close(index2);
                    setTimeout(function () {layer.close(index);}, 600);
                });
            }
        });
    }

    //日志授权提交
    function projectSubmit() {
        if ($("#toUserIds2").val() == "") {
            layer.msg('请选择被授权人.', {icon: 2, anim: 6});
            return false;
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        var arr = {
            toUserIds : $("#toUserIds2").val(),
            type : 1
        }
        YZ.ajaxRequestData("post", false, YZ.ip + "/accredit/addAccredit", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var index2 = layer.alert('保存成功.', {
                    skin: 'layui-layer-molv' //样式类名
                    ,closeBtn: 0
                    ,anim: 4 //动画类型
                }, function(){
                    layer.close(index2);
                    setTimeout(function () {layer.close(index);}, 600);
                });
            }
        });
    }

    //选择人员
    function selectUser (type) {
        layer.open({
            type: 2,
            title: '选择人员',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['600px', '600px'],
            scrollbar: false, //屏蔽浏览器滚动条
            content: YZ.ip + "/page/accredit/selectUser?accreditType=" + type
        });
    }

    /**
     * 提供给子页面调用获取选择的组员集合信息
     */
    function getIsIframe(userJson, checkIds, type) {
        console.log(checkIds);
        console.log(JSON.parse(userJson));
        var userList = JSON.parse(userJson);
        var html = "";
        for (var i = 0; i < userList.length; i++) {
            userList[i].avatar = userList[i].avatar == "null" || userList[i].avatar == null ? "resources/img/0.jpg" : userList[i].avatar;
            html += "<div class=\"userInfo\">" +
                    "<img src=\"" + YZ.ip + "\\" + userList[i].avatar + "\">" +
                    "<div><br>" + userList[i].name + "</div>" +
                    "<div><br><span class='hint'>" + userList[i].departmentName + "--" + userList[i].roleName + "</span></div>" +
                    "<div><br><button type='button' onclick=\"deleteUser(" + userList[i].id + ", this, " + type + ")\" class=\"layui-btn layui-btn-small layui-btn-danger\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button></div>" +
                    "</div>";

        }
        if (type == 2) {
            $("#toUserIds").val(checkIds);
            $("#userInfo").html(html);
        }
        else {
            $("#toUserIds2").val(checkIds);
            $("#userInfo2").html(html);
        }

        form.render();//重新渲染form
    }

    //删除一个人员
    function deleteUser(id, obj, type) {
        var index = layer.confirm("是否确认删除？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            //删除userID
            var numbers = "";
            if (type == 2) {
                numbers = $("#toUserIds").val();
            }
            else {
                numbers = $("#toUserIds2").val();
            }
            numbers = numbers.split(",");
            console.log(numbers);
            for (var i = 0; i < numbers.length; i++) {
                if (numbers[i] == id) {
                    numbers.splice(i, 1);
                    break;
                }
            }
            if (type == 2) {
                $("#toUserIds").val(numbers); //重新设置组员
            }
            else {
                $("#toUserIds2").val(numbers); //重新设置组员
            }
            layer.close(index);
            $(obj).parent().parent().fadeOut();
        }, function(){});
    }

</script>
</body>
</html>
