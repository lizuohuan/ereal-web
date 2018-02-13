<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加工作类型</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>添加工作类型</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">事务类别<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="transactionTypeId" lay-verify="required">
                        <option value="">选择事务类别</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">工作类型名称<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="transactionSubName" lay-verify="required" placeholder="请输入工作类型名称" autocomplete="off" class="layui-input" maxlength="20">
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
    <%@include file="../common/public-js.jsp" %>
    <script>

        //获取事务大类型列表
        function getTransactionMaxList () {
            YZ.ajaxRequestData("get", false, YZ.ip + "/transactionType/list", {}, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    var html = "<option value=\"\">选择事务类别</option>";
                    for (var i = 0; i < result.data.length; i++) {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].transactionName + "</option>";
                    }
                    if (result.data.length == 0) {
                        html += "<option value=\"0\" disabled>暂无</option>";
                    }
                    $("select[name='transactionTypeId']").html(html);
                }
            });
        }

        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            //自定义验证规则
            form.verify({

            });

            getTransactionMaxList();

            form.render();//重新渲染
            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.transactionTypeId = Number(data.field.transactionTypeId);
                YZ.ajaxRequestData("post", false, YZ.ip + "/transactionSub/save", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('添加工作类型成功.', {
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
