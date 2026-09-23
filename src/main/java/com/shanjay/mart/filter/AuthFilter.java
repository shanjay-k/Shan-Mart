package com.shanjay.mart.filter;
import javax.servlet.*;import javax.servlet.http.*;import java.io.IOException;
public class AuthFilter implements Filter {public void doFilter(ServletRequest req,ServletResponse res,FilterChain chain)throws IOException,ServletException{HttpServletRequest r=(HttpServletRequest)req;String p=r.getRequestURI();if(r.getSession(false)==null||r.getSession(false).getAttribute("user")==null){((HttpServletResponse)res).sendRedirect(r.getContextPath()+"/login");return;}chain.doFilter(req,res);}}
