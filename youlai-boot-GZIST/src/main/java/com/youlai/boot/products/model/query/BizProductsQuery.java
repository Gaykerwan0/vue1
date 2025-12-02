package com.youlai.boot.products.model.query;

import com.youlai.boot.common.base.BasePageQuery;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.util.List;
import java.math.BigDecimal;

/**
 * 商品供应分页查询对象
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Schema(description ="商品供应查询对象")
@Getter
@Setter
public class BizProductsQuery extends BasePageQuery {
    @Schema(description="关键字(商品名称)")
    private String name;
}
