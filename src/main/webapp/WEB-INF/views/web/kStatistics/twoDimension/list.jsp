<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>二维统计列表</title>

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
                            <label class="layui-form-label">选择公司</label>
                            <div class="layui-input-block">
                                <select id="companyId" name="companyId" lay-filter="company" lay-search="">
                                    <option value="">选择或搜索公司</option>
                                    <option value="0" disabled>暂无</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">时间类型</label>
                            <div class="layui-input-block">
                                <select id="timeType" name="timeType">
                                    <option value="1">周</option>
                                    <option value="2">月</option>
                                    <option value="3">年</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">时间</label>
                            <div class="layui-input-block">
                                <input type="text" id="time" name="time" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
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
        <legend>二维统计列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_116"><i class="layui-icon">&#xe605;</i> 确认数据</button>
                <button onclick="goIssue()" class="layui-btn layui-btn-small layui-btn-default hide checkBtn_151" onclick="batchDispose()"><i class="layui-icon">&#x1005;</i> 去发布</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>公司名</th>
                        <th>部门名</th>
                        <th>员工名</th>
                        <th>任务完成率（%）</th>
                    </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>
    //默认查询当天
    window.onload = function () {
        var date = new Date();
        $("#time").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
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
                url: YZ.ip + "/kStatistics/towListForWeb",
                headers: {
                    "token" : YZ.getUserInfo() == null ? null : YZ.getUserInfo().token,
                },
                "dataSrc": function(json) {
                    console.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    else if (json.code == 202) {
                        var index = layer.alert(json.msg, {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 5 //动画类型
                        }, function(){
                            layer.close(index);
                        });
                    }
                    return [];
                },
                "data": function(data) {
                    /**
                     * 二维统计 web
                     * @param time 时间
                     * @param userId 用户id
                     * @param departmentId 团队id
                     * @param companyId 公司id
                     * @param type 查询类型 0 :个人 1:部门 2：公司
                     * @param groupType 分组类型  0 :个人 1:部门 2：公司
                     * @return
                     */
                    data.companyId = $("#companyId").val();
                    data.timeType = $("#timeType").val();
                    if ($("#time").val() != "") {
                        data.time = YZ.getTimeStamp($("#time").val());
                    }
                    data.groupType = 0;
                    data.type = 2;
                }
            },
            "columns": [
                { "data": "companyName" },
                { "data": "departmentName" },
                { "data": "userName" },
                { "data": "schedule" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return data == null || data == "" ? 0 : data;
                    },
                    "targets": 3
                },
                /*{
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='addData(" + object + ")' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_116'><i class='fa fa-list fa-edit'></i>&nbsp;发布</button>";
                    },
                    "targets": 4
                },*/
            ]
        } );

        $("#search").click(function(){
            dataTable.ajax.reload();
            return false;
        });

    } );

    //发布
    function addData () {

        if ($("#companyId").val() == "") {
            layer.msg('请选择公司.', {icon: 2, anim: 6});
            return false;
        }
        if ($("#time").val() == "") {
            layer.msg('请选择时间.', {icon: 2, anim: 6});
            return false;
        }
        var msg = $("#companyId option:selected").text() + "-" + $("#timeType option:selected").text() + "度-" + $("#time").val();
        var index3 = layer.confirm('您确定要发布<span style="color: red;font-weight: bold">&nbsp;' + msg + '&nbsp;</span>的数据？', {
            btn: ['确定','不确定'] //按钮
        }, function(){

            var parameter = {
                companyId : $("#companyId").val(),
                timeType : $("#timeType").val(),
                time : YZ.getTimeStamp($("#time").val()),
                groupType : 0,
                type : 2
            }
            var dataList = [];
            YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/towListForWebNoPage", parameter , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    dataList = result.data;
                }
            });
            if (dataList.length == 0) {
                layer.msg('没有可确认的数据.', {icon: 2, anim: 6});
                return false;
            }

            var usersStatistics = []; // 封装数据实体
            for (var i = 0; i < dataList.length; i++) {
                dataList[i].type = 1;
                dataList[i].rwcl = dataList[i].schedule == null ? 0 : dataList[i].schedule;
                usersStatistics.push(dataList[i]);
            }
            parameter = {
                usersStatistics : JSON.stringify(usersStatistics),
                time : YZ.getTimeStamp($("#time").val()),
                timeType : $("#timeType").val(),
                tieUpType : 2, // 表示二维
                companyId : $("#companyId").val()
            }
            console.log(parameter);
            YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/saveList", parameter , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('确认数据成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        var index2 = layer.load(1, {shade: [0.5,'#eee']});
                        dataTable.ajax.reload();
                        setTimeout(function () {layer.close(index2);}, 600);
                        layer.close(index);
                        layer.close(index3);
                    });
                }
            });

        }, function(){ });
    }

    //去发布
    function goIssue () {
        if ($("#companyId").val() == "") {
            layer.msg('请选择公司.', {icon: 2, anim: 6});
            return false;
        }
        if ($("#time").val() == "") {
            layer.msg('请选择时间.', {icon: 2, anim: 6});
            return false;
        }
        localStorage.setItem("twoCompanyName", $("#companyId option:selected").text());
        localStorage.setItem("twoTimeName", $("#timeType option:selected").text());
        var index = layer.open({
            type: 2,
            title: '二维已发布数据',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/kStatistics/twoDimension/dataList?companyId="
            + $("#companyId").val()
            + "&timeType=" + $("#timeType").val()
            + "&time=" + $("#time").val()
        });
        layer.full(index);
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getCompanyListType(null, YZ.getUserInfo().companyId);
        form.render(); //重新渲染

    });

    //提供给子页面
    var closeNodeIframe = function () {
        location.reload();
    }


</script>
</body>
</html>
