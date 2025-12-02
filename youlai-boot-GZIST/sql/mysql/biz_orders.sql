CREATE TABLE `biz_orders` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单唯一标识符',
	`repo_id` INT UNSIGNED NOT NULL COMMENT '站点ID，外键关联部门表',
	`user_id` INT UNSIGNED NOT NULL COMMENT '用户ID，外键关联用户表',
	`quantity` INT UNSIGNED NOT NULL COMMENT '购买数量',
	`unit_price` DECIMAL(10,2) UNSIGNED NOT NULL COMMENT '商品单价（下单时价格）',
	`total_amount` DECIMAL(10,2) UNSIGNED NOT NULL COMMENT '订单总金额',
	`delivery_fee` DECIMAL(10,2) UNSIGNED NULL DEFAULT '0.00' COMMENT '配送费用',
	`order_date` DATETIME NOT NULL COMMENT '订单日期（下单时间）',
	`delivery_date` DATETIME NULL DEFAULT NULL COMMENT '配送/自提日期',
	`delivery_type` ENUM('self_pickup','home_delivery') NOT NULL DEFAULT 'self_pickup' COMMENT '配送方式：自提/送货上门' COLLATE 'utf8mb4_unicode_ci',
	`delivery_time_slot` VARCHAR(50) NULL DEFAULT NULL COMMENT '配送时段' COLLATE 'utf8mb4_unicode_ci',
	`payment_method` ENUM('wechat','alipay','cash','balance') NOT NULL DEFAULT 'wechat' COMMENT '支付方式' COLLATE 'utf8mb4_unicode_ci',
	`payment_status` ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending' COMMENT '支付状态' COLLATE 'utf8mb4_unicode_ci',
	`order_status` ENUM('pending','confirmed','preparing','delivering','completed','cancelled') NOT NULL DEFAULT 'pending' COMMENT '订单状态' COLLATE 'utf8mb4_unicode_ci',
	`delivery_address` TEXT NULL DEFAULT NULL COMMENT '配送地址' COLLATE 'utf8mb4_unicode_ci',
	`customer_notes` TEXT NULL DEFAULT NULL COMMENT '客户备注' COLLATE 'utf8mb4_unicode_ci',
	`create_by` INT UNSIGNED NOT NULL COMMENT '记录创建人（用户ID）',
	`create_time` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP) COMMENT '记录创建时间',
	`update_by` INT UNSIGNED NULL DEFAULT NULL COMMENT '记录最后修改人',
	`update_time` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后修改时间',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `idx_department` (`repo_id`) USING BTREE,
	INDEX `idx_user` (`user_id`) USING BTREE,
	INDEX `idx_order_date` (`order_date`) USING BTREE,
	INDEX `idx_order_status` (`order_status`) USING BTREE,
	INDEX `idx_payment_status` (`payment_status`) USING BTREE,
	INDEX `idx_created_by` (`create_by`) USING BTREE
)
COMMENT='订单表'
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
