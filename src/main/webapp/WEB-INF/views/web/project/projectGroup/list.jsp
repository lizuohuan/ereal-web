<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>项目组列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .userInfo{
            min-width: 100px;
            text-align: center;
            padding: 10px;
            float: left;
        }
        .userInfo img{
            width: 60px;
            height: 60px;
            border-radius: 50%;
        }
    </style>
<body>

<div class="admin-main">
    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">组名</label>
                            <div class="layui-input-block">
                                <input type="text" name="projectName" id="projectName" lay-verify="" placeholder="请输入组名" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择团队</label>
                            <div class="layui-input-block">
                                <select name="departmentId" id="departmentId" lay-filter="departmentId" lay-verify="" lay-search="">
                                    <option value="">选择或搜索公司和团队</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">项目经理</label>
                            <div class="layui-input-inline">
                                <select id="projectManagerId" name="projectManagerId" lay-search="" lay-verify="required">
                                    <option value="">选择或搜索项目经理</option>
                                    <option value="0" disabled>暂无</option>
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

    <fieldset class="layui-elem-field">
        <legend>项目组列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_67"><i class="layui-icon">&#xe608;</i> 添加项目组</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>组名</th>
                        <th>项目经理</th>
                        <th>所属部门</th>
                        <th>创建人</th>
                        <th>是否有效</th>
                        <th>创建时间</th>
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
                url: YZ.ip + "/projectGroup/list",
                headers: {
                    "token" : YZ.getUserInfo() == null ? null : YZ.getUserInfo().token,
                },
                "dataSrc": function(json) {
                    console.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function(data) {
                    data.projectName = $("#projectName").val();
                    data.departmentId = $("#departmentId").val();
                    data.isManager = $("#projectManagerId").val();
                }
            },
            "columns": [
                { "data": "projectName" },
                { "data": "projectManager.name" },
                { "data": "departmentName" },
                { "data": "createUserName" },
                { "data": "isValid" },
                { "data": "createTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 5
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "<i class='layui-icon'>&#x1006;</i>";
                        else return "<i class='layui-icon'>&#xe605;</i>";
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        var members = JSON.stringify(row.members);
                        return "<button class=\"layui-btn layui-btn-small hide checkBtn_68\" " +
                                "onclick=\"updateData(" + row.id + ")\">" +
                                "<i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>" +
                                "<button onclick='findUser(" + members + ")' class='layui-btn layui-btn-small layui-btn-normal'><i class='fa fa-list fa-file-text-o'></i>&nbsp;查看组员</button>";
                    },
                    "targets": 6
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

    //添加
    function addData () {
        var index = layer.open({
            type: 2,
            title: '添加项目组',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectGroup/add"
        });
        layer.full(index);
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getAllDepartment(0);
        //部门过滤器
        form.on('select(departmentId)', function(data){
            getIsManager(Number(data.value), 0);
            form.render();
        });
        form.render();
    });

    //修改
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改项目组',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectGroup/edit?projectGroupId=" + id
        });
        layer.full(index);
    }

    //查看组员
    function findUser (members) {
        console.log(members);
        if (members.length == 0) {
            layer.msg('没有组员.', {icon: 2});
            return false;
        }
        var html = "";
        for (var i = 0; i < members.length; i++) {
            members[i].avatar = members[i].avatar == "" || members[i].avatar == null ? YZ.ip + "/resources/img/0.jpg" : YZ.ipImg + "//" +members[i].avatar;
            html += "<div class=\"userInfo\">" +
                            "<img src=\"" + members[i].avatar + "\">" +
                            "<div style='padding: 5px;'>" + members[i].name + "</div>" +
                        "</div>";
        }

        layer.open({
            type: 1,
            title: '查看组员',
            shadeClose: true,
            shade: 0.5,
            area: ["600px", "300px"], //宽高
            content: html
        });
    }



</script>
</body>
</html>
