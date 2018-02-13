<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加传递卡子类</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        #dpTime {
            display: none;
        }
    </style>
</head>
<body ng-app="webApp">
    <div style="margin: 15px;" ng-controller="workDiarySubAddCtr" ng-cloak>
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>{{dateTime | date : 'yyyy-MM-dd'}}添加工作</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">事物类型<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="transactionSubId" lay-verify="required" lay-filter = "transactionType">
                        <option value="">选择事物类型</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">工作类型<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="jobTypeId" lay-verify="required" lay-search="">
                        <option value="">选择或搜索工作类型</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">选择项目<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="projectId" lay-verify="required" lay-search="">
                        <option value="">选择或搜索项目</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">事务类别<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="timeType" class="layui-input" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">开始时间<span class="font-red">*</span></label>
                    <div class="layui-input-inline" style="width: 100px;">
                        <select id="startTime1" lay-search lay-verify="required">
                            <option value="00">00</option>
                            <option value="01">01</option>
                            <option value="02">02</option>
                            <option value="03">03</option>
                            <option value="04">04</option>
                            <option value="05">05</option>
                            <option value="06">06</option>
                            <option value="07">07</option>
                            <option value="08">08</option>
                            <option value="09" selected>09</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                            <option value="18">18</option>
                            <option value="19">19</option>
                            <option value="20">20</option>
                            <option value="21">21</option>
                            <option value="22">22</option>
                            <option value="23">23</option>
                        </select>
                    </div>
                    <div class="layui-form-mid">:</div>
                    <div class="layui-input-inline" style="width: 100px;">
                        <select id="startTime2">
                            <option value="00">00</option>
                            <option value="30">30</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">结束时间<span class="font-red">*</span></label>
                    <div class="layui-input-inline" style="width: 100px;">
                        <select id="endTime1" lay-search lay-verify="required">
                            <option value="">请选择</option>
                            <option value="00">00</option>
                            <option value="01">01</option>
                            <option value="02">02</option>
                            <option value="03">03</option>
                            <option value="04">04</option>
                            <option value="05">05</option>
                            <option value="06">06</option>
                            <option value="07">07</option>
                            <option value="08">08</option>
                            <option value="09">09</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                            <option value="18">18</option>
                            <option value="19">19</option>
                            <option value="20">20</option>
                            <option value="21">21</option>
                            <option value="22">22</option>
                            <option value="23">23</option>
                            <option value="24">24</option>
                        </select>
                    </div>
                    <div class="layui-form-mid">:</div>
                    <div class="layui-input-inline" style="width: 100px;">
                        <select id="endTime2" lay-verify="required">
                            <option value="">请选择</option>
                            <option value="00">00</option>
                            <option value="30">30</option>
                        </select>
                    </div>
                </div>
            </div>

            <%--<div class="layui-form-item">
                <label class="layui-form-label">开始时间<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="startTime" value="09:00" id="startTime"  lay-verify="required" placeholder="HH:mm:ss" autocomplete="off"
                           class="layui-input" onfocus="WdatePicker({dateFmt:'HH:mm',maxDate:'#F{$dp.$D(\'endTime\')}'})" readonly>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">结束时间<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text"  name="endTime" id="endTime" lay-verify="required" placeholder="HH:mm:ss"
                           autocomplete="off" class="layui-input" onfocus="WdatePicker({dateFmt:'HH:mm',minDate:'#F{$dp.$D(\'startTime\')}'})" readonly>
                </div>
            </div>--%>

            <div class="layui-form-item">
                <label class="layui-form-label">工作内容<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <textarea name="jobContent" lay-verify="required" placeholder="请输入工作内容"></textarea>
                </div>
            </div>
            <input type="hidden" name="workDiaryId"/>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                    <a href="javascript:history.go(-1)" class="layui-btn layui-btn-primary">返回</a>
                </div>
            </div>
        </form>
    </div>

    <!--引入抽取公共js-->
    <%@include file="../common/public-js.jsp" %>
    <script>

        var webApp=angular.module('webApp',[]);
        webApp.controller("workDiarySubAddCtr", function($scope,$http,$timeout){
            $scope.dateTime=YZ.getUrlParam("dateTime");
            var time = new Date(Number($scope.dateTime)).format("yyyy-MM-dd");

            //获取工作列表
            function getJobTypeList(transactionType) {
                YZ.ajaxRequestData("get", false, YZ.ip + "/jobType/getJobTypeByTransactionForWeb", {transaction : transactionType, source : 0}, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        var html = "<option value=\"\">选择或搜索事务类型</option>";
                        for (var i = 0; i < result.data.length; i++) {
                            html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].jobTypeName + "</option>";
                        }
                        if (result.data.length == 0) {
                            html += "<option value=\"0\" disabled>暂无</option>";
                        }
                        $("select[name='jobTypeId']").html(html);
                    }
                });
            }




            layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
                var form = layui.form(),
                        layer = layui.layer,
                        laydate = layui.laydate;

                getTransactionList();

                // 设置初始化 开始时间选择
                YZ.ajaxRequestData("get", false, YZ.ip + "/workDiarySub/queryNewSub", {workDiaryId : YZ.getUrlParam("workDiaryId")}, null , function(result){
                    if(result.flag == 0 && result.code == 200 && undefined != result.data){
                        var date = new Date(result.data.endTime);
                        $("#startTime1 option").each(function(){
                            if(date.getHours() == $(this).val()){
                                $(this).attr("selected",true);
                            }

                        });
                        $("#startTime2 option").each(function(){

                            if(date.getMinutes() == $(this).val()){
                                $(this).attr("selected",true);
                            }

                        });
                        form.render();
                    }
                });

                //事务过滤器
                form.on('select(transactionType)', function(data){
                    getJobTypeList(Number(data.value));
                    $("input[name='timeType']").val($("select[name='transactionSubId'] option:selected").attr("transactiontypename"));
                    $("input[name='timeType']").parent().parent().show();
                    $("select[name='projectId']").parent().parent().hide();
                    $("select[name='projectId']").removeAttr("lay-verify");
                    //等于内部项目的情况
                    if (data.value == 3) {
                        getProjectInterior(0);
                        $("select[name='projectId']").attr("lay-verify", "required");
                        $("select[name='jobTypeId']").removeAttr("lay-verify");
                        $("select[name='jobTypeId']").parent().parent().hide();
                    }
                    else if (data.value == 4) {
                        getProjectExternal(0);
                        $("select[name='projectId']").attr("lay-verify", "required");
                        $("select[name='jobTypeId']").removeAttr("lay-verify");
                        $("select[name='jobTypeId']").parent().parent().hide();
                    }
                    else {
                        $("select[name='jobTypeId']").attr("lay-verify", "required");
                        $("select[name='jobTypeId']").parent().parent().show();
                    }

                    form.render();
                });
                form.render();
                //监听提交
                form.on('submit(demo1)', function(data) {

                    if(24 == $("#endTime1").val() && 30 == $("#endTime2").val()){
                        layer.msg('只能选择24:00.', {icon: 2, anim: 6});
                        return false;
                    }

                    data.field.startTime = $("#startTime1").val() + ":" + $("#startTime2 option:selected").val();
                    data.field.endTime = $("#endTime1").val() + ":" + $("#endTime2").val();
                    if (data.field.startTime >= data.field.endTime) {
                        layer.msg('开始时间不能大于或等于结束时间.', {icon: 2, anim: 6});
                        return false;
                    }
                    data.field.startTime = new Date(time + " " + data.field.startTime);
                    data.field.endTime = new Date(time + " " + data.field.endTime);
                    data.field.workDiaryId = YZ.getUrlParam("workDiaryId");

                    if(data.field.transactionSubId == 3 || data.field.transactionSubId == 4){
                        data.field.jobTypeId = $("select[name='projectId']").val();
                    }
                    else{
                        data.field.jobTypeId = $("select[name='jobTypeId']").val();
                        delete data.field.projectId;
                    }

                    console.log("-----------------------");
                    console.log(data.field);
                    console.log("-----------------------");
                    // return false;
                    YZ.ajaxRequestData("post", false, YZ.ip + "/workDiarySub/addWorkDiarySub", data.field , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            layer.alert('添加日志成功.', {
                                skin: 'layui-layer-molv' //样式类名
                                ,closeBtn: 0
                                ,anim: 3 //动画类型
                            }, function(){
                                self.location = document.referrer;// 返回上一页并刷新上一页
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
