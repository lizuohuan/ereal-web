<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>项目类型列表</title>
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
                        <label class="layui-form-label">显示状态</label>
                        <div class="layui-input-inline">
                            <select id="isShow" lay-verify="">
                                <option value="">请选择</option>
                                <option value="">全部</option>
                                <option value="0">隐藏</option>
                                <option value="1">显示</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" id="search"><i class="layui-icon">&#xe615;</i> 搜索</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field">
        <legend>项目类型列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_80"><i class="layui-icon">&#xe608;</i> 添加项目类型</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>项目类型名称</th>
                        <th>显示状态</th>
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
                url: YZ.ip + "/projectType/list",
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
                    data.isShow = $("#isShow").val();
                }
            },
            "columns": [
                { "data": "projectTypeName" },
                { "data": "isShow" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "<i class='layui-icon'>&#x1006;</i>";
                        if (data == 1) return "<i class='layui-icon'>&#xe605;</i>";
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        var btnHtml = "";
                        if (row.isShow == 0) {
                            btnHtml = "<button onclick=\"updateDataIsShow(" + row.id + ", 1)\" class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_82\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;显示</button>"
                        }
                        else {
                            btnHtml = "<button onclick=\"updateDataIsShow(" + row.id + ", 0)\" class=\"layui-btn layui-btn-small layui-btn-danger hide checkBtn_82\"><i class=\"fa fa-list fa-edit\"></i>&nbsp 隐藏</button>"
                        }
                        var object = JSON.stringify(row.sections);
                        return "<button class=\"layui-btn layui-btn-small layui-btn-normal hide checkBtn_81\" " +
                                "onclick=\"updateData(" + row.id + ")\">" +
                                "<i class=\"fa fa-list fa-edit\"></i>&nbsp;查看/修改阶段</button>" +
                                btnHtml ;//"<button onclick='findStage(" + object + ")' class=\"layui-btn layui-btn-small layui-btn-normal\"><i class=\"fa fa-list fa-file-text-o\"></i>&nbsp;查看阶段</button>";
                    },
                    "targets": 2
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

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
    });

    //添加
    function addData () {
        var index = layer.open({
            type: 2,
            title: '添加项目类型',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectType/add"
        });
        layer.full(index);
    }

    //修改
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改项目类型',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectType/edit?projectTypeId=" + id
        });
        layer.full(index);
    }

    //修改显示或隐藏
    function updateDataIsShow (id, isShow) {
        YZ.ajaxRequestData("post", false, YZ.ip + "/projectType/update", {id : id, isShow : isShow} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                layer.msg('操作成功.', {icon: 1});
                dataTable.ajax.reload();
            }
        });
    }

    //查看阶段 -- 暂无用
    function findStage (sections) {
        console.log(sections);
        var html = "";
        layer.open({
            type: 1,
            skin: 'layui-layer-rim', //加上边框
            area: ['420px', '240px'], //宽高
            content: 'html内容'
        });
    }


</script>
</body>
</html>
