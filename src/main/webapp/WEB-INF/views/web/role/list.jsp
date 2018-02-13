<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>角色列表</title>
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
                            <label class="layui-form-label">角色类型</label>
                            <div class="layui-input-block">
                                <select id="type" name="type" lay-verify="">
                                    <option value="">选择或搜索部门类型</option>
                                    <option value="">全部</option>
                                    <option value="0">总公司角色</option>
                                    <option value="1">常规角色</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button id="search" class="layui-btn" lay-submit="" ><i class="layui-icon">&#xe615;</i> 搜索</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field">
        <legend>角色列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_47"><i class="layui-icon">&#xe608;</i> 添加角色</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>角色名称</th>
                    <th>角色类型</th>
                    <th>角色描述</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>

</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var dataTable = null;
    $(document).ready(function() {
        dataTable = $('#dataTable').DataTable( {
            "bProcessing" : true, //DataTables载入数据时，是否显示‘进度’提示
            "searching": false, //关闭默认搜索
            "bSort":false,
            "bStateSave": true, //状态保存，使用了翻页或者改变了每页显示数据数量，会保存在cookie中，下回访问时会显示上一次关闭页面时的内容。
            "bPaginate" : false, //是否显示（应用）分页器
            "bInfo" : false, //是否显示页脚信息，DataTables插件左下角显示记录数
            "bLengthChange":false, //是否允许终端用户从一个选择列表中选择分页的页数，页数为10，25，50和100，需要分页组件bPaginate的支持
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
            "ajax":  {
                url: YZ.ip + "/role/list",
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
                    //高级查询参数
                    data.type = $("#type").val();
                    data.flag = 0;
                }
            },
            "columns": [
                { "data": "roleName" },
                { "data": "type" },
                { "data": "describe" },
                { "data": "isValid" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "总公司角色";
                        else return "常规角色";
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
                        if(data == 0 ){
                            return "隐藏";
                        }else{
                            return "显示";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        var msg = "";
                        if(row.isValid == 0){
                            msg = "设置显示";
                        }else{
                            msg = "设置隐藏";
                        }
                        var btn = "<button onclick='setIsValid("+row.id+","+row.isValid+")' class='layui-btn layui-btn-small'><i class='fa fa-list fa-edit'></i>&nbsp;"+msg+"</button>";

                        return "<button onclick=\"updateData(" + row.id + ", '" + row.roleName + "', '" + row.describe + "')\"  class=\"layui-btn layui-btn-small\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>"+btn;
                        //return "<button class=\"layui-btn layui-btn-small layui-btn-disabled\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>";
                    },
                    "targets": 4
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
            title: '添加角色',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/role/add"
        });
        layer.full(index);
    }

    function  setIsValid(id,isValid){
        var msg = "";
        if(isValid == 0){
            msg = "确认显示？";
        }else{
            msg = "确认隐藏？";
        }
        layer.open({
            content: msg,
            yes: function(index, layero){
                var arr = {
                    id : id,
                    isValid : 0 == isValid ? 1 : 0
                }
                YZ.ajaxRequestData("post", false, YZ.ip + "/role/updateRole", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        dataTable.ajax.reload();
                        layer.msg('操作成功.', {icon: 1});
                        var index = layer.load(1, {shade: [0.5,'#eee']});
                        setTimeout(function () {layer.close(index);}, 600);
                    }
                });
                layer.close(index); //如果设定了yes回调，需进行手工关闭
            }
        });

    }

    //修改
    function updateData (id, name, describe) {
        describe = describe == "null" ? "" : describe;
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">角色名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="name" autocomplete="off" lay-verify="required" value="' + name + '" placeholder="请输入角色名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">角色描述</label>' +
                '<div class="layui-input-block">' +
                '<textarea type="text" id="describe" lay-verify="required" placeholder="请输入角色描述" autocomplete="off" class="layui-textarea" maxlength="200">' + describe + '</textarea>' +
                '</div>' +
                '</div>' +
                '</form>';

        YZ.formPopup(html, "修改信息", ["500px", "300px"], function () {
            var arr = {
                id : id,
                roleName : $("#name").val(),
                describe : $("#describe").val()
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/role/updateRole", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('修改成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});
    }

</script>
</body>
</html>
