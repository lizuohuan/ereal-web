<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>K常规比例分配</title>

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
                                <select id="departmentId" name="departmentId" lay-verify="" lay-search="" lay-filter="department">
                                    <option value="">选择或搜索部门</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">事物类型</label>
                            <div class="layui-input-block">
                                <select name="transactionSubId" lay-verify="" lay-search="" lay-filter="transactionType">
                                    <option value="">选择事物类型</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">工作类型</label>
                            <div class="layui-input-block">
                                <select name="jobTypeId" lay-verify="required" lay-search="">
                                    <option value="">选择或搜索工作类型</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">时间类型</label>
                            <div class="layui-input-block">
                                <select id="timeType" name="timeType">
                                    <option value="0">周</option>
                                    <option value="1">月</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">时间</label>
                            <div class="layui-input-block">
                                <input type="text" id="time" name="time" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
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
        <legend>K常规比例分配列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_198"><i class="layui-icon">&#xe608;</i> 添加</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>员工名</th>
                        <th>比例</th>
                        <th>质量分</th>
                        <th>额定工作时间(H)</th>
                        <th>工作类型</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
                        <th>创建时间</th>
                        <th>创建人</th>
                        <th>操作</th>
                    </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>
    //默认查询当天
    window.onload = function () {
        var date = new Date();
        $("#time").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
    }
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
                url: YZ.ip + "/kGeneralRatio/queryKGeneralRatioByItems",
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
                    data.departmentId = $("select[name='departmentId']").val();
                    data.timeType = $("select[name='timeType']").val();
                    data.transactionSubId = $("select[name='transactionSubId']").val();
                    data.time = $("input[name='time']").val() == "" ? new Date().getTime() : new Date($("input[name='time']").val()).getTime();
                }
            },
            "columns": [
                { "data": "userName" },
                { "data": "ratio" },
                { "data": "score" },
                { "data": "jobTypeTime" },
                { "data": "jobTypeName" },
                { "data": "startTime" },
                { "data": "endTime" },
                { "data": "createTime" },
                { "data": "createUserName" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 5
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='updateData(" + row.id + ", " + row.ratio + ","+row.score+","+row.jobTypeTime+")' class='layui-btn layui-btn-small'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>"
                                ;
                    },
                    "targets": 9
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

        //事务过滤器
        form.on('select(department)', function(data){
            getTransactionList(0);
            $("select[name='jobTypeId']").parent().parent().hide();
            form.render();
        });

        //事务过滤器
        form.on('select(transactionType)', function(data){
            getJobTypeList(data.value, $("#departmentId").val());
            form.render();
        });

        form.render();
    });

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加K常规比例分配',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/kGeneralRatio/add"
        });
        layer.full(index);
    }

    //修改
    function updateData (id, ratio,score,jobTypeTime) {

        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">分配比例</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="ratio" autocomplete="off" lay-verify="required" value="' + ratio + '" placeholder="请输入比例" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">质量分</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="score" autocomplete="off" lay-verify="required" value="' + score + '" placeholder="请输入质量分" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">额定时间(H)</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="jobTypeTime" autocomplete="off" lay-verify="required" value="' + jobTypeTime + '" placeholder="请输入额定时间" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '</form>';

        YZ.formPopup(html, "修改信息", ["500px", "300px"], function () {
            var arr = {
                id : id,
                ratio : $("#ratio").val(),
                jobTypeTime : $("#jobTypeTime").val(),
                score : $("#score").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/kGeneralRatio/updateKGeneralRatio", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('修改成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});




    }

    //获取工作列表
    function getJobTypeList(transactionType, departmentId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/jobType/getJobTypeByTransactionForWeb", {transaction : transactionType, departmentId : departmentId, source : 0}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索事务类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].jobTypeName + "</option>";
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
