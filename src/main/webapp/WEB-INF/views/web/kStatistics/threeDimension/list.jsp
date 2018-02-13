<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>三维统计列表</title>

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
        <legend>三维统计列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn layui-btn-small layui-btn-normal"><i class="layui-icon">&#xe605;</i> 确认数据</button>
                <button onclick="goIssue()" class="layui-btn layui-btn-small layui-btn-default" onclick="batchDispose()"><i class="layui-icon">&#x1005;</i> 去发布</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>部门名</th>
                        <th>员工名</th>
                        <th>个人贡献(Kg)</th>
                        <th>工作学习时间增长率(Tz)</th>
                        <th>运动及集体活动(Yd)</th>
                        <th>热心文化会议(Hy)</th>
                        <th>文化故事及新闻撰稿(Wx)</th>
                        <th>着装及办公5S(Zb)</th>
                        <th>个人K文化</th>
                        <%--<th>团队K文化</th>
                        <th>团队K文化完成率</th>--%>
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
            "serverSide": true,/*
            "aLengthMenu" : [20, 40, 60], //更改显示记录数选项
            "iDisplayLength" : 40, //默认显示的记录数
            "bPaginate" : true, //是否显示（应用）分页器*/
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
                url: YZ.ip + "/kStatistics/threeListForWeb",
                "dataSrc": function(json) {
                    console.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function(data) {
                    /**
                     * 三维统计 web
                     * @param time 时间
                     //     * @param userId 用户id
                     //     * @param departmentId 团队id
                     //     * @param companyId 公司id
                     * @param type 查询类型 0 :个人 1:部门 2：公司
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
                { "data": "departmentName" },
                { "data": "userName" },
                { "data": "kg" },
                { "data": "tz" },
                { "data": "yd" },
                { "data": "hy" },
                { "data": "wx" },
                { "data": "zb" },
                { "data": "personKCulture" },
                /*{ "data": "teamKCulture" },
                { "data": "teamKCultureFinishRate" },*/
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return data == null ? 0 : data;
                    },
                    "targets": 8
                },
                /*{
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='addData(" + object + ")' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_117'><i class='fa fa-list fa-edit'></i>&nbsp;发布</button>";
                    },
                    "targets": 11
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
            YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/threeListForWebNoPage", parameter , null , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    dataList = result.data;
                }
            });
            if (dataList.length == 0) {
                layer.msg('没有可确认的数据.', {icon: 2, anim: 6});
                return false;
            }

            var usersStatistics = []; // 封装数据实体
            var threeVeidooStas = []; // 封装 第三维 UsersStatisticsThree
            for (var i = 0; i < dataList.length; i++) {
                dataList[i].type = 1;
                dataList[i].personKCulture = dataList[i].personKCulture == null ? 0 : dataList[i].personKCulture;
                dataList[i].teamKCulture = dataList[i].teamKCulture == null ? 0 : dataList[i].teamKCulture;
                dataList[i].teamKCultureFinishRate = dataList[i].teamKCultureFinishRate == null ? 0 : dataList[i].teamKCultureFinishRate;
                dataList[i].wwcl = dataList[i].personKCulture; //当前阶段文化工程完成率（三维）
                usersStatistics.push(dataList[i]);

                for (var j = 0; j < dataList[i].threeVeidooStas.length; j++) {
                    var json = {
                        userId : dataList[i].userId,
                        userStatisticsId : 0,
                        threeVeidooId : dataList[i].threeVeidooStas[j].id,
                        threeVeidooScore : dataList[i].threeVeidooStas[j].score,
                        msg : dataList[i].threeVeidooStas[j].msg,
                        threeVeidooName : dataList[i].threeVeidooStas[j].targetName,
                    };
                    threeVeidooStas.push(json);
                }

//                //添加kg
//                var json = {
//                    userId : dataList[i].userId,
//                    userStatisticsId : 0,
//                    threeVeidooId : 1,
//                    threeVeidooScore : dataList[i].kg,
//                    msg : null,
//                    threeVeidooName : null,
//                }
//                threeVeidooStas.push(json);
//
//                //添加tz
//                json = {
//                    userId : dataList[i].userId,
//                    userStatisticsId : 0,
//                    threeVeidooId : 2,
//                    threeVeidooScore : dataList[i].tz,
//                    msg : null,
//                    threeVeidooName : null,
//                }
//                threeVeidooStas.push(json);

            }

            parameter = {
                usersStatistics : JSON.stringify(usersStatistics),
                time : YZ.getTimeStamp($("#time").val()),
                timeType : $("#timeType").val(),
                tieUpType : 3, // 表示三维
                companyId : $("#companyId").val(),
                usersStatisticsThree : JSON.stringify(threeVeidooStas)
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
        localStorage.setItem("threeCompanyName", $("#companyId option:selected").text());
        localStorage.setItem("threeTimeName", $("#timeType option:selected").text());
        var index = layer.open({
            type: 2,
            title: '三维已发布数据',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/kStatistics/threeDimension/dataList?companyId="
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
        var index = layer.load(1, {shade: [0.5,'#eee']});
        dataTable.ajax.reload();
        layer.close(index);
    }


</script>
</body>
</html>
