package com.youlai.boot.products.model.entity;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import com.baomidou.mybatisplus.annotation.TableName;
import com.youlai.boot.common.base.BaseEntity;
import java.time.LocalDate;
/**
 * 商品供应实体对象
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Getter
@Setter
@TableName("biz_products")
public class BizProducts extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 商品名称（如：XX品牌 18.9L 桶装纯净水）
     */
    private String name;
    /**
     * 商品规格（如：18.9升/桶）
     */
    private String specification;
    /**
     * 产地
     */
    private String origin;
    /**
     * 生产日期
     */
    private LocalDate productionDate;
    /**
     * 保质日期
     */
    private LocalDate expirationDate;
    /**
     * 单价（元）
     */
    private BigDecimal unitPrice;
    /**
     * 商品详细介绍
     */
    private String description;
    /**
     * 商品预览图片的存储路径或URL
     */
    private String imagePreview;

    /**
     * 记录创建人
     */
    private Long createBy;
    /**
     * 记录最后修改人
     */
    private Long updateBy;
}
