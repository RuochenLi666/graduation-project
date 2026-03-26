package com.controller;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Map;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.annotation.IgnoreAuth;

import com.entity.QishouEntity;
import com.entity.OrdersEntity;
import com.entity.view.QishouView;

import com.service.QishouService;
import com.service.OrdersService;
import com.service.TokenService;
import com.utils.PageUtils;
import com.utils.R;
import com.utils.MPUtil;

/**
 * 骑手
 * 后端接口
 */
@RestController
@RequestMapping("/qishou")
public class QishouController {

    @Autowired
    private QishouService qishouService;

    @Autowired
    private OrdersService ordersService;

    @Autowired
    private TokenService tokenService;

    /**
     * 骑手登录
     */
    @IgnoreAuth
    @RequestMapping(value = "/login")
    public R login(String username, String password, HttpServletRequest request) {
        QishouEntity user = qishouService.selectOne(new EntityWrapper<QishouEntity>().eq("username", username));
        if (user == null || !user.getPassword().equals(password)) {
            return R.error("账号或密码不正确");
        }
        String token = tokenService.generateToken(user.getId(), username, "qishou", "骑手");
        return R.ok().put("token", token);
    }

    /**
     * 注册
     */
    @IgnoreAuth
    @RequestMapping("/register")
    public R register(@RequestBody QishouEntity qishou) {
        QishouEntity user = qishouService.selectOne(new EntityWrapper<QishouEntity>().eq("username", qishou.getUsername()));
        if (user != null) {
            return R.error("注册用户已存在");
        }
        qishou.setId(new Date().getTime());
        if (qishou.getStatus() == null) {
            qishou.setStatus("空闲");
        }
        qishouService.insert(qishou);
        return R.ok();
    }

    /**
     * 退出
     */
    @RequestMapping("/logout")
    public R logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return R.ok("退出成功");
    }

    /**
     * 获取当前骑手session信息
     */
    @RequestMapping("/session")
    public R getCurrUser(HttpServletRequest request) {
        Long id = (Long) request.getSession().getAttribute("userId");
        QishouEntity user = qishouService.selectById(id);
        return R.ok().put("data", user);
    }

    /**
     * 后端列表
     */
    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, QishouEntity qishou,
                  HttpServletRequest request) {
        EntityWrapper<QishouEntity> ew = new EntityWrapper<QishouEntity>();
        PageUtils page = qishouService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, qishou), params), params));
        return R.ok().put("data", page);
    }

    /**
     * 前端列表
     */
    @IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, QishouEntity qishou,
                  HttpServletRequest request) {
        EntityWrapper<QishouEntity> ew = new EntityWrapper<QishouEntity>();
        PageUtils page = qishouService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, qishou), params), params));
        return R.ok().put("data", page);
    }

    /**
     * 全部列表（用于下拉选骑手）
     */
    @RequestMapping("/lists")
    public R lists(QishouEntity qishou) {
        EntityWrapper<QishouEntity> ew = new EntityWrapper<QishouEntity>();
        ew.allEq(MPUtil.allEQMapPre(qishou, "qishou"));
        return R.ok().put("data", qishouService.selectListView(ew));
    }

    /**
     * 后端详情
     */
    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        QishouEntity qishou = qishouService.selectById(id);
        return R.ok().put("data", qishou);
    }

    /**
     * 前端详情
     */
    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id) {
        QishouEntity qishou = qishouService.selectById(id);
        return R.ok().put("data", qishou);
    }

    /**
     * 后端保存（管理员添加骑手）
     */
    @RequestMapping("/save")
    public R save(@RequestBody QishouEntity qishou, HttpServletRequest request) {
        QishouEntity user = qishouService.selectOne(new EntityWrapper<QishouEntity>().eq("username", qishou.getUsername()));
        if (user != null) {
            return R.error("用户名已存在");
        }
        qishou.setId(new Date().getTime() + (long)Math.floor(Math.random() * 1000));
        if (qishou.getStatus() == null) {
            qishou.setStatus("空闲");
        }
        qishouService.insert(qishou);
        return R.ok();
    }

    /**
     * 修改
     */
    @RequestMapping("/update")
    public R update(@RequestBody QishouEntity qishou, HttpServletRequest request) {
        qishouService.updateById(qishou);
        return R.ok();
    }

    /**
     * 删除
     */
    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids) {
        qishouService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    /**
     * 骑手更新配送状态（配送中 / 已送达）
     */
    @RequestMapping("/updateDeliveryStatus")
    public R updateDeliveryStatus(@RequestParam Long orderId,
                                   @RequestParam String peisongstatus,
                                   HttpServletRequest request) {
        OrdersEntity orders = ordersService.selectById(orderId);
        if (orders == null) {
            return R.error("订单不存在");
        }
        // 验证是否为当前骑手的订单
        String role = request.getSession().getAttribute("role") != null
                ? request.getSession().getAttribute("role").toString() : "";
        if ("骑手".equals(role)) {
            Long userId = (Long) request.getSession().getAttribute("userId");
            if (!userId.equals(orders.getQishouid())) {
                return R.error("无权操作此订单");
            }
        }
        orders.setPeisongstatus(peisongstatus);
        // 如果已送达，将骑手状态改回空闲
        if ("已送达".equals(peisongstatus)) {
            QishouEntity qishou = qishouService.selectById(orders.getQishouid());
            if (qishou != null) {
                qishou.setStatus("空闲");
                qishouService.updateById(qishou);
            }
        }
        ordersService.updateById(orders);
        return R.ok("配送状态已更新");
    }

    /**
     * 骑手查看自己的配送订单列表
     */
    @RequestMapping("/myOrders")
    public R myOrders(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        Long userId = (Long) request.getSession().getAttribute("userId");
        String role = request.getSession().getAttribute("role") != null
                ? request.getSession().getAttribute("role").toString() : "";
        EntityWrapper<OrdersEntity> ew = new EntityWrapper<OrdersEntity>();
        if ("骑手".equals(role)) {
            ew.eq("qishouid", userId);
        }
        PageUtils page = ordersService.queryPage(params, ew);
        return R.ok().put("data", page);
    }
}
