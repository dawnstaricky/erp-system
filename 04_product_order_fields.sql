-- ============================================================
-- Commit 7+8: 商品/单据补字段（执行于业务表已加 company_id 之后）
-- ============================================================

-- 1. 商品表新增钢材通用字段
ALTER TABLE `product`
  ADD COLUMN `hardness`     VARCHAR(50)  DEFAULT NULL COMMENT '硬度'     AFTER `image_url`,
  ADD COLUMN `tin_layer`    VARCHAR(50)  DEFAULT NULL COMMENT '锡层'     AFTER `hardness`,
  ADD COLUMN `coil_no`      VARCHAR(100) DEFAULT NULL COMMENT '钢卷号'   AFTER `tin_layer`,
  ADD COLUMN `steel_mill`   VARCHAR(100) DEFAULT NULL COMMENT '钢厂'     AFTER `coil_no`,
  ADD COLUMN `grade`        VARCHAR(50)  DEFAULT NULL COMMENT '等级'     AFTER `steel_mill`,
  ADD COLUMN `stock_in_date` DATETIME    DEFAULT NULL COMMENT '入库日期'  AFTER `grade`;

-- 2. 采购订单：交货方式 + 含税信息
ALTER TABLE `purchase_order`
  ADD COLUMN `delivery_method` VARCHAR(10) DEFAULT '自提' COMMENT '交货方式：自提/送货' AFTER `status`,
  ADD COLUMN `is_tax_included` TINYINT    DEFAULT 0     COMMENT '是否含税：1-含税 0-不含税' AFTER `delivery_method`,
  ADD COLUMN `tax_rate`       DECIMAL(5,2) DEFAULT 13   COMMENT '税率' AFTER `is_tax_included`;

-- 3. 销售订单：交货方式 + 含税信息 + 回款相关
ALTER TABLE `sales_order`
  ADD COLUMN `delivery_method` VARCHAR(10) DEFAULT '自提' COMMENT '交货方式：自提/送货' AFTER `status`,
  ADD COLUMN `is_tax_included` TINYINT    DEFAULT 0     COMMENT '是否含税：1-含税 0-不含税' AFTER `delivery_method`,
  ADD COLUMN `tax_rate`       DECIMAL(5,2) DEFAULT 13   COMMENT '税率' AFTER `is_tax_included`,
  ADD COLUMN `paid_amount`    DECIMAL(14,2) DEFAULT 0   COMMENT '已回款金额' AFTER `tax_rate`,
  ADD COLUMN `unpaid_amount`  DECIMAL(14,2) DEFAULT 0   COMMENT '未回款金额（冗余，便于查询）' AFTER `paid_amount`;

-- 4. 交货方式枚举值约束（建议，非必须）：仅 '自提' / '送货'
--    MySQL CHECK 约束 8.0.16+ 生效
ALTER TABLE `purchase_order` ADD CONSTRAINT chk_po_delivery CHECK (delivery_method IN ('自提', '送货'));
ALTER TABLE `sales_order`    ADD CONSTRAINT chk_so_delivery CHECK (delivery_method IN ('自提', '送货'));
