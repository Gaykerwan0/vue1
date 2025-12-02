package com.youlai.boot.system.model.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Range;

import java.math.BigDecimal;

@Schema(description = "部门表单对象")
@Getter
@Setter
public class DeptForm {

    @Schema(description="部门ID", example = "1001")
    private Long id;

    @Schema(description="部门名称", example = "研发部")
    private String name;

    @Schema(description="部门编号", example = "RD001")
    private String code;

    @Schema(description="父部门ID", example = "1000")
    @NotNull(message = "父部门ID不能为空")
    private Long parentId;

    @Schema(description="状态(1:启用;0:禁用)", example = "1")
    @Range(min = 0, max = 1, message = "状态值不正确")
    private Integer status;

    @Schema(description="排序(数字越小排名越靠前)", example = "1")
    private Integer sort;

    @Schema(description="站点地址信息", example = "北京市朝阳区某某街道1001号")
    private String address;

    @Schema(description="站点类型信息(水厂、水站、水点)", example = "水厂")
    private String type;

    @Schema(description="销售提成比(百分比形式)", example = "5.0")
    private BigDecimal commissionRate;

}
