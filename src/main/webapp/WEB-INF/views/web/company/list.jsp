<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>公司列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend>公司列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_49"><i class="layui-icon">&#xe608;</i> 添加公司</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>公司名称</th>
                    <th>公司类型</th>
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
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>

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
                url: YZ.ip + "/company/listForWeb",
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
                { "data": "companyName" },
                { "data": "type" },
                { "data": "createTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "总公司";
                        else return "常规分公司";
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 2
                },
                {
                    "render": function(data, type, row) {
                        var strBtn = "";
                        if (row.type == 0) {
                            strBtn = "<button class=\"layui-btn layui-btn-disabled layui-btn-small layui-btn-danger hide checkBtn_160\"><i class=\"fa fa-trash-o fa-fw\"></i>&nbsp;删除</button>"
                        }
                        else {
                            strBtn = "<button onclick=\"deleteCompany(" + row.id + ", '" + row.companyName + "')\" class=\"layui-btn layui-btn-small layui-btn-danger hide checkBtn_160\"><i class=\"fa fa-trash-o fa-fw\"></i>&nbsp;删除</button>"
                        }
                        return "<button onclick=\"updateData(" + row.id + ", '" + row.companyName + "')\"  class=\"layui-btn layui-btn-small hide checkBtn_50\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>" +
                                strBtn;
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
    function addData () {
        var index = layer.open({
            type: 2,
            title: '添加公司',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/company/add"
        });
        layer.full(index);
    }

    //修改
    function updateData (id, name) {
        console.log(id);
        console.log(name);
        layer.prompt({
            formType: 3,
            value: name,
            title: '请输入公司名称',
            area: ['400px', '200px'] //自定义文本域宽高
        }, function(value, index, elem){
            var arr = {
                id : id,
                companyName : value
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/company/updateCompany", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
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
    });

    //删除公司
    function deleteCompany (id, companyName) {
        var index1 = layer.confirm("<span style=\"color: red;font-weight: bold\">此操作不可逆，是否确认删除&nbsp;" + companyName + "</span>？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            layer.close(index1);

            var html = '<form class="layui-form layui-form-pane" action="">' +
                    '<div class="layui-form-item">' +
                    '<label class="layui-form-label">登录密码</label>' +
                    '<div class="layui-input-block">' +
                    '<input type="password" id="password" autocomplete="off" placeholder="请输入登录密码" class="layui-input" maxlength="16">' +
                    '</div>' +
                    '</div>' +
                    '</form>';
            var index = YZ.formPopup(html, "密码验证", ["500px","500px"], function () {
                if ($("#password").val() == "") {
                    layer.msg('密码不能为空.', {icon: 2, anim: 6});
                    $("#password").focus();
                    return false;
                }
                var arr = {
                    account : YZ.getUserInfo().account,
                    password : $.md5($("#password").val())
                }
                if (arr.password == YZ.getUserInfo().password) {
                    YZ.ajaxRequestData("post", false, YZ.ip + "/company/delCompany", {companyId : id} , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            var index2 = layer.load(1, {shade: [0.5,'#eee']});
                            dataTable.ajax.reload();
                            layer.close(index);
                            layer.close(index2);
                        }
                    });
                }
                else {
                    layer.msg("密码错误.", {icon: 2, anim: 6, time: 1000, offset: 't'});
                    $("#password").focus();
                    return false;
                }
            }, function () {
            });

            /*layer.prompt({
                formType: 1,
                title: '请输入登录密码',
                area: ['400px', '200px'] //自定义文本域宽高
            }, function(value, index, elem){
                var arr = {
                    account : YZ.getUserInfo().account,
                    password : $.md5(value)
                }
                if (arr.password == YZ.getUserInfo().password) {
                    YZ.ajaxRequestData("post", false, YZ.ip + "/company/delCompany", {companyId : id} , null , function(result) {
                        if (result.flag == 0 && result.code == 200) {
                            var index2 = layer.load(1, {shade: [0.5,'#eee']});
                            dataTable.ajax.reload();
                            layer.close(index);
                            layer.close(index2);
                        }
                    });
                }
                else {
                    layer.msg("密码错误.", {icon: 2, anim: 6, time: 1000, offset: 't'});
                    return false;
                }
               /!* YZ.ajaxRequestData("post", false, YZ.ip + "/user/lockPassword", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        YZ.ajaxRequestData("post", false, YZ.ip + "/company/delCompany", {companyId : id} , null , function(result) {
                            if (result.flag == 0 && result.code == 200) {
                                var index2 = layer.load(1, {shade: [0.5,'#eee']});
                                dataTable.ajax.reload();
                                layer.close(index);
                                layer.close(index2);
                            }
                        });
                    }
                });*!/
            });*/

        }, function(){

        });
    }
</script>
</body>
</html>
