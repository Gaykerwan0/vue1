package com.youlai.boot.system.model.query;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 部门查询对象
 *
 * @author haoxr
 * @since 2022/6/11
 */
@Schema(description ="部门分页查询对象")
@Data
public class DeptQuery {

    @Schema(description="关键字(部门名称)")
    private String keywords;

    @Schema(description="状态(1->正常；0->禁用)")
    private Integer status;

    @Schema(description="站点地址")
    private String address;

    @Schema(description="站点类型(水厂、水站、水点)")
    private String type;

    @Schema(description="销售提成比")
    private BigDecimal commissionRate;



}

