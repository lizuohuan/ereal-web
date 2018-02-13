<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>个人资料</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        div.layui-input{
            border: none;
        }
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <fieldset class="layui-elem-field" style="margin-top: 20px;">
        <legend>个人资料</legend>
        <div class="layui-field-box layui-form" ng-controller="userEditCtr" ng-cloak>

            <div class="layui-form-item">
                <label class="layui-form-label"></label>
                <div class="layui-input-inline">
                    <div class="site-demo-upload">
                        <img id="avatar" ng-if="userInfo.avatar == null" src="<%=imgPath%>/resources/img/0.jpg">
                        <img id="avatar" ng-if="userInfo.avatar != null" src="<%=imgPath%>/{{userInfo.avatar}}">
                        <div class="site-demo-upbar">
                            <div class="layui-box layui-upload-button">
                                <form target="layui-upload-iframe" method="get" key="set-mine" enctype="multipart/form-data" action="/test/upload.json">
                                    <input type="file" name="file" class="layui-upload-file" id="test">
                                </form>
                                <span class="layui-upload-icon"><i class="layui-icon"></i>上传头像</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">角色名称：</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.roleName}}</div>
                </div>
            </div>

            <div class="layui-form-item" ng-if="userInfo.companyName != null">
                <label class="layui-form-label">所属公司：</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.companyName}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">所属部门：</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.departmentName}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">账号：</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.account}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">姓名：</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" value="{{userInfo.name}}" lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input" maxlength="20">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">邮箱：</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.email}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">生日：</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{ userInfo.birthday | date:'yyyy-MM-dd'}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">电话号码：</label>
                <div class="layui-input-inline">
                    <input type="text" name="phone" value="{{userInfo.phone}}" lay-verify="required|phone" placeholder="请输入电话号码" autocomplete="off" class="layui-input" maxlength="20">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">性别：</label>
                    <div class="layui-input-inline">
                        <div class="layui-input" >
                            <span ng-if="userInfo.sex == 0">男</span>
                            <span ng-if="userInfo.sex == 1">女</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("userEditCtr", function($scope,$http,$timeout){
        $scope.userId = YZ.getUrlParam("userId");
        $scope.userInfo = null;
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/getUserById", {id : $scope.userId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.userInfo = result.data;
            }
        });
    });

    layui.use('upload', function(){
        layui.upload({
            url: YZ.ipImg + "/res/upload" //上传接口
            ,success: function(res){ //上传成功后的回调
                console.log(res);
                console.log(res.data.url);
                $("#avatar").attr("src", YZ.ip + "/" + res.data.url);
                var arr = {
                    id : YZ.getUrlParam("userId"),
                    avatar : res.data.url
                }
                YZ.ajaxRequestData("post", false, YZ.ip + "/user/updateUser", arr , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        YZ.setUserInfo();
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    }
                });
            }
        });
    });


</script>
</body>
</html>
