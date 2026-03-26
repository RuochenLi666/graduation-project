package com.config;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

/**
 * 解决Tomcat停止时JDBC驱动未注销导致的内存泄漏问题
 */
@WebListener
public class JdbcDriverCleanupListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(JdbcDriverCleanupListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 应用启动时无需处理
        logger.info("Web应用启动，JDBC驱动清理监听器已初始化");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("开始清理JDBC驱动和相关线程，防止内存泄漏");
        
        // 1. 注销所有已注册的JDBC驱动
        try {
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                // 仅注销当前Web应用加载的驱动，避免影响其他应用
                if (driver.getClass().getClassLoader() == getClass().getClassLoader()) {
                    DriverManager.deregisterDriver(driver);
                    logger.info("成功注销JDBC驱动: {}", driver.getClass().getName());
                }
            }
        } catch (SQLException e) {
            logger.error("注销JDBC驱动失败", e);
        }

        // 2. 停止MySQL的废弃连接清理线程
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            logger.info("成功停止MySQL废弃连接清理线程");
        } catch (Exception e) {
            logger.error("停止MySQL废弃连接清理线程失败", e);
        }

        logger.info("JDBC驱动和相关线程清理完成");
    }
}