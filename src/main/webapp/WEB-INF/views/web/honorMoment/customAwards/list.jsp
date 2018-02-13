<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>自定义奖项</title>

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
                            <label class="layui-form-label">奖项名称</label>
                            <div class="layui-input-block">
                                <input class="layui-input" id="awardsName" name="awardsName" placeholder="奖项名称" >
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">类型</label>
                            <div class="layui-input-block">
                                <select id="type">
                                    <option value="">选择类型</option>
                                    <option value="0">个人奖项</option>
                                    <option value="1">团队奖项</option>
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
        <legend>自定义奖项列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_189"><i class="layui-icon">&#xe608;</i> 添加自定义奖项</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>奖项名称</th>
                        <th>类型</th>
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
    //默认本月
    window.onload = function () {
        var date = new Date();
        $("#month").val(date.getFullYear() + "-" + (date.getMonth() + 1));
    }

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
                url: YZ.ip + "/customAwards/queryCustomAwards",
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
                    data.awardsName = $("#awardsName").val();
                }
            },
            "columns": [
                { "data": "awardsName" },
                { "data": "type" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return 0 == data ? "个人奖项" : 1 == data ? "团队奖项" : "-";
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        return "<button onclick=\"updateData(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_190\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改奖项</button>";
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

    //添加
    function addData () {
        var index = layer.open({
            type: 2,
            title: '新增自定义奖项',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/honorMoment/customAwards/add"
        });
        layer.full(index);
    }

    //修改数据
    function updateData(id) {
        layer.prompt({
            formType: 3,
            value: "",
            title: '请输入奖项名称',
            area: ['400px', '200px'] //自定义文本域宽高
        }, function(value, index, elem){
            var arr = {
                id : id,
                awardsName : value
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/customAwards/updateCustomAwards", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    layer.close(index);
                    dataTable.ajax.reload();
                }
            });
        });
    }


    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

    });


</script>
</body>
</html>
