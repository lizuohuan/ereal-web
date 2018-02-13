<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加K常规比例分配</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加K常规比例分配</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">时间类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="timeType" name="timeType" lay-verify="required">
                    <option value="0">周</option>
                    <option value="1">月</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" id="time" name="time" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input">
            </div>
        </div>

        <%--<div class="layui-form-item">
            <label class="layui-form-label">事物类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="transactionSubId" lay-verify="required" lay-filter="transactionType">
                    <option value="">选择事物类型</option>
                </select>
            </div>
        </div>--%>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">工作类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="jobTypeId" lay-verify="required" lay-search="" lay-filter="jobTypeId">
                    <option value="">选择或搜索工作类型</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">选择员工<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="userId" lay-verify="required">
                    <option value="">选择事物类型</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">比例<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="ratio" lay-verify="required|isNumber|isZero" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">质量分<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="score" lay-verify="required|isNumber|isZero" placeholder="请输入质量分" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">额定工作时间(H)<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="jobTypeTime" lay-verify="required|isNumber|isZero" placeholder="请输入额定工作时间" autocomplete="off" class="layui-input" maxlength="10">
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

    layui.use(['form', 'layedit', 'laydate'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getAllDepartment(0);
        //getTransactionList(0);

        var start = {
            //min: laydate.now(),
            max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };

        var end = {
            min: laydate.now()
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };

        document.getElementById('time').onclick = function(){
            start.elem = this;
            laydate(start);
            getJobTypeList(1);
            $("select[name='userId']").parent().parent().hide();
            form.render();
        }

        //自定义验证规则
        form.verify({
            isNumber: function(value) {
                if(value.length > 0 && !YZ.isDouble.test(value)) {
                    return "请输入一个整数";
                }
            },
            isZero : function (value) {
                if(value < 0 || value > 100) {
                    return "请输入(0-100)";
                }
            }
        });

        /*//事务过滤器
        form.on('select(transactionType)', function(data){
            if ($("#time").val() != "") {
                getJobTypeList(data.value);
            }
            else {
                layer.msg('请选择时间.', {icon: 2, anim: 6});
                return false;
            }
            form.render();
        });*/

        //事务过滤器
        form.on('select(jobTypeId)', function(data){
            queryKGeneralUser($("#timeType").val(), YZ.getTimeStamp($("#time").val()), data.value, 0);
            form.render();
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.time = YZ.getTimeStamp(data.field.time);
            console.log(data.field);
            YZ.ajaxRequestData("post", false, YZ.ip + "/kGeneralRatio/addKGeneralRatio", data.field , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    layer.alert('添加成功.', {
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
        form.render();
    });

    /**
     * 获取 K常规 用户 列表
     * @param timeType 时间类型 0：周 1：月
     * @param time 时间戳
     * @param jobTypeId 常规事务类型ID (可选)
     * @param departmentId 部门ID (可选，默认当前用户的部门ID)
     * @return
     */
    function queryKGeneralUser(timeType, time, jobTypeId, selectId) {
        var arr = {
            timeType : timeType,
            time : time,
            jobTypeId : jobTypeId,
            departmentId : YZ.getUserInfo().departmentId
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/kGeneralRatio/queryKGeneralUser", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索员工</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].userId + "\">" + result.data[i].userName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].userId + "\">" + result.data[i].userName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='userId']").html(html);
                $("select[name='userId']").parent().parent().show();
            }
        });
    }

    //获取工作列表
    function getJobTypeList(transactionType) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/jobType/getJobTypeByTransactionForWeb", {departmentId : YZ.getUserInfo().departmentId, transaction : transactionType, source : 1}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索事务类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].jobTypeName + "(" + result.data[i].departmentName + ")</option>";
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='jobTypeId']").html(html);
                $("select[name='jobTypeId']").parent().parent().show();
            }
        });
    }



</script>
</body>
</html>
