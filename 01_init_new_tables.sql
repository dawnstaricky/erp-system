-- ============================================================
-- ERP 重构 · 第 1 批：新建表（多公司隔离 + 新业务模块）
-- 执行方式：Navicat 打开 → 全选 → 运行（零风险，只 CREATE）
-- 前置：已备份 erp_db（mysqldump 或 Navicat 转储）
-- ============================================================
SET NAMES utf8mb4;

-- ------------------------------------------------------------
-- 1. 公司/抬头管理表
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `sys_company`;
CREATE TABLE `sys_company` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公司ID',
  `company_code` varchar(50) NOT NULL COMMENT '公司编码',
  `company_name` varchar(200) NOT NULL COMMENT '公司名称（抬头）',
  `legal_person` varchar(50) DEFAULT NULL COMMENT '法定代表人',
  `tax_number` varchar(50) DEFAULT NULL COMMENT '统一社会信用代码/税号',
  `contact_person` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `province` varchar(50) DEFAULT NULL COMMENT '省',
  `city` varchar(50) DEFAULT NULL COMMENT '市',
  `address` varchar(300) DEFAULT NULL COMMENT '详细地址',
  `bank_name` varchar(100) DEFAULT NULL COMMENT '开户银行',
  `bank_account` varchar(50) DEFAULT NULL COMMENT '银行账号',
  `status` tinyint DEFAULT 1 COMMENT '1-正常 0-停用',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_company_code` (`company_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公司/抬头管理表';

-- 初始化三家公司（信息占位，可在「公司管理」中修改）
INSERT INTO `sys_company` (`id`, `company_code`, `company_name`, `legal_person`, `tax_number`, `address_phone`, `bank_account`, `status`) VALUES
(1, 'SS',  '上海升顺供应链管理有限公司', '', '', '', '', 1),
(2, 'LY',  '上海岚页科技有限公司',       '', '', '', '', 1),
(3, 'YZ',  '上海悦竹屿科技有限公司',     '', '', '', '', 1);

