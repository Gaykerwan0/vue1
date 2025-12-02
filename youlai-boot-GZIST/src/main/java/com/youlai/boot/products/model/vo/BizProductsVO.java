package com.youlai.boot.products.model.vo;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.time.LocalDate;
/**
 * 商品供应视图对象
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Getter
@Setter
@Schema( description = "商品供应视图对象")
public class BizProductsVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Schema(description = "商品唯一标识符")
    private Long id;
    @Schema(description = "商品名称（如：XX品牌 18.9L 桶装纯净水）")
    private String name;
    @Schema(description = "商品规格（如：18.9升/桶）")
    private String specification;
    @Schema(description = "产地")
    private String origin;
    @Schema(description = "生产日期")
    private LocalDate productionDate;
    @Schema(description = "保质日期")
    private LocalDate expirationDate;
    @Schema(description = "单价（元）")
    private BigDecimal unitPrice;
    @Schema(description = "商品详细介绍")
    private String description;
    @Schema(description = "商品预览图片的存储路径或URL")
    private String imagePreview;
    @Schema(description = "记录创建时间")
    private LocalDateTime createTime;
    @Schema(description = "记录最后更新时间")
    private LocalDateTime updateTime;
    @Schema(description = "记录创建人")
    private Long createBy;
    @Schema(description = "记录最后修改人")
    private Long updateBy;
}
