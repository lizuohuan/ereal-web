<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改外部项目</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .layui-form-label{width: 150px;}
        .layui-input-block{margin-left: 180px;}
    </style>
</head>
<body ng-app="webApp" ng-controller="projectExternalEditCtr" ng-cloak>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改外部项目</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">项目编号<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="projectNumber" value="{{projectExternalInfo.projectNumber}}" lay-verify="required" placeholder="请输入项目编号" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="projectName" value="{{projectExternalInfo.projectName}}" lay-verify="required" placeholder="请输入项目名称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目简称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="projectNameShort" value="{{projectExternalInfo.projectNameShort}}" lay-verify="required" placeholder="请输入项目简称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="projectTypeId" lay-verify="required" lay-search="">
                    <option value="">请选择或搜索项目类型</option>
                </select>
            </div>
        </div>


        <div id="teacherDiv" class="layui-hide">
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
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户单位名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="customerUnit" value="{{projectExternalInfo.customerUnit}}" lay-verify="required" placeholder="请输入客户单位名称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户专业部门名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="customerDepartment" value="{{projectExternalInfo.customerDepartment}}" lay-verify="required" placeholder="请输入客户专业部门名称" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">承接时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="receiveTime" value="{{ projectExternalInfo.receiveTime | date:'yyyy-MM-dd'}}" lay-verify="required" placeholder="承接时间" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">项目启动书提交时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="submitTime" value="{{ projectExternalInfo.submitTime | date:'yyyy-MM-dd'}}" lay-verify="required" placeholder="项目启动书提交时间" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户定位<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea type="text" name="customerRemarks" lay-verify="required" placeholder="请输入客户定位" autocomplete="off" class="layui-textarea" maxlength="200">{{projectExternalInfo.customerRemarks}}</textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">风险说明<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea type="text" name="riskRemarks" lay-verify="required" placeholder="请输入风险说明" autocomplete="off" class="layui-textarea" maxlength="200">{{projectExternalInfo.riskRemarks}}</textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">其他市场信息备注<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea type="text" name="otherRemarks" lay-verify="required" placeholder="请输入其他市场信息备注" autocomplete="off" class="layui-textarea" maxlength="200">{{projectExternalInfo.otherRemarks}}</textarea>
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

    //获取内部项目专业
    function getProjectTypeList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectType/listSelect", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择或搜索项目类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].projectTypeName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].projectTypeName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectTypeId']").html(html);
            }
        });
    }

    var webApp=angular.module('webApp',[]);
    webApp.controller("projectExternalEditCtr", function($scope,$http,$timeout){
        $scope.projectExternalId = YZ.getUrlParam("projectExternalId");
        $scope.projectExternalInfo = null;
        YZ.ajaxRequestData("get", false, YZ.ip + "/project/info", {id : $scope.projectExternalId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                console.log(result.data);
                $scope.projectExternalInfo = result.data;
            }
        });

        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;


            //自定义验证规则
            form.verify({

            });
            // teacherDiv
            if(null != $scope.projectExternalInfo.cTeacherId){
                $("#teacherDiv").removeAttr("class","layui-hide");
                queryAllCompany(0,"aTeacherIdCompany",null);
                queryAllCompany(0,"bTeacherIdCompany",null);
                queryAllCompany(0,"cTeacherIdCompany",null);
                queryUserByDepartment($scope.projectExternalInfo.cTeacherId,"cTeacherId",null,null,null,null);
                queryUserByDepartment($scope.projectExternalInfo.bTeacherId,"bTeacherId",null,null,null,null);
                queryUserByDepartment($scope.projectExternalInfo.aTeacher,"aTeacher",null,null,null,null);
            }

            getProjectTypeList($scope.projectExternalInfo.projectTypeId);



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
                data.field.receiveTime = new Date(data.field.receiveTime);
                data.field.submitTime = new Date(data.field.submitTime);
                data.field.id = $scope.projectExternalId;
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProject", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('修改外部项目成功.', {
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
