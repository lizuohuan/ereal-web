<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 解决layer.open 不居中问题   -->
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>选择人员</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mui/css/mui.min.css">
    <style>
        .userHead{border-radius: 50%;width: 40px;height: 40px;}
        .mui-table-view-cell.mui-checkbox input[type=checkbox], .mui-table-view-cell.mui-radio input[type=radio]{top: 16px;}
        .hint{color: #5FB878;font-size: 12px;}
        .layui-form-label{width: 200px !important;}
        .layui-input-block{margin-left: 200px !important;}
        h1, h2, h3, h4, h5, h6{margin: 0}
        .layui-colla-title{font-size: 14px;font-weight: normal;position: relative;
            height: 42px;
            line-height: 42px;
            padding: 0 15px 0 35px;
            color: #333;
            background-color: #f2f2f2;
            cursor: pointer;}
        body{background: inherit}
        .layui-colla-content{padding: 10px 0;}
        .layui-form-checkbox{display: none}
    </style>
</head>
<body>
<div style="margin: 15px;">

    <form class="layui-form layui-form-pane" action="" id="formData">

        <div class="layui-collapse" lay-filter="test">
            <div class="layui-colla-item">
                <h2 class="layui-colla-title">综合部<span style="margin-left: 100px;">10个</span></h2>
                <div class="layui-colla-content">
                    <ul class="mui-table-view">
                        <li class="mui-table-view-cell mui-indexed-list-item mui-checkbox mui-left">
                            <input type="checkbox" value="1" account="" name="" src=""/>
                            &nbsp;&nbsp;&nbsp;
                            <img ng-if="user.avatar == null" class="userHead" src="<%=imgPath%>/resources/img/0.jpg">
                            &nbsp;李世民
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <br>
        <br>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.min.js"></script>
<script>

    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),layer = layui.layer;

        var accreditType = YZ.getUrlParam("accreditType");
        console.log(accreditType);
        var arr = {
            companyId : YZ.getUserInfo().companyId,
            accreditType : accreditType
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/contacts/getContacts", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var data = result.data;
                var html = "";
                for (var i = 0; i < data.departments.length; i++) {

                    var nodeHtml = "";

                    for (var j = 0; j < data.departments[i].users.length; j++) {
                        var imgUrl = "";
                        if (data.departments[i].users[j].avatar == null || data.departments[i].users[j].avatar == "") {
                            imgUrl = '<img class="userHead" src="' + YZ.ipImg + '/resources/img/0.jpg">';
                        }
                        else {
                            imgUrl = '<img class="userHead" src="' + YZ.ipImg + '/' + data.departments[i].users[j].avatar + '">';
                        }
                        nodeHtml += '<li class="mui-table-view-cell mui-indexed-list-item mui-checkbox mui-left">' +
                                        '<input type="checkbox" value="' + data.departments[i].users[j].id + '" account="' + data.departments[i].users[j].account + '" name="' + data.departments[i].users[j].name + '" avatar="' + data.departments[i].users[j].avatar + '" departmentName="' + data.departments[i].departmentName + '" roleName="' + data.departments[i].users[j].roleName + '"/>&nbsp;&nbsp;&nbsp;' +
                                        imgUrl + '&nbsp;' + data.departments[i].users[j].name + '</li>';
                    }
                    html += '<div class="layui-colla-item">' +
                                '<h2 class="layui-colla-title">' + data.departments[i].departmentName + '<span style="margin-left: 100px;">' + data.departments[i].users.length + '个</span></h2>' +
                                '<div class="layui-colla-content layui-show">' +
                                    '<ul class="mui-table-view">' + nodeHtml + '</ul>' +
                                '</div>' +
                            '</div>';
                }
                $(".layui-collapse").html(html);
                form.render();
            }
            form.render();
        });

        form.render();
        //监听提交
        form.on('submit(demo1)', function(data) {
            var selectedUserList = [];
            var checkIds = [];
            var checkboxArray = $('input[type="checkbox"]');
            checkboxArray.each(function() {
                if ($(this).is(':checked')) {
                    checkIds.push($(this).val());
                    var user = {
                        id : $(this).val(),
                        name : $(this).attr("name"),
                        avatar : $(this).attr("avatar"),
                        departmentName : $(this).attr("departmentName"),
                        roleName : $(this).attr("roleName"),
                    }
                    selectedUserList.push(user);
                }
            });
            //提交
            if (selectedUserList.length > 0) {
                //关闭iframe页面
                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                parent.layer.close(index);
                window.parent.getIsIframe(JSON.stringify(selectedUserList), checkIds, accreditType);//调用父页面方法
            } else {
                layer.msg('请选择被授权人.', {icon: 2, anim: 6});
                return false;
            }
            return false;
        });
    });

</script>
</body>
</html>
