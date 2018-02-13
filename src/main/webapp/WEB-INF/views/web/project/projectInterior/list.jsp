<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>内部项目列表</title>
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
                            <label class="layui-form-label">项目编号</label>
                            <div class="layui-input-block">
                                <input type="text" name="projectNumber" id="projectNumber" lay-verify="" placeholder="请输入项目编号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">项目名</label>
                            <div class="layui-input-block">
                                <input type="text" name="projectName" id="projectName" lay-verify="" placeholder="请输入项目名" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择内部项目专业</label>
                            <div class="layui-input-block">
                                <select name="projectMajorId" id="projectMajorId" lay-verify="" lay-search="">
                                    <option value="">请选择或搜索内部项目专业</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">项目状态</label>
                            <div class="layui-input-block">
                                <select name="status" id="status" lay-verify="">
                                    <option value="">请选择</option>
                                    <optgroup label="项目状态">
                                        <option value="0">审核中</option>
                                        <option value="1">审核通过</option>
                                        <option value="2">审核不通过</option>
                                    </optgroup>
                                    <optgroup label="结项状态">
                                        <option value="100">没有结项</option>
                                        <option value="101">已经结项</option>
                                    </optgroup>

                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">项目启动时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="startTime" id="startTime" lay-verify="" placeholder="项目启动时间" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this, min: '2010-01-01 00:00:00'})" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">项目截止时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="endTime" id="endTime" lay-verify="" placeholder="项目截止时间" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">是否对内</label>
                            <div class="layui-input-block">
                                <select name="atHome" id="atHome" lay-verify="">
                                    <option value="">请选择</option>
                                    <option value="">全部</option>
                                    <option value="0">对内</option>
                                    <option value="1">对外</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择团队</label>
                            <div class="layui-input-block">
                                <select name="departmentId" id="departmentId" lay-verify="" lay-search="" lay-filter="department">
                                    <option value="">选择或搜索公司和团队</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline ">
                            <label class="layui-form-label">是否终止</label>
                            <div class="layui-input-inline">
                                <select id="isTerminate" name="isTerminate"  lay-verify="">
                                    <option value="">选择或搜索项目状态</option>
                                    <option value="0">未终止</option>
                                    <option value="1">已终止</option>
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
        <legend>内部项目列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_69"><i class="layui-icon">&#xe608;</i> 添加内部项目</button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_181" onclick="projectDiaryExcel()">内部项目报表导出<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_201" onclick="importProject()">导入内部项目<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_201" onclick="templateDownLoad()">模版下载<i class="fa fa-file-text-o"></i></button>
                <%--<button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_139" onclick="batchDispose()">批量处理</button>--%>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>项目编号</th>
                        <th>项目名</th>
                        <%--<th>项目简称</th>--%>
                        <th>内部项目专业名</th>
                        <th>初始工作量</th>
                        <th>项目组</th>
                        <th>所在部门</th>
                        <th>项目启动时间</th>
                        <th>项目截止时间</th>
                        <th>创建人</th>
                        <th>是否对内</th>
                        <th>审核状态</th>
                        <th style="min-width: 80px;">进度</th>
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
<%@include file="../../common/public-js.jsp" %>
<script>

    //获取内部项目专业
    function getProjectMajorList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectMajor/list", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择或搜索内部项目专业</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].majorName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].majorName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectMajorId']").html(html);
            }
        });
    }

    var dataTable = null;
    var form = null;
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
                url: YZ.ip + "/projectInterior/list",
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
                    data.projectNumber = $("#projectNumber").val(); //项目编号
                    data.projectName = $("#projectName").val(); //项目名
                    data.projectMajorId = $("#projectMajorId").val(); //专业id
                    data.departmentId = $("#departmentId").val(); //分配到的部门
                    if ($("#startTime").val() != "") {
                        data.startTime = new Date($("#startTime").val()); //项目启动时间
                    }
                    if ($("#endTime").val() != "") {
                        data.endTime = new Date($("#endTime").val()); //截止时间
                    }
                    data.atHome = $("#atHome").val(); //是否对内

                    if ($("#status").val() == 100) {
                        data.projectStatus = 0;
                    }
                    else if ($("#status").val() == 101) {
                        data.projectStatus = 1;
                    }
                    else {
                        data.status = $("#status").val();
                    }

                    data.isManagerId = $("#projectManagerId").val(); //项目经理
                    data.isTerminate = $("#isTerminate").val();
                }
            },
            "columns": [
                { "data": "projectNumber" },
                { "data": "projectName" },
                //{ "data": "shortName" },
                { "data": "projectMajorName" },
                { "data": "initWorkload" },
                { "data": "projectGroupName" },
                { "data": "department.departmentName" },
                { "data": "startTime" },
                { "data": "endTime" },
                { "data": "createUser.name" },
                { "data": "atHome" },
                { "data": "status" },
                //{ "data": "acceptances.progress" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        else return data;
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        else return data;
                    },
                    "targets": 5
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "对内";
                        else return "对外";
                    },
                    "targets": 9
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "审核中";
                        else if (data == 1) return "审核通过";
                        else return "审核不通过";
                    },
                    "targets": 10
                },
                {
                    "render": function(data, type, row) {
                        //获取最新一条记录的进度
                        var maxId = 0;
                        var maxProgress = 0;
                        for (var i = 0; i < row.acceptances.length; i++) {
                            if (row.acceptances[i].status == 2) {
                                maxProgress = row.acceptances[i].progress;
                                break;
                            }
                        }
                        var seepHtml = '<div class="layui-progress layui-progress-big" lay-showpercent="true">' +
                                            '<div class="layui-progress-bar layui-bg-orange" lay-percent="70%" style="width: ' + maxProgress + '%;"><span class="layui-progress-text"> ' + maxProgress + '%</span></div>' +
                                        '</div>';
                        return seepHtml;
                    },
                    "targets": 11
                },
                {
                    "render": function(data, type, row) {
                        var str = "";
                        str += "<button onclick='deleteProject(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_172\"><i class=\"fa fa-trash-o fa-fw\"></i>&nbsp;删除项目</button>";
                        if (row.isTerminate == 1) {
                            str += "<button class=\"layui-btn layui-btn-small layui-btn-disabled\">项目已终止</button>";
                            return str;
                        }

                        //判断是否是值总
//                        if (YZ.getUserInfo().roleId == 5) {
                            if (row.status == 0) {
                                str = "<button onclick='adoptToExamine(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_71\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;审核通过</button>" +
                                        "<button onclick='rejectToExamine(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_72\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;审核不通过</button>";
                            }
//                        }
//                         if (row.status == 0) {
//                             str += "<button onclick='deleteProject(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_172\"><i class=\"fa fa-trash-o fa-fw\"></i>&nbsp;删除项目</button>";
//                         }
                        //判断状态显示修改按钮
                        if (row.status != 1) {
                            str += "<button class=\"layui-btn layui-btn-small hide checkBtn_70\" onclick=\"updateData(" + row.id + ")\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>";
                        }
                        else {
                            str += "<button class=\"layui-btn layui-btn-small hide checkBtn_174\" onclick=\"updateNameOrReport(" + row.id + ")\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>";
                        }

                        //判断是否是团队长
                        if (YZ.getUserInfo().id == row.allocationUserId && row.projectGroupId == null && row.status == 1) {
                            str += "<button onclick='distributionProject(" + row.id + ", " + row.departmentId + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_73\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;分配项目组</button>"
                        }


                        //判断是否是绩效专员
                        if (YZ.getUserInfo().id == row.createUserId && row.status == 2) {
                            str += "<button onclick='resubmit(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_74\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;重新提交</button>"
                        }
                        //判断审核成功
                        if (row.status == 1 && row.projectGroupId != null) {
                            str += "<button onclick='detailData(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-normal hide checkBtn_75\"><i class=\"fa fa-list fa-file-text-o\"></i>&nbsp;查看详情</button>";;
                        }
                        /*else {
                            str += "<button onclick='notData()' class=\"layui-btn layui-btn-small layui-btn-normal hide checkBtn_75\"><i class=\"fa fa-list fa-file-text-o\"></i>&nbsp;查看详情</button>";;
                        }*/
                        str += "<button onclick='permissionToTransfer(" + row.id + ", " + row.departmentId + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_179\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;权限转移</button>"
                        str +="<button onclick='projectTermination(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_177\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;项目终止</button>";

                        return str;
                    },
                    "targets": 12
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

        getProjectMajorList(0);
        getAllDepartment(0);
        //部门过滤器
        form.on('select(department)', function(data){
            getIsManager(Number(data.value), 0);
            form.render();
        });
        form.render();
    });

    //通过审核
    function adoptToExamine (id) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                        '<div class="layui-form-item layui-form-text">' +
                            '<label class="layui-form-label">备注</label>' +
                            '<div class="layui-input-block">' +
                                '<textarea type="text" id="remark" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                            '</div>' +
                        '</div>' +
                    '</form>';

        YZ.formPopup(html, "是否确认通过审核？", ["400px","300px"], function () {
            var arr = {
                status : 1,
                id : id,
                remark : $("#remark").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/projectInterior/updateStatus", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    location.reload();
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                    layer.msg('操作成功.', {icon: 1});
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2, anim: 6});
        });
    }

    //审核不通过
    function rejectToExamine (id) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">备注</label>' +
                '<div class="layui-input-block">' +
                '<textarea type="text" id="remark" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                '</div>' +
                '</div>' +
                '</form>';

        YZ.formPopup(html, "是否确认审核不通过？", ["400px","300px"], function () {
            var arr = {
                status : 2,
                id : id,
                remark : $("#remark").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/projectInterior/updateStatus", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    location.reload();
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                    layer.msg('操作成功.', {icon: 1});
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2, anim: 6});
        });
    }

    //分配项目组
    function distributionProject (id, departmentId) {
        layer.open({
            type: 2,
            title: '分配项目组',
            maxmin: true, //开启最大化最小化按钮
            area: ['600px', '400px'],
            content: YZ.ip + "/page/project/projectInterior/distribution?departmentId=" + departmentId + "&id=" + id
        });
    }

    //提供给子页面
    var closeNodeIframe = function () {
        location.reload();
        var index = layer.load(1, {shade: [0.5,'#eee']});
        setTimeout(function () {layer.close(index);}, 600);
    }

    //添加
    function addData () {
        var index = layer.open({
            type: 2,
            title: '添加内部项目',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectInterior/add"
        });
        layer.full(index);
    }

    //修改
    function updateData (id) {
        var index = layer.open({
            type: 2,
            title: '修改内部项目',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectInterior/edit?projectInteriorId=" + id
        });
        layer.full(index);
    }

    //修改
    function updateNameOrReport (id) {
        var index = layer.open({
            type: 2,
            title: '修改内部项目',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectInterior/edit?projectInteriorId=" + id + "&isDisabled=1"
        });
        layer.full(index);
    }

    //修改名字
    function updateName (id, projectName, shortName) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">项目名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="projectName2" autocomplete="off" placeholder="请输入项目名称" class="layui-input" maxlength="20" value="' + projectName + '">' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">项目简称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="shortName2" autocomplete="off" placeholder="请输入项目简称" class="layui-input" maxlength="30" value="' + shortName + '">' +
                '</div>' +
                '</div>' +
                '</form>';

        YZ.formPopup(html, "修改名字", ["500px","500px"], function () {
            if ($("#projectName2").val() == "") {
                layer.msg('请输入项目名称.', {icon: 2, anim: 6});
                return false;
            }
            if ($("#shortName2").val() == "") {
                layer.msg('请输入项目简称.', {icon: 2, anim: 6});
                return false;
            }
            var arr = {
                projectName : $("#projectName2").val(),
                shortName : $("#shortName2").val(),
                id : id
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/projectInterior/update", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.alert('修改成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
                        location.reload();
                        layer.close(index2);
                        var index = layer.load(1, {shade: [0.5,'#eee']});
                        setTimeout(function () {layer.close(index);}, 600);
                    });
                }
            });

        }, function () {
        });
    }

    //没有分配项目组
    function notData () {
        layer.msg('暂未分配项目组,不能查看详情.', {icon: 2, anim: 6});
        return false;
    }

    //查看项目详情
    function detailData(id) {
//        location.href = YZ.ip + "/page/project/projectInterior/detail?projectInteriorId=" + id;
//        return false;
        var index = layer.open({
            type: 2,
            title: '内部项目详情',
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/project/projectInterior/detail?projectInteriorId=" + id
        });
        layer.full(index);
    }

    //审核失败绩效专员重新提交
    function resubmit (id) {
        layer.confirm('是否确认重新提交？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/projectInterior/update", {id : id, status : 0} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    location.reload();
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                    layer.msg('重新提交成功.', {icon: 1});
                }
            });
        }, function(){
            //layer.msg('已取消.', {icon: 2, anim: 6});
        });
    }

    //批量处理
    function batchDispose () {

    }

    //删除项目
    function deleteProject (id) {
        var index1 = layer.confirm("<span style=\"color: red;font-weight: bold\">此操作不可逆，是否确认删除</span>？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/projectInterior/delProjectInterior", {projectId : id} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('删除成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
                        var index2 = layer.load(1, {shade: [0.5,'#eee']});
                        location.reload();
                        layer.close(index);
                        layer.close(index1);
                        layer.close(index2);
                    });
                }
            });
        }, function(){ });
    }

    //项目终止
    function projectTermination (id) {
        var index1 = layer.confirm("<span style=\"color: red;font-weight: bold\">此操作不可逆，是否确认项目终止</span>？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/projectInterior/update", {id : id, isTerminate : 1} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('项目终止成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
                        var index2 = layer.load(1, {shade: [0.5,'#eee']});
                        location.reload();
                        layer.close(index);
                        layer.close(index1);
                        layer.close(index2);
                    });
                }
            });
        }, function(){ });
    }

    //权限转移
    function permissionToTransfer (id, departmentId) {
        layer.open({
            type: 2,
            title: '权限转移',
            maxmin: true, //开启最大化最小化按钮
            area: ['600px', '400px'],
            content: YZ.ip + "/page/project/projectInterior/permissionToTransfer?departmentId=" + departmentId + "&id=" + id
        });
    }



    function importProject(){
        $('#File').click();
    }

    function templateDownLoad(){
        window.open(YZ.ip + "/resources/template/project_n_template.xls", "_blank");
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
                            YZ.ajaxRequestData("get", false, YZ.ip + "/import/importProjectInterior", {url : YZ.ipImg + "/" + result.data.url}, null , function(result){
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

    //内部项目报表导出
    function projectDiaryExcel () {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">密码</label>' +
                '<div class="layui-input-block">' +
                '<input type="password" id="password" autocomplete="off" placeholder="请输入加密密码" class="layui-input" maxlength="16">' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">导出年份</label>' +
                '<div class="layui-input-block">' +
                '<input type="number" id="year" autocomplete="off" placeholder="默认当年" class="layui-input" maxlength="5">' +
                '</div>' +
                '</div>' +
                '</form>';

        var index = layer.confirm(html, {
            btn: ['提交','取消'],
            title: "Excel加密密码",
            area: ["500px","500px"], //宽高
        }, function () {
            if ($("#password").val() == "") {
                layer.msg('密码不能为空.', {icon: 2, anim: 6});
                $("#password").focus();
                return false;
            }

            var params = "";
            if(null != $("#departmentId").val() && $("#departmentId").val() != 0 && $("#departmentId").val() != undefined ){
                params += "&departmentId=" + $("#departmentId").val();
            }else{
                params += "&departmentId=" + YZ.getUserInfo().departmentId;
            }
            if(null != $("#year").val() && '' != $("#year").val()){
                if(!YZ.isNumber_.test($("#year").val())){
                    layer.msg('年份输入错误.', {icon: 2, anim: 6});
                    $("#year").focus();
                    return false;
                }
                params += "&year="+$("#year").val()
            }
            window.location.href = YZ.ip + "/excel/excelHtml"
                    + "?password=" + $("#password").val()
                    + params
            ;
            layer.close(index);
        }, function () {
        });
    }

</script>
</body>
</html>
