package com.entity;

import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import java.lang.reflect.InvocationTargetException;
import java.io.Serializable;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.beanutils.BeanUtils;

/**
 * 骑手
 * 数据库通用操作实体类
 */
@TableName("qishou")
public class QishouEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    public QishouEntity() {
    }

    public QishouEntity(Object t) {
        try {
            BeanUtils.copyProperties(this, t);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    /** 主键id */
    @TableId
    private Long id;

    /** 用户名 */
    private String username;

    /** 密码 */
    private String password;

    /** 姓名 */
    private String xingming;

    /** 头像 */
    private String touxiang;

    /** 手机号 */
    private String phone;

    /** 状态(空闲/配送中) */
    private String status;

    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat
    private Date addtime;

    public Date getAddtime() { return addtime; }
    public void setAddtime(Date addtime) { this.addtime = addtime; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public void setUsername(String username) { this.username = username; }
    public String getUsername() { return username; }

    public void setPassword(String password) { this.password = password; }
    public String getPassword() { return password; }

    public void setXingming(String xingming) { this.xingming = xingming; }
    public String getXingming() { return xingming; }

    public void setTouxiang(String touxiang) { this.touxiang = touxiang; }
    public String getTouxiang() { return touxiang; }

    public void setPhone(String phone) { this.phone = phone; }
    public String getPhone() { return phone; }

    public void setStatus(String status) { this.status = status; }
    public String getStatus() { return status; }
}
