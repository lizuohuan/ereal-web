<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>第二维评分配置</title>

    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">选择部门</label>
                            <div class="layui-input-block">
                                <select name="departmentId" lay-verify="" lay-search="" lay-filter="department">
                                    <option value="">选择或搜索部门</option>
                                </select>
                            </div>
                        </div>
                        <%--<div class="layui-inline">
                            <label class="layui-form-label">时间类型</label>
                            <div class="layui-input-block">
                                <select id="timeType" name="timeType">
                                    <option value="0">周</option>
                                    <option value="1">月</option>
                                </select>
                            </div>
                        </div>--%>
                        <div class="layui-inline">
                            <label class="layui-form-label">针对月份</label>
                            <div class="layui-input-block">
                                <input type="text" name="targetTime" lay-verify="" placeholder="请选择针对月份" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"  autocomplete="off" class="layui-input" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" id="search"><i class="layui-icon">&#xe615;</i> 搜索</button>
                            <button type="reset" class="layui-btn layui-btn-primary">清空</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field"></button>
        <legend>第二维评分配置列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addSecondTargetConfig()" class="layui-btn layui-btn layui-btn-small layui-btn-normal"><i class="layui-icon">&#xe608;</i> 评分一次</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>公司名称</th>
                        <th>部门名称</th>
                        <th>总经理评分</th>
                        <th>值总评分</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
                    </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>
    var form = null;
    var dataTable = null;
    $(document).ready(function() {
        dataTable = $('#dataTable').DataTable( {
            "searching": false,"bStateSave": true, //状态保存，使用了翻页或者改变了每页显示数据数量，会保存在cookie中，下回访问时会显示上一次关闭页面时的内容。
            "processing": true,
            "serverSide": true,
            "bLengthChange": false,"bSort": false, //关闭排序功能
            //"pagingType": "bootstrap_full_number",
            'language': {
                'emptyTable': '没有数据',
                'loadingRecords': '加载中...',
                'processing': '查询中...',
                'search': '全局搜索:',
                'lengthMenu': '每页 _MENU_ 件',
                'zeroRecords': '没有您要搜索的内容',
                'paginate': {
                    'first':      '第一页',
                    'last':       '最后一页',
                    'next':       '下一页',
                    'previous':   '上一页'
                },
                'info': '第 _PAGE_ 页 / 总 _PAGES_ 页',
                'infoEmpty': '没有数据',
                'infoFiltered': '(过滤总件数 _MAX_ 条)'
            },
            //dataTable 加载加载完成回调函数
            "fnDrawCallback": function (sName, oData, sExpires, sPath) {
                checkJurisdiction(); //调用权限
                form.render();
            },
            "ajax":  {
                url: YZ.ip + "/secondTargetScoreDepartment/queryByItems",
                headers: {
                    "token" : YZ.getUserInfo() == null ? null : YZ.getUserInfo().token,
                },
                "dataSrc": function(json) {
                    if (json.code == 200) {
                        console.log(json.data);
                        return json.data;
                    }
                    return [];
                },
                "data": function(data) {
                    //高级查询参数
                    data.isScore = 1;
                    data.departmentId = $("select[name='departmentId']").val();
                    data.timeType = 1; //默认查询月
                    if ($("input[name='targetTime']").val() != "") {
                        data.time = YZ.getTimeStamp($("input[name='targetTime']").val());
                    }
                }
            },
            "columns": [
                { "data": "companyName" },
                { "data": "departmentName" },
                { "data": "managerGrade" },
                { "data": "dutyGrade" },
                { "data": "startTime" },
                { "data": "endTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "--";
                        else return data;
                    },
                    "targets": 0
                },
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "--";
                        else return data;
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "--";
                        else return data;
                    },
                    "targets": 2
                },
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "--";
                        else return data;
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 5
                },
            ]
        } );

        $("#search").click(function(){
            dataTable.ajax.reload();
            return false;
        });
    } );

    //提供给子页面
    var closeNodeIframe = function () {
        dataTable.ajax.reload();
        var index = layer.load(1, {shade: [0.5,'#eee']});
        setTimeout(function () {layer.close(index);}, 600);
    }

    layui.use(['form', 'layedit', 'laydate', 'layim'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getAllDepartment(0);

    });

    //添加
    function addSecondTargetConfig() {
        if (YZ.getUserInfo().roleId != 3 && YZ.getUserInfo().roleId != 5) {
            layer.msg('抱歉，您没有权限.', {icon: 2, anim: 6});
            return false;
        }
        var index = layer.open({
            type: 2,
            title: '评分一次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/twoScore/add"
        });
        layer.full(index);
    }


</script>
</body>
</html>
