<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>第三维评分列表</title>

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

                        <div class="layui-inline">
                            <label class="layui-form-label">选择员工</label>
                            <div class="layui-input-block">
                                <select name="userId" lay-verify="required" lay-search="">
                                    <option value="">选择或搜索员工</option>
                                </select>
                            </div>
                        </div>

                        <%--<div class="layui-inline">
                            <label class="layui-form-label">选择类型</label>
                            <div class="layui-input-block">
                                <select name="type" id="type">
                                    <option value="0">周打分</option>
                                    <option value="1">月打分</option>
                                </select>
                            </div>
                        </div>--%>
                        <div class="layui-inline">
                            <label class="layui-form-label">时间</label>
                            <div class="layui-input-block">
                                <input type="text" id="monthTime" name="monthTime" lay-verify="" placeholder="请选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
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
        <legend>第三维评分列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_122"><i class="layui-icon">&#xe608;</i> 添加第三维评分</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>指标名称</th>
                        <th>员工名称</th>
                        <th>评分数</th>
                        <th>月份</th>
                        <th>创建人</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
                        <th>创建时间</th>
                        <th>备注</th>
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
        $("#monthTime").val(date.getFullYear() + "-" + (date.getMonth() + 1));
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
                url: YZ.ip + "/threeVeidooScore/list",
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
                    data.userId = $("select[name='userId']").val();
                    data.type = 1;
                    data.date = $("input[name='monthTime']").val() == "" ? new Date().getTime() : new Date($("input[name='monthTime']").val()).getTime();
                }
            },
            "columns": [
                { "data": "targetName" },
                { "data": "userName" },
                { "data": "score" },
                { "data": "monthTime" },
                { "data": "createUserName" },
                { "data": "startTime" },
                { "data": "endTime" },
                { "data": "createTime" },
                { "data": "msg" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM");
                    },
                    "targets": 3
                },
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
                        return "<button onclick='updateData(" + object + ")' class='layui-btn layui-btn-small hide checkBtn_123'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>"
                                // + "<button onclick=\"deleteData(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-danger\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button>"
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
        getDepartmentIdUserList(0);
        form.render();

    });

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加第三维评分',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/threeVeidooScore/add"
        });
        layer.full(index);
    }

    //删除
    function deleteData (id) {
        layer.confirm("是否确认删除该配置？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/threeVeidoo/delete", {id : id} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('删除成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 5 //动画类型
                    }, function(){
                        dataTable.ajax.reload();
                        layer.close(index);
                    });
                }
            });
        }, function(){
            //layer.msg('已取消.', {icon: 2});
        });
    }

    //修改
    function updateData (detail) {
        localStorage.setItem("threeVeidooScore", JSON.stringify(detail));
        var index = layer.open({
            type: 2,
            title: '修改第三维评分',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/threeVeidooScore/edit"
        });
        layer.full(index);
    }


</script>
</body>
</html>
