<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>传递卡子类列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
<body ng-app="webApp">

<div class="admin-main" ng-controller="workDiarySubListCtr" ng-cloak>
    <fieldset class="layui-elem-field" >
        <legend>{{workDiary.workTime | date : 'yyyy-MM-dd'}}日志列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <!-- 等于登录人的情况 -->
                <span ng-if="userInfo.id == workDiary.userId">
                    <!--登录人添加-->
                    <a ng-if="userInfo.isManager == 1 && workDiary.status != 4004" href="<%=request.getContextPath()%>/page/workDiarySub/add?workDiaryId={{workDiary.id}}&dateTime={{workDiary.workTime}}" class="layui-btn layui-btn-small layui-btn-normal">
                        <i class="layui-icon">&#xe608;</i> 添加当天工作日志
                    </a>
                    <a ng-if="userInfo.isManager != 1 && (workDiary.status == 4000 || workDiary.status == 4002 || workDiary.status == 4005)" href="<%=request.getContextPath()%>/page/workDiarySub/add?workDiaryId={{workDiary.id}}&dateTime={{workDiary.workTime}}" class="layui-btn layui-btn-small layui-btn-normal">
                        <i class="layui-icon">&#xe608;</i> 添加当天工作日志
                    </a>
                    <a href='#' ng-if="(workDiary.status == 4000 || workDiary.status == 4002) && userInfo.isManager != 1" ng-click='updateWorkDiaryStatus(4001)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                    <a href='#' ng-if="workDiary.status == 4005" ng-click='updateWorkDiaryStatus(4003)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                    <!--团队长经理自己提交-->
                    <span ng-if="userInfo.isManager == 1 && workDiary.status == 4000 && user.roleId != 10">
                        <a href='#' ng-click='updateWorkDiaryStatus(4001)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                    </span> 
                    <!--综合部经理自己提交-->
                    <span ng-if="workDiary.status == 4000 && user.roleId == 10">
                        <a href='#' ng-click='updateWorkDiaryStatus(4001)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                    </span>
                </span>
                <!-- 不等于创建者的情况 -->
                <span ng-if="userInfo.id != workDiary.userId">
                    <!-- 等于团队长经理的情况 -->
                    <span ng-if="userInfo.isManager == 1 && workDiary.status == 4001 && userInfo.departmentId == workDiary.user.departmentId">
                        <a href="<%=request.getContextPath()%>/page/workDiarySub/add?workDiaryId={{workDiary.id}}&dateTime={{workDiary.workTime}}" class="layui-btn layui-btn-small layui-btn-normal">
                            <i class="layui-icon">&#xe608;</i> 添加当天工作日志</a>
                        <a href='#' ng-click='updateWorkDiaryStatus(4001)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                        <%--<a href='#' ng-click='updateWorkDiaryStatus(4003)' class="layui-btn layui-btn-small"><i class="fa fa-list fa-edit"></i>&nbsp;通过审核</a>
                        <a href='#' ng-click='updateWorkDiaryStatus(4002)' class="layui-btn layui-btn-danger layui-btn-small"><i class="fa fa-list fa-edit"></i>&nbsp;打回</a>--%>
                    </span>
                    <span ng-if="userInfo.isManager == 1 && workDiary.status == 4005 && userInfo.departmentId == workDiary.user.departmentId && userInfo.roleId != 10">
                        <a href='#' ng-click='updateWorkDiaryStatus(4001)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                    </span>
                        <!-- 等于综合部经理的情况 -->
                    <span ng-if="userInfo.roleId == 10 && workDiary.status == 4003 && userInfo.companyId == workDiary.user.companyId">
                        <a href="<%=request.getContextPath()%>/page/workDiarySub/add?workDiaryId={{workDiary.id}}&dateTime={{workDiary.workTime}}" class="layui-btn layui-btn-small layui-btn-normal">
                            <i class="layui-icon">&#xe608;</i> 添加当天工作日志</a>
                        <a href='#' ng-click='updateWorkDiaryStatus(4001)' class="layui-btn layui-btn-small layui-btn-warm"><i class="fa fa-list fa-edit"></i>&nbsp;提交审核</a>
                        <%--<a href='#' ng-click='updateWorkDiaryStatus2(4004)' class="layui-btn layui-btn-small"><i class="fa fa-list fa-edit"></i>&nbsp;通过审核</a>
                        <a href='#' ng-click='updateWorkDiaryStatus2(4005)' class="layui-btn layui-btn-danger layui-btn-small"><i class="fa fa-list fa-edit"></i>&nbsp;打回</a>--%>
                    </span>
                </span>

                <%--<button ng-if="workDiary.status == 4003" class="layui-btn layui-btn-small layui-btn-disabled"><i class="fa fa-list fa-edit"></i>&nbsp;综合部待审核</button>
                <button ng-if="workDiary.status == 4004" class="layui-btn layui-btn-small layui-btn-disabled"><i class="fa fa-list fa-edit"></i>&nbsp;综合部已通过</button>--%>
                <a href='#' ng-click='findSpeed()' class="layui-btn layui-btn-small layui-btn-primary"><i class='layui-icon'>&#xe62c;</i>&nbsp;查看进度</a>
                <%--<a href="<%=request.getContextPath()%>/page/workDiary/list" class="layui-btn layui-btn-small layui-btn-primary">返回</a>--%>
            </blockquote>
            <table class="layui-table admin-table">
                <thead>
                <tr>
                    <th>事务类别</th>
                    <th>事务类型</th>
                    <th>工作类型</th>
                    <%--<th>时间类型</th>--%>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th width="400px;">工作内容</th>
                    <th>创建时间</th>
                    <th>更新时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="workDiarySub in workDiarySubList">
                    <td>{{workDiarySub.transactionTypeName}}</td>
                    <td>{{workDiarySub.transactionSubName}}</td>
                    <td>{{workDiarySub.jobTypeName}}</td>
                    <%--<td>{{workDiarySub.timeTypeName}}</td>--%>
                    <td>{{workDiarySub.startTime | date : 'yyyy-MM-dd HH:mm:ss'}}</td>
                    <td>{{workDiarySub.endTime | date : 'yyyy-MM-dd HH:mm:ss'}}</td>
                    <td>{{workDiarySub.jobContent}}</td>
                    <td>{{workDiarySub.createTime | date : 'yyyy-MM-dd HH:mm:ss'}}</td>
                    <td>{{workDiarySub.updateTime | date : 'yyyy-MM-dd HH:mm:ss'}}</td>
                    <td>
                        <button class="layui-btn layui-btn-small" ng-click="updateData(workDiarySub.id)"><i class="fa fa-list fa-edit"></i>&nbsp;修改</button>
                        <button class="layui-btn layui-btn-small layui-btn-danger" ng-click="deleteData(workDiarySub.id)"><i class="layui-icon">&#xe640;</i>&nbsp;删除</button>
                    </td>
                </tr>
                <tr ng-if="workDiarySubList.length == 0"><td colspan="99" class="notData">暂无数据.</td></tr>
                </tbody>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>
    var webApp=angular.module('webApp',[]);
    //我的
    webApp.controller("workDiarySubListCtr", function($scope,$http,$timeout){
        $scope.workDiarySubList = null;
        $scope.workDiaryStatusDetail = null; //存放进度集合
        $scope.userInfo = YZ.getUserInfo();
        $scope.workDiaryId = YZ.getUrlParam("workDiaryId");
        $scope.workDiary = null;

        YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/queryWorkDiaryById", {id : $scope.workDiaryId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.workDiary = result.data;
            }
        });

        //获取当天列表
        YZ.ajaxRequestData("get", false, YZ.ip + "/workDiarySub/queryWorkDiarySubByWorkDiary", {workDiaryId : $scope.workDiaryId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.workDiaryStatusDetail = result.data.workDiaryStatusDetail;
                $scope.workDiarySubList = result.data.workDiarySub;
            }
        });



        layui.use(['form', 'layedit', 'laydate'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.type = Number(data.field.type);
                localStorage.setItem("type",data.field.type);
                location.reload();
                return false;
            });
        });

        /**
         * 更新传递卡 状态
         * @param id
         * @param status
         */
        $scope.updateWorkDiaryStatus = function(status) {

            //如果点击提交审核按钮没有传递卡子类日志的话提示
            if ($scope.workDiarySubList.length == 0) {
                layer.msg('没有添加任何传递卡日志不能提交审核', {icon: 2, anim: 6});
                return false;
            }

            var mag = "";
            if (status == 4001) {
                mag = "是否确认提交审核？";
            }
            else if (status == 4003) {
                mag = "是否确认通过审核？";
            }
            else if (status == 4002) {
                mag = "是否确认打回？";
            }
            var html = '<form class="layui-form layui-form-pane" action="">' +
                    '<div class="layui-form-item layui-form-text">' +
                    '<label class="layui-form-label">备注</label>' +
                    '<div class="layui-input-block">' +
                    '<textarea type="text" id="notes" autocomplete="off" placeholder="请输入备注" class="layui-input"></textarea>' +
                    '</div>' +
                    '</div>' +
                    '</form>';

            YZ.formPopup(html, mag, ["500px", "300px"], function () {
                var arr = {
                    status : status,
                    id : $scope.workDiary.id,
                    notes : $("#notes").val()
                }
                YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateWorkDiaryStatus", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        layer.msg('操作成功.', {icon: 1});
                        location.reload();
                    }
                });
            }, function () {
                //layer.msg('已取消.', {icon: 2, anim: 6});
            });
        }

        //综合部审核
        $scope.updateWorkDiaryStatus2 = function(status) {

            var mag = "";
            if (status == 4004) {
                $scope.selectUser(status);
                return false;
            }
            else if (status == 4005) {
                mag = "是否确认打回？";
            }
            var html = '<form class="layui-form layui-form-pane" action="">' +
                    '<div class="layui-form-item layui-form-text">' +
                    '<label class="layui-form-label">备注</label>' +
                    '<div class="layui-input-block">' +
                    '<textarea type="text" id="notes" autocomplete="off" placeholder="请输入备注" class="layui-input"></textarea>' +
                    '</div>' +
                    '</div>' +
                    '</form>';

            YZ.formPopup(html, mag, ["500px", "300px"], function () {
                var arr = {
                    status : status,
                    id : $scope.workDiary.id,
                    notes : $("#notes").val()
                }
                YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateWorkDiaryStatus", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        layer.msg('操作成功.', {icon: 1});
                        location.reload();
                    }
                });
            }, function () {
                //layer.msg('已取消.', {icon: 2, anim: 6});
            });
        }

        /**
         * 查看进度
         */
        $scope.findSpeed = function () {
            if ($scope.workDiaryStatusDetail == null || $scope.workDiaryStatusDetail.length == 0) {
                layer.msg('没有任何进度', {icon: 2, anim: 6});
                return false;
            }
            localStorage.setItem("details", JSON.stringify($scope.workDiaryStatusDetail));
            layer.open({
                type: 2,
                title: '传递卡进度',
                shadeClose: true,
                maxmin: true, //开启最大化最小化按钮
                area: ['100%', '100%'],
                content: YZ.ip + "/page/workDiary/speed"
            });
        }

        //选择抄送人
        $scope.selectUser = function (status) {
            layer.open({
                type: 2,
                title: '选择抄送人',
                shadeClose: true,
                maxmin: true, //开启最大化最小化按钮
                area: ['600px', '600px'],
                content: YZ.ip + "/page/workDiary/selectUser?workDiaryId=" + $scope.workDiary.id + "&workDiaryIdStatus=" + status
            });
        }

        //修改传递卡子类日志
        $scope.updateData = function (id) {
            console.log("$scope.userInfo.id: " + $scope.userInfo.id);
            console.log("$scope.workDiary.userId: " + $scope.workDiary.userId);
            console.log("$scope.userInfo.roleId: " + $scope.userInfo.roleId);
            console.log("$scope.userInfo.isManager: " + $scope.userInfo.isManager);
            console.log("$scope.userInfo.departmentId: " + $scope.userInfo.departmentId);
            console.log("$scope.workDiary.user.departmentId: " + $scope.workDiary.user.departmentId);
            //不是自己又不是综合部经理
            if ($scope.userInfo.id != $scope.workDiary.userId && $scope.userInfo.roleId != 10 && $scope.userInfo.isManager != 1){
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            //等于团队长经理但是,不是同一个部门
            if ($scope.userInfo.id != $scope.workDiary.userId && $scope.userInfo.roleId != 10 && $scope.userInfo.isManager == 1 && $scope.userInfo.departmentId != $scope.workDiary.user.departmentId) {
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            //等于同一个部门的员工
            if ($scope.userInfo.id != $scope.workDiary.userId && $scope.userInfo.roleId != 10 && $scope.userInfo.isManager == 0 && $scope.userInfo.departmentId == $scope.workDiary.user.departmentId) {
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            //等于自己
            if ($scope.workDiary.status == 4001 && $scope.userInfo.id == $scope.workDiary.userId) {
                layer.msg('抱歉，部门经理待审核不能修改.', {icon: 2, anim: 6});
                return false;
            }
            if ($scope.workDiary.status == 4003 && $scope.userInfo.id == $scope.workDiary.userId) {
                layer.msg('抱歉，部门经理通过审核不能修改.', {icon: 2, anim: 6});
                return false;
            }
            //等于团队长经理
            if ($scope.workDiary.status == 4002 && $scope.userInfo.isManager == 1 && $scope.userInfo.departmentId == $scope.workDiary.user.departmentId && $scope.userInfo.roleId != 10) {
                layer.msg('抱歉，队员还没提交不能修改.', {icon: 2, anim: 6});
                return false;
            }
            if ($scope.workDiary.status == 4003 && $scope.userInfo.isManager == 1 && $scope.userInfo.departmentId == $scope.workDiary.user.departmentId && $scope.userInfo.roleId != 10) {
                layer.msg('抱歉，待审核不能修改.', {icon: 2, anim: 6});
                return false;
            }
            if ($scope.workDiary.status == 4004) {
                layer.msg('抱歉，通过审核不能修改.', {icon: 2, anim: 6});
                return false;
            }
            location.href = YZ.ip + "/page/workDiarySub/edit?workDiarySubId=" + id + "&dateTime=" + $scope.workDiary.workTime + "&workDiaryId=" + $scope.workDiaryId;
        }

        //删除传递卡子类日志
        $scope.deleteData = function (id) {
            console.log("$scope.userInfo.id: " + $scope.userInfo.id);
            console.log("$scope.workDiary.userId: " + $scope.workDiary.userId);
            console.log("$scope.userInfo.roleId: " + $scope.userInfo.roleId);
            console.log("$scope.userInfo.isManager: " + $scope.userInfo.isManager);
            console.log("$scope.userInfo.departmentId: " + $scope.userInfo.departmentId);
            console.log("$scope.workDiary.user.departmentId: " + $scope.workDiary.user.departmentId);
            //不是自己又不是综合部经理
            if ($scope.userInfo.id != $scope.workDiary.userId && $scope.userInfo.roleId != 10 && $scope.userInfo.isManager != 1){
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            //等于团队长经理但是,不是同一个部门
            if ($scope.userInfo.id != $scope.workDiary.userId && $scope.userInfo.roleId != 10 && $scope.userInfo.isManager == 1 && $scope.userInfo.departmentId != $scope.workDiary.user.departmentId) {
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            //等于同一个部门的员工
            if ($scope.userInfo.id != $scope.workDiary.userId && $scope.userInfo.roleId != 10 && $scope.userInfo.isManager == 0 && $scope.userInfo.departmentId == $scope.workDiary.user.departmentId) {
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            //等于自己
            if ($scope.workDiary.status == 4001 && $scope.userInfo.id == $scope.workDiary.userId) {
                layer.msg('抱歉，部门经理待审核不能删除.', {icon: 2, anim: 6});
                return false;
            }
            if ($scope.workDiary.status == 4003 && $scope.userInfo.id == $scope.workDiary.userId) {
                layer.msg('抱歉，部门经理通过审核不能删除.', {icon: 2, anim: 6});
                return false;
            }
            //等于团队长经理
            if ($scope.workDiary.status == 4002 && $scope.userInfo.isManager == 1 && $scope.userInfo.departmentId == $scope.workDiary.user.departmentId && $scope.userInfo.roleId != 10) {
                layer.msg('抱歉，队员还没提交不能删除.', {icon: 2, anim: 6});
                return false;
            }
            if ($scope.workDiary.status == 4003 && $scope.userInfo.isManager == 1 && $scope.userInfo.departmentId == $scope.workDiary.user.departmentId && $scope.userInfo.roleId != 10) {
                layer.msg('抱歉，待审核不能删除.', {icon: 2, anim: 6});
                return false;
            }
            if ($scope.workDiary.status == 4004) {
                layer.msg('抱歉，通过审核不能删除.', {icon: 2, anim: 6});
                return false;
            }

            if ($scope.workDiarySubList.length == 1) {
                layer.msg('最后一条不能删除，只能修改.', {icon: 2, anim: 6});
                return false;
            }
            /*if ($scope.workDiary.status > 4000) {
                layer.msg('最后一条不能删除，只能修改.', {icon: 2, anim: 6});
                return false;
            }*/
            layer.confirm("是否确认删除该日志？", {
                btn: ['确定','取消'], //按钮
                title : "确认提示",
            }, function(){
                YZ.ajaxRequestData("get", false, YZ.ip + "/workDiarySub/delWorkDiarySub", {id : id}, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        layer.msg('操作成功.', {icon: 1});
                        if ($scope.workDiarySubList.length == 1) {
                            location.href = YZ.ip + "/page/workDiary/list";
                        }
                        else {
                            location.reload();
                        }
                    }
                });
            }, function(){
                //layer.msg('已取消.', {icon: 2, anim: 6});
            });
        }


    })

    //提供给子页面调用
    var closeNodeIframe = function () {
        location.reload();
    }
</script>
</body>
</html>
