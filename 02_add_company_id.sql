-- ============================================================
-- ERP 重构 · 第 2 批：旧表加 company_id（隔离生效的关键）
-- ⚠️ 执行方式：Navicat 里【一条一条】跑，每跑完一条 SELECT 验证
-- ⚠️ 务必在 BEGIN/COMMIT 事务里，或全部确认无误再提交
-- 前置：已执行 01_init_new_tables.sql，且 sys_company 已有 id=1 默认主体
-- ============================================================
-- ROLLBACK;

START TRANSACTION;

-- 主数据
ALTER TABLE `supplier`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `remark`,
  ADD KEY `idx_company_id` (`company_id`);

ALTER TABLE `customer`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `customer_code`,
  ADD KEY `idx_company_id` (`company_id`);

ALTER TABLE `product`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID',
  ADD COLUMN `hardness` varchar(50) DEFAULT NULL COMMENT '硬度' AFTER `spec`,
  ADD COLUMN `tin_layer` varchar(50) DEFAULT NULL COMMENT '锡层' AFTER `hardness`,
  ADD COLUMN `coil_no` varchar(100) DEFAULT NULL COMMENT '钢卷号' AFTER `tin_layer`,
  ADD COLUMN `steel_mill` varchar(100) DEFAULT NULL COMMENT '钢厂/产地' AFTER `coil_no`,
  ADD COLUMN `grade` varchar(50) DEFAULT NULL COMMENT '等级' AFTER `steel_mill`,
  ADD COLUMN `stock_in_date` date DEFAULT NULL COMMENT '入库日期' AFTER `grade`,
  ADD COLUMN `delivery_method` varchar(20) DEFAULT '自提' COMMENT '交货方式：自提/送货' AFTER `stock_in_date`,
  ADD KEY `idx_company_id` (`company_id`);

ALTER TABLE `warehouse`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `remark`,
  ADD KEY `idx_company_id` (`company_id`);

-- 业务单据
ALTER TABLE `purchase_order`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `status`,
  ADD COLUMN `contract_no` varchar(50) DEFAULT NULL COMMENT '关联采购合同编号' AFTER `company_id`,
  ADD COLUMN `delivery_method` varchar(20) DEFAULT '自提' COMMENT '交货方式' AFTER `contract_no`,
  ADD COLUMN `is_tax_included` tinyint DEFAULT 0 COMMENT '1-含税 0-不含税' AFTER `delivery_method`,
  ADD KEY `idx_company_id` (`company_id`);

ALTER TABLE `sales_order`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `status`,
  ADD COLUMN `contract_no` varchar(50) DEFAULT NULL COMMENT '关联销售合同编号' AFTER `company_id`,
  ADD COLUMN `delivery_method` varchar(20) DEFAULT '送货' COMMENT '交货方式' AFTER `contract_no`,
  ADD COLUMN `is_tax_included` tinyint DEFAULT 1 COMMENT '1-含税 0-不含税' AFTER `delivery_method`,
  ADD KEY `idx_company_id` (`company_id`);

-- 单据明细也冗余交货信息（便于生成合同，避免回查主表）
ALTER TABLE `purchase_order_item`
  ADD COLUMN `hardness` varchar(50) DEFAULT NULL AFTER `remark`,
  ADD COLUMN `tin_layer` varchar(50) DEFAULT NULL AFTER `hardness`,
  ADD COLUMN `coil_no` varchar(100) DEFAULT NULL AFTER `tin_layer`;

ALTER TABLE `sales_order_item`
  ADD COLUMN `hardness` varchar(50) DEFAULT NULL AFTER `remark`,
  ADD COLUMN `tin_layer` varchar(50) DEFAULT NULL AFTER `hardness`,
  ADD COLUMN `coil_no` varchar(100) DEFAULT NULL AFTER `tin_layer`;

-- 库存与流水
ALTER TABLE `inventory`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `cost_price`,
  ADD KEY `idx_company_id` (`company_id`);

ALTER TABLE `inventory_flow`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `remark`,
  ADD KEY `idx_company_id` (`company_id`);

ALTER TABLE `stock_check`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `status`,
  ADD KEY `idx_company_id` (`company_id`);

-- 报销（保留模块，按公司隔离）
ALTER TABLE `expense_form`
  ADD COLUMN `company_id` bigint NOT NULL DEFAULT 1 COMMENT '所属公司ID' AFTER `updated_at`,
  ADD KEY `idx_company_id` (`company_id`);

-- 验证：每条 ALTER 后跑一次，确认历史数据 company_id 都=1
-- SELECT COUNT(*) FROM supplier WHERE company_id IS NULL;
-- SELECT COUNT(*) FROM product WHERE company_id IS NULL;
-- ... 其余表同理

COMMIT;
