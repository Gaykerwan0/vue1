package com.youlai.boot.system.model.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.youlai.boot.common.base.BaseEntity;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 部门实体对象
 *
 * @author Ray.Hao
 * @since 2024/06/23
 */
@TableName("sys_dept")
@Getter
@Setter
public class Dept extends BaseEntity {

    /**
     * 部门名称
     */
    private String name;

    /**
     * 部门编码
     */
    private String code;

    /**
     * 父节点id
     */
    private Long parentId;

    /**
     * 父节点id路径
     */
    private String treePath;

    /**
     * 显示顺序
     */
    private Integer sort;

    /**
     * 状态(1-正常 0-禁用)
     */
    private Integer status;

    /**
     * 创建人 ID
     */
    private Long createBy;

    /**
     * 更新人 ID
     */
    private Long updateBy;

    /**
     * 是否删除(0-否 1-是)
     */
    private Integer isDeleted;

    /**
     * 站点地址信息
     */
    private String address;

    /**
     * 站点类型信息（关联字典管理，区分水厂、水站、水点）
     */
    private String type;

    /**
     * 销售提成比
     */
    private BigDecimal commissionRate;

}