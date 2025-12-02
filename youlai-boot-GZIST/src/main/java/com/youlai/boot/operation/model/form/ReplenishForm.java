package com.youlai.boot.operation.model.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "库存补货表单")
public class ReplenishForm {

    @Schema(description = "库存记录ID")
    @NotNull(message = "库存记录ID不能为空")
    private Long repositoryId;

    @Schema(description = "补货数量")
    @NotNull(message = "补货数量不能为空")
    @Min(value = 1, message = "补货数量必须大于0")
    private Integer quantity;
}
