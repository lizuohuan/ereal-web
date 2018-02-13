<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>个人工时统计</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        body{overflow: scroll}
        .check-table{border: 1px solid #fff;background: #fff}
        .check-table td, th{
            display: table-cell;
            vertical-align: inherit;
        }
        .check-table td{
            text-align: center;
            border: 1px solid #e2e2e2;
            padding: 8px;
            font-size: 13px;
            font-weight: 500;
            box-sizing: border-box;
            width: 36px;
            height: 34px;
        }
        .check-table thead td{
            padding: 8px 0;
            width: 70px;
            font-size: 13px;
            font-weight: 600;
        }
        .max-title{
            font-size: 24px !important;
            color: #0C0C0C;
            font-weight: bold;
        }
        .notData{display: none;}
        .notData td{text-align: center}
        .context{
            position:absolute;
            z-index:1;
            height: 10px;
            border: 2px solid;
            border-top:none;
            text-align: center;
            left:0;
            top: 33px;
            padding: 0px 10px;
            box-sizing: border-box;
        }
        .context span{
            position: relative;
            top: -20px;
            text-align: left;
            display: inline-block;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .context .totalTime{
            position: relative;
            top: -8px;
            font-size: 16px;
            font-weight: 600;
        }
        .relative{position: relative;}
        .userName{font-size: 13px;}

        .layui-layer-tips{
            word-wrap:break-word;
        }
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
        <legend>个人工时统计&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form" style="width: 2300px">
            <blockquote class="layui-elem-quote">
                <button onclick="generateImages(event)" class="layui-btn layui-btn-small hide checkBtn_185"><i class="layui-icon">&#xe64a;</i> 生成图片</button>
                <a id="downloadImg" download="0.png" class="layui-btn layui-btn-small hide">下载</a>
            </blockquote>
            <table class="check-table" id="dataTable">
                <thead>
                    <tr>
                        <td colspan="99" class="max-title"><span id="titleDate"></span><span id="week"></span>工作/学习记录传递卡</td>
                    </tr>
                    <tr>
                        <td width="68px">员工名</td>
                        <td width="72px" colspan="2" class="time">00:00</td>
                        <td width="72px" colspan="2" class="time">01:00</td>
                        <td width="72px" colspan="2" class="time">02:00</td>
                        <td width="72px" colspan="2" class="time">03:00</td>
                        <td width="72px" colspan="2" class="time">04:00</td>
                        <td width="72px" colspan="2" class="time">05:00</td>
                        <td width="72px" colspan="2" class="time">06:00</td>
                        <td width="72px" colspan="2" class="time">07:00</td>
                        <td width="72px" colspan="2" class="time" id="dot8">08:00</td>
                        <td width="72px" colspan="2" class="time" id="dot9">09:00</td>
                        <td width="72px" colspan="2" class="time" id="dot10">10:00</td>
                        <td width="72px" colspan="2" class="time" id="dot11">11:00</td>
                        <td width="72px" colspan="2" class="time" id="dot12">12:00</td>
                        <td width="72px" colspan="2" class="time" id="dot13">13:00</td>
                        <td width="72px" colspan="2" class="time" id="dot14">14:00</td>
                        <td width="72px" colspan="2" class="time" id="dot15">15:00</td>
                        <td width="72px" colspan="2" class="time" id="dot16">16:00</td>
                        <td width="72px" colspan="2" class="time" id="dot17">17:00</td>
                        <td width="72px" colspan="2" class="time" id="dot18">18:00</td>
                        <td width="72px" colspan="2" class="time" id="dot19">19:00</td>
                        <td width="72px" colspan="2" class="time" id="dot20">20:00</td>
                        <td width="72px" colspan="2" class="time" id="dot21">21:00</td>
                        <td width="72px" colspan="2" class="time" id="dot22">22:00</td>
                        <td width="72px" colspan="2" class="time" id="dot23">23:00</td>
                        <td width="72px" colspan="2" class="time" id="dot24">24:00</td>
                        <td width="72px">合计</td>
                        <td width="72px">运动</td>
                    </tr>
                </thead>
                <tbody id="tbodyData">
                    <%--<c:forEach begin="1" end="10">
                        <tr>
                            <td rowspan="2">陈海</td>
                            <td>
                                <div class="context" title="">
                                    玩车两个鄂打算放寒假大概卡电饭锅肯定是啊加点水
                                </div>
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td rowspan="2">8.5h</td>
                            <td rowspan="2">0.5h</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/html2canvas.js"></script>

<script>

    //默认查询当天
    window.onload = function () {
        var date = new Date();
        $("#time").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
        $("#titleDate").text(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
        $("#week").text("(" + getWeek(date.getDay()) + ")");
    }

    //参数调用
    function passingParameters() {
        var time = $("#time").val();
        var date = new Date(time);
        $("#titleDate").text(time);
        $("#week").text("(" + getWeek(date.getDay()) + ")");
        $("#week").text("(" + getWeek(date.getDay()) + ")");
        var departmentId = $("#departmentId").val();
        var companyId = $("#companyId").val();
        if (companyId == "") {
            layer.msg('请选择公司.', {icon: 2, anim: 6});
            return false;
        }
        if (time != "") {
            time = YZ.getTimeStamp(time);
        }
        else {
            layer.msg('请选择要查询的时间.', {icon: 2, anim: 6});
            return false;
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        bindData(time, departmentId,companyId);
        layer.close(index);
    }

    //默认查询登录人
    bindData(new Date().getTime(), YZ.getUserInfo().departmentId,null);

    /**
     * 三维绩效总汇表
     * @param time 时间
     * @param timeType 1：周 2：月
     * @param companyId 公司id
     * @return
     */
    function bindData (time, departmentId,companyId) {
        var arr = {
            departmentId : departmentId,
            companyId : companyId,
            time : time
        }
        YZ.ajaxRequestData("post", false, YZ.ip + "/workDiary/queryWorkDiaryByTime", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {

                if (result.data.length == 0) {$(".notData").show(); $("#tbodyData").html(""); return false;}
                else {$(".notData").hide()};

                var dataList = result.data;
                var html = "";
                for (var i = 0; i < dataList.length; i++) {
                    var workDiarySubList = dataList[i].workDiarySubs;
                    var subHtml = "";
                    if (null != workDiarySubList) {
                        for (var j = 0; j < workDiarySubList.length; j++) {
                            var startTime = workDiarySubList[j].startTimeStr;
                            var endTIme = workDiarySubList[j].endTimeStr;
                            var startLeft = 0;
                            var endLeft = 0;
                            var titleWidth = Number($(".time").outerWidth()); // 获取td的宽度
                            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
                            if (userAgent.indexOf("Firefox") > -1) {
                                titleWidth = titleWidth - 1; //火狐减1
                            }
                            titleWidth = (titleWidth / 2); //获取一个方格的宽度
                            ///console.log(titleWidth);
                            startLeft = (titleWidth * (getCheckNumber(startTime) - 1)); //开始位置
                            endLeft = (titleWidth * (getCheckNumber(endTIme) - 1)); //结束位置
                            //console.log(startLeft + "       " + endLeft);
                            //console.log("width： " + (endLeft - startLeft));
                            startLeft = startLeft - 1;
                            var className = "span_" + workDiarySubList[j].id; //作为 tip 显示的ID
                            var date = new Date();
                            var temp = startTime.split(":");
                            date.setHours(temp[0]);
                            date.setMinutes(temp[1]);
                            var date1 = new Date();
                            var temp1 = endTIme.split(":");
                            date1.setHours(temp1[0]);
                            date1.setMinutes(temp1[1]);
                            var hours = Math.abs(new Date(workDiarySubList[j].endTime) - new Date(workDiarySubList[j].startTime))/1000/60/60;
                            hours = hours + ""
                            if (hours.length > 4) {
                                hours = Number(hours).toFixed(1);
                            }
                            //hours = hours + 1;
                            //console.log(hours);
                            subHtml +=  '<div class="context" style="left: ' + (startLeft) + 'px;width: ' + (Number(endLeft) - Number(startLeft)) + 'px;">' +
                                            '<span class="' + className + '" onmouseover="showContext(\'' + workDiarySubList[j].jobContent + '\',\'' + className + '\')" style="width: ' + ((Number(endLeft) - Number(startLeft) - 20)) + 'px;">' + workDiarySubList[j].jobContent + '</span>' +
                                            '<i class="totalTime">' + hours + 'h</i>' +
                                        '</div>';
                        }
                    }
                    html += '<tr>' +
                                '<td rowspan="2" class="userName">' + dataList[i].userName + '</td>' +
                                '<td class="relative">' +
                                subHtml +
                                '</td>' +
                                '<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>' +
                                '<td rowspan="2">' + dataList[i].studyTime + 'h</td>' +
                                '<td rowspan="2">' + dataList[i].sportTime + 'h</td>' +
                            '</tr>' +
                            '<tr>' +
                                '<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>' +
                            '</tr>'

                }
                $("#tbodyData").html(html);
            }
        });
    }

    function showContext(context, className) {
        layer.tips(context, '.' + className, {
            tips: [1, '#78BA32']
        });
    }

    //通过时间获取方格的数据量
    function getCheckNumber (time) {
        switch (time) {
            case "00:00" : return 51;break;
            case "00:30" : return 2;break;
            case "01:00" : return 3;break;
            case "01:30" : return 4;break;
            case "02:00" : return 5;break;
            case "02:30" : return 6;break;
            case "03:00" : return 7;break;
            case "03:30" : return 8;break;
            case "04:00" : return 9;break;
            case "04:30" : return 10;break;
            case "05:00" : return 11;break;
            case "05:30" : return 12;break;
            case "06:00" : return 13;break;
            case "06:30" : return 14;break;
            case "07:00" : return 15;break;
            case "07:30" : return 16;break;
            case "08:00" : return 17;break;
            case "08:30" : return 18;break;
            case "09:00" : return 19;break;
            case "09:30" : return 20;break;
            case "10:00" : return 21;break;
            case "10:30" : return 22;break;
            case "11:00" : return 23;break;
            case "11:30" : return 24;break;
            case "12:00" : return 25;break;
            case "12:30" : return 26;break;
            case "13:00" : return 27;break;
            case "13:30" : return 28;break;
            case "14:00" : return 29;break;
            case "14:30" : return 30;break;
            case "15:00" : return 31;break;
            case "15:30" : return 32;break;
            case "16:00" : return 33;break;
            case "16:30" : return 34;break;
            case "17:00" : return 35;break;
            case "17:30" : return 36;break;
            case "18:00" : return 37;break;
            case "18:30" : return 38;break;
            case "19:00" : return 39;break;
            case "19:30" : return 40;break;
            case "20:00" : return 41;break;
            case "20:30" : return 42;break;
            case "21:00" : return 43;break;
            case "21:30" : return 44;break;
            case "22:00" : return 45;break;
            case "22:30" : return 46;break;
            case "23:00" : return 47;break;
            case "23:30" : return 48;break;
            case "23:59" : return 49;break;
        }
    }

    //获取星期几
    function getWeek (number) {
        switch (number) {
            case 0 : return "星期天"; break;
            case 1 : return "星期一"; break;
            case 2 : return "星期二"; break;
            case 3 : return "星期三"; break;
            case 4 : return "星期四"; break;
            case 5 : return "星期五"; break;
            case 6 : return "星期六"; break;
        }
    }

    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        queryAllCompany(0,"companyId",null);
        form.render(); //重新渲染

        form.on('select(companyId)', function(data){
            queryDepartmentByCompany(0, "departmentId", null, Number(data.value), null);
            form.render('select');
        });

    });

    //生成图片
    function generateImages(event) {
        var index = layer.load(1, {shade: [0.5,'#000']});
        event.preventDefault();
        html2canvas(document.getElementById("dataTable"), {
            allowTaint: true,
            taintTest: false,
            onrendered: function(canvas) {
                canvas.id = "mycanvas";
                //生成base64图片数据
                var dataUrl = canvas.toDataURL();
                $("#downloadImg").attr("href", dataUrl);
                document.getElementById("downloadImg").click();
                $(".updateBtn").parent().show();
                $(".operation").show();
                layer.close(index);
            }
        });
    }

</script>
</body>
</html>
