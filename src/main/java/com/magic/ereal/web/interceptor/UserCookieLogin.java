package com.magic.ereal.web.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.magic.ereal.business.entity.User;
import com.magic.ereal.business.service.UserService;

import com.magic.ereal.business.util.LoginHelper;
import com.magic.ereal.business.util.StatusConstant;
import com.magic.ereal.web.controller.BaseController;
import com.magic.ereal.web.util.ViewData;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;


/**
 * 用户登录拦截
 *
 */
@Component
public class UserCookieLogin extends BaseController implements HandlerInterceptor {

	private static final Logger logger = Logger.getLogger(UserCookieLogin.class);

	@Autowired
	private UserService userService;
	@Override
	public boolean preHandle(HttpServletRequest request,
							 HttpServletResponse response, Object handler) throws Exception {
		String requestURI = request.getRequestURI();
		User user = (User)LoginHelper.getCurrentUser(request);
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");



		String s = request.getServletPath();
		System.out.println(s);

		if(requestURI.contains("page")){
			// 如果请求页面 放行
			return true;
		}

		if(requestURI.contains("excel")){
			return true;
		}

		if (!requestURI.contains("login")) {
			if(null == user){
				response.getWriter().print(

						JSONObject.fromObject(buildFailureJson(StatusConstant.NOTLOGIN,"未登录"))
				);
//				response.sendRedirect(request.getContextPath()+"/page/login");
				return false;
			}
			//ajax请求
			if (request.getHeader("x-requested-with") != null && request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")){ //如果是ajax请求响应头会有x-requested-with
				if(null == user) {
//					response.sendRedirect(request.getContextPath()+"/web/page/login");
					response.getWriter().print(
							JSONObject.fromObject(buildFailureJson(StatusConstant.NOTLOGIN,"未登录"))
					);
					return false;
				}
				return true;
			}else{
				//非ajax请求时，session失效的处理
			}
		}


		//return true;
		if (requestURI.startsWith("/web")) {

			//web和app用户
		}

		return true;
	}
	@Override
	public void postHandle(HttpServletRequest request,
						   HttpServletResponse response, Object handler,
						   ModelAndView modelAndView) throws Exception {
	}
	@Override
	public void afterCompletion(HttpServletRequest request,
								HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

	protected void writeJsonToResponse(HttpServletResponse response, String responseJson) {
		try {
			response.setContentType("text/html;charset=UTF-8");
			OutputStream os = response.getOutputStream();
			os.write(responseJson.getBytes("UTF-8"));
			os.flush();
			os.close();
		} catch (Exception exp) {
			logger.error("error writing response, message=" + exp.getMessage(), exp);
		}
	}
}





