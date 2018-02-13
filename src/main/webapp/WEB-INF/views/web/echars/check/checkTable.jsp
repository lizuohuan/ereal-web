<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>三维绩效汇总表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .check-table{width: 100%;background: #000;border: 1px solid #fff;}
        .check-table td, th{
            display: table-cell;
            vertical-align: inherit;
        }
        .check-table td{
            text-align: center;
            border: 1px solid #fff;
            padding: 8px;
            font-size: 16px;
            color: #fff;
            font-weight: 500;
        }
        .max-title{
            font-size: 24px !important;
            color: #0C0C0C;
            font-weight: bold;
        }
        .blue{background: #4BACC6}
        .gray{background: #808080}
        .dark-gray{background: #414951}
        .green{background: #C4A378}
        .notData{display: none;}
        .notData td{text-align: center}
    </style>
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
                                <select id="timeType" name="timeType" lay-filter="timeType">
                                    <option value="1">周</option>
                                    <option value="2">月</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择时间</label>
                            <div class="layui-input-block">
                                <input class="layui-input" id="time" placeholder="选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button type="button" class="layui-btn" id="search" onclick="passingParameters()"><i class="layui-icon">&#xe615;</i> 搜索</button>
                            <button type="reset" class="layui-btn layui-btn-primary">清空</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field"></button>
        <legend>三维绩效汇总表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <table class="check-table">
                <thead>
                    <tr>
                        <td colspan="15" scope="col" class="max-title">四川一真管理咨询有限公司三维度绩效考核统计表</td>
                    </tr>
                    <tr>
                        <td rowspan="2">序号</td>
                        <td rowspan="2">团队</td>
                        <td rowspan="2" class="blue">总得分</td>
                        <td rowspan="2" class="blue">排名</td>
                        <td colspan="4" class="gray">K值完成率（50分）</td>
                        <td colspan="4" class="dark-gray">目标任务（30分）</td>
                        <td colspan="3" class="green">文化工程得分（20分）</td>
                    </tr>
                    <tr>
                        <td class="gray">实际K值</td>
                        <td class="gray">目标K值</td>
                        <td class="gray">K值完成率</td>
                        <td class="gray">得分</td>
                        <td class="dark-gray">实际结项</td>
                        <td class="dark-gray">目标任务</td>
                        <td class="dark-gray">结项完成率</td>
                        <td class="dark-gray">得分</td>
                        <td class="green">团队得分</td>
                        <td class="green">平均值</td>
                        <td class="green">得分</td>
                    </tr>
                </thead>
                <tbody id="tbodyData">
                    <%--<tr>
                        <td>1</td>
                        <td>斯隆队</td>
                        <td class="blue">77.52</td>
                        <td class="blue">9</td>
                        <td class="gray">0.93</td>
                        <td class="gray">1.24</td>
                        <td class="gray">75.1%</td>
                        <td class="gray">37.56</td>
                        <td class="dark-gray">0.56</td>
                        <td class="dark-gray">0.90</td>
                        <td class="dark-gray">62.52%</td>
                        <td class="dark-gray">18.76</td>
                        <td class="green">85.18</td>
                        <td class="green" rowspan="51">50</td>
                        <td class="green">21.21</td>
                    </tr>
                    <c:forEach begin="1" end="50">
                        <tr>
                            <td>2</td>
                            <td>斯隆队</td>
                            <td class="blue">77.52</td>
                            <td class="blue">9</td>
                            <td class="gray">0.93</td>
                            <td class="gray">1.24</td>
                            <td class="gray">75.1%</td>
                            <td class="gray">37.56</td>
                            <td class="dark-gray">0.56</td>
                            <td class="dark-gray">0.90</td>
                            <td class="dark-gray">62.52%</td>
                            <td class="dark-gray">18.76</td>
                            <td class="green">85.18</td>
                            <td class="green">21.21</td>
                        </tr>
                    </c:forEach>--%>
                </tbody>
                <tfoot>
                    <tr class="notData">
                        <td colspan="99">暂无数据</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>

    //默认查询当天
    window.onload = function () {
        var date = new Date();
        $("#time").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
    }

    //参数调用
    function passingParameters() {
        var time = $("#time").val();
        var companyId = $("#companyId").val();
        var timeType = $("#timeType").val();
        if (time != "") {
            time = YZ.getTimeStamp(time);
        }
        else {
            layer.msg('请选择要查询的时间.', {icon: 2, anim: 6});
            return false;
        }
        if (companyId == "") {
            companyId = 0;
        }

        var index = layer.load(1, {shade: [0.5,'#eee']});
        bindData(time, timeType, companyId);
        setTimeout(function () {layer.close(index);}, 600);
    }

    //默认查询登录人
    bindData(new Date().getTime(), 1, YZ.getUserInfo().companyId);

    /**
     * 三维绩效总汇表
     * @param time 时间
     * @param timeType 1：周 2：月
     * @param companyId 公司id
     * @return
     */
    function bindData (time, timeType, companyId) {
        var arr = {
            companyId : companyId,
            time : time,
            timeType : timeType
        }

        YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/getTotalAchievements", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {

                if (result.data.length == 0) {$(".notData").show(); $("#tbodyData").html(""); return false;}
                else {$(".notData").hide()};

                /** 部门名 */
                var departmentName = result.data[0].departmentName == null || "" ? "--" : result.data[0].departmentName;
                /** 总得分 */
                var totalScore = result.data[0].totalScore == null || "" ? "--" : result.data[0].totalScore;
                /** 排名 */
                var ranking = result.data[0].ranking == null || "" ? "--" : result.data[0].ranking;
                /** 实际k值 （一维） */
                var actualK = result.data[0].actualK == null || "" ? "--" : result.data[0].actualK;
                /** 目标k值 （一维） */
                var targetK = result.data[0].targetK == null || "" ? "--" : result.data[0].targetK;
                /** k值完成率（一维） */
                var kSchedule = result.data[0].kSchedule == null || "" ? "--" : result.data[0].kSchedule;
                /** 得分（一维） */
                var oneScore = result.data[0].oneScore == null || "" ? "--" : result.data[0].oneScore;
                /** 实际结项（二维） */
                var actualJX = result.data[0].actualJX == null || "" ? "--" : result.data[0].actualJX;
                /** 目标结项（二维） */
                var targetJX = result.data[0].targetJX == null || "" ? "--" : result.data[0].targetJX;
                /** 结项完成率（二维） */
                var kProjectSchedule = result.data[0].kProjectSchedule == null || "" ? "--" : result.data[0].kProjectSchedule;
                /** 得分（二维） */
                var twoScore = result.data[0].twoScore == null || "" ? "--" : result.data[0].twoScore;
                /** 团队得分（三维） */
                var teamScore = result.data[0].teamScore == null || "" ? "--" : result.data[0].teamScore;
                /** 平均值（三维） */
                var averageScore = result.data[0].averageScore == null || "" ? "--" : result.data[0].averageScore;
                /** 得分（三维） */
                var threeScore = result.data[0].threeScore == null || "" ? "--" : result.data[0].threeScore;
                var html = '<tr>' +
                        '<td>1</td>' +
                        '<td>' + departmentName + '</td>' +
                        '<td class="blue">' + totalScore + '</td>' +
                        '<td class="blue">' + ranking + '</td>' +
                        '<td class="gray">' + actualK + '</td>' +
                        '<td class="gray">' + targetK + '</td>' +
                        '<td class="gray">' + kSchedule + '%</td>' +
                        '<td class="gray">' + oneScore + '</td>' +
                        '<td class="dark-gray">' + actualJX + '</td>' +
                        '<td class="dark-gray">' + targetJX + '</td>' +
                        '<td class="dark-gray">' + kProjectSchedule + '%</td>' +
                        '<td class="dark-gray">' + twoScore + '</td>' +
                        '<td class="green">' + teamScore + '</td>' +
                        '<td class="green" rowspan="' + (result.data.length + 1) + '">' + averageScore + '</td>' +
                        '<td class="green">' + threeScore + '</td>' +
                        '</tr>';
                for (var i = 1; i < result.data.length; i++) {
                    /** 部门名 */
                    departmentName = result.data[i].departmentName == null || "" ? "--" : result.data[i].departmentName;
                    /** 总得分 */
                    totalScore = result.data[i].totalScore == null || "" ? "--" : result.data[i].totalScore;
                    /** 排名 */
                    ranking = result.data[i].ranking == null || "" ? "--" : result.data[i].ranking;
                    /** 实际k值 （一维） */
                    actualK = result.data[i].actualK == null || "" ? "--" : result.data[i].actualK;
                    /** 目标k值 （一维） */
                    targetK = result.data[i].targetK == null || "" ? "--" : result.data[i].targetK;
                    /** k值完成率（一维） */
                    kSchedule = result.data[i].kSchedule == null || "" ? "--" : result.data[i].kSchedule;
                    /** 得分（一维） */
                    oneScore = result.data[i].oneScore == null || "" ? "--" : result.data[i].oneScore;
                    /** 实际结项（二维） */
                    actualJX = result.data[i].actualJX == null || "" ? "--" : result.data[i].actualJX;
                    /** 目标结项（二维） */
                    targetJX = result.data[i].targetJX == null || "" ? "--" : result.data[i].targetJX;
                    /** 结项完成率（二维） */
                    kProjectSchedule = result.data[i].kProjectSchedule == null || "" ? "--" : result.data[i].kProjectSchedule;
                    /** 得分（二维） */
                    twoScore = result.data[i].twoScore == null || "" ? "--" : result.data[i].twoScore;
                    /** 团队得分（三维） */
                    teamScore = result.data[i].teamScore == null || "" ? "--" : result.data[i].teamScore;
                    /** 得分（三维） */
                    threeScore = result.data[i].threeScore == null || "" ? "--" : result.data[i].threeScore;
                    html += '<tr>' +
                            '<td>' + (i + 1) + '</td>' +
                            '<td>' + departmentName + '</td>' +
                            '<td class="blue">' + totalScore + '</td>' +
                            '<td class="blue">' + ranking + '</td>' +
                            '<td class="gray">' + actualK + '</td>' +
                            '<td class="gray">' + targetK + '</td>' +
                            '<td class="gray">' + kSchedule + '%</td>' +
                            '<td class="gray">' + oneScore + '</td>' +
                            '<td class="dark-gray">' + actualJX + '</td>' +
                            '<td class="dark-gray">' + targetJX + '</td>' +
                            '<td class="dark-gray">' + kProjectSchedule + '%</td>' +
                            '<td class="dark-gray">' + twoScore + '</td>' +
                            '<td class="green">' + teamScore + '</td>' +
                            '<td class="green">' + threeScore + '</td>' +
                            '</tr>';
                }
                $("#tbodyData").html(html);
            }
        });
    }

    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getCompanyListType(null, YZ.getUserInfo().companyId);

        form.render(); //重新渲染

    });

</script>
</body>
</html>
