package com.entity.view;

import com.entity.QishouEntity;
import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;
import java.io.Serializable;

/**
 * 骑手
 * 后端返回视图实体辅助类
 */
@TableName("qishou")
public class QishouView extends QishouEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    public QishouView() {
    }

    public QishouView(QishouEntity qishouEntity) {
        try {
            BeanUtils.copyProperties(this, qishouEntity);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }
}
