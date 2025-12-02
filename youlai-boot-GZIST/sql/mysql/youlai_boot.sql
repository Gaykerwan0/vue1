/*
 Navicat Premium Data Transfer

 Source Server         : mysql8
 Source Server Type    : MySQL
 Source Server Version : 80036 (8.0.36)
 Source Host           : localhost:3306
 Source Schema         : youlai_boot

 Target Server Type    : MySQL
 Target Server Version : 80036 (8.0.36)
 File Encoding         : 65001

 Date: 02/12/2025 14:24:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for biz_orders
-- ----------------------------
DROP TABLE IF EXISTS `biz_orders`;
CREATE TABLE `biz_orders`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单唯一标识符',
  `repo_id` int UNSIGNED NOT NULL COMMENT '站点ID，外键关联部门表',
  `user_id` int UNSIGNED NOT NULL COMMENT '用户ID，外键关联用户表',
  `quantity` int UNSIGNED NOT NULL COMMENT '购买数量',
  `unit_price` decimal(10, 2) UNSIGNED NOT NULL COMMENT '商品单价（下单时价格）',
  `total_amount` decimal(10, 2) UNSIGNED NOT NULL COMMENT '订单总金额',
  `delivery_fee` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '配送费用',
  `order_date` datetime NOT NULL COMMENT '订单日期（下单时间）',
  `delivery_date` datetime NULL DEFAULT NULL COMMENT '配送/自提日期',
  `delivery_type` enum('self_pickup','home_delivery') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'self_pickup' COMMENT '配送方式：自提/送货上门',
  `delivery_time_slot` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配送时段',
  `payment_method` enum('wechat','alipay','cash','balance') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'wechat' COMMENT '支付方式',
  `payment_status` enum('pending','paid','failed','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '支付状态',
  `order_status` enum('pending','confirmed','preparing','delivering','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '订单状态',
  `delivery_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配送地址',
  `customer_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '客户备注',
  `create_by` int UNSIGNED NOT NULL COMMENT '记录创建人（用户ID）',
  `create_time` timestamp NOT NULL DEFAULT (now()) COMMENT '记录创建时间',
  `update_by` int UNSIGNED NULL DEFAULT NULL COMMENT '记录最后修改人',
  `update_time` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_department`(`repo_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_date`(`order_date` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `idx_payment_status`(`payment_status` ASC) USING BTREE,
  INDEX `idx_created_by`(`create_by` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_orders
-- ----------------------------

-- ----------------------------
-- Table structure for biz_products
-- ----------------------------
DROP TABLE IF EXISTS `biz_products`;
CREATE TABLE `biz_products`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商品唯一标识符',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称（如：XX品牌 18.9L 桶装纯净水）',
  `specification` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品规格（如：18.9升/桶）',
  `origin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产地',
  `production_date` date NOT NULL COMMENT '生产日期',
  `expiration_date` date NOT NULL COMMENT '保质日期',
  `unit_price` decimal(10, 2) UNSIGNED NOT NULL COMMENT '单价（元）',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品详细介绍',
  `image_preview` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品预览图片的存储路径或URL',
  `create_time` timestamp NOT NULL DEFAULT (now()) COMMENT '记录创建时间',
  `update_time` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '记录创建人',
  `update_by` bigint NULL DEFAULT NULL COMMENT '记录最后修改人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_origin`(`origin` ASC) USING BTREE,
  INDEX `idx_expiration`(`expiration_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品信息表（用于管理水产品）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_products
-- ----------------------------
INSERT INTO `biz_products` VALUES (3, '200L水', '200L/桶', '中国', '2025-11-03', '2025-12-16', 100.00, '纯水', '', '2025-12-02 11:16:57', '2025-12-02 11:16:57', NULL, NULL);
INSERT INTO `biz_products` VALUES (4, '豆包', '45kg/个', '中国', '2024-12-02', '2026-12-13', 0.01, 'rubbish', '', '2025-12-02 11:18:27', '2025-12-02 11:18:27', NULL, NULL);

-- ----------------------------
-- Table structure for biz_repository
-- ----------------------------
DROP TABLE IF EXISTS `biz_repository`;
CREATE TABLE `biz_repository`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '关系记录唯一标识符',
  `department_id` bigint UNSIGNED NOT NULL COMMENT '部门ID，外键关联部门表',
  `product_id` bigint UNSIGNED NOT NULL COMMENT '产品ID，外键关联产品表',
  `current_quantity` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '当前库存数量',
  `order_quantity_total` int UNSIGNED NULL DEFAULT 0 COMMENT '累计订购数量',
  `order_date_latest` datetime NULL DEFAULT NULL COMMENT '最近订购日期',
  `create_time` timestamp NOT NULL DEFAULT (now()) COMMENT '记录创建时间',
  `update_time` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
  `create_by` bigint NULL DEFAULT NULL,
  `update_by` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_department_product`(`department_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `idx_department`(`department_id` ASC) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  INDEX `idx_stock_level`(`current_quantity` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门产品库存与订购关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_repository
-- ----------------------------

-- ----------------------------
-- Table structure for gen_config
-- ----------------------------
DROP TABLE IF EXISTS `gen_config`;
CREATE TABLE `gen_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名',
  `module_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模块名',
  `package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '包名',
  `business_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务名',
  `entity_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实体类名',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '作者',
  `parent_menu_id` bigint NULL DEFAULT NULL COMMENT '上级菜单ID，对应sys_menu的id ',
  `remove_table_prefix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '要移除的表前缀，如: sys_',
  `page_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '页面类型(classic|curd)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tablename`(`table_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成基础配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_config
-- ----------------------------

-- ----------------------------
-- Table structure for gen_field_config
-- ----------------------------
DROP TABLE IF EXISTS `gen_field_config`;
CREATE TABLE `gen_field_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_id` bigint NOT NULL COMMENT '关联的配置ID',
  `column_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `column_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `column_length` int NULL DEFAULT NULL,
  `field_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字段名称',
  `field_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段类型',
  `field_sort` int NULL DEFAULT NULL COMMENT '字段排序',
  `field_comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段描述',
  `max_length` int NULL DEFAULT NULL,
  `is_required` tinyint(1) NULL DEFAULT NULL COMMENT '是否必填',
  `is_show_in_list` tinyint(1) NULL DEFAULT 0 COMMENT '是否在列表显示',
  `is_show_in_form` tinyint(1) NULL DEFAULT 0 COMMENT '是否在表单显示',
  `is_show_in_query` tinyint(1) NULL DEFAULT 0 COMMENT '是否在查询条件显示',
  `query_type` tinyint NULL DEFAULT NULL COMMENT '查询方式',
  `form_type` tinyint NULL DEFAULT NULL COMMENT '表单类型',
  `dict_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典类型',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `config_id`(`config_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成字段配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_field_config
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名称',
  `config_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置key',
  `config_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除标识(0-未删除 1-已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '系统限流QPS', 'IP_QPS_THRESHOLD_LIMIT', '10', '单个IP请求的最大每秒查询数（QPS）阈值Key', '2025-11-24 15:32:02', 1, NULL, NULL, 0);

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门编号',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父节点id',
  `tree_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '父节点id路径',
  `sort` smallint NULL DEFAULT 0 COMMENT '显示顺序',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(1-正常 0-禁用)',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '修改人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint NULL DEFAULT 0 COMMENT '逻辑删除标识(1-已删除 0-未删除)',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '站点详细地址',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '站点类型：WATER_PLANT=水厂, WATER_STATION=水站, WATER_POINT=水点',
  `commission_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '销售提成比例（0-100之间的百分比值）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE COMMENT '部门编号唯一索引'
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (1, '茶棚水厂', 'YOULAI', 0, '0', 1, 1, 1, NULL, 1, '2025-12-01 14:31:16', 0, '广州', 'waterPlant', 12.00);
INSERT INTO `sys_dept` VALUES (2, '临城易道路', 'RD001', 1, '0,1', 1, 1, 2, NULL, 2, '2025-12-01 14:41:38', 0, '深圳', 'waterStation', 4.00);
INSERT INTO `sys_dept` VALUES (3, '联合街道', 'QA001', 1, '0,1', 1, 1, 2, NULL, 2, '2025-12-01 14:41:55', 0, '深圳', 'waterPoint', 1.00);
INSERT INTO `sys_dept` VALUES (8, '哈哈哈', '111111', 3, '0,1,3', 1, 1, 2, '2025-12-01 10:16:55', 2, '2025-12-01 10:17:25', 1, '广州', 'waterStation', 3.00);
INSERT INTO `sys_dept` VALUES (9, '临城易', '111', 2, '0,1,2', 1, 1, 2, '2025-12-01 14:47:32', NULL, '2025-12-01 14:50:26', 0, '东莞', 'waterPoint', 0.00);

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `dict_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型编码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型名称',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态(0:正常;1:禁用)',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '修改人ID',
  `is_deleted` tinyint NULL DEFAULT 0 COMMENT '是否删除(1-删除，0-未删除)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dict_code`(`dict_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (1, 'gender', '性别', 1, NULL, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1, 0);
INSERT INTO `sys_dict` VALUES (2, 'notice_type', '通知类型', 1, NULL, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1, 0);
INSERT INTO `sys_dict` VALUES (3, 'notice_level', '通知级别', 1, NULL, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1, 0);
INSERT INTO `sys_dict` VALUES (4, '1', '水厂', 1, NULL, '2025-12-02 14:03:58', NULL, '2025-12-02 14:03:58', NULL, 0);

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_item`;
CREATE TABLE `sys_dict_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联字典编码，与sys_dict表中的dict_code对应',
  `value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典项值',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典项标签',
  `tag_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签类型，用于前端样式展示（如success、warning等）',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态（1-正常，0-禁用）',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '修改人ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典项表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_item
-- ----------------------------
INSERT INTO `sys_dict_item` VALUES (1, 'gender', '1', '男', 'primary', 1, 1, NULL, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (2, 'gender', '2', '女', 'danger', 1, 2, NULL, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (3, 'gender', '0', '保密', 'info', 1, 3, NULL, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (4, 'notice_type', '1', '系统升级', 'success', 1, 1, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (5, 'notice_type', '2', '系统维护', 'primary', 1, 2, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (6, 'notice_type', '3', '安全警告', 'danger', 1, 3, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (7, 'notice_type', '4', '假期通知', 'success', 1, 4, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (8, 'notice_type', '5', '公司新闻', 'primary', 1, 5, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (9, 'notice_type', '99', '其他', 'info', 1, 99, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (10, 'notice_level', 'L', '低', 'info', 1, 1, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (11, 'notice_level', 'M', '中', 'warning', 1, 2, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);
INSERT INTO `sys_dict_item` VALUES (12, 'notice_level', 'H', '高', 'danger', 1, 3, '', '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 1);

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日志模块',
  `request_method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求方式',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求参数(批量请求参数可能会超过text)',
  `response_content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '返回参数',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日志内容',
  `request_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求路径',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '方法名',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `province` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '城市',
  `execution_time` bigint NULL DEFAULT NULL COMMENT '执行时间(ms)',
  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器',
  `browser_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器版本',
  `os` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '终端系统',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` tinyint NULL DEFAULT 0 COMMENT '逻辑删除标识(1-已删除 0-未删除)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 646 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES (1, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 2087, 'MSEdge', '141.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-11-24 15:39:59', 0);
INSERT INTO `sys_log` VALUES (2, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 401, 'MSEdge', '141.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-11-25 09:59:27', 0);
INSERT INTO `sys_log` VALUES (3, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 144, 'MSEdge', '141.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-11-25 10:10:02', 0);
INSERT INTO `sys_log` VALUES (4, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 163, 'MSEdge', '141.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-11-25 10:10:03', 0);
INSERT INTO `sys_log` VALUES (5, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 174, 'MSEdge', '141.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-11-25 10:10:57', 0);
INSERT INTO `sys_log` VALUES (6, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 381, 'MSEdge', '141.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-11-26 16:24:06', 0);
INSERT INTO `sys_log` VALUES (7, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 2573, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 09:25:28', 0);
INSERT INTO `sys_log` VALUES (8, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 51, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:25:28', 0);
INSERT INTO `sys_log` VALUES (9, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 34, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:26:07', 0);
INSERT INTO `sys_log` VALUES (10, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:26:42', 0);
INSERT INTO `sys_log` VALUES (11, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:26:44', 0);
INSERT INTO `sys_log` VALUES (12, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:26:57', 0);
INSERT INTO `sys_log` VALUES (13, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:26:58', 0);
INSERT INTO `sys_log` VALUES (14, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:29:00', 0);
INSERT INTO `sys_log` VALUES (15, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 09:29:00', 0);
INSERT INTO `sys_log` VALUES (16, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 40, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:26:05', 0);
INSERT INTO `sys_log` VALUES (17, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:26:06', 0);
INSERT INTO `sys_log` VALUES (18, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 3283, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 10:40:21', 0);
INSERT INTO `sys_log` VALUES (19, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 79, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:40:21', 0);
INSERT INTO `sys_log` VALUES (20, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 1686, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:41:30', 0);
INSERT INTO `sys_log` VALUES (21, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:41:41', 0);
INSERT INTO `sys_log` VALUES (22, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:41:41', 0);
INSERT INTO `sys_log` VALUES (23, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:42:43', 0);
INSERT INTO `sys_log` VALUES (24, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:42:44', 0);
INSERT INTO `sys_log` VALUES (25, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:43:02', 0);
INSERT INTO `sys_log` VALUES (26, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:43:02', 0);
INSERT INTO `sys_log` VALUES (27, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:43:12', 0);
INSERT INTO `sys_log` VALUES (28, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:43:13', 0);
INSERT INTO `sys_log` VALUES (29, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:43:28', 0);
INSERT INTO `sys_log` VALUES (30, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:43:28', 0);
INSERT INTO `sys_log` VALUES (31, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:52:45', 0);
INSERT INTO `sys_log` VALUES (32, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 10:52:57', 0);
INSERT INTO `sys_log` VALUES (33, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:02:52', 0);
INSERT INTO `sys_log` VALUES (34, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:02:52', 0);
INSERT INTO `sys_log` VALUES (35, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 1633, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 11:04:59', 0);
INSERT INTO `sys_log` VALUES (36, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 36, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:04:59', 0);
INSERT INTO `sys_log` VALUES (37, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 1163, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:05:21', 0);
INSERT INTO `sys_log` VALUES (38, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 1508, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 11:10:45', 0);
INSERT INTO `sys_log` VALUES (39, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 38, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:10:46', 0);
INSERT INTO `sys_log` VALUES (40, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:10:49', 0);
INSERT INTO `sys_log` VALUES (41, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:10:54', 0);
INSERT INTO `sys_log` VALUES (42, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:10:54', 0);
INSERT INTO `sys_log` VALUES (43, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:12:03', 0);
INSERT INTO `sys_log` VALUES (44, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:12:03', 0);
INSERT INTO `sys_log` VALUES (45, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 63, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:14:22', 0);
INSERT INTO `sys_log` VALUES (46, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:14:45', 0);
INSERT INTO `sys_log` VALUES (47, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:14:48', 0);
INSERT INTO `sys_log` VALUES (48, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:14:49', 0);
INSERT INTO `sys_log` VALUES (49, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:19:08', 0);
INSERT INTO `sys_log` VALUES (50, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:19:09', 0);
INSERT INTO `sys_log` VALUES (51, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:19:44', 0);
INSERT INTO `sys_log` VALUES (52, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:19:44', 0);
INSERT INTO `sys_log` VALUES (53, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:20:36', 0);
INSERT INTO `sys_log` VALUES (54, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:20:37', 0);
INSERT INTO `sys_log` VALUES (55, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:21:53', 0);
INSERT INTO `sys_log` VALUES (56, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:21:53', 0);
INSERT INTO `sys_log` VALUES (57, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:22:33', 0);
INSERT INTO `sys_log` VALUES (58, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:22:34', 0);
INSERT INTO `sys_log` VALUES (59, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 2421, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 11:26:11', 0);
INSERT INTO `sys_log` VALUES (60, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 38, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:26:11', 0);
INSERT INTO `sys_log` VALUES (61, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:26:14', 0);
INSERT INTO `sys_log` VALUES (62, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:26:18', 0);
INSERT INTO `sys_log` VALUES (63, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:26:21', 0);
INSERT INTO `sys_log` VALUES (64, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:26:48', 0);
INSERT INTO `sys_log` VALUES (65, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:27:10', 0);
INSERT INTO `sys_log` VALUES (66, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:27:13', 0);
INSERT INTO `sys_log` VALUES (67, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:27:14', 0);
INSERT INTO `sys_log` VALUES (68, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 43, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:30:02', 0);
INSERT INTO `sys_log` VALUES (69, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 22, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:30:24', 0);
INSERT INTO `sys_log` VALUES (70, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:50:48', 0);
INSERT INTO `sys_log` VALUES (71, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 11:50:49', 0);
INSERT INTO `sys_log` VALUES (72, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 13:21:35', 0);
INSERT INTO `sys_log` VALUES (73, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.157.1', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 13:21:36', 0);
INSERT INTO `sys_log` VALUES (74, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 13:22:44', 0);
INSERT INTO `sys_log` VALUES (75, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.157.1', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 13:22:45', 0);
INSERT INTO `sys_log` VALUES (76, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 13:46:33', 0);
INSERT INTO `sys_log` VALUES (77, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.163.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 13:46:34', 0);
INSERT INTO `sys_log` VALUES (78, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 44, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:21:03', 0);
INSERT INTO `sys_log` VALUES (79, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:21:03', 0);
INSERT INTO `sys_log` VALUES (80, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:21:31', 0);
INSERT INTO `sys_log` VALUES (81, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.118.129', '0', '内网IP', 77, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:21:47', 0);
INSERT INTO `sys_log` VALUES (82, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 39, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:22:06', 0);
INSERT INTO `sys_log` VALUES (83, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 69, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:22:15', 0);
INSERT INTO `sys_log` VALUES (84, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.118.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:23:02', 0);
INSERT INTO `sys_log` VALUES (85, 'SETTING', 'GET', '{\"keywords\":\"\",\"pageNum\":1,\"pageSize\":10}', NULL, '系统配置分页列表', '/api/v1/config/page', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:23:06', 0);
INSERT INTO `sys_log` VALUES (86, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 27, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:23:08', 0);
INSERT INTO `sys_log` VALUES (87, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:23:32', 0);
INSERT INTO `sys_log` VALUES (88, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:26:20', 0);
INSERT INTO `sys_log` VALUES (89, 'ROLE', 'GET', '{\"pageNum\":2,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 26, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:26:27', 0);
INSERT INTO `sys_log` VALUES (90, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:26:29', 0);
INSERT INTO `sys_log` VALUES (91, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 28, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:27:18', 0);
INSERT INTO `sys_log` VALUES (92, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:29:41', 0);
INSERT INTO `sys_log` VALUES (93, 'USER', 'GET', '{\"deptId\":2,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 35, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:31:11', 0);
INSERT INTO `sys_log` VALUES (94, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:32:03', 0);
INSERT INTO `sys_log` VALUES (95, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 14:36:32', 0);
INSERT INTO `sys_log` VALUES (96, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 15:03:28', 0);
INSERT INTO `sys_log` VALUES (97, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 15:03:30', 0);
INSERT INTO `sys_log` VALUES (98, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 314, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 15:37:08', 0);
INSERT INTO `sys_log` VALUES (99, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 15:37:34', 0);
INSERT INTO `sys_log` VALUES (100, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:06:11', 0);
INSERT INTO `sys_log` VALUES (101, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:06:11', 0);
INSERT INTO `sys_log` VALUES (102, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 41, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:07:39', 0);
INSERT INTO `sys_log` VALUES (103, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:08:01', 0);
INSERT INTO `sys_log` VALUES (104, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:08:14', 0);
INSERT INTO `sys_log` VALUES (105, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:09:13', 0);
INSERT INTO `sys_log` VALUES (106, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:09:13', 0);
INSERT INTO `sys_log` VALUES (107, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:21:19', 0);
INSERT INTO `sys_log` VALUES (108, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:21:20', 0);
INSERT INTO `sys_log` VALUES (109, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:21:24', 0);
INSERT INTO `sys_log` VALUES (110, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:28:40', 0);
INSERT INTO `sys_log` VALUES (111, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:28:40', 0);
INSERT INTO `sys_log` VALUES (112, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 2035, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 16:47:23', 0);
INSERT INTO `sys_log` VALUES (113, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 57, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:47:23', 0);
INSERT INTO `sys_log` VALUES (114, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 1549, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 16:47:47', 0);
INSERT INTO `sys_log` VALUES (115, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.129', '0', '内网IP', 3564, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-28 17:16:46', 0);
INSERT INTO `sys_log` VALUES (116, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 170, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:16:47', 0);
INSERT INTO `sys_log` VALUES (117, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 64, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:16:52', 0);
INSERT INTO `sys_log` VALUES (118, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 143, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:35:52', 0);
INSERT INTO `sys_log` VALUES (119, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 39, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:35:54', 0);
INSERT INTO `sys_log` VALUES (120, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 231, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:36:31', 0);
INSERT INTO `sys_log` VALUES (121, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 26, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:37:18', 0);
INSERT INTO `sys_log` VALUES (122, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:37:56', 0);
INSERT INTO `sys_log` VALUES (123, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:37:56', 0);
INSERT INTO `sys_log` VALUES (124, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 76, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:40:45', 0);
INSERT INTO `sys_log` VALUES (125, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 31, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:41:22', 0);
INSERT INTO `sys_log` VALUES (126, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 20, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:41:38', 0);
INSERT INTO `sys_log` VALUES (127, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:41:39', 0);
INSERT INTO `sys_log` VALUES (128, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 61, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:45:05', 0);
INSERT INTO `sys_log` VALUES (129, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:45:05', 0);
INSERT INTO `sys_log` VALUES (130, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 46, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:45:26', 0);
INSERT INTO `sys_log` VALUES (131, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:45:31', 0);
INSERT INTO `sys_log` VALUES (132, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 23, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:47:43', 0);
INSERT INTO `sys_log` VALUES (133, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:47:44', 0);
INSERT INTO `sys_log` VALUES (134, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:49:43', 0);
INSERT INTO `sys_log` VALUES (135, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:49:44', 0);
INSERT INTO `sys_log` VALUES (136, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:50:59', 0);
INSERT INTO `sys_log` VALUES (137, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:50:59', 0);
INSERT INTO `sys_log` VALUES (138, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 67, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:54:11', 0);
INSERT INTO `sys_log` VALUES (139, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:54:35', 0);
INSERT INTO `sys_log` VALUES (140, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:54:39', 0);
INSERT INTO `sys_log` VALUES (141, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:54:40', 0);
INSERT INTO `sys_log` VALUES (142, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:59:30', 0);
INSERT INTO `sys_log` VALUES (143, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 17:59:30', 0);
INSERT INTO `sys_log` VALUES (144, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:00:01', 0);
INSERT INTO `sys_log` VALUES (145, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:00:02', 0);
INSERT INTO `sys_log` VALUES (146, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 63, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:05:07', 0);
INSERT INTO `sys_log` VALUES (147, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:05:30', 0);
INSERT INTO `sys_log` VALUES (148, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:05:34', 0);
INSERT INTO `sys_log` VALUES (149, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:05:34', 0);
INSERT INTO `sys_log` VALUES (150, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 28, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:08:14', 0);
INSERT INTO `sys_log` VALUES (151, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:08:33', 0);
INSERT INTO `sys_log` VALUES (152, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.157.1', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:08:59', 0);
INSERT INTO `sys_log` VALUES (153, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:09:37', 0);
INSERT INTO `sys_log` VALUES (154, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.157.1', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-28 18:09:38', 0);
INSERT INTO `sys_log` VALUES (155, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 67, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-29 23:35:19', 0);
INSERT INTO `sys_log` VALUES (156, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.157.1', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-29 23:35:19', 0);
INSERT INTO `sys_log` VALUES (157, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-29 23:44:40', 0);
INSERT INTO `sys_log` VALUES (158, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-29 23:44:41', 0);
INSERT INTO `sys_log` VALUES (159, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 603, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:00:41', 0);
INSERT INTO `sys_log` VALUES (160, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:00:42', 0);
INSERT INTO `sys_log` VALUES (161, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 1342, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-11-30 01:42:37', 0);
INSERT INTO `sys_log` VALUES (162, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 27, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:42:37', 0);
INSERT INTO `sys_log` VALUES (163, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 68, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:42:58', 0);
INSERT INTO `sys_log` VALUES (164, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:43:01', 0);
INSERT INTO `sys_log` VALUES (165, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:46:35', 0);
INSERT INTO `sys_log` VALUES (166, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:47:12', 0);
INSERT INTO `sys_log` VALUES (167, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:55:00', 0);
INSERT INTO `sys_log` VALUES (168, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:55:01', 0);
INSERT INTO `sys_log` VALUES (169, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 32, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:55:56', 0);
INSERT INTO `sys_log` VALUES (170, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 01:56:10', 0);
INSERT INTO `sys_log` VALUES (171, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 02:01:23', 0);
INSERT INTO `sys_log` VALUES (172, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 02:03:41', 0);
INSERT INTO `sys_log` VALUES (173, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.157.1', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-11-30 02:03:42', 0);
INSERT INTO `sys_log` VALUES (174, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 56, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:00', 0);
INSERT INTO `sys_log` VALUES (175, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:00', 0);
INSERT INTO `sys_log` VALUES (176, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 64, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:22', 0);
INSERT INTO `sys_log` VALUES (177, 'USER', 'GET', '{\"deptId\":2,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 91, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:30', 0);
INSERT INTO `sys_log` VALUES (178, 'USER', 'GET', '{\"deptId\":2,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:31', 0);
INSERT INTO `sys_log` VALUES (179, 'USER', 'GET', '{\"deptId\":3,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 46, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:32', 0);
INSERT INTO `sys_log` VALUES (180, 'USER', 'GET', '{\"deptId\":1,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.129', '0', '内网IP', 26, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:34', 0);
INSERT INTO `sys_log` VALUES (181, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:42', 0);
INSERT INTO `sys_log` VALUES (182, 'ROLE', 'GET', '{\"pageNum\":2,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:53', 0);
INSERT INTO `sys_log` VALUES (183, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.129', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:32:56', 0);
INSERT INTO `sys_log` VALUES (184, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 48, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:33:24', 0);
INSERT INTO `sys_log` VALUES (185, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 63, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:38:22', 0);
INSERT INTO `sys_log` VALUES (186, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:39:05', 0);
INSERT INTO `sys_log` VALUES (187, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:39:33', 0);
INSERT INTO `sys_log` VALUES (188, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:39:40', 0);
INSERT INTO `sys_log` VALUES (189, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:39:40', 0);
INSERT INTO `sys_log` VALUES (190, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:40:03', 0);
INSERT INTO `sys_log` VALUES (191, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:40:36', 0);
INSERT INTO `sys_log` VALUES (192, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:40:39', 0);
INSERT INTO `sys_log` VALUES (193, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:40:39', 0);
INSERT INTO `sys_log` VALUES (194, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 08:40:52', 0);
INSERT INTO `sys_log` VALUES (195, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.118.129', '0', '内网IP', 67, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:07:04', 0);
INSERT INTO `sys_log` VALUES (196, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 46, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:27:04', 0);
INSERT INTO `sys_log` VALUES (197, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 20, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:27:21', 0);
INSERT INTO `sys_log` VALUES (198, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:27:56', 0);
INSERT INTO `sys_log` VALUES (199, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.129', '0', '内网IP', 34, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:29:26', 0);
INSERT INTO `sys_log` VALUES (200, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:29:27', 0);
INSERT INTO `sys_log` VALUES (201, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:29:46', 0);
INSERT INTO `sys_log` VALUES (202, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.129', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:29:54', 0);
INSERT INTO `sys_log` VALUES (203, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:35:19', 0);
INSERT INTO `sys_log` VALUES (204, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.163.129', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:35:20', 0);
INSERT INTO `sys_log` VALUES (205, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:36:15', 0);
INSERT INTO `sys_log` VALUES (206, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.163.129', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:36:16', 0);
INSERT INTO `sys_log` VALUES (207, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:41:24', 0);
INSERT INTO `sys_log` VALUES (208, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:42:10', 0);
INSERT INTO `sys_log` VALUES (209, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:42:19', 0);
INSERT INTO `sys_log` VALUES (210, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 59, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:43:37', 0);
INSERT INTO `sys_log` VALUES (211, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:13', 0);
INSERT INTO `sys_log` VALUES (212, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.163.129', '0', '内网IP', 61, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:14', 0);
INSERT INTO `sys_log` VALUES (213, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:19', 0);
INSERT INTO `sys_log` VALUES (214, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:23', 0);
INSERT INTO `sys_log` VALUES (215, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:27', 0);
INSERT INTO `sys_log` VALUES (216, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:30', 0);
INSERT INTO `sys_log` VALUES (217, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:37', 0);
INSERT INTO `sys_log` VALUES (218, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.163.129', '0', '内网IP', 33, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:38', 0);
INSERT INTO `sys_log` VALUES (219, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.163.129', '0', '内网IP', 44, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:41', 0);
INSERT INTO `sys_log` VALUES (220, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.163.129', '0', '内网IP', 59, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:45:46', 0);
INSERT INTO `sys_log` VALUES (221, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.163.129', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:02', 0);
INSERT INTO `sys_log` VALUES (222, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.163.129', '0', '内网IP', 39, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:02', 0);
INSERT INTO `sys_log` VALUES (223, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:28', 0);
INSERT INTO `sys_log` VALUES (224, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:37', 0);
INSERT INTO `sys_log` VALUES (225, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:46', 0);
INSERT INTO `sys_log` VALUES (226, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 68, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:46', 0);
INSERT INTO `sys_log` VALUES (227, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.43.200', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:49', 0);
INSERT INTO `sys_log` VALUES (228, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:59', 0);
INSERT INTO `sys_log` VALUES (229, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 42, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:46:59', 0);
INSERT INTO `sys_log` VALUES (230, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:47:04', 0);
INSERT INTO `sys_log` VALUES (231, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:49:20', 0);
INSERT INTO `sys_log` VALUES (232, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:50:15', 0);
INSERT INTO `sys_log` VALUES (233, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:51:10', 0);
INSERT INTO `sys_log` VALUES (234, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:51:49', 0);
INSERT INTO `sys_log` VALUES (235, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:53:46', 0);
INSERT INTO `sys_log` VALUES (236, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:54:25', 0);
INSERT INTO `sys_log` VALUES (237, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:55:18', 0);
INSERT INTO `sys_log` VALUES (238, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 09:55:19', 0);
INSERT INTO `sys_log` VALUES (239, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:00:05', 0);
INSERT INTO `sys_log` VALUES (240, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:00:28', 0);
INSERT INTO `sys_log` VALUES (241, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:00:42', 0);
INSERT INTO `sys_log` VALUES (242, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:04:09', 0);
INSERT INTO `sys_log` VALUES (243, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:04:23', 0);
INSERT INTO `sys_log` VALUES (244, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:06:31', 0);
INSERT INTO `sys_log` VALUES (245, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:06:31', 0);
INSERT INTO `sys_log` VALUES (246, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 64, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:13:40', 0);
INSERT INTO `sys_log` VALUES (247, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:14:09', 0);
INSERT INTO `sys_log` VALUES (248, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 22, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:14:17', 0);
INSERT INTO `sys_log` VALUES (249, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:15:39', 0);
INSERT INTO `sys_log` VALUES (250, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:16:03', 0);
INSERT INTO `sys_log` VALUES (251, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:16:55', 0);
INSERT INTO `sys_log` VALUES (252, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:17:25', 0);
INSERT INTO `sys_log` VALUES (253, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 68, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:18:43', 0);
INSERT INTO `sys_log` VALUES (254, 'USER', 'GET', '{\"deptId\":8,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:18:47', 0);
INSERT INTO `sys_log` VALUES (255, 'USER', 'GET', '{\"deptId\":3,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:18:49', 0);
INSERT INTO `sys_log` VALUES (256, 'USER', 'GET', '{\"deptId\":8,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:18:50', 0);
INSERT INTO `sys_log` VALUES (257, 'USER', 'GET', '{\"deptId\":2,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:18:54', 0);
INSERT INTO `sys_log` VALUES (258, 'USER', 'GET', '{\"deptId\":3,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 22, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:18:56', 0);
INSERT INTO `sys_log` VALUES (259, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:19:03', 0);
INSERT INTO `sys_log` VALUES (260, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 26, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:19:35', 0);
INSERT INTO `sys_log` VALUES (261, 'ROLE', 'GET', '{\"pageNum\":2,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:20:30', 0);
INSERT INTO `sys_log` VALUES (262, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:20:32', 0);
INSERT INTO `sys_log` VALUES (263, 'USER', 'GET', '{\"deptId\":1,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:22:34', 0);
INSERT INTO `sys_log` VALUES (264, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:11', 0);
INSERT INTO `sys_log` VALUES (265, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:13', 0);
INSERT INTO `sys_log` VALUES (266, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:16', 0);
INSERT INTO `sys_log` VALUES (267, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:19', 0);
INSERT INTO `sys_log` VALUES (268, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:21', 0);
INSERT INTO `sys_log` VALUES (269, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:24', 0);
INSERT INTO `sys_log` VALUES (270, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:27', 0);
INSERT INTO `sys_log` VALUES (271, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:30', 0);
INSERT INTO `sys_log` VALUES (272, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:33', 0);
INSERT INTO `sys_log` VALUES (273, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:25:52', 0);
INSERT INTO `sys_log` VALUES (274, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:26:22', 0);
INSERT INTO `sys_log` VALUES (275, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:26:49', 0);
INSERT INTO `sys_log` VALUES (276, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:29:13', 0);
INSERT INTO `sys_log` VALUES (277, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 376, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:30:05', 0);
INSERT INTO `sys_log` VALUES (278, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:30:05', 0);
INSERT INTO `sys_log` VALUES (279, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:30:06', 0);
INSERT INTO `sys_log` VALUES (280, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:30:10', 0);
INSERT INTO `sys_log` VALUES (281, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:30:26', 0);
INSERT INTO `sys_log` VALUES (282, 'LOGIN', 'POST', 'text 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 103, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:30:36', 0);
INSERT INTO `sys_log` VALUES (283, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 104, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:30:55', 0);
INSERT INTO `sys_log` VALUES (284, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:30:55', 0);
INSERT INTO `sys_log` VALUES (285, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:30:56', 0);
INSERT INTO `sys_log` VALUES (286, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:33:21', 0);
INSERT INTO `sys_log` VALUES (287, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:35:12', 0);
INSERT INTO `sys_log` VALUES (288, 'USER', 'POST', '{\"username\":\"water\",\"nickname\":\"水站管理员\",\"mobile\":\"13822123456\",\"gender\":2,\"email\":\"3317296587@qq.com\",\"status\":1,\"deptId\":1,\"roleIds\":[13]}', NULL, '新增用户', '/api/v1/users', NULL, '192.168.43.200', '0', '内网IP', 147, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:36:50', 0);
INSERT INTO `sys_log` VALUES (289, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:36:50', 0);
INSERT INTO `sys_log` VALUES (290, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:37:02', 0);
INSERT INTO `sys_log` VALUES (291, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 123, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:37:12', 0);
INSERT INTO `sys_log` VALUES (292, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:37:13', 0);
INSERT INTO `sys_log` VALUES (293, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:37:39', 0);
INSERT INTO `sys_log` VALUES (294, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:37:44', 0);
INSERT INTO `sys_log` VALUES (295, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 229, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:37:49', 0);
INSERT INTO `sys_log` VALUES (296, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:37:49', 0);
INSERT INTO `sys_log` VALUES (297, 'USER', 'GET', '', NULL, '获取个人中心用户信息', '/api/v1/users/profile', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:37:50', 0);
INSERT INTO `sys_log` VALUES (298, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:37:54', 0);
INSERT INTO `sys_log` VALUES (299, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:37:59', 0);
INSERT INTO `sys_log` VALUES (300, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:38:42', 0);
INSERT INTO `sys_log` VALUES (301, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 2, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:38:46', 0);
INSERT INTO `sys_log` VALUES (302, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 258, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:38:59', 0);
INSERT INTO `sys_log` VALUES (303, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:39:00', 0);
INSERT INTO `sys_log` VALUES (304, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:39:08', 0);
INSERT INTO `sys_log` VALUES (305, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 23, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:39:12', 0);
INSERT INTO `sys_log` VALUES (306, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 0, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 10:39:57', 0);
INSERT INTO `sys_log` VALUES (307, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 210, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 10:40:02', 0);
INSERT INTO `sys_log` VALUES (308, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:40:02', 0);
INSERT INTO `sys_log` VALUES (309, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:40:28', 0);
INSERT INTO `sys_log` VALUES (310, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:41:35', 0);
INSERT INTO `sys_log` VALUES (311, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:41:47', 0);
INSERT INTO `sys_log` VALUES (312, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 43, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:56:44', 0);
INSERT INTO `sys_log` VALUES (313, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 20, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:57:21', 0);
INSERT INTO `sys_log` VALUES (314, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 10:58:12', 0);
INSERT INTO `sys_log` VALUES (315, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 34, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:03:19', 0);
INSERT INTO `sys_log` VALUES (316, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:03:43', 0);
INSERT INTO `sys_log` VALUES (317, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 76, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:03:43', 0);
INSERT INTO `sys_log` VALUES (318, 'OTHER', 'GET', '{\"excludeTables\":[\"gen_config\",\"gen_field_config\"],\"pageNum\":1,\"pageSize\":10}', NULL, '代码生成分页列表', '/api/v1/codegen/table/page', NULL, '192.168.43.200', '0', '内网IP', 71, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:04:01', 0);
INSERT INTO `sys_log` VALUES (319, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:07:51', 0);
INSERT INTO `sys_log` VALUES (320, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 23, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:18:54', 0);
INSERT INTO `sys_log` VALUES (321, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:20:19', 0);
INSERT INTO `sys_log` VALUES (322, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:20:46', 0);
INSERT INTO `sys_log` VALUES (323, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 20, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:20:46', 0);
INSERT INTO `sys_log` VALUES (324, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:26:15', 0);
INSERT INTO `sys_log` VALUES (325, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:26:27', 0);
INSERT INTO `sys_log` VALUES (326, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 30, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:26:30', 0);
INSERT INTO `sys_log` VALUES (327, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:28:14', 0);
INSERT INTO `sys_log` VALUES (328, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:28:21', 0);
INSERT INTO `sys_log` VALUES (329, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:28:22', 0);
INSERT INTO `sys_log` VALUES (330, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 28, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:29:00', 0);
INSERT INTO `sys_log` VALUES (331, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:29:18', 0);
INSERT INTO `sys_log` VALUES (332, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:29:57', 0);
INSERT INTO `sys_log` VALUES (333, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:29:58', 0);
INSERT INTO `sys_log` VALUES (334, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 35, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:34:04', 0);
INSERT INTO `sys_log` VALUES (335, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 28, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:34:27', 0);
INSERT INTO `sys_log` VALUES (336, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 32, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:34:51', 0);
INSERT INTO `sys_log` VALUES (337, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:34:54', 0);
INSERT INTO `sys_log` VALUES (338, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:34:55', 0);
INSERT INTO `sys_log` VALUES (339, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:34:57', 0);
INSERT INTO `sys_log` VALUES (340, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:35:05', 0);
INSERT INTO `sys_log` VALUES (341, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:35:07', 0);
INSERT INTO `sys_log` VALUES (342, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:35:08', 0);
INSERT INTO `sys_log` VALUES (343, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:39:44', 0);
INSERT INTO `sys_log` VALUES (344, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 32, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:41:11', 0);
INSERT INTO `sys_log` VALUES (345, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:42:18', 0);
INSERT INTO `sys_log` VALUES (346, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:43:32', 0);
INSERT INTO `sys_log` VALUES (347, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 28, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:44:37', 0);
INSERT INTO `sys_log` VALUES (348, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 44, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:45:14', 0);
INSERT INTO `sys_log` VALUES (349, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 38, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:45:36', 0);
INSERT INTO `sys_log` VALUES (350, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 22, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:45:53', 0);
INSERT INTO `sys_log` VALUES (351, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:46:07', 0);
INSERT INTO `sys_log` VALUES (352, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:46:09', 0);
INSERT INTO `sys_log` VALUES (353, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:46:10', 0);
INSERT INTO `sys_log` VALUES (354, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:46:20', 0);
INSERT INTO `sys_log` VALUES (355, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:47:50', 0);
INSERT INTO `sys_log` VALUES (356, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:50:24', 0);
INSERT INTO `sys_log` VALUES (357, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:50:24', 0);
INSERT INTO `sys_log` VALUES (358, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:50:24', 0);
INSERT INTO `sys_log` VALUES (359, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:50:44', 0);
INSERT INTO `sys_log` VALUES (360, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:50:45', 0);
INSERT INTO `sys_log` VALUES (361, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 11:50:45', 0);
INSERT INTO `sys_log` VALUES (362, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 345, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:36:50', 0);
INSERT INTO `sys_log` VALUES (363, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 27, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:36:54', 0);
INSERT INTO `sys_log` VALUES (364, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.157.1', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:36:55', 0);
INSERT INTO `sys_log` VALUES (365, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.157.1', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:36:56', 0);
INSERT INTO `sys_log` VALUES (366, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.157.1', '0', '内网IP', 26, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:36:57', 0);
INSERT INTO `sys_log` VALUES (367, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.157.1', '0', '内网IP', 53, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:37:01', 0);
INSERT INTO `sys_log` VALUES (368, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 55, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:45:18', 0);
INSERT INTO `sys_log` VALUES (369, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:51:47', 0);
INSERT INTO `sys_log` VALUES (370, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:51:47', 0);
INSERT INTO `sys_log` VALUES (371, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 23, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:51:49', 0);
INSERT INTO `sys_log` VALUES (372, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:51:49', 0);
INSERT INTO `sys_log` VALUES (373, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:58:14', 0);
INSERT INTO `sys_log` VALUES (374, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:58:15', 0);
INSERT INTO `sys_log` VALUES (375, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:58:17', 0);
INSERT INTO `sys_log` VALUES (376, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:58:18', 0);
INSERT INTO `sys_log` VALUES (377, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:58:58', 0);
INSERT INTO `sys_log` VALUES (378, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:58:59', 0);
INSERT INTO `sys_log` VALUES (379, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:02', 0);
INSERT INTO `sys_log` VALUES (380, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:03', 0);
INSERT INTO `sys_log` VALUES (381, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:09', 0);
INSERT INTO `sys_log` VALUES (382, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 36, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:12', 0);
INSERT INTO `sys_log` VALUES (383, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:13', 0);
INSERT INTO `sys_log` VALUES (384, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 21, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:15', 0);
INSERT INTO `sys_log` VALUES (385, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:24', 0);
INSERT INTO `sys_log` VALUES (386, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:26', 0);
INSERT INTO `sys_log` VALUES (387, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:33', 0);
INSERT INTO `sys_log` VALUES (388, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:35', 0);
INSERT INTO `sys_log` VALUES (389, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:47', 0);
INSERT INTO `sys_log` VALUES (390, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 51, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 13:59:48', 0);
INSERT INTO `sys_log` VALUES (391, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:00:20', 0);
INSERT INTO `sys_log` VALUES (392, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:01:03', 0);
INSERT INTO `sys_log` VALUES (393, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 42, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:01:04', 0);
INSERT INTO `sys_log` VALUES (394, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:01:54', 0);
INSERT INTO `sys_log` VALUES (395, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 3, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:01:56', 0);
INSERT INTO `sys_log` VALUES (396, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:02:26', 0);
INSERT INTO `sys_log` VALUES (397, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:02:28', 0);
INSERT INTO `sys_log` VALUES (398, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:02:29', 0);
INSERT INTO `sys_log` VALUES (399, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:02:29', 0);
INSERT INTO `sys_log` VALUES (400, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:02:51', 0);
INSERT INTO `sys_log` VALUES (401, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:03:41', 0);
INSERT INTO `sys_log` VALUES (402, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:05:16', 0);
INSERT INTO `sys_log` VALUES (403, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:08:01', 0);
INSERT INTO `sys_log` VALUES (404, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:08:04', 0);
INSERT INTO `sys_log` VALUES (405, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:08:04', 0);
INSERT INTO `sys_log` VALUES (406, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:10:10', 0);
INSERT INTO `sys_log` VALUES (407, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:10:11', 0);
INSERT INTO `sys_log` VALUES (408, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 3, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:10:12', 0);
INSERT INTO `sys_log` VALUES (409, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:10:30', 0);
INSERT INTO `sys_log` VALUES (410, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 0, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:10:31', 0);
INSERT INTO `sys_log` VALUES (411, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 0, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:10:31', 0);
INSERT INTO `sys_log` VALUES (412, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:13:28', 0);
INSERT INTO `sys_log` VALUES (413, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:13:29', 0);
INSERT INTO `sys_log` VALUES (414, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:13:29', 0);
INSERT INTO `sys_log` VALUES (415, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:13:53', 0);
INSERT INTO `sys_log` VALUES (416, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 38, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:13:54', 0);
INSERT INTO `sys_log` VALUES (417, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:14:03', 0);
INSERT INTO `sys_log` VALUES (418, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:14:20', 0);
INSERT INTO `sys_log` VALUES (419, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 32, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:14:22', 0);
INSERT INTO `sys_log` VALUES (420, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:14:44', 0);
INSERT INTO `sys_log` VALUES (421, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:15:01', 0);
INSERT INTO `sys_log` VALUES (422, 'SETTING', 'GET', '{\"keywords\":\"\",\"pageNum\":1,\"pageSize\":10}', NULL, '系统配置分页列表', '/api/v1/config/page', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:15:19', 0);
INSERT INTO `sys_log` VALUES (423, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 2, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:15:47', 0);
INSERT INTO `sys_log` VALUES (424, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 237, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:15:59', 0);
INSERT INTO `sys_log` VALUES (425, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:15:59', 0);
INSERT INTO `sys_log` VALUES (426, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:16:18', 0);
INSERT INTO `sys_log` VALUES (427, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:16:19', 0);
INSERT INTO `sys_log` VALUES (428, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:16:22', 0);
INSERT INTO `sys_log` VALUES (429, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:16:31', 0);
INSERT INTO `sys_log` VALUES (430, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 20, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:16:35', 0);
INSERT INTO `sys_log` VALUES (431, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:19:03', 0);
INSERT INTO `sys_log` VALUES (432, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:19:12', 0);
INSERT INTO `sys_log` VALUES (433, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 2, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:20:15', 0);
INSERT INTO `sys_log` VALUES (434, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 229, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:20:19', 0);
INSERT INTO `sys_log` VALUES (435, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:20:19', 0);
INSERT INTO `sys_log` VALUES (436, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:24:59', 0);
INSERT INTO `sys_log` VALUES (437, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 34, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:25:00', 0);
INSERT INTO `sys_log` VALUES (438, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:25:59', 0);
INSERT INTO `sys_log` VALUES (439, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:07', 0);
INSERT INTO `sys_log` VALUES (440, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:11', 0);
INSERT INTO `sys_log` VALUES (441, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:20', 0);
INSERT INTO `sys_log` VALUES (442, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:21', 0);
INSERT INTO `sys_log` VALUES (443, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:50', 0);
INSERT INTO `sys_log` VALUES (444, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:52', 0);
INSERT INTO `sys_log` VALUES (445, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:26:54', 0);
INSERT INTO `sys_log` VALUES (446, 'USER', 'PUT', '{} {\"id\":4,\"username\":\"water\",\"nickname\":\"水站管理员\",\"mobile\":\"13822123456\",\"gender\":2,\"email\":\"3317296587@qq.com\",\"status\":1,\"deptId\":1,\"roleIds\":[13]}', NULL, '修改用户', '/api/v1/users/4', NULL, '192.168.43.200', '0', '内网IP', 58, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:27:06', 0);
INSERT INTO `sys_log` VALUES (447, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:27:06', 0);
INSERT INTO `sys_log` VALUES (448, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:27:07', 0);
INSERT INTO `sys_log` VALUES (449, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:27:55', 0);
INSERT INTO `sys_log` VALUES (450, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:28:49', 0);
INSERT INTO `sys_log` VALUES (451, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:28:58', 0);
INSERT INTO `sys_log` VALUES (452, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:29:22', 0);
INSERT INTO `sys_log` VALUES (453, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:29:22', 0);
INSERT INTO `sys_log` VALUES (454, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:30:14', 0);
INSERT INTO `sys_log` VALUES (455, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:30:19', 0);
INSERT INTO `sys_log` VALUES (456, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:30:23', 0);
INSERT INTO `sys_log` VALUES (457, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:16', 0);
INSERT INTO `sys_log` VALUES (458, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 22, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:32', 0);
INSERT INTO `sys_log` VALUES (459, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 22, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:49', 0);
INSERT INTO `sys_log` VALUES (460, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:53', 0);
INSERT INTO `sys_log` VALUES (461, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 28, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:53', 0);
INSERT INTO `sys_log` VALUES (462, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:55', 0);
INSERT INTO `sys_log` VALUES (463, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:31:58', 0);
INSERT INTO `sys_log` VALUES (464, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:32:02', 0);
INSERT INTO `sys_log` VALUES (465, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:32:40', 0);
INSERT INTO `sys_log` VALUES (466, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:33:00', 0);
INSERT INTO `sys_log` VALUES (467, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 155, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:33:13', 0);
INSERT INTO `sys_log` VALUES (468, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:33:13', 0);
INSERT INTO `sys_log` VALUES (469, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:33:17', 0);
INSERT INTO `sys_log` VALUES (470, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:33:30', 0);
INSERT INTO `sys_log` VALUES (471, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:33:41', 0);
INSERT INTO `sys_log` VALUES (472, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 14, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:33:42', 0);
INSERT INTO `sys_log` VALUES (473, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 2, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:33:52', 0);
INSERT INTO `sys_log` VALUES (474, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 145, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:33:57', 0);
INSERT INTO `sys_log` VALUES (475, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:33:57', 0);
INSERT INTO `sys_log` VALUES (476, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:33:58', 0);
INSERT INTO `sys_log` VALUES (477, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:34:44', 0);
INSERT INTO `sys_log` VALUES (478, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:34:45', 0);
INSERT INTO `sys_log` VALUES (479, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/2/form', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:34:58', 0);
INSERT INTO `sys_log` VALUES (480, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/2/form', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:05', 0);
INSERT INTO `sys_log` VALUES (481, 'USER', 'PUT', '{} {\"id\":2,\"username\":\"admin\",\"nickname\":\"系统管理员\",\"mobile\":\"18812345678\",\"gender\":1,\"avatar\":\"https://foruda.gitee.com/images/1723603502796844527/03cdca2a_716974.gif\",\"email\":\"youlaitech@163.com\",\"status\":1,\"deptId\":1,\"roleIds\":[2]}', NULL, '修改用户', '/api/v1/users/2', NULL, '192.168.43.200', '0', '内网IP', 19, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:13', 0);
INSERT INTO `sys_log` VALUES (482, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:14', 0);
INSERT INTO `sys_log` VALUES (483, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:24', 0);
INSERT INTO `sys_log` VALUES (484, 'USER', 'PUT', '{} {\"id\":4,\"username\":\"water\",\"nickname\":\"水站管理员\",\"mobile\":\"13822123456\",\"gender\":2,\"email\":\"3317296587@qq.com\",\"status\":1,\"deptId\":3,\"roleIds\":[13]}', NULL, '修改用户', '/api/v1/users/4', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:32', 0);
INSERT INTO `sys_log` VALUES (485, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:32', 0);
INSERT INTO `sys_log` VALUES (486, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:46', 0);
INSERT INTO `sys_log` VALUES (487, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:48', 0);
INSERT INTO `sys_log` VALUES (488, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:35:53', 0);
INSERT INTO `sys_log` VALUES (489, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:38:42', 0);
INSERT INTO `sys_log` VALUES (490, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:38:54', 0);
INSERT INTO `sys_log` VALUES (491, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:38:55', 0);
INSERT INTO `sys_log` VALUES (492, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:39:01', 0);
INSERT INTO `sys_log` VALUES (493, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 107, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:39:09', 0);
INSERT INTO `sys_log` VALUES (494, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 3, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:39:09', 0);
INSERT INTO `sys_log` VALUES (495, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:39:10', 0);
INSERT INTO `sys_log` VALUES (496, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:39:27', 0);
INSERT INTO `sys_log` VALUES (497, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:40:22', 0);
INSERT INTO `sys_log` VALUES (498, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 114, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:40:26', 0);
INSERT INTO `sys_log` VALUES (499, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:40:26', 0);
INSERT INTO `sys_log` VALUES (500, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:40:38', 0);
INSERT INTO `sys_log` VALUES (501, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:40:38', 0);
INSERT INTO `sys_log` VALUES (502, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:40:45', 0);
INSERT INTO `sys_log` VALUES (503, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:40:48', 0);
INSERT INTO `sys_log` VALUES (504, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:41:39', 0);
INSERT INTO `sys_log` VALUES (505, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:41:56', 0);
INSERT INTO `sys_log` VALUES (506, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 13, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:06', 0);
INSERT INTO `sys_log` VALUES (507, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:09', 0);
INSERT INTO `sys_log` VALUES (508, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:21', 0);
INSERT INTO `sys_log` VALUES (509, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 38, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:34', 0);
INSERT INTO `sys_log` VALUES (510, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 17, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:35', 0);
INSERT INTO `sys_log` VALUES (511, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 3, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:38', 0);
INSERT INTO `sys_log` VALUES (512, 'USER', 'PUT', '{} {\"id\":4,\"username\":\"water\",\"nickname\":\"水站管理员\",\"mobile\":\"13822123456\",\"gender\":2,\"email\":\"3317296587@qq.com\",\"status\":1,\"deptId\":2,\"roleIds\":[13]}', NULL, '修改用户', '/api/v1/users/4', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:46', 0);
INSERT INTO `sys_log` VALUES (513, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 15, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:46', 0);
INSERT INTO `sys_log` VALUES (514, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:42:50', 0);
INSERT INTO `sys_log` VALUES (515, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 224, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:42:59', 0);
INSERT INTO `sys_log` VALUES (516, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:42:59', 0);
INSERT INTO `sys_log` VALUES (517, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:42:59', 0);
INSERT INTO `sys_log` VALUES (518, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:43:07', 0);
INSERT INTO `sys_log` VALUES (519, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:43:07', 0);
INSERT INTO `sys_log` VALUES (520, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:43:12', 0);
INSERT INTO `sys_log` VALUES (521, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:43:20', 0);
INSERT INTO `sys_log` VALUES (522, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:43:21', 0);
INSERT INTO `sys_log` VALUES (523, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:43:26', 0);
INSERT INTO `sys_log` VALUES (524, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 202, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:43:30', 0);
INSERT INTO `sys_log` VALUES (525, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:43:30', 0);
INSERT INTO `sys_log` VALUES (526, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:43:31', 0);
INSERT INTO `sys_log` VALUES (527, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:43:56', 0);
INSERT INTO `sys_log` VALUES (528, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:44:14', 0);
INSERT INTO `sys_log` VALUES (529, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:44:39', 0);
INSERT INTO `sys_log` VALUES (530, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:44:41', 0);
INSERT INTO `sys_log` VALUES (531, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:45:36', 0);
INSERT INTO `sys_log` VALUES (532, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:45:41', 0);
INSERT INTO `sys_log` VALUES (533, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:47:32', 0);
INSERT INTO `sys_log` VALUES (534, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:48:00', 0);
INSERT INTO `sys_log` VALUES (535, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:48:28', 0);
INSERT INTO `sys_log` VALUES (536, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:48:31', 0);
INSERT INTO `sys_log` VALUES (537, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 188, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:48:38', 0);
INSERT INTO `sys_log` VALUES (538, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:48:39', 0);
INSERT INTO `sys_log` VALUES (539, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:48:44', 0);
INSERT INTO `sys_log` VALUES (540, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 0, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:49:29', 0);
INSERT INTO `sys_log` VALUES (541, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 279, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:49:32', 0);
INSERT INTO `sys_log` VALUES (542, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:49:32', 0);
INSERT INTO `sys_log` VALUES (543, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 16, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:49:33', 0);
INSERT INTO `sys_log` VALUES (544, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:49:44', 0);
INSERT INTO `sys_log` VALUES (545, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:50:26', 0);
INSERT INTO `sys_log` VALUES (546, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:50:35', 0);
INSERT INTO `sys_log` VALUES (547, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 36, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:50:44', 0);
INSERT INTO `sys_log` VALUES (548, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:50:54', 0);
INSERT INTO `sys_log` VALUES (549, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 3, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:50:58', 0);
INSERT INTO `sys_log` VALUES (550, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:51:03', 0);
INSERT INTO `sys_log` VALUES (551, 'LOGIN', 'POST', 'water 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 105, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:51:12', 0);
INSERT INTO `sys_log` VALUES (552, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:51:12', 0);
INSERT INTO `sys_log` VALUES (553, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:51:13', 0);
INSERT INTO `sys_log` VALUES (554, 'USER', 'GET', '{\"deptId\":9,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:51:53', 0);
INSERT INTO `sys_log` VALUES (555, 'USER', 'GET', '{\"deptId\":9,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:51:55', 0);
INSERT INTO `sys_log` VALUES (556, 'USER', 'GET', '{\"deptId\":2,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:51:56', 0);
INSERT INTO `sys_log` VALUES (557, 'USER', 'GET', '{\"deptId\":9,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:52:01', 0);
INSERT INTO `sys_log` VALUES (558, 'USER', 'GET', '{\"deptId\":2,\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:52:02', 0);
INSERT INTO `sys_log` VALUES (559, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:52:05', 0);
INSERT INTO `sys_log` VALUES (560, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.43.200', '0', '内网IP', 1, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 4, '2025-12-01 14:52:20', 0);
INSERT INTO `sys_log` VALUES (561, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.43.200', '0', '内网IP', 106, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', NULL, '2025-12-01 14:52:25', 0);
INSERT INTO `sys_log` VALUES (562, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:52:25', 0);
INSERT INTO `sys_log` VALUES (563, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:52:37', 0);
INSERT INTO `sys_log` VALUES (564, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 27, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:52:38', 0);
INSERT INTO `sys_log` VALUES (565, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:52:48', 0);
INSERT INTO `sys_log` VALUES (566, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:52:50', 0);
INSERT INTO `sys_log` VALUES (567, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 18, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:52:58', 0);
INSERT INTO `sys_log` VALUES (568, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:53:00', 0);
INSERT INTO `sys_log` VALUES (569, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:53:25', 0);
INSERT INTO `sys_log` VALUES (570, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 8, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:54:03', 0);
INSERT INTO `sys_log` VALUES (571, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:54:05', 0);
INSERT INTO `sys_log` VALUES (572, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:54:06', 0);
INSERT INTO `sys_log` VALUES (573, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 5, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:54:22', 0);
INSERT INTO `sys_log` VALUES (574, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:54:34', 0);
INSERT INTO `sys_log` VALUES (575, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:54:35', 0);
INSERT INTO `sys_log` VALUES (576, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 9, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:55:10', 0);
INSERT INTO `sys_log` VALUES (577, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:55:16', 0);
INSERT INTO `sys_log` VALUES (578, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.43.200', '0', '内网IP', 11, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:55:52', 0);
INSERT INTO `sys_log` VALUES (579, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.43.200', '0', '内网IP', 35, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:55:59', 0);
INSERT INTO `sys_log` VALUES (580, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/3/form', NULL, '192.168.43.200', '0', '内网IP', 4, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:56:55', 0);
INSERT INTO `sys_log` VALUES (581, 'USER', 'PUT', '{} {\"id\":3,\"username\":\"test\",\"nickname\":\"测试小用户\",\"mobile\":\"18812345679\",\"gender\":1,\"avatar\":\"https://foruda.gitee.com/images/1723603502796844527/03cdca2a_716974.gif\",\"email\":\"youlaitech@163.com\",\"status\":1,\"deptId\":3,\"roleIds\":[3]}', NULL, '修改用户', '/api/v1/users/3', NULL, '192.168.43.200', '0', '内网IP', 24, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:03', 0);
INSERT INTO `sys_log` VALUES (582, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 12, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:04', 0);
INSERT INTO `sys_log` VALUES (583, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/4/form', NULL, '192.168.43.200', '0', '内网IP', 6, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:06', 0);
INSERT INTO `sys_log` VALUES (584, 'USER', 'PUT', '{} {\"id\":4,\"username\":\"water\",\"nickname\":\"水站管理员\",\"mobile\":\"13822123456\",\"gender\":2,\"email\":\"3317296587@qq.com\",\"status\":1,\"deptId\":2,\"roleIds\":[13]}', NULL, '修改用户', '/api/v1/users/4', NULL, '192.168.43.200', '0', '内网IP', 25, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:08', 0);
INSERT INTO `sys_log` VALUES (585, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:09', 0);
INSERT INTO `sys_log` VALUES (586, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/2/form', NULL, '192.168.43.200', '0', '内网IP', 7, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:10', 0);
INSERT INTO `sys_log` VALUES (587, 'USER', 'PUT', '{} {\"id\":2,\"username\":\"admin\",\"nickname\":\"系统管理员\",\"mobile\":\"18812345678\",\"gender\":1,\"avatar\":\"https://foruda.gitee.com/images/1723603502796844527/03cdca2a_716974.gif\",\"email\":\"youlaitech@163.com\",\"status\":1,\"deptId\":1,\"roleIds\":[2]}', NULL, '修改用户', '/api/v1/users/2', NULL, '192.168.43.200', '0', '内网IP', 26, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:14', 0);
INSERT INTO `sys_log` VALUES (588, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.43.200', '0', '内网IP', 10, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:14', 0);
INSERT INTO `sys_log` VALUES (589, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/2/form', NULL, '192.168.43.200', '0', '内网IP', 3, 'Lenovo', '9.0.6.8151', 'Windows 10 or Windows Server 2016', 2, '2025-12-01 14:57:23', 0);
INSERT INTO `sys_log` VALUES (590, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.201', '0', '内网IP', 447, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-12-02 09:43:34', 0);
INSERT INTO `sys_log` VALUES (591, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 15, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 09:43:34', 0);
INSERT INTO `sys_log` VALUES (592, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 11, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 09:43:44', 0);
INSERT INTO `sys_log` VALUES (593, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.118.201', '0', '内网IP', 11, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 09:43:53', 0);
INSERT INTO `sys_log` VALUES (594, 'SETTING', 'GET', '{\"keywords\":\"\",\"pageNum\":1,\"pageSize\":10}', NULL, '系统配置分页列表', '/api/v1/config/page', NULL, '192.168.118.201', '0', '内网IP', 7, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 09:43:55', 0);
INSERT INTO `sys_log` VALUES (595, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 20, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 09:53:43', 0);
INSERT INTO `sys_log` VALUES (596, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 65, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:02:27', 0);
INSERT INTO `sys_log` VALUES (597, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 14, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:03:22', 0);
INSERT INTO `sys_log` VALUES (598, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":20}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 36, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:12:20', 0);
INSERT INTO `sys_log` VALUES (599, 'OTHER', 'GET', '{\"excludeTables\":[\"gen_config\",\"gen_field_config\"],\"pageNum\":1,\"pageSize\":10}', NULL, '代码生成分页列表', '/api/v1/codegen/table/page', NULL, '192.168.118.201', '0', '内网IP', 20, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:14:13', 0);
INSERT INTO `sys_log` VALUES (600, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.118.201', '0', '内网IP', 3, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:18:39', 0);
INSERT INTO `sys_log` VALUES (601, 'LOGIN', 'POST', 'gee 11111111', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.201', '0', '内网IP', 89, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-12-02 11:21:48', 0);
INSERT INTO `sys_log` VALUES (602, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.201', '0', '内网IP', 83, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-12-02 11:22:23', 0);
INSERT INTO `sys_log` VALUES (603, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 5, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:22:23', 0);
INSERT INTO `sys_log` VALUES (604, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 12, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:22:32', 0);
INSERT INTO `sys_log` VALUES (605, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 10, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:22:37', 0);
INSERT INTO `sys_log` VALUES (606, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 9, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:22:39', 0);
INSERT INTO `sys_log` VALUES (607, 'USER', 'POST', '{\"username\":\"gee\",\"nickname\":\"gee\",\"mobile\":\"19055654895\",\"gender\":1,\"email\":\"manbaoout@163.com\",\"status\":1,\"deptId\":1,\"roleIds\":[13]}', NULL, '新增用户', '/api/v1/users', NULL, '192.168.118.201', '0', '内网IP', 162, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:17', 0);
INSERT INTO `sys_log` VALUES (608, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 10, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:18', 0);
INSERT INTO `sys_log` VALUES (609, 'USER', 'GET', '{}', NULL, '用户表单数据', '/api/v1/users/6/form', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:22', 0);
INSERT INTO `sys_log` VALUES (610, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:25', 0);
INSERT INTO `sys_log` VALUES (611, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.118.201', '0', '内网IP', 25, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:26', 0);
INSERT INTO `sys_log` VALUES (612, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.201', '0', '内网IP', 11, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:28', 0);
INSERT INTO `sys_log` VALUES (613, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 6, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:24:46', 0);
INSERT INTO `sys_log` VALUES (614, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 10, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:39:31', 0);
INSERT INTO `sys_log` VALUES (615, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.201', '0', '内网IP', 7, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:39:32', 0);
INSERT INTO `sys_log` VALUES (616, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.118.201', '0', '内网IP', 1, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 11:40:09', 0);
INSERT INTO `sys_log` VALUES (617, 'LOGIN', 'POST', 'gee 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.201', '0', '内网IP', 91, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-12-02 11:40:18', 0);
INSERT INTO `sys_log` VALUES (618, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 3, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 11:40:18', 0);
INSERT INTO `sys_log` VALUES (619, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 14, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 11:40:19', 0);
INSERT INTO `sys_log` VALUES (620, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 11:40:22', 0);
INSERT INTO `sys_log` VALUES (621, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 40, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 14:00:54', 0);
INSERT INTO `sys_log` VALUES (622, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 9, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 14:01:52', 0);
INSERT INTO `sys_log` VALUES (623, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 5, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 14:02:48', 0);
INSERT INTO `sys_log` VALUES (624, 'LOGIN', 'DELETE', '{}', NULL, '退出登录', '/api/v1/auth/logout', NULL, '192.168.118.201', '0', '内网IP', 1, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 6, '2025-12-02 14:02:52', 0);
INSERT INTO `sys_log` VALUES (625, 'LOGIN', 'POST', 'admin 123456', NULL, '登录', '/api/v1/auth/login', NULL, '192.168.118.201', '0', '内网IP', 83, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', NULL, '2025-12-02 14:02:58', 0);
INSERT INTO `sys_log` VALUES (626, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:02:58', 0);
INSERT INTO `sys_log` VALUES (627, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 7, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:03:01', 0);
INSERT INTO `sys_log` VALUES (628, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.118.201', '0', '内网IP', 7, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:03:13', 0);
INSERT INTO `sys_log` VALUES (629, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.118.201', '0', '内网IP', 5, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:03:58', 0);
INSERT INTO `sys_log` VALUES (630, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 5, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:07:12', 0);
INSERT INTO `sys_log` VALUES (631, 'USER', 'GET', '{\"isRoot\":false,\"pageNum\":1,\"pageSize\":10}', NULL, '用户分页列表', '/api/v1/users/page', NULL, '192.168.118.201', '0', '内网IP', 15, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:07:13', 0);
INSERT INTO `sys_log` VALUES (632, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.201', '0', '内网IP', 6, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:07:20', 0);
INSERT INTO `sys_log` VALUES (633, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.118.201', '0', '内网IP', 13, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:07:20', 0);
INSERT INTO `sys_log` VALUES (634, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 6, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:10:52', 0);
INSERT INTO `sys_log` VALUES (635, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:11', 0);
INSERT INTO `sys_log` VALUES (636, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 6, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:11', 0);
INSERT INTO `sys_log` VALUES (637, 'DICT', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '字典分页列表', '/api/v1/dicts/page', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:14', 0);
INSERT INTO `sys_log` VALUES (638, 'SETTING', 'GET', '{\"keywords\":\"\",\"pageNum\":1,\"pageSize\":10}', NULL, '系统配置分页列表', '/api/v1/config/page', NULL, '192.168.118.201', '0', '内网IP', 7, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:16', 0);
INSERT INTO `sys_log` VALUES (639, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 3, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:19', 0);
INSERT INTO `sys_log` VALUES (640, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:51', 0);
INSERT INTO `sys_log` VALUES (641, 'ROLE', 'GET', '{\"pageNum\":1,\"pageSize\":10}', NULL, '角色分页列表', '/api/v1/roles/page', NULL, '192.168.118.201', '0', '内网IP', 5, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:52', 0);
INSERT INTO `sys_log` VALUES (642, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 3, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:54', 0);
INSERT INTO `sys_log` VALUES (643, 'MENU', 'GET', '{}', NULL, '菜单列表', '/api/v1/menus', NULL, '192.168.118.201', '0', '内网IP', 13, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:11:55', 0);
INSERT INTO `sys_log` VALUES (644, 'USER', 'GET', '', NULL, '获取当前登录用户信息', '/api/v1/users/me', NULL, '192.168.118.201', '0', '内网IP', 4, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:20:00', 0);
INSERT INTO `sys_log` VALUES (645, 'DEPT', 'GET', '{}', NULL, '部门列表', '/api/v1/dept', NULL, '192.168.118.201', '0', '内网IP', 5, 'MSEdge', '142.0.0.0', 'Windows 10 or Windows Server 2016', 2, '2025-12-02 14:20:00', 0);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `parent_id` bigint NOT NULL COMMENT '父菜单ID',
  `tree_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '父节点ID路径',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `type` tinyint NOT NULL COMMENT '菜单类型（1-菜单 2-目录 3-外链 4-按钮）',
  `route_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由名称（Vue Router 中用于命名路由）',
  `route_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由路径（Vue Router 中定义的 URL 路径）',
  `component` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径（组件页面完整路径，相对于 src/views/，缺省后缀 .vue）',
  `perm` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '【按钮】权限标识',
  `always_show` tinyint NULL DEFAULT 0 COMMENT '【目录】只有一个子路由是否始终显示（1-是 0-否）',
  `keep_alive` tinyint NULL DEFAULT 0 COMMENT '【菜单】是否开启页面缓存（1-是 0-否）',
  `visible` tinyint(1) NULL DEFAULT 1 COMMENT '显示状态（1-显示 0-隐藏）',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `icon` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `redirect` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '跳转路径',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 166 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '0', '系统管理', 2, '', '/system', 'Layout', NULL, NULL, NULL, 1, 1, 'system', '/system/user', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (2, 1, '0,1', '用户管理', 1, 'User', 'user', 'system/user/index', NULL, NULL, 1, 1, 1, 'el-icon-User', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (3, 1, '0,1', '角色管理', 1, 'Role', 'role', 'system/role/index', NULL, NULL, 1, 1, 2, 'role', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (4, 1, '0,1', '菜单管理', 1, 'SysMenu', 'menu', 'system/menu/index', NULL, NULL, 1, 1, 3, 'menu', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (5, 1, '0,1', '站点管理', 1, 'Dept', 'dept', 'system/dept/index', NULL, NULL, 1, 1, 4, 'tree', NULL, '2025-11-24 15:32:02', '2025-12-01 14:31:49', NULL);
INSERT INTO `sys_menu` VALUES (6, 1, '0,1', '字典管理', 1, 'Dict', 'dict', 'system/dict/index', NULL, NULL, 1, 1, 5, 'dict', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (20, 0, '0', '多级菜单', 2, NULL, '/multi-level', 'Layout', NULL, 1, NULL, 1, 9, 'cascader', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (21, 20, '0,20', '菜单一级', 2, NULL, 'multi-level1', 'Layout', NULL, 1, NULL, 1, 1, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (22, 21, '0,20,21', '菜单二级', 2, NULL, 'multi-level2', 'Layout', NULL, 0, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (23, 22, '0,20,21,22', '菜单三级-1', 1, NULL, 'multi-level3-1', 'demo/multi-level/children/children/level3-1', NULL, 0, 1, 1, 1, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (24, 22, '0,20,21,22', '菜单三级-2', 1, NULL, 'multi-level3-2', 'demo/multi-level/children/children/level3-2', NULL, 0, 1, 1, 2, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (26, 0, '0', '平台文档', 2, '', '/doc', 'Layout', NULL, NULL, NULL, 1, 8, 'document', 'https://juejin.cn/post/7228990409909108793', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (30, 26, '0,26', '平台文档(外链)', 3, NULL, 'https://juejin.cn/post/7228990409909108793', '', NULL, NULL, NULL, 1, 2, 'document', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (31, 2, '0,1,2', '用户新增', 4, NULL, '', NULL, 'sys:user:add', NULL, NULL, 1, 1, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (32, 2, '0,1,2', '用户编辑', 4, NULL, '', NULL, 'sys:user:edit', NULL, NULL, 1, 2, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (33, 2, '0,1,2', '用户删除', 4, NULL, '', NULL, 'sys:user:delete', NULL, NULL, 1, 3, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (36, 0, '0', '组件封装', 2, NULL, '/component', 'Layout', NULL, NULL, NULL, 1, 10, 'menu', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (37, 36, '0,36', '富文本编辑器', 1, 'WangEditor', 'wang-editor', 'demo/wang-editor', NULL, NULL, 1, 1, 2, '', '', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (38, 36, '0,36', '图片上传', 1, 'Upload', 'upload', 'demo/upload', NULL, NULL, 1, 1, 3, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (39, 36, '0,36', '图标选择器', 1, 'IconSelect', 'icon-select', 'demo/icon-select', NULL, NULL, 1, 1, 4, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (40, 0, '0', '接口文档', 2, NULL, '/api', 'Layout', NULL, 1, NULL, 1, 7, 'api', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (41, 40, '0,40', 'Apifox', 1, 'Apifox', 'apifox', 'demo/api/apifox', NULL, NULL, 1, 1, 1, 'api', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (70, 3, '0,1,3', '角色新增', 4, NULL, '', NULL, 'sys:role:add', NULL, NULL, 1, 2, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (71, 3, '0,1,3', '角色编辑', 4, NULL, '', NULL, 'sys:role:edit', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (72, 3, '0,1,3', '角色删除', 4, NULL, '', NULL, 'sys:role:delete', NULL, NULL, 1, 4, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (73, 4, '0,1,4', '菜单新增', 4, NULL, '', NULL, 'sys:menu:add', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (74, 4, '0,1,4', '菜单编辑', 4, NULL, '', NULL, 'sys:menu:edit', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (75, 4, '0,1,4', '菜单删除', 4, NULL, '', NULL, 'sys:menu:delete', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (76, 5, '0,1,5', '部门新增', 4, NULL, '', NULL, 'sys:dept:add', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (77, 5, '0,1,5', '部门编辑', 4, NULL, '', NULL, 'sys:dept:edit', NULL, NULL, 1, 2, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (78, 5, '0,1,5', '部门删除', 4, NULL, '', NULL, 'sys:dept:delete', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (79, 6, '0,1,6', '字典新增', 4, NULL, '', NULL, 'sys:dict:add', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (81, 6, '0,1,6', '字典编辑', 4, NULL, '', NULL, 'sys:dict:edit', NULL, NULL, 1, 2, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (84, 6, '0,1,6', '字典删除', 4, NULL, '', NULL, 'sys:dict:delete', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (88, 2, '0,1,2', '重置密码', 4, NULL, '', NULL, 'sys:user:reset-password', NULL, NULL, 1, 4, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (89, 0, '0', '功能演示', 2, NULL, '/function', 'Layout', NULL, NULL, NULL, 1, 12, 'menu', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (90, 89, '0,89', 'Websocket', 1, 'WebSocket', '/function/websocket', 'demo/websocket', NULL, NULL, 1, 1, 3, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (95, 36, '0,36', '字典组件', 1, 'DictDemo', 'dict-demo', 'demo/dictionary', NULL, NULL, 1, 1, 4, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (97, 89, '0,89', 'Icons', 1, 'IconDemo', 'icon-demo', 'demo/icons', NULL, NULL, 1, 1, 2, 'el-icon-Notification', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (102, 26, '0,26', 'document', 3, NULL, 'internal-doc', 'demo/internal-doc', NULL, NULL, NULL, 1, 1, 'document', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (105, 2, '0,1,2', '用户查询', 4, NULL, '', NULL, 'sys:user:query', 0, 0, 1, 0, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (106, 2, '0,1,2', '用户导入', 4, NULL, '', NULL, 'sys:user:import', NULL, NULL, 1, 5, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (107, 2, '0,1,2', '用户导出', 4, NULL, '', NULL, 'sys:user:export', NULL, NULL, 1, 6, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (108, 36, '0,36', '增删改查', 1, 'Curd', 'curd', 'demo/curd/index', NULL, NULL, 1, 1, 0, '', '', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (109, 36, '0,36', '列表选择器', 1, 'TableSelect', 'table-select', 'demo/table-select/index', NULL, NULL, 1, 1, 1, '', '', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (110, 0, '0', '路由参数', 2, NULL, '/route-param', 'Layout', NULL, 1, 1, 1, 11, 'el-icon-ElementPlus', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (111, 110, '0,110', '参数(type=1)', 1, 'RouteParamType1', 'route-param-type1', 'demo/route-param', NULL, 0, 1, 1, 1, 'el-icon-Star', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', '{\"type\": \"1\"}');
INSERT INTO `sys_menu` VALUES (112, 110, '0,110', '参数(type=2)', 1, 'RouteParamType2', 'route-param-type2', 'demo/route-param', NULL, 0, 1, 1, 2, 'el-icon-StarFilled', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', '{\"type\": \"2\"}');
INSERT INTO `sys_menu` VALUES (117, 1, '0,1', '系统日志', 1, 'Log', 'log', 'system/log/index', NULL, 0, 1, 1, 6, 'document', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (118, 0, '0', '系统工具', 2, NULL, '/codegen', 'Layout', NULL, 0, 1, 1, 2, 'menu', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (119, 118, '0,118', '代码生成', 1, 'Codegen', 'codegen', 'codegen/index', NULL, 0, 1, 1, 1, 'code', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (120, 1, '0,1', '系统配置', 1, 'Config', 'config', 'system/config/index', NULL, 0, 1, 1, 7, 'setting', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (121, 120, '0,1,120', '系统配置查询', 4, NULL, '', NULL, 'sys:config:query', 0, 1, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (122, 120, '0,1,120', '系统配置新增', 4, NULL, '', NULL, 'sys:config:add', 0, 1, 1, 2, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (123, 120, '0,1,120', '系统配置修改', 4, NULL, '', NULL, 'sys:config:update', 0, 1, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (124, 120, '0,1,120', '系统配置删除', 4, NULL, '', NULL, 'sys:config:delete', 0, 1, 1, 4, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (125, 120, '0,1,120', '系统配置刷新', 4, NULL, '', NULL, 'sys:config:refresh', 0, 1, 1, 5, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (126, 1, '0,1', '通知公告', 1, 'Notice', 'notice', 'system/notice/index', NULL, NULL, NULL, 1, 9, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (127, 126, '0,1,126', '通知查询', 4, NULL, '', NULL, 'sys:notice:query', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (128, 126, '0,1,126', '通知新增', 4, NULL, '', NULL, 'sys:notice:add', NULL, NULL, 1, 2, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (129, 126, '0,1,126', '通知编辑', 4, NULL, '', NULL, 'sys:notice:edit', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (130, 126, '0,1,126', '通知删除', 4, NULL, '', NULL, 'sys:notice:delete', NULL, NULL, 1, 4, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (133, 126, '0,1,126', '通知发布', 4, NULL, '', NULL, 'sys:notice:publish', 0, 1, 1, 5, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (134, 126, '0,1,126', '通知撤回', 4, NULL, '', NULL, 'sys:notice:revoke', 0, 1, 1, 6, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (135, 1, '0,1', '字典项', 1, 'DictItem', 'dict-item', 'system/dict/dict-item', NULL, 0, 1, 0, 6, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (136, 135, '0,1,135', '字典项新增', 4, NULL, '', NULL, 'sys:dict-item:add', NULL, NULL, 1, 2, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (137, 135, '0,1,135', '字典项编辑', 4, NULL, '', NULL, 'sys:dict-item:edit', NULL, NULL, 1, 3, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (138, 135, '0,1,135', '字典项删除', 4, NULL, '', NULL, 'sys:dict-item:delete', NULL, NULL, 1, 4, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (139, 3, '0,1,3', '角色查询', 4, NULL, '', NULL, 'sys:role:query', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (140, 4, '0,1,4', '菜单查询', 4, NULL, '', NULL, 'sys:menu:query', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (141, 5, '0,1,5', '部门查询', 4, NULL, '', NULL, 'sys:dept:query', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (142, 6, '0,1,6', '字典查询', 4, NULL, '', NULL, 'sys:dict:query', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (143, 135, '0,1,135', '字典项查询', 4, NULL, '', NULL, 'sys:dict-item:query', NULL, NULL, 1, 1, '', NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (144, 26, '0,26', '后端文档', 3, NULL, 'https://youlai.blog.csdn.net/article/details/145178880', '', NULL, NULL, NULL, 1, 3, 'document', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (145, 26, '0,26', '移动端文档', 3, NULL, 'https://youlai.blog.csdn.net/article/details/143222890', '', NULL, NULL, NULL, 1, 4, 'document', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (146, 36, '0,36', '拖拽组件', 1, 'Drag', 'drag', 'demo/drag', NULL, NULL, NULL, 1, 5, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (147, 36, '0,36', '滚动文本', 1, 'TextScroll', 'text-scroll', 'demo/text-scroll', NULL, NULL, NULL, 1, 6, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (148, 89, '0,89', '字典实时同步', 1, 'DictSync', 'dict-sync', 'demo/dict-sync', NULL, NULL, NULL, 1, 3, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (149, 89, '0,89', 'VxeTable', 1, 'VxeTable', 'vxe-table', 'demo/vxe-table/index', NULL, NULL, 1, 1, 0, 'el-icon-MagicStick', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (150, 36, '0,36', '自适应表格操作列', 1, 'AutoOperationColumn', 'operation-column', 'demo/auto-operation-column', NULL, NULL, 1, 1, 1, '', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (151, 89, '0,89', 'CURD单文件', 1, 'CurdSingle', 'curd-single', 'demo/curd-single', NULL, NULL, 1, 1, 7, 'el-icon-Reading', '', '2025-11-24 15:32:02', '2025-11-24 15:32:02', NULL);
INSERT INTO `sys_menu` VALUES (152, 0, '0', '运营中心', 2, NULL, '/operation', 'Layout', NULL, 1, 1, 1, 1, 'juejin', '', '2025-12-01 10:56:44', '2025-12-01 10:58:12', NULL);
INSERT INTO `sys_menu` VALUES (153, 152, '0,152', '销售统计', 1, 'Sales', 'sales', 'operation/sales/index', NULL, 0, 1, 1, 1, 'el-icon-KnifeFork', NULL, '2025-12-01 11:03:19', '2025-12-01 11:03:19', NULL);
INSERT INTO `sys_menu` VALUES (154, 152, '0,152', '商品供应', 1, 'BizProducts', 'biz-products', 'products/biz-products/index', NULL, 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:18:54', '2025-12-01 11:18:54', NULL);
INSERT INTO `sys_menu` VALUES (155, 154, '0,152,154', '补货', 4, NULL, NULL, NULL, 'products:biz-products:fillrepo', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:20:19', '2025-12-01 11:20:19', NULL);
INSERT INTO `sys_menu` VALUES (156, 154, '0,152,154', '查询', 4, NULL, NULL, NULL, 'products:biz-products:query', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:34:04', '2025-12-01 11:34:04', NULL);
INSERT INTO `sys_menu` VALUES (157, 154, '0,152,154', '新增', 4, NULL, NULL, NULL, 'products:biz-products:add', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:34:27', '2025-12-01 11:34:27', NULL);
INSERT INTO `sys_menu` VALUES (158, 154, '0,152,154', '编辑', 4, NULL, NULL, NULL, 'products:biz-products:edit', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:34:50', '2025-12-01 11:34:50', NULL);
INSERT INTO `sys_menu` VALUES (159, 0, '0', '购物管理', 2, NULL, '/shopping', 'Layout', NULL, 0, 1, 1, 1, 'wechat', NULL, '2025-12-01 11:41:10', '2025-12-01 11:41:10', NULL);
INSERT INTO `sys_menu` VALUES (160, 159, '0,159', '商品选购', 1, 'Shop', 'shop', 'shopping/shop/index', NULL, 0, 1, 1, 1, 'bilibili', NULL, '2025-12-01 11:42:18', '2025-12-01 11:42:18', NULL);
INSERT INTO `sys_menu` VALUES (161, 159, '0,159', '订单管理', 1, 'Order', 'order', 'shopping/order/index', NULL, 0, 1, 1, 1, 'file', NULL, '2025-12-01 11:43:32', '2025-12-01 11:43:32', NULL);
INSERT INTO `sys_menu` VALUES (162, 161, '0,159,161', '查询', 4, NULL, NULL, NULL, 'shopping:t-order:query', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:44:37', '2025-12-01 11:44:37', NULL);
INSERT INTO `sys_menu` VALUES (163, 161, '0,159,161', '新增', 4, NULL, NULL, NULL, 'shopping:t-order:add', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:45:13', '2025-12-01 11:45:13', NULL);
INSERT INTO `sys_menu` VALUES (164, 161, '0,159,161', '编辑', 4, NULL, NULL, NULL, 'shopping:t-order:edit', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:45:35', '2025-12-01 11:45:35', NULL);
INSERT INTO `sys_menu` VALUES (165, 161, '0,159,161', '删除', 4, NULL, NULL, NULL, 'shopping:t-order:delete', 0, 1, 1, 1, NULL, NULL, '2025-12-01 11:45:53', '2025-12-01 11:45:53', NULL);

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '通知内容',
  `type` tinyint NOT NULL COMMENT '通知类型（关联字典编码：notice_type）',
  `level` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知等级（字典code：notice_level）',
  `target_type` tinyint NOT NULL COMMENT '目标类型（1: 全体, 2: 指定）',
  `target_user_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目标人ID集合（多个使用英文逗号,分割）',
  `publisher_id` bigint NULL DEFAULT NULL COMMENT '发布人ID',
  `publish_status` tinyint NULL DEFAULT 0 COMMENT '发布状态（0: 未发布, 1: 已发布, -1: 已撤回）',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `revoke_time` datetime NULL DEFAULT NULL COMMENT '撤回时间',
  `create_by` bigint NOT NULL COMMENT '创建人ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除（0: 未删除, 1: 已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, 'v2.12.0 新增系统日志，访问趋势统计功能。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 1, 'L', 1, '2', 1, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (2, 'v2.13.0 新增菜单搜索。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 1, 'L', 1, '2', 1, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 1, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (3, 'v2.14.0 新增个人中心。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 1, 'L', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (4, 'v2.15.0 登录页面改造。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 1, 'L', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (5, 'v2.16.0 通知公告、字典翻译组件。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 1, 'L', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (6, '系统将于本周六凌晨 2 点进行维护，预计维护时间为 2 小时。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 2, 'H', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (7, '最近发现一些钓鱼邮件，请大家提高警惕，不要点击陌生链接。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 3, 'L', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (8, '国庆假期从 10 月 1 日至 10 月 7 日放假，共 7 天。', '<p>1. 消息通知</p><p>2. 字典重构</p><p>3. 代码生成</p>', 4, 'L', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (9, '公司将在 10 月 15 日举办新产品发布会，敬请期待。', '公司将在 10 月 15 日举办新产品发布会，敬请期待。', 5, 'H', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_notice` VALUES (10, 'v2.16.1 版本发布。', 'v2.16.1 版本修复了 WebSocket 重复连接导致的后台线程阻塞问题，优化了通知公告。', 1, 'M', 1, '2', 2, 1, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 2, '2025-11-24 15:32:02', 0);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `sort` int NULL DEFAULT NULL COMMENT '显示顺序',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '角色状态(1-正常 0-停用)',
  `data_scope` tinyint NULL DEFAULT NULL COMMENT '数据权限(1-所有数据 2-部门及子部门数据 3-本部门数据 4-本人数据)',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人 ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除标识(0-未删除 1-已删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name` ASC) USING BTREE COMMENT '角色名称唯一索引',
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE COMMENT '角色编码唯一索引'
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'ROOT', 1, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-11-24 15:32:02', 0);
INSERT INTO `sys_role` VALUES (2, '系统管理员（水厂）', 'ADMIN', 2, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:26:21', 0);
INSERT INTO `sys_role` VALUES (3, '消费用户', 'GUEST', 3, 1, 3, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:52', 0);
INSERT INTO `sys_role` VALUES (4, '系统管理员1', 'ADMIN1', 4, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:11', 1);
INSERT INTO `sys_role` VALUES (5, '系统管理员2', 'ADMIN2', 5, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:13', 1);
INSERT INTO `sys_role` VALUES (6, '系统管理员3', 'ADMIN3', 6, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:15', 1);
INSERT INTO `sys_role` VALUES (7, '系统管理员4', 'ADMIN4', 7, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:18', 1);
INSERT INTO `sys_role` VALUES (8, '系统管理员5', 'ADMIN5', 8, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:21', 1);
INSERT INTO `sys_role` VALUES (9, '系统管理员6', 'ADMIN6', 9, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:24', 1);
INSERT INTO `sys_role` VALUES (10, '系统管理员7', 'ADMIN7', 10, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:26', 1);
INSERT INTO `sys_role` VALUES (11, '系统管理员8', 'ADMIN8', 11, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:30', 1);
INSERT INTO `sys_role` VALUES (12, '系统管理员9', 'ADMIN9', 12, 1, 1, NULL, '2025-11-24 15:32:02', NULL, '2025-12-01 10:25:32', 1);
INSERT INTO `sys_role` VALUES (13, '水站管理员', 'ADMIN_DEPT_STATION', 1, 1, 2, NULL, '2025-11-28 14:29:41', NULL, '2025-12-01 14:52:48', 0);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  UNIQUE INDEX `uk_roleid_menuid`(`role_id` ASC, `menu_id` ASC) USING BTREE COMMENT '角色菜单唯一索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 5);
INSERT INTO `sys_role_menu` VALUES (2, 6);
INSERT INTO `sys_role_menu` VALUES (2, 20);
INSERT INTO `sys_role_menu` VALUES (2, 21);
INSERT INTO `sys_role_menu` VALUES (2, 22);
INSERT INTO `sys_role_menu` VALUES (2, 23);
INSERT INTO `sys_role_menu` VALUES (2, 24);
INSERT INTO `sys_role_menu` VALUES (2, 26);
INSERT INTO `sys_role_menu` VALUES (2, 30);
INSERT INTO `sys_role_menu` VALUES (2, 31);
INSERT INTO `sys_role_menu` VALUES (2, 32);
INSERT INTO `sys_role_menu` VALUES (2, 33);
INSERT INTO `sys_role_menu` VALUES (2, 36);
INSERT INTO `sys_role_menu` VALUES (2, 37);
INSERT INTO `sys_role_menu` VALUES (2, 38);
INSERT INTO `sys_role_menu` VALUES (2, 39);
INSERT INTO `sys_role_menu` VALUES (2, 40);
INSERT INTO `sys_role_menu` VALUES (2, 41);
INSERT INTO `sys_role_menu` VALUES (2, 70);
INSERT INTO `sys_role_menu` VALUES (2, 71);
INSERT INTO `sys_role_menu` VALUES (2, 72);
INSERT INTO `sys_role_menu` VALUES (2, 73);
INSERT INTO `sys_role_menu` VALUES (2, 74);
INSERT INTO `sys_role_menu` VALUES (2, 75);
INSERT INTO `sys_role_menu` VALUES (2, 76);
INSERT INTO `sys_role_menu` VALUES (2, 77);
INSERT INTO `sys_role_menu` VALUES (2, 78);
INSERT INTO `sys_role_menu` VALUES (2, 79);
INSERT INTO `sys_role_menu` VALUES (2, 81);
INSERT INTO `sys_role_menu` VALUES (2, 84);
INSERT INTO `sys_role_menu` VALUES (2, 88);
INSERT INTO `sys_role_menu` VALUES (2, 89);
INSERT INTO `sys_role_menu` VALUES (2, 90);
INSERT INTO `sys_role_menu` VALUES (2, 95);
INSERT INTO `sys_role_menu` VALUES (2, 97);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 118);
INSERT INTO `sys_role_menu` VALUES (2, 119);
INSERT INTO `sys_role_menu` VALUES (2, 120);
INSERT INTO `sys_role_menu` VALUES (2, 121);
INSERT INTO `sys_role_menu` VALUES (2, 122);
INSERT INTO `sys_role_menu` VALUES (2, 123);
INSERT INTO `sys_role_menu` VALUES (2, 124);
INSERT INTO `sys_role_menu` VALUES (2, 125);
INSERT INTO `sys_role_menu` VALUES (2, 126);
INSERT INTO `sys_role_menu` VALUES (2, 127);
INSERT INTO `sys_role_menu` VALUES (2, 128);
INSERT INTO `sys_role_menu` VALUES (2, 129);
INSERT INTO `sys_role_menu` VALUES (2, 130);
INSERT INTO `sys_role_menu` VALUES (2, 133);
INSERT INTO `sys_role_menu` VALUES (2, 134);
INSERT INTO `sys_role_menu` VALUES (2, 135);
INSERT INTO `sys_role_menu` VALUES (2, 136);
INSERT INTO `sys_role_menu` VALUES (2, 137);
INSERT INTO `sys_role_menu` VALUES (2, 138);
INSERT INTO `sys_role_menu` VALUES (2, 139);
INSERT INTO `sys_role_menu` VALUES (2, 140);
INSERT INTO `sys_role_menu` VALUES (2, 141);
INSERT INTO `sys_role_menu` VALUES (2, 142);
INSERT INTO `sys_role_menu` VALUES (2, 143);
INSERT INTO `sys_role_menu` VALUES (2, 144);
INSERT INTO `sys_role_menu` VALUES (2, 145);
INSERT INTO `sys_role_menu` VALUES (2, 146);
INSERT INTO `sys_role_menu` VALUES (2, 147);
INSERT INTO `sys_role_menu` VALUES (2, 148);
INSERT INTO `sys_role_menu` VALUES (2, 149);
INSERT INTO `sys_role_menu` VALUES (2, 150);
INSERT INTO `sys_role_menu` VALUES (2, 151);
INSERT INTO `sys_role_menu` VALUES (2, 152);
INSERT INTO `sys_role_menu` VALUES (2, 153);
INSERT INTO `sys_role_menu` VALUES (2, 154);
INSERT INTO `sys_role_menu` VALUES (2, 155);
INSERT INTO `sys_role_menu` VALUES (2, 156);
INSERT INTO `sys_role_menu` VALUES (2, 157);
INSERT INTO `sys_role_menu` VALUES (2, 158);
INSERT INTO `sys_role_menu` VALUES (2, 159);
INSERT INTO `sys_role_menu` VALUES (2, 160);
INSERT INTO `sys_role_menu` VALUES (2, 161);
INSERT INTO `sys_role_menu` VALUES (2, 162);
INSERT INTO `sys_role_menu` VALUES (2, 163);
INSERT INTO `sys_role_menu` VALUES (2, 164);
INSERT INTO `sys_role_menu` VALUES (2, 165);
INSERT INTO `sys_role_menu` VALUES (13, 1);
INSERT INTO `sys_role_menu` VALUES (13, 2);
INSERT INTO `sys_role_menu` VALUES (13, 5);
INSERT INTO `sys_role_menu` VALUES (13, 105);
INSERT INTO `sys_role_menu` VALUES (13, 141);
INSERT INTO `sys_role_menu` VALUES (13, 152);
INSERT INTO `sys_role_menu` VALUES (13, 153);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `gender` tinyint(1) NULL DEFAULT 1 COMMENT '性别((1-男 2-女 0-保密)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `dept_id` int NULL DEFAULT NULL COMMENT '部门ID',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户头像',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态(1-正常 0-禁用)',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户邮箱',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '修改人ID',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除标识(0-未删除 1-已删除)',
  `openid` char(28) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信 openid',
  `remaining_sum` decimal(18, 2) NOT NULL DEFAULT 0.00 COMMENT '账户余额（BigDecimal类型）',
  `latest_consume_time` timestamp NULL DEFAULT NULL COMMENT '最近消费时间（LocalDateTime类型）',
  `latest_consume_cost` decimal(18, 2) NOT NULL DEFAULT 0.00 COMMENT '最近消费金额（BigDecimal类型）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `login_name`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'root', '有来技术', 0, '$2a$10$xVWsNOhHrCxh5UbpCE7/HuJ.PAOKcYAqRxD2CO2nVnJS.IAXkr5aq', NULL, 'https://foruda.gitee.com/images/1723603502796844527/03cdca2a_716974.gif', '18812345677', 1, 'youlaitech@163.com', '2025-11-24 15:32:02', NULL, '2025-11-24 15:32:02', NULL, 0, NULL, 0.00, '2025-11-28 11:11:48', 0.00);
INSERT INTO `sys_user` VALUES (2, 'admin', '系统管理员', 1, '$2a$10$xVWsNOhHrCxh5UbpCE7/HuJ.PAOKcYAqRxD2CO2nVnJS.IAXkr5aq', 1, 'https://foruda.gitee.com/images/1723603502796844527/03cdca2a_716974.gif', '18812345678', 1, 'youlaitech@163.com', '2025-11-24 15:32:02', NULL, '2025-12-01 14:57:14', 2, 0, NULL, 8888.00, '2025-11-28 11:13:16', 1.00);
INSERT INTO `sys_user` VALUES (3, 'test', '测试小用户', 1, '$2a$10$xVWsNOhHrCxh5UbpCE7/HuJ.PAOKcYAqRxD2CO2nVnJS.IAXkr5aq', 3, 'https://foruda.gitee.com/images/1723603502796844527/03cdca2a_716974.gif', '18812345679', 1, 'youlaitech@163.com', '2025-11-24 15:32:02', NULL, '2025-12-01 14:57:03', 2, 0, NULL, 0.00, NULL, 0.00);
INSERT INTO `sys_user` VALUES (4, 'water', '水站管理员', 2, '$2a$10$Tkv9bdnwYy2Gcel1rqKr3eiqPMW1xUu6DcMgtgX.gbaxLIE9Qzgaa', 2, NULL, '13822123456', 1, '3317296587@qq.com', '2025-12-01 10:36:50', 2, '2025-12-01 14:57:08', 2, 0, NULL, 0.00, NULL, 0.00);
INSERT INTO `sys_user` VALUES (6, 'gee', 'gee', 1, '$2a$10$xhy/fgbsAXyRAxYn5E/Z6OcrEmVHgsMQDgc2KEByEPkgKojGTKIrC', 1, NULL, '19055654895', 1, 'manbaoout@163.com', '2025-12-02 11:24:17', 2, '2025-12-02 11:24:17', NULL, 0, NULL, 0.00, NULL, 0.00);

-- ----------------------------
-- Table structure for sys_user_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_notice`;
CREATE TABLE `sys_user_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `notice_id` bigint NOT NULL COMMENT '公共通知id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `is_read` bigint NULL DEFAULT 0 COMMENT '读取状态（0: 未读, 1: 已读）',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint NULL DEFAULT 0 COMMENT '逻辑删除(0: 未删除, 1: 已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_notice
-- ----------------------------
INSERT INTO `sys_user_notice` VALUES (1, 1, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (2, 2, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (3, 3, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (4, 4, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (5, 5, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (6, 6, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (7, 7, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (8, 8, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (9, 9, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);
INSERT INTO `sys_user_notice` VALUES (10, 10, 2, 1, NULL, '2025-11-24 15:32:02', '2025-11-24 15:32:02', 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (3, 3);
INSERT INTO `sys_user_role` VALUES (4, 13);
INSERT INTO `sys_user_role` VALUES (6, 13);

-- ----------------------------
-- Table structure for t_goods
-- ----------------------------
DROP TABLE IF EXISTS `t_goods`;
CREATE TABLE `t_goods`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品ID',
  `category` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品类别（家电、食品、日用）',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名称',
  `made_address` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '产地',
  `price` float NOT NULL DEFAULT 0 COMMENT '单价',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_goods
-- ----------------------------
INSERT INTO `t_goods` VALUES ('080b2adca01db6515ddb079a434c3764', '食品', '雪梨', '广州', 13);

SET FOREIGN_KEY_CHECKS = 1;
