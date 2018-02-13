<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>进行周验收</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp" ng-controller="weekAcceptanceCtr" ng-cloak>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>进行周验收</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="stage">
                <div class="layui-form-item">
                    <label class="layui-form-label">一阶段质量分<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="quality" lay-verify="required|isNumber|isZero" placeholder="请输入一阶段质量分" autocomplete="off" class="layui-input">
                        <input type="hidden" name="sectionNum" value="1">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage1 != null">(上次一阶段质量分{{stage1.quality}}分)</div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">一阶段进度(%)<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="schedule" lay-verify="required|isNumber|isZero" placeholder="请输入一阶段进度" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage1 != null">(上次一阶段进度{{stage1.schedule}}%)</div>
                </div>
            </div>

            <div class="stage">
                <div class="layui-form-item">
                    <label class="layui-form-label">二阶段质量分<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="quality" lay-verify="required|isNumber|isZero" placeholder="请输入二阶段质量分" autocomplete="off" class="layui-input">
                        <input type="hidden" name="sectionNum" value="2">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage2 != null">(上次二阶段质量分{{stage2.quality}})</div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">二阶段进度(%)<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="schedule" lay-verify="required|isNumber|isZero" placeholder="请输入二阶段进度" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage2 != null">(上次二阶段进度{{stage2.schedule}}%)</div>
                </div>
            </div>

            <div class="stage">
                <div class="layui-form-item">
                    <label class="layui-form-label">三阶段质量分<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="quality" lay-verify="required|isNumber|isZero" placeholder="请输入三阶段质量分" autocomplete="off" class="layui-input">
                        <input type="hidden" name="sectionNum" value="3">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage3 != null">(上次三阶段质量分{{stage3.quality}})</div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">三阶段进度(%)<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="schedule" lay-verify="required|isNumber|isZero" placeholder="请输入三阶段进度" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage3 != null">(上次三阶段进度{{stage3.schedule}}%)</div>
                </div>
            </div>

            <div class="stage">
                <div class="layui-form-item">
                    <label class="layui-form-label">四阶段质量分<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="quality" lay-verify="required|isNumber|isZero" placeholder="请输入四阶段质量分" autocomplete="off" class="layui-input">
                        <input type="hidden" name="sectionNum" value="4">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage4 != null">(上次四阶段质量分{{stage4.quality}})</div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">四阶段进度(%)<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="schedule" lay-verify="required|isNumber|isZero" placeholder="请输入四阶段进度" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux" ng-show="stage4 != null">(上次四阶段进度{{stage4.schedule}}%)</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-inline">
                    <textarea type="text" name="remark" lay-verify="" placeholder="请输入备注" autocomplete="off" class="layui-textarea"></textarea>
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
        webApp.controller("weekAcceptanceCtr", function($scope,$http,$timeout){
            var projectId = YZ.getUrlParam("projectExternalId");
            var objectId = YZ.getUrlParam("objectId");
            var projectTypeSectionList = null; //存放阶段集合
            $scope.lastAcceptancesExternal = JSON.parse(localStorage.getItem("lastAcceptancesExternal"));
            if ($scope.lastAcceptancesExternal != null) {
                $scope.sectionDetail = JSON.parse($scope.lastAcceptancesExternal.sectionDetail);
                $scope.stage1 = $scope.sectionDetail[0];
                $scope.stage2 = $scope.sectionDetail[1];
                $scope.stage3 = $scope.sectionDetail[2];
                $scope.stage4 = $scope.sectionDetail[3];
            }

            YZ.ajaxRequestData("post", false, YZ.ip + "/projectTypeSection/getByProjectId", {projectId : YZ.getUrlParam("projectExternalId")} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    projectTypeSectionList = result.data;
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
                        if(value < 0 || value > 100) {
                            return "请输入(0-100)";
                        }
                    }
                });

                //监听提交
                form.on('submit(demo1)', function(data) {
                    var objectArray = new Array();
                    $(".stage").each(function () {
                        var tempId = 0;
                        for (var i = 0; i < projectTypeSectionList.length; i++) {
                            if (projectTypeSectionList[i].sectionNum == $(this).find("input[name='sectionNum']").val()) {
                                tempId = projectTypeSectionList[i].id;
                                break;
                            }
                        }
                        var objectJson = {
                            schedule : $(this).find("input[name='schedule']").val(),
                            quality : $(this).find("input[name='quality']").val(),
                            sectionId : tempId,
                        };
                        objectArray.push(objectJson);

                    });
                    var dataJson = {
                        sectionDetail : JSON.stringify(objectArray),
                        projectId : projectId,
                        id : objectId,
                        remark : data.field.remark
                    };
                    console.log(dataJson);
                    YZ.ajaxRequestData("post", false, YZ.ip + "/projectWeekAcceptance/update", dataJson , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            layer.alert('周验收成功.', {
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
