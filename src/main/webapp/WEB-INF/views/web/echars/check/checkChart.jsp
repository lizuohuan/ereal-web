<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>三维绩效考核得分</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .sum-date{font-size: 20px;font-weight: bold;margin-bottom: 10px;}
        .label-date{font-size: 16px;width: 400px;text-align: left;margin: 0 auto}
        .label-date p{margin-bottom: 10px;}
        .label-date p span{float: right;font-weight: bold;line-height: 25px;}

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
        <legend>三维绩效考核得分统计表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <div id="water" style="width: 100%;height: 100%;min-height: 500px;"></div>
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

    var waterChart = echarts.init(document.getElementById("water")); // 统计图对象
    var option = {} // 统计图配置

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
     * 后台个人K可比 统计
     * @param date 日期时间戳
     * @param userId 用户ID
     * @param departmentId  部门ID
     * @param companyId 分公司ID
     * @param timeType 1：周统计   2：月统计
     */
    function bindData (time, timeType, companyId) {
        var departmentNames = []; //部门名称
        var score = []; //分数
        var arr = {
            companyId : companyId,
            time : time,
            timeType : timeType
        }
        var max = 0; // 存放最大的
        YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/getCompanySta", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                departmentNames.push(result.data.departmentNames);
                score.push(result.data.score);
                //寻找最大的
                var temp = score[0];
                for (var i = 0; i < temp.length; i++) {
                    if (temp[i] > max) {
                        max = temp[i];
                    }
                }
                max = YZ.getForTen(max);
                waterChart.setOption(setToOption(departmentNames, score, "bar", max));
            }
        });
    }

    function setToOption(departmentNames, score, type, max) {
        console.log("*******************");
        console.log(departmentNames[0]);
        console.log(score[0]);

        console.log("*******************");
        departmentNames = departmentNames[0];
        score = score[0];
        option = {
            title : {
                text: '三维绩效考核得分统计表',
                x: 'center',
                y: 'top',
                padding: 5,
            },
            tooltip : {
                trigger: 'axis'
            },
            color: ["#8B95C9"],
            legend: {
                orient: 'horizontal',
                x: 'center',
                y: '30px',
                data:['三维绩效考核得分']
            },
            toolbox: {
                show : true,
                feature : {
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    axisTick: {
                        alignWithLabel: true
                    },
                    data : departmentNames
                }
            ],
            yAxis : [
                {
                    type: "value",
                    splitLine: {
                        show: false // y轴背景线条
                    },
                    "axisLine": {
                        show: true  // 左侧竖线线
                    },
                    axisTick: {
                        show: true  //刻度标识
                    },
                    splitArea: {
                        show: false //y轴背景颜色
                    },
                    axisLabel: {
                        formatter : "{value}", //添加左侧单位
                    },
                    max: max
                }
            ],
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: 50
            }, {
                start: 0,
                end: 10,
                handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                handleSize: '80%',
                handleStyle: {
                    color: '#FFF',
                    shadowBlur: 3,
                    shadowColor: 'rgba(0, 0, 0, 0.6)',
                    shadowOffsetX: 2,
                    shadowOffsetY: 2
                }
            }],
            series : [
                {
                    name:'三维绩效考核得分',
                    type: type,
                    data: score,
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                },
            ]
        };

        return option;
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
