<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>事务类型列表</title>

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
                            <label class="layui-form-label">事务类型名称</label>
                            <div class="layui-input-block">
                                <input type="text" name="jobTypeName" id="jobTypeName" placeholder="请输入事务类型名称" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">事务类型</label>
                            <div class="layui-input-block">
                                <select name="transactionSubId" id="transaction">
                                    <option value="">选择事务类型</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">部门类型</label>
                            <div class="layui-input-block">
                                <select name="type" lay-filter="type">
                                    <option value="">选择部门类型</option>
                                    <option value="0">总公司部门</option>
                                    <option value="1">分公司部门</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">所属公司</label>
                            <div class="layui-input-block">
                                <select id="companyId" name="companyId" lay-search="" lay-filter="company">
                                    <option value="">选择或搜索公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">部门</label>
                            <div class="layui-input-block">
                                <select id="departmentId" name="departmentId" lay-search="">
                                    <option value="">选择或搜索部门</option>
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

    <fieldset class="layui-elem-field">
        <legend>事务类型列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_57"><i class="layui-icon">&#xe608;</i> 添加事务类型</button>
                <button onclick="importData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_199"><i class="layui-icon">&#xe608;</i> 导入事务类型</button>
                <button onclick="templateDownLoad()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_199"><i class="layui-icon">&#xe608;</i> 模版下载</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>事务类型名称</th>
                        <th>额定工作时间</th>
                        <th>事务类型</th>
                        <th>所在部门</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
            </table>
        </div>
    </fieldset>



    <form id="newUpload" method="post" enctype="multipart/form-data">
        <input id="File" type="file" name="File" accept="application/vnd.ms-excel" class="hide">
        <input type="hidden" name="type" value="1">
    </form>
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
                url: YZ.ip + "/jobType/list",
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
                    data.jobTypeName = $("#jobTypeName").val(); //事务类型名称
                    data.transaction = $("#transaction").val(); //事务
                    data.companyId = $("#companyId").val(); //公司ID
                    data.departmentId = $("#departmentId").val(); //部门ID
                }
            },
            "columns": [
                //{ "data": "realName", "field" : "A.real_name" },
                { "data": "jobTypeName" },
                { "data": "jobTypeTime" },
                { "data": "transactionSubName" },
                { "data": "departmentName" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == 0 || data == null) return "--";
                        else {return data}
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0 || data == null) return "--";
                        else {return data}
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        if(row.isValid == 0){
                            return "隐藏";
                        }
                        else{
                            return "显示";
                        }
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        var btn = "<button onclick=\"updateData(" + row.id + ", '" + row.jobTypeName + "', " + row.jobTypeTime + ", " + row.transactionSubId + ")\" class=\"layui-btn layui-btn-small hide checkBtn_58\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>";

                        if(row.isValid == 0){
                            btn += "<button onclick=\"updateIsValid(" + row.id + ", " + 1 + ")\" class=\"layui-btn layui-btn-small hide checkBtn_58\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;设置显示</button>";
                        }
                        else{
                            btn += "<button onclick=\"updateIsValid(" + row.id + ", " + 0 + ")\" class=\"layui-btn layui-btn-small hide checkBtn_58\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;设置隐藏</button>";
                        }

                        return btn;
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

    function updateIsValid(id,isValid){
        YZ.ajaxRequestData("post", false, YZ.ip + "/jobType/updateJobType", {id:id,isValid:isValid} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                dataTable.ajax.reload();
            }
        });

    }

    //提供给子页面
    var closeNodeIframe = function () {
        location.reload();
        var index = layer.load(1, {shade: [0.5,'#eee']});
        setTimeout(function () {layer.close(index);}, 600);
    }

    function templateDownLoad(){
        window.open(YZ.ip + "/resources/template/jobtype_template.xls", "_blank");
    }

    function importData(){
        $('#File').click();
    }

    //上传 .xls
    $('#File').change(function(){
        $("body").append(YZ.showShade("正在上传,请稍等..."));
        var file = this.files[0];
        var fr = new FileReader();
        if(window.FileReader) {
            fr.onloadend = function(e) {
                $("#newUpload").ajaxSubmit({
                    type: "POST",
                    url: YZ.ipImg + '/res/upload',
                    success: function(result) {
                        if (result.code == 200) {
                            $('#File').val("");
                            YZ.hideShade();
                            YZ.ajaxRequestData("get", false, YZ.ip + "/import/importJobType", {url : YZ.ipImg + "/" + result.data.url}, null , function(result){
                                if(result.flag == 0 && result.code == 200){
                                    var msg = "<p>导入成功</p>";

                                    var index = layer.alert(msg, {
                                        title: "温馨提示",
                                        closeBtn: 0
                                        ,anim: 3
                                    }, function(){
                                        location.reload();
                                    });
                                }else{
                                    layer.alert(result.msg);
                                }
                            });
                            $.ajax({
                                type: "POST",
                                url: YZ.ipImg + "/res/delete",
                                data: { url : result.data.url },
                                success: function () {}
                            });

                        } else {
                            YZ.hideShade();
                            $('#File').val("");
                            layer.alert(result.msg);
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    });

    //添加
    function addData () {
        var index = layer.open({
            type: 2,
            title: '添加事务类型',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/jobType/add"
        });
        layer.full(index);
    }

    //修改数据
    function updateData(id, name, jobTypeTime, transactionSubId) {
        var index = layer.open({
            type: 2,
            title: '添加事务类型',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/jobType/edit?id=" + id
        });
        layer.full(index);
    }



    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getTransactionList();
        form.render('select');

        //监听select事件--部门类型过滤器
        form.on('select(type)', function(data){
            console.log(data);
            if (Number(data.value) == 0) {
                getCompanyListType(0, 0);
                getDepartmentList(null, 0, 0);
                $("select[name='companyId']").parent().parent().hide();
            }
            else {
                getCompanyListType(1, 0);
            }
            form.render('select');
        });

        //公司过滤器
        form.on('select(company)', function(data){
            console.log(data);
            getDepartmentListType(Number(data.value) , 1, null, 0);
            form.render('select');
        });
    });


</script>
</body>
</html>
