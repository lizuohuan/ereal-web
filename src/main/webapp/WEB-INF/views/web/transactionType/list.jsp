<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>工作类型列表</title>

    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote layui-hide">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">工作类型名称</label>
                            <div class="layui-input-block">
                                <input type="text" name="transactionSubName" id="transactionSubName" lay-verify="" placeholder="请输入事务类别名称" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">事务类别</label>
                            <div class="layui-input-block">
                                <select name="transactionTypeId" id="transactionTypeId" lay-verify="">
                                    <option value="">选择工作类型</option>
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
        <legend>工作类型列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_55"><i class="layui-icon">&#xe608;</i> 添加工作类型</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>事务类别</th>
                        <th>工作类型名称</th>
                        <th>显示/隐藏状态</th>
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
            "bProcessing" : true, //DataTables载入数据时，是否显示‘进度’提示
            "searching": false, //关闭默认搜索
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
                url: YZ.ip + "/transactionSub/list",
                headers: {
                    "token" : YZ.getUserInfo() == null ? null : YZ.getUserInfo().token,
                },
                "dataSrc": function(json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function(data) {
                    //高级查询参数
                    //data.transactionSubName = $("#transactionSubName").val(); //事务子类名
                    //data.transactionTypeId = $("#transactionTypeId").val(); //事务类别
                }
            },
            "columns": [
                { "data": "transactionTypeName" },
                { "data": "transactionSubName" },
                { "data": "isShow" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "<i class='layui-icon'>&#x1006;</i>";
                        if (data == 1) return "<i class='layui-icon'>&#xe605;</i>";
                    },
                    "targets": 2
                },
                {
                    "render": function(data, type, row) {
                        var btns = "";
                        if (row.isUpdate == 0) {
                            btns = "<button class=\"layui-btn layui-btn-disabled layui-btn-small hide checkBtn_56\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>"
                        }
                        else {
                            btns = "<button onclick=\"updateData(" + row.id + ", '" + row.transactionSubName + "')\" class=\"layui-btn layui-btn-small hide checkBtn_56\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>";
                            if (row.isShow == 1) {
                                btns += "<button onclick=\"updateStatus(" + row.id + ", 0)\" class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_59\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;隐藏</button>";
                            }
                            else {
                                btns += "<button onclick=\"updateStatus(" + row.id + ", 1)\" class=\"layui-btn layui-btn-warm layui-btn-small hide checkBtn_59\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;显示</button>";
                            }
                        }
                        return btns;
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

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加工作类型',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/transactionType/add"
        });
        layer.full(index);
    }

    //修改数据
    function updateData(id, name) {
        console.log(id);
        console.log(name);
        layer.prompt({
            formType: 3,
            value: name,
            title: '请输入工作类型名称',
            area: ['400px', '200px'] //自定义文本域宽高
        }, function(value, index, elem){
            var arr = {
                id : id,
                transactionSubName : value
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/transactionSub/update", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    layer.close(index);
                    dataTable.ajax.reload();
                }
            });
        });
    }

    //修改状态
    function updateStatus(id, status) {
        var arr = {
            id : id,
            isShow : status
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/transactionSub/update", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                layer.msg('操作成功.', {icon: 1});
                dataTable.ajax.reload();
            }
        });
    }


    //获取事务大类型列表
    function getTransactionMaxList () {
        YZ.ajaxRequestData("get", false, YZ.ip + "/transactionType/list", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择事务类别</option>";
                for (var i = 0; i < result.data.length; i++) {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].transactionName + "</option>";
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='transactionTypeId']").html(html);
            }
        });
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getTransactionMaxList();
        form.render();//重新渲染
    });


</script>
</body>
</html>