-- ------------------------------------------------------------
-- 2. 用户-公司-角色关联表（替代 user_role / sys_user_role）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `sys_user_company_role`;
CREATE TABLE `sys_user_company_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `company_id` bigint NOT NULL COMMENT '公司ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `is_main` tinyint DEFAULT 1 COMMENT '是否主公司：1-是 0-否',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_company_role` (`user_id`, `company_id`, `role_id`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户-公司-角色关联表';

-- 迁移现有 user_role 数据到新表（company_id 默认 1）
INSERT INTO `sys_user_company_role` (`user_id`, `company_id`, `role_id`, `is_main`)
SELECT `user_id`, 1, `role_id`, 1 FROM `user_role`;

-- 迁移完成后确认条数一致，再删除旧表（手动执行，脚本不自动删）
-- SELECT COUNT(*) FROM user_role;
-- SELECT COUNT(*) FROM sys_user_company_role;
-- DROP TABLE user_role;
-- DROP TABLE sys_user_role;

-- ------------------------------------------------------------
-- 3. 采购合同 + 明细（对齐采购合同模板）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `purchase_contract`;
CREATE TABLE `purchase_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `contract_no` varchar(50) NOT NULL COMMENT '合同编号，如 XL-XZL260824',
  `company_id` bigint NOT NULL COMMENT '我方公司ID',
  `supplier_id` bigint NOT NULL COMMENT '供应商ID',
  `order_id` bigint DEFAULT NULL COMMENT '关联的采购订单ID',
  `sign_date` date DEFAULT NULL COMMENT '签订日期',
  `total_amount` decimal(14,2) DEFAULT 0 COMMENT '合同总额',
  `tax_rate` decimal(5,2) DEFAULT 13 COMMENT '税率',
  `tax_amount` decimal(14,2) DEFAULT 0 COMMENT '税额',
  `is_tax_included` tinyint DEFAULT 0 COMMENT '1-含税 0-不含税',
  `delivery_method` varchar(20) DEFAULT '自提' COMMENT '交货方式：自提/送货',
  `payment_terms` varchar(500) DEFAULT NULL COMMENT '付款方式',
  `delivery_period` varchar(200) DEFAULT NULL COMMENT '交货期限',
  `status` tinyint DEFAULT 0 COMMENT '0-草稿 1-已签章 2-已作废',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_no` (`contract_no`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购合同表';

DROP TABLE IF EXISTS `purchase_contract_item`;
CREATE TABLE `purchase_contract_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `contract_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `product_name` varchar(200) DEFAULT NULL,
  `material` varchar(100) DEFAULT NULL COMMENT '材质',
  `spec` varchar(200) DEFAULT NULL COMMENT '规格',
  `origin` varchar(100) DEFAULT NULL COMMENT '产地/钢厂',
  `hardness` varchar(50) DEFAULT NULL COMMENT '硬度',
  `tin_layer` varchar(50) DEFAULT NULL COMMENT '锡层',
  `coil_no` varchar(100) DEFAULT NULL COMMENT '卷号',
  `quantity` int DEFAULT 0,
  `unit` varchar(20) DEFAULT NULL,
  `unit_price` decimal(14,2) DEFAULT 0,
  `amount` decimal(14,2) DEFAULT 0,
  `remark` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_contract_id` (`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购合同明细';

-- ------------------------------------------------------------
-- 4. 销售合同 + 明细（结构对称，supplier_id → customer_id）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `sales_contract`;
CREATE TABLE `sales_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `contract_no` varchar(50) NOT NULL COMMENT '合同编号，如 SS2026090303-01',
  `company_id` bigint NOT NULL COMMENT '我方公司ID',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `order_id` bigint DEFAULT NULL COMMENT '关联的销售订单ID',
  `sign_date` date DEFAULT NULL,
  `total_amount` decimal(14,2) DEFAULT 0,
  `tax_rate` decimal(5,2) DEFAULT 13,
  `tax_amount` decimal(14,2) DEFAULT 0,
  `is_tax_included` tinyint DEFAULT 1 COMMENT '销售合同默认含税',
  `delivery_method` varchar(20) DEFAULT '送货' COMMENT '交货方式：自提/送货',
  `payment_terms` varchar(500) DEFAULT NULL,
  `delivery_period` varchar(200) DEFAULT NULL,
  `status` tinyint DEFAULT 0 COMMENT '0-草稿 1-已签章 2-已作废',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_no` (`contract_no`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售合同表';

DROP TABLE IF EXISTS `sales_contract_item`;
CREATE TABLE `sales_contract_item` LIKE `purchase_contract_item`;

-- ------------------------------------------------------------
-- 5. 销售开票登记表（绑定销售订单）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `invoice`;
CREATE TABLE `invoice` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `invoice_no` varchar(50) NOT NULL COMMENT '发票号码',
  `company_id` bigint NOT NULL COMMENT '开票方公司ID',
  `customer_id` bigint NOT NULL COMMENT '购方（客户）',
  `order_id` bigint NOT NULL COMMENT '关联销售订单ID',
  `order_no` varchar(50) DEFAULT NULL,
  `invoice_type` varchar(20) DEFAULT '增值税专用' COMMENT '发票类型',
  `invoice_date` date DEFAULT NULL,
  `total_amount` decimal(14,2) DEFAULT 0 COMMENT '开票金额（须 ≤ 订单未开票金额）',
  `tax_rate` decimal(5,2) DEFAULT 13,
  `status` tinyint DEFAULT 1 COMMENT '1-正常 2-作废/红冲',
  `file_url` varchar(255) DEFAULT NULL COMMENT '发票附件',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_no` (`invoice_no`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售开票登记表';

-- ------------------------------------------------------------
-- 6. 销售回款登记表
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `receipt`;
CREATE TABLE `receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `receipt_no` varchar(50) NOT NULL COMMENT '回款单号',
  `company_id` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL COMMENT '核销的销售订单ID（空=预收款）',
  `receipt_date` date DEFAULT NULL,
  `amount` decimal(14,2) DEFAULT 0 COMMENT '回款金额',
  `payment_method` varchar(20) DEFAULT NULL COMMENT '收款方式：银行转账/承兑/现金',
  `bank_account` varchar(100) DEFAULT NULL,
  `unallocated_amount` decimal(14,2) DEFAULT 0 COMMENT '未核销余额',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receipt_no` (`receipt_no`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售回款登记表';

-- ------------------------------------------------------------
-- 7. 业务闭环归档表（严格五环节）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `business_archive`;
CREATE TABLE `business_archive` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `company_id` bigint NOT NULL,
  `order_id` bigint NOT NULL COMMENT '销售订单ID',
  `order_no` varchar(50) DEFAULT NULL,
  `customer_id` bigint DEFAULT NULL,
  `purchase_done` tinyint DEFAULT 0 COMMENT '采购入库完成',
  `sale_draft_done` tinyint DEFAULT 0 COMMENT '销售开单完成',
  `outbound_done` tinyint DEFAULT 0 COMMENT '商品出库完成',
  `invoice_done` tinyint DEFAULT 0 COMMENT '全额开票完成',
  `receipt_done` tinyint DEFAULT 0 COMMENT '全额回款完成',
  `is_archived` tinyint DEFAULT 0 COMMENT '1-已归档 0-未归档',
  `archived_at` datetime DEFAULT NULL,
  `auto_unarchived` tinyint DEFAULT 0 COMMENT '是否因撤销/作废自动退出归档',
  `unarchive_reason` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order` (`company_id`, `order_id`),
  KEY `idx_is_archived` (`is_archived`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务闭环归档表';

-- ------------------------------------------------------------
-- 8. 质量异议表（自动联动财务扣款，带明细）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `quality_dispute`;
CREATE TABLE `quality_dispute` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dispute_no` varchar(50) NOT NULL COMMENT '异议单号',
  `company_id` bigint NOT NULL,
  `dispute_type` tinyint NOT NULL COMMENT '1-来料(采购侧) 2-销售(客户投诉)',
  `supplier_id` bigint DEFAULT NULL COMMENT '采购侧：责任供应商',
  `customer_id` bigint DEFAULT NULL COMMENT '销售侧：投诉客户',
  `order_id` bigint DEFAULT NULL COMMENT '关联订单',
  `product_id` bigint DEFAULT NULL,
  `contract_no` varchar(50) DEFAULT NULL,
  `quantity` int DEFAULT 0 COMMENT '异议数量',
  `claim_amount` decimal(14,2) DEFAULT 0 COMMENT '索赔金额',
  `description` varchar(1000) DEFAULT NULL COMMENT '异议描述',
  `evidence_urls` varchar(1000) DEFAULT NULL COMMENT '附件URL，逗号分隔',
  `handle_method` varchar(500) DEFAULT NULL COMMENT '处理方案',
  `finance_adjusted` tinyint DEFAULT 0 COMMENT '是否已联动财务扣款：1-是',
  `adjust_type` varchar(20) DEFAULT NULL COMMENT '抵扣类型：扣减应付/减免应收/退款',
  `adjusted_amount` decimal(14,2) DEFAULT 0 COMMENT '联动金额',
  `adjusted_bill_no` varchar(50) DEFAULT NULL COMMENT '关联的应付/应收账单号',
  `adjust_remark` varchar(500) DEFAULT NULL COMMENT '扣款明细说明',
  `status` tinyint DEFAULT 0 COMMENT '0-待处理 1-已处理',
  `handler_id` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dispute_no` (`dispute_no`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_dispute_type` (`dispute_type`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='质量异议表';

-- ------------------------------------------------------------
-- 9. 商品/单据补字段：交货方式字典表（自提/送货）
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `dict_delivery_method`;
CREATE TABLE `dict_delivery_method` (
  `code` varchar(20) NOT NULL COMMENT '自提/送货',
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='交货方式字典';
INSERT INTO `dict_delivery_method` VALUES ('自提','自提'), ('送货','送货');
