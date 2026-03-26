package com.entity.vo;

import java.io.Serializable;

/**
 * 骑手
 * 手机端接口返回实体辅助类
 */
public class QishouVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String username;
    private String xingming;
    private String touxiang;
    private String phone;
    private String status;

    public void setUsername(String username) { this.username = username; }
    public String getUsername() { return username; }

    public void setXingming(String xingming) { this.xingming = xingming; }
    public String getXingming() { return xingming; }

    public void setTouxiang(String touxiang) { this.touxiang = touxiang; }
    public String getTouxiang() { return touxiang; }

    public void setPhone(String phone) { this.phone = phone; }
    public String getPhone() { return phone; }

    public void setStatus(String status) { this.status = status; }
    public String getStatus() { return status; }
}
