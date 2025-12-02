package com.youlai.boot.operation.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;

@Getter
@Setter
@Schema(description = "销售统计视图对象")
public class SalesStatisticsVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Schema(description = "库存记录ID")
    private Long repositoryId;

    @Schema(description = "商品ID")
    private Long productId;

    @Schema(description = "站点ID")
    private Long stationId;

    @Schema(description = "商品名称")
    private String productName;

    @Schema(description = "站点名称")
    private String stationName;

    @Schema(description = "库存数量")
    private Integer currentQuantity;

    @Schema(description = "订单数量")
    private Long orderCount;

    @Schema(description = "销售金额")
    private BigDecimal totalAmount;

    @Schema(description = "提成金额")
    private BigDecimal commissionAmount;

    @Schema(description = "提成比例")
    private BigDecimal commissionRate;

    @Schema(description = "统计时间范围")
    private String dateRange;
}
