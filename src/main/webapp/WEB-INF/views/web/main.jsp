<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <!--引入抽取css文件-->
    <%@include file="common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/main.css" />
    <style>
        .col-xs-5{float: left; width: 50%;}
        .honorImg{width: 150px;height: 250px;}
        .kUserName{font-size: 16px;font-weight: bold;position: relative;margin-top: -52px;margin-left: 15px;}
    </style>
</head>
<body>
<div class="admin-main">
    <blockquote class="layui-elem-quote">
        <div class="widget">
            <div class="row" id="rowDiv">
                <div class="col-xs-12 weather">
                    <iframe allowtransparency="true"
                            frameborder="0" width="575"
                            height="96" scrolling="no"
                            src="//tianqi.2345.com/plugin/widget/index.htm?s=2&z=1&t=0&v=0&d=5&bd=0&k=000000&f=000000&q=1&e=1&a=1&c=54511&w=575&h=96&align=center"></iframe>
                </div>
            </div>
        </div>
    </blockquote>

    <%--<div class="col-xs-5">
        <fieldset class="layui-elem-field">
            <legend>月度K王</legend>
            <div class="layui-field-box">
                <div style="width: 100%;height: 100%;min-height: 600px;text-align: center">
                    &lt;%&ndash;<img class="honorImg" src="<%=request.getContextPath()%>/resources/img/1.png" alt="">
                    <img class="honorImg" src="<%=request.getContextPath()%>/resources/img/2.png" alt="">
                    <img class="honorImg" src="<%=request.getContextPath()%>/resources/img/3.png" alt="">
                    <img class="honorImg" src="<%=request.getContextPath()%>/resources/img/4.png" alt="">&ndash;%&gt;
                    <img src="<%=request.getContextPath()%>/resources/img/2.png">
                    <div class="kUserName">--</div>
                </div>
            </div>
        </fieldset>
    </div>--%>
    <div class="col-xs-5">
        <fieldset class="layui-elem-field">
            <legend>本月公司总K值</legend>
            <div class="layui-field-box">
                <div id="companyWater" style="width: 100%;height: 100%;min-height: 600px;"></div>
            </div>
        </fieldset>
    </div>

    <div class="col-xs-5">
        <fieldset class="layui-elem-field">
            <legend>本月团队总K值</legend>
            <div class="layui-field-box">
                <div id="departmentWater" style="width: 100%;height: 100%;min-height: 600px;"></div>
            </div>
        </fieldset>
    </div>
</div>

<!--引入抽取公共js-->
<%@include file="common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>
<script>
    var companyWater = echarts.init(document.getElementById("companyWater")); // 公司
    var departmentWater = echarts.init(document.getElementById("departmentWater")); // 部门
    var option = {} // 统计图配置

    initData ();

    function initData () {

        YZ.ajaxRequestData("get", false, YZ.ip + "/statistics/homeKStatistics", {} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var companyData = result.data.companyData;
                var departmentData = result.data.departmentData;
                if (companyData == null || companyData == undefined || companyData == "") {
                    companyWater.setOption(setToOption(0, 0, 0, 0, 0, 0));
                }
                else {
                    var kExterior = companyData.kExterior == null ? 0 : Number(companyData.kExterior).toFixed(2); // K外
                    var kInterior = companyData.kInterior == null ? 0 : Number(companyData.kInterior).toFixed(2); // K内
                    var kGeneral = companyData.kGeneral == null ? 0 : Number(companyData.kGeneral).toFixed(2); // K常规
                    var kTemp = companyData.kTemp == null ? 0 : Number(companyData.kTemp).toFixed(2); // K临时
                    var kFinishRate = companyData.kFinishRate == null ? 0 : parseInt(companyData.kFinishRate); // K完成率
                    var totalK = (Number(kExterior) + Number(kInterior) + Number(kGeneral) + Number(kTemp)).toFixed(2);
                    companyWater.setOption(setToOption(kExterior, kInterior, kGeneral, kTemp, kFinishRate, totalK));
                }
                if (departmentData == null || departmentData == undefined || departmentData == "") {
                    departmentWater.setOption(setToOption(0, 0, 0, 0, 0, 0));
                }
                else {
                    //部门的
                    kExterior = departmentData.kExterior == null ? 0 : Number(departmentData.kExterior).toFixed(2); // K外
                    kInterior = departmentData.kInterior == null ? 0 : Number(departmentData.kInterior).toFixed(2); // K内
                    kGeneral = departmentData.kGeneral == null ? 0 : Number(departmentData.kGeneral).toFixed(2); // K常规
                    kTemp = departmentData.kTemp == null ? 0 : Number(departmentData.kTemp).toFixed(2); // K临时
                    kFinishRate = departmentData.kFinishRate == null ? 0 : parseInt(departmentData.kFinishRate); // K完成率
                    totalK = (Number(kExterior) + Number(kInterior) + Number(kGeneral) + Number(kTemp)).toFixed(2);
                    departmentWater.setOption(setToOption(kExterior, kInterior, kGeneral, kTemp, kFinishRate, totalK));
                }
            }
        });

    }

    //设置图表数据
    function setToOption (kExterior, kInterior, kGeneral, kTemp, kFinishRate, totalK) {
        option = {
            title: {
                text: '本月总K值：' + totalK + "K",
                subtext: 'K外目标完成率：' + kFinishRate + "%",
                x: 'center',
                y: 'center',
                textStyle: {
                    fontWeight: 'normal',
                    fontSize: 16
                }
            },
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: 'right',
                y: 'center',
                data: ['K临时','K常规','K内','K外']
            },
            series : [
                {
                    color: ['#FFBF63', '#FB7A72', '#67C3E9', '#4BC792'],
                    name: '当前',
                    type: 'pie',
                    radius: ['50%', '70%'],
                    /*center: ['60%', '80%'],*/
                    data:[
                        {value:kTemp, name:'K临时'},
                        {value:kGeneral, name:'K常规'},
                        {value:kInterior, name:'K内'},
                        {value:kExterior, name:'K外'},
                    ],
                    itemStyle:{
                        normal:{
                            label:{
                                show: true,
                                formatter: '{b} : {c} ({d}%)'
                            },
                            labelLine :{show:true}
                        }
                    }
                }
            ]
        };

        return option;
    }

    //theKingOfMonthly ();
    //获取月度K王
    function theKingOfMonthly () {
        YZ.ajaxRequestData("get", false, YZ.ip + "/statistics/staticsMaxK", {month : new Date()} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $(".kUserName").html(result.data.name);
            }
        });
    }
</script>
</body>
</html>
