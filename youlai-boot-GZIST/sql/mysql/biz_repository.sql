CREATE TABLE `biz_repository` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '关系记录唯一标识符',
	`department_id` BIGINT UNSIGNED NOT NULL COMMENT '部门ID，外键关联部门表',
	`product_id` BIGINT UNSIGNED NOT NULL COMMENT '产品ID，外键关联产品表',
	`current_quantity` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT '当前库存数量',
	`order_quantity_total` INT UNSIGNED NULL DEFAULT '0' COMMENT '累计订购数量',
	`order_date_latest` DATETIME NULL DEFAULT NULL COMMENT '最近订购日期',
	`create_time` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP) COMMENT '记录创建时间',
	`update_time` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
	`create_by` BIGINT NULL DEFAULT NULL,
	`update_by` BIGINT NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uk_department_product` (`department_id`, `product_id`) USING BTREE,
	INDEX `idx_department` (`department_id`) USING BTREE,
	INDEX `idx_product` (`product_id`) USING BTREE,
	INDEX `idx_stock_level` (`current_quantity`) USING BTREE
)
COMMENT='部门产品库存与订购关系表'
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
