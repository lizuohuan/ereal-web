<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>员工本月的出勤情况</title>

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
                            <label class="layui-form-label">天数类型</label>
                            <div class="layui-input-block">
                                <select name="type">
                                    <option value="">请选择天数类型</option>
                                    <%--<option value="1">请假</option>--%>
                                    <option value="2">转正前上的天数</option>
                                    <option value="3">月中入职未上天数</option>
                                    <option value="4">离职后未上的天数</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择配置的月份</label>
                            <div class="layui-input-block">
                                <select name="monthDaysId" lay-search="" lay-verify="required">
                                    <option value="">选择配置的月份</option>
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
        <legend>员工本月的出勤情况&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_126"><i class="layui-icon">&#xe608;</i> 添加</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>天数类型</th>
                        <th>天数</th>
                        <th>员工名</th>
                        <th>月份</th>
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
                url: YZ.ip + "/monthDaysUser/list",
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
                    data.type = $("select[name='type']").val();
                    data.source = 1;
                    data.monthDaysId = $("select[name='monthDaysId']").val();
                }
            },
            "columns": [
                { "data": "type" },
                { "data": "dayNum" },
                { "data": "userName" },
                { "data": "dateTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        /*if (data == 1) return "请假";*/
                        if (data == 2) return "转正前上的天数";
                        if (data == 3) return "月中入职未上天数";
                        if (data == 4) return "离职后未上的天数";
                        else return "--";
                    },
                    "targets": 0
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM");
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='updateData(" + object + ")' class='layui-btn layui-btn-small hide checkBtn_127'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>"
                                //+ "<button onclick=\"deleteData(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-danger\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button>"
                                ;
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

    layui.use(['form', 'layedit', 'laydate', 'layim'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        listForSelect();
        form.render();
    });

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加应出勤天数',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/monthDaysUser/add"
        });
        layer.full(index);
    }

    //修改
    function updateData (detail) {
        localStorage.setItem("monthDaysUser", JSON.stringify(detail));
        var index = layer.open({
            type: 2,
            title: '修改应出勤天数',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/monthDaysUser/edit"
        });
        layer.full(index);
    }
    /**
     * 获取配置列表
     * @return
     */
    function listForSelect(selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/monthDays/listForSelect", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索配置</option>";
                for (var i = 0; i < result.data.length; i++) {
                    result.data[i].dateTime = new Date(result.data[i].dateTime).format("yyyy-MM");
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].dateTime + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].dateTime + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='monthDaysId']").html(html);
                $("select[name='monthDaysId']").parent().parent().show();
            }
        });
    }

</script>
</body>
</html>
