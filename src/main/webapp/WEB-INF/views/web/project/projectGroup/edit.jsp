<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改项目组</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
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
        .hint{color: #1AA094;font-size: 12px;display: none}
    </style>
</head>
<body ng-app="webApp">
    <div style="margin: 15px;" ng-controller="projectGroupCtr" ng-cloak>
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>修改项目组</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">所属团队<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="departmentId" lay-verify="required" lay-search="" >
                        <option value="">选择或搜索团队</option>
                    </select>
                        <%--<input type="text"  value="{{projectGroupInfo.departmentName}}" lay-verify="required"  autocomplete="off" class="layui-input" disabled>--%>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">选择部门筛选队员<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="departmentSearch" lay-verify="required" lay-search="" lay-filter="department">
                        <option value="">选择或搜索团队</option>
                    </select>
                        <%--<input type="text"  value="{{projectGroupInfo.departmentName}}" lay-verify="required"  autocomplete="off" class="layui-input" disabled>--%>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">选择组员<span class="font-red">*</span></label>
                <div class="layui-input-block">
                    <div id="userInfo"></div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label"></label>
                <div class="layui-input-inline">
                    <div>
                        <button id="selectMemberBtn" type="button" class="layui-btn layui-btn-small layui-btn-normal" onclick="selectMember()">点击选择组员</button>
                    </div>
                    <div class="hint">请设置一个项目经理.</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">项目组名称<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="projectName" value="{{projectGroupInfo.projectName}}" lay-verify="required" placeholder="请输入项目组名称" autocomplete="off" class="layui-input">
                </div>
            </div>

            <input type="hidden" name="member" id="member">
            <input type="hidden" name="projectManagerId" id="projectManagerId" value="{{projectGroupInfo.projectManagerId}}">

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
        var projectGroupId = YZ.getUrlParam("projectGroupId");
        var maxForm = null;
        var webApp=angular.module('webApp',[]);
        webApp.controller("projectGroupCtr", function($scope,$http,$timeout) {
            $scope.projectGroupInfo = null; //分组详情
            YZ.ajaxRequestData("get", false, YZ.ip + "/projectGroup/info", {id : projectGroupId} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    $scope.projectGroupInfo = result.data;
                }
            });
            initProjectManagerId = $scope.projectGroupInfo.projectManagerId;
            layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
                var form = layui.form(),
                        layer = layui.layer,
                        laydate = layui.laydate;
                maxForm = form;
                //自定义验证规则
                form.verify({

                });

                getAllDepartment($scope.projectGroupInfo.departmentId);

                queryDepartmentByCompany(0,'departmentSearch',null,null,null);
                var selectedUserList = [];
                var checkIds = [];
                for (var i = 0; i < $scope.projectGroupInfo.members.length; i++) {
                    checkIds.push($scope.projectGroupInfo.members[i].id);
                    var user = {
                        id : $scope.projectGroupInfo.members[i].id,
                        name : $scope.projectGroupInfo.members[i].name,
                        img : $scope.projectGroupInfo.members[i].avatar
                    }
                    selectedUserList.push(user);
                }
                getIsIframe(JSON.stringify(selectedUserList), checkIds, $scope.projectGroupInfo.projectManagerId);

                //部门过滤器
                form.on('select(department)', function(data){
                    $("#selectMemberBtn").html("点击选择组员");
                    form.render('select');
                });

                form.on('radio(accountRadio)', function(data){
                    console.log(data.value); //被点击的radio的value值
                    $("#projectManagerId").val(data.value);
                });

                form.render();
                //监听提交
                form.on('submit(demo1)', function(data) {
                    if (data.field.member == "" || data.field.member == null) {
                        layer.msg('请选择组员.', {icon: 2, anim: 6});
                        return false;
                    }
                    if (data.field.projectManagerId == "" || data.field.projectManagerId == null) {
                        layer.msg('请设置一个项目经理.', {icon: 2, anim: 6});
                        return false;
                    }
//                    delete data.field["departmentId"];
                    data.field.id = $scope.projectGroupInfo.id;
                    console.log(data.field);
                    YZ.ajaxRequestData("post", false, YZ.ip + "/projectGroup/update", data.field , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            layer.alert('修改项目组成功.', {
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
            });
        });


        //选择组员
        var selectMember = function () {
            if ($("select[name='departmentSearch']").val() == "") {
                layer.msg('请先选择部门.', {icon: 2, anim: 6});
                return false;
            }
            layer.open({
                type: 2,
                title: '选择组员',
                shadeClose: true,
                maxmin: false, //开启最大化最小化按钮
                area: ['600px', '600px'],
                scrollbar: false, //屏蔽浏览器滚动条
                content: YZ.ip + "/page/project/projectGroup/selectMember?departmentId=" + $("select[name='departmentSearch']").val() + "&ids=" + $("#member").val()
            });
        }

        /**
         * 提供给子页面调用获取选择的组员集合信息
         */
        function getIsIframe(userJson, checkIds, projectManagerId) {
            console.log(checkIds);
            console.log("projectManagerId : " + projectManagerId);
            console.log(JSON.parse(userJson));
            var userList = JSON.parse(userJson);
            var html = "";
            for (var i = 0; i < userList.length; i++) {
                var imgUrl = userList[i].img == "" || userList[i].img == null ? YZ.ip+"/resources/img/0.jpg" : YZ.ipImg + "//" + userList[i].img;
                if (userList[i].id == projectManagerId) {
                    html += "<div class=\"userInfo\">" +
                            "<img src=\"" + imgUrl + "\">" +
                            "<div><input lay-filter=\"accountRadio\" type=\"radio\" name=\"account\" value=\"" + userList[i].id + "\" title=\"" + userList[i].name + "\" checked></div>" +
                            "<div><button type='button' onclick=\"deleteUser(" + userList[i].id + ", this)\" class=\"layui-btn layui-btn-small layui-btn-danger\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button></div>" +
                            "</div>";
                }
                else {
                    html += "<div class=\"userInfo\">" +
                                    "<img src=\"" + imgUrl + "\">" +
                                    "<div><input lay-filter=\"accountRadio\" type=\"radio\" name=\"account\" value=\"" + userList[i].id + "\" title=\"" + userList[i].name + "\"></div>" +
                                    "<div><button type='button' onclick=\"deleteUser(" + userList[i].id + ", this)\" class=\"layui-btn layui-btn-small layui-btn-danger\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button></div>" +
                                "</div>";
                }

            }
            var ids = $("#member").val() == "" ? [] : $("#member").val().split(",");
            ids = ids.concat(checkIds);
            $("#member").val(ids.toString()); //设置已选组员
            $("#userInfo").append(html);
            $(".hint").show();
            $("#selectMemberBtn").html("重新选择组员");

            maxForm.render();//重新渲染form
        }

        //删除一个员工
        function deleteUser( id, obj) {
            $(obj).blur();
            var isManager = $(obj).parent().prev().find("input[type='radio']").is(':checked'); // 获取是否删除的项目经理
            var msg = "";
            if (isManager) msg = "项目经理";
            else msg = "普通员工";
            var index = layer.confirm("是否确认删除 ？", {
                btn: ['确定','取消'], //按钮
                title : "确认提示",
            }, function(){
                if (isManager) {
                    $("#projectManagerId").val("");
                }
                //删除userID
                var numbers = $("#member").val();
                numbers = numbers.split(",");
                console.log(numbers);
                for (var i = 0; i < numbers.length; i++) {
                    if (numbers[i] == id) {
                        numbers.splice(i, 1);
                        break;
                    }
                }
                layer.close(index);
                $("#member").val(numbers); //重新设置组员
                $(obj).parent().parent().fadeOut();
            }, function(){});
        }

    </script>
</body>
</html>
