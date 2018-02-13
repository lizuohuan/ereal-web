<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>破题统计</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .sum-time{font-size: 20px;font-weight: bold;margin-bottom: 10px;}
        .label-time{font-size: 16px;width: 600px;text-align: left;margin: 0 auto}
        .label-time p{margin-bottom: 10px;}
        .label-time p span{float: right;font-weight: bold;line-height: 25px;}

        .layui-progress-big, .layui-progress-big .layui-progress-bar{height: 40px;line-height: 40px;}
        .layui-progress{border-radius: 0px;}
        .layui-progress-bar{border-radius: 0px;}
        .layui-form-label{width: 60px;}
        .layui-input-block{margin-left: 90px;}
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
                            <label class="layui-form-label">开始时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="startTime" id="startTime" lay-verify="required" placeholder="开始时间" autocomplete="off" class="layui-input" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">结束时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="endTime" id="endTime" lay-verify="required" placeholder="结束时间" autocomplete="off" class="layui-input" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" type="button" lay-submit="" lay-filter="submit"><i class="layui-icon">&#xe615;</i> 搜索</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field"></button>
        <legend>破题比例&nbsp;</legend>
        <div class="layui-field-box layui-form text-center" id="totalsHtml">
            <h3 class="sum-time">项目总数：<span id="totals">--</span></h3>
            <div class="label-time">

                <div class="layui-block">
                    <label class="layui-form-label">全破：</label>
                    <div class="layui-input-block">
                        <div class="layui-progress layui-progress-big" lay-showpercent="true" lay-filter="demo">
                            <div class="layui-progress-bar layui-bg-red" lay-percent="0%"></div>
                        </div>
                    </div>
                </div>
                <div class="layui-block" style="margin-top: 15px;">
                    <label class="layui-form-label">半坡：</label>
                    <div class="layui-input-block">
                        <div class="layui-progress layui-progress-big" lay-showpercent="true" lay-filter="demo">
                            <div class="layui-progress-bar layui-bg-red" lay-percent="0%"></div>
                        </div>
                    </div>
                </div>
                <div class="layui-block" style="margin-top: 15px;">
                    <label class="layui-form-label">未破：</label>
                    <div class="layui-input-block">
                        <div class="layui-progress layui-progress-big" lay-showpercent="true" lay-filter="demo">
                            <div class="layui-progress-bar layui-bg-red" lay-percent="0%"></div>
                        </div>
                    </div>
                </div>

                <button class="layui-btn site-demo-active" data-type="setPercent">设置50%</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field"></button>
        <legend>破题统计列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <div id="water" style="width: 100%;height: 100%;min-height: 500px;"></div>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>

    window.onload = function () {
        var date = new Date();
        $("#startTime").val(date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate());
        $("#endTime").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
        bindData(YZ.getTimeStamp(date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate()), YZ.getTimeStamp(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()));
    }

    var waterChart = echarts.init(document.getElementById("water")); // 统计图对象
    var option = {} // 统计图配置

    function passingParameters () {
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if (startTime != "") {
            startTime = YZ.getTimeStamp(startTime);
        }
        else {
            layer.msg('请选择开始时间.', {icon: 2, anim: 6});
            return false;
        }
        if (endTime != "") {
            endTime = YZ.getTimeStamp(endTime);
        }
        else {
            layer.msg('请选择结束时间.', {icon: 2, anim: 6});
            return false;
        }

        var index = layer.load(1, {shade: [0.5,'#eee']});
        bindData(startTime, endTime);
        setTimeout(function () {layer.close(index);}, 600);
    }

    function bindData (startTime, endTime) {
        var allAry = new Array(); //此时间段全部项目
        var departmentNameAry = new Array(); //部门名数组
        var poAllAry = new Array(); //全破项目 数组
        var poHalfAry = new Array(); //半破项目 数组
        var poNoneAry = new Array(); //未破项目 数组

        var arr = {
            startTime : startTime, //开始时间
            endTime : endTime, //结束时间
        }
        var max = 0;
        YZ.ajaxRequestData("post", false, YZ.ip + "/project/getByTimeStatistics", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                allAry = result.data.allAry;
                departmentNameAry = result.data.departmentNameAry;
                poAllAry = result.data.poAllAry;
                poHalfAry = result.data.poHalfAry;
                poNoneAry = result.data.poNoneAry;

                //寻找最大的
                for (var i = 0; i < allAry.length; i++) {
                    if (allAry[i] > max) {
                        max = allAry[i];
                    }
                }
                max = YZ.getForTen(max);
                //封装数据
                waterChart.setOption(setToOption(departmentNameAry, poAllAry, poHalfAry, poNoneAry, allAry, max));
            }
        });
    }

    //设置图表数据
    function setToOption (departmentNameAry, poAllAry, poHalfAry, poNoneAry, allAry, max) {
        option = {
            title : {
                text: '破题数量统计表',
                x: 'center',
                y: 'top',
                padding: 5,
            },
            tooltip : {
                trigger: 'axis'
            },
            color: ["#F39996", "#8B95C9", "#EDB579", "#81CEF4"],
            legend: {
                orient: 'horizontal',
                x: 'center',
                y: '30px',
                data:['未破','半坡','全破','项目总数']
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
                    data : departmentNameAry
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
                        formatter : "{value}个", //添加左侧单位
                    },
                    max: max
                }
            ],
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: 30
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
                    name:'未破',
                    type:'bar',
                    data: poAllAry,
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                },
                {
                    name:'半坡',
                    type:'bar',
                    data: poHalfAry,
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                },
                {
                    name:'全破',
                    type:'bar',
                    data: poNoneAry,
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                },
                {
                    name:'项目总数',
                    type:'bar',
                    data: allAry,
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                }
            ]
        };

        return option;
    }

    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate,
                element = layui.element(); //Tab的切换功能，切换事件监听等，需要依赖element模块

        var date = new Date();
        var arr = {
            startTime : YZ.getTimeStamp(date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate()), //开始时间
            endTime : YZ.getTimeStamp(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()), //结束时间
        }
        YZ.ajaxRequestData("post", false, YZ.ip + "/project/getByTimeStatisticsData", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {

            }
        });

        var start = {
            max: laydate.now()
            , istoday: false
            , choose: function (datas) {
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            max: laydate.now()
            , istoday: false
            , choose: function (datas) {
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        document.getElementById('startTime').onclick = function () {
            start.elem = this;
            laydate(start);
        }
        document.getElementById('endTime').onclick = function () {
            end.elem = this;
            laydate(end);
        }

        $('.site-demo-active').on('click', function(){
            element.progress('demo', '50%');
        });

        form.render();

        //监听提交
        form.on('submit(submit)', function(data) {
            passingParameters();
            // TODO 对接破题比例 -- 进度条
            element.progress('demo', '50%');
            return false;
        });

    });

</script>
</body>
</html>
