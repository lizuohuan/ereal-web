<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>用户详情</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <fieldset class="layui-elem-field" style="margin-top: 20px;">
        <legend>用户详情</legend>
        <div class="layui-field-box layui-form" ng-controller="userEditCtr" ng-cloak>

            <div class="layui-form-item">
                <label class="layui-form-label">头像</label>
                <div class="layui-input-inline">
                    <div class="site-demo-upload">
                        <img ng-if="userInfo.avatar == null" src="<%=request.getContextPath()%>/resources/img/0.jpg">
                        <img ng-if="userInfo.avatar != null" src="<%=imgPath%>/{{userInfo.avatar}}">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">用户类型</label>
                <div class="layui-input-inline">
                    <div class="layui-input">
                        <span ng-if="userInfo.companyId == null">平台用户</span>
                        <span ng-if="userInfo.companyId != null">分公司用户</span>
                    </div>
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">角色名称</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.roleName}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">后台多角色</label>
                <div class="layui-input-inline">
                    <div class="layui-input" style="height: inherit; padding: 10px;">
                        <button style="cursor: not-allowed!important;" type="button" class="layui-btn layui-btn-small layui-btn-radius" ng-repeat="role in userInfo.roles">{{role.roleName}}</button>
                    </div>
                </div>
            </div>

            <div class="layui-form-item" ng-if="userInfo.companyName != null">
                <label class="layui-form-label">所属公司</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.companyName}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">所属部门</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.departmentName}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">账号</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.account}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.name}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.email}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">生日</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{ userInfo.birthday | date:'yyyy-MM-dd'}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">电话号码</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{userInfo.phone}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">身份属性</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >
                        <span ng-if="userInfo.incumbency == 0">实习</span>
                        <span ng-if="userInfo.incumbency == 1">磨合期</span>
                        <span ng-if="userInfo.incumbency == 2">正式</span>
                        <span ng-if="userInfo.incumbency == 3">离职</span>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">入职时间</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{ userInfo.entryTime | date:'yyyy-MM-dd'}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">转正时间</label>
                <div class="layui-input-inline">
                    <div class="layui-input" >{{ userInfo.positiveTime | date:'yyyy-MM-dd'}}</div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">薪酬</label>
                    <div class="layui-input-inline">
                        <div class="layui-input" >
                            {{userInfo.salary}}
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">性别</label>
                    <div class="layui-input-inline">
                        <div class="layui-input" >
                            <span ng-if="userInfo.sex == 0">男</span>
                            <span ng-if="userInfo.sex == 1">女</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">合作状态</label>
                    <div class="layui-input-inline">
                        <div class="layui-input" >
                            <span ng-if="userInfo.infoStatus == 0">合作</span>
                            <span ng-if="userInfo.infoStatus == 1">股东</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">最后登录时间</label>
                    <div class="layui-input-inline">
                        <div class="layui-input" >
                            {{ userInfo.lastLoginTime | date:'yyyy-MM-dd hh:mm:ss'}}
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">创建时间</label>
                    <div class="layui-input-inline">
                        <div class="layui-input" >
                            {{ userInfo.createTime | date:'yyyy-MM-dd hh:mm:ss'}}
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



</script>
</body>
</html>
