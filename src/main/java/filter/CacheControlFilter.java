package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CacheControlFilter implements Filter {
    private int cacheTime = 3600; // 1 hour in seconds

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String cacheTimeParam = filterConfig.getInitParameter("cacheTime");
        if (cacheTimeParam != null) {
            cacheTime = Integer.parseInt(cacheTimeParam);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setHeader("Cache-Control", "public, max-age=" + cacheTime);
        chain.doFilter(request, response);
    }
}