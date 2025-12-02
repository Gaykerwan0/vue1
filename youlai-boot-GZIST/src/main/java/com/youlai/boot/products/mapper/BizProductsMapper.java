package com.youlai.boot.products.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.youlai.boot.products.model.entity.BizProducts;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.youlai.boot.products.model.query.BizProductsQuery;
import com.youlai.boot.products.model.vo.BizProductsVO;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品供应Mapper接口
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Mapper
public interface BizProductsMapper extends BaseMapper<BizProducts> {

    /**
     * 获取商品供应分页数据
     *
     * @param page 分页对象
     * @param queryParams 查询参数
     * @return {@link Page<BizProductsVO>} 商品供应分页列表
     */
    Page<BizProductsVO> getBizProductsPage(Page<BizProductsVO> page, BizProductsQuery queryParams);

}
