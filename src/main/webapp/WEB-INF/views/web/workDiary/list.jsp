<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>传递卡列表</title>
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
                            <label class="layui-form-label">审核人名字</label>
                            <div class="layui-input-block">
                                <input type="text" name="verifierName" id="verifierName" lay-verify="" placeholder="请输入审核人名字" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">创建人名字</label>
                            <div class="layui-input-block">
                                <input type="text" name="userName" id="userName" lay-verify="" placeholder="请输入创建人名字" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">工作日期</label>
                            <div class="layui-input-block">
                                <input type="text" name="workTime" id="workTime" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this, max: laydate.now()})" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">创建时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="createTime" id="createTime" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this, max: laydate.now()})" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">传递卡状态</label>
                            <div class="layui-input-block">
                                <select id="status" name="status" lay-verify="">
                                    <option value="">选择传递卡状态</option>
                                    <option value="0">全部</option>
                                    <option value="4000">草稿-临时保存</option>
                                    <option value="4001">待审核</option>
                                    <option value="4002">部门经理审核不通过</option>
                                    <option value="4003">部门经理审核通过</option>
                                    <option value="4004">综合部经理审核通过</option>
                                    <option value="4005">综合部经理审核不通过</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择公司</label>
                            <div class="layui-input-block">
                                <select id="companyId" name="companyId" lay-verify="" lay-search="" lay-filter="companyId">
                                    <option value="">选择或搜索公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择部门</label>
                            <div class="layui-input-block">
                                <select id="departmentId" name="departmentId" lay-verify="" lay-search="" lay-filter="department">
                                    <option value="">选择或搜索部门</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline" pane="">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-block">
                                <input type="checkbox" value="0" id="userId" lay-skin="primary" title="查看我的">
                            </div>
                        </div>
                        <div class="layui-inline layui-hide" pane="">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-block">
                                <input type="checkbox" value="1" id="type" lay-skin="primary" title="查看我的团队">
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
        <legend>传递卡列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal"><i class="layui-icon">&#xe608;</i> 添加传递卡</button>
                <button lay-submit="" lay-filter="submitWork" class="layui-btn layui-btn-small layui-btn-default hide checkBtn_60" onclick="passSelected()">通过已选传递卡</button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_183" onclick="exportWork()">工作学习报表导出<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_184" onclick="exportPassCard()">传递卡报表导出<i class="fa fa-file-text-o"></i></button>
                <%--<button class="layui-btn layui-btn-small layui-btn-normal" onclick="passAll()">通过所有传递卡</button>--%>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th width="110px;"><input type="checkbox" name="" lay-skin="primary" lay-filter="allChoose" title="勾选本页"></th>
                        <th>工作日期</th>
                        <th>传递卡状态</th>
                        <th>所在部门</th>
                        <th>审核人名字</th>
                        <th>创建名字</th>
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
                if (YZ.getUserInfo().isManager == 1) {
                    $("#type").parent().parent().show();
                }
                checkJurisdiction(); //调用权限
                form.render();
            },
            "ajax":  {
                url: YZ.ip + "/workDiary/listForWeb",
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
                    console.log($("#userId:checked").val());
                    console.log($("#type:checked").val());
                    if ($("#userId:checked").val() == 0) {
                        data.type = 1;
                    }
                    else if ($("#type:checked").val() == 1) {
                        data.type = 2;
                    }
                    data.verifierName = $("#verifierName").val(); //审核人名字
                    if ($("#departmentId option:selected").val() != null && $("#departmentId option:selected").val() != "") {
                        data.type = 3;
                        data.departmentId = $("#departmentId option:selected").val(); //部门ID
                    }
                    data.userName = $("#userName").val(); //创建人名字
                    if ($("#workTime").val() != "") {
                        data.workTime = new Date($("#workTime").val()); //工作日期
                    }
                    if ($("#createTime").val() != "") {
                        data.createTime = new Date($("#createTime").val()); //创建时间
                    }
                    data.status = $("#status").val() == 0 ? "" : $("#status").val(); //传递卡状态
                    data.companyId = $("#companyId").val(); //传递卡状态
                }
            },
            "columns": [
                { "data": "" },
                { "data": "workTime" },
                { "data": "status" },
                { "data": "departmentName" },
                { "data": "verifierName" },
                { "data": "userName" },
                { "data": "createTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        //判断团队长的情况
                        if (YZ.getUserInfo().isManager == 1 && YZ.getUserInfo().departmentId == row.user.departmentId){
                            if (row.status == 4001) {
                                return "<input type=\"checkbox\" name=\"\" departmentId=\"" + row.user.departmentId + "\" companyId=\"" + row.user.companyId + "\" value=\"" + row.id + "\" status=\"" + row.status + "\" lay-skin=\"primary\" title=\"勾选\">";
                            }
                        }
                        //判断综合部经理的情况
                        if (YZ.getUserInfo().roleId == 10 && YZ.getUserInfo().companyId == row.user.companyId){
                            if (row.status == 4003) {
                                return "<input type=\"checkbox\" name=\"\" value=\"" + row.id + "\" companyId=\"" + row.user.companyId + "\" status=\"" + row.status + "\" lay-skin=\"primary\" title=\"勾选\">";
                            }
                        }
                        return "<input disabled=\"disabled\" type=\"checkbox\" name=\"\" value=\"" + row.id + "\" status=\"" + row.status + "\" lay-skin=\"primary\" title=\"勾选\">";
                    },
                    "targets": 0
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        if (data == 4000) return "草稿-临时保存";
                        if (data == 4001) return "部门经理待审核";
                        if (data == 4002) return "部门经理审核不通过";
                        if (data == 4003) return "综合部经理待审核"; //部门经理审核通过
                        if (data == 4004) return "综合部经理审核通过";
                        if (data == 4005) return "综合部经理审核不通过";
                    },
                    "targets": 2
                },
                {
                    "render": function(data, type, row) {
                        return data == "" || data == null ? "--" : data;
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        return data == "" || data == null ? "--" : data;
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        var workDiary = JSON.stringify(row); //当前对象
                        var object = JSON.stringify(row.details); //进度列表
                        var subLength = row.workDiarySubs.length; //获取是否有子类传递卡
                        var str = "<button onclick='findDay(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-normal'><i class='fa fa-list fa-file-text-o'></i>&nbsp;查看当天列表</button>" +
                                    "<button onclick='findSpeed(" + object + ")' class='layui-btn layui-btn-small layui-btn-primary'><i class='layui-icon'>&#xe62c;</i>&nbsp;查看进度</button>";

                        //发布者看见的
                        if (row.userId == YZ.getUserInfo().id) {
                            if ((row.status == 4000 || row.status == 4002 || row.status == 4005)) {
                                if (subLength == 0) {
                                    str += "<button onclick='notData()' class=\"layui-btn layui-btn-small layui-btn-warm\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;提交审核</button>";
                                }
                                else {
                                    if (row.status == 4005) { // 判断综合部打回
                                        str += "<button onclick='submitWorkDiaryStatus(" + row.id + ", 4003)' class=\"layui-btn layui-btn-small layui-btn-warm\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;提交审核</button>";
                                    }
                                    else {
                                        str += "<button onclick='submitWorkDiaryStatus("+row.id+",4001)' class=\"layui-btn layui-btn-small layui-btn-warm\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;提交审核</button>";
                                    }
                                }
                            }
                            //判断综合部经理的情况
                            if (YZ.getUserInfo().roleId == 10 && row.status == 4003){
                                str += "<button onclick='updateWorkDiaryStatus2("+row.id+",4004)' class=\"layui-btn layui-btn-small hide checkBtn_61\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;通过审核</button>" +
                                        "<button onclick='updateWorkDiaryStatus2("+row.id+",4005)' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_62\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;打回</button>";
                            }
                        }
                        else {
                            //判断团队长的情况
                            if (YZ.getUserInfo().isManager == 1 && (row.status == 4001 || row.status == 4005) && YZ.getUserInfo().departmentId == row.user.departmentId && YZ.getUserInfo().roleId != 10){
                                if (row.status == 4005) {
                                    str += "<button onclick='submitWorkDiaryStatus(" + row.id + ", 4003)' class=\"layui-btn layui-btn-small layui-btn-warm\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;提交审核</button>";
                                }
                                else {
                                    str += "<button onclick='updateWorkDiaryStatus("+row.id+",4003)' class=\"layui-btn layui-btn-small hide checkBtn_63\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;通过审核</button>" +
                                            "<button onclick='updateWorkDiaryStatus("+row.id+",4002)' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_64\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;打回</button>";
                                }
                            }

                            //判断综合部经理的情况
                            if (YZ.getUserInfo().roleId == 10 && row.status == 4003 && YZ.getUserInfo().companyId == row.user.companyId){
                                str += "<button onclick='updateWorkDiaryStatus2("+row.id+",4004)' class=\"layui-btn layui-btn-small hide checkBtn_61\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;通过审核</button>" +
                                        "<button onclick='updateWorkDiaryStatus2("+row.id+",4005)' class=\"layui-btn layui-btn-danger layui-btn-small hide checkBtn_62\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;打回</button>";
                            }
                        }

                        /*if (row.status == 4003) {
                            str += "<button class=\"layui-btn layui-btn-small layui-btn-disabled\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;综合部待审核</button>";
                        }
                        if (row.status == 4004) {
                            str += "<button class=\"layui-btn layui-btn-small layui-btn-disabled\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;综合部已通过</button>";
                        }*/

                        return str;
                    },
                    "targets": 7
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

        queryAllCompany(0,"companyId",null);
        form.render(); //重新渲染

        form.on('select(companyId)', function(data){
            queryDepartmentByCompany(0, "departmentId", null, Number(data.value), null);
            form.render('select');
        });

        form.render();
        //全选
        form.on('checkbox(allChoose)', function(data){
            var child = $(data.elem).parents('table').find('tbody input[type="checkbox"]');
            child.each(function(index, item){
                if ($(this).attr("status") == 4001 && YZ.getUserInfo().departmentId == $(this).attr("departmentId")) {
                    item.checked = data.elem.checked;
                }
                else if ($(this).attr("status") == 4003 && YZ.getUserInfo().roleId == 10 && YZ.getUserInfo().companyId == $(this).attr("companyId")) {
                    item.checked = data.elem.checked;
                }
                else {
                    $(this).attr("disabled", "disabled");
                }
            });
            form.render('checkbox');
        });
    });

    //通过已选传递卡
    var passSelected = function () {
        form.on('submit(submitWork)', function(data){
            var child = $("#dataTable").find('tbody input[type="checkbox"]');
            var wordDiaryIds = "";
            child.each(function(){
                if ($(this).is(':checked')) {
                    wordDiaryIds += $(this).val() + ",";
                }
            });
            if (wordDiaryIds == "") {
                layer.msg('至少勾选一个传递卡.', {icon: 2, anim: 6});
                return false;
            }
            else {
                wordDiaryIds = wordDiaryIds.substring(0, wordDiaryIds.length - 1);
                /*var type = 0;
                if (YZ.getUserInfo().roleId == 10) { //判断是综合部经理
                    type = 1
                }*/
                var arr = {
                    ids : wordDiaryIds,
                    type : 1
                }
                YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateListStatus", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        dataTable.ajax.reload();
                        layer.msg('操作成功.', {icon: 1});
                        var index = layer.load(1, {shade: [0.5,'#eee']});
                        setTimeout(function () {layer.close(index);}, 600);
                    }
                });
            }
        });
        //layer.msg('等我开发.', {icon: 1});
    }

    //综合部经理通过全部传递卡
    var passAll = function () {
        layer.confirm('是否确认通过所有？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            if (YZ.getUserInfo().roleId != 10) {
                layer.msg('抱歉，您没有权限做此操作.', {icon: 2, anim: 6});
                return false;
            }
            var arr = {
                type : 3
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateListStatus", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function(){});
    }


    //如果点击提交审核按钮没有传递卡子类日志的话提示
    var notData = function () {
        layer.msg('没有添加任何传递卡日志不能提交审核', {icon: 2, anim: 6});
        return false;
    }

    //普通员工或者团队长经理提交
    var submitWorkDiaryStatus = function (id, status) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                        '<div class="layui-form-item layui-form-text">' +
                            '<label class="layui-form-label">备注</label>' +
                            '<div class="layui-input-block">' +
                                '<textarea type="text" id="notes" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                            '</div>' +
                        '</div>' +
                    '</form>';
        YZ.formPopup(html, "是否确认提交审核？", ["500px", "300px"], function () {
            var arr = {
                status : status,
                id : id,
                notes : $("#notes").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateWorkDiaryStatus", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2, anim: 6});
        });
    }

    //团队长经理通过审核或者打回
    var updateWorkDiaryStatus = function(id, status) {

        var mag = "";
        if (status == 4001) {
            mag = "是否确认提交审核？";
        }
        else if (status == 4003) {
            mag = "是否确认通过审核？";
        }
        else if (status == 4002) {
            mag = "是否确认打回？";
        }

        var html = '<form class="layui-form layui-form-pane" action="">' +
                        '<div class="layui-form-item layui-form-text">' +
                            '<label class="layui-form-label">备注</label>' +
                            '<div class="layui-input-block">' +
                                '<textarea type="text" id="notes" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                            '</div>' +
                        '</div>' +
                    '</form>';

        YZ.formPopup(html, mag, ["500px", "300px"], function () {
            var arr = {
                status : status,
                id : id,
                notes : $("#notes").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateWorkDiaryStatus", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2, anim: 6});
        });

    }

    //综合部经理通过审核或者打回
    var updateWorkDiaryStatus2 = function(id, status) {

        var mag = "";
        if (status == 4004) {
            selectUser(id, status);
            return false;
        }
        else if (status == 4005) {
            mag = "是否确认打回？";
        }

        var html = '<form class="layui-form layui-form-pane" action="">' +
                        '<div class="layui-form-item layui-form-text">' +
                            '<label class="layui-form-label">备注</label>' +
                            '<div class="layui-input-block">' +
                                '<textarea type="text" id="notes" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                            '</div>' +
                        '</div>' +
                    '</form>';

        YZ.formPopup(html, mag, ["500px", "300px"], function () {
            var arr = {
                status : status,
                id : id,
                notes : $("#notes").val()
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateWorkDiaryStatus", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {
            //layer.msg('已取消.', {icon: 2, anim: 6});
        });

    }


    //查看当天列表
    var findDay = function (id) {
//        location.href = YZ.ip + "/page/workDiarySub/list?workDiaryId=" + id;
        layer.full(layer.open({
            type: 2,
            title: '查看当天列表',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/workDiarySub/list?workDiaryId=" + id
        }));
    }

    /***
     * 进度集合
     * @param details
     */
    var findSpeed = function (details) {
        console.log(details);
        if (details == null || details.length == 0) {
            layer.msg('没有任何进度', {icon: 2, anim: 6});
            return false;
        }
        localStorage.setItem("details", JSON.stringify(details));
        layer.open({
            type: 2,
            title: '传递卡进度',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/workDiary/speed"
        });
    }

    //选择抄送人
    var selectUser = function (id, status) {
        layer.open({
            type: 2,
            title: '选择抄送人',
            shadeClose: true,
            maxmin: false, //开启最大化最小化按钮
            area: ['600px', '600px'],
            scrollbar: false, //屏蔽浏览器滚动条
            content: YZ.ip + "/page/workDiary/selectUser?workDiaryId=" + id + "&workDiaryIdStatus=" + status
        });
    }

    //提供给子页面
    var closeNodeIframe = function () {
        dataTable.ajax.reload();
        layer.msg('操作成功.', {icon: 1});
        var index = layer.load(1, {shade: [0.5,'#eee']});
        setTimeout(function () {layer.close(index);}, 600);
    }

    //添加
    function addData () {
        var index = layer.open({
            type: 2,
            title: '添加传递卡',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/workDiary/add"
        });
        layer.full(index);
    }

    //工作学习报表 导出
    function exportWork () {

        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">选择时间</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" name="workTimeOfMonth" id="workTimeOfMonth" lay-verify="required" placeholder="yyyy-mm" autocomplete="off" class="layui-input" onfocus="WdatePicker({dateFmt:\'yyyy-MM\'})" readonly>'+
                '</div>' +
                '</div>' +
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
            if ($("#workTimeOfMonth").val() == "") {
                layer.msg('请选择时间.', {icon: 2, anim: 6});
                return false;
            }
            if ($("#password").val() == "") {
                layer.msg('密码不能为空.', {icon: 2, anim: 6});
                $("#password").focus();
                return false;
            }
            window.location.href = YZ.ip + "/excel/workDiary?time="
                    + new Date($("#workTimeOfMonth").val()).getTime()
                    + "&password=" + $("#password").val()
                    + "&departmentId=" + $("#departmentId").val()
                    + "&companyId=" + $("#companyId").val()
            ;
            layer.close(index);
        }, function () {
        });
    }



    //传递卡报表导出
    function exportPassCard () {
//        if ($("#workTime").val() == "") {
//            layer.msg('请选择工作时间.', {icon: 2, anim: 6});
//            return false;
//        }

        var html = '<form class="layui-form layui-form-pane" action="">' +

                '<div class="layui-form-item">' +
                '<label class="layui-form-label">开始时间</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" name="startWorkTime" id="startWorkTime" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this, max: laydate.now()})" readonly>'+
                '</div>' +
                '</div>' +
                '<div class="layui-form-item">'+
                '<label class="layui-form-label">结束时间</label>'+
                '<div class="layui-input-block">'+
                '<input type="text" name="endWorkTime" id="endWorkTime" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this, max: laydate.now()})" readonly>'+
                '</div>'+
                '</div>'+
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
            var params = "";
            if($("#startWorkTime").val() != ''){
                params += "&startStamp=" + new Date($("#startWorkTime").val()).getTime();
            }
            if($("#endWorkTime").val() != ''){
                params += "&endStamp=" + new Date($("#endWorkTime").val()).getTime();
            }
            if ($("#password").val() == "") {
                layer.msg('密码不能为空.', {icon: 2, anim: 6});
                $("#password").focus();
                return false;
            }
            window.location.href = YZ.ip + "/excel/excelWorkDiary?password=" + $("#password").val()
                    + "&departmentId=" + $("#departmentId").val()
                    + "&companyId=" + $("#companyId").val()
                    + params
            ;
            layer.close(index);
        }, function () {
        });
    }

</script>
</body>
</html>
