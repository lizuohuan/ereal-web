<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>目标指标项目部列表</title>

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
                            <label class="layui-form-label">选择部门</label>
                            <div class="layui-input-block">
                                <select name="departmentId" lay-verify="" lay-search="" lay-filter="department">
                                    <option value="">选择或搜索部门</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline layui-hide">
                            <label class="layui-form-label">时间类型</label>
                            <div class="layui-input-block">
                                <select id="timeType" name="timeType">
                                    <option value="0">周</option>
                                    <option value="1">月</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">针对月份</label>
                            <div class="layui-input-block">
                                <input type="text" name="targetTime" lay-verify="" placeholder="请选择针对月份" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"  autocomplete="off" class="layui-input" readonly>
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
        <legend>目标指标项目部列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addSecondTargetConfig()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_118"><i class="layui-icon">&#xe608;</i> 添加</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>公司名称</th>
                        <th>部门名称</th>
                        <th>指标名称</th>
                        <th>指标权重</th>
                        <th>目标结项数</th>
                        <th>指标值描述</th>
                        <th>针对月份</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
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
                url: YZ.ip + "/secondTarget/querySecondTarget",
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
                    data.isScore = 0;
                    data.departmentId = $("select[name='departmentId']").val();
                    data.timeType = 1;
                    data.date = "" == $("input[name='targetTime']").val() ? null : YZ.getTimeStamp($("input[name='targetTime']").val());
                    if ($("input[name='targetTime']").val() != "") {
                        data.targetTime = new Date($("input[name='targetTime']").val());
                    }
                    data.isProjectDepartment = 1; //只查项目部的
                }
            },
            "columns": [
                { "data": "companyName" },
                { "data": "departmentName" },
                { "data": "targetName" },
                { "data": "targetWeight" },
                { "data": "targetNum" },
                { "data": "targetMsg" },
                { "data": "targetTime" },
                { "data": "startTime" },
                { "data": "endTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "--";
                        else return data;
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM");
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
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 8
                },
                {
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='updateData(" + object + ")' class='layui-btn layui-btn-small hide checkBtn_119'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                                //"<button onclick=\"deleteData(" + row.id + ")\" class=\"layui-btn layui-btn-small layui-btn-danger hide checkBtn_120\"><i class=\"layui-icon\">&#xe640;</i>&nbsp;删除</button>"
                    },
                    "targets": 9
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

        getAllDepartment(0);
        form.render();
    });

    //添加
    function addSecondTargetConfig() {
        var index = layer.open({
            type: 2,
            title: '添加目标指标配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/secondTarget/add?isProjectDepartment=1"
        });
        layer.full(index);
    }

    //删除
    function deleteData (id) {
        layer.confirm("是否确认删除该目标指标配置？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondTarget/delSecondTarget", {id : id} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('删除成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 5 //动画类型
                    }, function(){
                        dataTable.ajax.reload();
                        layer.close(index);
                    });
                }
            });
        }, function(){
            //layer.msg('已取消.', {icon: 2});
        });
    }

    //修改
    function updateData (detail) {
        localStorage.setItem("secondTarget", JSON.stringify(detail));
        var index = layer.open({
            type: 2,
            title: '修改目标指标配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/config/secondTarget/edit?isProjectDepartment=1"
        });
        layer.full(index);
    }

    //通过
    function pass(id) {
        var index = layer.confirm("您确定通过？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondTarget/updateSecondTarget", {id : id, isApproved : 1} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.load(1, {shade: [0.5,'#eee']});
                    dataTable.ajax.reload();
                    setTimeout(function () {layer.close(index2);}, 600);
                    layer.close(index);
                }
            });
        }, function(){
            //layer.msg('已取消.', {icon: 2});
        });
    }

    //不通过
    function noPass(id) {
        var index = layer.confirm("您确定不通过？", {
            btn: ['确定','取消'], //按钮
            title : "确认提示",
        }, function(){
            YZ.ajaxRequestData("post", false, YZ.ip + "/secondTarget/updateSecondTarget", {id : id, isApproved : 0} , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index2 = layer.load(1, {shade: [0.5,'#eee']});
                    dataTable.ajax.reload();
                    setTimeout(function () {layer.close(index2);}, 600);
                    layer.close(index);
                }
            });
        }, function(){
            //layer.msg('已取消.', {icon: 2});
        });
    }

    //打分
    function grade (id, score) {
        layer.prompt({
            formType: 3,
            value: score,
            title: '请输入分数',
            area: ['400px', '200px'] //自定义文本域宽高
        }, function(value, index, elem){
            if(value.length > 0 && !YZ.isDouble.test(value)) {
                layer.msg('请输入(0-100).', {icon: 2, anim: 6, offset: 't'});
                return false;
            }
            if(value < 0 || value > 100) {
                layer.msg('请输入(0-100).', {icon: 2, anim: 6,});
                return false;
            }
            var arr = {
                secondTargetId : id,
                score : value
            }
            YZ.ajaxRequestData("get", false, YZ.ip + "/secondTargetScore/addSecondTargetScore", arr, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    var index2 = layer.load(1, {shade: [0.5,'#eee']});
                    dataTable.ajax.reload();
                    layer.close(index2);
                    layer.close(index);
                }
            });
        });
    }



</script>
</body>
</html>
