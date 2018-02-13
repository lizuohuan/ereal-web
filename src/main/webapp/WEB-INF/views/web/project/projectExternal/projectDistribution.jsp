<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>项目分配</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp" ng-controller="projectExternalCtr" ng-cloak>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>项目分配</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">选择团队<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="companyId"  lay-search="" lay-filter="companyFilter">
                        <option value="">请选择或搜索公司</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="departmentId" lay-verify="required" lay-search="" >
                        <option value="">请选择或搜索部门</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">初始工作量</label>
                <div class="layui-input-block">
                    <div class="layui-input">
                        (一阶段：{{projectInfo.projectType.sections[0].sectionDays}}天) + (二阶段：{{projectInfo.projectType.sections[1].sectionDays}}天) +
                        (三阶段：{{projectInfo.projectType.sections[2].sectionDays}}天) + (四阶段：{{projectInfo.projectType.sections[3].sectionDays}}天) =
                        {{projectInfo.projectType.sections[0].sectionDays + projectInfo.projectType.sections[1].sectionDays + projectInfo.projectType.sections[2].sectionDays + projectInfo.projectType.sections[3].sectionDays}}天
                    </div>
                    <%--<input name="initWorkload" step="1" value="{{projectInfo.initWorkload}}" lay-verify="required|isNumber|isZero" placeholder="请输入初始工作量" autocomplete="off" class="layui-input" maxlength="5">--%>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">选择A导师<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="aTeacherIdCompany"  lay-search="" lay-filter="aTeacherIdCompany">
                        <option value="">请选择或搜索公司</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="aTeacherIdDepartment"  lay-search="" lay-filter="aTeacherIdDepartment" >
                        <option value="">请选择或搜索部门</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="aTeacher" lay-verify="required" lay-search="">
                        <option value="">请选择或搜索</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">选择B导师<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="bTeacherIdCompany"  lay-search="" lay-filter="bTeacherIdCompany">
                        <option value="">请选择或搜索公司</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="bTeacherIdDepartment"  lay-search="" lay-filter="bTeacherIdDepartment">
                        <option value="">请选择或搜索部门</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="bTeacherId" lay-verify="required" lay-search="">
                        <option value="">请选择或搜索</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">选择C导师<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="cTeacherIdCompany"  lay-search="" lay-filter="cTeacherIdCompany">
                        <option value="">请选择或搜索公司</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="cTeacherIdDepartment"  lay-search="" lay-filter="cTeacherIdDepartment">
                        <option value="">请选择或搜索部门</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="cTeacherId" lay-verify="required" lay-search="">
                        <option value="">请选择或搜索</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">一真定位备注<span class="font-red">*</span></label>
                <div class="layui-input-block">
                    <textarea type="text" name="orientationRemarks" lay-verify="required" placeholder="请输入一真定位备注" autocomplete="off" class="layui-textarea" maxlength="200">{{projectInfo.orientationRemarks}}</textarea>
                </div>
            </div>

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

        var webApp=angular.module('webApp',[]);
        webApp.controller("projectExternalCtr", function($scope,$http,$timeout){
            $scope.projectId = YZ.getUrlParam("id");
            $scope.projectInfo = null;
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/info", {id : $scope.projectId} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    $scope.projectInfo = result.data;
                }
            });

            layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
                var form = layui.form(),
                        layer = layui.layer,
                        laydate = layui.laydate;

                //自定义验证规则
                form.verify({
                    isNumber: function(value) {
                        if(value.length > 0 && !YZ.isNumber.test(value)) {
                            return "请输入一个整数";
                        }
                    },
                    isZero : function (value) {
                        if(value <= 0) {
                            return "不能小于等于0";
                        }
                    }
                });


                queryAllCompany(0,"companyId",null);
                queryAllCompany(0,"aTeacherIdCompany",null);
                queryAllCompany(0,"bTeacherIdCompany",null);
                queryAllCompany(0,"cTeacherIdCompany",null);


                if ($scope.projectInfo.departmentId != null) {
                    $("select[name='bTeacherId']").html(getRoleDepartmentIdUserList(12, $scope.projectInfo.bTeacherId, $scope.projectInfo.departmentId));
                    $("select[name='cTeacherId']").html(getRoleUserList(7, $scope.projectInfo.cTeacherId));
                    $("select[name='bTeacherId']").parent().parent().show();
                    $("select[name='cTeacherId']").parent().parent().show();
                    form.render('select');
                }
                form.on('select(companyFilter)', function(data) {
                    // 填充部门
                    queryDepartmentByCompany(0,"departmentId",null,data.value,null);
                    form.render('select');
                });

                // A导师选择
                form.on('select(aTeacherIdCompany)', function(data) {
                    // 填充部门
                    queryDepartmentByCompany(0,"aTeacherIdDepartment",null,data.value,null);
                    form.render('select');
                });

                form.on('select(aTeacherIdDepartment)', function(data) {
                    // 填充部门
                    queryUserByDepartment(0,"aTeacher",null,null,data.value,null);
                    form.render('select');
                });

                // B导师
                form.on('select(bTeacherIdCompany)', function(data) {
                    // 填充部门
                    queryDepartmentByCompany(0,"bTeacherIdDepartment",null,data.value,null);
                    form.render('select');
                });

                form.on('select(bTeacherIdDepartment)', function(data) {
                    // 填充部门
                    queryUserByDepartment(0,"bTeacherId",null,null,data.value,null);
                    form.render('select');
                });
                // C导师
                form.on('select(cTeacherIdCompany)', function(data) {
                    // 填充部门
                    queryDepartmentByCompany(0,"cTeacherIdDepartment",null,data.value,null);
                    form.render('select');
                });

                form.on('select(cTeacherIdDepartment)', function(data) {
                    // 填充部门
                    queryUserByDepartment(0,"cTeacherId",null,null,data.value,null);
                    form.render('select');
                });



                form.render();

                //监听提交
                form.on('submit(demo1)', function(data) {
                    data.field.id = $scope.projectId;
                    data.field.connectStatus = 1;
                    data.field.initWorkload = $scope.projectInfo.projectType.sections[0].sectionDays
                            + $scope.projectInfo.projectType.sections[1].sectionDays
                            + $scope.projectInfo.projectType.sections[2].sectionDays
                            + $scope.projectInfo.projectType.sections[3].sectionDays;
                    console.log(data.field);

                    YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProjectManagerCommittee", data.field , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            layer.alert('分配成功.', {
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

    </script>
</body>
</html>
