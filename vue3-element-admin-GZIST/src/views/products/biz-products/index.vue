<template>
  <div class="app-container h-full flex flex-1 flex-col">
    <!-- 搜索 -->
    <page-search
      ref="searchRef"
      :search-config="searchConfig"
      @query-click="handleQueryClick"
      @reset-click="handleResetClick"
    ></page-search>

    <!-- Ensure proper closing of page-content -->
    <page-content
      ref="contentRef"
      :content-config="contentConfig"
      @add-click="handleAddClick"
      @export-click="handleExportClick"
      @search-click="handleSearchClick"
      @toolbar-click="handleToolbarClick"
      @operate-click="handleOperateClick"
      @filter-change="handleFilterChange"
    >
      <!-- Custom column for description with modal popup -->
      <template #description="{ row }">
        <el-button v-if="row.description" type="primary" link @click="showDescriptionModal(row)">
          查看详情
        </el-button>
        <span v-else>-</span>
      </template>
    </page-content>

    <!-- Description Modal -->
    <el-dialog
      v-model="descriptionModalVisible"
      :title="currentRow?.name + ' - 详细信息'"
      width="500px"
    >
      <div v-if="currentRow">
        <p>
          <strong>商品名称:</strong>
          {{ currentRow.name }}
        </p>
        <p>
          <strong>商品规格:</strong>
          {{ currentRow.specification }}
        </p>
        <p>
          <strong>产地:</strong>
          {{ currentRow.origin }}
        </p>
        <p>
          <strong>生产日期:</strong>
          {{ currentRow.productionDate }}
        </p>
        <p>
          <strong>保质日期:</strong>
          {{ currentRow.expirationDate }}
        </p>
        <p>
          <strong>单价:</strong>
          {{ currentRow.unitPrice }} 元
        </p>
        <p>
          <strong>详细描述:</strong>
          {{ currentRow.description }}
        </p>
      </div>
      <template #footer>
        <el-button @click="descriptionModalVisible = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 新增 -->
    <page-modal
      ref="addModalRef"
      :modal-config="addModalConfig"
      @submit-click="handleSubmitClick"
    ></page-modal>

    <!-- 编辑 -->
    <page-modal
      ref="editModalRef"
      :modal-config="editModalConfig"
      @submit-click="handleSubmitClick"
    ></page-modal>
  </div>
</template>

<script setup lang="ts">
defineOptions({ name: "BizProducts" });

// Add these to your existing script setup
const descriptionModalVisible = ref(false);
const currentRow = ref<any>(null);

const showDescriptionModal = (row: any) => {
  currentRow.value = row;
  descriptionModalVisible.value = true;
};

import BizProductsAPI, {
  BizProductsForm,
  BizProductsPageQuery,
} from "@/api/products/biz-products-api";
import type { IObject, IModalConfig, IContentConfig, ISearchConfig } from "@/components/CURD/types";
import usePage from "@/components/CURD/usePage";

// 组合式 CRUD
const {
  searchRef,
  contentRef,
  addModalRef,
  editModalRef,
  handleQueryClick,
  handleResetClick,
  handleAddClick,
  handleEditClick,
  handleSubmitClick,
  handleExportClick,
  handleSearchClick,
  handleFilterChange,
} = usePage();

// 搜索配置
const searchConfig: ISearchConfig = reactive({
  permPrefix: "products:biz-products",
  formItems: [
    {
      tips: "支持模糊搜索",
      type: "input",
      label: "商品名称",
      prop: "name",
      attrs: {
        placeholder: "商品名称（如：XX品牌 18.9L 桶装纯净水）",
        clearable: true,
        style: { width: "400px" },
      },
    },
  ],
});

// 列表配置
const contentConfig: IContentConfig<BizProductsPageQuery> = reactive({
  // 权限前缀
  permPrefix: "products:biz-products",
  table: {
    border: true,
    highlightCurrentRow: true,
  },
  // 主键
  pk: "id",
  // 列表查询接口
  indexAction: BizProductsAPI.getPage,
  // 删除接口
  deleteAction: BizProductsAPI.deleteByIds,
  // 数据解析函数
  parseData(res: any) {
    return {
      total: res.total,
      list: res.list,
    };
  },
  // 分页配置
  pagination: {
    background: true,
    layout: "total, sizes, prev, pager, next, jumper",
    pageSize: 20,
    pageSizes: [10, 20, 30, 50],
  },
  // 工具栏配置
  toolbar: ["add", "delete"],
  defaultToolbar: ["refresh", "filter"],
  // 表格列配置
  cols: [
    { type: "selection", width: 55, align: "center" },
    { label: "商品唯一标识符", prop: "id", show: false },
    { label: "商品名称", prop: "name", slotName: "name" },
    { label: "商品规格", prop: "specification" },
    { label: "产地", prop: "origin" },
    { label: "生产日期", prop: "productionDate" },
    { label: "保质日期", prop: "expirationDate" },
    { label: "单价（元）", prop: "unitPrice" },
    { label: "详细信息", prop: "description", templet: "custom", show: false },
    { label: "预览存储路径", prop: "imagePreview", show: false },
    { label: "记录创建时间", prop: "createTime", show: false },
    { label: "记录最后更新时间", prop: "updateTime", show: false },
    { label: "记录创建人", prop: "createBy", show: false },
    { label: "记录最后修改人", prop: "updateBy", show: false },
    {
      label: "操作",
      prop: "operation",
      width: 220,
      templet: "tool",
      operat: ["edit", "delete", "view"],
    },
  ],
});

