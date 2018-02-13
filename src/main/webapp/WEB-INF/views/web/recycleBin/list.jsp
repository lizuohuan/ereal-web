<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>用户回收站列表</title>

    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">账号</label>
                            <div class="layui-input-block">
                                <input type="text" name="account" id="account" lay-verify="" placeholder="请输入账号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">姓名</label>
                            <div class="layui-input-block">
                                <input type="text" name="account" id="name" lay-verify="" placeholder="请输入姓名" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">手机号</label>
                            <div class="layui-input-block">
                                <input type="text" name="account" id="phone" lay-verify="" placeholder="请输入手机号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">用户类型</label>
                            <div class="layui-input-block">
                                <select lay-verify="" lay-filter="userType">
                                    <option value="">选择用户类型</option>
                                    <option value="0">总公司用户</option>
                                    <option value="1">分公司用户</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">所属公司</label>
                            <div class="layui-input-block">
                                <select id="companyId" name="companyId" lay-filter="company" lay-verify="" lay-search="">
                                    <option value="">选择或搜索公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">所属部门</label>
                            <div class="layui-input-block">
                                <select id="departmentId" name="departmentId" lay-verify="" lay-search="">
                                    <option value="">选择或搜索部门</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">角色</label>
                            <div class="layui-input-block">
                                <select id="roleId" name="roleId" lay-verify="" lay-search="">
                                    <option value="">选择或搜索角色</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">身份属性</label>
                            <div class="layui-input-block">
                                <select id="incumbency" name="type" lay-verify="">
                                    <option value="">选择身份属性</option>
                                    <option value="0">实习</option>
                                    <option value="1">磨合期</option>
                                    <option value="2">正式</option>
                                    <option value="3">离职</option>
                                </select>
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
        <legend>用户回收站列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>账号</th>
                        <th>姓名</th>
                        <th>手机号</th>
                        <th>所属公司</th>
                        <th>所属部门</th>
                        <th>角色名</th>
                        <th>入职时间</th>
                        <th>转正时间</th>
                        <th>工资</th>
                        <th>身份属性</th>
                        <th>操作</th>
                    </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
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
                url: YZ.ip + "/user/findUserPageFoIsValid",
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
                    data.account = $("#account").val(); //账号
                    data.name = $("#name").val(); //姓名
                    data.phone = $("#phone").val(); //手机号
                    data.companyId = $("#companyId").val(); //公司
                    data.departmentId = $("#departmentId").val(); //部门
                    data.roleId = $("#roleId").val(); //角色
                    data.incumbency = $("#incumbency").val(); //身份属性
                }
            },
            "columns": [
                //{ "data": "realName", "field" : "A.real_name" },
                { "data": "account" },
                { "data": "name" },
                { "data": "phone" },
                { "data": "companyName" },
                { "data": "departmentName" },
                { "data": "roleName" },
                { "data": "entryTime" },
                { "data": "positiveTime" },
                { "data": "salary" },
                { "data": "incumbency" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        else return data;
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        else return data;
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        return "<span class=\"money\">￥&nbsp;" + data + "</span>";
                    },
                    "targets": 8
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "实习";
                        if (data == 1) return "磨合期";
                        if (data == 2) return "正式";
                        if (data == 3) return "离职";
                    },
                    "targets": 9
                },
                {
                    "render": function(data, type, row) {
                        return "<button onclick='updateData(" + row.id + ", " + row.companyId + ")' class=\"layui-btn layui-btn-small hide checkBtn_164\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;分配用户</button>";
                    },
                    "targets": 10
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

        //监听select事件--用户类型过滤器
        form.on('select(userType)', function(data){
            console.log(data);
            if (Number(data.value) == 0) {
                $("select[name='companyId']").parent().parent().hide();
                //$("select[name='departmentId']").parent().parent().hide();
                getCompanyListType(0, 0);
                getDepartmentList(null, 0, 0);
            }
            else {
                getCompanyListType(1, 0);
            }
            getRoleListType(Number(data.value), 0);
            form.render('select');
        });
        //公司过滤器
        form.on('select(company)', function(data){
            console.log(data);
            getDepartmentListType(Number(data.value), 1, null, 0);
            form.render('select');
        });
    });

    //修改
    function updateData (id, companyId) {
        layer.open({
            type: 2,
            title: '分配用户',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/recycleBin/edit?id=" + id + "&companyId=" + companyId
        });
    }

    //查看详情
    function detailData(id) {
        layer.open({
            type: 2,
            title: '用户详情',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/user/detail?userId=" + id
        });
    }

</script>
</body>
</html>
