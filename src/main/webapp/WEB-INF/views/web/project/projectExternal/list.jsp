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
                            <label class="layui-form-label">项目名称</label>
                            <div class="layui-input-block">
                                <input type="text" name="projectName" id="projectName" lay-verify="" placeholder="请输入项目名称" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">项目类型</label>
                            <div class="layui-input-block">
                                <select name="projectTypeId" id="projectTypeId" lay-verify="" lay-search="">
                                    <option value="">请选择或搜索项目类型</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">项目组</label>
                            <div class="layui-input-block">
                                <select id="projectGroupId" name="projectGroupId" lay-verify="required" lay-search="">
                                    <option value="">请选择或搜索项目组</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">项目状态</label>
                            <div class="layui-input-block">
                                <select id="status" lay-verify="">
                                    <option value="">请选择</option>
                                   <%-- /**破题状态 未破
                                    public static final Integer PO_NONE = 5000;
                                    /!**破题状态 半破审核中*!/
                                    public static final Integer PO_HALF_ING = 5001;
                                    /!**破题状态 半破*!/
                                    public static final Integer PO_HALF = 5002;
                                    /!**破题状态 全破 审核中*!/
                                    public static final Integer PO_ALL_ING = 5003;
                                    /!**破题状态 全破*!/
                                    public static final Integer PO_ALL = 5004;
                                    /!**申请 内部项目结项 审核中*!/
                                    public static final Integer INTERIOR_OVER_ING = 5005;
                                    /!**内部项目结项 完成*!/
                                    public static final Integer INTERIOR_OVER = 5006;
                                    /!**申请外部结项 审核中*!/
                                    public static final Integer EXTERIOR_OVER_ING  = 5007;
                                    /!**外部结项 完成*!/
                                    public static final Integer EXTERIOR_OVER  = 5008;*/--%>
                                    <optgroup label="破题状态">
                                        <option value="5000">未破</option>
                                        <option value="5002">半破</option>
                                        <option value="5004">破</option>
                                    </optgroup>
                                    <optgroup label="项目交接状态">
                                        <option value="5005">内部结项中</option>
                                        <option value="5006">内部结项完成</option>
                                        <option value="5007">外部结项中</option>
                                        <option value="5008">外部结项完成</option>
                                    </optgroup>

                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">所在部门</label>
                            <div class="layui-input-block">
                                <select id="departmentId" name="departmentId" lay-verify="required" lay-search="" lay-filter="department">
                                    <option value="">请选择或搜索公司和部门</option>
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
        <legend>外部项目列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_83"><i class="layui-icon">&#xe608;</i> 添加外部项目</button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_84" onclick="batchDispose()">批量处理</button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_182" onclick="projectDiaryExcel()">外部项目报表导出<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_182" onclick="projectExcel()">外部项目导出<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_202" onclick="importProject()">导入外部项目<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_202" onclick="templateDownLoad()">模版下载<i class="fa fa-file-text-o"></i></button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>项目编号</th>
                        <th>项目名称</th>
                        <th>项目类型</th>
                        <th>项目组</th>
                        <th>所在部门</th>
                        <th>客户单位名称</th>
                        <th>客户专业部门名称</th>
                        <th>承接时间</th>
                        <th>项目启动书提交时间</th>
                        <th>交接状态</th>
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
    function getProjectTypeList () {
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectType/listSelect", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择或搜索项目类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].projectTypeName + "</option>";
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectTypeId']").html(html);
            }
        });
    }
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
                url: YZ.ip + "/project/list",
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
                    data.projectTypeId = $("#projectTypeId").val(); //项目类型
                    data.projectGroupId = $("#projectGroupId").val(); //项目组
                    data.departmentId = $("#departmentId").val(); //部门
                    data.status = $("#status").val(); //状态
                    data.isManagerId = $("#projectManagerId").val(); //项目经理
                    data.isTerminate = $("#isTerminate").val();
                }
            },
            "columns": [
                { "data": "projectNumber" },
                { "data": "projectName" },
                { "data": "projectTypeName" },
                { "data": "projectGroupName" },
                { "data": "departmentName" },
                { "data": "customerUnit" },
                { "data": "customerDepartment" },
                { "data": "receiveTime" },
                { "data": "submitTime" },
                { "data": "status" },
                { "data": "connectStatus" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        else return data;
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        else return data;
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 8
                },
                {
                    "render": function(data, type, row) {
                        /**破题状态 未破
                        public static final Integer PO_NONE = 5000;
                        /!**破题状态 半破审核中*!/
                        public static final Integer PO_HALF_ING = 5001;
                        /!**破题状态 半破*!/
                        public static final Integer PO_HALF = 5002;
                        /!**破题状态 全破 审核中*!/
                        public static final Integer PO_ALL_ING = 5003;
                        /!**破题状态 全破*!/
                        public static final Integer PO_ALL = 5004;
                        /!**申请 内部项目结项 审核中*!/
                        public static final Integer INTERIOR_OVER_ING = 5005;
                        /!**内部项目结项 完成*!/
                        public static final Integer INTERIOR_OVER = 5006;
                        /!**申请外部结项 审核中*!/
                        public static final Integer EXTERIOR_OVER_ING  = 5007;
                        /!**外部结项 完成*!/
                        public static final Integer EXTERIOR_OVER  = 5008;*/
                        if (data == 5000) return "<span class='badgeStatus' style='background: #97cadf;'>未破</span>";
                        if (data == 5001) return "<span class='badgeStatus' style='background: #83c4bc;'>破题审核中</span>";
                        if (data == 5002) return "<span class='badgeStatus' style='background: #ffbd5d;'>半破</span>";
                        if (data == 5003) return "<span class='badgeStatus' style='background: #83c4bc;'>破题审核中</span>";
                        if (data == 5004) return "<span class='badgeStatus' style='background: #eec58f;'>破</span>";
                        if (data == 5005) return "<span class='badgeStatus' style='background: #ea958e;'>内部结项中</span>";
                        if (data == 5006) return "<span class='badgeStatus' style='background: #d4bb9c;'>内部已结项</span>";
                        if (data == 5007) return "<span class='badgeStatus' style='background: #ffa37a;'>外部结项中</span>";
                        if (data == 5008) return "<span class='badgeStatus' style='background: #d4bb9c;'>外部已结项</span>";
                    },
                    "targets": 9
                },
                {
                    "render": function(data, type, row) {
                        if (data == -1 || data == null) return "待启动";
                        if (data == 0) return "待分配";
                        if (data == 1) return "待审核";
                        if (data == 2) return "审核未通过";
                        if (data == 3) return "审核通过";
                    },
                    "targets": 10
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
                    "targets": 11
                },
                {
                    "render": function(data, type, row) {
                        if (row.isTerminate == 1) {
                            return "<button class=\"layui-btn layui-btn-small layui-btn-disabled\">项目已终止</button>";
                        }
                        var str =  "<button onclick='deleteProject(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_173\"><i class=\"fa fa-trash-o fa-fw\"></i>&nbsp;删除项目</button>";

                        if ((row.connectStatus == -1 && YZ.getUserInfo().roleId == 9) || row.connectStatus == -1) {
                            var btnStr = "";
                            if(null == row.projectTypeId){
                                str += "<button onclick='setProjectType(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_203\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;设置项目类型</button>";
                            }else{
                                str += "<button onclick='startProject(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_165\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;启动项目</button>";
                            }

                            return  str ;
                        }
                        //判断是否是项目管理处
//                        if (YZ.getUserInfo().roleId == 6) {
                            if (row.connectStatus == 0) {
                                str += "<button onclick='projectDistribution(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_85\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;项目分配</button>";
                            }
                            else if (row.connectStatus == 2) {
                                str += "<button onclick='projectDistribution(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_86\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;重新项目分配</button>";
                            }
//                        }
                        //判断是否是值总
//                        if (YZ.getUserInfo().roleId == 5) {
                            if (row.connectStatus == 1) {
                                str += "<button onclick='adoptToExamine(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_87\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;审核通过</button>" +
                                        "<button onclick='rejectToExamine(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_88\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;审核不通过</button>";
                            }
//                        }
                        //判断状态显示修改按钮
                        if (row.connectStatus != -1) {
                            str += "<button class=\"layui-btn layui-btn-small hide checkBtn_89\" onclick=\"updateData(" + row.id + ")\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>";
                        }
                        else {
                            str += "<button class=\"layui-btn layui-btn-small hide checkBtn_175\" onclick=\"updateName(" + row.id + ", '" + row.projectName + "', '" + row.projectNameShort + "')\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改名字</button>";
                        }

                        //判断是否是团队长
                        if (YZ.getUserInfo().id == row.aTeacher && row.projectGroupId == null && row.connectStatus == 3) {
                            str += "<button onclick='distributionGroup(" + row.id + ", " + row.departmentId + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_90\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;分配项目组</button>"
                        }
                        //判断审核成功
                        if (row.connectStatus == 3 && row.projectGroupId != null) {
                            str += "<button onclick='detailData(" + row.id + ")' class=\"layui-btn layui-btn-small layui-btn-normal hide checkBtn_91\"><i class=\"fa fa-list fa-file-text-o\"></i>&nbsp;查看详情</button>";;
                        }
                        /*else {
                            str += "<button onclick='notData()' class=\"layui-btn layui-btn-small layui-btn-normal hide checkBtn_91\"><i class=\"fa fa-list fa-file-text-o\"></i>&nbsp;查看详情</button>";;
                        }*/
                        if(null != row.departmentId){
                            str += "<button onclick='permissionToTransfer(" + row.id + ", " + row.departmentId + ")' class=\"layui-btn layui-btn-small layui-btn-warm hide checkBtn_180\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;权限转移</button>"
                        }
                        str +="<button onclick='projectTermination(" + row.id + ")' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_178\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;项目终止</button>";
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

        getProjectTypeList();
        getAllDepartment(0);
        getDistributionProjectGroup();
        //部门过滤器
        form.on('select(department)', function(data){
            getIsManager(Number(data.value), 0);
            form.render();
        });
        form.render();
    });

    //根据部门ID获取有效的项目组
    function getDistributionProjectGroup() {
        var arr = {
            isValid : 1
        }
        console.log(arr);
        var htmlSelect = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectGroup/list", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                htmlSelect = "<option value=\"\">请选择或搜索项目组</option>";
                for (var i = 0; i < result.data.length; i++) {
                    htmlSelect += "<option value=\"" + result.data[i].id + "\">" + result.data[i].projectName + "</option>";
                }
                if (result.data.length == 0) {
                    htmlSelect += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectGroupId']").html(htmlSelect);
            }
        });
    }

    //通过审核
    function adoptToExamine (id) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                        '<div class="layui-form-item layui-form-text">' +
                            '<label class="layui-form-label">备注</label>' +
                            '<div class="layui-input-block">' +
                                '<textarea type="text" id="dutyRemarks" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                            '</div>' +
                        '</div>' +
                    '</form>';

        YZ.formPopup(html, "是否确认通过审核？", ["400px","300px"], function () {
            var arr = {
                connectStatus : 3,
                id : id,
                dutyRemarks : $("#dutyRemarks").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/project/updateProjectGeneralManagerOnDuty", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    location.reload();
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                    layer.msg('操作成功.', {icon: 1});
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2});
        });
    }

    //审核不通过
    function rejectToExamine (id) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">备注</label>' +
                '<div class="layui-input-block">' +
                '<textarea type="text" id="dutyRemarks" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                '</div>' +
                '</div>' +
                '</form>';

        YZ.formPopup(html, "是否确认审核不通过？", ["400px","300px"], function () {
            var arr = {
                connectStatus : 2,
                id : id,
                dutyRemarks : $("#dutyRemarks").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/project/updateProjectGeneralManagerOnDuty", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    location.reload();
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                    layer.msg('操作成功.', {icon: 1});
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2});
        });
    }

    //没有分配项目组
    function notData () {
        layer.msg('暂未分配项目组,不能查看详情.', {icon: 2, anim: 6});
        return false;
    }

    //项目分配
    function projectDistribution (id) {
        var index = layer.open({
            type: 2,
            title: '项目分配',
            maxmin: true, //开启最大化最小化按钮
            area: ['600px', '400px'],
            content: YZ.ip + "/page/project/projectExternal/projectDistribution?id=" + id
        });
        layer.full(index);
    }

    //分配项目组
    function distributionGroup (id, departmentId) {
        layer.open({
            type: 2,
            title: '分配项目组',
            maxmin: true, //开启最大化最小化按钮
            area: ['600px', '400px'],
            content: YZ.ip + "/page/project/projectExternal/distribution?departmentId=" + departmentId + "&id=" + id
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
            title: '添加外部项目',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectExternal/add"
        });
        layer.full(index);
    }

    //修改
    function updateData (id) {
        var index = layer.open({
            type: 2,
            title: '修改外部项目',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/project/projectExternal/edit?projectExternalId=" + id
        });
        layer.full(index);
    }

    //修改名字
    function updateName (id, projectName, projectNameShort) {
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
                '<input type="text" id="projectNameShort2" autocomplete="off" placeholder="请输入项目简称" class="layui-input" maxlength="30" value="' + projectNameShort + '">' +
                '</div>' +
                '</div>' +
                '</form>';

        YZ.formPopup(html, "修改名字", ["500px","500px"], function () {
            if ($("#projectName2").val() == "") {
                layer.msg('请输入项目名称.', {icon: 2, anim: 6});
                return false;
            }
            if ($("#projectNameShort2").val() == "") {
                layer.msg('请输入项目简称.', {icon: 2, anim: 6});
                return false;
            }
            var arr = {
                projectName : $("#projectName2").val(),
                projectNameShort : $("#projectNameShort2").val(),
                id : id
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProject", arr , null , function(result) {
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



    function importProject(){
        $('#File').click();
    }

    function templateDownLoad(){
        window.open(YZ.ip + "/resources/template/project_w_template.xls", "_blank");
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
                            YZ.ajaxRequestData("get", false, YZ.ip + "/import/importProject", {url : YZ.ipImg + "/" + result.data.url}, null , function(result){
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


    //查看项目详情
    function detailData(id) {
        // location.href = YZ.ip + "/page/project/projectExternal/detail?projectExternalId=" + id;
        // return false;
        var index = layer.open({
            type: 2,
            title: '外部项目详情',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/project/projectExternal/detail?projectExternalId=" + id
        });
        layer.full(index);
    }

    //批量处理
    function batchDispose () {
        var index = layer.open({
            type: 2,
            title: '批量处理项目',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['800px', '550px'],
            scrollbar: false, //屏蔽浏览器滚动条
            content: YZ.ip + "/page/project/projectExternal/listC"
        });
    }

    //启动项目
    function startProject (id) {
        layer.confirm("您确定要启动项目？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProject", {id : id, connectStatus : 0,isStart : 1} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('启动成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
                        var index2 = layer.load(1, {shade: [0.5,'#eee']});
                        location.reload();
                        layer.close(index2);
                        layer.close(index);
                    });
                }
            });
        }, function(){ });
    }

    var projectTypeList = null;
    // 设置项目类型
    function setProjectType(projectId){

        if(null == projectTypeList){
            YZ.ajaxRequestData("post", false, YZ.ip + "/projectType/listSelect", null , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    projectTypeList = result.data;
                }
            });
        }
        var selectHtml = "";
        for (var  i = 0; i < projectTypeList.length; i++ ){
            selectHtml += "<option value='"+projectTypeList[i].id+"'>"+projectTypeList[i].projectTypeName+"</option>";
        }

        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">项目类型</label>' +
                '<div class="layui-input-block">' +
                '<select name="projectType" id="projectType" lay-verify="required">' +
                    '<option value="">选择项目类型</option>' +
                 selectHtml +
                '</select>' +
                '</div>' +
                '</div>' +
                '</form>';


        YZ.formPopup(html, "设置项目类型", ["500px","500px"], function () {
            if ($("#projectType").val() == "") {
                layer.msg('请选择项目类型.', {icon: 2, anim: 6});
                return false;
            }

            var arr = {
                projectTypeId : $("#projectType").val(),
                id : projectId
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProject", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.alert('设置成功.', {
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
        form.render();

    }

    //删除项目
    function deleteProject (id) {
        var index1 = layer.confirm("<span style=\"color: red;font-weight: bold\">此操作不可逆，是否确认删除</span>？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/delProject", {projectId : id} , null , function(result) {
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
            YZ.ajaxRequestData("post", false, YZ.ip + "/project/updateProject", {id : id, isTerminate : 1} , null , function(result) {
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
            content: YZ.ip + "/page/project/projectExternal/permissionToTransfer?departmentId=" + departmentId + "&id=" + id
        });
    }

    //外部项目报表导出
    function projectDiaryExcel () {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">密码</label>' +
                '<div class="layui-input-block">' +
                '<input type="password" id="password" autocomplete="off" placeholder="请输入加密密码" class="layui-input" maxlength="16">' +
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
            if(null != $("#projectGroupId").val() && $("#projectGroupId").val() != 0 && $("#projectGroupId").val() != undefined ){
                params += "&projectGroupId=" + $("#projectGroupId").val();
            }
            if(null != $("#projectTypeId").val() && $("#projectTypeId").val() != 0 && $("#projectTypeId").val() != undefined ){
                params += "&projectTypeId=" + $("#projectTypeId").val();
            }
            if(null != $("#departmentId").val() && $("#departmentId").val() != 0 && $("#departmentId").val() != undefined ){
                params += "&departmentId=" + $("#departmentId").val();
            }
            window.location.href = YZ.ip + "/excel/projectDiaryExcel"
                    + "?password=" + $("#password").val()
                    + params
                    ;
            layer.close(index);
        }, function () {
        });
    }

    function  projectExcel(){
        var params = "";
        if(null != $("#projectGroupId").val() && $("#projectGroupId").val() != 0 && $("#projectGroupId").val() != undefined ){
            params += "&projectGroupId=" + $("#projectGroupId").val();
        }
        if(null != $("#projectTypeId").val() && $("#projectTypeId").val() != 0 && $("#projectTypeId").val() != undefined ){
            params += "&projectTypeId=" + $("#projectTypeId").val();
        }
        if(null != $("#departmentId").val() && $("#departmentId").val() != 0 && $("#departmentId").val() != undefined ){
            params += "&departmentId=" + $("#departmentId").val();
        }
        window.location.href = YZ.ip + "/excel/exportProject"
                + "?password=0" + params

        ;
    }

</script>
</body>
</html>
