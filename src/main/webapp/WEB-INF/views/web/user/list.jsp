<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>用户列表</title>

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
                            <label class="layui-form-label">账号</label>
                            <div class="layui-input-block">
                                <input type="text" name="account" id="account" lay-verify="" placeholder="请输入账号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">姓名</label>
                            <div class="layui-input-block">
                                <input type="text" name="account" id="name" lay-verify="" placeholder="请输入姓名" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">手机号</label>
                            <div class="layui-input-block">
                                <input type="text" name="account" id="phone" lay-verify="" placeholder="请输入手机号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">用户类型</label>
                            <div class="layui-input-block">
                                <select lay-verify="" lay-filter="userType">
                                    <option value="">选择用户类型</option>
                                    <option value="0">总公司用户</option>
                                    <option value="1">分公司用户</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">所属公司</label>
                            <div class="layui-input-block">
                                <select id="companyId" name="companyId" lay-filter="company" lay-verify="" lay-search="">
                                    <option value="">选择或搜索公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">所属部门</label>
                            <div class="layui-input-block">
                                <select id="departmentId" name="departmentId" lay-verify="" lay-search="">
                                    <option value="">选择或搜索部门</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">角色</label>
                            <div class="layui-input-block">
                                <select id="roleId" name="roleId" lay-verify="" lay-search="">
                                    <option value="">选择或搜索角色</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">身份属性</label>
                            <div class="layui-input-block">
                                <select id="incumbency" name="type" lay-verify="">
                                    <option value="">选择身份属性</option>
                                    <option value="0">实习</option>
                                    <option value="1">磨合期</option>
                                    <option value="2">正式</option>
                                    <option value="3">离职</option>
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
        <legend>用户列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_53"><i class="layui-icon">&#xe608;</i> 添加用户</button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_182" onclick="userExcel()">导出用户<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_200" onclick="importUser()">导入用户<i class="fa fa-file-text-o"></i></button>
                <button class="layui-btn layui-btn-small layui-btn-default hide checkBtn_200" onclick="templateDownload()">模版下载<i class="fa fa-file-text-o"></i></button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>账号</th>
                        <th>姓名</th>
                        <th>手机号</th>
                        <th>所属公司</th>
                        <th>所属部门</th>
                        <th>角色名</th>
                        <th>入职时间</th>
                        <th>转正时间</th>
                        <th>工资</th>
                        <th>身份属性</th>
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
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
<script>

    var form = null;
    var dataTable = null;
    $(document).ready(function() {
        dataTable = $('#dataTable').DataTable( {
            "searching": false,
            "bStateSave": true, //状态保存，使用了翻页或者改变了每页显示数据数量，会保存在cookie中，下回访问时会显示上一次关闭页面时的内容。
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
                url: YZ.ip + "/user/findUserPageForWeb",
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
                    data.account = $("#account").val(); //账号
                    data.name = $("#name").val(); //姓名
                    data.phone = $("#phone").val(); //手机号
                    data.companyId = $("#companyId").val(); //公司
                    data.departmentId = $("#departmentId").val(); //部门
                    data.roleId = $("#roleId").val(); //角色
                    data.incumbency = $("#incumbency").val(); //身份属性
                }
            },
            "columns": [
                //{ "data": "realName", "field" : "A.real_name" },
                { "data": "account" },
                { "data": "name" },
                { "data": "phone" },
                { "data": "companyName" },
                { "data": "departmentName" },
                { "data": "roleName" },
                { "data": "entryTime" },
                { "data": "positiveTime" },
                { "data": "salary" },
                { "data": "incumbency" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "一真平台";
                        else return data;
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        if (data == null || data == "") return "--";
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        return "<span class=\"money\">￥&nbsp;" + data + "</span>";
                    },
                    "targets": 8
                },
                {
                    "render": function(data, type, row) {
                        if (data == 0) return "实习";
                        if (data == 1) return "磨合期";
                        if (data == 2) return "正式";
                        if (data == 3) return "离职";
                        return "--";
                    },
                    "targets": 9
                },
                {
                    "render": function(data, type, row) {
                        var strBtn = "";

                        if (row.incumbency == 0) {
                            strBtn = "<button onclick=\"becomeAFullMember(" + row.id + ")\" class=\"layui-btn layui-btn-warm layui-btn-small hide checkBtn_163\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;转正</button>";
                        }
                        else if (row.incumbency == 2) {
                            strBtn = "<button onclick=\"dimission(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-danger hide checkBtn_176\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;离职</button>";
                        }
                        return "<button onclick=\"detailData(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-normal\"><i class=\"fa fa-list fa-file-text-o\"></i>&nbsp;查看详情</button>" +
                                "<button onclick=\"updateData(" + row.id + ")\" class=\"layui-btn layui-btn-small hide checkBtn_54\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;修改</button>" +
                                "<button onclick=\"resetPasswords(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-danger hide checkBtn_140\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;重置密码</button>" +
                                strBtn;
                    },
                    "targets": 10
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
        location.reload();
        var index = layer.load(1, {shade: [0.5,'#eee']});
        setTimeout(function () {layer.close(index);}, 600);
    }

    layui.use(['form', 'layedit', 'laydate', 'layim'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        //监听select事件--用户类型过滤器
        form.on('select(userType)', function(data){
            console.log(data);
            if (Number(data.value) == 0) {
                $("select[name='companyId']").parent().parent().hide();
                //$("select[name='departmentId']").parent().parent().hide();
                getCompanyListType(0, 0);
                getDepartmentList(null, 0, 0);
            }
            else {
                getCompanyListType(1, 0);
            }
            getRoleListType(Number(data.value), 0);
            form.render('select');
        });
        //公司过滤器
        form.on('select(company)', function(data){
            console.log(data);
            getDepartmentListType(Number(data.value), 1, null, 0);
            form.render('select');
        });
    });


    function importUser(){
        $('#File').click();
    }

    function templateDownload(){
        window.open(YZ.ip + "/resources/template/user_template.xls", "_blank");
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
                            YZ.ajaxRequestData("get", false, YZ.ip + "/import/importUser", {url : YZ.ipImg + "/" + result.data.url}, null , function(result){
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
            title: '添加用户',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/user/add"
        });
        layer.full(index);
    }
    //修改
    function updateData (id) {
        var index = layer.open({
            type: 2,
            title: '修改用户',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/user/edit?userId=" + id
        });
        layer.full(index);
    }

    //查看详情
    function detailData(id) {

        layer.open({
            type: 2,
            title: '用户详情',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: YZ.ip + "/page/user/detail?userId=" + id
        });

        //一下是自定义封装的form弹窗
        return false;
        var html = '<form class="layui-form layui-form-pane" action="">' +
                        '<div class="layui-form-item">' +
                            '<label class="layui-form-label">长输入框</label>' +
                            '<div class="layui-input-block">' +
                                '<input type="text" name="title" autocomplete="off" placeholder="请输入标题" class="layui-input">' +
                            '</div>' +
                        '</div>' +
                    '</form>';

        YZ.formPopup(html, "修改信息", function () {
            layer.msg('点击了提交', {icon: 1});
        }, function () {
            layer.msg('点击了关闭', {icon: 2});
        });


    }

    //重置密码
    function resetPasswords (id) {
        if (id == YZ.getUserInfo().id) {
            layer.msg('抱歉，您不能重置自己的密码', {icon: 2, anim : 6});
            return false;
        }
        layer.confirm('您确定重置密码？', {
            btn: ['确定','不确定'] //按钮
        }, function(){
            var arr = {
                userId : id,
                password : $.md5("111111")
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/user/resetPassword", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.alert('重置密码成功.', {
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
        }, function(){ });
    }

    //离职
    function dimission (id) {
        layer.confirm('您确定离职吗？', {
            btn: ['确定','不确定'] //按钮
        }, function(){
            var arr = {
                userId : id,
                //resignTime : new Date(),
                incumbency : 3
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/user/setUserStatus", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.alert('离职成功.', {
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
        }, function(){ });
    }

    //转正
    function becomeAFullMember (id) {
        layer.confirm('您确定转正吗？', {
            btn: ['确定','不确定'] //按钮
        }, function(){
            var arr = {
                userId : id,
                //positiveTime : new Date(),
                incumbency : 2
            }
            YZ.ajaxRequestData("post", false, YZ.ip + "/user/setUserStatus", arr , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.alert('转正成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 4 //动画类型
                    }, function(){
                        dataTable.ajax.reload();
                        layer.close(index2);
                        var index = layer.load(1, {shade: [0.5,'#eee']});
                        setTimeout(function () {layer.close(index);}, 600);
                    });
                }
            });
        }, function(){ });
    }

    //外部项目报表导出
    function userExcel () {
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
            window.location.href = YZ.ip + "/excel/userExcel"
                    + "?password=" + $("#password").val()
                    + "&account=" + $("#account").val()
                    + "&userType=" + $("#userType").val()
                    + "&companyId=" + $("#companyId").val()
                    + "&departmentId=" + $("#departmentId").val()
                    + "&roleId=" + $("#roleId").val()
                    + "&incumbency=" + $("#incumbency").val()
            ;
            layer.close(index);
        }, function () {
        });
    }

</script>
</body>
</html>
