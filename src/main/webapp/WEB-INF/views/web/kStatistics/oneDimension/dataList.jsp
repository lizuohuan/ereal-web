<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>一维已发布数据</title>

    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend><span id="condition"></span>&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()" class="layui-btn layui-btn-small layui-btn-normal hide checkBtn_148"><i class="layui-icon">&#xe64a;</i> 图片已生成去上传</button>
                <button onclick="generateImages(event)" class="layui-btn layui-btn-small hide checkBtn_149"><i class="layui-icon">&#xe64a;</i> 生成图片</button>
                <button onclick="downLoad()" class="layui-btn layui-btn-small hide checkBtn_149"><i class="layui-icon">&#xe601;</i> 下载数据</button>
                <a id="downloadImg" download="0.png" class="layui-btn layui-btn-small hide">下载</a>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>公司名</th>
                        <th>部门名</th>
                        <th>员工名</th>
                        <th>k外</th>
                        <th>k内</th>
                        <th>k临时</th>
                        <th>k常规</th>
                        <th>k目标</th>
                        <th>k可比</th>
                        <th>k值完成率</th>
                        <th>k项目完成率</th>
                        <th class="operation">操作</th>
                    </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/html2canvas.js"></script>

<script>

    var msg = localStorage.getItem("oneCompanyName") + "-" + localStorage.getItem("oneTimeName") + "度-" + YZ.getUrlParam("time");
    $("#condition").html(msg);

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
                url: YZ.ip + "/kStatistics/queryPendingData",
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
                    /**
                     *  获取已确认，待审核的数据
                     * @param pageArgs 分页参数
                     * @param companyId 公司ID
                     * @param time 时间
                     * @param timeType 时间类型  1: 周数据  2：月数据  3：年数据
                     * @param veidooType 维度 类型 1：一维数据 2：二维数据 3：三维数据
                     * @return
                     */
                    data.companyId = YZ.getUrlParam("companyId");
                    data.timeType = YZ.getUrlParam("timeType");
                    data.time = YZ.getTimeStamp(YZ.getUrlParam("time"));
                    data.veidooType = 1;
                }
            },
            "columns": [
                { "data": "companyName" },
                { "data": "departmentName" },
                { "data": "userName" },
                { "data": "kw" },
                { "data": "kn" },
                { "data": "kl" },
                { "data": "kc" },
                { "data": "kmb" },
                { "data": "kkb" },
                { "data": "kwcl" },
                { "data": "kProjectSchedule" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "--";
                        else return data;
                    },
                    "targets": 2
                },
                {
                    "render": function(data, type, row) {
                        data = data + "";
                        if (data.indexOf(".") != -1) {
                            var nums = data.split(".");
                            if (nums[1].length > 9) {
                                nums[1] = nums[1].substring(0, 9);
                            }
                            return nums[0] + "." + nums[1];
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function(data, type, row) {
                        data = data + "";
                        if (data.indexOf(".") != -1) {
                            var nums = data.split(".");
                            if (nums[1].length > 9) {
                                nums[1] = nums[1].substring(0, 9);
                            }
                            return nums[0] + "." + nums[1];
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 4
                },
                {
                    "render": function(data, type, row) {
                        data = data + "";
                        if (data.indexOf(".") != -1) {
                            var nums = data.split(".");
                            if (nums[1].length > 9) {
                                nums[1] = nums[1].substring(0, 9);
                            }
                            return nums[0] + "." + nums[1];
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 5
                },
                {
                    "render": function(data, type, row) {
                        data = data + "";
                        if (data.indexOf(".") != -1) {
                            var nums = data.split(".");
                            if (nums[1].length > 9) {
                                nums[1] = nums[1].substring(0, 9);
                            }
                            return nums[0] + "." + nums[1];
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 6
                },
                {
                    "render": function(data, type, row) {
                        data = data == null ? 0 : data + "";
                        if (data.indexOf(".") != -1) {
                            var nums = data.split(".");
                            if (nums[1].length > 9) {
                                nums[1] = nums[1].substring(0, 9);
                            }
                            return nums[0] + "." + nums[1];
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 7
                },
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "0";
                        else {
                            data = data == null ? 0 : data + "";
                            if (data.indexOf(".") != -1) {
                                var nums = data.split(".");
                                if (nums[1].length > 9) {
                                    nums[1] = nums[1].substring(0, 9);
                                }
                                return nums[0] + "." + nums[1];
                            }
                            else {
                                return data;
                            }
                        };
                    },
                    "targets": 8
                },
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "0";
                        else {
                            data = data == null ? 0 : data + "";
                            if (data.indexOf(".") != -1) {
                                var nums = data.split(".");
                                if (nums[1].length > 9) {
                                    nums[1] = nums[1].substring(0, 9);
                                }
                                return nums[0] + "." + nums[1];
                            }
                            else {
                                return data;
                            }
                        };
                    },
                    "targets": 9
                },
                {
                    "render": function(data, type, row) {
                        if (data == "" || data == null) return "0";
                        else {
                            data = data == null ? 0 : data + "";
                            if (data.indexOf(".") != -1) {
                                var nums = data.split(".");
                                if (nums[1].length > 9) {
                                    nums[1] = nums[1].substring(0, 9);
                                }
                                return nums[0] + "." + nums[1];
                            }
                            else {
                                return data;
                            }
                        };
                    },
                    "targets": 10
                },
                {
                    "render": function(data, type, row) {
                        var object = JSON.stringify(row);
                        return "<button onclick='updateData(" + object + ")' class='updateBtn layui-btn layui-btn-small hide checkBtn_150'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                    },
                    "targets": 11
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

    function  downLoad(){
        window.open(YZ.ip + "/kStatistics/excel/downLoadPendingData?companyId="+YZ.getUrlParam("companyId")
                +"&timeType="+YZ.getUrlParam("timeType")+"&time="+YZ.getTimeStamp(YZ.getUrlParam("time"))+"&veidooType=1")
    }

    function addData () {
        var parameter = {
            companyId : YZ.getUrlParam("companyId"),
            timeType : YZ.getUrlParam("timeType"),
            time : YZ.getTimeStamp(YZ.getUrlParam("time")),
            veidooType : 1,
        }
        var dataList = [];
        YZ.ajaxRequestData("post", false, YZ.ip + "/kStatistics/queryPendingDataNoPage", parameter , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                dataList = result.data;
            }
        });
        if (dataList.length == 0) {
            layer.msg('没有可上传的数据.', {icon: 2, anim: 6});
            return false;
        }
        var ids = [];
        for (var i = 0; i < dataList.length; i++) {
            ids.push(dataList[i].id);
        }

        var index = layer.open({
            type: 2,
            title: '上传图片',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/banner/add?ids=" + ids.toString() + "&dimensionType=0&companyId=" + YZ.getUrlParam("companyId")
        });
        layer.full(index);
    }

    //修改
    function updateData (object) {
        localStorage.setItem("usersStatistics", JSON.stringify(object));
        var index = layer.open({
            type: 2,
            title: '修改已发布数据',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['400px', '500px'],
            content: YZ.ip + "/page/kStatistics/oneDimension/edit"
        });
        layer.full(index);
    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
    });

    //生成图片
    function generateImages(event) {
        var index = layer.load(1, {shade: [0.5,'#000']});
        $(".updateBtn").parent().hide();
        $(".operation").hide();
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
