<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>banner列表</title>

    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .coverImg{width: 200px;height: 100px;border: 1px solid #eee;}
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
                            <label class="layui-form-label">选择公司</label>
                            <div class="layui-input-inline">
                                <select id="companyId" name="companyId" lay-filter="company" lay-verify="" lay-search="">
                                    <option value="">选择或搜索公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">banner位置</label>
                            <div class="layui-input-inline">
                                <select id="type">
                                    <option value="">选择类型</option>
                                    <option value="0">首页banner</option>
                                    <option value="4">统计banner</option>
                                </select>
                            </div>
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
        <legend>banner列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_195"><i class="layui-icon">&#xe608;</i> 添加banner</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>图片</th>
                        <th width="200px;">标题</th>
                        <th>banner位置</th>
                        <th>公司</th>
                        <th>创建者</th>
                        <th>创建时间</th>
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
                url: YZ.ip + "/companyBanner/queryCompanyBanner",
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
                    data.companyId = $("#companyId").val();
                }
            },
            "columns": [
                { "data": "imgUrl" },
                { "data": "title" },
                { "data": "type" },
                { "data": "companyName" },
                { "data": "createUserName" },
                { "data": "createTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return "<img src='"+YZ.ipImg+"/"+data+"' width='120px' height='100px'>";
                    },
                    "targets": 0
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 5
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "首页Banner";
                        if (data == 4) return "统计Banner";
                    },
                    "targets": 2
                },

                {
                    "render": function(data, type, row) {
                        var btn = "<button onclick='delBanner(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_197'><i class='fa fa-list fa-edit'></i>&nbsp;删除</button>";
                        return "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_196'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>"
                                + btn
                                ;
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
            title: '添加banner',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/companyBanner/add"
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改banner',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/companyBanner/edit?bannerId=" + id
        });
        layer.full(index);
    }

    //查看/修改数据
    function delBanner(id) {

        layer.confirm('确认删除吗？', {
            btn: ['确认', '取消']
            ,btn2: function(index, layero){
            }
        }, function(index, layero){
            // 确认
            YZ.ajaxRequestData("post", false, YZ.ip + "/companyBanner/delCompanyBanner", {id : id} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.close(index);
                }
            });
        });
    }




    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        getCompanyListType(null, 0);
//        form.on("switch(isShow)", function (data) {
//            console.log(data);
//            var bannerId = $(this).attr("bannerId");
//            if (data.elem.checked) {
//                updateStatus(bannerId, 1);
//            }
//            else {
//                updateStatus(bannerId, 0);
//            }
//            form.render();
//        });

    });


</script>
</body>
</html>
