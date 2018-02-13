<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>第三维配置列表</title>

    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <fieldset class="layui-elem-field"></button>
        <legend>第三维配置列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote layui-hide">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal"><i class="layui-icon">&#xe608;</i> 添加第三维配置</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>指标名称</th>
                        <th>指标权重</th>
                        <th>描述</th>
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
            //dataTable 加载加载完成回调函数
            "fnDrawCallback": function (sName, oData, sExpires, sPath) {
                checkJurisdiction(); //调用权限
                form.render();
            },
            "ajax":  {
                url: YZ.ip + "/threeVeidoo/list",
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
                }
            },
            "columns": [
                { "data": "targetName" },
                { "data": "weight" },
                { "data": "describe" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                       if (data == "" || data == null) return "--";
                       else return data;
                    },
                    "targets": 2
                },
                {
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='updateData(" + object + ")' class='layui-btn layui-btn-small hide checkBtn_121'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>"
                                // + "<button onclick=\"deleteData(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-danger\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button>"
                                ;
                    },
                    "targets": 3
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

    });

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加第三维配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/threeVeidoo/add"
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
        localStorage.setItem("threeVeidoo", JSON.stringify(detail));
        var index = layer.open({
            type: 2,
            title: '修改第三维配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/threeVeidoo/edit"
        });
        layer.full(index);
    }


</script>
</body>
</html>
