-- ============================================================
-- 追加：三家公司初始化 + 用户-公司-角色数据迁移
-- 执行时机：01_init_new_tables.sql 执行完、业务表加 company_id 之后
-- 说明：历史数据全部归入 company_id=1（上海升顺），已通过 ALTER DEFAULT 1 保证
-- ============================================================

-- 1. 三家公司（信息占位，可在「公司管理」中修改）
--    若 01 脚本已插入 id=1 默认主体，则用 UPDATE 修正，否则 INSERT
INSERT INTO `sys_company` (`id`, `company_code`, `company_name`, `contract_prefix`, `status`)
VALUES
 (1, 'SS',  '上海升顺供应链管理有限公司', 'SS',  1),
 (2, 'LY',  '上海岚页科技有限公司',       'LY',  1),
 (3, 'YZ',  '上海悦竹屿科技有限公司',     'YZ',  1)
ON DUPLICATE KEY UPDATE
  company_code    = VALUES(company_code),
  company_name    = VALUES(company_name),
  contract_prefix = VALUES(contract_prefix);

-- 2. 为现有用户分配默认公司（示例：把所有现有用户分配到上海升顺，管理员按需调整）
--    假设 sys_user 已有数据，company_id=1 为默认主体
--    角色：1=ADMIN（示例，按你实际 sys_role.id 调整）
INSERT INTO `sys_user_company_role` (`user_id`, `company_id`, `role_id`, `is_main`)
SELECT u.id, 1, 1, 1
FROM `sys_user` u
WHERE NOT EXISTS (
  SELECT 1 FROM `sys_user_company_role` ucr WHERE ucr.user_id = u.id
);

-- 3. 废弃旧表：user_role / sys_user_role
--    【执行前务必确认 sys_user_company_role 数据已迁移完整】
--    SELECT COUNT(*) FROM user_role;          -- 应先 = 0（已全部迁入新表）
--    SELECT COUNT(*) FROM sys_user_company_role;  -- 应 > 0
DROP TABLE IF EXISTS `user_role`;
DROP TABLE IF EXISTS `sys_user_role`;

-- 4. 业务表 company_id 默认值确认（已由 02_add_company_id.sql 设置 DEFAULT 1）
--    如有遗漏表，在此补 ALTER：
--    ALTER TABLE `xxx` ADD COLUMN `company_id` BIGINT NOT NULL DEFAULT 1 COMMENT '所属公司ID', ADD KEY `idx_company_id` (`company_id`);