// 新增配置
const addModalConfig: IModalConfig<BizProductsForm> = reactive({
  // 权限前缀
  permPrefix: "products:biz-products",
  // 主键
  pk: "id",
  // 弹窗配置
  dialog: {
    title: "新增",
    width: 800,
    draggable: true,
  },
  form: {
    labelWidth: 100,
  },
  // 表单项配置
  formItems: [
    // {
    //   type: "input",
    //   attrs: {
    //     placeholder: "商品唯一标识符",
    //   },
    //   rules: [{ required: false, message: "商品唯一标识符不能为空", trigger: "blur" }],
    //   label: "商品唯一标识符",
    //   prop: "id",
    //   show: false,
    // },
    {
      type: "input",
      attrs: {
        placeholder: "商品名称（如：XX品牌 18.9L 桶装纯净水）",
      },
      rules: [
        {
          required: true,
          message: "商品名称（如：XX品牌 18.9L 桶装纯净水）不能为空",
          trigger: "blur",
        },
      ],
      label: "商品名称",
      prop: "name",
    },
    {
      type: "input",
      attrs: {
        placeholder: "商品规格（如：18.9升/桶）",
      },
      rules: [{ required: true, message: "商品规格（如：18.9升/桶）不能为空", trigger: "blur" }],
      label: "商品规格",
      prop: "specification",
    },
    {
      type: "input",
      attrs: {
        placeholder: "产地",
      },
      rules: [{ required: true, message: "产地不能为空", trigger: "blur" }],
      label: "产地",
      prop: "origin",
    },
    {
      type: "date-picker",
      attrs: {
        placeholder: "生产日期",
      },
      rules: [{ required: true, message: "生产日期不能为空", trigger: "blur" }],
      label: "生产日期",
      prop: "productionDate",
    },
    {
      type: "date-picker",
      attrs: {
        placeholder: "保质日期",
      },
      rules: [{ required: true, message: "保质日期不能为空", trigger: "blur" }],
      label: "保质日期",
      prop: "expirationDate",
    },
    {
      type: "input",
      attrs: {
        placeholder: "单价（元）",
      },
      rules: [{ required: true, message: "单价（元）不能为空", trigger: "blur" }],
      label: "单价（元）",
      prop: "unitPrice",
    },
    {
      type: "input",
      attrs: {
        placeholder: "商品详细介绍",
      },
      label: "商品详细介绍",
      prop: "description",
    },
    {
      type: "input",
      attrs: {
        placeholder: "商品预览图片的存储路径或URL",
      },
      label: "预览存储路径",
      prop: "imagePreview",
    },
    // {
    //   type: "date-picker",
    //   attrs: {
    //     placeholder: "记录创建时间",
    //   },
    //   rules: [{ required: false, message: "记录创建时间不能为空", trigger: "blur" }],
    //   label: "记录创建时间",
    //   prop: "createTime",
    // },
    // {
    //   type: "date-picker",
    //   attrs: {
    //     placeholder: "记录最后更新时间",
    //   },
    //   rules: [{ required: false, message: "记录最后更新时间不能为空", trigger: "blur" }],
    //   label: "记录最后更新时间",
    //   prop: "updateTime",
    // },
    // {
    //   type: "input",
    //   attrs: {
    //     placeholder: "记录创建人",
    //   },
    //   label: "记录创建人",
    //   prop: "createBy",
    // },
    // {
    //   type: "input",
    //   attrs: {
    //     placeholder: "记录最后修改人",
    //   },
    //   label: "记录最后修改人",
    //   prop: "updateBy",
    // },
  ],
  // 提交函数
  formAction: (data: BizProductsForm) => {
    console.log("formAction data:", data);
    if (data.id) {
      // 编辑
      return BizProductsAPI.update(data.id.toString(), data);
    } else {
      // 新增
      return BizProductsAPI.create(data);
    }
  },
});

// 编辑配置
const editModalConfig: IModalConfig<BizProductsForm> = reactive({
  permPrefix: "products:biz-products",
  component: "drawer",
  drawer: {
    title: "编辑",
    size: 500,
  },
  pk: "id",
  formAction(data: any) {
    // console.log("formAction data 11:", data);
    return BizProductsAPI.update(data.id as string, data);
  },
  formItems: addModalConfig.formItems, // 复用新增的表单项
});

// 处理操作按钮点击
const handleOperateClick = (data: IObject) => {
  if (data.name === "edit") {
    handleEditClick(data.row, async () => {
      return await BizProductsAPI.getFormData(data.row.id);
    });
  } else if (data.name === "view") {
    showDescriptionModal(data.row);
  }
};

// 处理工具栏按钮点击（删除等）
const handleToolbarClick = (name: string) => {
  console.log(name);
};
</script>
