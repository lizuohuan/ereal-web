package com.magic.ereal.web.filter;

import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.controller.BaseController;
import net.sf.json.JSONObject;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by Administrator on 2017/7/4 0004.
 */
//@WebFilter("/*")
public class LoginFilter extends BaseController implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse)servletResponse;

        String requestURI = request.getRequestURI();

        Object currentUser = LoginHelper.getCurrentUser(request);

        if(requestURI.contains("excel")){
            filterChain.doFilter(request,response);
            return;
        }
        if(requestURI.contains("page") && !requestURI.contains("login")){
            // 如果是AJAX请求页面 返回未登录
            if (request.getHeader("x-requested-with") != null && request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")){ //如果是ajax请求响应头会有x-requested-with
                if(null == currentUser){
                    response.getWriter().print(JSONObject.fromObject(buildFailureJson(StatusConstant.NOTLOGIN,"未登录")));
                    return;
                }
            }
            filterChain.doFilter(request,response);
            return;
        }

        if(requestURI.contains("resources")){
            filterChain.doFilter(request,response);
            return;
        }

        if(null == currentUser && !requestURI.contains("login")){
            response.sendRedirect(request.getContextPath()+"/page/login");
           return;
        }

        filterChain.doFilter(request,response);
    }

    @Override
    public void destroy() {

    }
}
