import request from "@/utils/request";

const BIZPRODUCTS_BASE_URL = "/api/v1/biz-products";

const BizProductsAPI = {
  /** 获取商品供应分页数据 */
  getPage(queryParams?: BizProductsPageQuery) {
    // console.log("getPage", queryParams);
    return request<any, PageResult<BizProductsPageVO[]>>({
      url: `${BIZPRODUCTS_BASE_URL}/page`,
      method: "get",
      params: queryParams,
    });
  },
  /**
   * 获取商品供应表单数据
   *
   * @param id 商品供应ID
   * @returns 商品供应表单数据
   */
  getFormData(id: number) {
    return request<any, BizProductsForm>({
      url: `${BIZPRODUCTS_BASE_URL}/${id}/form`,
      method: "get",
    });
  },

  /**
   *  添加商品供应
   *
   *  @param data 商品供应表单数据
   */
  create(data: BizProductsForm) {
    return request({
      url: `${BIZPRODUCTS_BASE_URL}`,
      method: "post",
      data,
    });
  },

  /**
   * 更新商品供应
   *
   * @param id 商品供应ID
   * @param data 商品供应表单数据
   */
  update(id: string, data: BizProductsForm) {
    return request({
      url: `${BIZPRODUCTS_BASE_URL}/${id}`,
      method: "put",
      data,
    });
  },

  /**
   * 批量删除商品供应，多个以英文逗号(,)分割
   *
   * @param ids 商品供应ID字符串，多个以英文逗号(,)分割
   */
  deleteByIds(ids: string) {
    return request({
      url: `${BIZPRODUCTS_BASE_URL}/${ids}`,
      method: "delete",
    });
  },
};

export default BizProductsAPI;

/** 商品供应分页查询参数 */
export interface BizProductsPageQuery extends PageQuery {
  /** 搜索关键字 */
  name?: string;
}

/** 商品供应表单对象 */
export interface BizProductsForm {
  /** 商品唯一标识符 */
  id?: number;
  /** 商品名称（如：XX品牌 18.9L 桶装纯净水） */
  name?: string;
  /** 商品规格（如：18.9升/桶） */
  specification?: string;
  /** 产地 */
  origin?: string;
  /** 生产日期 */
  productionDate?: Date;
  /** 保质日期 */
  expirationDate?: Date;
  /** 单价（元） */
  unitPrice?: number;
  /** 商品详细介绍 */
  description?: string;
  /** 商品预览图片的存储路径或URL */
  imagePreview?: string;
  /** 记录创建时间 */
  createTime?: Date;
  /** 记录最后更新时间 */
  updateTime?: Date;
  /** 记录创建人 */
  createBy?: number;
  /** 记录最后修改人 */
  updateBy?: number;
}

/** 商品供应分页对象 */
export interface BizProductsPageVO {
  /** 商品唯一标识符 */
  id?: number;
  /** 商品名称（如：XX品牌 18.9L 桶装纯净水） */
  name?: string;
  /** 商品规格（如：18.9升/桶） */
  specification?: string;
  /** 产地 */
  origin?: string;
  /** 生产日期 */
  productionDate?: Date;
  /** 保质日期 */
  expirationDate?: Date;
  /** 单价（元） */
  unitPrice?: number;
  /** 商品详细介绍 */
  description?: string;
  /** 商品预览图片的存储路径或URL */
  imagePreview?: string;
  /** 记录创建时间 */
  createTime?: Date;
  /** 记录最后更新时间 */
  updateTime?: Date;
  /** 记录创建人 */
  createBy?: number;
  /** 记录最后修改人 */
  updateBy?: number;
}
