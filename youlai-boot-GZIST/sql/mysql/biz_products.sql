CREATE TABLE `biz_products` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商品唯一标识符',
	`name` VARCHAR(255) NOT NULL COMMENT '商品名称（如：XX品牌 18.9L 桶装纯净水）' COLLATE 'utf8mb4_unicode_ci',
	`specification` VARCHAR(100) NOT NULL COMMENT '商品规格（如：18.9升/桶）' COLLATE 'utf8mb4_unicode_ci',
	`origin` VARCHAR(100) NOT NULL COMMENT '产地' COLLATE 'utf8mb4_unicode_ci',
	`production_date` DATE NOT NULL COMMENT '生产日期',
	`expiration_date` DATE NOT NULL COMMENT '保质日期',
	`unit_price` DECIMAL(10,2) UNSIGNED NOT NULL COMMENT '单价（元）',
	`description` TEXT NULL DEFAULT NULL COMMENT '商品详细介绍' COLLATE 'utf8mb4_unicode_ci',
	`image_preview` VARCHAR(500) NULL DEFAULT NULL COMMENT '商品预览图片的存储路径或URL' COLLATE 'utf8mb4_unicode_ci',
	`create_time` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP) COMMENT '记录创建时间',
	`update_time` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP COMMENT '记录最后更新时间',
	`create_by` BIGINT NULL DEFAULT NULL COMMENT '记录创建人',
	`update_by` BIGINT NULL DEFAULT NULL COMMENT '记录最后修改人',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `idx_name` (`name`) USING BTREE,
	INDEX `idx_origin` (`origin`) USING BTREE,
	INDEX `idx_expiration` (`expiration_date`) USING BTREE
)
COMMENT='商品信息表（用于管理水产品）'
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;
