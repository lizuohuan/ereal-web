<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加项目类型</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .layui-form-label{width: 200px;}
        .layui-input-block{margin-left: 230px;}
        .layui-layer{top: 200px !important;}
    </style>
</head>
<body>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>添加项目类型</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">项目类型名称<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="projectTypeName" lay-verify="required" placeholder="请输入项目类型名称" autocomplete="off" class="layui-input" maxlength="50">
                </div>
            </div>

            <fieldset class="layui-elem-field stage" style="margin-top: 20px;">
                <legend>第一阶段</legend>
                <div class="layui-form-item layui-hide">
                    <label class="layui-form-label">阶段名称<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionName" value="第一阶段" lay-verify="required" placeholder="请输入阶段名称" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段描述<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionDescribe" lay-verify="required" placeholder="请输入阶段描述" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段所需要花费的时长<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="number" name="sectionDays" lay-verify="required" placeholder="请输入阶段所需要花费的时长" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                    <div class="layui-form-mid layui-word-aux">单位为: 天</div>
                </div>
                <input type="hidden" name="sectionNum" value="1">
            </fieldset>

            <fieldset class="layui-elem-field stage" style="margin-top: 20px;">
                <legend>第二阶段</legend>
                <div class="layui-form-item layui-hide">
                    <label class="layui-form-label">阶段名称<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionName" value="第二阶段" lay-verify="required" placeholder="请输入阶段名称" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段描述<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionDescribe" lay-verify="required" placeholder="请输入阶段描述" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段所需要花费的时长<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="number" name="sectionDays" lay-verify="required" placeholder="请输入阶段所需要花费的时长" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                    <div class="layui-form-mid layui-word-aux">单位为: 天</div>
                </div>
                <input type="hidden" name="sectionNum" value="2">
            </fieldset>

            <fieldset class="layui-elem-field stage" style="margin-top: 20px;">
                <legend>第三阶段</legend>
                <div class="layui-form-item layui-hide">
                    <label class="layui-form-label">阶段名称<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionName" value="第三阶段" lay-verify="required" placeholder="请输入阶段名称" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段描述<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionDescribe" lay-verify="required" placeholder="请输入阶段描述" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段所需要花费的时长<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="number" name="sectionDays" lay-verify="required" placeholder="请输入阶段所需要花费的时长" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                    <div class="layui-form-mid layui-word-aux">单位为: 天</div>
                </div>
                <input type="hidden" name="sectionNum" value="3">
            </fieldset>

            <fieldset class="layui-elem-field stage" style="margin-top: 20px;">
                <legend>第四阶段</legend>
                <div class="layui-form-item layui-hide">
                    <label class="layui-form-label">阶段名称<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionName" value="第四阶段" lay-verify="required" placeholder="请输入阶段名称" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段描述<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="sectionDescribe" lay-verify="required" placeholder="请输入阶段描述" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">阶段所需要花费的时长<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="number" name="sectionDays" lay-verify="required" placeholder="请输入阶段所需要花费的时长" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                    <div class="layui-form-mid layui-word-aux">单位为: 天</div>
                </div>
                <input type="hidden" name="sectionNum" value="4">
            </fieldset>


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

        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            //自定义验证规则
            form.verify({

            });

            form.render();
            //监听提交
            form.on('submit(demo1)', function(data) {
                var objectArray = new Array();
                $(".stage").each(function () {
                    var objectJson = {
                        sectionName : $(this).find("input[name='sectionName']").val(),
                        sectionDescribe : $(this).find("input[name='sectionDescribe']").val(),
                        sectionDays : $(this).find("input[name='sectionDays']").val(),
                        sectionNum : $(this).find("input[name='sectionNum']").val(),
                    };
                    objectArray.push(objectJson);
                });

                data.field.projectTypeSectionJson = JSON.stringify(objectArray);
                console.log(data.field);

                YZ.ajaxRequestData("post", false, YZ.ip + "/projectType/save", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('添加项目类型成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 3 //动画类型
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


    </script>
</body>
</html>
