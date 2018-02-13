<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common/jquery-2.1.0.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common/jquery.form.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/plugins/layui/layui.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/plugins/layui/lay/dest/layui.all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/angular.min.js"></script>
<%--<script type="text/javascript" src="<%=request.getContextPath()%>/resources/dataTable/js/jquery.dataTables.min.js"></script>--%>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/datatables/media/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/datatables/plugins/bootstrap/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/config.js"></script>
<!--时间控件-->
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/My97DatePicker/WdatePicker.js"></script>

<script>

    //打印登录人信息
    console.log(YZ.getUserInfo());
    /*if (YZ.getUserInfo() == null) {
        layer.alert("登录已失效，请重新登录.", {
            skin: 'layui-layer-lan'
            ,closeBtn: 0
            ,anim: 4 //动画类型
        },function () {
            location.href = YZ.ip + "/page/login";
        });
    }*/

    /*YZ.ajaxRequestData("get", false, YZ.ip + "/accredit/queryAccreditByToUser", {type : 2} , null , function(result) {
        if (result.flag == 0 && result.code == 200) {

        }
    });*/

    $(function () {
        $(".fa-refresh").click(function () {
            location.reload();
        });
        /*$(".fa-refresh").mouseover(function () {
            layer.tips('点击刷新', '.fa-refresh', {
                tips: [1, '#000101'], //还可配置颜色
                time: 2000
            });
        });*/

    });





    var company = null;

    /*
     *
     *  获取公司列表
     *
     * selectId 默认选中的选择器  默认不选择任何
     * targetName html设置的选择器 必选
     * isShow 上两父级 是否设置显示 1 显示 其他则不做处理
     * */
    function queryAllCompany (selectId,targetName,isShow) {
        if(null == targetName || targetName.length == 0){
            return;
        }
        if(null == company){
            YZ.ajaxRequestData("get", false, YZ.ip + "/company/listForWeb", {}, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    company = result.data;
                }
            });
        }
        var html = "<option value=\"\">选择或搜索公司</option>";
        for (var i = 0; i < company.length; i++) {
            if (company[i].id == selectId) {
                html += "<option selected=\"selected\" value=\"" + company[i].id + "\">" + company[i].companyName + "</option>";
            }
            else {
                html += "<option value=\"" + company[i].id + "\">" + company[i].companyName + "</option>";
            }
        }
        if (company.length == 0) {
            html += "<option value=\"0\" disabled>暂无</option>";
        }
        $("select[name='"+targetName+"']").html(html);
        if(1 == isShow){
            $("select[name='"+targetName+"']").parent().parent().show();
        }
    }





    /*
     *
     *  通过公司ID 获取部门列表
     *
     * selectId 默认选中的选择器  默认不选择任何
     * targetName html设置的选择器 必选
     * isShow 上两父级 是否设置显示 1 显示 其他则不做处理
     * companyId 公司ID
     * isProjectDepartment 查询部门类型  0：查询职能部门  1：查询项目部门 其他则 全部
     * */
    function queryDepartmentByCompany (selectId,targetName,isShow,companyId,isProjectDepartment) {
        if(null == targetName || targetName.length == 0){
            return;
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/queryDepartmentByCompany", {companyId : companyId,isProjectDepartment:isProjectDepartment }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    var showName = result.data[i].departmentName;
                    if(null != result.data[i].companyName && result.data[i].companyName != undefined){
                        showName += "("+result.data[i].companyName+")";
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + showName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + showName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='"+targetName+"']").html(html);
                if (1 == isShow) {
                    $("select[name='"+targetName+"']").parent().parent().show();
                }
            }
        });
    }


    /*
    *
    * 通过部门 查询用户
    *
    * selectId 默认选中的选择器  默认不选择任何
    * targetName html设置的选择器 必选
    * isShow 上两父级 是否设置显示 1 显示 其他则不做处理
    * companyId 公司ID
    * departmentId 部门ID 可选
    * roleId 角色ID  可选
    *
    * */
    function queryUserByDepartment(selectId,targetName,isShow,companyId,departmentId,roleId){

        var html = "";
        var arr = {
            departmentId : departmentId,
            companyId : companyId,
            roleId : roleId
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByItemsOfV2", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                // for (var i = 0; i < userList.length; i++) {
                //     if (userList[i].id == YZ.getUserInfo().id) {
                //         userList.splice(i,1); // 排除自己
                //     }
                // }
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='"+targetName+"']").html(html);
                if (1 == isShow) {
                    $("select[name='"+targetName+"']").parent().parent().show();
                }
            }
        });
    }









    /******************************************************************************************/
    /******************************************************************************************/
    /************************     以上 V2 版本 公共JS    ***************************************/
    /******************************************************************************************/
    /******************************************************************************************/


    //获取角色列表
    function getRoleList(type, selectId) {

        var arr = {};
        if(1 == type){
            arr = {
                type : type
            }
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/role/list", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索角色</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].roleName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].roleName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='roleId']").html(html);
                $("select[name='roleId']").parent().parent().show();
            }
        });
    }

    //获取角色列表
    function getRoleListType(type, selectId) {

        //type：0 所有角色  1常规角色
        if (type == 0) {
            type = null;
        }
        var arr = {
            type:type
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/role/list", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索角色</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].roleName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].roleName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='roleId']").html(html);
                $("select[name='roleId']").parent().parent().show();
            }
        });
    }

    //获取公司列表
    function getCompanyList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/company/listForWeb", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索公司</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" companyType=\""+result.data[i].type+"\" value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                    }
                    else {
                        html += "<option companyType=\""+result.data[i].type+"\" value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='companyId']").html(html);
                $("select[name='companyId']").parent().parent().show();
            }
        });
    }

    //获取公司列表
    function getCompanyListOfCTeacher (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/company/listForWeb", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索公司</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='directReportPersonUserIdCompanyId']").html(html);
                $("select[name='directReportPersonUserIdCompanyId']").parent().parent().show();
            }
        });
    }

    //获取公司列表
    function getCompanyListType (type,selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/company/listForWeb", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索公司</option>";

                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].type == type) {
                        if (result.data[i].id == selectId) {
                            html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                        }
                        else {
                            html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                        }
                    }
                    else if (type == null) {
                        if (result.data[i].id == selectId) {
                            html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                        }
                        else {
                            html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                        }
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='companyId']").html(html);
                $("select[name='companyId']").parent().parent().show();
            }
        });
    }

    //获取部门列表
    function getDepartmentList (companyId, type, selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getAllDepartmentByCompanyIdForWeb", {companyId : companyId, type : type}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='departmentId']").html(html);
                $("select[name='departmentId']").parent().parent().show();
            }
        });
    }

    //获取部门列表
    function getDepartmentListOfProject (companyId, type, selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getAllDepartmentByCompanyIdForWeb", {companyId : companyId, type : type}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='department']").html(html);
            }
        });
    }

    //获取部门列表
    function getDepartmentListOfCTeacher (companyId, type, selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getAllDepartmentByCompanyIdForWeb", {companyId : companyId, type : type}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='directReportPersonUserIdDepartment']").html(html);
            }
        });
    }

    //获取部门列表
    function getDepartmentListType (companyId, type, isProjectDepartment, selectId) {

        var arr = {
            companyId : companyId,
            type : null,
            isProjectDepartmentId : isProjectDepartment
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getAllDepartmentByCompanyIdForWeb", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='departmentId']").html(html);
                $("select[name='departmentId']").parent().parent().show();
            }
        });
    }

    //获取部门列表
    function getDepartmentForProject (companyId, isProject, projectId,selectId) {

        var arr = {
            companyId : companyId,
            isProject : isProject,
            projectId : projectId
        }
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getDepartmentByProject", arr, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='departmentId']").html(html);
                $("select[name='departmentId']").parent().parent().show();
            }
        });
    }

    //获取公司和部门列表
    function getAllDepartment (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getAllForWeb", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索公司和部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='departmentId']").html(html);
                $("select[name='departmentId']").parent().parent().show();
            }
        });
    }

    //获取公司下部门（下拉列表使用）（存在A导师的部门）
    function getAllForWebGroup (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/department/getAllForWebGroup", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索公司和部门</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" title=\"" + result.data[i].companyId + "\" companyId=\"" + result.data[i].companyId + "\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                    else {
                        html += "<option title=\"" + result.data[i].companyId + "\" companyId=\"" + result.data[i].companyId + "\" value=\"" + result.data[i].id + "\">" + result.data[i].departmentName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='departmentId']").html(html);
                $("select[name='departmentId']").parent().parent().show();
            }
        });
    }

    //获取事务类型列表
    function getTransactionList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/transactionSub/list", {isShow : 1}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择事务类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" transactionTypeName=\"" + result.data[i].transactionTypeName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].transactionSubName + "</option>";
                    }
                    else {
                        html += "<option transactionTypeName=\"" + result.data[i].transactionTypeName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].transactionSubName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='transactionSubId']").html(html);
                $("select[name='transactionSubId']").parent().parent().show();
            }
        });
    }

    //通过角色ID获取用户列表
    function getRoleUserList (roleId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByRole", {roleId : roleId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].name + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
            }
        });
        return html;
    }

    //通过部门ID获取用户列表 （排除自己的）
    function  getDepartmentIdUser (departmentId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/findUserPageForWeb", {departmentId : departmentId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                // for (var i = 0; i < userList.length; i++) {
                //     if (userList[i].id == YZ.getUserInfo().id) {
                //         userList.splice(i,1); // 排除自己
                //     }
                // }
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='userId']").html(html);
                $("select[name='userId']").parent().parent().show();
            }
        });
    }

    //通过部门ID获取用户列表 （排除自己的）
    function  getDepartmentIdUserOfProject (departmentId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/findUserPageForWeb", {departmentId : departmentId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                // for (var i = 0; i < userList.length; i++) {
                //     if (userList[i].id == YZ.getUserInfo().id) {
                //         userList.splice(i,1); // 排除自己
                //     }
                // }
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='allocationUserId']").html(html);
            }
        });
    }

    //通过部门ID获取用户列表 （排除自己的）
    function  getDepartmentIdUserOfProject2 (departmentId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/getUserByDepartment2", {departmentId : departmentId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                // for (var i = 0; i < userList.length; i++) {
                //     if (userList[i].id == YZ.getUserInfo().id) {
                //         userList.splice(i,1); // 排除自己
                //     }
                // }
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='allocationUserId']").html(html);
            }
        });
    }

    //通过部门ID获取用户列表 （排除自己的）
    function  getDepartmentIdUserOfCTeacher (departmentId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/findUserPageForWeb", {departmentId : departmentId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                // for (var i = 0; i < userList.length; i++) {
                //     if (userList[i].id == YZ.getUserInfo().id) {
                //         userList.splice(i,1); // 排除自己
                //     }
                // }
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='directReportPersonUserId']").html(html);
            }
        });
    }


    //通过部门ID获取用户列表
    function  getDepartmentIdUserOfCTeacher2 (departmentId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/getUserByDepartment2", {departmentId : departmentId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='directReportPersonUserId']").html(html);
            }
        });
    }

    //通过部门ID获取用户列表 （不排除自己的）
    function  getDepartmentIdUserNotExclude (departmentId, selectId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/findUserPageForWeb2", {departmentId : departmentId }, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var userList = result.data;
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < userList.length; i++) {
                    if (userList[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + userList[i].id + "\">" + userList[i].name + "</option>";
                    }
                }
                if (userList.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='userId']").html(html);
                $("select[name='userId']").parent().parent().show();
            }
        });
    }

    //通过角色ID获取用户列表之排查部门
    function getRoleDepartmentIdUserList (roleId, selectId, departmentId) {
        var html = "";
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/getCompanyIdRole", {roleId : roleId , departmentId : departmentId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                html = "<option value=\"\">选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].name + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
            }
        });
        return html;
    }

    //获取内部项目
    function getProjectInterior (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectInterior/getWorkDiaryProInterior", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索项目</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectId']").html(html);
                $("select[name='projectId']").parent().parent().show();
            }
        });
    }

    //获取外部项目
    function getProjectExternal (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/project/getWorkDiaryPro", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索项目</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].projectNameShort + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].projectNameShort + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectId']").html(html);
                $("select[name='projectId']").parent().parent().show();
            }
        });
    }

    //获取当前登录所在部门下面的所有员工
    function getDepartmentIdUserList (selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByCompany", {}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索员工</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].name + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='userId']").html(html);
                $("select[name='userId']").parent().parent().show();
            }
        });
    }

    //获取项目经理
    function getIsManager (departmentId, selectId) {
        YZ.ajaxRequestData("get", false, YZ.ip + "/projectGroup/queryProjectGroupManager", {departmentId : departmentId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">选择或搜索项目经理</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].projectManagerId + "\">" + result.data[i].userName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].projectManagerId + "\">" + result.data[i].userName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='projectManagerId']").html(html);
                $("select[name='projectManagerId']").parent().parent().show();
            }
        });
    }
    
    //遍历验证权限
    function checkJurisdiction () {
        var menuList = YZ.getLoginUserJurisdiction();
        for (var i = 0; i < menuList.length; i++) {
            var oneChild = menuList[i];
            for (var j = 0; j < oneChild.child.length; j++) {
                var twoChild = oneChild.child[j];
                for (var k = 0; k < twoChild.child.length; k++) {
                    var threeChild = twoChild.child[k];
                    for (var n = 0; n < threeChild.child.length; n++) {
                        var fourChild = threeChild.child[n];
                        $(".checkBtn_" + fourChild.id).show();
                    }
                    $(".checkBtn_" + threeChild.id).show();
                }
                $(".checkBtn_" + twoChild.id).show();
            }
        }
    }

    $(function () {
        checkJurisdiction();

        document.onkeydown = function(event) {
            var code;
            if (!event) {
                event = window.event; //针对ie浏览器
                code = event.keyCode;
                if (code == 13) {
                    if (document.getElementsByClassName("layui-layer-btn0").length > 0) {
                        document.getElementsByClassName("layui-layer-btn0")[0].click();
                    }
                    if (document.getElementById("unlock")) {
                        document.getElementById("unlock").click();
                    }
                }
            }
            else {
                code = event.keyCode;
                if (code == 13) {
                    if (document.getElementsByClassName("layui-layer-btn0").length > 0) {
                        document.getElementsByClassName("layui-layer-btn0")[0].click();
                    }
                    if (document.getElementById("unlock")) {
                        document.getElementById("unlock").click();
                    }
                }
            }
        };

        $(".layui-btn").blur();

    });

</script>