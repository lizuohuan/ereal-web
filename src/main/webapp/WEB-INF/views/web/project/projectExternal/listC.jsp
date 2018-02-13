<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>外部项目列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend>外部项目批量处理列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button lay-submit="" lay-filter="submitWork" class="layui-btn layui-btn-small layui-btn-default hide checkBtn_84" onclick="passProject()">通过已选项目</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th width="110px;"><input type="checkbox" name="" lay-skin="primary" lay-filter="allChoose" title="勾选本页"></th>
                    <th>项目编号</th>
                    <th>项目名称</th>
                    <th>项目组</th>
                    <th>所在部门</th>
                    <th>进度</th>
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
                form.render();
            },
            "ajax":  {
                url: YZ.ip + "/project/getAuditProject",
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
                }
            },
            "columns": [
                { "data": "" },
                { "data": "projectNumber" },
                { "data": "projectName" },
                { "data": "projectGroupName" },
                { "data": "departmentName" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return "<input type=\"checkbox\" value=\"" + row.id + "\" lay-skin=\"primary\" title=\"勾选\">";;
                    },
                    "targets": 0
                },
                {
                    "render": function(data, type, row) {
                        //获取最新一条记录的进度
                        var progress = Number(row.progress * 100).toFixed(2);
                        var seepHtml = '<div class="layui-progress layui-progress-big" lay-showpercent="true">' +
                                '<div class="layui-progress-bar layui-bg-orange" lay-percent="' + progress + '%" style="width: ' + progress + '%;"><span class="layui-progress-text"> ' + progress + '%</span></div>' +
                                '</div>';
                        return seepHtml;
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

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        //全选
        form.on('checkbox(allChoose)', function(data){
            var child = $(data.elem).parents('table').find('tbody input[type="checkbox"]');
            child.each(function(index, item){
                item.checked = data.elem.checked;
            });
            form.render('checkbox');
        });

        form.render();
    });

    //批量通过
    function passProject () {
        form.on('submit(submitWork)', function(data){
            var child = $("#dataTable").find('tbody input[type="checkbox"]');
            var ids = [];
            child.each(function(){
                if ($(this).is(':checked')) {
                    ids.push($(this).val());
                }
            });
            if (ids.length == 0) {
                layer.msg('至少勾选一个项目.', {icon: 2, anim: 6});
                return false;
            }
            else {
                var arr = {
                    projectIds : ids.toString(),
                }
                YZ.ajaxRequestData("post", false, YZ.ip + "/project/saveUpdateList", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    }
                });
            }
        });
    }



</script>
</body>
</html>
