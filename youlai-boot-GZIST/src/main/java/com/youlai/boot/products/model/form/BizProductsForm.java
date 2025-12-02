package com.youlai.boot.products.model.form;

import java.io.Serial;
import java.io.Serializable;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import jakarta.validation.constraints.*;
import java.time.LocalDate;

/**
 * 商品供应表单对象
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Getter
@Setter
@Schema(description = "商品供应表单对象")
public class BizProductsForm implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Schema(description = "商品唯一标识符")
//    @NotNull(message = "商品唯一标识符不能为空")
    private Long id;

    @Schema(description = "商品名称（如：XX品牌 18.9L 桶装纯净水）")
    @NotBlank(message = "商品名称（如：XX品牌 18.9L 桶装纯净水）不能为空")
    @Size(max=255, message="商品名称（如：XX品牌 18.9L 桶装纯净水）长度不能超过255个字符")
    private String name;

    @Schema(description = "商品规格（如：18.9升/桶）")
    @NotBlank(message = "商品规格（如：18.9升/桶）不能为空")
    @Size(max=100, message="商品规格（如：18.9升/桶）长度不能超过100个字符")
    private String specification;

    @Schema(description = "产地")
    @NotBlank(message = "产地不能为空")
    @Size(max=100, message="产地长度不能超过100个字符")
    private String origin;

    @Schema(description = "生产日期")
    @NotNull(message = "生产日期不能为空")
    private LocalDate productionDate;

    @Schema(description = "保质日期")
    @NotNull(message = "保质日期不能为空")
    private LocalDate expirationDate;

    @Schema(description = "单价（元）")
    @NotNull(message = "单价（元）不能为空")
    private BigDecimal unitPrice;

    @Schema(description = "商品详细介绍")
    @Size(max=65535, message="商品详细介绍长度不能超过65535个字符")
    private String description;

    @Schema(description = "商品预览图片的存储路径或URL")
    @Size(max=500, message="商品预览图片的存储路径或URL长度不能超过500个字符")
    private String imagePreview;

    @Schema(description = "记录创建时间")
//    @NotNull(message = "记录创建时间不能为空")
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    @Schema(description = "记录最后更新时间")
//    @NotNull(message = "记录最后更新时间不能为空")
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;

    @Schema(description = "记录创建人")
    private Long createBy;

    @Schema(description = "记录最后修改人")
    private Long updateBy;


}
