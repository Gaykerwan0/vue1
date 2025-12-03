package com.youlai.boot.operation.model.form;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StockAdjustForm {

    @NotNull(message = "商品不能为空")
    private Long productId;

    @NotNull(message = "站点不能为空")
    private Long stationId;

    @NotNull(message = "库存数量不能为空")
    @Min(value = 0, message = "库存数量不能小于0")
    private Integer quantity;
}
