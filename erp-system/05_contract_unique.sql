-- 采购/销售合同表已在 01_init_new_tables.sql 中建好
-- 此处补充合同编号唯一约束（如未建）
ALTER TABLE `purchase_contract` ADD UNIQUE KEY `uk_contract_no` (`contract_no`);
ALTER TABLE `sales_contract`    ADD UNIQUE KEY `uk_contract_no` (`contract_no`);
