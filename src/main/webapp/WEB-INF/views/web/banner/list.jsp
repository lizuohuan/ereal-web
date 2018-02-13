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
                            <label class="layui-form-label">标题</label>
                            <div class="layui-input-inline">
                                <input type="text" id="title" lay-verify="" placeholder="请输入标题" autocomplete="off" class="layui-input" maxlength="20">
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
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_130"><i class="layui-icon">&#xe608;</i> 添加banner</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>排序</th>
                        <th width="200px;">标题</th>
                        <th width="300px;">备注</th>
                        <th>创建者</th>
                        <th>创建时间</th>
                        <th>banner类型</th>
                        <th>审核状态</th>
                        <th>是否显示</th>
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
                url: YZ.ip + "/banner/list",
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
                    data.title = $("#title").val();
                    data.companyId = $("#companyId").val();
                }
            },
            "columns": [
                { "data": "order" },
                { "data": "title" },
                { "data": "remarks" },
                { "data": "name" },
                { "data": "createTime" },
                { "data": "type" },
                { "data": "status" },
                { "data": "isShow" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        if (data == 1) return "普通";
                        if (data == 2) return "审核";
                        if (data == 3) return "生日消息";
                        if (data == 4) return "统计页Banner";
                    },
                    "targets": 5
                },
                {
                    "render": function(data, type, row) {
                        if (row.type == 2) {
                            if (data == 0) return "待审核";
                            if (data == 1) return "已发布";
                            if (data == 2) return "不通过";
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "<input bannerId=\"" + row.id + "\" lay-filter=\"isShow\" type=\"checkbox\" name=\"isShow\" lay-skin=\"switch\" title=\"开关\" lay-text=\"是|否\">";
                        if (data == 1) return "<input bannerId=\"" + row.id + "\" lay-filter=\"isShow\" type=\"checkbox\" name=\"isShow\" lay-skin=\"switch\" title=\"开关\" lay-text=\"是|否\" checked>";
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        var btn = "";
                        if (row.type == 2 && YZ.getUserInfo().roleId == 5 && row.status == 0) {
                            btn = "<button onclick='adoptToExamine(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_141\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;确认发布</button>" +
                                    "<button onclick='rejectToExamine(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_142\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;打回</button>";
                        }
                        return "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_131'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>"
                                + btn
                                ;
                    },
                    "targets": 8
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
            content: YZ.ip + "/page/banner/add"
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
            content: YZ.ip + "/page/banner/edit?bannerId=" + id
        });
        layer.full(index);
    }

    //修改状态
    function updateStatus(id, isShow) {
        var index = layer.load(1, {
            shade: [0.1,'#fff'] //0.1透明度的白色背景
        });
        var arr = {
            id : id,
            isShow : isShow
        }
        YZ.ajaxRequestData("post", false, YZ.ip + "/banner/update", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                dataTable.ajax.reload();
                layer.close(index);
            }
        });
    }

    //审核通过确认发布
    function adoptToExamine (id) {
        var index = layer.load(1, {shade: [0.5,'#eee']});
        var index2 = layer.confirm('是否确认发布？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            var arr = {
                id : id,
                status : 1
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/banner/updateStatus", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.close(index);
                    layer.close(index2);
                }
            });
        }, function(){layer.close(index);});
    }

    //打回
    function rejectToExamine (id) {
        var index = layer.load(1, {shade: [0.5,'#eee']});
        var index2 = layer.confirm('是否确认打回？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            var arr = {
                id : id,
                status : 2
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/banner/updateStatus", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.close(index);
                    layer.close(index2);
                }
            });
        }, function(){layer.close(index);});
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        getCompanyListType(null, 0);
        form.on("switch(isShow)", function (data) {
            console.log(data);
            var bannerId = $(this).attr("bannerId");
            if (data.elem.checked) {
                updateStatus(bannerId, 1);
            }
            else {
                updateStatus(bannerId, 0);
            }
            form.render();
        });

    });


</script>
</body>
</html>
