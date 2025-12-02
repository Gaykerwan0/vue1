package com.youlai.boot.operation.model.query;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 销售统计查询参数
 */
@Getter
@Setter
public class SalesStatisticsQuery {

    @Schema(description = "商品ID")
    private Long productId;

    @Schema(description = "站点ID")
    private Long stationId;

    @Schema(description = "开始日期")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate startDate;

    @Schema(description = "结束日期")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate endDate;

    /**
     * 计算后的起始时间
     */
    private LocalDateTime startDateTime;

    /**
     * 计算后的截止时间
     */
    private LocalDateTime endDateTime;
}
