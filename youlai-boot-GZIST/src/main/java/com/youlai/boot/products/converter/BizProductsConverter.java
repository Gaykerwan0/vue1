package com.youlai.boot.products.converter;

import org.mapstruct.Mapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.youlai.boot.products.model.entity.BizProducts;
import com.youlai.boot.products.model.form.BizProductsForm;

/**
 * 商品供应对象转换器
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Mapper(componentModel = "spring")
public interface BizProductsConverter{

    BizProductsForm toForm(BizProducts entity);

    BizProducts toEntity(BizProductsForm formData);
}