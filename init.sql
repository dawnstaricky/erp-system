/*
 Navicat Premium Data Transfer

 Source Server         : erp
 Source Server Type    : MySQL
 Source Server Version : 80046
 Source Host           : localhost:3306
 Source Schema         : erp_db

 Target Server Type    : MySQL
 Target Server Version : 80046
 File Encoding         : 65001

 Date: 17/08/2026 16:34:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for approval_record
-- ----------------------------
DROP TABLE IF EXISTS `approval_record`;
CREATE TABLE `approval_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '审批记录ID',
  `form_id` bigint NOT NULL COMMENT '单据ID（报销单ID等）',
  `form_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单据类型（expense/purchase等）',
  `approver_id` bigint NOT NULL COMMENT '审批人ID',
  `approve_result` tinyint NOT NULL COMMENT '审批结果：1-同意 0-驳回',
  `approve_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批意见',
  `approve_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '审批时间',
  `level` int NOT NULL COMMENT '审批层级（第几级审批）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_form_id`(`form_id` ASC) USING BTREE,
  INDEX `idx_form_type`(`form_type` ASC) USING BTREE,
  INDEX `idx_approver_id`(`approver_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '审批记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approval_record
-- ----------------------------
INSERT INTO `approval_record` VALUES (1, 1, 'expense', 1, 1, '同意', '2026-07-29 22:36:16', 1);
INSERT INTO `approval_record` VALUES (2, 1, 'expense', 3, 1, '票据合规', '2026-07-29 22:36:20', 1);

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `customer_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '客户名称',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '客户等级（普通/VIP/战略）',
  `credit_limit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '信用额度',
  `initial_receivable` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '期初应收款',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-正常 0-停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `customer_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '客户编码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `customer_code`(`customer_code` ASC) USING BTREE,
  INDEX `idx_customer_name`(`customer_name` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '客户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of customer
-- ----------------------------
INSERT INTO `customer` VALUES (1, '测试客户', '李总', '13900139000', 'hah@163.com', '哈哈', 'VIP', NULL, NULL, 1, NULL, '2026-07-29 20:11:48', '2026-08-09 20:58:13', 'CUS001');
INSERT INTO `customer` VALUES (2, '测试客户1', '', '', '', '', '普通', NULL, NULL, 1, NULL, '2026-08-16 20:45:22', '2026-08-16 20:45:22', NULL);

-- ----------------------------
-- Table structure for expense_form
-- ----------------------------
DROP TABLE IF EXISTS `expense_form`;
CREATE TABLE `expense_form`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '报销单ID',
  `form_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报销单号',
  `applicant_id` bigint NOT NULL COMMENT '申请人ID',
  `dept_id` bigint NOT NULL COMMENT '所属部门ID',
  `apply_date` date NOT NULL COMMENT '申请日期',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '报销总金额',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '报销事由',
  `current_approver_id` bigint NULL DEFAULT NULL COMMENT '当前审批人ID',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿 1-审批中 2-已通过 3-已驳回 4-已付款',
  `payment_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `attachment_urls` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发票附件URL，多个用逗号分隔',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `form_no`(`form_no` ASC) USING BTREE,
  INDEX `idx_form_no`(`form_no` ASC) USING BTREE,
  INDEX `idx_applicant_id`(`applicant_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_apply_date`(`apply_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '报销单头表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of expense_form
-- ----------------------------
INSERT INTO `expense_form` VALUES (1, 'EXP202607290001', 7, 4, '2026-07-29', 1650.00, '出差上海拜访客户', 3, 2, NULL, '差旅报销', '2026-07-29 22:36:07', '2026-07-29 22:36:20', NULL);
INSERT INTO `expense_form` VALUES (3, 'EXP202608170001', 7, 4, '2026-08-17', 6000.00, '测试', 2, 1, NULL, NULL, '2026-08-17 14:43:45', '2026-08-17 14:43:45', '/uploads/expense/a9bba980-1d31-47be-a9eb-4c519e777c60_连接成功.png');

-- ----------------------------
-- Table structure for expense_item
-- ----------------------------
DROP TABLE IF EXISTS `expense_item`;
CREATE TABLE `expense_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `form_id` bigint NOT NULL COMMENT '报销单ID',
  `expense_type_id` bigint NOT NULL COMMENT '费用类型ID（关联字典表）',
  `expense_date` date NOT NULL COMMENT '费用发生日期',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `invoice_count` int NULL DEFAULT 0 COMMENT '发票张数',
  `invoice_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发票图片URL',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_form_id`(`form_id` ASC) USING BTREE,
  INDEX `idx_expense_type_id`(`expense_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '报销单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of expense_item
-- ----------------------------
INSERT INTO `expense_item` VALUES (1, 1, 1, '2026-07-25', 1200.00, 3, NULL, '机票');
INSERT INTO `expense_item` VALUES (2, 1, 2, '2026-07-26', 450.00, 2, NULL, '酒店');
INSERT INTO `expense_item` VALUES (3, 3, 1, '2026-08-17', 6000.00, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '库存ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `quantity` int NULL DEFAULT 0 COMMENT '当前库存数量',
  `lock_quantity` int NULL DEFAULT 0 COMMENT '锁定数量（已开单但未出库）',
  `cost_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '成本价（冗余字段，便于查询）',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_product_warehouse`(`product_id` ASC, `warehouse_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_warehouse_id`(`warehouse_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory
-- ----------------------------
INSERT INTO `inventory` VALUES (1, 1, 1, 7, NULL, 4650.00, '2026-08-16 22:25:03');
INSERT INTO `inventory` VALUES (2, 2, 1, 1, NULL, 10.00, '2026-08-16 22:16:05');

-- ----------------------------
-- Table structure for inventory_flow
-- ----------------------------
DROP TABLE IF EXISTS `inventory_flow`;
CREATE TABLE `inventory_flow`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `flow_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：PURCHASE_IN-采购入库 SALE_OUT-销售出库 STOCK_CHECK-盘点',
  `quantity_change` int NOT NULL COMMENT '变动数量（正数入库，负数出库）',
  `quantity_after` int NOT NULL COMMENT '变动后库存',
  `related_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联单号',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人ID',
  `flow_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发生时间',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_warehouse`(`product_id` ASC, `warehouse_id` ASC) USING BTREE,
  INDEX `idx_flow_time`(`flow_time` ASC) USING BTREE,
  INDEX `idx_related_order_no`(`related_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory_flow
-- ----------------------------
INSERT INTO `inventory_flow` VALUES (1, 1, 1, 'PURCHASE_IN', 10, 18, 'PO202607290002', 1, '2026-07-29 21:32:21', '采购入库');
INSERT INTO `inventory_flow` VALUES (2, 1, 1, 'SALE_OUT', -2, 16, 'SO202607290002', 1, '2026-07-29 21:33:15', '销售出库');
INSERT INTO `inventory_flow` VALUES (3, 1, 1, 'PURCHASE_IN', 1, 8, 'PO202608160001', 1, '2026-08-16 18:29:58', '采购入库');
INSERT INTO `inventory_flow` VALUES (4, 2, 1, 'PURCHASE_IN', 1, 1, 'PO202608160002', NULL, '2026-08-16 22:16:05', '采购入库');
INSERT INTO `inventory_flow` VALUES (5, 1, 1, 'SALE_OUT', -1, 7, 'SO202608160001', NULL, '2026-08-16 22:25:03', '销售出库');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作模块',
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作动作',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求方法',
  `params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求参数',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `status` tinyint NULL DEFAULT NULL COMMENT '状态：1-成功 0-失败',
  `error_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `operation_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_module`(`module` ASC) USING BTREE,
  INDEX `idx_operation_time`(`operation_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3971 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 1, 'system', '其他', 'GET', 'GET /login', '[\"admin\",\"123456\"]', '127.0.0.1', 1, NULL, '2026-08-02 21:05:10');
INSERT INTO `operation_log` VALUES (2, 1, 'system', '其他', 'GET', 'GET /login', '[\"admin\",\"123456\"]', '127.0.0.1', 1, NULL, '2026-08-02 21:06:00');
INSERT INTO `operation_log` VALUES (3, 1, 'system', '其他', 'GET', 'GET /login', '[\"admin\",\"123456\"]', '127.0.0.1', 1, NULL, '2026-08-02 21:12:24');
INSERT INTO `operation_log` VALUES (4, 1, 'system', '其他', 'GET', 'GET /login', '[\"admin\",\"123456\"]', '127.0.0.1', 1, NULL, '2026-08-02 22:07:33');
INSERT INTO `operation_log` VALUES (5, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:08:09');
INSERT INTO `operation_log` VALUES (6, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:08:10');
INSERT INTO `operation_log` VALUES (7, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'rank,\n        p.sku_code,\n        p.product_name,\n        p.spec,\n        SUM(so\' at line 2\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\ReportMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n##', '2026-08-02 22:08:11');
INSERT INTO `operation_log` VALUES (8, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@78fd02f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:09:15');
INSERT INTO `operation_log` VALUES (9, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:09:58');
INSERT INTO `operation_log` VALUES (10, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:10:27');
INSERT INTO `operation_log` VALUES (11, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:10:31');
INSERT INTO `operation_log` VALUES (12, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:11:39');
INSERT INTO `operation_log` VALUES (13, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:11:39');
INSERT INTO `operation_log` VALUES (14, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:12:38');
INSERT INTO `operation_log` VALUES (15, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:12:38');
INSERT INTO `operation_log` VALUES (16, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:12:38');
INSERT INTO `operation_log` VALUES (17, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:12:40');
INSERT INTO `operation_log` VALUES (18, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:12:40');
INSERT INTO `operation_log` VALUES (19, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:14:00');
INSERT INTO `operation_log` VALUES (20, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:14:00');
INSERT INTO `operation_log` VALUES (21, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:14:00');
INSERT INTO `operation_log` VALUES (22, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:15:36');
INSERT INTO `operation_log` VALUES (23, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:15:36');
INSERT INTO `operation_log` VALUES (24, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:16:42');
INSERT INTO `operation_log` VALUES (25, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:16:42');
INSERT INTO `operation_log` VALUES (26, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:16:42');
INSERT INTO `operation_log` VALUES (27, 1, 'system', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:17:37');
INSERT INTO `operation_log` VALUES (28, 1, 'system', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:17:57');
INSERT INTO `operation_log` VALUES (29, 1, 'system', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:17:57');
INSERT INTO `operation_log` VALUES (30, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[2026-07-03, 2026-08-02, null, 10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'rank,\n        p.sku_code,\n        p.product_name,\n        p.spec,\n        SUM(so\' at line 2\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\ReportMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n##', '2026-08-02 22:18:01');
INSERT INTO `operation_log` VALUES (31, 1, 'system', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-03, 2026-08-02, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:18:01');
INSERT INTO `operation_log` VALUES (32, 1, 'system', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:18:01');
INSERT INTO `operation_log` VALUES (33, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[2026-07-03, 2026-08-02, null, 10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'rank,\n        p.sku_code,\n        p.product_name,\n        p.spec,\n        SUM(so\' at line 2\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\ReportMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n##', '2026-08-02 22:39:43');
INSERT INTO `operation_log` VALUES (34, 1, 'system', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:39:43');
INSERT INTO `operation_log` VALUES (35, 1, 'system', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-03, 2026-08-02, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:39:43');
INSERT INTO `operation_log` VALUES (36, 1, 'system', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:44:49');
INSERT INTO `operation_log` VALUES (37, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[2026-07-03, 2026-08-02, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:44:49');
INSERT INTO `operation_log` VALUES (38, 1, 'system', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-03, 2026-08-02, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:44:49');
INSERT INTO `operation_log` VALUES (39, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:44:51');
INSERT INTO `operation_log` VALUES (40, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:44:51');
INSERT INTO `operation_log` VALUES (41, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@2f386662]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:00');
INSERT INTO `operation_log` VALUES (42, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:03');
INSERT INTO `operation_log` VALUES (43, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:03');
INSERT INTO `operation_log` VALUES (44, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:16');
INSERT INTO `operation_log` VALUES (45, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:16');
INSERT INTO `operation_log` VALUES (46, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:17');
INSERT INTO `operation_log` VALUES (47, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@40f17701]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:22');
INSERT INTO `operation_log` VALUES (48, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:45:23');
INSERT INTO `operation_log` VALUES (49, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:06');
INSERT INTO `operation_log` VALUES (50, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:07');
INSERT INTO `operation_log` VALUES (51, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:09');
INSERT INTO `operation_log` VALUES (52, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:13');
INSERT INTO `operation_log` VALUES (53, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:13');
INSERT INTO `operation_log` VALUES (54, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:15');
INSERT INTO `operation_log` VALUES (55, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:15');
INSERT INTO `operation_log` VALUES (56, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:15');
INSERT INTO `operation_log` VALUES (57, 1, 'system', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:17');
INSERT INTO `operation_log` VALUES (58, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:18');
INSERT INTO `operation_log` VALUES (59, 1, 'system', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:18');
INSERT INTO `operation_log` VALUES (60, 1, 'system', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:27');
INSERT INTO `operation_log` VALUES (61, 1, 'system', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:27');
INSERT INTO `operation_log` VALUES (62, 1, 'system', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-03, 2026-08-02, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:28');
INSERT INTO `operation_log` VALUES (63, 1, 'system', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:28');
INSERT INTO `operation_log` VALUES (64, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[2026-07-03, 2026-08-02, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:28');
INSERT INTO `operation_log` VALUES (65, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:55');
INSERT INTO `operation_log` VALUES (66, 1, 'system', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 22:46:55');
INSERT INTO `operation_log` VALUES (67, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:05');
INSERT INTO `operation_log` VALUES (68, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:05');
INSERT INTO `operation_log` VALUES (69, 1, 'system', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:07');
INSERT INTO `operation_log` VALUES (70, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:18');
INSERT INTO `operation_log` VALUES (71, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:19');
INSERT INTO `operation_log` VALUES (72, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:19');
INSERT INTO `operation_log` VALUES (73, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@2b046a92]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:26');
INSERT INTO `operation_log` VALUES (74, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:29');
INSERT INTO `operation_log` VALUES (75, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:31');
INSERT INTO `operation_log` VALUES (76, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:33');
INSERT INTO `operation_log` VALUES (77, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:34');
INSERT INTO `operation_log` VALUES (78, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:35');
INSERT INTO `operation_log` VALUES (79, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:37');
INSERT INTO `operation_log` VALUES (80, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:37');
INSERT INTO `operation_log` VALUES (81, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:37');
INSERT INTO `operation_log` VALUES (82, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:12:38');
INSERT INTO `operation_log` VALUES (83, 1, 'system', '其他', '新增', 'POST /warehouse/add', '[{\"id\":null,\"warehouseCode\":null,\"warehouseName\":\"2222\",\"address\":\"2\",\"manager\":\"2\",\"phone\":\"13322222222\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:13:31');
INSERT INTO `operation_log` VALUES (84, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:08');
INSERT INTO `operation_log` VALUES (85, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:08');
INSERT INTO `operation_log` VALUES (86, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:08');
INSERT INTO `operation_log` VALUES (87, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:09');
INSERT INTO `operation_log` VALUES (88, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:09');
INSERT INTO `operation_log` VALUES (89, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:09');
INSERT INTO `operation_log` VALUES (90, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:09');
INSERT INTO `operation_log` VALUES (91, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:10');
INSERT INTO `operation_log` VALUES (92, 1, 'system', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:10');
INSERT INTO `operation_log` VALUES (93, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:10');
INSERT INTO `operation_log` VALUES (94, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:10');
INSERT INTO `operation_log` VALUES (95, 1, 'system', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:10');
INSERT INTO `operation_log` VALUES (96, 1, 'system', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:13');
INSERT INTO `operation_log` VALUES (97, 1, 'system', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:14:13');
INSERT INTO `operation_log` VALUES (98, 1, 'system', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:30:35');
INSERT INTO `operation_log` VALUES (99, 1, 'system', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:30:35');
INSERT INTO `operation_log` VALUES (100, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:30:48');
INSERT INTO `operation_log` VALUES (101, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:30:48');
INSERT INTO `operation_log` VALUES (102, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:30:48');
INSERT INTO `operation_log` VALUES (103, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:30:51');
INSERT INTO `operation_log` VALUES (104, 1, 'system', '其他', '新增', 'POST /warehouse/add', '[{\"id\":2,\"warehouseCode\":\"222\",\"warehouseName\":\"222\",\"address\":\"222\",\"manager\":\"222\",\"phone\":\"13322222222\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:16');
INSERT INTO `operation_log` VALUES (105, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:16');
INSERT INTO `operation_log` VALUES (106, 1, 'system', '其他', 'DELETE', 'DELETE /warehouse/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:22');
INSERT INTO `operation_log` VALUES (107, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:22');
INSERT INTO `operation_log` VALUES (108, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:28');
INSERT INTO `operation_log` VALUES (109, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:28');
INSERT INTO `operation_log` VALUES (110, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:28');
INSERT INTO `operation_log` VALUES (111, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-02 23:31:29');
INSERT INTO `operation_log` VALUES (112, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:47:56');
INSERT INTO `operation_log` VALUES (113, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:47:59');
INSERT INTO `operation_log` VALUES (114, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:47:59');
INSERT INTO `operation_log` VALUES (115, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:03');
INSERT INTO `operation_log` VALUES (116, 1, 'system', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:03');
INSERT INTO `operation_log` VALUES (117, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:05');
INSERT INTO `operation_log` VALUES (118, 1, 'system', '其他', '修改', 'PUT /warehouse/update', '[{\"id\":2,\"warehouseCode\":\"222\",\"warehouseName\":\"222\",\"address\":\"222\",\"manager\":\"222\",\"phone\":\"13322222222\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:23');
INSERT INTO `operation_log` VALUES (119, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:23');
INSERT INTO `operation_log` VALUES (120, 1, 'system', '其他', '修改', 'PUT /warehouse/update', '[{\"id\":2,\"warehouseCode\":null,\"warehouseName\":null,\"address\":null,\"manager\":null,\"phone\":null,\"status\":0,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:31');
INSERT INTO `operation_log` VALUES (121, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:31');
INSERT INTO `operation_log` VALUES (122, 1, 'system', '其他', '新增', 'POST /warehouse/add', '[{\"id\":null,\"warehouseCode\":\"222\",\"warehouseName\":\"333\",\"address\":\"333\",\"manager\":\"333\",\"phone\":\"13333333333\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 16:48:58');
INSERT INTO `operation_log` VALUES (123, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:21:35');
INSERT INTO `operation_log` VALUES (124, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:21:50');
INSERT INTO `operation_log` VALUES (125, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:21:51');
INSERT INTO `operation_log` VALUES (126, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:21:51');
INSERT INTO `operation_log` VALUES (127, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@79a5859b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:21:57');
INSERT INTO `operation_log` VALUES (128, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:21:59');
INSERT INTO `operation_log` VALUES (129, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:01');
INSERT INTO `operation_log` VALUES (130, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:03');
INSERT INTO `operation_log` VALUES (131, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:52');
INSERT INTO `operation_log` VALUES (132, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:54');
INSERT INTO `operation_log` VALUES (133, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:55');
INSERT INTO `operation_log` VALUES (134, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:56');
INSERT INTO `operation_log` VALUES (135, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:58');
INSERT INTO `operation_log` VALUES (136, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:58');
INSERT INTO `operation_log` VALUES (137, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:22:58');
INSERT INTO `operation_log` VALUES (138, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:02');
INSERT INTO `operation_log` VALUES (139, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:02');
INSERT INTO `operation_log` VALUES (140, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:02');
INSERT INTO `operation_log` VALUES (141, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:02');
INSERT INTO `operation_log` VALUES (142, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:04');
INSERT INTO `operation_log` VALUES (143, 1, 'system', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:05');
INSERT INTO `operation_log` VALUES (144, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:06');
INSERT INTO `operation_log` VALUES (145, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:07');
INSERT INTO `operation_log` VALUES (146, 1, 'system', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:07');
INSERT INTO `operation_log` VALUES (147, 1, 'system', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:08');
INSERT INTO `operation_log` VALUES (148, 1, 'system', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:08');
INSERT INTO `operation_log` VALUES (149, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:10');
INSERT INTO `operation_log` VALUES (150, 1, 'system', '其他', '修改', 'PUT /warehouse/update', '[{\"id\":2,\"warehouseCode\":null,\"warehouseName\":null,\"address\":null,\"manager\":null,\"phone\":null,\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:14');
INSERT INTO `operation_log` VALUES (151, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:15');
INSERT INTO `operation_log` VALUES (152, 1, 'system', '其他', '修改', 'PUT /warehouse/update', '[{\"id\":2,\"warehouseCode\":null,\"warehouseName\":null,\"address\":null,\"manager\":null,\"phone\":null,\"status\":0,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:18');
INSERT INTO `operation_log` VALUES (153, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:18');
INSERT INTO `operation_log` VALUES (154, 1, 'system', '其他', '新增', 'POST /warehouse/add', '[{\"id\":4,\"warehouseCode\":\"WH20260803-0001\",\"warehouseName\":\"333\",\"address\":\"333\",\"manager\":\"333\",\"phone\":\"13333333333\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:29');
INSERT INTO `operation_log` VALUES (155, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-03 17:23:29');
INSERT INTO `operation_log` VALUES (156, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:41:40');
INSERT INTO `operation_log` VALUES (157, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:41:43');
INSERT INTO `operation_log` VALUES (158, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:41:44');
INSERT INTO `operation_log` VALUES (159, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@43a770ad]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:41:59');
INSERT INTO `operation_log` VALUES (160, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:42:23');
INSERT INTO `operation_log` VALUES (161, 1, 'system', '其他', 'GET', 'GET /role/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:42:30');
INSERT INTO `operation_log` VALUES (162, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:46:04');
INSERT INTO `operation_log` VALUES (163, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:46:05');
INSERT INTO `operation_log` VALUES (164, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@7d9b4323]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:46:07');
INSERT INTO `operation_log` VALUES (165, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@3e576f97]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:46:26');
INSERT INTO `operation_log` VALUES (166, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:46:29');
INSERT INTO `operation_log` VALUES (167, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:00');
INSERT INTO `operation_log` VALUES (168, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:02');
INSERT INTO `operation_log` VALUES (169, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:04');
INSERT INTO `operation_log` VALUES (170, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:05');
INSERT INTO `operation_log` VALUES (171, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:05');
INSERT INTO `operation_log` VALUES (172, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:05');
INSERT INTO `operation_log` VALUES (173, 1, 'system', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:10');
INSERT INTO `operation_log` VALUES (174, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:13');
INSERT INTO `operation_log` VALUES (175, 1, 'system', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:15');
INSERT INTO `operation_log` VALUES (176, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 19:47:42');
INSERT INTO `operation_log` VALUES (177, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:24:02');
INSERT INTO `operation_log` VALUES (178, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:25:30');
INSERT INTO `operation_log` VALUES (179, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@2e110e39]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:25:37');
INSERT INTO `operation_log` VALUES (180, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:25:41');
INSERT INTO `operation_log` VALUES (181, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@30d04d65]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:26:55');
INSERT INTO `operation_log` VALUES (182, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:12');
INSERT INTO `operation_log` VALUES (183, 1, 'system', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":8,\"username\":\"gm\",\"password\":null,\"realName\":\"总经理\",\"deptId\":3,\"phone\":\"13800138001\",\"email\":null,\"avatar\":null,\"role\":\"gm\",\"status\":1,\"roleIds\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:36');
INSERT INTO `operation_log` VALUES (184, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:36');
INSERT INTO `operation_log` VALUES (185, 1, 'system', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":2,\"username\":\"manager\",\"password\":null,\"realName\":\"李四\",\"deptId\":3,\"phone\":\"13800138001\",\"email\":null,\"avatar\":null,\"role\":\"manager\",\"status\":1,\"roleIds\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:46');
INSERT INTO `operation_log` VALUES (186, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:46');
INSERT INTO `operation_log` VALUES (187, 1, 'system', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":3,\"username\":\"finance\",\"password\":null,\"realName\":\"王五\",\"deptId\":3,\"phone\":\"13800138002\",\"email\":null,\"avatar\":null,\"role\":\"finance\",\"status\":1,\"roleIds\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:53');
INSERT INTO `operation_log` VALUES (188, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 21:27:53');
INSERT INTO `operation_log` VALUES (189, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"sales\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:26:41');
INSERT INTO `operation_log` VALUES (190, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:26:44');
INSERT INTO `operation_log` VALUES (191, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:26:44');
INSERT INTO `operation_log` VALUES (192, 1, 'system', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@52b7b0d9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:26:51');
INSERT INTO `operation_log` VALUES (193, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:27:01');
INSERT INTO `operation_log` VALUES (194, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:27:06');
INSERT INTO `operation_log` VALUES (195, 1, 'system', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:27:13');
INSERT INTO `operation_log` VALUES (196, 1, 'system', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:27:13');
INSERT INTO `operation_log` VALUES (197, 1, 'system', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:27:13');
INSERT INTO `operation_log` VALUES (198, 1, 'system', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-04 22:27:13');
INSERT INTO `operation_log` VALUES (199, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 08:52:23');
INSERT INTO `operation_log` VALUES (200, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 08:52:24');
INSERT INTO `operation_log` VALUES (201, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 08:52:25');
INSERT INTO `operation_log` VALUES (202, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 08:58:53');
INSERT INTO `operation_log` VALUES (203, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 08:58:54');
INSERT INTO `operation_log` VALUES (204, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 09:01:19');
INSERT INTO `operation_log` VALUES (205, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 10:39:08');
INSERT INTO `operation_log` VALUES (206, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 11:25:32');
INSERT INTO `operation_log` VALUES (207, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 11:39:45');
INSERT INTO `operation_log` VALUES (208, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 11:39:46');
INSERT INTO `operation_log` VALUES (209, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 11:39:46');
INSERT INTO `operation_log` VALUES (210, 1, 'system', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 11:39:59');
INSERT INTO `operation_log` VALUES (211, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 11:44:36');
INSERT INTO `operation_log` VALUES (212, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 15:44:02');
INSERT INTO `operation_log` VALUES (213, 1, 'system', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 15:44:03');
INSERT INTO `operation_log` VALUES (214, 1, 'system', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 15:44:03');
INSERT INTO `operation_log` VALUES (215, 1, 'system', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 15:44:09');
INSERT INTO `operation_log` VALUES (216, 1, 'system', '其他', 'GET', 'GET /role/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 16:42:37');
INSERT INTO `operation_log` VALUES (217, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"sales\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 16:55:27');
INSERT INTO `operation_log` VALUES (218, 1, 'system', '其他', 'POST', 'POST /login', '[{\"username\":\"sales\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 16:55:40');
INSERT INTO `operation_log` VALUES (219, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:17:55');
INSERT INTO `operation_log` VALUES (220, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:18:44');
INSERT INTO `operation_log` VALUES (221, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:18:44');
INSERT INTO `operation_log` VALUES (222, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:23:10');
INSERT INTO `operation_log` VALUES (223, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:23:10');
INSERT INTO `operation_log` VALUES (224, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:24:06');
INSERT INTO `operation_log` VALUES (225, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:24:06');
INSERT INTO `operation_log` VALUES (226, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:24:25');
INSERT INTO `operation_log` VALUES (227, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:24:25');
INSERT INTO `operation_log` VALUES (228, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-05 22:24:26');
INSERT INTO `operation_log` VALUES (229, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 14:31:09');
INSERT INTO `operation_log` VALUES (230, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 14:31:11');
INSERT INTO `operation_log` VALUES (231, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 14:31:12');
INSERT INTO `operation_log` VALUES (232, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 15:43:19');
INSERT INTO `operation_log` VALUES (233, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 15:43:19');
INSERT INTO `operation_log` VALUES (234, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 15:43:20');
INSERT INTO `operation_log` VALUES (235, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:19:55');
INSERT INTO `operation_log` VALUES (236, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:19:57');
INSERT INTO `operation_log` VALUES (237, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:19:58');
INSERT INTO `operation_log` VALUES (238, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:30:03');
INSERT INTO `operation_log` VALUES (239, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:30:03');
INSERT INTO `operation_log` VALUES (240, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:30:03');
INSERT INTO `operation_log` VALUES (241, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:30:12');
INSERT INTO `operation_log` VALUES (242, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:30:12');
INSERT INTO `operation_log` VALUES (243, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:30:13');
INSERT INTO `operation_log` VALUES (244, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:31:13');
INSERT INTO `operation_log` VALUES (245, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:32:13');
INSERT INTO `operation_log` VALUES (246, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:33:13');
INSERT INTO `operation_log` VALUES (247, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:34:13');
INSERT INTO `operation_log` VALUES (248, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:35:13');
INSERT INTO `operation_log` VALUES (249, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:35:48');
INSERT INTO `operation_log` VALUES (250, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@53334c7e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:35:50');
INSERT INTO `operation_log` VALUES (251, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:35:51');
INSERT INTO `operation_log` VALUES (252, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:36:13');
INSERT INTO `operation_log` VALUES (253, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:37:12');
INSERT INTO `operation_log` VALUES (254, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:38:12');
INSERT INTO `operation_log` VALUES (255, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:39:13');
INSERT INTO `operation_log` VALUES (256, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:01');
INSERT INTO `operation_log` VALUES (257, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:01');
INSERT INTO `operation_log` VALUES (258, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:12');
INSERT INTO `operation_log` VALUES (259, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:12');
INSERT INTO `operation_log` VALUES (260, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:33');
INSERT INTO `operation_log` VALUES (261, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:34');
INSERT INTO `operation_log` VALUES (262, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:34');
INSERT INTO `operation_log` VALUES (263, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:34');
INSERT INTO `operation_log` VALUES (264, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:47');
INSERT INTO `operation_log` VALUES (265, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:47');
INSERT INTO `operation_log` VALUES (266, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:47');
INSERT INTO `operation_log` VALUES (267, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:48');
INSERT INTO `operation_log` VALUES (268, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:40:50');
INSERT INTO `operation_log` VALUES (269, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:41:34');
INSERT INTO `operation_log` VALUES (270, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:42:34');
INSERT INTO `operation_log` VALUES (271, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:43:34');
INSERT INTO `operation_log` VALUES (272, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:44:34');
INSERT INTO `operation_log` VALUES (273, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:45:34');
INSERT INTO `operation_log` VALUES (274, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:46:34');
INSERT INTO `operation_log` VALUES (275, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:48:29');
INSERT INTO `operation_log` VALUES (276, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:49:29');
INSERT INTO `operation_log` VALUES (277, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:49:34');
INSERT INTO `operation_log` VALUES (278, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:49:39');
INSERT INTO `operation_log` VALUES (279, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:49:39');
INSERT INTO `operation_log` VALUES (280, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:50:08');
INSERT INTO `operation_log` VALUES (281, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:50:08');
INSERT INTO `operation_log` VALUES (282, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:50:08');
INSERT INTO `operation_log` VALUES (283, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:50:08');
INSERT INTO `operation_log` VALUES (284, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:51:08');
INSERT INTO `operation_log` VALUES (285, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:52:08');
INSERT INTO `operation_log` VALUES (286, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:53:08');
INSERT INTO `operation_log` VALUES (287, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:54:08');
INSERT INTO `operation_log` VALUES (288, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:55:08');
INSERT INTO `operation_log` VALUES (289, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:56:08');
INSERT INTO `operation_log` VALUES (290, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:57:08');
INSERT INTO `operation_log` VALUES (291, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:58:08');
INSERT INTO `operation_log` VALUES (292, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:59:09');
INSERT INTO `operation_log` VALUES (293, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:59:57');
INSERT INTO `operation_log` VALUES (294, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:59:57');
INSERT INTO `operation_log` VALUES (295, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 16:59:57');
INSERT INTO `operation_log` VALUES (296, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:00:09');
INSERT INTO `operation_log` VALUES (297, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:00:09');
INSERT INTO `operation_log` VALUES (298, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:00:10');
INSERT INTO `operation_log` VALUES (299, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:00:10');
INSERT INTO `operation_log` VALUES (300, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:01:09');
INSERT INTO `operation_log` VALUES (301, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:02:10');
INSERT INTO `operation_log` VALUES (302, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:03:09');
INSERT INTO `operation_log` VALUES (303, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:04:10');
INSERT INTO `operation_log` VALUES (304, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:05:10');
INSERT INTO `operation_log` VALUES (305, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:06:10');
INSERT INTO `operation_log` VALUES (306, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:07:29');
INSERT INTO `operation_log` VALUES (307, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:08:29');
INSERT INTO `operation_log` VALUES (308, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:09:29');
INSERT INTO `operation_log` VALUES (309, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:10:29');
INSERT INTO `operation_log` VALUES (310, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:11:29');
INSERT INTO `operation_log` VALUES (311, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:12:29');
INSERT INTO `operation_log` VALUES (312, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:13:29');
INSERT INTO `operation_log` VALUES (313, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:14:29');
INSERT INTO `operation_log` VALUES (314, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:15:29');
INSERT INTO `operation_log` VALUES (315, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:16:29');
INSERT INTO `operation_log` VALUES (316, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:17:29');
INSERT INTO `operation_log` VALUES (317, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:18:29');
INSERT INTO `operation_log` VALUES (318, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:19:29');
INSERT INTO `operation_log` VALUES (319, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:20:29');
INSERT INTO `operation_log` VALUES (320, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:21:29');
INSERT INTO `operation_log` VALUES (321, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:22:29');
INSERT INTO `operation_log` VALUES (322, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:23:29');
INSERT INTO `operation_log` VALUES (323, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:24:29');
INSERT INTO `operation_log` VALUES (324, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:25:29');
INSERT INTO `operation_log` VALUES (325, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:26:29');
INSERT INTO `operation_log` VALUES (326, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:27:29');
INSERT INTO `operation_log` VALUES (327, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:28:29');
INSERT INTO `operation_log` VALUES (328, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:29:29');
INSERT INTO `operation_log` VALUES (329, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:30:29');
INSERT INTO `operation_log` VALUES (330, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:31:29');
INSERT INTO `operation_log` VALUES (331, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:32:29');
INSERT INTO `operation_log` VALUES (332, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:33:29');
INSERT INTO `operation_log` VALUES (333, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:34:29');
INSERT INTO `operation_log` VALUES (334, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:35:29');
INSERT INTO `operation_log` VALUES (335, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:29');
INSERT INTO `operation_log` VALUES (336, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:41');
INSERT INTO `operation_log` VALUES (337, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:41');
INSERT INTO `operation_log` VALUES (338, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:41');
INSERT INTO `operation_log` VALUES (339, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:51');
INSERT INTO `operation_log` VALUES (340, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:51');
INSERT INTO `operation_log` VALUES (341, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:51');
INSERT INTO `operation_log` VALUES (342, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:36:51');
INSERT INTO `operation_log` VALUES (343, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'deleted\' in \'where clause\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\RoleMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT count(0) FROM sys_role WHERE deleted = 0\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'deleted\' in \'where clause\'\n; bad SQL grammar []', '2026-08-06 17:36:56');
INSERT INTO `operation_log` VALUES (344, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:37:51');
INSERT INTO `operation_log` VALUES (345, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:38:51');
INSERT INTO `operation_log` VALUES (346, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:15');
INSERT INTO `operation_log` VALUES (347, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:16');
INSERT INTO `operation_log` VALUES (348, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:16');
INSERT INTO `operation_log` VALUES (349, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:16');
INSERT INTO `operation_log` VALUES (350, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:34');
INSERT INTO `operation_log` VALUES (351, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:37');
INSERT INTO `operation_log` VALUES (352, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:39:58');
INSERT INTO `operation_log` VALUES (353, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'deleted\' in \'where clause\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\RoleMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT count(0) FROM sys_role WHERE deleted = 0\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'deleted\' in \'where clause\'\n; bad SQL grammar []', '2026-08-06 17:39:58');
INSERT INTO `operation_log` VALUES (354, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:40:58');
INSERT INTO `operation_log` VALUES (355, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:41:58');
INSERT INTO `operation_log` VALUES (356, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:42:58');
INSERT INTO `operation_log` VALUES (357, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:43:58');
INSERT INTO `operation_log` VALUES (358, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:44:58');
INSERT INTO `operation_log` VALUES (359, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:45:58');
INSERT INTO `operation_log` VALUES (360, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:47:29');
INSERT INTO `operation_log` VALUES (361, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:48:29');
INSERT INTO `operation_log` VALUES (362, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:49:29');
INSERT INTO `operation_log` VALUES (363, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:50:29');
INSERT INTO `operation_log` VALUES (364, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:51:29');
INSERT INTO `operation_log` VALUES (365, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:52:29');
INSERT INTO `operation_log` VALUES (366, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:53:29');
INSERT INTO `operation_log` VALUES (367, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:54:29');
INSERT INTO `operation_log` VALUES (368, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:55:29');
INSERT INTO `operation_log` VALUES (369, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:56:29');
INSERT INTO `operation_log` VALUES (370, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:57:29');
INSERT INTO `operation_log` VALUES (371, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:58:29');
INSERT INTO `operation_log` VALUES (372, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 17:59:29');
INSERT INTO `operation_log` VALUES (373, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:00:29');
INSERT INTO `operation_log` VALUES (374, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:01:29');
INSERT INTO `operation_log` VALUES (375, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:02:29');
INSERT INTO `operation_log` VALUES (376, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:03:29');
INSERT INTO `operation_log` VALUES (377, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:04:29');
INSERT INTO `operation_log` VALUES (378, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:05:29');
INSERT INTO `operation_log` VALUES (379, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:06:29');
INSERT INTO `operation_log` VALUES (380, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:07:29');
INSERT INTO `operation_log` VALUES (381, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:08:29');
INSERT INTO `operation_log` VALUES (382, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:09:29');
INSERT INTO `operation_log` VALUES (383, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:10:29');
INSERT INTO `operation_log` VALUES (384, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:11:29');
INSERT INTO `operation_log` VALUES (385, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:12:29');
INSERT INTO `operation_log` VALUES (386, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:13:29');
INSERT INTO `operation_log` VALUES (387, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:14:29');
INSERT INTO `operation_log` VALUES (388, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:15:29');
INSERT INTO `operation_log` VALUES (389, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:16:29');
INSERT INTO `operation_log` VALUES (390, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:17:29');
INSERT INTO `operation_log` VALUES (391, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:18:29');
INSERT INTO `operation_log` VALUES (392, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:19:29');
INSERT INTO `operation_log` VALUES (393, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:20:29');
INSERT INTO `operation_log` VALUES (394, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:21:29');
INSERT INTO `operation_log` VALUES (395, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:22:29');
INSERT INTO `operation_log` VALUES (396, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:23:29');
INSERT INTO `operation_log` VALUES (397, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:24:29');
INSERT INTO `operation_log` VALUES (398, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:25:29');
INSERT INTO `operation_log` VALUES (399, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:26:29');
INSERT INTO `operation_log` VALUES (400, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:27:29');
INSERT INTO `operation_log` VALUES (401, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:28:29');
INSERT INTO `operation_log` VALUES (402, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:29:29');
INSERT INTO `operation_log` VALUES (403, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:30:29');
INSERT INTO `operation_log` VALUES (404, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:31:29');
INSERT INTO `operation_log` VALUES (405, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:32:29');
INSERT INTO `operation_log` VALUES (406, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:33:29');
INSERT INTO `operation_log` VALUES (407, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:34:29');
INSERT INTO `operation_log` VALUES (408, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:35:29');
INSERT INTO `operation_log` VALUES (409, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:36:29');
INSERT INTO `operation_log` VALUES (410, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:37:29');
INSERT INTO `operation_log` VALUES (411, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:38:29');
INSERT INTO `operation_log` VALUES (412, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:39:29');
INSERT INTO `operation_log` VALUES (413, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:40:29');
INSERT INTO `operation_log` VALUES (414, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:41:29');
INSERT INTO `operation_log` VALUES (415, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:42:29');
INSERT INTO `operation_log` VALUES (416, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:43:29');
INSERT INTO `operation_log` VALUES (417, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:44:29');
INSERT INTO `operation_log` VALUES (418, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:45:29');
INSERT INTO `operation_log` VALUES (419, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:46:29');
INSERT INTO `operation_log` VALUES (420, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:47:29');
INSERT INTO `operation_log` VALUES (421, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:48:29');
INSERT INTO `operation_log` VALUES (422, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:49:29');
INSERT INTO `operation_log` VALUES (423, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:50:29');
INSERT INTO `operation_log` VALUES (424, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:51:29');
INSERT INTO `operation_log` VALUES (425, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:52:29');
INSERT INTO `operation_log` VALUES (426, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:53:29');
INSERT INTO `operation_log` VALUES (427, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:54:29');
INSERT INTO `operation_log` VALUES (428, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:55:29');
INSERT INTO `operation_log` VALUES (429, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:56:29');
INSERT INTO `operation_log` VALUES (430, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:57:29');
INSERT INTO `operation_log` VALUES (431, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:58:29');
INSERT INTO `operation_log` VALUES (432, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 18:59:29');
INSERT INTO `operation_log` VALUES (433, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:00:29');
INSERT INTO `operation_log` VALUES (434, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:01:29');
INSERT INTO `operation_log` VALUES (435, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:02:29');
INSERT INTO `operation_log` VALUES (436, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:03:29');
INSERT INTO `operation_log` VALUES (437, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:04:29');
INSERT INTO `operation_log` VALUES (438, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:05:29');
INSERT INTO `operation_log` VALUES (439, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:06:29');
INSERT INTO `operation_log` VALUES (440, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:07:29');
INSERT INTO `operation_log` VALUES (441, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:08:29');
INSERT INTO `operation_log` VALUES (442, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:09:29');
INSERT INTO `operation_log` VALUES (443, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:10:29');
INSERT INTO `operation_log` VALUES (444, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:11:29');
INSERT INTO `operation_log` VALUES (445, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:12:29');
INSERT INTO `operation_log` VALUES (446, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:13:29');
INSERT INTO `operation_log` VALUES (447, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:14:29');
INSERT INTO `operation_log` VALUES (448, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:15:29');
INSERT INTO `operation_log` VALUES (449, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:16:29');
INSERT INTO `operation_log` VALUES (450, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:17:29');
INSERT INTO `operation_log` VALUES (451, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:18:29');
INSERT INTO `operation_log` VALUES (452, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:19:29');
INSERT INTO `operation_log` VALUES (453, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:20:29');
INSERT INTO `operation_log` VALUES (454, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:21:29');
INSERT INTO `operation_log` VALUES (455, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:22:29');
INSERT INTO `operation_log` VALUES (456, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:23:29');
INSERT INTO `operation_log` VALUES (457, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:24:29');
INSERT INTO `operation_log` VALUES (458, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:25:29');
INSERT INTO `operation_log` VALUES (459, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:26:29');
INSERT INTO `operation_log` VALUES (460, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:27:29');
INSERT INTO `operation_log` VALUES (461, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:28:29');
INSERT INTO `operation_log` VALUES (462, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:29:29');
INSERT INTO `operation_log` VALUES (463, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:30:29');
INSERT INTO `operation_log` VALUES (464, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:31:29');
INSERT INTO `operation_log` VALUES (465, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:32:29');
INSERT INTO `operation_log` VALUES (466, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:33:29');
INSERT INTO `operation_log` VALUES (467, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:34:29');
INSERT INTO `operation_log` VALUES (468, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:35:29');
INSERT INTO `operation_log` VALUES (469, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:36:29');
INSERT INTO `operation_log` VALUES (470, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:37:29');
INSERT INTO `operation_log` VALUES (471, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:38:29');
INSERT INTO `operation_log` VALUES (472, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:48:22');
INSERT INTO `operation_log` VALUES (473, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:48:23');
INSERT INTO `operation_log` VALUES (474, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:48:23');
INSERT INTO `operation_log` VALUES (475, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:48:24');
INSERT INTO `operation_log` VALUES (476, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_time\' in \'order clause\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\RoleMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT * FROM sys_role WHERE status = 1                             ORDER BY create_time DESC  LIMIT ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_tim', '2026-08-06 19:48:35');
INSERT INTO `operation_log` VALUES (477, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:49:24');
INSERT INTO `operation_log` VALUES (478, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:50:53');
INSERT INTO `operation_log` VALUES (479, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:50:54');
INSERT INTO `operation_log` VALUES (480, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:50:54');
INSERT INTO `operation_log` VALUES (481, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:50:54');
INSERT INTO `operation_log` VALUES (482, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:50:56');
INSERT INTO `operation_log` VALUES (483, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:51:30');
INSERT INTO `operation_log` VALUES (484, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:51:30');
INSERT INTO `operation_log` VALUES (485, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:51:30');
INSERT INTO `operation_log` VALUES (486, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:51:30');
INSERT INTO `operation_log` VALUES (487, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:51:33');
INSERT INTO `operation_log` VALUES (488, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:51:42');
INSERT INTO `operation_log` VALUES (489, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:52:35');
INSERT INTO `operation_log` VALUES (490, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:52:35');
INSERT INTO `operation_log` VALUES (491, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:52:35');
INSERT INTO `operation_log` VALUES (492, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:52:35');
INSERT INTO `operation_log` VALUES (493, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:52:47');
INSERT INTO `operation_log` VALUES (494, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:53:35');
INSERT INTO `operation_log` VALUES (495, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:54:36');
INSERT INTO `operation_log` VALUES (496, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:55:36');
INSERT INTO `operation_log` VALUES (497, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:56:36');
INSERT INTO `operation_log` VALUES (498, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:57:36');
INSERT INTO `operation_log` VALUES (499, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:58:36');
INSERT INTO `operation_log` VALUES (500, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:41');
INSERT INTO `operation_log` VALUES (501, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:43');
INSERT INTO `operation_log` VALUES (502, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:43');
INSERT INTO `operation_log` VALUES (503, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:43');
INSERT INTO `operation_log` VALUES (504, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:54');
INSERT INTO `operation_log` VALUES (505, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:54');
INSERT INTO `operation_log` VALUES (506, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:54');
INSERT INTO `operation_log` VALUES (507, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:54');
INSERT INTO `operation_log` VALUES (508, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 19:59:58');
INSERT INTO `operation_log` VALUES (509, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:00:06');
INSERT INTO `operation_log` VALUES (510, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:00:06');
INSERT INTO `operation_log` VALUES (511, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:00:06');
INSERT INTO `operation_log` VALUES (512, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:01:07');
INSERT INTO `operation_log` VALUES (513, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:02:07');
INSERT INTO `operation_log` VALUES (514, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:03:07');
INSERT INTO `operation_log` VALUES (515, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:04:07');
INSERT INTO `operation_log` VALUES (516, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:05:07');
INSERT INTO `operation_log` VALUES (517, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:06:07');
INSERT INTO `operation_log` VALUES (518, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:07:29');
INSERT INTO `operation_log` VALUES (519, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:08:29');
INSERT INTO `operation_log` VALUES (520, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:09:29');
INSERT INTO `operation_log` VALUES (521, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:10:29');
INSERT INTO `operation_log` VALUES (522, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:11:29');
INSERT INTO `operation_log` VALUES (523, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:12:29');
INSERT INTO `operation_log` VALUES (524, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:13:29');
INSERT INTO `operation_log` VALUES (525, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:14:29');
INSERT INTO `operation_log` VALUES (526, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:15:29');
INSERT INTO `operation_log` VALUES (527, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:16:29');
INSERT INTO `operation_log` VALUES (528, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:17:29');
INSERT INTO `operation_log` VALUES (529, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:18:29');
INSERT INTO `operation_log` VALUES (530, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:19:29');
INSERT INTO `operation_log` VALUES (531, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:20:29');
INSERT INTO `operation_log` VALUES (532, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:21:29');
INSERT INTO `operation_log` VALUES (533, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:22:29');
INSERT INTO `operation_log` VALUES (534, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:23:29');
INSERT INTO `operation_log` VALUES (535, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:24:29');
INSERT INTO `operation_log` VALUES (536, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:25:29');
INSERT INTO `operation_log` VALUES (537, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:26:29');
INSERT INTO `operation_log` VALUES (538, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:27:29');
INSERT INTO `operation_log` VALUES (539, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:28:29');
INSERT INTO `operation_log` VALUES (540, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:29:29');
INSERT INTO `operation_log` VALUES (541, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:30:29');
INSERT INTO `operation_log` VALUES (542, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:31:29');
INSERT INTO `operation_log` VALUES (543, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:32:29');
INSERT INTO `operation_log` VALUES (544, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:33:29');
INSERT INTO `operation_log` VALUES (545, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:34:29');
INSERT INTO `operation_log` VALUES (546, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:35:29');
INSERT INTO `operation_log` VALUES (547, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:36:29');
INSERT INTO `operation_log` VALUES (548, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:37:29');
INSERT INTO `operation_log` VALUES (549, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:38:29');
INSERT INTO `operation_log` VALUES (550, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:39:29');
INSERT INTO `operation_log` VALUES (551, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:40:29');
INSERT INTO `operation_log` VALUES (552, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:41:29');
INSERT INTO `operation_log` VALUES (553, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:42:29');
INSERT INTO `operation_log` VALUES (554, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:43:29');
INSERT INTO `operation_log` VALUES (555, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:44:29');
INSERT INTO `operation_log` VALUES (556, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:45:29');
INSERT INTO `operation_log` VALUES (557, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:46:29');
INSERT INTO `operation_log` VALUES (558, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:47:29');
INSERT INTO `operation_log` VALUES (559, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:48:29');
INSERT INTO `operation_log` VALUES (560, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:49:29');
INSERT INTO `operation_log` VALUES (561, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:50:29');
INSERT INTO `operation_log` VALUES (562, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:51:29');
INSERT INTO `operation_log` VALUES (563, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:52:29');
INSERT INTO `operation_log` VALUES (564, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 20:53:29');
INSERT INTO `operation_log` VALUES (565, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:26');
INSERT INTO `operation_log` VALUES (566, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:27');
INSERT INTO `operation_log` VALUES (567, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:27');
INSERT INTO `operation_log` VALUES (568, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:27');
INSERT INTO `operation_log` VALUES (569, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:29');
INSERT INTO `operation_log` VALUES (570, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:44');
INSERT INTO `operation_log` VALUES (571, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:44');
INSERT INTO `operation_log` VALUES (572, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:04:44');
INSERT INTO `operation_log` VALUES (573, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:05:44');
INSERT INTO `operation_log` VALUES (574, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:06:11');
INSERT INTO `operation_log` VALUES (575, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:06:17');
INSERT INTO `operation_log` VALUES (576, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:06:23');
INSERT INTO `operation_log` VALUES (577, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:07:23');
INSERT INTO `operation_log` VALUES (578, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:07:24');
INSERT INTO `operation_log` VALUES (579, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:08:25');
INSERT INTO `operation_log` VALUES (580, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:09:25');
INSERT INTO `operation_log` VALUES (581, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:10:25');
INSERT INTO `operation_log` VALUES (582, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:11:25');
INSERT INTO `operation_log` VALUES (583, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:12:25');
INSERT INTO `operation_log` VALUES (584, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:13:25');
INSERT INTO `operation_log` VALUES (585, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:14:29');
INSERT INTO `operation_log` VALUES (586, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:15:29');
INSERT INTO `operation_log` VALUES (587, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:16:29');
INSERT INTO `operation_log` VALUES (588, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:17:29');
INSERT INTO `operation_log` VALUES (589, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:18:29');
INSERT INTO `operation_log` VALUES (590, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:19:29');
INSERT INTO `operation_log` VALUES (591, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:20:29');
INSERT INTO `operation_log` VALUES (592, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:21:29');
INSERT INTO `operation_log` VALUES (593, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:22:29');
INSERT INTO `operation_log` VALUES (594, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:23:29');
INSERT INTO `operation_log` VALUES (595, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:24:29');
INSERT INTO `operation_log` VALUES (596, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:25:29');
INSERT INTO `operation_log` VALUES (597, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:26:29');
INSERT INTO `operation_log` VALUES (598, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:27:29');
INSERT INTO `operation_log` VALUES (599, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:28:29');
INSERT INTO `operation_log` VALUES (600, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:29:29');
INSERT INTO `operation_log` VALUES (601, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:30:29');
INSERT INTO `operation_log` VALUES (602, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:31:29');
INSERT INTO `operation_log` VALUES (603, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:32:29');
INSERT INTO `operation_log` VALUES (604, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:33:29');
INSERT INTO `operation_log` VALUES (605, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:34:29');
INSERT INTO `operation_log` VALUES (606, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:29');
INSERT INTO `operation_log` VALUES (607, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:44');
INSERT INTO `operation_log` VALUES (608, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:44');
INSERT INTO `operation_log` VALUES (609, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:44');
INSERT INTO `operation_log` VALUES (610, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:58');
INSERT INTO `operation_log` VALUES (611, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:58');
INSERT INTO `operation_log` VALUES (612, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:35:58');
INSERT INTO `operation_log` VALUES (613, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:36:08');
INSERT INTO `operation_log` VALUES (614, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:36:08');
INSERT INTO `operation_log` VALUES (615, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:36:08');
INSERT INTO `operation_log` VALUES (616, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:36:08');
INSERT INTO `operation_log` VALUES (617, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:36:12');
INSERT INTO `operation_log` VALUES (618, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:37:08');
INSERT INTO `operation_log` VALUES (619, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:37:23');
INSERT INTO `operation_log` VALUES (620, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:37:23');
INSERT INTO `operation_log` VALUES (621, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:37:23');
INSERT INTO `operation_log` VALUES (622, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:38:03');
INSERT INTO `operation_log` VALUES (623, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:38:03');
INSERT INTO `operation_log` VALUES (624, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:38:04');
INSERT INTO `operation_log` VALUES (625, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:39:04');
INSERT INTO `operation_log` VALUES (626, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:40:04');
INSERT INTO `operation_log` VALUES (627, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:04');
INSERT INTO `operation_log` VALUES (628, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:21');
INSERT INTO `operation_log` VALUES (629, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:21');
INSERT INTO `operation_log` VALUES (630, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:21');
INSERT INTO `operation_log` VALUES (631, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:21');
INSERT INTO `operation_log` VALUES (632, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:23');
INSERT INTO `operation_log` VALUES (633, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:32');
INSERT INTO `operation_log` VALUES (634, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:32');
INSERT INTO `operation_log` VALUES (635, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:32');
INSERT INTO `operation_log` VALUES (636, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:41');
INSERT INTO `operation_log` VALUES (637, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:41');
INSERT INTO `operation_log` VALUES (638, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:41:41');
INSERT INTO `operation_log` VALUES (639, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:42:41');
INSERT INTO `operation_log` VALUES (640, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:43:41');
INSERT INTO `operation_log` VALUES (641, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:44:41');
INSERT INTO `operation_log` VALUES (642, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:45:41');
INSERT INTO `operation_log` VALUES (643, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:46:41');
INSERT INTO `operation_log` VALUES (644, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:47:41');
INSERT INTO `operation_log` VALUES (645, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:48:42');
INSERT INTO `operation_log` VALUES (646, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:50:00');
INSERT INTO `operation_log` VALUES (647, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:50:12');
INSERT INTO `operation_log` VALUES (648, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:50:12');
INSERT INTO `operation_log` VALUES (649, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:50:12');
INSERT INTO `operation_log` VALUES (650, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:50:13');
INSERT INTO `operation_log` VALUES (651, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:50:24');
INSERT INTO `operation_log` VALUES (652, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:51:11');
INSERT INTO `operation_log` VALUES (653, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:51:11');
INSERT INTO `operation_log` VALUES (654, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:51:11');
INSERT INTO `operation_log` VALUES (655, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:52:11');
INSERT INTO `operation_log` VALUES (656, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:53:12');
INSERT INTO `operation_log` VALUES (657, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:54:12');
INSERT INTO `operation_log` VALUES (658, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:55:12');
INSERT INTO `operation_log` VALUES (659, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:56:12');
INSERT INTO `operation_log` VALUES (660, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:57:12');
INSERT INTO `operation_log` VALUES (661, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:58:29');
INSERT INTO `operation_log` VALUES (662, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 21:59:29');
INSERT INTO `operation_log` VALUES (663, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:00:29');
INSERT INTO `operation_log` VALUES (664, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:01:29');
INSERT INTO `operation_log` VALUES (665, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:02:29');
INSERT INTO `operation_log` VALUES (666, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:03:29');
INSERT INTO `operation_log` VALUES (667, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:04:29');
INSERT INTO `operation_log` VALUES (668, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:05:29');
INSERT INTO `operation_log` VALUES (669, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:06:29');
INSERT INTO `operation_log` VALUES (670, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:07:29');
INSERT INTO `operation_log` VALUES (671, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:08:29');
INSERT INTO `operation_log` VALUES (672, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:09:29');
INSERT INTO `operation_log` VALUES (673, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:10:29');
INSERT INTO `operation_log` VALUES (674, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:11:29');
INSERT INTO `operation_log` VALUES (675, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:12:29');
INSERT INTO `operation_log` VALUES (676, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:13:29');
INSERT INTO `operation_log` VALUES (677, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:14:29');
INSERT INTO `operation_log` VALUES (678, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:15:29');
INSERT INTO `operation_log` VALUES (679, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:16:29');
INSERT INTO `operation_log` VALUES (680, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:17:29');
INSERT INTO `operation_log` VALUES (681, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:18:29');
INSERT INTO `operation_log` VALUES (682, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:19:29');
INSERT INTO `operation_log` VALUES (683, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:20:29');
INSERT INTO `operation_log` VALUES (684, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:21:29');
INSERT INTO `operation_log` VALUES (685, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:22:29');
INSERT INTO `operation_log` VALUES (686, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:23:29');
INSERT INTO `operation_log` VALUES (687, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:24:29');
INSERT INTO `operation_log` VALUES (688, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:25:29');
INSERT INTO `operation_log` VALUES (689, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:26:29');
INSERT INTO `operation_log` VALUES (690, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:27:29');
INSERT INTO `operation_log` VALUES (691, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:28:29');
INSERT INTO `operation_log` VALUES (692, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:29:29');
INSERT INTO `operation_log` VALUES (693, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:30:29');
INSERT INTO `operation_log` VALUES (694, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:31:29');
INSERT INTO `operation_log` VALUES (695, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:32:29');
INSERT INTO `operation_log` VALUES (696, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:33:29');
INSERT INTO `operation_log` VALUES (697, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:34:29');
INSERT INTO `operation_log` VALUES (698, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:35:29');
INSERT INTO `operation_log` VALUES (699, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:36:29');
INSERT INTO `operation_log` VALUES (700, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:37:29');
INSERT INTO `operation_log` VALUES (701, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:38:29');
INSERT INTO `operation_log` VALUES (702, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:39:29');
INSERT INTO `operation_log` VALUES (703, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:40:29');
INSERT INTO `operation_log` VALUES (704, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:41:29');
INSERT INTO `operation_log` VALUES (705, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:42:29');
INSERT INTO `operation_log` VALUES (706, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:43:29');
INSERT INTO `operation_log` VALUES (707, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:44:29');
INSERT INTO `operation_log` VALUES (708, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:45:29');
INSERT INTO `operation_log` VALUES (709, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:46:29');
INSERT INTO `operation_log` VALUES (710, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:47:29');
INSERT INTO `operation_log` VALUES (711, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:48:29');
INSERT INTO `operation_log` VALUES (712, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:49:29');
INSERT INTO `operation_log` VALUES (713, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:50:29');
INSERT INTO `operation_log` VALUES (714, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:51:29');
INSERT INTO `operation_log` VALUES (715, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:52:29');
INSERT INTO `operation_log` VALUES (716, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:53:29');
INSERT INTO `operation_log` VALUES (717, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:54:29');
INSERT INTO `operation_log` VALUES (718, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:55:29');
INSERT INTO `operation_log` VALUES (719, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:56:29');
INSERT INTO `operation_log` VALUES (720, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:57:29');
INSERT INTO `operation_log` VALUES (721, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:58:29');
INSERT INTO `operation_log` VALUES (722, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 22:59:29');
INSERT INTO `operation_log` VALUES (723, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:00:29');
INSERT INTO `operation_log` VALUES (724, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:01:29');
INSERT INTO `operation_log` VALUES (725, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:02:29');
INSERT INTO `operation_log` VALUES (726, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:03:29');
INSERT INTO `operation_log` VALUES (727, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:04:29');
INSERT INTO `operation_log` VALUES (728, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:05:29');
INSERT INTO `operation_log` VALUES (729, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:06:29');
INSERT INTO `operation_log` VALUES (730, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:07:29');
INSERT INTO `operation_log` VALUES (731, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:08:29');
INSERT INTO `operation_log` VALUES (732, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:09:29');
INSERT INTO `operation_log` VALUES (733, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:10:29');
INSERT INTO `operation_log` VALUES (734, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:11:29');
INSERT INTO `operation_log` VALUES (735, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:12:29');
INSERT INTO `operation_log` VALUES (736, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:13:29');
INSERT INTO `operation_log` VALUES (737, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:14:29');
INSERT INTO `operation_log` VALUES (738, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:15:29');
INSERT INTO `operation_log` VALUES (739, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:16:29');
INSERT INTO `operation_log` VALUES (740, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:17:29');
INSERT INTO `operation_log` VALUES (741, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:18:29');
INSERT INTO `operation_log` VALUES (742, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:19:29');
INSERT INTO `operation_log` VALUES (743, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:20:29');
INSERT INTO `operation_log` VALUES (744, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:21:29');
INSERT INTO `operation_log` VALUES (745, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:22:29');
INSERT INTO `operation_log` VALUES (746, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:23:29');
INSERT INTO `operation_log` VALUES (747, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:24:29');
INSERT INTO `operation_log` VALUES (748, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:25:29');
INSERT INTO `operation_log` VALUES (749, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:26:29');
INSERT INTO `operation_log` VALUES (750, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:27:29');
INSERT INTO `operation_log` VALUES (751, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:28:29');
INSERT INTO `operation_log` VALUES (752, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:29:29');
INSERT INTO `operation_log` VALUES (753, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:30:29');
INSERT INTO `operation_log` VALUES (754, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:31:29');
INSERT INTO `operation_log` VALUES (755, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:32:29');
INSERT INTO `operation_log` VALUES (756, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:33:29');
INSERT INTO `operation_log` VALUES (757, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:34:29');
INSERT INTO `operation_log` VALUES (758, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:35:29');
INSERT INTO `operation_log` VALUES (759, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:36:29');
INSERT INTO `operation_log` VALUES (760, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:37:29');
INSERT INTO `operation_log` VALUES (761, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:38:29');
INSERT INTO `operation_log` VALUES (762, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:39:29');
INSERT INTO `operation_log` VALUES (763, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:40:29');
INSERT INTO `operation_log` VALUES (764, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:41:29');
INSERT INTO `operation_log` VALUES (765, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:42:29');
INSERT INTO `operation_log` VALUES (766, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:43:29');
INSERT INTO `operation_log` VALUES (767, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:44:29');
INSERT INTO `operation_log` VALUES (768, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:45:29');
INSERT INTO `operation_log` VALUES (769, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:46:29');
INSERT INTO `operation_log` VALUES (770, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:47:29');
INSERT INTO `operation_log` VALUES (771, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:48:29');
INSERT INTO `operation_log` VALUES (772, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-06 23:49:29');
INSERT INTO `operation_log` VALUES (773, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:33:03');
INSERT INTO `operation_log` VALUES (774, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:33:04');
INSERT INTO `operation_log` VALUES (775, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:33:04');
INSERT INTO `operation_log` VALUES (776, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:33:05');
INSERT INTO `operation_log` VALUES (777, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:33:09');
INSERT INTO `operation_log` VALUES (778, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:34:05');
INSERT INTO `operation_log` VALUES (779, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:35:05');
INSERT INTO `operation_log` VALUES (780, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:36:05');
INSERT INTO `operation_log` VALUES (781, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:37:05');
INSERT INTO `operation_log` VALUES (782, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 16:38:05');
INSERT INTO `operation_log` VALUES (783, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:07:53');
INSERT INTO `operation_log` VALUES (784, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:07:55');
INSERT INTO `operation_log` VALUES (785, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:07:55');
INSERT INTO `operation_log` VALUES (786, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:07:56');
INSERT INTO `operation_log` VALUES (787, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:08:02');
INSERT INTO `operation_log` VALUES (788, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:08:55');
INSERT INTO `operation_log` VALUES (789, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:09:43');
INSERT INTO `operation_log` VALUES (790, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:09:43');
INSERT INTO `operation_log` VALUES (791, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:09:43');
INSERT INTO `operation_log` VALUES (792, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:09:43');
INSERT INTO `operation_log` VALUES (793, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:09:47');
INSERT INTO `operation_log` VALUES (794, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:10:43');
INSERT INTO `operation_log` VALUES (795, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:11:43');
INSERT INTO `operation_log` VALUES (796, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:12:43');
INSERT INTO `operation_log` VALUES (797, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:13:43');
INSERT INTO `operation_log` VALUES (798, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:14:43');
INSERT INTO `operation_log` VALUES (799, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:15:43');
INSERT INTO `operation_log` VALUES (800, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:17:01');
INSERT INTO `operation_log` VALUES (801, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:18:01');
INSERT INTO `operation_log` VALUES (802, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:19:01');
INSERT INTO `operation_log` VALUES (803, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:20:01');
INSERT INTO `operation_log` VALUES (804, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:21:01');
INSERT INTO `operation_log` VALUES (805, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:22:01');
INSERT INTO `operation_log` VALUES (806, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:23:01');
INSERT INTO `operation_log` VALUES (807, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:24:01');
INSERT INTO `operation_log` VALUES (808, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:25:01');
INSERT INTO `operation_log` VALUES (809, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:26:01');
INSERT INTO `operation_log` VALUES (810, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:27:01');
INSERT INTO `operation_log` VALUES (811, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:28:01');
INSERT INTO `operation_log` VALUES (812, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:29:01');
INSERT INTO `operation_log` VALUES (813, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:30:01');
INSERT INTO `operation_log` VALUES (814, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:31:01');
INSERT INTO `operation_log` VALUES (815, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:32:01');
INSERT INTO `operation_log` VALUES (816, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:33:01');
INSERT INTO `operation_log` VALUES (817, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:34:01');
INSERT INTO `operation_log` VALUES (818, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:35:01');
INSERT INTO `operation_log` VALUES (819, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:36:01');
INSERT INTO `operation_log` VALUES (820, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:37:01');
INSERT INTO `operation_log` VALUES (821, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:38:01');
INSERT INTO `operation_log` VALUES (822, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:39:01');
INSERT INTO `operation_log` VALUES (823, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:40:01');
INSERT INTO `operation_log` VALUES (824, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:41:01');
INSERT INTO `operation_log` VALUES (825, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:42:01');
INSERT INTO `operation_log` VALUES (826, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:43:01');
INSERT INTO `operation_log` VALUES (827, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:44:01');
INSERT INTO `operation_log` VALUES (828, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:45:01');
INSERT INTO `operation_log` VALUES (829, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:46:01');
INSERT INTO `operation_log` VALUES (830, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:47:01');
INSERT INTO `operation_log` VALUES (831, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:48:01');
INSERT INTO `operation_log` VALUES (832, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:49:01');
INSERT INTO `operation_log` VALUES (833, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:50:01');
INSERT INTO `operation_log` VALUES (834, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:51:01');
INSERT INTO `operation_log` VALUES (835, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:52:01');
INSERT INTO `operation_log` VALUES (836, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:53:01');
INSERT INTO `operation_log` VALUES (837, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:54:01');
INSERT INTO `operation_log` VALUES (838, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:55:01');
INSERT INTO `operation_log` VALUES (839, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:56:01');
INSERT INTO `operation_log` VALUES (840, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:57:01');
INSERT INTO `operation_log` VALUES (841, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:58:01');
INSERT INTO `operation_log` VALUES (842, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 17:59:01');
INSERT INTO `operation_log` VALUES (843, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:00:01');
INSERT INTO `operation_log` VALUES (844, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:01:01');
INSERT INTO `operation_log` VALUES (845, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:02:01');
INSERT INTO `operation_log` VALUES (846, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:03:01');
INSERT INTO `operation_log` VALUES (847, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:04:01');
INSERT INTO `operation_log` VALUES (848, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:05:01');
INSERT INTO `operation_log` VALUES (849, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:06:01');
INSERT INTO `operation_log` VALUES (850, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:07:01');
INSERT INTO `operation_log` VALUES (851, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:08:01');
INSERT INTO `operation_log` VALUES (852, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:09:01');
INSERT INTO `operation_log` VALUES (853, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:10:01');
INSERT INTO `operation_log` VALUES (854, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:11:01');
INSERT INTO `operation_log` VALUES (855, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:12:01');
INSERT INTO `operation_log` VALUES (856, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:13:01');
INSERT INTO `operation_log` VALUES (857, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:14:01');
INSERT INTO `operation_log` VALUES (858, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:15:01');
INSERT INTO `operation_log` VALUES (859, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:16:01');
INSERT INTO `operation_log` VALUES (860, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:17:01');
INSERT INTO `operation_log` VALUES (861, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:18:01');
INSERT INTO `operation_log` VALUES (862, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:19:01');
INSERT INTO `operation_log` VALUES (863, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:20:01');
INSERT INTO `operation_log` VALUES (864, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:21:01');
INSERT INTO `operation_log` VALUES (865, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:22:01');
INSERT INTO `operation_log` VALUES (866, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:23:01');
INSERT INTO `operation_log` VALUES (867, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:24:01');
INSERT INTO `operation_log` VALUES (868, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:25:01');
INSERT INTO `operation_log` VALUES (869, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:26:01');
INSERT INTO `operation_log` VALUES (870, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:27:01');
INSERT INTO `operation_log` VALUES (871, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:28:01');
INSERT INTO `operation_log` VALUES (872, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:29:01');
INSERT INTO `operation_log` VALUES (873, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:30:01');
INSERT INTO `operation_log` VALUES (874, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:31:01');
INSERT INTO `operation_log` VALUES (875, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:32:01');
INSERT INTO `operation_log` VALUES (876, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:33:01');
INSERT INTO `operation_log` VALUES (877, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:34:01');
INSERT INTO `operation_log` VALUES (878, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:35:01');
INSERT INTO `operation_log` VALUES (879, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:36:01');
INSERT INTO `operation_log` VALUES (880, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:37:01');
INSERT INTO `operation_log` VALUES (881, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:38:01');
INSERT INTO `operation_log` VALUES (882, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:39:01');
INSERT INTO `operation_log` VALUES (883, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:40:01');
INSERT INTO `operation_log` VALUES (884, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:41:01');
INSERT INTO `operation_log` VALUES (885, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:42:01');
INSERT INTO `operation_log` VALUES (886, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:43:01');
INSERT INTO `operation_log` VALUES (887, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:44:01');
INSERT INTO `operation_log` VALUES (888, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:45:01');
INSERT INTO `operation_log` VALUES (889, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:46:01');
INSERT INTO `operation_log` VALUES (890, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:47:01');
INSERT INTO `operation_log` VALUES (891, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:48:01');
INSERT INTO `operation_log` VALUES (892, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:49:01');
INSERT INTO `operation_log` VALUES (893, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:50:01');
INSERT INTO `operation_log` VALUES (894, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:51:01');
INSERT INTO `operation_log` VALUES (895, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:52:01');
INSERT INTO `operation_log` VALUES (896, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:53:01');
INSERT INTO `operation_log` VALUES (897, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:54:01');
INSERT INTO `operation_log` VALUES (898, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:55:01');
INSERT INTO `operation_log` VALUES (899, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:56:01');
INSERT INTO `operation_log` VALUES (900, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:57:01');
INSERT INTO `operation_log` VALUES (901, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:58:01');
INSERT INTO `operation_log` VALUES (902, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 18:59:01');
INSERT INTO `operation_log` VALUES (903, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:00:01');
INSERT INTO `operation_log` VALUES (904, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:01:01');
INSERT INTO `operation_log` VALUES (905, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:02:01');
INSERT INTO `operation_log` VALUES (906, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:03:01');
INSERT INTO `operation_log` VALUES (907, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:04:01');
INSERT INTO `operation_log` VALUES (908, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:05:01');
INSERT INTO `operation_log` VALUES (909, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:06:01');
INSERT INTO `operation_log` VALUES (910, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:07:01');
INSERT INTO `operation_log` VALUES (911, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:08:01');
INSERT INTO `operation_log` VALUES (912, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 19:09:01');
INSERT INTO `operation_log` VALUES (913, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:33:58');
INSERT INTO `operation_log` VALUES (914, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:33:59');
INSERT INTO `operation_log` VALUES (915, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:33:59');
INSERT INTO `operation_log` VALUES (916, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:33:59');
INSERT INTO `operation_log` VALUES (917, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:34:01');
INSERT INTO `operation_log` VALUES (918, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:34:03');
INSERT INTO `operation_log` VALUES (919, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:34:11');
INSERT INTO `operation_log` VALUES (920, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:34:11');
INSERT INTO `operation_log` VALUES (921, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:34:13');
INSERT INTO `operation_log` VALUES (922, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:34:30');
INSERT INTO `operation_log` VALUES (923, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:35:11');
INSERT INTO `operation_log` VALUES (924, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:28');
INSERT INTO `operation_log` VALUES (925, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:29');
INSERT INTO `operation_log` VALUES (926, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:29');
INSERT INTO `operation_log` VALUES (927, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:29');
INSERT INTO `operation_log` VALUES (928, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:34');
INSERT INTO `operation_log` VALUES (929, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:41');
INSERT INTO `operation_log` VALUES (930, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:41');
INSERT INTO `operation_log` VALUES (931, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:36:41');
INSERT INTO `operation_log` VALUES (932, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:37:41');
INSERT INTO `operation_log` VALUES (933, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:38:41');
INSERT INTO `operation_log` VALUES (934, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:39:41');
INSERT INTO `operation_log` VALUES (935, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:40:41');
INSERT INTO `operation_log` VALUES (936, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:41:41');
INSERT INTO `operation_log` VALUES (937, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:42:41');
INSERT INTO `operation_log` VALUES (938, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:44:01');
INSERT INTO `operation_log` VALUES (939, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:45:01');
INSERT INTO `operation_log` VALUES (940, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:00');
INSERT INTO `operation_log` VALUES (941, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:00');
INSERT INTO `operation_log` VALUES (942, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:00');
INSERT INTO `operation_log` VALUES (943, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:17');
INSERT INTO `operation_log` VALUES (944, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:17');
INSERT INTO `operation_log` VALUES (945, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:17');
INSERT INTO `operation_log` VALUES (946, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:17');
INSERT INTO `operation_log` VALUES (947, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:19');
INSERT INTO `operation_log` VALUES (948, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:33');
INSERT INTO `operation_log` VALUES (949, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:33');
INSERT INTO `operation_log` VALUES (950, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:46:33');
INSERT INTO `operation_log` VALUES (951, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:47:34');
INSERT INTO `operation_log` VALUES (952, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:48:34');
INSERT INTO `operation_log` VALUES (953, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:49:34');
INSERT INTO `operation_log` VALUES (954, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:49:39');
INSERT INTO `operation_log` VALUES (955, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:49:39');
INSERT INTO `operation_log` VALUES (956, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:42');
INSERT INTO `operation_log` VALUES (957, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:43');
INSERT INTO `operation_log` VALUES (958, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:43');
INSERT INTO `operation_log` VALUES (959, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:43');
INSERT INTO `operation_log` VALUES (960, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:45');
INSERT INTO `operation_log` VALUES (961, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:52');
INSERT INTO `operation_log` VALUES (962, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:52');
INSERT INTO `operation_log` VALUES (963, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:52:52');
INSERT INTO `operation_log` VALUES (964, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:53:52');
INSERT INTO `operation_log` VALUES (965, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:54:02');
INSERT INTO `operation_log` VALUES (966, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:54:12');
INSERT INTO `operation_log` VALUES (967, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:54:12');
INSERT INTO `operation_log` VALUES (968, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:54:12');
INSERT INTO `operation_log` VALUES (969, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:55:12');
INSERT INTO `operation_log` VALUES (970, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:56:12');
INSERT INTO `operation_log` VALUES (971, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:57:12');
INSERT INTO `operation_log` VALUES (972, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:58:12');
INSERT INTO `operation_log` VALUES (973, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 20:59:12');
INSERT INTO `operation_log` VALUES (974, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:00:12');
INSERT INTO `operation_log` VALUES (975, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:01:46');
INSERT INTO `operation_log` VALUES (976, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:02:47');
INSERT INTO `operation_log` VALUES (977, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:03:48');
INSERT INTO `operation_log` VALUES (978, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:04:49');
INSERT INTO `operation_log` VALUES (979, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:05:50');
INSERT INTO `operation_log` VALUES (980, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:06:51');
INSERT INTO `operation_log` VALUES (981, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:07:52');
INSERT INTO `operation_log` VALUES (982, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:08:53');
INSERT INTO `operation_log` VALUES (983, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:09:54');
INSERT INTO `operation_log` VALUES (984, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:10:55');
INSERT INTO `operation_log` VALUES (985, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:11:56');
INSERT INTO `operation_log` VALUES (986, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:12:57');
INSERT INTO `operation_log` VALUES (987, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:13:58');
INSERT INTO `operation_log` VALUES (988, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:14:59');
INSERT INTO `operation_log` VALUES (989, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:16:00');
INSERT INTO `operation_log` VALUES (990, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:17:01');
INSERT INTO `operation_log` VALUES (991, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:18:01');
INSERT INTO `operation_log` VALUES (992, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:19:01');
INSERT INTO `operation_log` VALUES (993, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:20:01');
INSERT INTO `operation_log` VALUES (994, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:21:01');
INSERT INTO `operation_log` VALUES (995, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:22:01');
INSERT INTO `operation_log` VALUES (996, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:23:01');
INSERT INTO `operation_log` VALUES (997, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:24:01');
INSERT INTO `operation_log` VALUES (998, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:24:04');
INSERT INTO `operation_log` VALUES (999, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:24:04');
INSERT INTO `operation_log` VALUES (1000, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:24:04');
INSERT INTO `operation_log` VALUES (1001, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:25:05');
INSERT INTO `operation_log` VALUES (1002, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:05');
INSERT INTO `operation_log` VALUES (1003, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:42');
INSERT INTO `operation_log` VALUES (1004, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:42');
INSERT INTO `operation_log` VALUES (1005, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:42');
INSERT INTO `operation_log` VALUES (1006, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:56');
INSERT INTO `operation_log` VALUES (1007, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:56');
INSERT INTO `operation_log` VALUES (1008, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:56');
INSERT INTO `operation_log` VALUES (1009, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:56');
INSERT INTO `operation_log` VALUES (1010, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:26:58');
INSERT INTO `operation_log` VALUES (1011, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:27:57');
INSERT INTO `operation_log` VALUES (1012, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:28:57');
INSERT INTO `operation_log` VALUES (1013, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:29:57');
INSERT INTO `operation_log` VALUES (1014, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:30:57');
INSERT INTO `operation_log` VALUES (1015, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:31:57');
INSERT INTO `operation_log` VALUES (1016, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:32:57');
INSERT INTO `operation_log` VALUES (1017, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:34:01');
INSERT INTO `operation_log` VALUES (1018, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:34:12');
INSERT INTO `operation_log` VALUES (1019, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:34:12');
INSERT INTO `operation_log` VALUES (1020, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:34:12');
INSERT INTO `operation_log` VALUES (1021, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:35:12');
INSERT INTO `operation_log` VALUES (1022, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:38:08');
INSERT INTO `operation_log` VALUES (1023, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:38:08');
INSERT INTO `operation_log` VALUES (1024, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:38:08');
INSERT INTO `operation_log` VALUES (1025, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:38:08');
INSERT INTO `operation_log` VALUES (1026, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:38:11');
INSERT INTO `operation_log` VALUES (1027, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:39:09');
INSERT INTO `operation_log` VALUES (1028, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:09');
INSERT INTO `operation_log` VALUES (1029, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:13');
INSERT INTO `operation_log` VALUES (1030, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:13');
INSERT INTO `operation_log` VALUES (1031, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:13');
INSERT INTO `operation_log` VALUES (1032, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:28');
INSERT INTO `operation_log` VALUES (1033, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:28');
INSERT INTO `operation_log` VALUES (1034, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:28');
INSERT INTO `operation_log` VALUES (1035, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:28');
INSERT INTO `operation_log` VALUES (1036, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:40:31');
INSERT INTO `operation_log` VALUES (1037, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:41:29');
INSERT INTO `operation_log` VALUES (1038, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:42:29');
INSERT INTO `operation_log` VALUES (1039, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:43:29');
INSERT INTO `operation_log` VALUES (1040, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:44:29');
INSERT INTO `operation_log` VALUES (1041, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:44:49');
INSERT INTO `operation_log` VALUES (1042, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:44:49');
INSERT INTO `operation_log` VALUES (1043, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:44:49');
INSERT INTO `operation_log` VALUES (1044, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:45:33');
INSERT INTO `operation_log` VALUES (1045, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:45:33');
INSERT INTO `operation_log` VALUES (1046, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:45:33');
INSERT INTO `operation_log` VALUES (1047, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:45:33');
INSERT INTO `operation_log` VALUES (1048, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:45:47');
INSERT INTO `operation_log` VALUES (1049, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:46:34');
INSERT INTO `operation_log` VALUES (1050, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:47:16');
INSERT INTO `operation_log` VALUES (1051, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:47:16');
INSERT INTO `operation_log` VALUES (1052, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:47:16');
INSERT INTO `operation_log` VALUES (1053, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:48:17');
INSERT INTO `operation_log` VALUES (1054, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:49:17');
INSERT INTO `operation_log` VALUES (1055, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:50:17');
INSERT INTO `operation_log` VALUES (1056, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:51:17');
INSERT INTO `operation_log` VALUES (1057, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:52:10');
INSERT INTO `operation_log` VALUES (1058, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:52:10');
INSERT INTO `operation_log` VALUES (1059, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:52:10');
INSERT INTO `operation_log` VALUES (1060, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:52:45');
INSERT INTO `operation_log` VALUES (1061, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:52:45');
INSERT INTO `operation_log` VALUES (1062, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:52:45');
INSERT INTO `operation_log` VALUES (1063, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:53:45');
INSERT INTO `operation_log` VALUES (1064, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:54:45');
INSERT INTO `operation_log` VALUES (1065, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:27');
INSERT INTO `operation_log` VALUES (1066, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:27');
INSERT INTO `operation_log` VALUES (1067, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:27');
INSERT INTO `operation_log` VALUES (1068, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:39');
INSERT INTO `operation_log` VALUES (1069, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:39');
INSERT INTO `operation_log` VALUES (1070, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:39');
INSERT INTO `operation_log` VALUES (1071, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:39');
INSERT INTO `operation_log` VALUES (1072, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:55:46');
INSERT INTO `operation_log` VALUES (1073, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:56:39');
INSERT INTO `operation_log` VALUES (1074, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:57:39');
INSERT INTO `operation_log` VALUES (1075, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:58:39');
INSERT INTO `operation_log` VALUES (1076, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 21:59:39');
INSERT INTO `operation_log` VALUES (1077, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:03:18');
INSERT INTO `operation_log` VALUES (1078, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:03:19');
INSERT INTO `operation_log` VALUES (1079, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:03:19');
INSERT INTO `operation_log` VALUES (1080, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:03:19');
INSERT INTO `operation_log` VALUES (1081, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:03:21');
INSERT INTO `operation_log` VALUES (1082, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:04:19');
INSERT INTO `operation_log` VALUES (1083, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:05:19');
INSERT INTO `operation_log` VALUES (1084, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:06:19');
INSERT INTO `operation_log` VALUES (1085, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:07:02');
INSERT INTO `operation_log` VALUES (1086, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:07:02');
INSERT INTO `operation_log` VALUES (1087, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:07:02');
INSERT INTO `operation_log` VALUES (1088, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:08:02');
INSERT INTO `operation_log` VALUES (1089, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:09:02');
INSERT INTO `operation_log` VALUES (1090, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:10:02');
INSERT INTO `operation_log` VALUES (1091, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:11:02');
INSERT INTO `operation_log` VALUES (1092, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:13:33');
INSERT INTO `operation_log` VALUES (1093, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:13:33');
INSERT INTO `operation_log` VALUES (1094, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:13:33');
INSERT INTO `operation_log` VALUES (1095, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:13:33');
INSERT INTO `operation_log` VALUES (1096, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:13:35');
INSERT INTO `operation_log` VALUES (1097, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:14:34');
INSERT INTO `operation_log` VALUES (1098, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:15:34');
INSERT INTO `operation_log` VALUES (1099, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:16:34');
INSERT INTO `operation_log` VALUES (1100, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:17:34');
INSERT INTO `operation_log` VALUES (1101, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:15');
INSERT INTO `operation_log` VALUES (1102, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:15');
INSERT INTO `operation_log` VALUES (1103, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:29');
INSERT INTO `operation_log` VALUES (1104, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:29');
INSERT INTO `operation_log` VALUES (1105, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:29');
INSERT INTO `operation_log` VALUES (1106, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:29');
INSERT INTO `operation_log` VALUES (1107, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:32');
INSERT INTO `operation_log` VALUES (1108, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:33');
INSERT INTO `operation_log` VALUES (1109, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:18:33');
INSERT INTO `operation_log` VALUES (1110, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:19:27');
INSERT INTO `operation_log` VALUES (1111, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:19:27');
INSERT INTO `operation_log` VALUES (1112, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:19:27');
INSERT INTO `operation_log` VALUES (1113, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:20:27');
INSERT INTO `operation_log` VALUES (1114, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:20:28');
INSERT INTO `operation_log` VALUES (1115, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:20:28');
INSERT INTO `operation_log` VALUES (1116, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:20:28');
INSERT INTO `operation_log` VALUES (1117, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:21:28');
INSERT INTO `operation_log` VALUES (1118, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:23');
INSERT INTO `operation_log` VALUES (1119, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:23');
INSERT INTO `operation_log` VALUES (1120, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:23');
INSERT INTO `operation_log` VALUES (1121, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:23');
INSERT INTO `operation_log` VALUES (1122, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:35');
INSERT INTO `operation_log` VALUES (1123, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:52');
INSERT INTO `operation_log` VALUES (1124, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:22:52');
INSERT INTO `operation_log` VALUES (1125, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:22');
INSERT INTO `operation_log` VALUES (1126, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:23');
INSERT INTO `operation_log` VALUES (1127, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:27');
INSERT INTO `operation_log` VALUES (1128, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:27');
INSERT INTO `operation_log` VALUES (1129, 1, 'admin', '其他', 'POST', 'POST /permission/assign', '[{\"roleId\":2,\"permissionIds\":[23,75,76,77,28,29,32,38,43,47,51,55,57,58,59,61,62,63,66,68,69,70,72,73,74]}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:55');
INSERT INTO `operation_log` VALUES (1130, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:55');
INSERT INTO `operation_log` VALUES (1131, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:58');
INSERT INTO `operation_log` VALUES (1132, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:23:58');
INSERT INTO `operation_log` VALUES (1133, 1, 'admin', '其他', 'POST', 'POST /permission/assign', '[{\"roleId\":2,\"permissionIds\":[23,75,76,77,28,32,38,43,47,51,55,57,58,59,61,62,63,66,68,69,70,72,73,74]}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:10');
INSERT INTO `operation_log` VALUES (1134, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:10');
INSERT INTO `operation_log` VALUES (1135, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:13');
INSERT INTO `operation_log` VALUES (1136, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:13');
INSERT INTO `operation_log` VALUES (1137, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:23');
INSERT INTO `operation_log` VALUES (1138, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:24');
INSERT INTO `operation_log` VALUES (1139, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:24');
INSERT INTO `operation_log` VALUES (1140, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:24');
INSERT INTO `operation_log` VALUES (1141, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:29');
INSERT INTO `operation_log` VALUES (1142, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:32');
INSERT INTO `operation_log` VALUES (1143, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:39');
INSERT INTO `operation_log` VALUES (1144, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:40');
INSERT INTO `operation_log` VALUES (1145, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:42');
INSERT INTO `operation_log` VALUES (1146, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:44');
INSERT INTO `operation_log` VALUES (1147, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:24:44');
INSERT INTO `operation_log` VALUES (1148, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:25:24');
INSERT INTO `operation_log` VALUES (1149, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:26:24');
INSERT INTO `operation_log` VALUES (1150, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:26:28');
INSERT INTO `operation_log` VALUES (1151, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:15');
INSERT INTO `operation_log` VALUES (1152, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:15');
INSERT INTO `operation_log` VALUES (1153, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:17');
INSERT INTO `operation_log` VALUES (1154, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:24');
INSERT INTO `operation_log` VALUES (1155, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:39');
INSERT INTO `operation_log` VALUES (1156, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:47');
INSERT INTO `operation_log` VALUES (1157, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:51');
INSERT INTO `operation_log` VALUES (1158, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:27:58');
INSERT INTO `operation_log` VALUES (1159, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:15');
INSERT INTO `operation_log` VALUES (1160, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:19');
INSERT INTO `operation_log` VALUES (1161, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:23');
INSERT INTO `operation_log` VALUES (1162, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:24');
INSERT INTO `operation_log` VALUES (1163, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:27');
INSERT INTO `operation_log` VALUES (1164, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:29');
INSERT INTO `operation_log` VALUES (1165, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:35');
INSERT INTO `operation_log` VALUES (1166, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:36');
INSERT INTO `operation_log` VALUES (1167, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:36');
INSERT INTO `operation_log` VALUES (1168, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:36');
INSERT INTO `operation_log` VALUES (1169, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:51');
INSERT INTO `operation_log` VALUES (1170, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:51');
INSERT INTO `operation_log` VALUES (1171, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:51');
INSERT INTO `operation_log` VALUES (1172, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:51');
INSERT INTO `operation_log` VALUES (1173, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:55');
INSERT INTO `operation_log` VALUES (1174, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:55');
INSERT INTO `operation_log` VALUES (1175, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:58');
INSERT INTO `operation_log` VALUES (1176, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:58');
INSERT INTO `operation_log` VALUES (1177, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:28:59');
INSERT INTO `operation_log` VALUES (1178, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:29:03');
INSERT INTO `operation_log` VALUES (1179, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:29:03');
INSERT INTO `operation_log` VALUES (1180, 1, 'admin', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:29:06');
INSERT INTO `operation_log` VALUES (1181, 1, 'admin', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-08, 2026-08-07, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:29:06');
INSERT INTO `operation_log` VALUES (1182, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[2026-07-08, 2026-08-07, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:29:06');
INSERT INTO `operation_log` VALUES (1183, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:29:24');
INSERT INTO `operation_log` VALUES (1184, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:30:24');
INSERT INTO `operation_log` VALUES (1185, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:31:10');
INSERT INTO `operation_log` VALUES (1186, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:31:10');
INSERT INTO `operation_log` VALUES (1187, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:31:24');
INSERT INTO `operation_log` VALUES (1188, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:31:53');
INSERT INTO `operation_log` VALUES (1189, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:31:56');
INSERT INTO `operation_log` VALUES (1190, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:04');
INSERT INTO `operation_log` VALUES (1191, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:19');
INSERT INTO `operation_log` VALUES (1192, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:20');
INSERT INTO `operation_log` VALUES (1193, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:24');
INSERT INTO `operation_log` VALUES (1194, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:32');
INSERT INTO `operation_log` VALUES (1195, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:34');
INSERT INTO `operation_log` VALUES (1196, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:34');
INSERT INTO `operation_log` VALUES (1197, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:34');
INSERT INTO `operation_log` VALUES (1198, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:37');
INSERT INTO `operation_log` VALUES (1199, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:37');
INSERT INTO `operation_log` VALUES (1200, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:37');
INSERT INTO `operation_log` VALUES (1201, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:37');
INSERT INTO `operation_log` VALUES (1202, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:38');
INSERT INTO `operation_log` VALUES (1203, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:38');
INSERT INTO `operation_log` VALUES (1204, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:32:42');
INSERT INTO `operation_log` VALUES (1205, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:33:24');
INSERT INTO `operation_log` VALUES (1206, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:33:25');
INSERT INTO `operation_log` VALUES (1207, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:33:27');
INSERT INTO `operation_log` VALUES (1208, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:24');
INSERT INTO `operation_log` VALUES (1209, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:38');
INSERT INTO `operation_log` VALUES (1210, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:39');
INSERT INTO `operation_log` VALUES (1211, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:51');
INSERT INTO `operation_log` VALUES (1212, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:53');
INSERT INTO `operation_log` VALUES (1213, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:53');
INSERT INTO `operation_log` VALUES (1214, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:34:53');
INSERT INTO `operation_log` VALUES (1215, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:24');
INSERT INTO `operation_log` VALUES (1216, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:33');
INSERT INTO `operation_log` VALUES (1217, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:33');
INSERT INTO `operation_log` VALUES (1218, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:33');
INSERT INTO `operation_log` VALUES (1219, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:34');
INSERT INTO `operation_log` VALUES (1220, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:48');
INSERT INTO `operation_log` VALUES (1221, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:48');
INSERT INTO `operation_log` VALUES (1222, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:48');
INSERT INTO `operation_log` VALUES (1223, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:52');
INSERT INTO `operation_log` VALUES (1224, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:35:52');
INSERT INTO `operation_log` VALUES (1225, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:36:24');
INSERT INTO `operation_log` VALUES (1226, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:37:49');
INSERT INTO `operation_log` VALUES (1227, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:37:51');
INSERT INTO `operation_log` VALUES (1228, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:38:24');
INSERT INTO `operation_log` VALUES (1229, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:39:24');
INSERT INTO `operation_log` VALUES (1230, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:41:01');
INSERT INTO `operation_log` VALUES (1231, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:42:01');
INSERT INTO `operation_log` VALUES (1232, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:43:01');
INSERT INTO `operation_log` VALUES (1233, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:01');
INSERT INTO `operation_log` VALUES (1234, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:20');
INSERT INTO `operation_log` VALUES (1235, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:24');
INSERT INTO `operation_log` VALUES (1236, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:25');
INSERT INTO `operation_log` VALUES (1237, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:26');
INSERT INTO `operation_log` VALUES (1238, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:26');
INSERT INTO `operation_log` VALUES (1239, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:29');
INSERT INTO `operation_log` VALUES (1240, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:29');
INSERT INTO `operation_log` VALUES (1241, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:31');
INSERT INTO `operation_log` VALUES (1242, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:31');
INSERT INTO `operation_log` VALUES (1243, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:32');
INSERT INTO `operation_log` VALUES (1244, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:36');
INSERT INTO `operation_log` VALUES (1245, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:44:39');
INSERT INTO `operation_log` VALUES (1246, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:45:24');
INSERT INTO `operation_log` VALUES (1247, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:46:29');
INSERT INTO `operation_log` VALUES (1248, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:46:52');
INSERT INTO `operation_log` VALUES (1249, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:46:52');
INSERT INTO `operation_log` VALUES (1250, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:46:59');
INSERT INTO `operation_log` VALUES (1251, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:46:59');
INSERT INTO `operation_log` VALUES (1252, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:14');
INSERT INTO `operation_log` VALUES (1253, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:14');
INSERT INTO `operation_log` VALUES (1254, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:15');
INSERT INTO `operation_log` VALUES (1255, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:15');
INSERT INTO `operation_log` VALUES (1256, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:31');
INSERT INTO `operation_log` VALUES (1257, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:31');
INSERT INTO `operation_log` VALUES (1258, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:31');
INSERT INTO `operation_log` VALUES (1259, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:40');
INSERT INTO `operation_log` VALUES (1260, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:40');
INSERT INTO `operation_log` VALUES (1261, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:40');
INSERT INTO `operation_log` VALUES (1262, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:48');
INSERT INTO `operation_log` VALUES (1263, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:48');
INSERT INTO `operation_log` VALUES (1264, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:48');
INSERT INTO `operation_log` VALUES (1265, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:47:48');
INSERT INTO `operation_log` VALUES (1266, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:48:49');
INSERT INTO `operation_log` VALUES (1267, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:00');
INSERT INTO `operation_log` VALUES (1268, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:00');
INSERT INTO `operation_log` VALUES (1269, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:00');
INSERT INTO `operation_log` VALUES (1270, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:01');
INSERT INTO `operation_log` VALUES (1271, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:01');
INSERT INTO `operation_log` VALUES (1272, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:01');
INSERT INTO `operation_log` VALUES (1273, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:05');
INSERT INTO `operation_log` VALUES (1274, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:05');
INSERT INTO `operation_log` VALUES (1275, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:05');
INSERT INTO `operation_log` VALUES (1276, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:36');
INSERT INTO `operation_log` VALUES (1277, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:36');
INSERT INTO `operation_log` VALUES (1278, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:36');
INSERT INTO `operation_log` VALUES (1279, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:37');
INSERT INTO `operation_log` VALUES (1280, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:37');
INSERT INTO `operation_log` VALUES (1281, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:37');
INSERT INTO `operation_log` VALUES (1282, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:37');
INSERT INTO `operation_log` VALUES (1283, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:37');
INSERT INTO `operation_log` VALUES (1284, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:38');
INSERT INTO `operation_log` VALUES (1285, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:39');
INSERT INTO `operation_log` VALUES (1286, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:39');
INSERT INTO `operation_log` VALUES (1287, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:39');
INSERT INTO `operation_log` VALUES (1288, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:40');
INSERT INTO `operation_log` VALUES (1289, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:40');
INSERT INTO `operation_log` VALUES (1290, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:40');
INSERT INTO `operation_log` VALUES (1291, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:58');
INSERT INTO `operation_log` VALUES (1292, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:59');
INSERT INTO `operation_log` VALUES (1293, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:59');
INSERT INTO `operation_log` VALUES (1294, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:49:59');
INSERT INTO `operation_log` VALUES (1295, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:50:59');
INSERT INTO `operation_log` VALUES (1296, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:51:59');
INSERT INTO `operation_log` VALUES (1297, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:52:59');
INSERT INTO `operation_log` VALUES (1298, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:53:59');
INSERT INTO `operation_log` VALUES (1299, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:54:00');
INSERT INTO `operation_log` VALUES (1300, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:54:00');
INSERT INTO `operation_log` VALUES (1301, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:54:00');
INSERT INTO `operation_log` VALUES (1302, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:55:00');
INSERT INTO `operation_log` VALUES (1303, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:56:00');
INSERT INTO `operation_log` VALUES (1304, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:00');
INSERT INTO `operation_log` VALUES (1305, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:22');
INSERT INTO `operation_log` VALUES (1306, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:22');
INSERT INTO `operation_log` VALUES (1307, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:22');
INSERT INTO `operation_log` VALUES (1308, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:29');
INSERT INTO `operation_log` VALUES (1309, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:30');
INSERT INTO `operation_log` VALUES (1310, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:30');
INSERT INTO `operation_log` VALUES (1311, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:33');
INSERT INTO `operation_log` VALUES (1312, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:35');
INSERT INTO `operation_log` VALUES (1313, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:37');
INSERT INTO `operation_log` VALUES (1314, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:38');
INSERT INTO `operation_log` VALUES (1315, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:39');
INSERT INTO `operation_log` VALUES (1316, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:57:40');
INSERT INTO `operation_log` VALUES (1317, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:58:22');
INSERT INTO `operation_log` VALUES (1318, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 22:59:22');
INSERT INTO `operation_log` VALUES (1319, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:00:22');
INSERT INTO `operation_log` VALUES (1320, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:01:22');
INSERT INTO `operation_log` VALUES (1321, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:02:22');
INSERT INTO `operation_log` VALUES (1322, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:03:22');
INSERT INTO `operation_log` VALUES (1323, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:04:56');
INSERT INTO `operation_log` VALUES (1324, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:05:57');
INSERT INTO `operation_log` VALUES (1325, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:06:58');
INSERT INTO `operation_log` VALUES (1326, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:07:59');
INSERT INTO `operation_log` VALUES (1327, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:09:00');
INSERT INTO `operation_log` VALUES (1328, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:10:01');
INSERT INTO `operation_log` VALUES (1329, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:11:01');
INSERT INTO `operation_log` VALUES (1330, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:12:01');
INSERT INTO `operation_log` VALUES (1331, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:13:01');
INSERT INTO `operation_log` VALUES (1332, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:14:01');
INSERT INTO `operation_log` VALUES (1333, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:15:01');
INSERT INTO `operation_log` VALUES (1334, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:16:01');
INSERT INTO `operation_log` VALUES (1335, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:17:01');
INSERT INTO `operation_log` VALUES (1336, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:18:01');
INSERT INTO `operation_log` VALUES (1337, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:19:01');
INSERT INTO `operation_log` VALUES (1338, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:20:01');
INSERT INTO `operation_log` VALUES (1339, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:21:01');
INSERT INTO `operation_log` VALUES (1340, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:22:01');
INSERT INTO `operation_log` VALUES (1341, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:23:01');
INSERT INTO `operation_log` VALUES (1342, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:24:01');
INSERT INTO `operation_log` VALUES (1343, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:25:01');
INSERT INTO `operation_log` VALUES (1344, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:26:01');
INSERT INTO `operation_log` VALUES (1345, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:27:01');
INSERT INTO `operation_log` VALUES (1346, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:28:01');
INSERT INTO `operation_log` VALUES (1347, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:29:01');
INSERT INTO `operation_log` VALUES (1348, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:30:01');
INSERT INTO `operation_log` VALUES (1349, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:31:01');
INSERT INTO `operation_log` VALUES (1350, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:32:01');
INSERT INTO `operation_log` VALUES (1351, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:33:01');
INSERT INTO `operation_log` VALUES (1352, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:34:01');
INSERT INTO `operation_log` VALUES (1353, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:35:01');
INSERT INTO `operation_log` VALUES (1354, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:36:01');
INSERT INTO `operation_log` VALUES (1355, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:37:01');
INSERT INTO `operation_log` VALUES (1356, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:38:01');
INSERT INTO `operation_log` VALUES (1357, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:39:01');
INSERT INTO `operation_log` VALUES (1358, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:40:01');
INSERT INTO `operation_log` VALUES (1359, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:41:01');
INSERT INTO `operation_log` VALUES (1360, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:42:01');
INSERT INTO `operation_log` VALUES (1361, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:43:01');
INSERT INTO `operation_log` VALUES (1362, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:44:01');
INSERT INTO `operation_log` VALUES (1363, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:45:01');
INSERT INTO `operation_log` VALUES (1364, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:46:01');
INSERT INTO `operation_log` VALUES (1365, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:47:01');
INSERT INTO `operation_log` VALUES (1366, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:48:01');
INSERT INTO `operation_log` VALUES (1367, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:49:01');
INSERT INTO `operation_log` VALUES (1368, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:50:01');
INSERT INTO `operation_log` VALUES (1369, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:51:01');
INSERT INTO `operation_log` VALUES (1370, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:52:01');
INSERT INTO `operation_log` VALUES (1371, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:53:01');
INSERT INTO `operation_log` VALUES (1372, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:54:01');
INSERT INTO `operation_log` VALUES (1373, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:55:01');
INSERT INTO `operation_log` VALUES (1374, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:56:01');
INSERT INTO `operation_log` VALUES (1375, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:57:01');
INSERT INTO `operation_log` VALUES (1376, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:58:01');
INSERT INTO `operation_log` VALUES (1377, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-07 23:59:01');
INSERT INTO `operation_log` VALUES (1378, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:00:01');
INSERT INTO `operation_log` VALUES (1379, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:01:01');
INSERT INTO `operation_log` VALUES (1380, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:02:01');
INSERT INTO `operation_log` VALUES (1381, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:03:01');
INSERT INTO `operation_log` VALUES (1382, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:04:01');
INSERT INTO `operation_log` VALUES (1383, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:05:01');
INSERT INTO `operation_log` VALUES (1384, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:06:01');
INSERT INTO `operation_log` VALUES (1385, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:07:01');
INSERT INTO `operation_log` VALUES (1386, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:08:01');
INSERT INTO `operation_log` VALUES (1387, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:09:01');
INSERT INTO `operation_log` VALUES (1388, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:10:01');
INSERT INTO `operation_log` VALUES (1389, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:11:01');
INSERT INTO `operation_log` VALUES (1390, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:12:01');
INSERT INTO `operation_log` VALUES (1391, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:13:01');
INSERT INTO `operation_log` VALUES (1392, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:14:01');
INSERT INTO `operation_log` VALUES (1393, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:15:01');
INSERT INTO `operation_log` VALUES (1394, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:16:01');
INSERT INTO `operation_log` VALUES (1395, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:17:01');
INSERT INTO `operation_log` VALUES (1396, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:18:01');
INSERT INTO `operation_log` VALUES (1397, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:19:01');
INSERT INTO `operation_log` VALUES (1398, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:20:01');
INSERT INTO `operation_log` VALUES (1399, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:21:01');
INSERT INTO `operation_log` VALUES (1400, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:22:01');
INSERT INTO `operation_log` VALUES (1401, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:23:01');
INSERT INTO `operation_log` VALUES (1402, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:24:01');
INSERT INTO `operation_log` VALUES (1403, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:25:01');
INSERT INTO `operation_log` VALUES (1404, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:26:01');
INSERT INTO `operation_log` VALUES (1405, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:27:01');
INSERT INTO `operation_log` VALUES (1406, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:28:01');
INSERT INTO `operation_log` VALUES (1407, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:29:01');
INSERT INTO `operation_log` VALUES (1408, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:30:01');
INSERT INTO `operation_log` VALUES (1409, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:31:01');
INSERT INTO `operation_log` VALUES (1410, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:32:01');
INSERT INTO `operation_log` VALUES (1411, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:33:01');
INSERT INTO `operation_log` VALUES (1412, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:34:01');
INSERT INTO `operation_log` VALUES (1413, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:35:01');
INSERT INTO `operation_log` VALUES (1414, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:36:01');
INSERT INTO `operation_log` VALUES (1415, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:37:01');
INSERT INTO `operation_log` VALUES (1416, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:38:01');
INSERT INTO `operation_log` VALUES (1417, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:39:01');
INSERT INTO `operation_log` VALUES (1418, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:40:01');
INSERT INTO `operation_log` VALUES (1419, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:41:01');
INSERT INTO `operation_log` VALUES (1420, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:42:01');
INSERT INTO `operation_log` VALUES (1421, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:43:01');
INSERT INTO `operation_log` VALUES (1422, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:44:01');
INSERT INTO `operation_log` VALUES (1423, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:45:01');
INSERT INTO `operation_log` VALUES (1424, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:46:01');
INSERT INTO `operation_log` VALUES (1425, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:47:01');
INSERT INTO `operation_log` VALUES (1426, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:48:01');
INSERT INTO `operation_log` VALUES (1427, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 00:49:01');
INSERT INTO `operation_log` VALUES (1428, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:03');
INSERT INTO `operation_log` VALUES (1429, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:03');
INSERT INTO `operation_log` VALUES (1430, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:03');
INSERT INTO `operation_log` VALUES (1431, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:03');
INSERT INTO `operation_log` VALUES (1432, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:07');
INSERT INTO `operation_log` VALUES (1433, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:10');
INSERT INTO `operation_log` VALUES (1434, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:10');
INSERT INTO `operation_log` VALUES (1435, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:13');
INSERT INTO `operation_log` VALUES (1436, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:04:17');
INSERT INTO `operation_log` VALUES (1437, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:05:03');
INSERT INTO `operation_log` VALUES (1438, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:06:03');
INSERT INTO `operation_log` VALUES (1439, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:07:03');
INSERT INTO `operation_log` VALUES (1440, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:08:03');
INSERT INTO `operation_log` VALUES (1441, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:09:03');
INSERT INTO `operation_log` VALUES (1442, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:10:03');
INSERT INTO `operation_log` VALUES (1443, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:12:01');
INSERT INTO `operation_log` VALUES (1444, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:14:01');
INSERT INTO `operation_log` VALUES (1445, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:16:01');
INSERT INTO `operation_log` VALUES (1446, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:19:52');
INSERT INTO `operation_log` VALUES (1447, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:19:52');
INSERT INTO `operation_log` VALUES (1448, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:20:12');
INSERT INTO `operation_log` VALUES (1449, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:20:12');
INSERT INTO `operation_log` VALUES (1450, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:21:13');
INSERT INTO `operation_log` VALUES (1451, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:22:13');
INSERT INTO `operation_log` VALUES (1452, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:13');
INSERT INTO `operation_log` VALUES (1453, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:24');
INSERT INTO `operation_log` VALUES (1454, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:24');
INSERT INTO `operation_log` VALUES (1455, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:40');
INSERT INTO `operation_log` VALUES (1456, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:40');
INSERT INTO `operation_log` VALUES (1457, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[2026-07-09, 2026-08-08, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:52');
INSERT INTO `operation_log` VALUES (1458, 1, 'admin', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:52');
INSERT INTO `operation_log` VALUES (1459, 1, 'admin', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-09, 2026-08-08, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:23:52');
INSERT INTO `operation_log` VALUES (1460, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:24:41');
INSERT INTO `operation_log` VALUES (1461, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:25:41');
INSERT INTO `operation_log` VALUES (1462, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:26:41');
INSERT INTO `operation_log` VALUES (1463, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:27:41');
INSERT INTO `operation_log` VALUES (1464, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:28:41');
INSERT INTO `operation_log` VALUES (1465, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:29:41');
INSERT INTO `operation_log` VALUES (1466, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:31:01');
INSERT INTO `operation_log` VALUES (1467, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:32:01');
INSERT INTO `operation_log` VALUES (1468, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:33:01');
INSERT INTO `operation_log` VALUES (1469, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:34:01');
INSERT INTO `operation_log` VALUES (1470, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:35:01');
INSERT INTO `operation_log` VALUES (1471, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:36:01');
INSERT INTO `operation_log` VALUES (1472, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:37:01');
INSERT INTO `operation_log` VALUES (1473, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:38:01');
INSERT INTO `operation_log` VALUES (1474, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 15:39:01');
INSERT INTO `operation_log` VALUES (1475, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:12:16');
INSERT INTO `operation_log` VALUES (1476, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:12:17');
INSERT INTO `operation_log` VALUES (1477, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:12:17');
INSERT INTO `operation_log` VALUES (1478, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:12:17');
INSERT INTO `operation_log` VALUES (1479, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:13:17');
INSERT INTO `operation_log` VALUES (1480, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:14:17');
INSERT INTO `operation_log` VALUES (1481, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:15:08');
INSERT INTO `operation_log` VALUES (1482, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:15:08');
INSERT INTO `operation_log` VALUES (1483, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:15:08');
INSERT INTO `operation_log` VALUES (1484, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:15:17');
INSERT INTO `operation_log` VALUES (1485, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:16:17');
INSERT INTO `operation_log` VALUES (1486, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:17:17');
INSERT INTO `operation_log` VALUES (1487, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:18:17');
INSERT INTO `operation_log` VALUES (1488, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:19:42');
INSERT INTO `operation_log` VALUES (1489, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:20:43');
INSERT INTO `operation_log` VALUES (1490, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:21:44');
INSERT INTO `operation_log` VALUES (1491, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:22:17');
INSERT INTO `operation_log` VALUES (1492, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:23:17');
INSERT INTO `operation_log` VALUES (1493, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'Invalid bound statement (not found): com.example.erpsystem.mapper.OperationLogMapper.selectList', '2026-08-08 21:24:11');
INSERT INTO `operation_log` VALUES (1494, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:24:13');
INSERT INTO `operation_log` VALUES (1495, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'Invalid bound statement (not found): com.example.erpsystem.mapper.OperationLogMapper.selectList', '2026-08-08 21:24:13');
INSERT INTO `operation_log` VALUES (1496, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:24:28');
INSERT INTO `operation_log` VALUES (1497, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:24:28');
INSERT INTO `operation_log` VALUES (1498, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:24:28');
INSERT INTO `operation_log` VALUES (1499, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:24:28');
INSERT INTO `operation_log` VALUES (1500, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'Invalid bound statement (not found): com.example.erpsystem.mapper.OperationLogMapper.selectList', '2026-08-08 21:24:31');
INSERT INTO `operation_log` VALUES (1501, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:25:29');
INSERT INTO `operation_log` VALUES (1502, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:26:29');
INSERT INTO `operation_log` VALUES (1503, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:27:29');
INSERT INTO `operation_log` VALUES (1504, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:28:25');
INSERT INTO `operation_log` VALUES (1505, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:28:28');
INSERT INTO `operation_log` VALUES (1506, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:29:29');
INSERT INTO `operation_log` VALUES (1507, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:30:29');
INSERT INTO `operation_log` VALUES (1508, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:32:01');
INSERT INTO `operation_log` VALUES (1509, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:33:01');
INSERT INTO `operation_log` VALUES (1510, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:34:01');
INSERT INTO `operation_log` VALUES (1511, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:35:01');
INSERT INTO `operation_log` VALUES (1512, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:36:01');
INSERT INTO `operation_log` VALUES (1513, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:37:01');
INSERT INTO `operation_log` VALUES (1514, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:38:01');
INSERT INTO `operation_log` VALUES (1515, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:39:01');
INSERT INTO `operation_log` VALUES (1516, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:41:01');
INSERT INTO `operation_log` VALUES (1517, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:42:01');
INSERT INTO `operation_log` VALUES (1518, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:42:28');
INSERT INTO `operation_log` VALUES (1519, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:42:28');
INSERT INTO `operation_log` VALUES (1520, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:42:30');
INSERT INTO `operation_log` VALUES (1521, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:42:30');
INSERT INTO `operation_log` VALUES (1522, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:45:50');
INSERT INTO `operation_log` VALUES (1523, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:45:50');
INSERT INTO `operation_log` VALUES (1524, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:45:50');
INSERT INTO `operation_log` VALUES (1525, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:45:51');
INSERT INTO `operation_log` VALUES (1526, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'Invalid bound statement (not found): com.example.erpsystem.mapper.OperationLogMapper.selectList', '2026-08-08 21:45:54');
INSERT INTO `operation_log` VALUES (1527, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:05');
INSERT INTO `operation_log` VALUES (1528, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:05');
INSERT INTO `operation_log` VALUES (1529, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:05');
INSERT INTO `operation_log` VALUES (1530, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:09');
INSERT INTO `operation_log` VALUES (1531, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:09');
INSERT INTO `operation_log` VALUES (1532, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:09');
INSERT INTO `operation_log` VALUES (1533, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:09');
INSERT INTO `operation_log` VALUES (1534, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:23');
INSERT INTO `operation_log` VALUES (1535, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:23');
INSERT INTO `operation_log` VALUES (1536, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:23');
INSERT INTO `operation_log` VALUES (1537, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:46:51');
INSERT INTO `operation_log` VALUES (1538, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:47:51');
INSERT INTO `operation_log` VALUES (1539, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:48:51');
INSERT INTO `operation_log` VALUES (1540, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:49:51');
INSERT INTO `operation_log` VALUES (1541, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:50:51');
INSERT INTO `operation_log` VALUES (1542, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:51:57');
INSERT INTO `operation_log` VALUES (1543, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:51:58');
INSERT INTO `operation_log` VALUES (1544, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:51:58');
INSERT INTO `operation_log` VALUES (1545, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:51:58');
INSERT INTO `operation_log` VALUES (1546, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:00');
INSERT INTO `operation_log` VALUES (1547, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:14');
INSERT INTO `operation_log` VALUES (1548, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:18');
INSERT INTO `operation_log` VALUES (1549, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:22');
INSERT INTO `operation_log` VALUES (1550, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:24');
INSERT INTO `operation_log` VALUES (1551, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'Invalid bound statement (not found): com.example.erpsystem.mapper.OperationLogMapper.selectList', '2026-08-08 21:52:49');
INSERT INTO `operation_log` VALUES (1552, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:53');
INSERT INTO `operation_log` VALUES (1553, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:53');
INSERT INTO `operation_log` VALUES (1554, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:56');
INSERT INTO `operation_log` VALUES (1555, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:56');
INSERT INTO `operation_log` VALUES (1556, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:56');
INSERT INTO `operation_log` VALUES (1557, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:52:58');
INSERT INTO `operation_log` VALUES (1558, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:53:58');
INSERT INTO `operation_log` VALUES (1559, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:54:58');
INSERT INTO `operation_log` VALUES (1560, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:55:58');
INSERT INTO `operation_log` VALUES (1561, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:56:58');
INSERT INTO `operation_log` VALUES (1562, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:57:59');
INSERT INTO `operation_log` VALUES (1563, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:57:59');
INSERT INTO `operation_log` VALUES (1564, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:57:59');
INSERT INTO `operation_log` VALUES (1565, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:57:59');
INSERT INTO `operation_log` VALUES (1566, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:58:01');
INSERT INTO `operation_log` VALUES (1567, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:58:04');
INSERT INTO `operation_log` VALUES (1568, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:58:59');
INSERT INTO `operation_log` VALUES (1569, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 21:59:59');
INSERT INTO `operation_log` VALUES (1570, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:00:59');
INSERT INTO `operation_log` VALUES (1571, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:01:59');
INSERT INTO `operation_log` VALUES (1572, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:02:59');
INSERT INTO `operation_log` VALUES (1573, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:03:59');
INSERT INTO `operation_log` VALUES (1574, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:05:01');
INSERT INTO `operation_log` VALUES (1575, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:06:01');
INSERT INTO `operation_log` VALUES (1576, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:07:01');
INSERT INTO `operation_log` VALUES (1577, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:08:01');
INSERT INTO `operation_log` VALUES (1578, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:09:01');
INSERT INTO `operation_log` VALUES (1579, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:10:01');
INSERT INTO `operation_log` VALUES (1580, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:11:01');
INSERT INTO `operation_log` VALUES (1581, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:12:01');
INSERT INTO `operation_log` VALUES (1582, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-08 22:13:01');
INSERT INTO `operation_log` VALUES (1583, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:08:12');
INSERT INTO `operation_log` VALUES (1584, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:08:13');
INSERT INTO `operation_log` VALUES (1585, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:08:13');
INSERT INTO `operation_log` VALUES (1586, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:08:13');
INSERT INTO `operation_log` VALUES (1587, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:08:15');
INSERT INTO `operation_log` VALUES (1588, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:09:13');
INSERT INTO `operation_log` VALUES (1589, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:10:13');
INSERT INTO `operation_log` VALUES (1590, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:11:13');
INSERT INTO `operation_log` VALUES (1591, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:12:13');
INSERT INTO `operation_log` VALUES (1592, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:13:13');
INSERT INTO `operation_log` VALUES (1593, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:14:13');
INSERT INTO `operation_log` VALUES (1594, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:15:39');
INSERT INTO `operation_log` VALUES (1595, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:16:29');
INSERT INTO `operation_log` VALUES (1596, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:16:43');
INSERT INTO `operation_log` VALUES (1597, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:16:43');
INSERT INTO `operation_log` VALUES (1598, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:16:43');
INSERT INTO `operation_log` VALUES (1599, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:16:43');
INSERT INTO `operation_log` VALUES (1600, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:16:46');
INSERT INTO `operation_log` VALUES (1601, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:17:44');
INSERT INTO `operation_log` VALUES (1602, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:18:43');
INSERT INTO `operation_log` VALUES (1603, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:18:43');
INSERT INTO `operation_log` VALUES (1604, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:18:43');
INSERT INTO `operation_log` VALUES (1605, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:18:43');
INSERT INTO `operation_log` VALUES (1606, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.binding.BindingException: Parameter \'supplierName\' not found. Available parameters are [orderNo, pageSize, param3, pageNum, param1, param2]\r\n### Cause: org.apache.ibatis.binding.BindingException: Parameter \'supplierName\' not found. Available parameters are [orderNo, pageSize, param3, pageNum, param1, param2]', '2026-08-09 14:18:46');
INSERT INTO `operation_log` VALUES (1607, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:19:44');
INSERT INTO `operation_log` VALUES (1608, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:21:44');
INSERT INTO `operation_log` VALUES (1609, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:22:44');
INSERT INTO `operation_log` VALUES (1610, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:24:01');
INSERT INTO `operation_log` VALUES (1611, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:24:50');
INSERT INTO `operation_log` VALUES (1612, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:03');
INSERT INTO `operation_log` VALUES (1613, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:04');
INSERT INTO `operation_log` VALUES (1614, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:04');
INSERT INTO `operation_log` VALUES (1615, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:04');
INSERT INTO `operation_log` VALUES (1616, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:06');
INSERT INTO `operation_log` VALUES (1617, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:11');
INSERT INTO `operation_log` VALUES (1618, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:11');
INSERT INTO `operation_log` VALUES (1619, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:25:11');
INSERT INTO `operation_log` VALUES (1620, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'supplier_name\' in \'field list\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT           id, order_no, supplier_id, supplier_name, total_amount, status, created_at               FROM purchase_order                    ORDER BY created_at D', '2026-08-09 14:25:12');
INSERT INTO `operation_log` VALUES (1621, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:26:04');
INSERT INTO `operation_log` VALUES (1622, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:27:04');
INSERT INTO `operation_log` VALUES (1623, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:28:04');
INSERT INTO `operation_log` VALUES (1624, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:29:04');
INSERT INTO `operation_log` VALUES (1625, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:30:04');
INSERT INTO `operation_log` VALUES (1626, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:31:04');
INSERT INTO `operation_log` VALUES (1627, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:32:04');
INSERT INTO `operation_log` VALUES (1628, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:33:31');
INSERT INTO `operation_log` VALUES (1629, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:33:48');
INSERT INTO `operation_log` VALUES (1630, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@75ce650c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:33:48');
INSERT INTO `operation_log` VALUES (1631, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:34:49');
INSERT INTO `operation_log` VALUES (1632, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:35:49');
INSERT INTO `operation_log` VALUES (1633, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:36:49');
INSERT INTO `operation_log` VALUES (1634, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:37:49');
INSERT INTO `operation_log` VALUES (1635, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:38:56');
INSERT INTO `operation_log` VALUES (1636, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:38:57');
INSERT INTO `operation_log` VALUES (1637, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:38:57');
INSERT INTO `operation_log` VALUES (1638, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:38:57');
INSERT INTO `operation_log` VALUES (1639, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:39:01');
INSERT INTO `operation_log` VALUES (1640, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:39:01');
INSERT INTO `operation_log` VALUES (1641, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:39:01');
INSERT INTO `operation_log` VALUES (1642, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:39:04');
INSERT INTO `operation_log` VALUES (1643, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:39:57');
INSERT INTO `operation_log` VALUES (1644, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:40:57');
INSERT INTO `operation_log` VALUES (1645, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 14:41:57');
INSERT INTO `operation_log` VALUES (1646, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:33:07');
INSERT INTO `operation_log` VALUES (1647, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:33:07');
INSERT INTO `operation_log` VALUES (1648, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:33:07');
INSERT INTO `operation_log` VALUES (1649, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:33:07');
INSERT INTO `operation_log` VALUES (1650, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:33:10');
INSERT INTO `operation_log` VALUES (1651, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:08');
INSERT INTO `operation_log` VALUES (1652, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:31');
INSERT INTO `operation_log` VALUES (1653, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:32');
INSERT INTO `operation_log` VALUES (1654, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:32');
INSERT INTO `operation_log` VALUES (1655, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:32');
INSERT INTO `operation_log` VALUES (1656, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:34');
INSERT INTO `operation_log` VALUES (1657, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:34:36');
INSERT INTO `operation_log` VALUES (1658, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:35:00');
INSERT INTO `operation_log` VALUES (1659, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:35:02');
INSERT INTO `operation_log` VALUES (1660, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:35:02');
INSERT INTO `operation_log` VALUES (1661, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:35:32');
INSERT INTO `operation_log` VALUES (1662, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:36:32');
INSERT INTO `operation_log` VALUES (1663, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:37:32');
INSERT INTO `operation_log` VALUES (1664, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 17:38:32');
INSERT INTO `operation_log` VALUES (1665, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:35');
INSERT INTO `operation_log` VALUES (1666, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:37');
INSERT INTO `operation_log` VALUES (1667, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:36');
INSERT INTO `operation_log` VALUES (1668, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:37');
INSERT INTO `operation_log` VALUES (1669, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:39');
INSERT INTO `operation_log` VALUES (1670, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:40');
INSERT INTO `operation_log` VALUES (1671, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:40');
INSERT INTO `operation_log` VALUES (1672, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:44');
INSERT INTO `operation_log` VALUES (1673, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:47');
INSERT INTO `operation_log` VALUES (1674, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@7b7ef1ee]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:50');
INSERT INTO `operation_log` VALUES (1675, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:51');
INSERT INTO `operation_log` VALUES (1676, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:53');
INSERT INTO `operation_log` VALUES (1677, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:55:55');
INSERT INTO `operation_log` VALUES (1678, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:09');
INSERT INTO `operation_log` VALUES (1679, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:10');
INSERT INTO `operation_log` VALUES (1680, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:10');
INSERT INTO `operation_log` VALUES (1681, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:12');
INSERT INTO `operation_log` VALUES (1682, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:14');
INSERT INTO `operation_log` VALUES (1683, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:35');
INSERT INTO `operation_log` VALUES (1684, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:36');
INSERT INTO `operation_log` VALUES (1685, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:56:45');
INSERT INTO `operation_log` VALUES (1686, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:57:10');
INSERT INTO `operation_log` VALUES (1687, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"海信\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:57:23');
INSERT INTO `operation_log` VALUES (1688, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:57:24');
INSERT INTO `operation_log` VALUES (1689, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:57:36');
INSERT INTO `operation_log` VALUES (1690, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:57:36');
INSERT INTO `operation_log` VALUES (1691, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:57:44');
INSERT INTO `operation_log` VALUES (1692, 1, 'admin', '客户', '修改', 'PUT /customer/update', '[Customer(id=1, customerName=测试客户, contactPerson=李总, phone=13900139000, email=hah@163.com, address=哈哈, level=VIP, creditLimit=null, initialReceivable=null, status=1, remark=null, createdAt=2026-07-29T20:11:48, updatedAt=2026-07-31T14:55:47)]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:58:14');
INSERT INTO `operation_log` VALUES (1693, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:58:14');
INSERT INTO `operation_log` VALUES (1694, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:58:37');
INSERT INTO `operation_log` VALUES (1695, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:59:04');
INSERT INTO `operation_log` VALUES (1696, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:59:06');
INSERT INTO `operation_log` VALUES (1697, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 20:59:37');
INSERT INTO `operation_log` VALUES (1698, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:00:37');
INSERT INTO `operation_log` VALUES (1699, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:00:47');
INSERT INTO `operation_log` VALUES (1700, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:00:48');
INSERT INTO `operation_log` VALUES (1701, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:00:53');
INSERT INTO `operation_log` VALUES (1702, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:21');
INSERT INTO `operation_log` VALUES (1703, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:24');
INSERT INTO `operation_log` VALUES (1704, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:34');
INSERT INTO `operation_log` VALUES (1705, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:36');
INSERT INTO `operation_log` VALUES (1706, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:36');
INSERT INTO `operation_log` VALUES (1707, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:38');
INSERT INTO `operation_log` VALUES (1708, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:42');
INSERT INTO `operation_log` VALUES (1709, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:42');
INSERT INTO `operation_log` VALUES (1710, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:01:42');
INSERT INTO `operation_log` VALUES (1711, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.binding.BindingException: Parameter \'offset\' not found. Available parameters are [orderNo, pageSize, param3, pageNum, param1, param2]\r\n### Cause: org.apache.ibatis.binding.BindingException: Parameter \'offset\' not found. Available parameters are [orderNo, pageSize, param3, pageNum, param1, param2]', '2026-08-09 21:01:44');
INSERT INTO `operation_log` VALUES (1712, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:02:37');
INSERT INTO `operation_log` VALUES (1713, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:03:57');
INSERT INTO `operation_log` VALUES (1714, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:04:58');
INSERT INTO `operation_log` VALUES (1715, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:05:59');
INSERT INTO `operation_log` VALUES (1716, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:48');
INSERT INTO `operation_log` VALUES (1717, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:48');
INSERT INTO `operation_log` VALUES (1718, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:47');
INSERT INTO `operation_log` VALUES (1719, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:48');
INSERT INTO `operation_log` VALUES (1720, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:48');
INSERT INTO `operation_log` VALUES (1721, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:52');
INSERT INTO `operation_log` VALUES (1722, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:54');
INSERT INTO `operation_log` VALUES (1723, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:55');
INSERT INTO `operation_log` VALUES (1724, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:56');
INSERT INTO `operation_log` VALUES (1725, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:56');
INSERT INTO `operation_log` VALUES (1726, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:07:56');
INSERT INTO `operation_log` VALUES (1727, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'supplierName\' of \'class com.example.erpsystem.entity.PurchaseOrder\' with value \'华为供应商\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'supplierName\' in \'class com.example.erpsystem.entity.PurchaseOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve c', '2026-08-09 21:07:58');
INSERT INTO `operation_log` VALUES (1728, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:08:48');
INSERT INTO `operation_log` VALUES (1729, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:09:48');
INSERT INTO `operation_log` VALUES (1730, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:10:48');
INSERT INTO `operation_log` VALUES (1731, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:11:48');
INSERT INTO `operation_log` VALUES (1732, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:15');
INSERT INTO `operation_log` VALUES (1733, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:17');
INSERT INTO `operation_log` VALUES (1734, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:17');
INSERT INTO `operation_log` VALUES (1735, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:17');
INSERT INTO `operation_log` VALUES (1736, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:17');
INSERT INTO `operation_log` VALUES (1737, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'supplierName\' of \'class com.example.erpsystem.entity.PurchaseOrder\' with value \'华为供应商\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'supplierName\' in \'class com.example.erpsystem.entity.PurchaseOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve c', '2026-08-09 21:14:18');
INSERT INTO `operation_log` VALUES (1738, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:38');
INSERT INTO `operation_log` VALUES (1739, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:38');
INSERT INTO `operation_log` VALUES (1740, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:38');
INSERT INTO `operation_log` VALUES (1741, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:14:38');
INSERT INTO `operation_log` VALUES (1742, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:01');
INSERT INTO `operation_log` VALUES (1743, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:01');
INSERT INTO `operation_log` VALUES (1744, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:01');
INSERT INTO `operation_log` VALUES (1745, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:01');
INSERT INTO `operation_log` VALUES (1746, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:03');
INSERT INTO `operation_log` VALUES (1747, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:03');
INSERT INTO `operation_log` VALUES (1748, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:15:03');
INSERT INTO `operation_log` VALUES (1749, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'supplierName\' of \'class com.example.erpsystem.entity.PurchaseOrder\' with value \'华为供应商\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'supplierName\' in \'class com.example.erpsystem.entity.PurchaseOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve c', '2026-08-09 21:15:05');
INSERT INTO `operation_log` VALUES (1750, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:16:01');
INSERT INTO `operation_log` VALUES (1751, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:17:01');
INSERT INTO `operation_log` VALUES (1752, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'supplierName\' of \'class com.example.erpsystem.entity.PurchaseOrder\' with value \'华为供应商\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'supplierName\' in \'class com.example.erpsystem.entity.PurchaseOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve c', '2026-08-09 21:17:40');
INSERT INTO `operation_log` VALUES (1753, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:18:01');
INSERT INTO `operation_log` VALUES (1754, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:19:01');
INSERT INTO `operation_log` VALUES (1755, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@25a81506]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:19:31');
INSERT INTO `operation_log` VALUES (1756, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'supplierName\' of \'class com.example.erpsystem.entity.PurchaseOrder\' with value \'华为供应商\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'supplierName\' in \'class com.example.erpsystem.entity.PurchaseOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve c', '2026-08-09 21:19:40');
INSERT INTO `operation_log` VALUES (1757, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:20:01');
INSERT INTO `operation_log` VALUES (1758, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:21:01');
INSERT INTO `operation_log` VALUES (1759, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:01');
INSERT INTO `operation_log` VALUES (1760, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:35');
INSERT INTO `operation_log` VALUES (1761, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:36');
INSERT INTO `operation_log` VALUES (1762, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:36');
INSERT INTO `operation_log` VALUES (1763, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:36');
INSERT INTO `operation_log` VALUES (1764, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'supplierName\' of \'class com.example.erpsystem.entity.PurchaseOrder\' with value \'华为供应商\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'supplierName\' in \'class com.example.erpsystem.entity.PurchaseOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\PurchaseOrderMapper.xml]\r\n### The error may involve c', '2026-08-09 21:22:37');
INSERT INTO `operation_log` VALUES (1765, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:55');
INSERT INTO `operation_log` VALUES (1766, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:55');
INSERT INTO `operation_log` VALUES (1767, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:55');
INSERT INTO `operation_log` VALUES (1768, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:22:55');
INSERT INTO `operation_log` VALUES (1769, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:01');
INSERT INTO `operation_log` VALUES (1770, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:14');
INSERT INTO `operation_log` VALUES (1771, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:14');
INSERT INTO `operation_log` VALUES (1772, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:14');
INSERT INTO `operation_log` VALUES (1773, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:15');
INSERT INTO `operation_log` VALUES (1774, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:15');
INSERT INTO `operation_log` VALUES (1775, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:15');
INSERT INTO `operation_log` VALUES (1776, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:23:15');
INSERT INTO `operation_log` VALUES (1777, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:24:01');
INSERT INTO `operation_log` VALUES (1778, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:25:01');
INSERT INTO `operation_log` VALUES (1779, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:26:01');
INSERT INTO `operation_log` VALUES (1780, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:26:35');
INSERT INTO `operation_log` VALUES (1781, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:26:35');
INSERT INTO `operation_log` VALUES (1782, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:26:35');
INSERT INTO `operation_log` VALUES (1783, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:26:35');
INSERT INTO `operation_log` VALUES (1784, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'customerName\' of \'class com.example.erpsystem.entity.SalesOrder\' with value \'测试客户\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'customerName\' in \'class com.example.erpsystem.entity.SalesOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\SalesOrderMapper.xml]\r\n### The error may involve com.example', '2026-08-09 21:26:38');
INSERT INTO `operation_log` VALUES (1785, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:27:01');
INSERT INTO `operation_log` VALUES (1786, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:27:19');
INSERT INTO `operation_log` VALUES (1787, 1, 'admin', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:27:19');
INSERT INTO `operation_log` VALUES (1788, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[2026-07-10, 2026-08-09, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:27:19');
INSERT INTO `operation_log` VALUES (1789, 1, 'admin', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-10, 2026-08-09, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:27:19');
INSERT INTO `operation_log` VALUES (1790, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:28:20');
INSERT INTO `operation_log` VALUES (1791, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:29:20');
INSERT INTO `operation_log` VALUES (1792, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Table \'erp_db.sys_operation_log\' doesn\'t exist\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\OperationLogMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT * FROM sys_operation_log                    ORDER BY operation_time DESC         LIMIT ?, ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Table \'erp_db.sys_oper', '2026-08-09 21:30:04');
INSERT INTO `operation_log` VALUES (1793, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:30:14');
INSERT INTO `operation_log` VALUES (1794, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Table \'erp_db.sys_operation_log\' doesn\'t exist\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\OperationLogMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT * FROM sys_operation_log                    ORDER BY operation_time DESC         LIMIT ?, ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Table \'erp_db.sys_oper', '2026-08-09 21:30:14');
INSERT INTO `operation_log` VALUES (1795, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:31:15');
INSERT INTO `operation_log` VALUES (1796, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:32:15');
INSERT INTO `operation_log` VALUES (1797, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:15');
INSERT INTO `operation_log` VALUES (1798, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:28');
INSERT INTO `operation_log` VALUES (1799, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:28');
INSERT INTO `operation_log` VALUES (1800, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:28');
INSERT INTO `operation_log` VALUES (1801, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:29');
INSERT INTO `operation_log` VALUES (1802, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:32');
INSERT INTO `operation_log` VALUES (1803, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:32');
INSERT INTO `operation_log` VALUES (1804, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:32');
INSERT INTO `operation_log` VALUES (1805, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:35');
INSERT INTO `operation_log` VALUES (1806, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:33:35');
INSERT INTO `operation_log` VALUES (1807, 1, 'admin', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:05');
INSERT INTO `operation_log` VALUES (1808, 1, 'admin', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-10, 2026-08-09, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:05');
INSERT INTO `operation_log` VALUES (1809, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[2026-07-10, 2026-08-09, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:05');
INSERT INTO `operation_log` VALUES (1810, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:06');
INSERT INTO `operation_log` VALUES (1811, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:14');
INSERT INTO `operation_log` VALUES (1812, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,10,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:15');
INSERT INTO `operation_log` VALUES (1813, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:20');
INSERT INTO `operation_log` VALUES (1814, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[2,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:34:36');
INSERT INTO `operation_log` VALUES (1815, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:35:13');
INSERT INTO `operation_log` VALUES (1816, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:35:13');
INSERT INTO `operation_log` VALUES (1817, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:35:14');
INSERT INTO `operation_log` VALUES (1818, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:36:15');
INSERT INTO `operation_log` VALUES (1819, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:15');
INSERT INTO `operation_log` VALUES (1820, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:23');
INSERT INTO `operation_log` VALUES (1821, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:23');
INSERT INTO `operation_log` VALUES (1822, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:31');
INSERT INTO `operation_log` VALUES (1823, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:44');
INSERT INTO `operation_log` VALUES (1824, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:47');
INSERT INTO `operation_log` VALUES (1825, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:49');
INSERT INTO `operation_log` VALUES (1826, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:52');
INSERT INTO `operation_log` VALUES (1827, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:57');
INSERT INTO `operation_log` VALUES (1828, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:57');
INSERT INTO `operation_log` VALUES (1829, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:37:57');
INSERT INTO `operation_log` VALUES (1830, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:06');
INSERT INTO `operation_log` VALUES (1831, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:06');
INSERT INTO `operation_log` VALUES (1832, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:15');
INSERT INTO `operation_log` VALUES (1833, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,4,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:28');
INSERT INTO `operation_log` VALUES (1834, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:30');
INSERT INTO `operation_log` VALUES (1835, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,2,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:32');
INSERT INTO `operation_log` VALUES (1836, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:33');
INSERT INTO `operation_log` VALUES (1837, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:39');
INSERT INTO `operation_log` VALUES (1838, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:39');
INSERT INTO `operation_log` VALUES (1839, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:39');
INSERT INTO `operation_log` VALUES (1840, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:38:40');
INSERT INTO `operation_log` VALUES (1841, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:39:15');
INSERT INTO `operation_log` VALUES (1842, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:39:41');
INSERT INTO `operation_log` VALUES (1843, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:39:41');
INSERT INTO `operation_log` VALUES (1844, 1, 'admin', '库存', 'GET', 'GET /inventory/flow-export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@26914de5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:08');
INSERT INTO `operation_log` VALUES (1845, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:14');
INSERT INTO `operation_log` VALUES (1846, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:37');
INSERT INTO `operation_log` VALUES (1847, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:37');
INSERT INTO `operation_log` VALUES (1848, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:37');
INSERT INTO `operation_log` VALUES (1849, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:53');
INSERT INTO `operation_log` VALUES (1850, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:40:53');
INSERT INTO `operation_log` VALUES (1851, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:41:15');
INSERT INTO `operation_log` VALUES (1852, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:42:15');
INSERT INTO `operation_log` VALUES (1853, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:43:15');
INSERT INTO `operation_log` VALUES (1854, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:44:27');
INSERT INTO `operation_log` VALUES (1855, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:45:15');
INSERT INTO `operation_log` VALUES (1856, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 21:47:01');
INSERT INTO `operation_log` VALUES (1857, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:01');
INSERT INTO `operation_log` VALUES (1858, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:02');
INSERT INTO `operation_log` VALUES (1859, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:02');
INSERT INTO `operation_log` VALUES (1860, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:03');
INSERT INTO `operation_log` VALUES (1861, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:05');
INSERT INTO `operation_log` VALUES (1862, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:08');
INSERT INTO `operation_log` VALUES (1863, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:08');
INSERT INTO `operation_log` VALUES (1864, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:08');
INSERT INTO `operation_log` VALUES (1865, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:09');
INSERT INTO `operation_log` VALUES (1866, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:21');
INSERT INTO `operation_log` VALUES (1867, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:21');
INSERT INTO `operation_log` VALUES (1868, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:21');
INSERT INTO `operation_log` VALUES (1869, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:21');
INSERT INTO `operation_log` VALUES (1870, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:31');
INSERT INTO `operation_log` VALUES (1871, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:43');
INSERT INTO `operation_log` VALUES (1872, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:43');
INSERT INTO `operation_log` VALUES (1873, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:43');
INSERT INTO `operation_log` VALUES (1874, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:26:43');
INSERT INTO `operation_log` VALUES (1875, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error querying database.  Cause: org.apache.ibatis.reflection.ReflectionException: Could not set property \'customerName\' of \'class com.example.erpsystem.entity.SalesOrder\' with value \'测试客户\' Cause: org.apache.ibatis.reflection.ReflectionException: There is no setter for property named \'customerName\' in \'class com.example.erpsystem.entity.SalesOrder\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\SalesOrderMapper.xml]\r\n### The error may involve com.example', '2026-08-09 22:26:45');
INSERT INTO `operation_log` VALUES (1876, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:27:21');
INSERT INTO `operation_log` VALUES (1877, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:28:21');
INSERT INTO `operation_log` VALUES (1878, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:28:54');
INSERT INTO `operation_log` VALUES (1879, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:28:54');
INSERT INTO `operation_log` VALUES (1880, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:28:54');
INSERT INTO `operation_log` VALUES (1881, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:05');
INSERT INTO `operation_log` VALUES (1882, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:05');
INSERT INTO `operation_log` VALUES (1883, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:05');
INSERT INTO `operation_log` VALUES (1884, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:07');
INSERT INTO `operation_log` VALUES (1885, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:07');
INSERT INTO `operation_log` VALUES (1886, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:11');
INSERT INTO `operation_log` VALUES (1887, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:11');
INSERT INTO `operation_log` VALUES (1888, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:11');
INSERT INTO `operation_log` VALUES (1889, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:16');
INSERT INTO `operation_log` VALUES (1890, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:16');
INSERT INTO `operation_log` VALUES (1891, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:16');
INSERT INTO `operation_log` VALUES (1892, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:16');
INSERT INTO `operation_log` VALUES (1893, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:21');
INSERT INTO `operation_log` VALUES (1894, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:22');
INSERT INTO `operation_log` VALUES (1895, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:22');
INSERT INTO `operation_log` VALUES (1896, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:22');
INSERT INTO `operation_log` VALUES (1897, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:29:46');
INSERT INTO `operation_log` VALUES (1898, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:30:21');
INSERT INTO `operation_log` VALUES (1899, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:31:21');
INSERT INTO `operation_log` VALUES (1900, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:32:21');
INSERT INTO `operation_log` VALUES (1901, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:33:33');
INSERT INTO `operation_log` VALUES (1902, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:34:34');
INSERT INTO `operation_log` VALUES (1903, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:35:35');
INSERT INTO `operation_log` VALUES (1904, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:37:09');
INSERT INTO `operation_log` VALUES (1905, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:37:09');
INSERT INTO `operation_log` VALUES (1906, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:37:09');
INSERT INTO `operation_log` VALUES (1907, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:37:10');
INSERT INTO `operation_log` VALUES (1908, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 0, 'Error attempting to get column \'customer_name\' from result set.  Cause: java.sql.SQLDataException: Cannot determine value type from string \'测试客户\'\n; Cannot determine value type from string \'测试客户\'', '2026-08-09 22:37:10');
INSERT INTO `operation_log` VALUES (1909, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:37:21');
INSERT INTO `operation_log` VALUES (1910, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:38:21');
INSERT INTO `operation_log` VALUES (1911, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:01');
INSERT INTO `operation_log` VALUES (1912, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:01');
INSERT INTO `operation_log` VALUES (1913, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:00');
INSERT INTO `operation_log` VALUES (1914, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:02');
INSERT INTO `operation_log` VALUES (1915, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:04');
INSERT INTO `operation_log` VALUES (1916, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:04');
INSERT INTO `operation_log` VALUES (1917, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:04');
INSERT INTO `operation_log` VALUES (1918, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:04');
INSERT INTO `operation_log` VALUES (1919, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:05');
INSERT INTO `operation_log` VALUES (1920, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:40:21');
INSERT INTO `operation_log` VALUES (1921, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:41:21');
INSERT INTO `operation_log` VALUES (1922, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:42:33');
INSERT INTO `operation_log` VALUES (1923, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:31');
INSERT INTO `operation_log` VALUES (1924, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:32');
INSERT INTO `operation_log` VALUES (1925, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:32');
INSERT INTO `operation_log` VALUES (1926, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:32');
INSERT INTO `operation_log` VALUES (1927, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:34');
INSERT INTO `operation_log` VALUES (1928, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:34');
INSERT INTO `operation_log` VALUES (1929, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:34');
INSERT INTO `operation_log` VALUES (1930, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:34');
INSERT INTO `operation_log` VALUES (1931, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:43:35');
INSERT INTO `operation_log` VALUES (1932, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:44:21');
INSERT INTO `operation_log` VALUES (1933, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:45:33');
INSERT INTO `operation_log` VALUES (1934, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:46:34');
INSERT INTO `operation_log` VALUES (1935, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:47:09');
INSERT INTO `operation_log` VALUES (1936, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:47:11');
INSERT INTO `operation_log` VALUES (1937, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:47:11');
INSERT INTO `operation_log` VALUES (1938, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:47:21');
INSERT INTO `operation_log` VALUES (1939, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:48:21');
INSERT INTO `operation_log` VALUES (1940, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:50:01');
INSERT INTO `operation_log` VALUES (1941, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:51:01');
INSERT INTO `operation_log` VALUES (1942, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:01');
INSERT INTO `operation_log` VALUES (1943, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:09');
INSERT INTO `operation_log` VALUES (1944, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:21');
INSERT INTO `operation_log` VALUES (1945, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:38');
INSERT INTO `operation_log` VALUES (1946, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:38');
INSERT INTO `operation_log` VALUES (1947, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:47');
INSERT INTO `operation_log` VALUES (1948, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:52:50');
INSERT INTO `operation_log` VALUES (1949, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:53:01');
INSERT INTO `operation_log` VALUES (1950, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:53:01');
INSERT INTO `operation_log` VALUES (1951, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:53:21');
INSERT INTO `operation_log` VALUES (1952, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:03');
INSERT INTO `operation_log` VALUES (1953, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:03');
INSERT INTO `operation_log` VALUES (1954, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:03');
INSERT INTO `operation_log` VALUES (1955, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:03');
INSERT INTO `operation_log` VALUES (1956, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:04');
INSERT INTO `operation_log` VALUES (1957, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:04');
INSERT INTO `operation_log` VALUES (1958, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:19');
INSERT INTO `operation_log` VALUES (1959, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:19');
INSERT INTO `operation_log` VALUES (1960, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:19');
INSERT INTO `operation_log` VALUES (1961, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:20');
INSERT INTO `operation_log` VALUES (1962, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:21');
INSERT INTO `operation_log` VALUES (1963, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:21');
INSERT INTO `operation_log` VALUES (1964, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:54:21');
INSERT INTO `operation_log` VALUES (1965, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:55:21');
INSERT INTO `operation_log` VALUES (1966, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:06');
INSERT INTO `operation_log` VALUES (1967, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:06');
INSERT INTO `operation_log` VALUES (1968, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:06');
INSERT INTO `operation_log` VALUES (1969, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:06');
INSERT INTO `operation_log` VALUES (1970, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:06');
INSERT INTO `operation_log` VALUES (1971, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@5ed70347]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:09');
INSERT INTO `operation_log` VALUES (1972, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:56:11');
INSERT INTO `operation_log` VALUES (1973, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:57:08');
INSERT INTO `operation_log` VALUES (1974, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:57:12');
INSERT INTO `operation_log` VALUES (1975, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:57:12');
INSERT INTO `operation_log` VALUES (1976, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:57:17');
INSERT INTO `operation_log` VALUES (1977, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:57:17');
INSERT INTO `operation_log` VALUES (1978, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:58:12');
INSERT INTO `operation_log` VALUES (1979, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 22:59:12');
INSERT INTO `operation_log` VALUES (1980, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:00:12');
INSERT INTO `operation_log` VALUES (1981, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:01:12');
INSERT INTO `operation_log` VALUES (1982, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:02:12');
INSERT INTO `operation_log` VALUES (1983, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:03:12');
INSERT INTO `operation_log` VALUES (1984, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:04:46');
INSERT INTO `operation_log` VALUES (1985, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:05:47');
INSERT INTO `operation_log` VALUES (1986, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:06:48');
INSERT INTO `operation_log` VALUES (1987, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:07:49');
INSERT INTO `operation_log` VALUES (1988, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:08:50');
INSERT INTO `operation_log` VALUES (1989, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:09:51');
INSERT INTO `operation_log` VALUES (1990, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:10:52');
INSERT INTO `operation_log` VALUES (1991, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-09 23:11:53');
INSERT INTO `operation_log` VALUES (1992, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:42:13');
INSERT INTO `operation_log` VALUES (1993, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:42:14');
INSERT INTO `operation_log` VALUES (1994, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:42:14');
INSERT INTO `operation_log` VALUES (1995, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:42:15');
INSERT INTO `operation_log` VALUES (1996, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:43:15');
INSERT INTO `operation_log` VALUES (1997, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:44:15');
INSERT INTO `operation_log` VALUES (1998, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:13');
INSERT INTO `operation_log` VALUES (1999, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:13');
INSERT INTO `operation_log` VALUES (2000, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:13');
INSERT INTO `operation_log` VALUES (2001, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:39');
INSERT INTO `operation_log` VALUES (2002, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:39');
INSERT INTO `operation_log` VALUES (2003, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:39');
INSERT INTO `operation_log` VALUES (2004, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:45:43');
INSERT INTO `operation_log` VALUES (2005, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:46:13');
INSERT INTO `operation_log` VALUES (2006, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:47:14');
INSERT INTO `operation_log` VALUES (2007, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:47:52');
INSERT INTO `operation_log` VALUES (2008, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:47:52');
INSERT INTO `operation_log` VALUES (2009, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:47:52');
INSERT INTO `operation_log` VALUES (2010, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:47:54');
INSERT INTO `operation_log` VALUES (2011, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:47:55');
INSERT INTO `operation_log` VALUES (2012, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:48:13');
INSERT INTO `operation_log` VALUES (2013, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:49:14');
INSERT INTO `operation_log` VALUES (2014, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:50:14');
INSERT INTO `operation_log` VALUES (2015, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:51:14');
INSERT INTO `operation_log` VALUES (2016, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:52:46');
INSERT INTO `operation_log` VALUES (2017, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:53:47');
INSERT INTO `operation_log` VALUES (2018, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:54:48');
INSERT INTO `operation_log` VALUES (2019, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:55:49');
INSERT INTO `operation_log` VALUES (2020, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:56:50');
INSERT INTO `operation_log` VALUES (2021, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:57:51');
INSERT INTO `operation_log` VALUES (2022, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:58:52');
INSERT INTO `operation_log` VALUES (2023, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 11:59:53');
INSERT INTO `operation_log` VALUES (2024, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 12:00:54');
INSERT INTO `operation_log` VALUES (2025, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 12:01:55');
INSERT INTO `operation_log` VALUES (2026, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 12:02:56');
INSERT INTO `operation_log` VALUES (2027, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:56:25');
INSERT INTO `operation_log` VALUES (2028, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"adminn\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:56:37');
INSERT INTO `operation_log` VALUES (2029, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:40');
INSERT INTO `operation_log` VALUES (2030, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:41');
INSERT INTO `operation_log` VALUES (2031, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:41');
INSERT INTO `operation_log` VALUES (2032, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:41');
INSERT INTO `operation_log` VALUES (2033, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:44');
INSERT INTO `operation_log` VALUES (2034, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:44');
INSERT INTO `operation_log` VALUES (2035, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:44');
INSERT INTO `operation_log` VALUES (2036, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:57:46');
INSERT INTO `operation_log` VALUES (2037, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:58:41');
INSERT INTO `operation_log` VALUES (2038, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 18:59:41');
INSERT INTO `operation_log` VALUES (2039, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:00:41');
INSERT INTO `operation_log` VALUES (2040, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:01:41');
INSERT INTO `operation_log` VALUES (2041, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:02:41');
INSERT INTO `operation_log` VALUES (2042, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:03:41');
INSERT INTO `operation_log` VALUES (2043, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:04:50');
INSERT INTO `operation_log` VALUES (2044, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:05:50');
INSERT INTO `operation_log` VALUES (2045, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:06:50');
INSERT INTO `operation_log` VALUES (2046, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:07:28');
INSERT INTO `operation_log` VALUES (2047, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:07:28');
INSERT INTO `operation_log` VALUES (2048, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:07:28');
INSERT INTO `operation_log` VALUES (2049, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:07:30');
INSERT INTO `operation_log` VALUES (2050, 1, 'admin', '采购', 'GET', 'GET /purchase/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@764e826b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:07:32');
INSERT INTO `operation_log` VALUES (2051, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:07:41');
INSERT INTO `operation_log` VALUES (2052, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:08:41');
INSERT INTO `operation_log` VALUES (2053, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:09:50');
INSERT INTO `operation_log` VALUES (2054, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:10:50');
INSERT INTO `operation_log` VALUES (2055, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:11:50');
INSERT INTO `operation_log` VALUES (2056, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:12:50');
INSERT INTO `operation_log` VALUES (2057, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:13:50');
INSERT INTO `operation_log` VALUES (2058, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:14:50');
INSERT INTO `operation_log` VALUES (2059, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:14');
INSERT INTO `operation_log` VALUES (2060, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:15');
INSERT INTO `operation_log` VALUES (2061, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:15');
INSERT INTO `operation_log` VALUES (2062, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:15');
INSERT INTO `operation_log` VALUES (2063, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:15');
INSERT INTO `operation_log` VALUES (2064, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:22');
INSERT INTO `operation_log` VALUES (2065, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:22');
INSERT INTO `operation_log` VALUES (2066, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,1,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:28:49');
INSERT INTO `operation_log` VALUES (2067, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:08');
INSERT INTO `operation_log` VALUES (2068, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:09');
INSERT INTO `operation_log` VALUES (2069, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:09');
INSERT INTO `operation_log` VALUES (2070, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:09');
INSERT INTO `operation_log` VALUES (2071, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:11');
INSERT INTO `operation_log` VALUES (2072, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:11');
INSERT INTO `operation_log` VALUES (2073, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,1,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:29:14');
INSERT INTO `operation_log` VALUES (2074, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:30:09');
INSERT INTO `operation_log` VALUES (2075, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:31:09');
INSERT INTO `operation_log` VALUES (2076, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:32:09');
INSERT INTO `operation_log` VALUES (2077, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:33:09');
INSERT INTO `operation_log` VALUES (2078, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:34:09');
INSERT INTO `operation_log` VALUES (2079, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 19:35:09');
INSERT INTO `operation_log` VALUES (2080, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:23:48');
INSERT INTO `operation_log` VALUES (2081, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:23:50');
INSERT INTO `operation_log` VALUES (2082, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:23:50');
INSERT INTO `operation_log` VALUES (2083, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:23:50');
INSERT INTO `operation_log` VALUES (2084, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:23:53');
INSERT INTO `operation_log` VALUES (2085, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:23:53');
INSERT INTO `operation_log` VALUES (2086, 1, 'admin', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:24:02');
INSERT INTO `operation_log` VALUES (2087, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:24:50');
INSERT INTO `operation_log` VALUES (2088, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:25:50');
INSERT INTO `operation_log` VALUES (2089, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:26:50');
INSERT INTO `operation_log` VALUES (2090, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:27:50');
INSERT INTO `operation_log` VALUES (2091, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:28:50');
INSERT INTO `operation_log` VALUES (2092, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:29:50');
INSERT INTO `operation_log` VALUES (2093, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:30:50');
INSERT INTO `operation_log` VALUES (2094, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:31:50');
INSERT INTO `operation_log` VALUES (2095, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:32:50');
INSERT INTO `operation_log` VALUES (2096, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:29');
INSERT INTO `operation_log` VALUES (2097, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:29');
INSERT INTO `operation_log` VALUES (2098, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:29');
INSERT INTO `operation_log` VALUES (2099, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:30');
INSERT INTO `operation_log` VALUES (2100, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:34');
INSERT INTO `operation_log` VALUES (2101, 1, 'admin', '采购', 'GET', 'GET /purchase/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@254fdfc4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:40');
INSERT INTO `operation_log` VALUES (2102, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:33:50');
INSERT INTO `operation_log` VALUES (2103, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:34:37');
INSERT INTO `operation_log` VALUES (2104, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:34:37');
INSERT INTO `operation_log` VALUES (2105, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,1,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:34:42');
INSERT INTO `operation_log` VALUES (2106, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:34:50');
INSERT INTO `operation_log` VALUES (2107, 1, 'admin', '库存', 'GET', 'GET /inventory/export-for-check', '[1, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@6e5e8553]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:34:50');
INSERT INTO `operation_log` VALUES (2108, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:35:50');
INSERT INTO `operation_log` VALUES (2109, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:36:50');
INSERT INTO `operation_log` VALUES (2110, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:37:50');
INSERT INTO `operation_log` VALUES (2111, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:38:50');
INSERT INTO `operation_log` VALUES (2112, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:39:50');
INSERT INTO `operation_log` VALUES (2113, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:40:50');
INSERT INTO `operation_log` VALUES (2114, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:41:50');
INSERT INTO `operation_log` VALUES (2115, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:42:50');
INSERT INTO `operation_log` VALUES (2116, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:43:50');
INSERT INTO `operation_log` VALUES (2117, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:44:50');
INSERT INTO `operation_log` VALUES (2118, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:33');
INSERT INTO `operation_log` VALUES (2119, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:33');
INSERT INTO `operation_log` VALUES (2120, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:39');
INSERT INTO `operation_log` VALUES (2121, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:39');
INSERT INTO `operation_log` VALUES (2122, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:39');
INSERT INTO `operation_log` VALUES (2123, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:39');
INSERT INTO `operation_log` VALUES (2124, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:40');
INSERT INTO `operation_log` VALUES (2125, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:40');
INSERT INTO `operation_log` VALUES (2126, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,1,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:43');
INSERT INTO `operation_log` VALUES (2127, 1, 'admin', '库存', 'GET', 'GET /inventory/export-for-check', '[1, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@1df14c72]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:45');
INSERT INTO `operation_log` VALUES (2128, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:45:50');
INSERT INTO `operation_log` VALUES (2129, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:46:50');
INSERT INTO `operation_log` VALUES (2130, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:47:50');
INSERT INTO `operation_log` VALUES (2131, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:48:50');
INSERT INTO `operation_log` VALUES (2132, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:49:50');
INSERT INTO `operation_log` VALUES (2133, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:50:50');
INSERT INTO `operation_log` VALUES (2134, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:51:50');
INSERT INTO `operation_log` VALUES (2135, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:52:50');
INSERT INTO `operation_log` VALUES (2136, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:53:50');
INSERT INTO `operation_log` VALUES (2137, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:54:50');
INSERT INTO `operation_log` VALUES (2138, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:55:50');
INSERT INTO `operation_log` VALUES (2139, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:56:50');
INSERT INTO `operation_log` VALUES (2140, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:57:50');
INSERT INTO `operation_log` VALUES (2141, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:58:50');
INSERT INTO `operation_log` VALUES (2142, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 20:59:50');
INSERT INTO `operation_log` VALUES (2143, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:00:50');
INSERT INTO `operation_log` VALUES (2144, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:10');
INSERT INTO `operation_log` VALUES (2145, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:10');
INSERT INTO `operation_log` VALUES (2146, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:10');
INSERT INTO `operation_log` VALUES (2147, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:12');
INSERT INTO `operation_log` VALUES (2148, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:21');
INSERT INTO `operation_log` VALUES (2149, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:22');
INSERT INTO `operation_log` VALUES (2150, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:22');
INSERT INTO `operation_log` VALUES (2151, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:22');
INSERT INTO `operation_log` VALUES (2152, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:27');
INSERT INTO `operation_log` VALUES (2153, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:22:27');
INSERT INTO `operation_log` VALUES (2154, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:23:22');
INSERT INTO `operation_log` VALUES (2155, 1, 'admin', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:24:12');
INSERT INTO `operation_log` VALUES (2156, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:24:22');
INSERT INTO `operation_log` VALUES (2157, 1, 'admin', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:24:40');
INSERT INTO `operation_log` VALUES (2158, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:24:52');
INSERT INTO `operation_log` VALUES (2159, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:13');
INSERT INTO `operation_log` VALUES (2160, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:22');
INSERT INTO `operation_log` VALUES (2161, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:28');
INSERT INTO `operation_log` VALUES (2162, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:30');
INSERT INTO `operation_log` VALUES (2163, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:32');
INSERT INTO `operation_log` VALUES (2164, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:32');
INSERT INTO `operation_log` VALUES (2165, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:25:32');
INSERT INTO `operation_log` VALUES (2166, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:26:18');
INSERT INTO `operation_log` VALUES (2167, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:26:20');
INSERT INTO `operation_log` VALUES (2168, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:26:22');
INSERT INTO `operation_log` VALUES (2169, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:27:22');
INSERT INTO `operation_log` VALUES (2170, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:27:38');
INSERT INTO `operation_log` VALUES (2171, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:27:38');
INSERT INTO `operation_log` VALUES (2172, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:28:22');
INSERT INTO `operation_log` VALUES (2173, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:29:26');
INSERT INTO `operation_log` VALUES (2174, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:29:31');
INSERT INTO `operation_log` VALUES (2175, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:29:39');
INSERT INTO `operation_log` VALUES (2176, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:29:39');
INSERT INTO `operation_log` VALUES (2177, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:29:39');
INSERT INTO `operation_log` VALUES (2178, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:29:42');
INSERT INTO `operation_log` VALUES (2179, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:30:22');
INSERT INTO `operation_log` VALUES (2180, 1, 'admin', '采购', 'GET', 'GET /purchase/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@4b87bae]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:30:25');
INSERT INTO `operation_log` VALUES (2181, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:30:57');
INSERT INTO `operation_log` VALUES (2182, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:01');
INSERT INTO `operation_log` VALUES (2183, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:01');
INSERT INTO `operation_log` VALUES (2184, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:01');
INSERT INTO `operation_log` VALUES (2185, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:04');
INSERT INTO `operation_log` VALUES (2186, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:18');
INSERT INTO `operation_log` VALUES (2187, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:21');
INSERT INTO `operation_log` VALUES (2188, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:21');
INSERT INTO `operation_log` VALUES (2189, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:21');
INSERT INTO `operation_log` VALUES (2190, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:31:22');
INSERT INTO `operation_log` VALUES (2191, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:32:01');
INSERT INTO `operation_log` VALUES (2192, 1, 'admin', '采购', 'GET', 'GET /purchase/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@36e99138]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:32:05');
INSERT INTO `operation_log` VALUES (2193, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:32:22');
INSERT INTO `operation_log` VALUES (2194, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:33:22');
INSERT INTO `operation_log` VALUES (2195, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@1b7d0886]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:33:35');
INSERT INTO `operation_log` VALUES (2196, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:34:22');
INSERT INTO `operation_log` VALUES (2197, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:35:22');
INSERT INTO `operation_log` VALUES (2198, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:36:41');
INSERT INTO `operation_log` VALUES (2199, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 21:37:42');
INSERT INTO `operation_log` VALUES (2200, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:47');
INSERT INTO `operation_log` VALUES (2201, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:48');
INSERT INTO `operation_log` VALUES (2202, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:48');
INSERT INTO `operation_log` VALUES (2203, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:48');
INSERT INTO `operation_log` VALUES (2204, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:48');
INSERT INTO `operation_log` VALUES (2205, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:51');
INSERT INTO `operation_log` VALUES (2206, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:22:51');
INSERT INTO `operation_log` VALUES (2207, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:23:49');
INSERT INTO `operation_log` VALUES (2208, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:24:49');
INSERT INTO `operation_log` VALUES (2209, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:25:49');
INSERT INTO `operation_log` VALUES (2210, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:26:49');
INSERT INTO `operation_log` VALUES (2211, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:27:49');
INSERT INTO `operation_log` VALUES (2212, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:28:49');
INSERT INTO `operation_log` VALUES (2213, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:29:50');
INSERT INTO `operation_log` VALUES (2214, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:30:50');
INSERT INTO `operation_log` VALUES (2215, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:31:50');
INSERT INTO `operation_log` VALUES (2216, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:32:50');
INSERT INTO `operation_log` VALUES (2217, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:33:50');
INSERT INTO `operation_log` VALUES (2218, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:34:50');
INSERT INTO `operation_log` VALUES (2219, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:35:50');
INSERT INTO `operation_log` VALUES (2220, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:36:50');
INSERT INTO `operation_log` VALUES (2221, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:37:50');
INSERT INTO `operation_log` VALUES (2222, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:38:50');
INSERT INTO `operation_log` VALUES (2223, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:39:50');
INSERT INTO `operation_log` VALUES (2224, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:40:50');
INSERT INTO `operation_log` VALUES (2225, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:41:50');
INSERT INTO `operation_log` VALUES (2226, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-10 22:42:50');
INSERT INTO `operation_log` VALUES (2227, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:18');
INSERT INTO `operation_log` VALUES (2228, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:20');
INSERT INTO `operation_log` VALUES (2229, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:20');
INSERT INTO `operation_log` VALUES (2230, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:20');
INSERT INTO `operation_log` VALUES (2231, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:24');
INSERT INTO `operation_log` VALUES (2232, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:24');
INSERT INTO `operation_log` VALUES (2233, 1, 'admin', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:14:28');
INSERT INTO `operation_log` VALUES (2234, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:15:19');
INSERT INTO `operation_log` VALUES (2235, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:16:20');
INSERT INTO `operation_log` VALUES (2236, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:17:20');
INSERT INTO `operation_log` VALUES (2237, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:18:20');
INSERT INTO `operation_log` VALUES (2238, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:19:20');
INSERT INTO `operation_log` VALUES (2239, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:20:20');
INSERT INTO `operation_log` VALUES (2240, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:20:39');
INSERT INTO `operation_log` VALUES (2241, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:20:39');
INSERT INTO `operation_log` VALUES (2242, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:20:39');
INSERT INTO `operation_log` VALUES (2243, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:20:46');
INSERT INTO `operation_log` VALUES (2244, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:20:48');
INSERT INTO `operation_log` VALUES (2245, 1, 'admin', '采购', 'GET', 'GET /purchase/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@2515011b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:21:03');
INSERT INTO `operation_log` VALUES (2246, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:21:20');
INSERT INTO `operation_log` VALUES (2247, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@9291b69]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:21:51');
INSERT INTO `operation_log` VALUES (2248, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:20');
INSERT INTO `operation_log` VALUES (2249, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:39');
INSERT INTO `operation_log` VALUES (2250, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:39');
INSERT INTO `operation_log` VALUES (2251, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:39');
INSERT INTO `operation_log` VALUES (2252, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:39');
INSERT INTO `operation_log` VALUES (2253, 1, 'admin', '销售', 'GET', 'GET /sales/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@78e8113d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:47');
INSERT INTO `operation_log` VALUES (2254, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:22:54');
INSERT INTO `operation_log` VALUES (2255, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:23:03');
INSERT INTO `operation_log` VALUES (2256, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:23:03');
INSERT INTO `operation_log` VALUES (2257, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:23:03');
INSERT INTO `operation_log` VALUES (2258, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:23:03');
INSERT INTO `operation_log` VALUES (2259, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:23:03');
INSERT INTO `operation_log` VALUES (2260, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:24:03');
INSERT INTO `operation_log` VALUES (2261, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:25:03');
INSERT INTO `operation_log` VALUES (2262, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:26:03');
INSERT INTO `operation_log` VALUES (2263, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:27:03');
INSERT INTO `operation_log` VALUES (2264, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:28:03');
INSERT INTO `operation_log` VALUES (2265, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:29:03');
INSERT INTO `operation_log` VALUES (2266, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:30:50');
INSERT INTO `operation_log` VALUES (2267, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:31:50');
INSERT INTO `operation_log` VALUES (2268, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:32:50');
INSERT INTO `operation_log` VALUES (2269, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:33:50');
INSERT INTO `operation_log` VALUES (2270, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:34:50');
INSERT INTO `operation_log` VALUES (2271, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:35:50');
INSERT INTO `operation_log` VALUES (2272, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:36:50');
INSERT INTO `operation_log` VALUES (2273, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 09:37:50');
INSERT INTO `operation_log` VALUES (2274, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:31');
INSERT INTO `operation_log` VALUES (2275, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:34');
INSERT INTO `operation_log` VALUES (2276, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:34');
INSERT INTO `operation_log` VALUES (2277, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:34');
INSERT INTO `operation_log` VALUES (2278, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:34');
INSERT INTO `operation_log` VALUES (2279, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:34');
INSERT INTO `operation_log` VALUES (2280, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:22:47');
INSERT INTO `operation_log` VALUES (2281, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:23:33');
INSERT INTO `operation_log` VALUES (2282, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:24:34');
INSERT INTO `operation_log` VALUES (2283, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:25:34');
INSERT INTO `operation_log` VALUES (2284, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:26:34');
INSERT INTO `operation_log` VALUES (2285, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:27:34');
INSERT INTO `operation_log` VALUES (2286, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:28:34');
INSERT INTO `operation_log` VALUES (2287, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:29:50');
INSERT INTO `operation_log` VALUES (2288, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:09');
INSERT INTO `operation_log` VALUES (2289, 1, 'admin', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:26');
INSERT INTO `operation_log` VALUES (2290, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:33');
INSERT INTO `operation_log` VALUES (2291, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:35');
INSERT INTO `operation_log` VALUES (2292, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:35');
INSERT INTO `operation_log` VALUES (2293, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:35');
INSERT INTO `operation_log` VALUES (2294, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:30:37');
INSERT INTO `operation_log` VALUES (2295, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:31:34');
INSERT INTO `operation_log` VALUES (2296, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:31:59');
INSERT INTO `operation_log` VALUES (2297, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:31:59');
INSERT INTO `operation_log` VALUES (2298, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:35:53');
INSERT INTO `operation_log` VALUES (2299, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:35:54');
INSERT INTO `operation_log` VALUES (2300, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:35:54');
INSERT INTO `operation_log` VALUES (2301, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:35:54');
INSERT INTO `operation_log` VALUES (2302, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:35:58');
INSERT INTO `operation_log` VALUES (2303, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:36:55');
INSERT INTO `operation_log` VALUES (2304, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:37:55');
INSERT INTO `operation_log` VALUES (2305, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:38:55');
INSERT INTO `operation_log` VALUES (2306, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:39:55');
INSERT INTO `operation_log` VALUES (2307, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:40:55');
INSERT INTO `operation_log` VALUES (2308, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:41:55');
INSERT INTO `operation_log` VALUES (2309, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:43:50');
INSERT INTO `operation_log` VALUES (2310, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:44:50');
INSERT INTO `operation_log` VALUES (2311, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:45:50');
INSERT INTO `operation_log` VALUES (2312, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:46:50');
INSERT INTO `operation_log` VALUES (2313, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:47:50');
INSERT INTO `operation_log` VALUES (2314, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:38');
INSERT INTO `operation_log` VALUES (2315, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:38');
INSERT INTO `operation_log` VALUES (2316, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:38');
INSERT INTO `operation_log` VALUES (2317, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:54');
INSERT INTO `operation_log` VALUES (2318, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:56');
INSERT INTO `operation_log` VALUES (2319, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:56');
INSERT INTO `operation_log` VALUES (2320, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:48:56');
INSERT INTO `operation_log` VALUES (2321, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:49:09');
INSERT INTO `operation_log` VALUES (2322, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:49:09');
INSERT INTO `operation_log` VALUES (2323, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:49:55');
INSERT INTO `operation_log` VALUES (2324, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:51:48');
INSERT INTO `operation_log` VALUES (2325, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:52:09');
INSERT INTO `operation_log` VALUES (2326, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:52:09');
INSERT INTO `operation_log` VALUES (2327, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:52:09');
INSERT INTO `operation_log` VALUES (2328, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:52:55');
INSERT INTO `operation_log` VALUES (2329, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:54:50');
INSERT INTO `operation_log` VALUES (2330, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:30');
INSERT INTO `operation_log` VALUES (2331, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:30');
INSERT INTO `operation_log` VALUES (2332, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:41');
INSERT INTO `operation_log` VALUES (2333, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:41');
INSERT INTO `operation_log` VALUES (2334, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:41');
INSERT INTO `operation_log` VALUES (2335, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:54');
INSERT INTO `operation_log` VALUES (2336, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:55:54');
INSERT INTO `operation_log` VALUES (2337, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:15');
INSERT INTO `operation_log` VALUES (2338, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:15');
INSERT INTO `operation_log` VALUES (2339, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:46');
INSERT INTO `operation_log` VALUES (2340, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:46');
INSERT INTO `operation_log` VALUES (2341, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:46');
INSERT INTO `operation_log` VALUES (2342, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:46');
INSERT INTO `operation_log` VALUES (2343, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:56:50');
INSERT INTO `operation_log` VALUES (2344, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:57:47');
INSERT INTO `operation_log` VALUES (2345, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:58:25');
INSERT INTO `operation_log` VALUES (2346, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:58:39');
INSERT INTO `operation_log` VALUES (2347, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:58:39');
INSERT INTO `operation_log` VALUES (2348, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:58:46');
INSERT INTO `operation_log` VALUES (2349, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:58:46');
INSERT INTO `operation_log` VALUES (2350, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 10:59:46');
INSERT INTO `operation_log` VALUES (2351, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:00:46');
INSERT INTO `operation_log` VALUES (2352, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:01:46');
INSERT INTO `operation_log` VALUES (2353, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:02:46');
INSERT INTO `operation_log` VALUES (2354, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:03:46');
INSERT INTO `operation_log` VALUES (2355, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:04:46');
INSERT INTO `operation_log` VALUES (2356, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:05:46');
INSERT INTO `operation_log` VALUES (2357, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:06:46');
INSERT INTO `operation_log` VALUES (2358, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:07:46');
INSERT INTO `operation_log` VALUES (2359, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:08:47');
INSERT INTO `operation_log` VALUES (2360, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:09:47');
INSERT INTO `operation_log` VALUES (2361, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:10:48');
INSERT INTO `operation_log` VALUES (2362, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:11:49');
INSERT INTO `operation_log` VALUES (2363, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:12:50');
INSERT INTO `operation_log` VALUES (2364, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:13:50');
INSERT INTO `operation_log` VALUES (2365, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:14:50');
INSERT INTO `operation_log` VALUES (2366, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:15:50');
INSERT INTO `operation_log` VALUES (2367, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:16:50');
INSERT INTO `operation_log` VALUES (2368, 1, 'admin', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:17:14');
INSERT INTO `operation_log` VALUES (2369, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:17:47');
INSERT INTO `operation_log` VALUES (2370, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:18:50');
INSERT INTO `operation_log` VALUES (2371, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:19:50');
INSERT INTO `operation_log` VALUES (2372, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:20:50');
INSERT INTO `operation_log` VALUES (2373, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:21:50');
INSERT INTO `operation_log` VALUES (2374, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:22:50');
INSERT INTO `operation_log` VALUES (2375, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:23:50');
INSERT INTO `operation_log` VALUES (2376, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:24:50');
INSERT INTO `operation_log` VALUES (2377, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:25:50');
INSERT INTO `operation_log` VALUES (2378, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:26:50');
INSERT INTO `operation_log` VALUES (2379, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:27:50');
INSERT INTO `operation_log` VALUES (2380, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:28:50');
INSERT INTO `operation_log` VALUES (2381, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:29:50');
INSERT INTO `operation_log` VALUES (2382, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:30:50');
INSERT INTO `operation_log` VALUES (2383, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:31:50');
INSERT INTO `operation_log` VALUES (2384, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:44:20');
INSERT INTO `operation_log` VALUES (2385, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:44:27');
INSERT INTO `operation_log` VALUES (2386, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:44:27');
INSERT INTO `operation_log` VALUES (2387, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:45:27');
INSERT INTO `operation_log` VALUES (2388, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:46:28');
INSERT INTO `operation_log` VALUES (2389, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:47:28');
INSERT INTO `operation_log` VALUES (2390, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:48:28');
INSERT INTO `operation_log` VALUES (2391, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:49:28');
INSERT INTO `operation_log` VALUES (2392, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:49:37');
INSERT INTO `operation_log` VALUES (2393, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:49:37');
INSERT INTO `operation_log` VALUES (2394, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:50:38');
INSERT INTO `operation_log` VALUES (2395, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:51:38');
INSERT INTO `operation_log` VALUES (2396, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:52:38');
INSERT INTO `operation_log` VALUES (2397, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:53:38');
INSERT INTO `operation_log` VALUES (2398, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:54:38');
INSERT INTO `operation_log` VALUES (2399, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:55:38');
INSERT INTO `operation_log` VALUES (2400, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:56:50');
INSERT INTO `operation_log` VALUES (2401, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:57:50');
INSERT INTO `operation_log` VALUES (2402, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:58:50');
INSERT INTO `operation_log` VALUES (2403, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 11:59:50');
INSERT INTO `operation_log` VALUES (2404, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 12:00:50');
INSERT INTO `operation_log` VALUES (2405, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 12:01:50');
INSERT INTO `operation_log` VALUES (2406, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 12:02:50');
INSERT INTO `operation_log` VALUES (2407, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 12:03:50');
INSERT INTO `operation_log` VALUES (2408, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 12:04:50');
INSERT INTO `operation_log` VALUES (2409, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 12:05:50');
INSERT INTO `operation_log` VALUES (2410, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:05:20');
INSERT INTO `operation_log` VALUES (2411, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:05:22');
INSERT INTO `operation_log` VALUES (2412, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@64a402c4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:05:22');
INSERT INTO `operation_log` VALUES (2413, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:05:22');
INSERT INTO `operation_log` VALUES (2414, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:05:27');
INSERT INTO `operation_log` VALUES (2415, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@69d8e703]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:06:23');
INSERT INTO `operation_log` VALUES (2416, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:07:01');
INSERT INTO `operation_log` VALUES (2417, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3b11c109]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:07:22');
INSERT INTO `operation_log` VALUES (2418, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4c81015c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:08:23');
INSERT INTO `operation_log` VALUES (2419, 1, 'admin', '其他', '新增', 'POST /dept/add', '[{\"id\":7,\"deptName\":\"综合部\",\"parentId\":null,\"sort\":null,\"leader\":null,\"phone\":null,\"email\":null,\"status\":1,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:08:43');
INSERT INTO `operation_log` VALUES (2420, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:08:43');
INSERT INTO `operation_log` VALUES (2421, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:09:02');
INSERT INTO `operation_log` VALUES (2422, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@1dc92139]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:09:12');
INSERT INTO `operation_log` VALUES (2423, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@726ea5e6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:09:22');
INSERT INTO `operation_log` VALUES (2424, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:25');
INSERT INTO `operation_log` VALUES (2425, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:26');
INSERT INTO `operation_log` VALUES (2426, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7efcd2c2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:26');
INSERT INTO `operation_log` VALUES (2427, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:26');
INSERT INTO `operation_log` VALUES (2428, 7, 'staff', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@7c0f9618]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:30');
INSERT INTO `operation_log` VALUES (2429, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@447bef9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:47');
INSERT INTO `operation_log` VALUES (2430, 7, 'staff', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:51');
INSERT INTO `operation_log` VALUES (2431, 7, 'staff', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:10:58');
INSERT INTO `operation_log` VALUES (2432, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6e644b37]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:11:26');
INSERT INTO `operation_log` VALUES (2433, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68405b79]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:12:26');
INSERT INTO `operation_log` VALUES (2434, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@85814f5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:13:26');
INSERT INTO `operation_log` VALUES (2435, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2c004e98]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:14:26');
INSERT INTO `operation_log` VALUES (2436, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6b0e8130]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:15:26');
INSERT INTO `operation_log` VALUES (2437, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6de274ea]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:16:26');
INSERT INTO `operation_log` VALUES (2438, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5dabdfa8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:17:26');
INSERT INTO `operation_log` VALUES (2439, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@208622c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:18:45');
INSERT INTO `operation_log` VALUES (2440, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5de909bc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:56:43');
INSERT INTO `operation_log` VALUES (2441, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7c3bef21]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:00');
INSERT INTO `operation_log` VALUES (2442, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:00');
INSERT INTO `operation_log` VALUES (2443, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:01');
INSERT INTO `operation_log` VALUES (2444, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:14');
INSERT INTO `operation_log` VALUES (2445, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@47b1e085]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:14');
INSERT INTO `operation_log` VALUES (2446, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:14');
INSERT INTO `operation_log` VALUES (2447, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:14');
INSERT INTO `operation_log` VALUES (2448, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:57:16');
INSERT INTO `operation_log` VALUES (2449, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6605a79a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:58:15');
INSERT INTO `operation_log` VALUES (2450, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:59:12');
INSERT INTO `operation_log` VALUES (2451, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7e2b4859]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:59:14');
INSERT INTO `operation_log` VALUES (2452, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:59:14');
INSERT INTO `operation_log` VALUES (2453, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:59:15');
INSERT INTO `operation_log` VALUES (2454, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 22:59:24');
INSERT INTO `operation_log` VALUES (2455, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5a85f172]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:00:15');
INSERT INTO `operation_log` VALUES (2456, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6ddc2ab1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:01:15');
INSERT INTO `operation_log` VALUES (2457, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@209a45c2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:02:15');
INSERT INTO `operation_log` VALUES (2458, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68c4ef2c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:03:15');
INSERT INTO `operation_log` VALUES (2459, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6056919]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:03:45');
INSERT INTO `operation_log` VALUES (2460, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:03:45');
INSERT INTO `operation_log` VALUES (2461, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:03:48');
INSERT INTO `operation_log` VALUES (2462, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7c998700]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:04:46');
INSERT INTO `operation_log` VALUES (2463, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1e19df55]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:05:46');
INSERT INTO `operation_log` VALUES (2464, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:06:38');
INSERT INTO `operation_log` VALUES (2465, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:06:40');
INSERT INTO `operation_log` VALUES (2466, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6865d652]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:06:45');
INSERT INTO `operation_log` VALUES (2467, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@656210e2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:07:46');
INSERT INTO `operation_log` VALUES (2468, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:08:26');
INSERT INTO `operation_log` VALUES (2469, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:08:26');
INSERT INTO `operation_log` VALUES (2470, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2b163cc9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:08:45');
INSERT INTO `operation_log` VALUES (2471, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6e582850]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:09:46');
INSERT INTO `operation_log` VALUES (2472, 1, 'unknown', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":8,\"username\":\"gm\",\"password\":null,\"realName\":\"总经理\",\"deptId\":2,\"phone\":\"13800138001\",\"email\":null,\"avatar\":null,\"role\":\"gm\",\"status\":1,\"roleIds\":null,\"deptIds\":null,\"mainDeptId\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:10:31');
INSERT INTO `operation_log` VALUES (2473, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:10:31');
INSERT INTO `operation_log` VALUES (2474, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:10:31');
INSERT INTO `operation_log` VALUES (2475, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@26fbc3dc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:10:46');
INSERT INTO `operation_log` VALUES (2476, 1, 'unknown', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":8,\"username\":\"gm\",\"password\":null,\"realName\":\"总经理\",\"deptId\":2,\"phone\":\"13800138001\",\"email\":null,\"avatar\":null,\"role\":\"gm\",\"status\":1,\"roleIds\":null,\"deptIds\":null,\"mainDeptId\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:11:02');
INSERT INTO `operation_log` VALUES (2477, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:11:03');
INSERT INTO `operation_log` VALUES (2478, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:11:03');
INSERT INTO `operation_log` VALUES (2479, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@12f61f63]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:11:45');
INSERT INTO `operation_log` VALUES (2480, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4b38c626]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:12:46');
INSERT INTO `operation_log` VALUES (2481, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5233cc51]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:13:47');
INSERT INTO `operation_log` VALUES (2482, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4d69ef2f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:14:48');
INSERT INTO `operation_log` VALUES (2483, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:15:35');
INSERT INTO `operation_log` VALUES (2484, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@17d4e967]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:15:36');
INSERT INTO `operation_log` VALUES (2485, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:15:36');
INSERT INTO `operation_log` VALUES (2486, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:15:36');
INSERT INTO `operation_log` VALUES (2487, 7, 'staff', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@2c72a406]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:16:31');
INSERT INTO `operation_log` VALUES (2488, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2380eaae]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:16:36');
INSERT INTO `operation_log` VALUES (2489, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c6ed302]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:17:36');
INSERT INTO `operation_log` VALUES (2490, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@60c32d5c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:18:36');
INSERT INTO `operation_log` VALUES (2491, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@c6bca9b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:19:36');
INSERT INTO `operation_log` VALUES (2492, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4015fb45]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:20:36');
INSERT INTO `operation_log` VALUES (2493, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@10d8e0b4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:21:36');
INSERT INTO `operation_log` VALUES (2494, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4b39ee8b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:22:50');
INSERT INTO `operation_log` VALUES (2495, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@63f7517f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:23:50');
INSERT INTO `operation_log` VALUES (2496, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4062dfcf]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:24:50');
INSERT INTO `operation_log` VALUES (2497, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@590e469b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:25:50');
INSERT INTO `operation_log` VALUES (2498, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@25614c76]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:26:50');
INSERT INTO `operation_log` VALUES (2499, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5a3fd8c2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:27:50');
INSERT INTO `operation_log` VALUES (2500, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@102fff18]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:28:50');
INSERT INTO `operation_log` VALUES (2501, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3356936b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:29:50');
INSERT INTO `operation_log` VALUES (2502, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7575f316]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:30:50');
INSERT INTO `operation_log` VALUES (2503, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@46e36c74]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-11 23:31:50');
INSERT INTO `operation_log` VALUES (2504, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:49:10');
INSERT INTO `operation_log` VALUES (2505, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1a41a106]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:49:12');
INSERT INTO `operation_log` VALUES (2506, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:49:12');
INSERT INTO `operation_log` VALUES (2507, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:49:12');
INSERT INTO `operation_log` VALUES (2508, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:49:24');
INSERT INTO `operation_log` VALUES (2509, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@4ab233e7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:49:30');
INSERT INTO `operation_log` VALUES (2510, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5126e607]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:50:12');
INSERT INTO `operation_log` VALUES (2511, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@35266e7c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:51:12');
INSERT INTO `operation_log` VALUES (2512, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@525be908]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:52:12');
INSERT INTO `operation_log` VALUES (2513, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6eb8751]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:53:12');
INSERT INTO `operation_log` VALUES (2514, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42826bb8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:54:12');
INSERT INTO `operation_log` VALUES (2515, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@591579be]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 15:55:12');
INSERT INTO `operation_log` VALUES (2516, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:29:27');
INSERT INTO `operation_log` VALUES (2517, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@14396535]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:29:28');
INSERT INTO `operation_log` VALUES (2518, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:29:28');
INSERT INTO `operation_log` VALUES (2519, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:29:28');
INSERT INTO `operation_log` VALUES (2520, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@fbe2d3e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:30:28');
INSERT INTO `operation_log` VALUES (2521, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@26e22895]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:31:28');
INSERT INTO `operation_log` VALUES (2522, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7a4d4aa9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:32:28');
INSERT INTO `operation_log` VALUES (2523, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@73bab5e4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:33:28');
INSERT INTO `operation_log` VALUES (2524, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:33:52');
INSERT INTO `operation_log` VALUES (2525, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4cd2c6f0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:34:28');
INSERT INTO `operation_log` VALUES (2526, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@36b7e5ef]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:35:28');
INSERT INTO `operation_log` VALUES (2527, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3c83cab7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:36:28');
INSERT INTO `operation_log` VALUES (2528, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@295b7703]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:37:28');
INSERT INTO `operation_log` VALUES (2529, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3c4ea7b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:38:28');
INSERT INTO `operation_log` VALUES (2530, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@51ec5925]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:39:28');
INSERT INTO `operation_log` VALUES (2531, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@52f91333]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:40:28');
INSERT INTO `operation_log` VALUES (2532, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6615bdc0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:41:28');
INSERT INTO `operation_log` VALUES (2533, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1f8efed5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:42:29');
INSERT INTO `operation_log` VALUES (2534, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@677ef447]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:43:30');
INSERT INTO `operation_log` VALUES (2535, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@701e2276]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:44:31');
INSERT INTO `operation_log` VALUES (2536, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7dbe2bd5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:45:32');
INSERT INTO `operation_log` VALUES (2537, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6846707]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:46:33');
INSERT INTO `operation_log` VALUES (2538, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@a0ac6e6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:47:34');
INSERT INTO `operation_log` VALUES (2539, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5abc7f20]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:48:35');
INSERT INTO `operation_log` VALUES (2540, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@85814f5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:49:36');
INSERT INTO `operation_log` VALUES (2541, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@381d2762]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:50:37');
INSERT INTO `operation_log` VALUES (2542, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@428e974c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:51:38');
INSERT INTO `operation_log` VALUES (2543, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@9c82606]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:52:39');
INSERT INTO `operation_log` VALUES (2544, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5f4e3aa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:53:40');
INSERT INTO `operation_log` VALUES (2545, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5c4eee85]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 18:54:41');
INSERT INTO `operation_log` VALUES (2546, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@51d46e8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:45:42');
INSERT INTO `operation_log` VALUES (2547, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:45:44');
INSERT INTO `operation_log` VALUES (2548, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@575ec1af]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:45:44');
INSERT INTO `operation_log` VALUES (2549, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:45:47');
INSERT INTO `operation_log` VALUES (2550, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:45:48');
INSERT INTO `operation_log` VALUES (2551, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2518af98]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:46:45');
INSERT INTO `operation_log` VALUES (2552, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f194ceb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:47:45');
INSERT INTO `operation_log` VALUES (2553, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@225bda1a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:48:44');
INSERT INTO `operation_log` VALUES (2554, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@708948da]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:49:44');
INSERT INTO `operation_log` VALUES (2555, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6430726c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:50:45');
INSERT INTO `operation_log` VALUES (2556, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3aa98b83]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:51:45');
INSERT INTO `operation_log` VALUES (2557, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@302b9ef1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:52:46');
INSERT INTO `operation_log` VALUES (2558, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61dcc970]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:53:47');
INSERT INTO `operation_log` VALUES (2559, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@123d0319]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:54:48');
INSERT INTO `operation_log` VALUES (2560, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1200956a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:55:49');
INSERT INTO `operation_log` VALUES (2561, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@38430034]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:56:50');
INSERT INTO `operation_log` VALUES (2562, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2e2f9e2f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:57:50');
INSERT INTO `operation_log` VALUES (2563, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@732aa326]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:58:50');
INSERT INTO `operation_log` VALUES (2564, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@136390c3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 19:59:50');
INSERT INTO `operation_log` VALUES (2565, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4dfcfcce]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:00:50');
INSERT INTO `operation_log` VALUES (2566, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@652d8f9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:01:50');
INSERT INTO `operation_log` VALUES (2567, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49604d2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:02:50');
INSERT INTO `operation_log` VALUES (2568, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@12f61f63]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:03:50');
INSERT INTO `operation_log` VALUES (2569, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@350cc4d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:04:50');
INSERT INTO `operation_log` VALUES (2570, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:08');
INSERT INTO `operation_log` VALUES (2571, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:15');
INSERT INTO `operation_log` VALUES (2572, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2ce4cd76]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:16');
INSERT INTO `operation_log` VALUES (2573, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:16');
INSERT INTO `operation_log` VALUES (2574, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:17');
INSERT INTO `operation_log` VALUES (2575, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:21');
INSERT INTO `operation_log` VALUES (2576, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 20:59:21');
INSERT INTO `operation_log` VALUES (2577, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@a725955]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:00:17');
INSERT INTO `operation_log` VALUES (2578, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@54fd0320]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:01:17');
INSERT INTO `operation_log` VALUES (2579, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@302b083e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:02:16');
INSERT INTO `operation_log` VALUES (2580, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6353311]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:03:17');
INSERT INTO `operation_log` VALUES (2581, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@37849c5b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:04:17');
INSERT INTO `operation_log` VALUES (2582, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68d9016f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:05:16');
INSERT INTO `operation_log` VALUES (2583, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:06:16');
INSERT INTO `operation_log` VALUES (2584, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6d39a43b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:06:16');
INSERT INTO `operation_log` VALUES (2585, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:06:16');
INSERT INTO `operation_log` VALUES (2586, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4ae7d1be]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:07:17');
INSERT INTO `operation_log` VALUES (2587, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:07:21');
INSERT INTO `operation_log` VALUES (2588, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:07:21');
INSERT INTO `operation_log` VALUES (2589, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:07:21');
INSERT INTO `operation_log` VALUES (2590, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1cf547f6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:08:17');
INSERT INTO `operation_log` VALUES (2591, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@71ec6ef8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:09:16');
INSERT INTO `operation_log` VALUES (2592, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:09:38');
INSERT INTO `operation_log` VALUES (2593, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:09:38');
INSERT INTO `operation_log` VALUES (2594, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@53270b1b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:09:38');
INSERT INTO `operation_log` VALUES (2595, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:09:38');
INSERT INTO `operation_log` VALUES (2596, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2fab5b9f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:10:38');
INSERT INTO `operation_log` VALUES (2597, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@334e0715]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:11:38');
INSERT INTO `operation_log` VALUES (2598, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@92ccfe2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:12:38');
INSERT INTO `operation_log` VALUES (2599, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5b6de5ad]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:13:38');
INSERT INTO `operation_log` VALUES (2600, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2fc359df]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:14:38');
INSERT INTO `operation_log` VALUES (2601, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@854081c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 21:15:38');
INSERT INTO `operation_log` VALUES (2602, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@21dc6d8c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:22:52');
INSERT INTO `operation_log` VALUES (2603, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b157a6a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:22:53');
INSERT INTO `operation_log` VALUES (2604, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:22:53');
INSERT INTO `operation_log` VALUES (2605, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:22:53');
INSERT INTO `operation_log` VALUES (2606, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:22:53');
INSERT INTO `operation_log` VALUES (2607, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:23:12');
INSERT INTO `operation_log` VALUES (2608, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@54fd0320]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:23:13');
INSERT INTO `operation_log` VALUES (2609, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:23:12');
INSERT INTO `operation_log` VALUES (2610, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:23:13');
INSERT INTO `operation_log` VALUES (2611, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:23:15');
INSERT INTO `operation_log` VALUES (2612, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:23:15');
INSERT INTO `operation_log` VALUES (2613, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@23b9607a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:24:13');
INSERT INTO `operation_log` VALUES (2614, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@85f4b9b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:25:13');
INSERT INTO `operation_log` VALUES (2615, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@cca3726]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:26:13');
INSERT INTO `operation_log` VALUES (2616, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3449820]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:27:13');
INSERT INTO `operation_log` VALUES (2617, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@e852067]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:28:14');
INSERT INTO `operation_log` VALUES (2618, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3394b927]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:29:12');
INSERT INTO `operation_log` VALUES (2619, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@5e38db8c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:29:13');
INSERT INTO `operation_log` VALUES (2620, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:29:48');
INSERT INTO `operation_log` VALUES (2621, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:29:48');
INSERT INTO `operation_log` VALUES (2622, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:29:48');
INSERT INTO `operation_log` VALUES (2623, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@51d16e22]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:29:50');
INSERT INTO `operation_log` VALUES (2624, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4018eb77]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:30:13');
INSERT INTO `operation_log` VALUES (2625, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@ae2ee75]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:31:08');
INSERT INTO `operation_log` VALUES (2626, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6f7839cf]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:31:08');
INSERT INTO `operation_log` VALUES (2627, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6d04fed3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:32:09');
INSERT INTO `operation_log` VALUES (2628, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4ddbfea1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:33:09');
INSERT INTO `operation_log` VALUES (2629, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4e93d6f4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:34:09');
INSERT INTO `operation_log` VALUES (2630, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:34:24');
INSERT INTO `operation_log` VALUES (2631, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:34:24');
INSERT INTO `operation_log` VALUES (2632, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@617b9bdb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:35:09');
INSERT INTO `operation_log` VALUES (2633, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@50a5b8eb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:36:09');
INSERT INTO `operation_log` VALUES (2634, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@67ef4284]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:37:09');
INSERT INTO `operation_log` VALUES (2635, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@74eeb12e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:38:41');
INSERT INTO `operation_log` VALUES (2636, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68179678]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:39:42');
INSERT INTO `operation_log` VALUES (2637, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@31f559a2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:40:43');
INSERT INTO `operation_log` VALUES (2638, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@20836268]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:41:44');
INSERT INTO `operation_log` VALUES (2639, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@74ffd2ea]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:42:36');
INSERT INTO `operation_log` VALUES (2640, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5ca8e355]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:43:09');
INSERT INTO `operation_log` VALUES (2641, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7fb084ee]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:44:50');
INSERT INTO `operation_log` VALUES (2642, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@557660e1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:45:50');
INSERT INTO `operation_log` VALUES (2643, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2edf9565]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:46:50');
INSERT INTO `operation_log` VALUES (2644, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1247582e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:47:50');
INSERT INTO `operation_log` VALUES (2645, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:56:56');
INSERT INTO `operation_log` VALUES (2646, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@326472c7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:56:56');
INSERT INTO `operation_log` VALUES (2647, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5ed7273c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:56:56');
INSERT INTO `operation_log` VALUES (2648, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:56:57');
INSERT INTO `operation_log` VALUES (2649, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:06');
INSERT INTO `operation_log` VALUES (2650, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@37849c5b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:07');
INSERT INTO `operation_log` VALUES (2651, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:07');
INSERT INTO `operation_log` VALUES (2652, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:07');
INSERT INTO `operation_log` VALUES (2653, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6ac594f9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:09');
INSERT INTO `operation_log` VALUES (2654, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:09');
INSERT INTO `operation_log` VALUES (2655, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:09');
INSERT INTO `operation_log` VALUES (2656, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@6416c9c9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:13');
INSERT INTO `operation_log` VALUES (2657, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:32');
INSERT INTO `operation_log` VALUES (2658, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:57:32');
INSERT INTO `operation_log` VALUES (2659, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4841c156]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:58:09');
INSERT INTO `operation_log` VALUES (2660, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4a158071]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 22:59:09');
INSERT INTO `operation_log` VALUES (2661, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:00:00');
INSERT INTO `operation_log` VALUES (2662, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@438db354]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:00:00');
INSERT INTO `operation_log` VALUES (2663, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:00:00');
INSERT INTO `operation_log` VALUES (2664, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:00:00');
INSERT INTO `operation_log` VALUES (2665, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@797fec2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:00:02');
INSERT INTO `operation_log` VALUES (2666, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2c1f909c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:01:00');
INSERT INTO `operation_log` VALUES (2667, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42b1f819]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:02:01');
INSERT INTO `operation_log` VALUES (2668, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4cbdbd5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:03:01');
INSERT INTO `operation_log` VALUES (2669, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@312b8b27]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:04:01');
INSERT INTO `operation_log` VALUES (2670, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4a4aa125]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:05:01');
INSERT INTO `operation_log` VALUES (2671, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@12df1ddb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:36:44');
INSERT INTO `operation_log` VALUES (2672, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@236d3a6f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:36:44');
INSERT INTO `operation_log` VALUES (2673, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@f0aa4d6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:36:44');
INSERT INTO `operation_log` VALUES (2674, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:36:59');
INSERT INTO `operation_log` VALUES (2675, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6f41f393]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:37:00');
INSERT INTO `operation_log` VALUES (2676, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:37:00');
INSERT INTO `operation_log` VALUES (2677, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:37:00');
INSERT INTO `operation_log` VALUES (2678, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@1f05d1b7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:37:01');
INSERT INTO `operation_log` VALUES (2679, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6efd699f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:38:00');
INSERT INTO `operation_log` VALUES (2680, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@52abe272]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:39:00');
INSERT INTO `operation_log` VALUES (2681, 7, 'staff', '报销', 'GET', 'GET /expense/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:39:43');
INSERT INTO `operation_log` VALUES (2682, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:39:55');
INSERT INTO `operation_log` VALUES (2683, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@74fe29ac]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:39:56');
INSERT INTO `operation_log` VALUES (2684, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:39:56');
INSERT INTO `operation_log` VALUES (2685, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:39:56');
INSERT INTO `operation_log` VALUES (2686, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:40:01');
INSERT INTO `operation_log` VALUES (2687, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:40:01');
INSERT INTO `operation_log` VALUES (2688, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4cdf5ea8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:40:56');
INSERT INTO `operation_log` VALUES (2689, 1, 'unknown', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":8,\"username\":\"gm\",\"password\":null,\"realName\":\"总经理\",\"deptId\":null,\"phone\":null,\"email\":null,\"avatar\":null,\"role\":null,\"status\":null,\"roleIds\":[],\"mainDeptId\":null,\"deptIds\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:41:45');
INSERT INTO `operation_log` VALUES (2690, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:41:45');
INSERT INTO `operation_log` VALUES (2691, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:41:45');
INSERT INTO `operation_log` VALUES (2692, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@35939eb6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:41:56');
INSERT INTO `operation_log` VALUES (2693, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7ebb28b8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:42:56');
INSERT INTO `operation_log` VALUES (2694, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6886b4e7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:43:56');
INSERT INTO `operation_log` VALUES (2695, 1, 'unknown', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":4,\"username\":\"sales\",\"password\":null,\"realName\":\"赵六\",\"deptId\":null,\"phone\":null,\"email\":null,\"avatar\":null,\"role\":null,\"status\":null,\"roleIds\":[],\"mainDeptId\":null,\"deptIds\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:44:33');
INSERT INTO `operation_log` VALUES (2696, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:44:33');
INSERT INTO `operation_log` VALUES (2697, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:44:33');
INSERT INTO `operation_log` VALUES (2698, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2d502bf2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:44:56');
INSERT INTO `operation_log` VALUES (2699, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3c40dee6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:45:56');
INSERT INTO `operation_log` VALUES (2700, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1cebf08a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:47:50');
INSERT INTO `operation_log` VALUES (2701, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1bd0f2e4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:48:50');
INSERT INTO `operation_log` VALUES (2702, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42c0d759]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:49:50');
INSERT INTO `operation_log` VALUES (2703, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@156d0daa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:50:50');
INSERT INTO `operation_log` VALUES (2704, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@72a620a7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:51:50');
INSERT INTO `operation_log` VALUES (2705, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@12deb225]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:52:50');
INSERT INTO `operation_log` VALUES (2706, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@71fcf96a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:53:50');
INSERT INTO `operation_log` VALUES (2707, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4c445d6d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:54:50');
INSERT INTO `operation_log` VALUES (2708, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4c66c7a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:55:50');
INSERT INTO `operation_log` VALUES (2709, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@509cabfc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:56:50');
INSERT INTO `operation_log` VALUES (2710, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4568cc27]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:57:50');
INSERT INTO `operation_log` VALUES (2711, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f7838d1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:58:50');
INSERT INTO `operation_log` VALUES (2712, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6c852615]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-12 23:59:50');
INSERT INTO `operation_log` VALUES (2713, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:28:11');
INSERT INTO `operation_log` VALUES (2714, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:28:12');
INSERT INTO `operation_log` VALUES (2715, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@558e3aad]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:28:12');
INSERT INTO `operation_log` VALUES (2716, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:28:12');
INSERT INTO `operation_log` VALUES (2717, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@680214ff]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:29:12');
INSERT INTO `operation_log` VALUES (2718, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@14a2c3a3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:30:12');
INSERT INTO `operation_log` VALUES (2719, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61d2572f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:31:12');
INSERT INTO `operation_log` VALUES (2720, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3a96040]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:33:13');
INSERT INTO `operation_log` VALUES (2721, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@22624c57]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:33:37');
INSERT INTO `operation_log` VALUES (2722, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:33:37');
INSERT INTO `operation_log` VALUES (2723, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:33:37');
INSERT INTO `operation_log` VALUES (2724, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:02');
INSERT INTO `operation_log` VALUES (2725, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@389e5719]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:02');
INSERT INTO `operation_log` VALUES (2726, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:02');
INSERT INTO `operation_log` VALUES (2727, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@12fb5b87]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:06');
INSERT INTO `operation_log` VALUES (2728, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:06');
INSERT INTO `operation_log` VALUES (2729, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:06');
INSERT INTO `operation_log` VALUES (2730, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:14');
INSERT INTO `operation_log` VALUES (2731, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:34:14');
INSERT INTO `operation_log` VALUES (2732, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@687a8f4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:35:06');
INSERT INTO `operation_log` VALUES (2733, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3a9d8348]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:36:06');
INSERT INTO `operation_log` VALUES (2734, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@959fe2b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:37:06');
INSERT INTO `operation_log` VALUES (2735, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7ccb2c32]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:38:06');
INSERT INTO `operation_log` VALUES (2736, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@37d628f3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:39:06');
INSERT INTO `operation_log` VALUES (2737, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@70cb166f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:40:06');
INSERT INTO `operation_log` VALUES (2738, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:40:47');
INSERT INTO `operation_log` VALUES (2739, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:40:47');
INSERT INTO `operation_log` VALUES (2740, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42a09b8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:40:47');
INSERT INTO `operation_log` VALUES (2741, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:40:47');
INSERT INTO `operation_log` VALUES (2742, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@4487b449]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:40:49');
INSERT INTO `operation_log` VALUES (2743, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68769278]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:41:47');
INSERT INTO `operation_log` VALUES (2744, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@38a6e08a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:42:47');
INSERT INTO `operation_log` VALUES (2745, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2fc7eca9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:43:47');
INSERT INTO `operation_log` VALUES (2746, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@854081c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:44:47');
INSERT INTO `operation_log` VALUES (2747, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@29255c2a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:45:47');
INSERT INTO `operation_log` VALUES (2748, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@448649c7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:11');
INSERT INTO `operation_log` VALUES (2749, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@4975691e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:10');
INSERT INTO `operation_log` VALUES (2750, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@41bdbe2b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:11');
INSERT INTO `operation_log` VALUES (2751, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:22');
INSERT INTO `operation_log` VALUES (2752, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:22');
INSERT INTO `operation_log` VALUES (2753, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@26dabd89]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:22');
INSERT INTO `operation_log` VALUES (2754, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:22');
INSERT INTO `operation_log` VALUES (2755, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:25');
INSERT INTO `operation_log` VALUES (2756, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:47:25');
INSERT INTO `operation_log` VALUES (2757, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2852373d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:48:23');
INSERT INTO `operation_log` VALUES (2758, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@355b647]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:49:23');
INSERT INTO `operation_log` VALUES (2759, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f03f67]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:50:23');
INSERT INTO `operation_log` VALUES (2760, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7ed1d87e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:51:23');
INSERT INTO `operation_log` VALUES (2761, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7a7d159a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:52:23');
INSERT INTO `operation_log` VALUES (2762, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3a96040]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:32');
INSERT INTO `operation_log` VALUES (2763, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:44');
INSERT INTO `operation_log` VALUES (2764, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:44');
INSERT INTO `operation_log` VALUES (2765, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1fb0f195]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:47');
INSERT INTO `operation_log` VALUES (2766, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:47');
INSERT INTO `operation_log` VALUES (2767, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:47');
INSERT INTO `operation_log` VALUES (2768, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:49');
INSERT INTO `operation_log` VALUES (2769, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:49');
INSERT INTO `operation_log` VALUES (2770, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:54:51');
INSERT INTO `operation_log` VALUES (2771, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:55:11');
INSERT INTO `operation_log` VALUES (2772, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:55:11');
INSERT INTO `operation_log` VALUES (2773, 1, 'admin', '其他', 'GET', 'GET /user/depts/8', '[8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:55:13');
INSERT INTO `operation_log` VALUES (2774, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68768609]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:55:47');
INSERT INTO `operation_log` VALUES (2775, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f980fa4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:56:47');
INSERT INTO `operation_log` VALUES (2776, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7cd37bde]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:57:47');
INSERT INTO `operation_log` VALUES (2777, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@516e7b7e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:58:47');
INSERT INTO `operation_log` VALUES (2778, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7a3594a2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 21:59:47');
INSERT INTO `operation_log` VALUES (2779, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@35f451fb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:00:47');
INSERT INTO `operation_log` VALUES (2780, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@45208f1c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:02:22');
INSERT INTO `operation_log` VALUES (2781, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f980fa4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:03:22');
INSERT INTO `operation_log` VALUES (2782, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@744314dd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:01');
INSERT INTO `operation_log` VALUES (2783, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:12');
INSERT INTO `operation_log` VALUES (2784, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6ac594f9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:12');
INSERT INTO `operation_log` VALUES (2785, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:12');
INSERT INTO `operation_log` VALUES (2786, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:24');
INSERT INTO `operation_log` VALUES (2787, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:25');
INSERT INTO `operation_log` VALUES (2788, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@59cdd7b3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:25');
INSERT INTO `operation_log` VALUES (2789, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:25');
INSERT INTO `operation_log` VALUES (2790, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:26');
INSERT INTO `operation_log` VALUES (2791, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:27');
INSERT INTO `operation_log` VALUES (2792, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:04:29');
INSERT INTO `operation_log` VALUES (2793, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7362ea17]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:05:25');
INSERT INTO `operation_log` VALUES (2794, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68d9016f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:25');
INSERT INTO `operation_log` VALUES (2795, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@50fae8e2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:26');
INSERT INTO `operation_log` VALUES (2796, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:50');
INSERT INTO `operation_log` VALUES (2797, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:50');
INSERT INTO `operation_log` VALUES (2798, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@15a18a27]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:50');
INSERT INTO `operation_log` VALUES (2799, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:50');
INSERT INTO `operation_log` VALUES (2800, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@7c0dfa81]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:06:51');
INSERT INTO `operation_log` VALUES (2801, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b247181]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:07:50');
INSERT INTO `operation_log` VALUES (2802, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4c8fb2c3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:08:50');
INSERT INTO `operation_log` VALUES (2803, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b3b8e09]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:09:50');
INSERT INTO `operation_log` VALUES (2804, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4472f5f9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:10:50');
INSERT INTO `operation_log` VALUES (2805, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@58ea19ed]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:11:50');
INSERT INTO `operation_log` VALUES (2806, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5a708e2f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:12:50');
INSERT INTO `operation_log` VALUES (2807, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@71678fc8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:14:17');
INSERT INTO `operation_log` VALUES (2808, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@59fd4a7f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:15:18');
INSERT INTO `operation_log` VALUES (2809, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1f9e03d3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:16:19');
INSERT INTO `operation_log` VALUES (2810, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@557eb86f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:17:20');
INSERT INTO `operation_log` VALUES (2811, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4a150e34]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:18:21');
INSERT INTO `operation_log` VALUES (2812, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@528ad5e4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:19:22');
INSERT INTO `operation_log` VALUES (2813, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@361e393a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:20:54');
INSERT INTO `operation_log` VALUES (2814, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49512d40]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:20:54');
INSERT INTO `operation_log` VALUES (2815, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@3bc57650]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:20:54');
INSERT INTO `operation_log` VALUES (2816, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@4360b51a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:20:57');
INSERT INTO `operation_log` VALUES (2817, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61aa21aa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:20:57');
INSERT INTO `operation_log` VALUES (2818, 7, 'staff', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=null, formNo=EXP202608140001, applicantId=7, deptId=4, applyDate=2026-08-14, totalAmount=6000, reason=多少, currentApproverId=null, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=null, expenseTypeId=1, expenseDate=2026-08-14, amount=6000, invoiceCount=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@7601900f], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@193cbfdd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:14');
INSERT INTO `operation_log` VALUES (2819, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:39');
INSERT INTO `operation_log` VALUES (2820, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:40');
INSERT INTO `operation_log` VALUES (2821, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@320005be]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:40');
INSERT INTO `operation_log` VALUES (2822, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:40');
INSERT INTO `operation_log` VALUES (2823, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:42');
INSERT INTO `operation_log` VALUES (2824, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:42');
INSERT INTO `operation_log` VALUES (2825, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:21:44');
INSERT INTO `operation_log` VALUES (2826, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1a3c1ab]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:22:40');
INSERT INTO `operation_log` VALUES (2827, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@62d1d535]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:23:40');
INSERT INTO `operation_log` VALUES (2828, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@41bb0f7c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:24:40');
INSERT INTO `operation_log` VALUES (2829, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@493fb4a3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:25:40');
INSERT INTO `operation_log` VALUES (2830, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@204e0a49]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:26:40');
INSERT INTO `operation_log` VALUES (2831, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@32679bdc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:27:40');
INSERT INTO `operation_log` VALUES (2832, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:22');
INSERT INTO `operation_log` VALUES (2833, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:22');
INSERT INTO `operation_log` VALUES (2834, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:24');
INSERT INTO `operation_log` VALUES (2835, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:24');
INSERT INTO `operation_log` VALUES (2836, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:26');
INSERT INTO `operation_log` VALUES (2837, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:26');
INSERT INTO `operation_log` VALUES (2838, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:27');
INSERT INTO `operation_log` VALUES (2839, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3f3eb217]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:28:40');
INSERT INTO `operation_log` VALUES (2840, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49a31c1e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:29:46');
INSERT INTO `operation_log` VALUES (2841, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:30:12');
INSERT INTO `operation_log` VALUES (2842, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@10445ce2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:30:12');
INSERT INTO `operation_log` VALUES (2843, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:30:12');
INSERT INTO `operation_log` VALUES (2844, 1, 'admin', '其他', 'GET', 'GET /user/depts/8', '[8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:30:15');
INSERT INTO `operation_log` VALUES (2845, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@13d115a1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:31:12');
INSERT INTO `operation_log` VALUES (2846, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7343b0cd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:32:12');
INSERT INTO `operation_log` VALUES (2847, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3ae01055]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:33:12');
INSERT INTO `operation_log` VALUES (2848, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@242eac3a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:34:12');
INSERT INTO `operation_log` VALUES (2849, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2921d24a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:35:12');
INSERT INTO `operation_log` VALUES (2850, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:02');
INSERT INTO `operation_log` VALUES (2851, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@549c50a0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:02');
INSERT INTO `operation_log` VALUES (2852, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:02');
INSERT INTO `operation_log` VALUES (2853, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:06');
INSERT INTO `operation_log` VALUES (2854, 1, 'admin', '其他', 'GET', 'GET /user/depts/8', '[8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:13');
INSERT INTO `operation_log` VALUES (2855, 1, 'admin', '其他', 'GET', 'GET /user/depts/5', '[5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:17');
INSERT INTO `operation_log` VALUES (2856, 1, 'admin', '其他', 'GET', 'GET /user/depts/7', '[7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:21');
INSERT INTO `operation_log` VALUES (2857, 1, 'admin', '其他', 'GET', 'GET /user/depts/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:28');
INSERT INTO `operation_log` VALUES (2858, 1, 'admin', '其他', 'GET', 'GET /user/depts/6', '[6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:32');
INSERT INTO `operation_log` VALUES (2859, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:36');
INSERT INTO `operation_log` VALUES (2860, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:36:40');
INSERT INTO `operation_log` VALUES (2861, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@67737531]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:02');
INSERT INTO `operation_log` VALUES (2862, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:07');
INSERT INTO `operation_log` VALUES (2863, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:07');
INSERT INTO `operation_log` VALUES (2864, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:10');
INSERT INTO `operation_log` VALUES (2865, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@40b89f7e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:10');
INSERT INTO `operation_log` VALUES (2866, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:10');
INSERT INTO `operation_log` VALUES (2867, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:11');
INSERT INTO `operation_log` VALUES (2868, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:37:15');
INSERT INTO `operation_log` VALUES (2869, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7d6d0d11]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:38:10');
INSERT INTO `operation_log` VALUES (2870, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:38:36');
INSERT INTO `operation_log` VALUES (2871, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:38:39');
INSERT INTO `operation_log` VALUES (2872, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:38:46');
INSERT INTO `operation_log` VALUES (2873, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:39:04');
INSERT INTO `operation_log` VALUES (2874, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1bf30a15]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:39:04');
INSERT INTO `operation_log` VALUES (2875, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:39:04');
INSERT INTO `operation_log` VALUES (2876, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:39:07');
INSERT INTO `operation_log` VALUES (2877, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@bfffd6a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:40:05');
INSERT INTO `operation_log` VALUES (2878, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@44e5fea8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:41:05');
INSERT INTO `operation_log` VALUES (2879, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@155cfd56]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:42:05');
INSERT INTO `operation_log` VALUES (2880, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1f04b562]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:43:05');
INSERT INTO `operation_log` VALUES (2881, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@392cc957]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:44:05');
INSERT INTO `operation_log` VALUES (2882, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3e6c464]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:45:05');
INSERT INTO `operation_log` VALUES (2883, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1f0112b4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:46:07');
INSERT INTO `operation_log` VALUES (2884, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c851435]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:47:08');
INSERT INTO `operation_log` VALUES (2885, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7ba1e5ec]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:48:09');
INSERT INTO `operation_log` VALUES (2886, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@181724ca]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:49:10');
INSERT INTO `operation_log` VALUES (2887, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4ba556b7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:50:11');
INSERT INTO `operation_log` VALUES (2888, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@697d2eca]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:51:12');
INSERT INTO `operation_log` VALUES (2889, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6b918b4f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:52:13');
INSERT INTO `operation_log` VALUES (2890, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1327fd3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:53:14');
INSERT INTO `operation_log` VALUES (2891, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49b96e58]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:54:15');
INSERT INTO `operation_log` VALUES (2892, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@62123d57]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:55:16');
INSERT INTO `operation_log` VALUES (2893, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7cce2b65]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-14 22:56:17');
INSERT INTO `operation_log` VALUES (2894, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:07');
INSERT INTO `operation_log` VALUES (2895, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:19');
INSERT INTO `operation_log` VALUES (2896, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:20');
INSERT INTO `operation_log` VALUES (2897, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@706ac18a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:20');
INSERT INTO `operation_log` VALUES (2898, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:20');
INSERT INTO `operation_log` VALUES (2899, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:22');
INSERT INTO `operation_log` VALUES (2900, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:22');
INSERT INTO `operation_log` VALUES (2901, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:28:35');
INSERT INTO `operation_log` VALUES (2902, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@70a1cefd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:08');
INSERT INTO `operation_log` VALUES (2903, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2b1a9ab8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:08');
INSERT INTO `operation_log` VALUES (2904, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:13');
INSERT INTO `operation_log` VALUES (2905, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:13');
INSERT INTO `operation_log` VALUES (2906, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:14');
INSERT INTO `operation_log` VALUES (2907, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:27');
INSERT INTO `operation_log` VALUES (2908, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:36');
INSERT INTO `operation_log` VALUES (2909, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:36');
INSERT INTO `operation_log` VALUES (2910, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:40');
INSERT INTO `operation_log` VALUES (2911, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@278b43ba]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:40');
INSERT INTO `operation_log` VALUES (2912, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:40');
INSERT INTO `operation_log` VALUES (2913, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:45');
INSERT INTO `operation_log` VALUES (2914, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@372d83d0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:52');
INSERT INTO `operation_log` VALUES (2915, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:29:58');
INSERT INTO `operation_log` VALUES (2916, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@40dcc2c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:30:40');
INSERT INTO `operation_log` VALUES (2917, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5c96c39a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:31:39');
INSERT INTO `operation_log` VALUES (2918, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:32:24');
INSERT INTO `operation_log` VALUES (2919, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:32:24');
INSERT INTO `operation_log` VALUES (2920, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@14673a5b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:32:40');
INSERT INTO `operation_log` VALUES (2921, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:32:59');
INSERT INTO `operation_log` VALUES (2922, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:33:15');
INSERT INTO `operation_log` VALUES (2923, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:33:15');
INSERT INTO `operation_log` VALUES (2924, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:33:18');
INSERT INTO `operation_log` VALUES (2925, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@56d2d5be]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:33:27');
INSERT INTO `operation_log` VALUES (2926, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:33:27');
INSERT INTO `operation_log` VALUES (2927, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:33:33');
INSERT INTO `operation_log` VALUES (2928, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@48b83f57]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:34:26');
INSERT INTO `operation_log` VALUES (2929, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:34:30');
INSERT INTO `operation_log` VALUES (2930, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:34:34');
INSERT INTO `operation_log` VALUES (2931, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2194d2c8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:35:27');
INSERT INTO `operation_log` VALUES (2932, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:35:32');
INSERT INTO `operation_log` VALUES (2933, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:35:32');
INSERT INTO `operation_log` VALUES (2934, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39e51a5a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:36:26');
INSERT INTO `operation_log` VALUES (2935, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@38a4bda2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:37:27');
INSERT INTO `operation_log` VALUES (2936, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:38:15');
INSERT INTO `operation_log` VALUES (2937, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c7e11a9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:38:26');
INSERT INTO `operation_log` VALUES (2938, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1d97c6f1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:39:27');
INSERT INTO `operation_log` VALUES (2939, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@40ee3c2a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:40:31');
INSERT INTO `operation_log` VALUES (2940, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@aee6993]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:41:27');
INSERT INTO `operation_log` VALUES (2941, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c966659]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:42:27');
INSERT INTO `operation_log` VALUES (2942, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@69ad7b16]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:43:28');
INSERT INTO `operation_log` VALUES (2943, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1416054d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:44:29');
INSERT INTO `operation_log` VALUES (2944, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:22');
INSERT INTO `operation_log` VALUES (2945, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:22');
INSERT INTO `operation_log` VALUES (2946, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:24');
INSERT INTO `operation_log` VALUES (2947, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:26');
INSERT INTO `operation_log` VALUES (2948, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:26');
INSERT INTO `operation_log` VALUES (2949, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@765c7eaf]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:26');
INSERT INTO `operation_log` VALUES (2950, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:28');
INSERT INTO `operation_log` VALUES (2951, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:29');
INSERT INTO `operation_log` VALUES (2952, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:29');
INSERT INTO `operation_log` VALUES (2953, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:32');
INSERT INTO `operation_log` VALUES (2954, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:36');
INSERT INTO `operation_log` VALUES (2955, 1, 'admin', '其他', 'GET', 'GET /user/depts/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:39');
INSERT INTO `operation_log` VALUES (2956, 1, 'admin', '其他', 'GET', 'GET /user/depts/5', '[5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:45:50');
INSERT INTO `operation_log` VALUES (2957, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@27ced242]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:46:27');
INSERT INTO `operation_log` VALUES (2958, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c39dc8a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 21:47:28');
INSERT INTO `operation_log` VALUES (2959, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@389bd93d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:16');
INSERT INTO `operation_log` VALUES (2960, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@559f5352]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:18');
INSERT INTO `operation_log` VALUES (2961, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:18');
INSERT INTO `operation_log` VALUES (2962, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:18');
INSERT INTO `operation_log` VALUES (2963, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:33');
INSERT INTO `operation_log` VALUES (2964, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@30394278]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:34');
INSERT INTO `operation_log` VALUES (2965, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:34');
INSERT INTO `operation_log` VALUES (2966, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:35');
INSERT INTO `operation_log` VALUES (2967, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:39');
INSERT INTO `operation_log` VALUES (2968, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:48');
INSERT INTO `operation_log` VALUES (2969, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:48');
INSERT INTO `operation_log` VALUES (2970, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:50');
INSERT INTO `operation_log` VALUES (2971, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:52');
INSERT INTO `operation_log` VALUES (2972, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:55');
INSERT INTO `operation_log` VALUES (2973, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:55');
INSERT INTO `operation_log` VALUES (2974, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:00:58');
INSERT INTO `operation_log` VALUES (2975, 1, 'admin', '其他', 'GET', 'GET /user/depts/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:01:03');
INSERT INTO `operation_log` VALUES (2976, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6c1e2bc1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:01:35');
INSERT INTO `operation_log` VALUES (2977, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3997da37]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:02:35');
INSERT INTO `operation_log` VALUES (2978, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@38d6d84f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:03:52');
INSERT INTO `operation_log` VALUES (2979, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@213c79a9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:03:55');
INSERT INTO `operation_log` VALUES (2980, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@76fa23fe]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:03:55');
INSERT INTO `operation_log` VALUES (2981, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:03:57');
INSERT INTO `operation_log` VALUES (2982, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:03:57');
INSERT INTO `operation_log` VALUES (2983, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6658759c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:04:56');
INSERT INTO `operation_log` VALUES (2984, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@53d2e60b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:05:56');
INSERT INTO `operation_log` VALUES (2985, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:06');
INSERT INTO `operation_log` VALUES (2986, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:07');
INSERT INTO `operation_log` VALUES (2987, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@73cdaedb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:09');
INSERT INTO `operation_log` VALUES (2988, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@234f6ca7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:12');
INSERT INTO `operation_log` VALUES (2989, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@66c785f3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:12');
INSERT INTO `operation_log` VALUES (2990, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:13');
INSERT INTO `operation_log` VALUES (2991, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:13');
INSERT INTO `operation_log` VALUES (2992, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:17');
INSERT INTO `operation_log` VALUES (2993, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7887b17a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:17');
INSERT INTO `operation_log` VALUES (2994, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:18');
INSERT INTO `operation_log` VALUES (2995, 1, 'admin', '其他', 'GET', 'GET /user/depts/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:19');
INSERT INTO `operation_log` VALUES (2996, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:06:22');
INSERT INTO `operation_log` VALUES (2997, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49d4648d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:07:18');
INSERT INTO `operation_log` VALUES (2998, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5671295]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:08:18');
INSERT INTO `operation_log` VALUES (2999, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@36d05279]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:09:18');
INSERT INTO `operation_log` VALUES (3000, 1, 'admin', '其他', 'GET', 'GET /permission/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:09:58');
INSERT INTO `operation_log` VALUES (3001, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1cc813e6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:10:18');
INSERT INTO `operation_log` VALUES (3002, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2bb458c3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:11:18');
INSERT INTO `operation_log` VALUES (3003, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5050c1dc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:12:18');
INSERT INTO `operation_log` VALUES (3004, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@668a5eb2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 22:13:31');
INSERT INTO `operation_log` VALUES (3005, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:31');
INSERT INTO `operation_log` VALUES (3006, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7433994d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:31');
INSERT INTO `operation_log` VALUES (3007, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7463e0de]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:31');
INSERT INTO `operation_log` VALUES (3008, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@4f46e21]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:38');
INSERT INTO `operation_log` VALUES (3009, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@3f55efa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:43');
INSERT INTO `operation_log` VALUES (3010, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@625958c5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:43');
INSERT INTO `operation_log` VALUES (3011, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:45');
INSERT INTO `operation_log` VALUES (3012, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:46');
INSERT INTO `operation_log` VALUES (3013, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:48');
INSERT INTO `operation_log` VALUES (3014, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:18:54');
INSERT INTO `operation_log` VALUES (3015, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42bdd17d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:19:43');
INSERT INTO `operation_log` VALUES (3016, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:42');
INSERT INTO `operation_log` VALUES (3017, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2cd51b29]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:43');
INSERT INTO `operation_log` VALUES (3018, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:44');
INSERT INTO `operation_log` VALUES (3019, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:45');
INSERT INTO `operation_log` VALUES (3020, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:49');
INSERT INTO `operation_log` VALUES (3021, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:49');
INSERT INTO `operation_log` VALUES (3022, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:52');
INSERT INTO `operation_log` VALUES (3023, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:55');
INSERT INTO `operation_log` VALUES (3024, 1, 'admin', '其他', 'GET', 'GET /permission/role/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:55');
INSERT INTO `operation_log` VALUES (3025, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:20:58');
INSERT INTO `operation_log` VALUES (3026, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:21:00');
INSERT INTO `operation_log` VALUES (3027, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:21:00');
INSERT INTO `operation_log` VALUES (3028, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:21:02');
INSERT INTO `operation_log` VALUES (3029, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3bf6e661]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:21:43');
INSERT INTO `operation_log` VALUES (3030, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@75fc236c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:22:43');
INSERT INTO `operation_log` VALUES (3031, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@b54a667]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:23:43');
INSERT INTO `operation_log` VALUES (3032, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4cf9f667]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:24:43');
INSERT INTO `operation_log` VALUES (3033, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:07');
INSERT INTO `operation_log` VALUES (3034, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b2d7768]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:08');
INSERT INTO `operation_log` VALUES (3035, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:08');
INSERT INTO `operation_log` VALUES (3036, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:08');
INSERT INTO `operation_log` VALUES (3037, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:13');
INSERT INTO `operation_log` VALUES (3038, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:14');
INSERT INTO `operation_log` VALUES (3039, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:15');
INSERT INTO `operation_log` VALUES (3040, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:25');
INSERT INTO `operation_log` VALUES (3041, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:26');
INSERT INTO `operation_log` VALUES (3042, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:26');
INSERT INTO `operation_log` VALUES (3043, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:29');
INSERT INTO `operation_log` VALUES (3044, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:26:30');
INSERT INTO `operation_log` VALUES (3045, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f9ada32]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:27:09');
INSERT INTO `operation_log` VALUES (3046, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@c037cbc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:28:09');
INSERT INTO `operation_log` VALUES (3047, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:28:49');
INSERT INTO `operation_log` VALUES (3048, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:28:49');
INSERT INTO `operation_log` VALUES (3049, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:28:51');
INSERT INTO `operation_log` VALUES (3050, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:28:55');
INSERT INTO `operation_log` VALUES (3051, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:28:59');
INSERT INTO `operation_log` VALUES (3052, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:29:01');
INSERT INTO `operation_log` VALUES (3053, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2e7fb7a5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:29:08');
INSERT INTO `operation_log` VALUES (3054, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b83afb9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:30:09');
INSERT INTO `operation_log` VALUES (3055, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@a80f834]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:31:09');
INSERT INTO `operation_log` VALUES (3056, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@23e06029]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:32:09');
INSERT INTO `operation_log` VALUES (3057, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7f4122b1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:33:21');
INSERT INTO `operation_log` VALUES (3058, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-15 23:48:38');
INSERT INTO `operation_log` VALUES (3059, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@730a26be]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:48:38');
INSERT INTO `operation_log` VALUES (3060, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2b1b0ac5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:48:38');
INSERT INTO `operation_log` VALUES (3061, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@22db7645]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:48:40');
INSERT INTO `operation_log` VALUES (3062, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:01');
INSERT INTO `operation_log` VALUES (3063, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2c678dc5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:02');
INSERT INTO `operation_log` VALUES (3064, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:02');
INSERT INTO `operation_log` VALUES (3065, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:02');
INSERT INTO `operation_log` VALUES (3066, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:07');
INSERT INTO `operation_log` VALUES (3067, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@48b45349]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:07');
INSERT INTO `operation_log` VALUES (3068, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:07');
INSERT INTO `operation_log` VALUES (3069, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:10');
INSERT INTO `operation_log` VALUES (3070, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:10');
INSERT INTO `operation_log` VALUES (3071, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:13');
INSERT INTO `operation_log` VALUES (3072, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-15 23:49:18');
INSERT INTO `operation_log` VALUES (3073, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:18');
INSERT INTO `operation_log` VALUES (3074, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:26');
INSERT INTO `operation_log` VALUES (3075, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@1363db4c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:30');
INSERT INTO `operation_log` VALUES (3076, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:31');
INSERT INTO `operation_log` VALUES (3077, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:32');
INSERT INTO `operation_log` VALUES (3078, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:49:34');
INSERT INTO `operation_log` VALUES (3079, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@33d3731d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:50:07');
INSERT INTO `operation_log` VALUES (3080, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@655a5165]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:51:07');
INSERT INTO `operation_log` VALUES (3081, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@6f7e161a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:51:13');
INSERT INTO `operation_log` VALUES (3082, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-15 23:51:15');
INSERT INTO `operation_log` VALUES (3083, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@13438c70]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:52:07');
INSERT INTO `operation_log` VALUES (3084, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@600f9fcf]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:53:07');
INSERT INTO `operation_log` VALUES (3085, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@765b7410]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:53:43');
INSERT INTO `operation_log` VALUES (3086, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-15 23:53:44');
INSERT INTO `operation_log` VALUES (3087, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:53:51');
INSERT INTO `operation_log` VALUES (3088, 1, 'admin', '其他', 'GET', 'GET /permission/role/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:54:01');
INSERT INTO `operation_log` VALUES (3089, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-15 23:54:01');
INSERT INTO `operation_log` VALUES (3090, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@75ac0f6b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:54:44');
INSERT INTO `operation_log` VALUES (3091, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2cae8dcd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:55:44');
INSERT INTO `operation_log` VALUES (3092, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@397f8b43]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:56:44');
INSERT INTO `operation_log` VALUES (3093, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@149671f7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:57:44');
INSERT INTO `operation_log` VALUES (3094, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:21');
INSERT INTO `operation_log` VALUES (3095, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-15 23:58:23');
INSERT INTO `operation_log` VALUES (3096, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:23');
INSERT INTO `operation_log` VALUES (3097, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:30');
INSERT INTO `operation_log` VALUES (3098, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:31');
INSERT INTO `operation_log` VALUES (3099, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:31');
INSERT INTO `operation_log` VALUES (3100, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:33');
INSERT INTO `operation_log` VALUES (3101, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@107b476c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:58:43');
INSERT INTO `operation_log` VALUES (3102, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@f1fa172]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-15 23:59:44');
INSERT INTO `operation_log` VALUES (3103, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:00:05');
INSERT INTO `operation_log` VALUES (3104, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6fde0658]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:00:44');
INSERT INTO `operation_log` VALUES (3105, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@76d93f45]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:02:31');
INSERT INTO `operation_log` VALUES (3106, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@92ca040]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:00');
INSERT INTO `operation_log` VALUES (3107, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@67a3a930]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:01');
INSERT INTO `operation_log` VALUES (3108, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:03');
INSERT INTO `operation_log` VALUES (3109, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:03');
INSERT INTO `operation_log` VALUES (3110, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:06');
INSERT INTO `operation_log` VALUES (3111, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@14e1e02a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:06');
INSERT INTO `operation_log` VALUES (3112, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:06');
INSERT INTO `operation_log` VALUES (3113, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:08');
INSERT INTO `operation_log` VALUES (3114, 1, 'admin', '其他', 'GET', 'GET /user/8/roleIds', '[8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:04:09');
INSERT INTO `operation_log` VALUES (3115, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:06');
INSERT INTO `operation_log` VALUES (3116, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@546f79e0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:07');
INSERT INTO `operation_log` VALUES (3117, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:08');
INSERT INTO `operation_log` VALUES (3118, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:22');
INSERT INTO `operation_log` VALUES (3119, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@563e2626]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:23');
INSERT INTO `operation_log` VALUES (3120, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:23');
INSERT INTO `operation_log` VALUES (3121, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:23');
INSERT INTO `operation_log` VALUES (3122, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:25');
INSERT INTO `operation_log` VALUES (3123, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:25');
INSERT INTO `operation_log` VALUES (3124, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:27');
INSERT INTO `operation_log` VALUES (3125, 1, 'admin', '其他', 'GET', 'GET /user/1/roleIds', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:05:27');
INSERT INTO `operation_log` VALUES (3126, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@186279ca]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:06:23');
INSERT INTO `operation_log` VALUES (3127, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@41e28182]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:07:23');
INSERT INTO `operation_log` VALUES (3128, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@66517ee6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:08:23');
INSERT INTO `operation_log` VALUES (3129, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@16b54eea]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:36');
INSERT INTO `operation_log` VALUES (3130, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7763600f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:37');
INSERT INTO `operation_log` VALUES (3131, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:37');
INSERT INTO `operation_log` VALUES (3132, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:37');
INSERT INTO `operation_log` VALUES (3133, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@73c0b15c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:40');
INSERT INTO `operation_log` VALUES (3134, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:41');
INSERT INTO `operation_log` VALUES (3135, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:41');
INSERT INTO `operation_log` VALUES (3136, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:43');
INSERT INTO `operation_log` VALUES (3137, 1, 'admin', '其他', 'GET', 'GET /user/1/roleIds', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:16:43');
INSERT INTO `operation_log` VALUES (3138, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 0, 'class java.lang.Integer cannot be cast to class java.lang.Long (java.lang.Integer and java.lang.Long are in module java.base of loader \'bootstrap\')', '2026-08-16 00:16:49');
INSERT INTO `operation_log` VALUES (3139, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@fada19]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:17:37');
INSERT INTO `operation_log` VALUES (3140, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@72a11e82]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:18:37');
INSERT INTO `operation_log` VALUES (3141, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@17f3a24c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:19:37');
INSERT INTO `operation_log` VALUES (3142, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49c6f8a0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:20:37');
INSERT INTO `operation_log` VALUES (3143, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61331b2a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:21:37');
INSERT INTO `operation_log` VALUES (3144, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@b0c7bb0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:22:37');
INSERT INTO `operation_log` VALUES (3145, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@566ef65a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:37');
INSERT INTO `operation_log` VALUES (3146, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@4647a4e1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:36');
INSERT INTO `operation_log` VALUES (3147, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@294a6505]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:39');
INSERT INTO `operation_log` VALUES (3148, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@16b64976]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:39');
INSERT INTO `operation_log` VALUES (3149, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:42');
INSERT INTO `operation_log` VALUES (3150, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:51');
INSERT INTO `operation_log` VALUES (3151, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:53');
INSERT INTO `operation_log` VALUES (3152, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:23:53');
INSERT INTO `operation_log` VALUES (3153, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@291a7316]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:24:39');
INSERT INTO `operation_log` VALUES (3154, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@134f0cfb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:25:39');
INSERT INTO `operation_log` VALUES (3155, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@24cb36cc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:03');
INSERT INTO `operation_log` VALUES (3156, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:05');
INSERT INTO `operation_log` VALUES (3157, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@433a0e60]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:05');
INSERT INTO `operation_log` VALUES (3158, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:05');
INSERT INTO `operation_log` VALUES (3159, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:06');
INSERT INTO `operation_log` VALUES (3160, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:09');
INSERT INTO `operation_log` VALUES (3161, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:09');
INSERT INTO `operation_log` VALUES (3162, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:11');
INSERT INTO `operation_log` VALUES (3163, 1, 'admin', '其他', 'GET', 'GET /user/8/roleIds', '[8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:11');
INSERT INTO `operation_log` VALUES (3164, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:18');
INSERT INTO `operation_log` VALUES (3165, 1, 'admin', '其他', 'GET', 'GET /user/1/roleIds', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:28:18');
INSERT INTO `operation_log` VALUES (3166, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3dc410b0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:29:05');
INSERT INTO `operation_log` VALUES (3167, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1f6b40b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:30:05');
INSERT INTO `operation_log` VALUES (3168, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:30:50');
INSERT INTO `operation_log` VALUES (3169, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:30:53');
INSERT INTO `operation_log` VALUES (3170, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@66c5b682]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:31:05');
INSERT INTO `operation_log` VALUES (3171, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5e9e07f5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:05');
INSERT INTO `operation_log` VALUES (3172, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3c4200f1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:17');
INSERT INTO `operation_log` VALUES (3173, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:17');
INSERT INTO `operation_log` VALUES (3174, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:22');
INSERT INTO `operation_log` VALUES (3175, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:22');
INSERT INTO `operation_log` VALUES (3176, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:23');
INSERT INTO `operation_log` VALUES (3177, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:25');
INSERT INTO `operation_log` VALUES (3178, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:25');
INSERT INTO `operation_log` VALUES (3179, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:30');
INSERT INTO `operation_log` VALUES (3180, 1, 'admin', '其他', 'GET', 'GET /permission/role/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:32');
INSERT INTO `operation_log` VALUES (3181, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:32');
INSERT INTO `operation_log` VALUES (3182, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:35');
INSERT INTO `operation_log` VALUES (3183, 1, 'admin', '其他', 'GET', 'GET /permission/role/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:38');
INSERT INTO `operation_log` VALUES (3184, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:38');
INSERT INTO `operation_log` VALUES (3185, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:42');
INSERT INTO `operation_log` VALUES (3186, 1, 'admin', '其他', 'GET', 'GET /permission/role/6', '[6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:44');
INSERT INTO `operation_log` VALUES (3187, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:32:44');
INSERT INTO `operation_log` VALUES (3188, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:06');
INSERT INTO `operation_log` VALUES (3189, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:09');
INSERT INTO `operation_log` VALUES (3190, 1, 'admin', '其他', 'GET', 'GET /permission/role/5', '[5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:09');
INSERT INTO `operation_log` VALUES (3191, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@19fa5b4d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:17');
INSERT INTO `operation_log` VALUES (3192, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:18');
INSERT INTO `operation_log` VALUES (3193, 1, 'admin', '其他', 'GET', 'GET /permission/role/8', '[8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:25');
INSERT INTO `operation_log` VALUES (3194, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:25');
INSERT INTO `operation_log` VALUES (3195, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:32');
INSERT INTO `operation_log` VALUES (3196, 1, 'admin', '其他', 'GET', 'GET /permission/role/6', '[6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:46');
INSERT INTO `operation_log` VALUES (3197, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:46');
INSERT INTO `operation_log` VALUES (3198, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:54');
INSERT INTO `operation_log` VALUES (3199, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:59');
INSERT INTO `operation_log` VALUES (3200, 1, 'admin', '其他', 'GET', 'GET /permission/role/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:33:59');
INSERT INTO `operation_log` VALUES (3201, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:03');
INSERT INTO `operation_log` VALUES (3202, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:05');
INSERT INTO `operation_log` VALUES (3203, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:05');
INSERT INTO `operation_log` VALUES (3204, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6fc4f13d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:17');
INSERT INTO `operation_log` VALUES (3205, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:17');
INSERT INTO `operation_log` VALUES (3206, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:19');
INSERT INTO `operation_log` VALUES (3207, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[2,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:34');
INSERT INTO `operation_log` VALUES (3208, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:40');
INSERT INTO `operation_log` VALUES (3209, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:34:44');
INSERT INTO `operation_log` VALUES (3210, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@776f352e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:35:17');
INSERT INTO `operation_log` VALUES (3211, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:35:17');
INSERT INTO `operation_log` VALUES (3212, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:35:19');
INSERT INTO `operation_log` VALUES (3213, 1, 'admin', '其他', 'GET', 'GET /permission/role/1', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:35:50');
INSERT INTO `operation_log` VALUES (3214, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:35:50');
INSERT INTO `operation_log` VALUES (3215, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7a30b5fc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:36:17');
INSERT INTO `operation_log` VALUES (3216, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4760d5a7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:37:17');
INSERT INTO `operation_log` VALUES (3217, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:04');
INSERT INTO `operation_log` VALUES (3218, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:10');
INSERT INTO `operation_log` VALUES (3219, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:11');
INSERT INTO `operation_log` VALUES (3220, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:15');
INSERT INTO `operation_log` VALUES (3221, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6d969eeb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:17');
INSERT INTO `operation_log` VALUES (3222, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:18');
INSERT INTO `operation_log` VALUES (3223, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:19');
INSERT INTO `operation_log` VALUES (3224, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:23');
INSERT INTO `operation_log` VALUES (3225, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:23');
INSERT INTO `operation_log` VALUES (3226, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:23');
INSERT INTO `operation_log` VALUES (3227, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:25');
INSERT INTO `operation_log` VALUES (3228, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:25');
INSERT INTO `operation_log` VALUES (3229, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:30');
INSERT INTO `operation_log` VALUES (3230, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:30');
INSERT INTO `operation_log` VALUES (3231, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:30');
INSERT INTO `operation_log` VALUES (3232, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:33');
INSERT INTO `operation_log` VALUES (3233, 1, 'admin', '采购', 'GET', 'GET /purchase/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@59312871]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:39');
INSERT INTO `operation_log` VALUES (3234, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@36758f10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:38:51');
INSERT INTO `operation_log` VALUES (3235, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@7b63e5a7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:39:03');
INSERT INTO `operation_log` VALUES (3236, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7783f331]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:39:17');
INSERT INTO `operation_log` VALUES (3237, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:39:23');
INSERT INTO `operation_log` VALUES (3238, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6ea3bef]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:40:17');
INSERT INTO `operation_log` VALUES (3239, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@36187747]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:41:18');
INSERT INTO `operation_log` VALUES (3240, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@f434797]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:42:19');
INSERT INTO `operation_log` VALUES (3241, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@63c50b8e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:43:20');
INSERT INTO `operation_log` VALUES (3242, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@102ec615]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:44:21');
INSERT INTO `operation_log` VALUES (3243, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3dd0ac33]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:45:22');
INSERT INTO `operation_log` VALUES (3244, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@577f77df]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:46:23');
INSERT INTO `operation_log` VALUES (3245, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@205ce12]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:47:24');
INSERT INTO `operation_log` VALUES (3246, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b29c2b3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:48:25');
INSERT INTO `operation_log` VALUES (3247, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2489cc68]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:49:26');
INSERT INTO `operation_log` VALUES (3248, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@201fd2f3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:50:27');
INSERT INTO `operation_log` VALUES (3249, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@667e784c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:51:28');
INSERT INTO `operation_log` VALUES (3250, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4f6f9f3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:52:29');
INSERT INTO `operation_log` VALUES (3251, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5884217e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 00:53:30');
INSERT INTO `operation_log` VALUES (3252, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:25');
INSERT INTO `operation_log` VALUES (3253, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3924fa21]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:26');
INSERT INTO `operation_log` VALUES (3254, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:26');
INSERT INTO `operation_log` VALUES (3255, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:26');
INSERT INTO `operation_log` VALUES (3256, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:28');
INSERT INTO `operation_log` VALUES (3257, 1, 'admin', '其他', 'GET', 'GET /permission/role/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:30');
INSERT INTO `operation_log` VALUES (3258, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,9999,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:30');
INSERT INTO `operation_log` VALUES (3259, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:35');
INSERT INTO `operation_log` VALUES (3260, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:56');
INSERT INTO `operation_log` VALUES (3261, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:35:56');
INSERT INTO `operation_log` VALUES (3262, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6c4d187]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:36:26');
INSERT INTO `operation_log` VALUES (3263, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@e51cdd5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:37:26');
INSERT INTO `operation_log` VALUES (3264, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@37338529]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:38:26');
INSERT INTO `operation_log` VALUES (3265, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@522b99db]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:39:26');
INSERT INTO `operation_log` VALUES (3266, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4921ee7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:40:26');
INSERT INTO `operation_log` VALUES (3267, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4170f5b0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:41:26');
INSERT INTO `operation_log` VALUES (3268, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39d2ad6f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:42:31');
INSERT INTO `operation_log` VALUES (3269, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@71b76f23]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:13');
INSERT INTO `operation_log` VALUES (3270, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2e890579]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:15');
INSERT INTO `operation_log` VALUES (3271, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:15');
INSERT INTO `operation_log` VALUES (3272, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:15');
INSERT INTO `operation_log` VALUES (3273, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:18');
INSERT INTO `operation_log` VALUES (3274, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:18');
INSERT INTO `operation_log` VALUES (3275, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:18');
INSERT INTO `operation_log` VALUES (3276, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@17a4b6e2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:56:25');
INSERT INTO `operation_log` VALUES (3277, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:57:21');
INSERT INTO `operation_log` VALUES (3278, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:57:22');
INSERT INTO `operation_log` VALUES (3279, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@16cc141c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:57:22');
INSERT INTO `operation_log` VALUES (3280, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:57:22');
INSERT INTO `operation_log` VALUES (3281, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@43d1007]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:58:22');
INSERT INTO `operation_log` VALUES (3282, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6125b549]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 17:59:22');
INSERT INTO `operation_log` VALUES (3283, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7c096067]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:00:22');
INSERT INTO `operation_log` VALUES (3284, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2bc6ffb2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:01:22');
INSERT INTO `operation_log` VALUES (3285, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6b43add5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:02:22');
INSERT INTO `operation_log` VALUES (3286, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7a89842c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:03:22');
INSERT INTO `operation_log` VALUES (3287, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1111ba3d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:04:26');
INSERT INTO `operation_log` VALUES (3288, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@733c764f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:05:22');
INSERT INTO `operation_log` VALUES (3289, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:14');
INSERT INTO `operation_log` VALUES (3290, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:15');
INSERT INTO `operation_log` VALUES (3291, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:15');
INSERT INTO `operation_log` VALUES (3292, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:15');
INSERT INTO `operation_log` VALUES (3293, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@77f3e4c1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:18');
INSERT INTO `operation_log` VALUES (3294, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@7b38776d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:20');
INSERT INTO `operation_log` VALUES (3295, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@55718d71]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:06:22');
INSERT INTO `operation_log` VALUES (3296, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@27f5bfca]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:07:22');
INSERT INTO `operation_log` VALUES (3297, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@517bc52a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:08:23');
INSERT INTO `operation_log` VALUES (3298, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2b603694]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:09:24');
INSERT INTO `operation_log` VALUES (3299, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@199940c0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:10:25');
INSERT INTO `operation_log` VALUES (3300, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@63758f71]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:11:26');
INSERT INTO `operation_log` VALUES (3301, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@19c288c6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:12:27');
INSERT INTO `operation_log` VALUES (3302, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@1a8d4313]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:12:56');
INSERT INTO `operation_log` VALUES (3303, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2d71dc3c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:13:22');
INSERT INTO `operation_log` VALUES (3304, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@79377917]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:14:22');
INSERT INTO `operation_log` VALUES (3305, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@24fb7baa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:15:31');
INSERT INTO `operation_log` VALUES (3306, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:15:56');
INSERT INTO `operation_log` VALUES (3307, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:15:56');
INSERT INTO `operation_log` VALUES (3308, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:15:56');
INSERT INTO `operation_log` VALUES (3309, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@28e0fc14]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:15:56');
INSERT INTO `operation_log` VALUES (3310, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:15');
INSERT INTO `operation_log` VALUES (3311, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:15');
INSERT INTO `operation_log` VALUES (3312, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:15');
INSERT INTO `operation_log` VALUES (3313, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@48f2b13d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:15');
INSERT INTO `operation_log` VALUES (3314, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@19fc2198]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:47');
INSERT INTO `operation_log` VALUES (3315, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:47');
INSERT INTO `operation_log` VALUES (3316, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:47');
INSERT INTO `operation_log` VALUES (3317, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:47');
INSERT INTO `operation_log` VALUES (3318, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@1f22e0d9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:16:54');
INSERT INTO `operation_log` VALUES (3319, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@74467a72]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:17:47');
INSERT INTO `operation_log` VALUES (3320, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6cf5fa37]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:18:47');
INSERT INTO `operation_log` VALUES (3321, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@d6346a9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:19:47');
INSERT INTO `operation_log` VALUES (3322, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@249eb66a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:20:47');
INSERT INTO `operation_log` VALUES (3323, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@132b6dac]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:21:47');
INSERT INTO `operation_log` VALUES (3324, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:09');
INSERT INTO `operation_log` VALUES (3325, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@e370f52]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:13');
INSERT INTO `operation_log` VALUES (3326, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:13');
INSERT INTO `operation_log` VALUES (3327, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:32');
INSERT INTO `operation_log` VALUES (3328, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:32');
INSERT INTO `operation_log` VALUES (3329, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:32');
INSERT INTO `operation_log` VALUES (3330, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@651c3076]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:22:36');
INSERT INTO `operation_log` VALUES (3331, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6e50b6b8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:23:13');
INSERT INTO `operation_log` VALUES (3332, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@f002a27]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:24:13');
INSERT INTO `operation_log` VALUES (3333, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5b978bb0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:25:13');
INSERT INTO `operation_log` VALUES (3334, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:25:44');
INSERT INTO `operation_log` VALUES (3335, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4233fce7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:25:44');
INSERT INTO `operation_log` VALUES (3336, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:25:44');
INSERT INTO `operation_log` VALUES (3337, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:25:44');
INSERT INTO `operation_log` VALUES (3338, 1, 'admin', '采购', 'GET', 'GET /purchase/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@21d6ddfe]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:25:48');
INSERT INTO `operation_log` VALUES (3339, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@41b6bf70]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:26:44');
INSERT INTO `operation_log` VALUES (3340, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@281e3ab]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:27:44');
INSERT INTO `operation_log` VALUES (3341, 1, 'admin', '采购', 'POST', 'POST /purchase/import', '[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@512e563, 1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:28:28');
INSERT INTO `operation_log` VALUES (3342, 1, 'admin', '采购', 'GET', 'GET /purchase/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:28:29');
INSERT INTO `operation_log` VALUES (3343, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@70a3286f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:28:44');
INSERT INTO `operation_log` VALUES (3344, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@ec3ff74]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:29:44');
INSERT INTO `operation_log` VALUES (3345, 1, 'admin', '采购', '采购入库', 'POST /purchase/stock-in/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:29:59');
INSERT INTO `operation_log` VALUES (3346, 1, 'admin', '采购', 'GET', 'GET /purchase/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:29:59');
INSERT INTO `operation_log` VALUES (3347, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@74899559]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:30:44');
INSERT INTO `operation_log` VALUES (3348, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3817b042]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:31:44');
INSERT INTO `operation_log` VALUES (3349, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@73183091]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:33:05');
INSERT INTO `operation_log` VALUES (3350, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:33:07');
INSERT INTO `operation_log` VALUES (3351, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:33:07');
INSERT INTO `operation_log` VALUES (3352, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1b86199]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:33:07');
INSERT INTO `operation_log` VALUES (3353, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:33:07');
INSERT INTO `operation_log` VALUES (3354, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:00');
INSERT INTO `operation_log` VALUES (3355, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:00');
INSERT INTO `operation_log` VALUES (3356, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:00');
INSERT INTO `operation_log` VALUES (3357, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:00');
INSERT INTO `operation_log` VALUES (3358, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1834327c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:07');
INSERT INTO `operation_log` VALUES (3359, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:12');
INSERT INTO `operation_log` VALUES (3360, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:12');
INSERT INTO `operation_log` VALUES (3361, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:12');
INSERT INTO `operation_log` VALUES (3362, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:16');
INSERT INTO `operation_log` VALUES (3363, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:19');
INSERT INTO `operation_log` VALUES (3364, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:24');
INSERT INTO `operation_log` VALUES (3365, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:24');
INSERT INTO `operation_log` VALUES (3366, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:24');
INSERT INTO `operation_log` VALUES (3367, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:24');
INSERT INTO `operation_log` VALUES (3368, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:26');
INSERT INTO `operation_log` VALUES (3369, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:31');
INSERT INTO `operation_log` VALUES (3370, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:31');
INSERT INTO `operation_log` VALUES (3371, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5843c796]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:31');
INSERT INTO `operation_log` VALUES (3372, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:31');
INSERT INTO `operation_log` VALUES (3373, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:34:32');
INSERT INTO `operation_log` VALUES (3374, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@af00726]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:35:32');
INSERT INTO `operation_log` VALUES (3375, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@481caaf4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:36:32');
INSERT INTO `operation_log` VALUES (3376, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@612665ee]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:37:32');
INSERT INTO `operation_log` VALUES (3377, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1e8f1b09]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:38:32');
INSERT INTO `operation_log` VALUES (3378, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7d14f6a5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:39:32');
INSERT INTO `operation_log` VALUES (3379, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2834ec49]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:40:32');
INSERT INTO `operation_log` VALUES (3380, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5b2601d1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:42:10');
INSERT INTO `operation_log` VALUES (3381, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5196ef2d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 18:44:09');
INSERT INTO `operation_log` VALUES (3382, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:41');
INSERT INTO `operation_log` VALUES (3383, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:41');
INSERT INTO `operation_log` VALUES (3384, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:40');
INSERT INTO `operation_log` VALUES (3385, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@23d82753]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:42');
INSERT INTO `operation_log` VALUES (3386, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:43');
INSERT INTO `operation_log` VALUES (3387, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:58');
INSERT INTO `operation_log` VALUES (3388, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5cc9ebb0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:59');
INSERT INTO `operation_log` VALUES (3389, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:59');
INSERT INTO `operation_log` VALUES (3390, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:19:59');
INSERT INTO `operation_log` VALUES (3391, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:20:03');
INSERT INTO `operation_log` VALUES (3392, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:20:03');
INSERT INTO `operation_log` VALUES (3393, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:20:03');
INSERT INTO `operation_log` VALUES (3394, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:20:04');
INSERT INTO `operation_log` VALUES (3395, 1, 'admin', '销售', 'GET', 'GET /sales/import-template', '[org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@46cfcf46]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:20:08');
INSERT INTO `operation_log` VALUES (3396, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@136ab60c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:20:59');
INSERT INTO `operation_log` VALUES (3397, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@15ea5f0c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:21:59');
INSERT INTO `operation_log` VALUES (3398, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2fcd2c2a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:22:59');
INSERT INTO `operation_log` VALUES (3399, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:21');
INSERT INTO `operation_log` VALUES (3400, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:21');
INSERT INTO `operation_log` VALUES (3401, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:21');
INSERT INTO `operation_log` VALUES (3402, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:21');
INSERT INTO `operation_log` VALUES (3403, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:23');
INSERT INTO `operation_log` VALUES (3404, 1, 'admin', '销售', 'GET', 'GET /sales/detail/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:27');
INSERT INTO `operation_log` VALUES (3405, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@46aff6a6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:23:59');
INSERT INTO `operation_log` VALUES (3406, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4acb3942]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:24:59');
INSERT INTO `operation_log` VALUES (3407, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@47a4b127]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:25:59');
INSERT INTO `operation_log` VALUES (3408, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5ff851f5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:27:31');
INSERT INTO `operation_log` VALUES (3409, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@765c631b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:28:31');
INSERT INTO `operation_log` VALUES (3410, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3eb4d9f8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:29:31');
INSERT INTO `operation_log` VALUES (3411, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@27ce5d72]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:30:31');
INSERT INTO `operation_log` VALUES (3412, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@224569c4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 19:31:31');
INSERT INTO `operation_log` VALUES (3413, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5c3cd001]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:35');
INSERT INTO `operation_log` VALUES (3414, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7970c241]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:37');
INSERT INTO `operation_log` VALUES (3415, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:37');
INSERT INTO `operation_log` VALUES (3416, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:37');
INSERT INTO `operation_log` VALUES (3417, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:37');
INSERT INTO `operation_log` VALUES (3418, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:37');
INSERT INTO `operation_log` VALUES (3419, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:46');
INSERT INTO `operation_log` VALUES (3420, 1, 'admin', '销售', 'GET', 'GET /sales/detail/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:49');
INSERT INTO `operation_log` VALUES (3421, 1, 'admin', '销售', 'GET', 'GET /sales/export', '[null, null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@4895a618]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:20:53');
INSERT INTO `operation_log` VALUES (3422, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:21:05');
INSERT INTO `operation_log` VALUES (3423, 1, 'admin', '供应商', '新增', 'POST /supplier/add', '[{\"id\":null,\"supplierName\":\"测试供应商1\",\"contactPerson\":\"\",\"phone\":\"\",\"email\":\"\",\"address\":\"\",\"level\":\"普通\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 0, '\r\n### Error updating database.  Cause: org.apache.ibatis.reflection.ReflectionException: There is no getter for property named \'bankName\' in \'class com.example.erpsystem.entity.Supplier\'\r\n### The error may exist in file [D:\\projects\\erp\\erp-system\\target\\classes\\mapper\\SupplierMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO supplier (supplier_name, contact_person, phone, email, address, bank_name, bank_account, tax', '2026-08-16 20:21:34');
INSERT INTO `operation_log` VALUES (3424, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3c0c61b0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:21:36');
INSERT INTO `operation_log` VALUES (3425, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@e96b762]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:22:37');
INSERT INTO `operation_log` VALUES (3426, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@31a68fc2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:23:37');
INSERT INTO `operation_log` VALUES (3427, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2abfa210]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:24:37');
INSERT INTO `operation_log` VALUES (3428, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39e61155]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:25:37');
INSERT INTO `operation_log` VALUES (3429, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5f688b03]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:26:37');
INSERT INTO `operation_log` VALUES (3430, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6ac42412]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:28:09');
INSERT INTO `operation_log` VALUES (3431, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@35506a69]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:29:10');
INSERT INTO `operation_log` VALUES (3432, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@12624a14]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:30:11');
INSERT INTO `operation_log` VALUES (3433, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@615057f8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:31:12');
INSERT INTO `operation_log` VALUES (3434, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4e6a3d77]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:32:13');
INSERT INTO `operation_log` VALUES (3435, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1cbaa93f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:33:14');
INSERT INTO `operation_log` VALUES (3436, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@13008321]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:34:15');
INSERT INTO `operation_log` VALUES (3437, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7dfcde6a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:35:16');
INSERT INTO `operation_log` VALUES (3438, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@66f7eebb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:36:17');
INSERT INTO `operation_log` VALUES (3439, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:36:26');
INSERT INTO `operation_log` VALUES (3440, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:36:26');
INSERT INTO `operation_log` VALUES (3441, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@66ed64e3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:36:36');
INSERT INTO `operation_log` VALUES (3442, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:37:29');
INSERT INTO `operation_log` VALUES (3443, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@74b3a3c8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:37:30');
INSERT INTO `operation_log` VALUES (3444, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:37:30');
INSERT INTO `operation_log` VALUES (3445, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:37:30');
INSERT INTO `operation_log` VALUES (3446, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:37:31');
INSERT INTO `operation_log` VALUES (3447, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:37:32');
INSERT INTO `operation_log` VALUES (3448, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6aeb9c61]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:38:30');
INSERT INTO `operation_log` VALUES (3449, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@34a8dd8f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:39:30');
INSERT INTO `operation_log` VALUES (3450, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6cad3ea3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:40:30');
INSERT INTO `operation_log` VALUES (3451, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:40:54');
INSERT INTO `operation_log` VALUES (3452, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@40f63f86]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:41:30');
INSERT INTO `operation_log` VALUES (3453, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@54e44b24]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:42:30');
INSERT INTO `operation_log` VALUES (3454, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:42:56');
INSERT INTO `operation_log` VALUES (3455, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3adfa252]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:43:30');
INSERT INTO `operation_log` VALUES (3456, 1, 'admin', '其他', '新增', 'POST /permission/add', '[{\"id\":78,\"permissionName\":\"测试权限1\",\"permissionCode\":\"PERMISSION_TEST\",\"apiPath\":\"/permission/test\",\"apiMethod\":\"GET\",\"description\":\"\",\"status\":1,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:43:52');
INSERT INTO `operation_log` VALUES (3457, 1, 'admin', '其他', 'GET', 'GET /permission/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:43:52');
INSERT INTO `operation_log` VALUES (3458, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:44:01');
INSERT INTO `operation_log` VALUES (3459, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:44:04');
INSERT INTO `operation_log` VALUES (3460, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@15a3ce63]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:44:30');
INSERT INTO `operation_log` VALUES (3461, 1, 'unknown', '其他', '新增', 'POST /product/add', '[{\"id\":2,\"skuCode\":\"SKU1786884291265\",\"productName\":\"测试商品1\",\"mnemonicCode\":\"测试商品1\",\"categoryId\":null,\"spec\":\"1\",\"model\":null,\"unit\":\"台\",\"barcode\":null,\"costPrice\":10,\"salePrice\":20,\"minStock\":1,\"maxStock\":null,\"supplierId\":null,\"shelfLife\":null,\"storageLocation\":null,\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:44:51');
INSERT INTO `operation_log` VALUES (3462, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:44:51');
INSERT INTO `operation_log` VALUES (3463, 1, 'unknown', '其他', '修改', 'PUT /product/update', '[Product(id=2, skuCode=SKU1786884291265, productName=测试商品1, mnemonicCode=测试商品1, categoryId=null, spec=1KG, model=null, unit=台, barcode=null, costPrice=10, salePrice=20, minStock=1, maxStock=null, supplierId=null, shelfLife=null, storageLocation=null, status=1, remark=null, createdAt=2026-08-16T20:44:51, updatedAt=2026-08-16T20:44:51)]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:10');
INSERT INTO `operation_log` VALUES (3464, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:11');
INSERT INTO `operation_log` VALUES (3465, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:14');
INSERT INTO `operation_log` VALUES (3466, 1, 'admin', '客户', '新增', 'POST /customer/add', '[{\"id\":2,\"customerName\":\"测试客户1\",\"contactPerson\":\"\",\"phone\":\"\",\"email\":\"\",\"address\":\"\",\"level\":\"普通\",\"creditLimit\":null,\"initialReceivable\":null,\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:23');
INSERT INTO `operation_log` VALUES (3467, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:23');
INSERT INTO `operation_log` VALUES (3468, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:26');
INSERT INTO `operation_log` VALUES (3469, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:29');
INSERT INTO `operation_log` VALUES (3470, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:29');
INSERT INTO `operation_log` VALUES (3471, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:29');
INSERT INTO `operation_log` VALUES (3472, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1d2bd41b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:30');
INSERT INTO `operation_log` VALUES (3473, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:33');
INSERT INTO `operation_log` VALUES (3474, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:33');
INSERT INTO `operation_log` VALUES (3475, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:33');
INSERT INTO `operation_log` VALUES (3476, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:33');
INSERT INTO `operation_log` VALUES (3477, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:38');
INSERT INTO `operation_log` VALUES (3478, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:38');
INSERT INTO `operation_log` VALUES (3479, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:45:38');
INSERT INTO `operation_log` VALUES (3480, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@363777f0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:46:30');
INSERT INTO `operation_log` VALUES (3481, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c08160f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:47:30');
INSERT INTO `operation_log` VALUES (3482, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7b4e846d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:48:31');
INSERT INTO `operation_log` VALUES (3483, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@226e3b36]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:49:31');
INSERT INTO `operation_log` VALUES (3484, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@41379568]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:50:31');
INSERT INTO `operation_log` VALUES (3485, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@22950ebe]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:51:31');
INSERT INTO `operation_log` VALUES (3486, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2f9713d5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:52:31');
INSERT INTO `operation_log` VALUES (3487, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3eef0cda]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:53:31');
INSERT INTO `operation_log` VALUES (3488, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@55ef6f1b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 20:54:31');
INSERT INTO `operation_log` VALUES (3489, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7224c1c4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:32');
INSERT INTO `operation_log` VALUES (3490, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:35');
INSERT INTO `operation_log` VALUES (3491, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5a02d383]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:35');
INSERT INTO `operation_log` VALUES (3492, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:35');
INSERT INTO `operation_log` VALUES (3493, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:35');
INSERT INTO `operation_log` VALUES (3494, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:37');
INSERT INTO `operation_log` VALUES (3495, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:11:37');
INSERT INTO `operation_log` VALUES (3496, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@69cef3b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:12:35');
INSERT INTO `operation_log` VALUES (3497, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2e890579]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:13:35');
INSERT INTO `operation_log` VALUES (3498, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7a9bbf1d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:14:35');
INSERT INTO `operation_log` VALUES (3499, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@79714ef1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:15:35');
INSERT INTO `operation_log` VALUES (3500, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@649e700b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:16:35');
INSERT INTO `operation_log` VALUES (3501, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@27b15d9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:17:35');
INSERT INTO `operation_log` VALUES (3502, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@77a0e25c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:19:08');
INSERT INTO `operation_log` VALUES (3503, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@655a5165]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:20:09');
INSERT INTO `operation_log` VALUES (3504, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@324afa96]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:21:10');
INSERT INTO `operation_log` VALUES (3505, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@38498057]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:22:11');
INSERT INTO `operation_log` VALUES (3506, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@55a455ac]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:23:12');
INSERT INTO `operation_log` VALUES (3507, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5f21656]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:24:13');
INSERT INTO `operation_log` VALUES (3508, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5f73c30b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:25:14');
INSERT INTO `operation_log` VALUES (3509, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@cf371db]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:26:15');
INSERT INTO `operation_log` VALUES (3510, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:18');
INSERT INTO `operation_log` VALUES (3511, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@11405e53]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:20');
INSERT INTO `operation_log` VALUES (3512, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@694410e7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:20');
INSERT INTO `operation_log` VALUES (3513, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:20');
INSERT INTO `operation_log` VALUES (3514, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:24');
INSERT INTO `operation_log` VALUES (3515, 1, 'admin', '供应商', '新增', 'POST /supplier/add', '[{\"id\":2,\"supplierName\":\"测试供应商1\",\"contactPerson\":\"\",\"phone\":\"\",\"email\":\"\",\"address\":\"\",\"level\":\"普通\",\"status\":1,\"remark\":null,\"createdAt\":null,\"updatedAt\":null,\"bankName\":null,\"bankAccount\":null,\"taxNumber\":null,\"initialPayable\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:34');
INSERT INTO `operation_log` VALUES (3516, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:28:34');
INSERT INTO `operation_log` VALUES (3517, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5a675b7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:29:19');
INSERT INTO `operation_log` VALUES (3518, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@192d174]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:30:19');
INSERT INTO `operation_log` VALUES (3519, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:30:41');
INSERT INTO `operation_log` VALUES (3520, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:30:42');
INSERT INTO `operation_log` VALUES (3521, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3a872691]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:31:18');
INSERT INTO `operation_log` VALUES (3522, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@792df37c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:32:19');
INSERT INTO `operation_log` VALUES (3523, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@718ecbba]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:33:19');
INSERT INTO `operation_log` VALUES (3524, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7b76c581]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:34:19');
INSERT INTO `operation_log` VALUES (3525, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6bcef4d8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:35:31');
INSERT INTO `operation_log` VALUES (3526, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@208b0428]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:36:18');
INSERT INTO `operation_log` VALUES (3527, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:36:19');
INSERT INTO `operation_log` VALUES (3528, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:36:19');
INSERT INTO `operation_log` VALUES (3529, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@273128bd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:37:19');
INSERT INTO `operation_log` VALUES (3530, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@740c8141]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:38:31');
INSERT INTO `operation_log` VALUES (3531, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:39:55');
INSERT INTO `operation_log` VALUES (3532, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@789ea274]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:39:56');
INSERT INTO `operation_log` VALUES (3533, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:39:57');
INSERT INTO `operation_log` VALUES (3534, 1, 'admin', '其他', 'GET', 'GET /user/info', '[org.apache.catalina.connector.RequestFacade@2fc47aa2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:40:05');
INSERT INTO `operation_log` VALUES (3535, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:40:06');
INSERT INTO `operation_log` VALUES (3536, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:40:07');
INSERT INTO `operation_log` VALUES (3537, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:40:33');
INSERT INTO `operation_log` VALUES (3538, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@b43a86c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:40:33');
INSERT INTO `operation_log` VALUES (3539, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:40:33');
INSERT INTO `operation_log` VALUES (3540, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@78f3f57a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:41:33');
INSERT INTO `operation_log` VALUES (3541, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:42:24');
INSERT INTO `operation_log` VALUES (3542, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@337f6612]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:42:24');
INSERT INTO `operation_log` VALUES (3543, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:42:24');
INSERT INTO `operation_log` VALUES (3544, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:42:26');
INSERT INTO `operation_log` VALUES (3545, 1, 'admin', '其他', '新增', 'POST /role/add', '[{\"id\":9,\"roleName\":\"角色测试1\",\"roleCode\":\"ROLE_TEST1\",\"description\":\"测试\",\"status\":1,\"createdAt\":null,\"updatedAt\":null}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:15');
INSERT INTO `operation_log` VALUES (3546, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:15');
INSERT INTO `operation_log` VALUES (3547, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,10,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:23');
INSERT INTO `operation_log` VALUES (3548, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39f3bf96]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:23');
INSERT INTO `operation_log` VALUES (3549, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:26');
INSERT INTO `operation_log` VALUES (3550, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:27');
INSERT INTO `operation_log` VALUES (3551, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:27');
INSERT INTO `operation_log` VALUES (3552, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:43:27');
INSERT INTO `operation_log` VALUES (3553, 1, 'admin', '采购', '新增', 'POST /purchase/create', '[com.example.erpsystem.controller.PurchaseController$CreatePurchaseRequest@55f9e248]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:45:11');
INSERT INTO `operation_log` VALUES (3554, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:45:19');
INSERT INTO `operation_log` VALUES (3555, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:45:23');
INSERT INTO `operation_log` VALUES (3556, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2b398b5a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:45:23');
INSERT INTO `operation_log` VALUES (3557, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@59e584a4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:46:23');
INSERT INTO `operation_log` VALUES (3558, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:46:27');
INSERT INTO `operation_log` VALUES (3559, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:46:35');
INSERT INTO `operation_log` VALUES (3560, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39d5b81]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:47:24');
INSERT INTO `operation_log` VALUES (3561, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5169df82]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:48:24');
INSERT INTO `operation_log` VALUES (3562, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@29562de6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:49:31');
INSERT INTO `operation_log` VALUES (3563, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@521c9f24]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:23');
INSERT INTO `operation_log` VALUES (3564, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:25');
INSERT INTO `operation_log` VALUES (3565, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@10890551]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:25');
INSERT INTO `operation_log` VALUES (3566, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:25');
INSERT INTO `operation_log` VALUES (3567, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:25');
INSERT INTO `operation_log` VALUES (3568, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:29');
INSERT INTO `operation_log` VALUES (3569, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:32');
INSERT INTO `operation_log` VALUES (3570, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:32');
INSERT INTO `operation_log` VALUES (3571, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:32');
INSERT INTO `operation_log` VALUES (3572, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:40');
INSERT INTO `operation_log` VALUES (3573, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:52:47');
INSERT INTO `operation_log` VALUES (3574, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6718be92]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:53:25');
INSERT INTO `operation_log` VALUES (3575, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@298c26f7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:54:25');
INSERT INTO `operation_log` VALUES (3576, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:54:37');
INSERT INTO `operation_log` VALUES (3577, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:54:37');
INSERT INTO `operation_log` VALUES (3578, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:54:37');
INSERT INTO `operation_log` VALUES (3579, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:54:37');
INSERT INTO `operation_log` VALUES (3580, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:54:43');
INSERT INTO `operation_log` VALUES (3581, 1, 'admin', '销售', '新增', 'POST /sales/create', '[com.example.erpsystem.controller.SalesController$CreateSalesRequest@7c946009]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:06');
INSERT INTO `operation_log` VALUES (3582, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:11');
INSERT INTO `operation_log` VALUES (3583, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@71e85239]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:25');
INSERT INTO `operation_log` VALUES (3584, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:47');
INSERT INTO `operation_log` VALUES (3585, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:47');
INSERT INTO `operation_log` VALUES (3586, 1, 'admin', '库存', 'GET', 'GET /inventory/list', '[1,10,1,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:57');
INSERT INTO `operation_log` VALUES (3587, 1, 'admin', '库存', 'GET', 'GET /inventory/export-for-check', '[1, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@e83405b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:55:58');
INSERT INTO `operation_log` VALUES (3588, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5e42d350]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:56:25');
INSERT INTO `operation_log` VALUES (3589, 1, 'admin', '库存', 'GET', 'GET /inventory/export-for-check', '[1, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@59983878]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:57:09');
INSERT INTO `operation_log` VALUES (3590, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@28e2a11d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:57:25');
INSERT INTO `operation_log` VALUES (3591, 1, 'admin', '库存', 'GET', 'GET /inventory/flow-export', '[null, null, null, 1, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@16efdb55]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:58:12');
INSERT INTO `operation_log` VALUES (3592, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@47bfe1c1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:58:25');
INSERT INTO `operation_log` VALUES (3593, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:58:52');
INSERT INTO `operation_log` VALUES (3594, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:58:52');
INSERT INTO `operation_log` VALUES (3595, 1, 'admin', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:58:53');
INSERT INTO `operation_log` VALUES (3596, 1, 'admin', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@7d7cfacb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:59:11');
INSERT INTO `operation_log` VALUES (3597, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@c8c1175]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:59:25');
INSERT INTO `operation_log` VALUES (3598, 1, 'admin', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=null, formNo=EXP202608160001, applicantId=1, deptId=2, applyDate=2026-08-16, totalAmount=6000, reason=测试1, currentApproverId=null, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=null, expenseTypeId=1, expenseDate=2026-08-16, amount=6000, invoiceCount=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@7dd91d58], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@2116329c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:59:45');
INSERT INTO `operation_log` VALUES (3599, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[2026-07-17, 2026-08-16, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:59:55');
INSERT INTO `operation_log` VALUES (3600, 1, 'admin', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:59:55');
INSERT INTO `operation_log` VALUES (3601, 1, 'admin', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-17, 2026-08-16, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 21:59:55');
INSERT INTO `operation_log` VALUES (3602, 1, 'admin', '销售', 'GET', 'GET /report/export/sales-daily', '[null, null, null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@17c69408]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:00:00');
INSERT INTO `operation_log` VALUES (3603, 1, 'admin', '其他', 'GET', 'GET /report/export/product-rank', '[null, null, null, 20, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@2d13eea7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:00:03');
INSERT INTO `operation_log` VALUES (3604, 1, 'admin', '库存', 'GET', 'GET /report/export/inventory-analysis', '[null, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@449b9aca]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:00:06');
INSERT INTO `operation_log` VALUES (3605, 1, 'admin', '其他', 'GET', 'GET /operation-log/list', '[1,20,\"\",\"\",\"\",\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:00:09');
INSERT INTO `operation_log` VALUES (3606, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@70ade661]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:00:25');
INSERT INTO `operation_log` VALUES (3607, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3a2fa22e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:01:26');
INSERT INTO `operation_log` VALUES (3608, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@621c182a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:02:25');
INSERT INTO `operation_log` VALUES (3609, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:02:53');
INSERT INTO `operation_log` VALUES (3610, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:02:53');
INSERT INTO `operation_log` VALUES (3611, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6e113252]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:03:25');
INSERT INTO `operation_log` VALUES (3612, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@599d6d8b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:04:25');
INSERT INTO `operation_log` VALUES (3613, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@21bd1d7a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:05:25');
INSERT INTO `operation_log` VALUES (3614, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@49586e26]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:06:25');
INSERT INTO `operation_log` VALUES (3615, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@96a306f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:07:25');
INSERT INTO `operation_log` VALUES (3616, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42abe770]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:08:25');
INSERT INTO `operation_log` VALUES (3617, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@776042a4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:09:26');
INSERT INTO `operation_log` VALUES (3618, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@55099eee]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:10:27');
INSERT INTO `operation_log` VALUES (3619, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7911a563]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:39');
INSERT INTO `operation_log` VALUES (3620, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c468452]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:41');
INSERT INTO `operation_log` VALUES (3621, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:41');
INSERT INTO `operation_log` VALUES (3622, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:42');
INSERT INTO `operation_log` VALUES (3623, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"inventory\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:52');
INSERT INTO `operation_log` VALUES (3624, 6, 'inventory', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@b05cae5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:52');
INSERT INTO `operation_log` VALUES (3625, 6, 'inventory', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:52');
INSERT INTO `operation_log` VALUES (3626, 6, 'inventory', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:53');
INSERT INTO `operation_log` VALUES (3627, 6, 'inventory', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:55');
INSERT INTO `operation_log` VALUES (3628, 6, 'inventory', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:58');
INSERT INTO `operation_log` VALUES (3629, 6, 'inventory', '库存', 'GET', 'GET /inventory/list', '[1,10,null,\"\"]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:12:59');
INSERT INTO `operation_log` VALUES (3630, 6, 'inventory', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:03');
INSERT INTO `operation_log` VALUES (3631, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:03');
INSERT INTO `operation_log` VALUES (3632, 6, 'inventory', '盘点', 'GET', 'GET /stock-check/list', '[null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:03');
INSERT INTO `operation_log` VALUES (3633, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"gm\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:28');
INSERT INTO `operation_log` VALUES (3634, 8, 'gm', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:28');
INSERT INTO `operation_log` VALUES (3635, 8, 'gm', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4754e1dd]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:28');
INSERT INTO `operation_log` VALUES (3636, 8, 'gm', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:28');
INSERT INTO `operation_log` VALUES (3637, 8, 'gm', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@353ef21c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:31');
INSERT INTO `operation_log` VALUES (3638, 8, 'gm', '其他', 'GET', 'GET /report/product-rank', '[2026-07-17, 2026-08-16, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:36');
INSERT INTO `operation_log` VALUES (3639, 8, 'gm', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:36');
INSERT INTO `operation_log` VALUES (3640, 8, 'gm', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-17, 2026-08-16, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:36');
INSERT INTO `operation_log` VALUES (3641, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:53');
INSERT INTO `operation_log` VALUES (3642, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@77932426]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:53');
INSERT INTO `operation_log` VALUES (3643, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:53');
INSERT INTO `operation_log` VALUES (3644, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:13:53');
INSERT INTO `operation_log` VALUES (3645, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1590f2f7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:14:54');
INSERT INTO `operation_log` VALUES (3646, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@52484f25]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:15:54');
INSERT INTO `operation_log` VALUES (3647, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:00');
INSERT INTO `operation_log` VALUES (3648, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:00');
INSERT INTO `operation_log` VALUES (3649, 1, 'admin', '供应商', 'GET', 'GET /supplier/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:00');
INSERT INTO `operation_log` VALUES (3650, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:03');
INSERT INTO `operation_log` VALUES (3651, 1, 'admin', '采购', '采购入库', 'POST /purchase/stock-in/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:06');
INSERT INTO `operation_log` VALUES (3652, 1, 'admin', '采购', 'GET', 'GET /purchase/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:06');
INSERT INTO `operation_log` VALUES (3653, 1, 'admin', '采购', 'GET', 'GET /purchase/detail/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:08');
INSERT INTO `operation_log` VALUES (3654, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:13');
INSERT INTO `operation_log` VALUES (3655, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:13');
INSERT INTO `operation_log` VALUES (3656, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:13');
INSERT INTO `operation_log` VALUES (3657, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:13');
INSERT INTO `operation_log` VALUES (3658, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:15');
INSERT INTO `operation_log` VALUES (3659, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@46e02d5f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:16:54');
INSERT INTO `operation_log` VALUES (3660, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7c2e042a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:17:54');
INSERT INTO `operation_log` VALUES (3661, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2ab8d1f9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:18:54');
INSERT INTO `operation_log` VALUES (3662, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1fc1a305]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:19:54');
INSERT INTO `operation_log` VALUES (3663, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5bb3a580]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:31');
INSERT INTO `operation_log` VALUES (3664, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:44');
INSERT INTO `operation_log` VALUES (3665, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:44');
INSERT INTO `operation_log` VALUES (3666, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:44');
INSERT INTO `operation_log` VALUES (3667, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:44');
INSERT INTO `operation_log` VALUES (3668, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:47');
INSERT INTO `operation_log` VALUES (3669, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1a25ae8f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:21:53');
INSERT INTO `operation_log` VALUES (3670, 1, 'admin', '销售', 'GET', 'GET /sales/detail/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:22:43');
INSERT INTO `operation_log` VALUES (3671, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@14e36efb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:22:53');
INSERT INTO `operation_log` VALUES (3672, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7359da21]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:23:54');
INSERT INTO `operation_log` VALUES (3673, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:46');
INSERT INTO `operation_log` VALUES (3674, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:48');
INSERT INTO `operation_log` VALUES (3675, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:48');
INSERT INTO `operation_log` VALUES (3676, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:48');
INSERT INTO `operation_log` VALUES (3677, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:48');
INSERT INTO `operation_log` VALUES (3678, 1, 'admin', '客户', 'GET', 'GET /customer/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:53');
INSERT INTO `operation_log` VALUES (3679, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@31b037fb]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:53');
INSERT INTO `operation_log` VALUES (3680, 1, 'unknown', '其他', 'GET', 'GET /product/list', '[1,100,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:53');
INSERT INTO `operation_log` VALUES (3681, 1, 'admin', '其他', 'GET', 'GET /warehouse/list', '[null,1,100]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:53');
INSERT INTO `operation_log` VALUES (3682, 1, 'admin', '销售', 'GET', 'GET /sales/draft-list', '[1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:53');
INSERT INTO `operation_log` VALUES (3683, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:24:55');
INSERT INTO `operation_log` VALUES (3684, 1, 'admin', '销售', '销售出库', 'POST /sales/stock-out/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:25:03');
INSERT INTO `operation_log` VALUES (3685, 1, 'admin', '销售', 'GET', 'GET /sales/order/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:25:04');
INSERT INTO `operation_log` VALUES (3686, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@27e5e28a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:25:53');
INSERT INTO `operation_log` VALUES (3687, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@35b1a8de]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:26:53');
INSERT INTO `operation_log` VALUES (3688, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@21ae23de]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:27:53');
INSERT INTO `operation_log` VALUES (3689, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39c9f7ff]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:28:53');
INSERT INTO `operation_log` VALUES (3690, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:29:02');
INSERT INTO `operation_log` VALUES (3691, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5ccd9d3c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:29:02');
INSERT INTO `operation_log` VALUES (3692, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:29:02');
INSERT INTO `operation_log` VALUES (3693, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:29:02');
INSERT INTO `operation_log` VALUES (3694, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@115a954f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:29:04');
INSERT INTO `operation_log` VALUES (3695, 7, 'staff', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=null, formNo=EXP202608160001, applicantId=7, deptId=4, applyDate=2026-08-16, totalAmount=6000, reason=测试, currentApproverId=null, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=null, expenseTypeId=1, expenseDate=2026-08-16, amount=6000, invoiceCount=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@51143d18], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@735c13ea]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:29:29');
INSERT INTO `operation_log` VALUES (3696, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5f766b64]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:30:02');
INSERT INTO `operation_log` VALUES (3697, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@563a72db]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:31:02');
INSERT INTO `operation_log` VALUES (3698, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:13');
INSERT INTO `operation_log` VALUES (3699, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3414eeb8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:13');
INSERT INTO `operation_log` VALUES (3700, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:13');
INSERT INTO `operation_log` VALUES (3701, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:13');
INSERT INTO `operation_log` VALUES (3702, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:26');
INSERT INTO `operation_log` VALUES (3703, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:26');
INSERT INTO `operation_log` VALUES (3704, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:32');
INSERT INTO `operation_log` VALUES (3705, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:32:56');
INSERT INTO `operation_log` VALUES (3706, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@69a39bcf]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:33:13');
INSERT INTO `operation_log` VALUES (3707, 1, 'unknown', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":2,\"username\":\"manager\",\"password\":null,\"realName\":\"李四\",\"deptId\":3,\"phone\":\"13800138001\",\"email\":null,\"avatar\":null,\"role\":\"manager\",\"status\":1,\"roleIds\":null,\"deptIds\":[3,4],\"mainDeptId\":4}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:33:23');
INSERT INTO `operation_log` VALUES (3708, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:33:23');
INSERT INTO `operation_log` VALUES (3709, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:33:23');
INSERT INTO `operation_log` VALUES (3710, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:33:30');
INSERT INTO `operation_log` VALUES (3711, 1, 'admin', '其他', 'GET', 'GET /user/3/roleIds', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:33:30');
INSERT INTO `operation_log` VALUES (3712, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2ccad1d1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:34:13');
INSERT INTO `operation_log` VALUES (3713, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@360f5702]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:35:13');
INSERT INTO `operation_log` VALUES (3714, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@ca17d8e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:14');
INSERT INTO `operation_log` VALUES (3715, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:19');
INSERT INTO `operation_log` VALUES (3716, 1, 'admin', '其他', 'GET', 'GET /user/2/roleIds', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:19');
INSERT INTO `operation_log` VALUES (3717, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:33');
INSERT INTO `operation_log` VALUES (3718, 1, 'admin', '其他', 'GET', 'GET /user/3/roleIds', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:33');
INSERT INTO `operation_log` VALUES (3719, 1, 'admin', '其他', 'POST', 'POST /user/assign-roles', '[3,[4,3]]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:36');
INSERT INTO `operation_log` VALUES (3720, 1, 'admin', '其他', 'GET', 'GET /user/depts/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:46');
INSERT INTO `operation_log` VALUES (3721, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:50');
INSERT INTO `operation_log` VALUES (3722, 1, 'admin', '其他', 'GET', 'GET /user/4/roleIds', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:50');
INSERT INTO `operation_log` VALUES (3723, 1, 'admin', '其他', 'GET', 'GET /user/depts/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:53');
INSERT INTO `operation_log` VALUES (3724, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:56');
INSERT INTO `operation_log` VALUES (3725, 1, 'admin', '其他', 'GET', 'GET /user/3/roleIds', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:37:56');
INSERT INTO `operation_log` VALUES (3726, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:00');
INSERT INTO `operation_log` VALUES (3727, 1, 'admin', '其他', 'GET', 'GET /role/list', '[1,10,null,null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:04');
INSERT INTO `operation_log` VALUES (3728, 1, 'admin', '其他', 'GET', 'GET /user/2/roleIds', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:04');
INSERT INTO `operation_log` VALUES (3729, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@13799d54]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:13');
INSERT INTO `operation_log` VALUES (3730, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:22');
INSERT INTO `operation_log` VALUES (3731, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2fc47aa2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:23');
INSERT INTO `operation_log` VALUES (3732, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:23');
INSERT INTO `operation_log` VALUES (3733, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:23');
INSERT INTO `operation_log` VALUES (3734, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@77d4492a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:24');
INSERT INTO `operation_log` VALUES (3735, 7, 'staff', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=null, formNo=EXP202608160001, applicantId=7, deptId=4, applyDate=2026-08-16, totalAmount=6000, reason=测试, currentApproverId=null, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=null, expenseTypeId=1, expenseDate=2026-08-16, amount=6000, invoiceCount=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@1885e504], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@6c3b2dec]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:38:45');
INSERT INTO `operation_log` VALUES (3736, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@339418b7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:39:23');
INSERT INTO `operation_log` VALUES (3737, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:04');
INSERT INTO `operation_log` VALUES (3738, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:04');
INSERT INTO `operation_log` VALUES (3739, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61d676ff]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:04');
INSERT INTO `operation_log` VALUES (3740, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:04');
INSERT INTO `operation_log` VALUES (3741, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:08');
INSERT INTO `operation_log` VALUES (3742, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@42e93be1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:09');
INSERT INTO `operation_log` VALUES (3743, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:09');
INSERT INTO `operation_log` VALUES (3744, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:12');
INSERT INTO `operation_log` VALUES (3745, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:13');
INSERT INTO `operation_log` VALUES (3746, 1, 'admin', '其他', 'GET', 'GET /user/depts/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:17');
INSERT INTO `operation_log` VALUES (3747, 1, 'admin', '其他', 'GET', 'GET /user/depts/2', '[2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:40:24');
INSERT INTO `operation_log` VALUES (3748, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2079c762]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:41:09');
INSERT INTO `operation_log` VALUES (3749, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1c57274b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:42:09');
INSERT INTO `operation_log` VALUES (3750, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:43:16');
INSERT INTO `operation_log` VALUES (3751, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@19f402d0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:43:16');
INSERT INTO `operation_log` VALUES (3752, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:43:16');
INSERT INTO `operation_log` VALUES (3753, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:43:17');
INSERT INTO `operation_log` VALUES (3754, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@7e53cfb0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:43:18');
INSERT INTO `operation_log` VALUES (3755, 7, 'staff', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=null, formNo=EXP202608160001, applicantId=7, deptId=4, applyDate=2026-08-16, totalAmount=6000, reason=强大的, currentApproverId=null, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=null, expenseTypeId=1, expenseDate=2026-08-16, amount=6000, invoiceCount=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@6fafcce9], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@333753fe]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:43:39');
INSERT INTO `operation_log` VALUES (3756, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@856b047]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:44:17');
INSERT INTO `operation_log` VALUES (3757, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@c3437a5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:45:17');
INSERT INTO `operation_log` VALUES (3758, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@766f12e3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:46:17');
INSERT INTO `operation_log` VALUES (3759, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@78d3e756]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:47:17');
INSERT INTO `operation_log` VALUES (3760, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:48:21');
INSERT INTO `operation_log` VALUES (3761, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@570dd6b5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:48:21');
INSERT INTO `operation_log` VALUES (3762, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:48:21');
INSERT INTO `operation_log` VALUES (3763, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:48:22');
INSERT INTO `operation_log` VALUES (3764, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:48:24');
INSERT INTO `operation_log` VALUES (3765, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:48:24');
INSERT INTO `operation_log` VALUES (3766, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@166ec36d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:49:21');
INSERT INTO `operation_log` VALUES (3767, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7f625ece]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:50:22');
INSERT INTO `operation_log` VALUES (3768, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61c45f48]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:51:22');
INSERT INTO `operation_log` VALUES (3769, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@666c6d25]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:52:22');
INSERT INTO `operation_log` VALUES (3770, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@618678b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:53:22');
INSERT INTO `operation_log` VALUES (3771, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4fe019ed]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:54:22');
INSERT INTO `operation_log` VALUES (3772, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@57020d66]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-16 22:55:31');
INSERT INTO `operation_log` VALUES (3773, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:31:41');
INSERT INTO `operation_log` VALUES (3774, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:32:04');
INSERT INTO `operation_log` VALUES (3775, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@bdce615]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:32:05');
INSERT INTO `operation_log` VALUES (3776, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:32:05');
INSERT INTO `operation_log` VALUES (3777, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:32:06');
INSERT INTO `operation_log` VALUES (3778, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@28e2a11d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:32:08');
INSERT INTO `operation_log` VALUES (3779, 7, 'staff', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=2, formNo=EXP202608170001, applicantId=7, deptId=4, applyDate=2026-08-17, totalAmount=6000, reason=test, currentApproverId=2, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=2, expenseTypeId=1, expenseDate=2026-08-17, amount=6000, invoiceCount=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@53bc065f], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@1216b864]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:32:32');
INSERT INTO `operation_log` VALUES (3780, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@54f876b2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:33:05');
INSERT INTO `operation_log` VALUES (3781, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7c10ef2b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:34:05');
INSERT INTO `operation_log` VALUES (3782, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7db4167]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:35:05');
INSERT INTO `operation_log` VALUES (3783, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4d1e9ef6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:36:05');
INSERT INTO `operation_log` VALUES (3784, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@67e62e3b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:43:17');
INSERT INTO `operation_log` VALUES (3785, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4e61c8bc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:43:17');
INSERT INTO `operation_log` VALUES (3786, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@5dc3e058]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:43:15');
INSERT INTO `operation_log` VALUES (3787, 7, 'staff', '报销', '新增', 'POST /expense/submit', '[ExpenseForm(id=3, formNo=EXP202608170001, applicantId=7, deptId=4, applyDate=2026-08-17, totalAmount=6000, reason=测试, currentApproverId=2, status=1, paymentDate=null, remark=null, createdAt=null, updatedAt=null, attachmentUrls=null, attachmentUrlsList=null), [ExpenseItem(id=null, formId=3, expenseTypeId=1, expenseDate=2026-08-17, amount=6000, invoiceCount=null, invoiceImage=null, remark=null)], [org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@5110ab3d], org.springframework.web.multipart.support.StandardMultipartHttpServletRequest@7431f755]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:43:45');
INSERT INTO `operation_log` VALUES (3788, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@3a5a7b43]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:43:46');
INSERT INTO `operation_log` VALUES (3789, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:06');
INSERT INTO `operation_log` VALUES (3790, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3442fda6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:07');
INSERT INTO `operation_log` VALUES (3791, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:07');
INSERT INTO `operation_log` VALUES (3792, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:07');
INSERT INTO `operation_log` VALUES (3793, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@6a231a40]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:13');
INSERT INTO `operation_log` VALUES (3794, 7, 'staff', '报销', 'GET', 'GET /expense/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:20');
INSERT INTO `operation_log` VALUES (3795, 7, 'staff', '报销', 'GET', 'GET /expense/preview-attachment', '[/uploads/expense/a9bba980-1d31-47be-a9eb-4c519e777c60_连接成功.png, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@74d734a7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:44:28');
INSERT INTO `operation_log` VALUES (3796, 7, 'staff', '报销', 'GET', 'GET /expense/preview-attachment', '[/uploads/expense/a9bba980-1d31-47be-a9eb-4c519e777c60_连接成功.png, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@6c0d466c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:45:04');
INSERT INTO `operation_log` VALUES (3797, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61b2f1cc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:45:07');
INSERT INTO `operation_log` VALUES (3798, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"finance\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:31');
INSERT INTO `operation_log` VALUES (3799, 3, 'finance', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@116f9a05]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:31');
INSERT INTO `operation_log` VALUES (3800, 3, 'finance', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:31');
INSERT INTO `operation_log` VALUES (3801, 3, 'finance', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:31');
INSERT INTO `operation_log` VALUES (3802, 3, 'finance', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@791cac01]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:35');
INSERT INTO `operation_log` VALUES (3803, 3, 'finance', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:43');
INSERT INTO `operation_log` VALUES (3804, 3, 'finance', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:44');
INSERT INTO `operation_log` VALUES (3805, 3, 'finance', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:50');
INSERT INTO `operation_log` VALUES (3806, 3, 'finance', '其他', 'GET', 'GET /report/product-rank', '[2026-07-18, 2026-08-17, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:50');
INSERT INTO `operation_log` VALUES (3807, 3, 'finance', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-18, 2026-08-17, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:47:50');
INSERT INTO `operation_log` VALUES (3808, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"manager\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:09');
INSERT INTO `operation_log` VALUES (3809, 2, 'manager', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:09');
INSERT INTO `operation_log` VALUES (3810, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4d466e11]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:09');
INSERT INTO `operation_log` VALUES (3811, 2, 'manager', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:09');
INSERT INTO `operation_log` VALUES (3812, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@332519c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:12');
INSERT INTO `operation_log` VALUES (3813, 2, 'manager', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:25');
INSERT INTO `operation_log` VALUES (3814, 2, 'manager', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:25');
INSERT INTO `operation_log` VALUES (3815, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@6b919670]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:48:32');
INSERT INTO `operation_log` VALUES (3816, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7ef96f67]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:49:09');
INSERT INTO `operation_log` VALUES (3817, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@322404d2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:50:09');
INSERT INTO `operation_log` VALUES (3818, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4d8bd0bf]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:51:09');
INSERT INTO `operation_log` VALUES (3819, 2, 'manager', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:51:36');
INSERT INTO `operation_log` VALUES (3820, 2, 'manager', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-18, 2026-08-17, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:51:36');
INSERT INTO `operation_log` VALUES (3821, 2, 'manager', '其他', 'GET', 'GET /report/product-rank', '[2026-07-18, 2026-08-17, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:51:36');
INSERT INTO `operation_log` VALUES (3822, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@3458b005]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:51:38');
INSERT INTO `operation_log` VALUES (3823, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@467018dc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:52:09');
INSERT INTO `operation_log` VALUES (3824, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3c517f68]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:53:09');
INSERT INTO `operation_log` VALUES (3825, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2da51198]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:54:09');
INSERT INTO `operation_log` VALUES (3826, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4db33e11]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:55:31');
INSERT INTO `operation_log` VALUES (3827, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7b8efc5a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:56:31');
INSERT INTO `operation_log` VALUES (3828, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@726eb8e0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:57:31');
INSERT INTO `operation_log` VALUES (3829, 2, 'manager', '销售', 'GET', 'GET /report/sales-daily', '[2026-07-18, 2026-08-17, null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:57:53');
INSERT INTO `operation_log` VALUES (3830, 2, 'manager', '其他', 'GET', 'GET /report/product-rank', '[2026-07-18, 2026-08-17, null, 10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:57:53');
INSERT INTO `operation_log` VALUES (3831, 2, 'manager', '库存', 'GET', 'GET /report/inventory-analysis', '[null]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:57:53');
INSERT INTO `operation_log` VALUES (3832, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@5e668026]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:58:01');
INSERT INTO `operation_log` VALUES (3833, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5b65390a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:58:09');
INSERT INTO `operation_log` VALUES (3834, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@22b37f67]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:58:31');
INSERT INTO `operation_log` VALUES (3835, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6f5dbfc7]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:58:31');
INSERT INTO `operation_log` VALUES (3836, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@5d8a68d3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:58:40');
INSERT INTO `operation_log` VALUES (3837, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5b77c9c8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:58:40');
INSERT INTO `operation_log` VALUES (3838, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@d1de8f6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:59:05');
INSERT INTO `operation_log` VALUES (3839, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7082a111]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 14:59:05');
INSERT INTO `operation_log` VALUES (3840, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39a572ee]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:00:05');
INSERT INTO `operation_log` VALUES (3841, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@75ad70fa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:01:05');
INSERT INTO `operation_log` VALUES (3842, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@39c5a214]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:02:05');
INSERT INTO `operation_log` VALUES (3843, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4e37c09d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:03:05');
INSERT INTO `operation_log` VALUES (3844, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@29961eea]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:04:05');
INSERT INTO `operation_log` VALUES (3845, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@40530d90]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:27');
INSERT INTO `operation_log` VALUES (3846, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@31ce157]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:29');
INSERT INTO `operation_log` VALUES (3847, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1fd076de]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:29');
INSERT INTO `operation_log` VALUES (3848, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:51');
INSERT INTO `operation_log` VALUES (3849, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@447a1655]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:51');
INSERT INTO `operation_log` VALUES (3850, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:51');
INSERT INTO `operation_log` VALUES (3851, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:52');
INSERT INTO `operation_log` VALUES (3852, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:54');
INSERT INTO `operation_log` VALUES (3853, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:07:54');
INSERT INTO `operation_log` VALUES (3854, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@479be070]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:08:51');
INSERT INTO `operation_log` VALUES (3855, 1, 'admin', '其他', 'GET', 'GET /user/depts/4', '[4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:09:43');
INSERT INTO `operation_log` VALUES (3856, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7f289a75]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:09:51');
INSERT INTO `operation_log` VALUES (3857, 1, 'unknown', '其他', '修改', 'PUT /admin/user/update', '[{\"id\":4,\"username\":\"sales\",\"password\":null,\"realName\":\"销售赵六\",\"deptId\":4,\"phone\":\"13800138003\",\"email\":\"123@126.com\",\"avatar\":null,\"role\":\"staff\",\"status\":1,\"roleIds\":null,\"deptIds\":[4],\"mainDeptId\":4}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:10:02');
INSERT INTO `operation_log` VALUES (3858, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:10:02');
INSERT INTO `operation_log` VALUES (3859, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:10:02');
INSERT INTO `operation_log` VALUES (3860, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7fac3ef]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:10:51');
INSERT INTO `operation_log` VALUES (3861, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6b62a030]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:11:52');
INSERT INTO `operation_log` VALUES (3862, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61579aff]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:12:52');
INSERT INTO `operation_log` VALUES (3863, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@40d8744b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:13:52');
INSERT INTO `operation_log` VALUES (3864, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@16ed4d7e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:16:25');
INSERT INTO `operation_log` VALUES (3865, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:16:28');
INSERT INTO `operation_log` VALUES (3866, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6545429b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:16:28');
INSERT INTO `operation_log` VALUES (3867, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:16:28');
INSERT INTO `operation_log` VALUES (3868, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"manager\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:17:08');
INSERT INTO `operation_log` VALUES (3869, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@788d7e09]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:17:09');
INSERT INTO `operation_log` VALUES (3870, 2, 'manager', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:17:09');
INSERT INTO `operation_log` VALUES (3871, 2, 'manager', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:17:09');
INSERT INTO `operation_log` VALUES (3872, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@4a8ca794]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:17:12');
INSERT INTO `operation_log` VALUES (3873, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5991f099]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:17:12');
INSERT INTO `operation_log` VALUES (3874, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@262afced]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:18:09');
INSERT INTO `operation_log` VALUES (3875, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@777c724e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:19:09');
INSERT INTO `operation_log` VALUES (3876, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2a820f51]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:20:09');
INSERT INTO `operation_log` VALUES (3877, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@ad1002b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:21:09');
INSERT INTO `operation_log` VALUES (3878, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@68d7bdb6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:22:09');
INSERT INTO `operation_log` VALUES (3879, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4f65947f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:23:09');
INSERT INTO `operation_log` VALUES (3880, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6aaab9aa]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:24:31');
INSERT INTO `operation_log` VALUES (3881, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@19cadb92]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:31');
INSERT INTO `operation_log` VALUES (3882, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"staff\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:57');
INSERT INTO `operation_log` VALUES (3883, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@b07f93b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:57');
INSERT INTO `operation_log` VALUES (3884, 7, 'staff', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:57');
INSERT INTO `operation_log` VALUES (3885, 7, 'staff', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:57');
INSERT INTO `operation_log` VALUES (3886, 7, 'staff', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@76485d67]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:59');
INSERT INTO `operation_log` VALUES (3887, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@52ae7410]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:25:59');
INSERT INTO `operation_log` VALUES (3888, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4d68adb5]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:26:57');
INSERT INTO `operation_log` VALUES (3889, 7, 'staff', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3e4f1f79]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:27:57');
INSERT INTO `operation_log` VALUES (3890, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"finance\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:28:49');
INSERT INTO `operation_log` VALUES (3891, 3, 'finance', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:28:49');
INSERT INTO `operation_log` VALUES (3892, 3, 'finance', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4e76d33b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:28:49');
INSERT INTO `operation_log` VALUES (3893, 3, 'finance', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:28:49');
INSERT INTO `operation_log` VALUES (3894, 3, 'finance', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@38b29587]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:28:51');
INSERT INTO `operation_log` VALUES (3895, 3, 'finance', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2cd8ae75]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:28:51');
INSERT INTO `operation_log` VALUES (3896, 3, 'finance', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@787076e8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:29:49');
INSERT INTO `operation_log` VALUES (3897, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"manager\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:30:02');
INSERT INTO `operation_log` VALUES (3898, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@61b6801d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:30:03');
INSERT INTO `operation_log` VALUES (3899, 2, 'manager', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:30:03');
INSERT INTO `operation_log` VALUES (3900, 2, 'manager', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:30:03');
INSERT INTO `operation_log` VALUES (3901, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@7866d518]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:30:05');
INSERT INTO `operation_log` VALUES (3902, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@50f6a374]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:30:05');
INSERT INTO `operation_log` VALUES (3903, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4f7424c1]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:31:03');
INSERT INTO `operation_log` VALUES (3904, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@776fb701]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:32:03');
INSERT INTO `operation_log` VALUES (3905, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6fabf327]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:33:03');
INSERT INTO `operation_log` VALUES (3906, 2, 'manager', '报销', 'GET', 'GET /expense/my', '[org.apache.catalina.connector.RequestFacade@429569e2]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:33:43');
INSERT INTO `operation_log` VALUES (3907, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@48d5444e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:33:43');
INSERT INTO `operation_log` VALUES (3908, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@93a55ad]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:33:43');
INSERT INTO `operation_log` VALUES (3909, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1804f58a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:34:43');
INSERT INTO `operation_log` VALUES (3910, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2e63f6c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:35:43');
INSERT INTO `operation_log` VALUES (3911, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2eba6b17]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:36:43');
INSERT INTO `operation_log` VALUES (3912, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@52da53fc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:37:43');
INSERT INTO `operation_log` VALUES (3913, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@38cb97be]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:38:43');
INSERT INTO `operation_log` VALUES (3914, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@29ae545]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:39:43');
INSERT INTO `operation_log` VALUES (3915, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6dc7db78]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:41:16');
INSERT INTO `operation_log` VALUES (3916, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@665859c0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:42:17');
INSERT INTO `operation_log` VALUES (3917, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2bd9946e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:43:18');
INSERT INTO `operation_log` VALUES (3918, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@569db549]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:44:19');
INSERT INTO `operation_log` VALUES (3919, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7f380653]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:45:20');
INSERT INTO `operation_log` VALUES (3920, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4d60faea]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:46:21');
INSERT INTO `operation_log` VALUES (3921, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@463fc64f]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:47:22');
INSERT INTO `operation_log` VALUES (3922, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3dc380a0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:48:23');
INSERT INTO `operation_log` VALUES (3923, 2, 'manager', '报销', 'GET', 'GET /expense/3', '[3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:48:35');
INSERT INTO `operation_log` VALUES (3924, 2, 'manager', '报销', 'GET', 'GET /expense/preview-attachment', '[/uploads/expense/a9bba980-1d31-47be-a9eb-4c519e777c60_连接成功.png, org.springframework.web.context.request.async.StandardServletAsyncWebRequest$LifecycleHttpServletResponse@30dc2aca]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:48:38');
INSERT INTO `operation_log` VALUES (3925, 2, 'manager', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@9a701e8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:48:43');
INSERT INTO `operation_log` VALUES (3926, 1, 'unknown', '其他', 'POST', 'POST /login', '[{\"username\":\"admin\",\"password\":\"123456\"}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:50:31');
INSERT INTO `operation_log` VALUES (3927, 1, 'admin', '其他', 'GET', 'GET /report/dashboard', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:50:33');
INSERT INTO `operation_log` VALUES (3928, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4f872e50]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:50:33');
INSERT INTO `operation_log` VALUES (3929, 1, 'admin', '其他', 'GET', 'GET /report/product-rank', '[null,null,null,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:50:33');
INSERT INTO `operation_log` VALUES (3930, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:50:35');
INSERT INTO `operation_log` VALUES (3931, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:50:35');
INSERT INTO `operation_log` VALUES (3932, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@33447f6c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:51:33');
INSERT INTO `operation_log` VALUES (3933, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3e5eb09b]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:52:33');
INSERT INTO `operation_log` VALUES (3934, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@7c0e248]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:53:33');
INSERT INTO `operation_log` VALUES (3935, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@64cd860e]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:54:33');
INSERT INTO `operation_log` VALUES (3936, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@53f07f6c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:55:33');
INSERT INTO `operation_log` VALUES (3937, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@47da2b09]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:56:33');
INSERT INTO `operation_log` VALUES (3938, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@33c7d22d]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 15:58:31');
INSERT INTO `operation_log` VALUES (3939, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3ae13cd3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:00:31');
INSERT INTO `operation_log` VALUES (3940, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@71ebff6a]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:02:31');
INSERT INTO `operation_log` VALUES (3941, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:07:59');
INSERT INTO `operation_log` VALUES (3942, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@1d2beba9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:08:01');
INSERT INTO `operation_log` VALUES (3943, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@156390f4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:08:01');
INSERT INTO `operation_log` VALUES (3944, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:08:02');
INSERT INTO `operation_log` VALUES (3945, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@18cd13d6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:08:58');
INSERT INTO `operation_log` VALUES (3946, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@a7d987c]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:09:59');
INSERT INTO `operation_log` VALUES (3947, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@dc5af9]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:10:59');
INSERT INTO `operation_log` VALUES (3948, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@55e420cc]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:11:59');
INSERT INTO `operation_log` VALUES (3949, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@50fdeba3]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:12:59');
INSERT INTO `operation_log` VALUES (3950, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@224e4d12]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:13:59');
INSERT INTO `operation_log` VALUES (3951, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@17b0f5c4]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:15:31');
INSERT INTO `operation_log` VALUES (3952, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4fce4ca0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:16:31');
INSERT INTO `operation_log` VALUES (3953, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2a75dece]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:17:31');
INSERT INTO `operation_log` VALUES (3954, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@77ed0f54]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:18:31');
INSERT INTO `operation_log` VALUES (3955, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@429fee22]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:19:31');
INSERT INTO `operation_log` VALUES (3956, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@5dc8de82]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:21:33');
INSERT INTO `operation_log` VALUES (3957, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@f2077ff]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:21:58');
INSERT INTO `operation_log` VALUES (3958, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@3442fda6]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:22:05');
INSERT INTO `operation_log` VALUES (3959, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:22:05');
INSERT INTO `operation_log` VALUES (3960, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:22:06');
INSERT INTO `operation_log` VALUES (3961, 1, 'unknown', '其他', '新增', 'POST /admin/user/add', '[{\"id\":9,\"username\":\"test\",\"password\":\"$2a$10$To00j0/AHWv9rEbsnpo3KuW6QvD7I4leqHBLy.KZFXqIIAZOLxOXS\",\"realName\":\"测试\",\"deptId\":null,\"phone\":\"\",\"email\":\"\",\"avatar\":null,\"role\":\"staff\",\"status\":1,\"roleIds\":null,\"deptIds\":[7],\"mainDeptId\":7}]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:22:23');
INSERT INTO `operation_log` VALUES (3962, 1, 'unknown', '其他', 'GET', 'GET /admin/user/list', '[\"\",1,10]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:22:24');
INSERT INTO `operation_log` VALUES (3963, 1, 'admin', '其他', 'GET', 'GET /dept/list', NULL, '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:22:24');
INSERT INTO `operation_log` VALUES (3964, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2ca1b0a8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:23:05');
INSERT INTO `operation_log` VALUES (3965, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@4c322562]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:24:05');
INSERT INTO `operation_log` VALUES (3966, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@19345f91]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:25:05');
INSERT INTO `operation_log` VALUES (3967, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@14fd3f0]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:26:05');
INSERT INTO `operation_log` VALUES (3968, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@25912735]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:27:05');
INSERT INTO `operation_log` VALUES (3969, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@2b2951a8]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:28:05');
INSERT INTO `operation_log` VALUES (3970, 1, 'admin', '报销', 'GET', 'GET /expense/pending', '[org.apache.catalina.connector.RequestFacade@6a9ea2ad]', '0:0:0:0:0:0:0:1', 1, NULL, '2026-08-17 16:29:31');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `sku_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品编码（SKU）',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `mnemonic_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '助记码（拼音首字母）',
  `category_id` bigint NULL DEFAULT NULL COMMENT '商品分类ID（关联字典表）',
  `spec` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品规格',
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品型号',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计量单位（台/个/箱/公斤）',
  `barcode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '条形码',
  `cost_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成本价',
  `sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售价',
  `min_stock` int NULL DEFAULT 0 COMMENT '最低库存预警',
  `max_stock` int NULL DEFAULT 0 COMMENT '最高库存预警',
  `supplier_id` bigint NULL DEFAULT NULL COMMENT '默认供应商ID',
  `shelf_life` int NULL DEFAULT 0 COMMENT '保质期天数（0表示无保质期）',
  `storage_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存放位置（如：A区3排5号）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-启用 0-停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sku_code`(`sku_code` ASC) USING BTREE,
  UNIQUE INDEX `barcode`(`barcode` ASC) USING BTREE,
  INDEX `idx_sku_code`(`sku_code` ASC) USING BTREE,
  INDEX `idx_product_name`(`product_name` ASC) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_barcode`(`barcode` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品/物料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, 'SKU1785248948521', '华为Mate60 Pro', 'HWM60P', 1, '12GB+256GB', 'ALP-AL00', '台', NULL, 4500.00, 5499.00, 5, 100, 1, NULL, 'A区1排3号', 1, NULL, '2026-07-28 22:29:08', '2026-07-28 22:29:08');
INSERT INTO `product` VALUES (2, 'SKU1786884291265', '测试商品1', '测试商品1', NULL, '1KG', NULL, '台', NULL, 10.00, 20.00, 1, NULL, NULL, NULL, NULL, 1, NULL, '2026-08-16 20:44:51', '2026-08-16 20:45:10');

-- ----------------------------
-- Table structure for purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order`;
CREATE TABLE `purchase_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '采购单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '采购单号（系统自动生成）',
  `supplier_id` bigint NOT NULL COMMENT '供应商ID',
  `warehouse_id` bigint NOT NULL COMMENT '入库仓库ID',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总金额',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿 1-已入库 2-已取消',
  `purchaser_id` bigint NULL DEFAULT NULL COMMENT '采购员ID',
  `order_date` date NULL DEFAULT NULL COMMENT '采购日期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_order_date`(`order_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购入库单头表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_order
-- ----------------------------
INSERT INTO `purchase_order` VALUES (1, 'PO202607290001', 1, 1, 45000.00, 1, 1, '2026-07-28', '测试采购', '2026-07-29 19:52:37', '2026-07-29 20:12:20');
INSERT INTO `purchase_order` VALUES (2, 'PO202607290002', 1, 1, 45000.00, 1, 1, '2026-07-28', '测试采购', '2026-07-29 21:32:10', '2026-07-29 21:32:21');
INSERT INTO `purchase_order` VALUES (3, 'PO202608160001', 1, 1, 4650.00, 1, 1, '2026-08-16', '批量导入', '2026-08-16 18:28:28', '2026-08-16 18:29:58');
INSERT INTO `purchase_order` VALUES (4, 'PO202608160002', 2, 1, 10.00, 1, NULL, '2026-08-16', '前端创建', '2026-08-16 21:45:11', '2026-08-16 22:16:05');

-- ----------------------------
-- Table structure for purchase_order_item
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order_item`;
CREATE TABLE `purchase_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '采购单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '数量',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额（数量×单价）',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购入库单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_order_item
-- ----------------------------
INSERT INTO `purchase_order_item` VALUES (1, 1, 1, 10, 4500.00, 45000.00, '第一批');
INSERT INTO `purchase_order_item` VALUES (2, 2, 1, 10, 4500.00, 45000.00, '第一批');
INSERT INTO `purchase_order_item` VALUES (3, 3, 1, 1, 4650.00, 4650.00, '示例数据，请删除后导入');
INSERT INTO `purchase_order_item` VALUES (4, 4, 2, 1, 10.00, 10.00, NULL);

-- ----------------------------
-- Table structure for sales_order
-- ----------------------------
DROP TABLE IF EXISTS `sales_order`;
CREATE TABLE `sales_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '销售单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '销售单号（系统自动生成）',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `warehouse_id` bigint NOT NULL COMMENT '出库仓库ID',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总金额',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿 1-已出库 2-已取消',
  `salesman_id` bigint NULL DEFAULT NULL COMMENT '销售员ID',
  `order_date` date NULL DEFAULT NULL COMMENT '销售日期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_order_date`(`order_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '销售出库单头表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sales_order
-- ----------------------------
INSERT INTO `sales_order` VALUES (1, 'SO202607290001', 1, 1, 10998.00, 1, 1, '2026-07-28', '测试销售', '2026-07-29 19:56:32', '2026-07-29 20:13:23');
INSERT INTO `sales_order` VALUES (2, 'SO202607290002', 1, 1, 10998.00, 1, 1, '2026-07-28', '测试销售', '2026-07-29 21:33:08', '2026-07-29 21:33:15');
INSERT INTO `sales_order` VALUES (3, 'SO202608160001', 2, 1, 5000.00, 1, NULL, '2026-08-16', '前端创建', '2026-08-16 21:55:06', '2026-08-16 22:25:03');

-- ----------------------------
-- Table structure for sales_order_item
-- ----------------------------
DROP TABLE IF EXISTS `sales_order_item`;
CREATE TABLE `sales_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '销售单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '数量',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额（数量×单价）',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '销售出库单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sales_order_item
-- ----------------------------
INSERT INTO `sales_order_item` VALUES (1, 1, 1, 2, 5499.00, 10998.00, '卖给测试客户');
INSERT INTO `sales_order_item` VALUES (2, 2, 1, 2, 5499.00, 10998.00, '卖给测试客户');
INSERT INTO `sales_order_item` VALUES (3, 3, 1, 1, 5000.00, 5000.00, NULL);

-- ----------------------------
-- Table structure for stock_check
-- ----------------------------
DROP TABLE IF EXISTS `stock_check`;
CREATE TABLE `stock_check`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '盘点单ID',
  `check_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '盘点单号',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `book_quantity` int NOT NULL COMMENT '账面数量',
  `actual_quantity` int NOT NULL COMMENT '实际数量',
  `difference` int NULL DEFAULT NULL COMMENT '差异数量',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '差异原因',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿 1-已审核',
  `checker_id` bigint NULL DEFAULT NULL COMMENT '盘点人ID',
  `check_date` date NULL DEFAULT NULL COMMENT '盘点日期',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `check_no`(`check_no` ASC) USING BTREE,
  INDEX `idx_check_no`(`check_no` ASC) USING BTREE,
  INDEX `idx_warehouse_id`(`warehouse_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存盘点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stock_check
-- ----------------------------
INSERT INTO `stock_check` VALUES (1, 'SC202607290001', 1, 1, 16, 7, -9, '少了一台，待查原因', 1, 1, '2026-07-29', '2026-07-29 22:49:22', '2026-07-29 23:00:40');

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `supplier_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应商名称',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开户行',
  `bank_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '银行账号',
  `tax_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '税号',
  `initial_payable` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '期初应付款',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-正常 0-停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `supplier_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商编码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `supplier_code`(`supplier_code` ASC) USING BTREE,
  INDEX `idx_supplier_name`(`supplier_name` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '供应商表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of supplier
-- ----------------------------
INSERT INTO `supplier` VALUES (1, '华为供应商', '张经理', '13800138000', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2026-07-29 19:52:14', '2026-07-31 14:35:17', 'SUP001');
INSERT INTO `supplier` VALUES (2, '测试供应商1', '', '', '', '', NULL, NULL, NULL, NULL, 1, NULL, '2026-08-16 21:28:34', '2026-08-16 21:28:34', NULL);

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门ID，0表示根部门',
  `sort` int NULL DEFAULT 0 COMMENT '排序号',
  `leader` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-正常 0-停用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_department
-- ----------------------------
INSERT INTO `sys_department` VALUES (1, '总公司', 0, 1, '张三', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_department` VALUES (2, '总经办', 1, 1, '张三', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_department` VALUES (3, '财务部', 1, 2, '李四', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_department` VALUES (4, '销售部', 1, 3, '王五', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_department` VALUES (5, '采购部', 1, 4, '赵六', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_department` VALUES (6, '仓储部', 1, 5, '钱七', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_department` VALUES (7, '综合部', NULL, NULL, NULL, NULL, NULL, 1, '2026-08-11 22:08:43', '2026-08-11 22:08:43');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典ID',
  `dict_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典类型',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典标签（显示的文字）',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典值（实际存储的值）',
  `sort` int NULL DEFAULT 0 COMMENT '排序号',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-正常 0-停用',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dict_type`(`dict_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (1, 'product_category', '电子产品', '1', 1, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (2, 'product_category', '办公用品', '2', 2, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (3, 'product_category', '劳保用品', '3', 3, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (4, 'product_category', '原材料', '4', 4, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (5, 'product_category', '成品', '5', 5, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (6, 'unit', '台', '1', 1, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (7, 'unit', '个', '2', 2, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (8, 'unit', '箱', '3', 3, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (9, 'unit', '公斤', '4', 4, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (10, 'unit', '米', '5', 5, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (11, 'unit', '套', '6', 6, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (12, 'expense_type', '差旅费', '1', 1, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (13, 'expense_type', '交通费', '2', 2, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (14, 'expense_type', '招待费', '3', 3, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (15, 'expense_type', '办公费', '4', 4, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (16, 'expense_type', '通讯费', '5', 5, 1, NULL, '2026-07-28 19:35:07');
INSERT INTO `sys_dict` VALUES (17, 'expense_type', '其他', '6', 6, 1, NULL, '2026-07-28 19:35:07');

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `permission_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限名称，如\"用户新增\"',
  `permission_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限编码，如\"USER_ADD\"',
  `api_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '接口路径，如\"/user/add\"',
  `api_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求方法，如\"POST\"',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限描述',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_permission_code`(`permission_code` ASC) USING BTREE,
  UNIQUE INDEX `uk_api_path_method`(`api_path` ASC, `api_method` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 79 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '接口权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (23, '用户列表', 'USER_LIST', '/user/list', 'GET', '查询用户列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (24, '用户新增', 'USER_ADD', '/user/add', 'POST', '新增用户', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (25, '用户修改', 'USER_UPDATE', '/user/update', 'PUT', '修改用户', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (26, '用户删除', 'USER_DELETE', '/user/delete', 'DELETE', '删除用户', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (27, '用户分配角色', 'USER_ASSIGN', '/user/assign-roles', 'POST', '分配用户角色', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (28, '角色列表', 'ROLE_LIST', '/role/list', 'GET', '查询角色列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (29, '角色新增', 'ROLE_ADD', '/role/add', 'POST', '新增角色', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (30, '角色修改', 'ROLE_UPDATE', '/role/update', 'PUT', '修改角色', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (31, '角色删除', 'ROLE_DELETE', '/role/delete', 'DELETE', '删除角色', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (32, '权限列表', 'PERM_LIST', '/permission/list', 'GET', '查询权限列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (33, '权限新增', 'PERM_ADD', '/permission/add', 'POST', '新增权限', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (34, '权限修改', 'PERM_UPDATE', '/permission/update', 'PUT', '修改权限', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (35, '权限删除', 'PERM_DELETE', '/permission/delete', 'DELETE', '删除权限', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (36, '角色权限查询', 'PERM_ROLE_QUERY', '/permission/role', 'GET', '查询角色权限', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (37, '角色权限分配', 'PERM_ROLE_ASSIGN', '/permission/assign', 'POST', '分配角色权限', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (38, '仓库列表', 'WH_LIST', '/warehouse/list', 'GET', '查询仓库列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (39, '仓库新增', 'WH_ADD', '/warehouse/add', 'POST', '新增仓库', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (40, '仓库修改', 'WH_UPDATE', '/warehouse/update', 'PUT', '修改仓库', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (41, '仓库停用', 'WH_DISABLE', '/warehouse/disable', 'PUT', '停用仓库', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (42, '仓库启用', 'WH_ENABLE', '/warehouse/enable', 'PUT', '启用仓库', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (43, '商品列表', 'PRODUCT_LIST', '/product/list', 'GET', '查询商品列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (44, '商品新增', 'PRODUCT_ADD', '/product/add', 'POST', '新增商品', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (45, '商品修改', 'PRODUCT_UPDATE', '/product/update', 'PUT', '修改商品', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (46, '商品删除', 'PRODUCT_DELETE', '/product/delete', 'DELETE', '删除商品', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (47, '供应商列表', 'SUPPLIER_LIST', '/supplier/list', 'GET', '查询供应商列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (48, '供应商新增', 'SUPPLIER_ADD', '/supplier/add', 'POST', '新增供应商', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (49, '供应商修改', 'SUPPLIER_UPDATE', '/supplier/update', 'PUT', '修改供应商', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (50, '供应商删除', 'SUPPLIER_DELETE', '/supplier/delete', 'DELETE', '删除供应商', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (51, '客户列表', 'CUSTOMER_LIST', '/customer/list', 'GET', '查询客户列表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (52, '客户新增', 'CUSTOMER_ADD', '/customer/add', 'POST', '新增客户', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (53, '客户修改', 'CUSTOMER_UPDATE', '/customer/update', 'PUT', '修改客户', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (54, '客户删除', 'CUSTOMER_DELETE', '/customer/delete', 'DELETE', '删除客户', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (55, '采购列表', 'PURCHASE_LIST', '/purchase/list', 'GET', '查询采购单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (56, '采购新增', 'PURCHASE_ADD', '/purchase/add', 'POST', '新增采购单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (57, '采购审批', 'PURCHASE_APPROVE', '/purchase/approve', 'PUT', '审批采购单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (58, '采购删除', 'PURCHASE_DELETE', '/purchase/delete', 'DELETE', '删除采购单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (59, '销售列表', 'SALES_LIST', '/sales/list', 'GET', '查询销售单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (60, '销售新增', 'SALES_ADD', '/sales/add', 'POST', '新增销售单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (61, '销售审批', 'SALES_APPROVE', '/sales/approve', 'PUT', '审批销售单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (62, '销售删除', 'SALES_DELETE', '/sales/delete', 'DELETE', '删除销售单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (63, '库存列表', 'INV_LIST', '/inventory/list', 'GET', '查询库存', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (64, '库存出库', 'INV_OUT', '/inventory/out', 'POST', '库存出库', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (65, '库存入库', 'INV_IN', '/inventory/in', 'POST', '库存入库', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (66, '盘点列表', 'STOCK_LIST', '/stock-check/list', 'GET', '查询盘点单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (67, '盘点新增', 'STOCK_ADD', '/stock-check/add', 'POST', '新增盘点单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (68, '盘点审批', 'STOCK_APPROVE', '/stock-check/approve', 'PUT', '审批盘点单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (69, '盘点删除', 'STOCK_DELETE', '/stock-check/delete', 'DELETE', '删除盘点单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (70, '报销列表', 'EXPENSE_LIST', '/expense/list', 'GET', '查询报销单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (71, '报销新增', 'EXPENSE_ADD', '/expense/add', 'POST', '新增报销单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (72, '报销审批', 'EXPENSE_APPROVE', '/expense/approve', 'PUT', '审批报销单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (73, '报销删除', 'EXPENSE_DELETE', '/expense/delete', 'DELETE', '删除报销单', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (74, '报表查询', 'REPORT_QUERY', '/report/**', 'GET', '查询统计报表', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (75, '获取用户信息', 'USER_INFO', '/user/info', 'GET', '获取当前用户信息', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (76, '修改密码', 'CHANGE_PWD', '/user/change-password', 'POST', '修改密码', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (77, '更新个人信息', 'UPDATE_PROFILE', '/user/profile', 'PUT', '更新个人信息', 1, '2026-08-04 16:43:24', '2026-08-04 16:43:24');
INSERT INTO `sys_permission` VALUES (78, '测试权限1', 'PERMISSION_TEST', '/permission/test', 'GET', '', 1, '2026-08-16 20:43:52', '2026-08-16 20:43:52');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色描述',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-正常 0-停用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'ADMIN', '系统最高权限', 1, '2026-07-28 19:35:07', '2026-08-04 10:20:55');
INSERT INTO `sys_role` VALUES (2, '总经理', 'GM', '公司总经理，审批大额报销', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (3, '部门经理', 'DEPT_MANAGER', '部门负责人，审批本部门报销', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (4, '财务', 'FINANCE', '财务人员，审核报销、确认付款', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (5, '销售员', 'SALES', '销售人员，开具销售单', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (6, '采购员', 'PURCHASER', '采购人员，开具采购单', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (7, '仓管员', 'INVENTORY', '仓库管理人员，执行出入库', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (8, '普通员工', 'STAFF', '普通员工，提交报销', 1, '2026-07-28 19:35:07', '2026-07-28 19:35:07');
INSERT INTO `sys_role` VALUES (9, '角色测试1', 'ROLE_TEST1', '测试', 1, '2026-08-16 21:43:14', '2026-08-16 21:43:14');

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission`(`role_id` ASC, `permission_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 291 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
INSERT INTO `sys_role_permission` VALUES (100, 1, 23);
INSERT INTO `sys_role_permission` VALUES (96, 1, 24);
INSERT INTO `sys_role_permission` VALUES (101, 1, 25);
INSERT INTO `sys_role_permission` VALUES (98, 1, 26);
INSERT INTO `sys_role_permission` VALUES (97, 1, 27);
INSERT INTO `sys_role_permission` VALUES (81, 1, 28);
INSERT INTO `sys_role_permission` VALUES (79, 1, 29);
INSERT INTO `sys_role_permission` VALUES (82, 1, 30);
INSERT INTO `sys_role_permission` VALUES (80, 1, 31);
INSERT INTO `sys_role_permission` VALUES (66, 1, 32);
INSERT INTO `sys_role_permission` VALUES (64, 1, 33);
INSERT INTO `sys_role_permission` VALUES (69, 1, 34);
INSERT INTO `sys_role_permission` VALUES (65, 1, 35);
INSERT INTO `sys_role_permission` VALUES (68, 1, 36);
INSERT INTO `sys_role_permission` VALUES (67, 1, 37);
INSERT INTO `sys_role_permission` VALUES (105, 1, 38);
INSERT INTO `sys_role_permission` VALUES (102, 1, 39);
INSERT INTO `sys_role_permission` VALUES (106, 1, 40);
INSERT INTO `sys_role_permission` VALUES (103, 1, 41);
INSERT INTO `sys_role_permission` VALUES (104, 1, 42);
INSERT INTO `sys_role_permission` VALUES (72, 1, 43);
INSERT INTO `sys_role_permission` VALUES (70, 1, 44);
INSERT INTO `sys_role_permission` VALUES (73, 1, 45);
INSERT INTO `sys_role_permission` VALUES (71, 1, 46);
INSERT INTO `sys_role_permission` VALUES (93, 1, 47);
INSERT INTO `sys_role_permission` VALUES (91, 1, 48);
INSERT INTO `sys_role_permission` VALUES (94, 1, 49);
INSERT INTO `sys_role_permission` VALUES (92, 1, 50);
INSERT INTO `sys_role_permission` VALUES (55, 1, 51);
INSERT INTO `sys_role_permission` VALUES (53, 1, 52);
INSERT INTO `sys_role_permission` VALUES (56, 1, 53);
INSERT INTO `sys_role_permission` VALUES (54, 1, 54);
INSERT INTO `sys_role_permission` VALUES (77, 1, 55);
INSERT INTO `sys_role_permission` VALUES (74, 1, 56);
INSERT INTO `sys_role_permission` VALUES (75, 1, 57);
INSERT INTO `sys_role_permission` VALUES (76, 1, 58);
INSERT INTO `sys_role_permission` VALUES (86, 1, 59);
INSERT INTO `sys_role_permission` VALUES (83, 1, 60);
INSERT INTO `sys_role_permission` VALUES (84, 1, 61);
INSERT INTO `sys_role_permission` VALUES (85, 1, 62);
INSERT INTO `sys_role_permission` VALUES (62, 1, 63);
INSERT INTO `sys_role_permission` VALUES (63, 1, 64);
INSERT INTO `sys_role_permission` VALUES (61, 1, 65);
INSERT INTO `sys_role_permission` VALUES (90, 1, 66);
INSERT INTO `sys_role_permission` VALUES (87, 1, 67);
INSERT INTO `sys_role_permission` VALUES (88, 1, 68);
INSERT INTO `sys_role_permission` VALUES (89, 1, 69);
INSERT INTO `sys_role_permission` VALUES (60, 1, 70);
INSERT INTO `sys_role_permission` VALUES (57, 1, 71);
INSERT INTO `sys_role_permission` VALUES (58, 1, 72);
INSERT INTO `sys_role_permission` VALUES (59, 1, 73);
INSERT INTO `sys_role_permission` VALUES (78, 1, 74);
INSERT INTO `sys_role_permission` VALUES (99, 1, 75);
INSERT INTO `sys_role_permission` VALUES (52, 1, 76);
INSERT INTO `sys_role_permission` VALUES (95, 1, 77);
INSERT INTO `sys_role_permission` VALUES (267, 2, 23);
INSERT INTO `sys_role_permission` VALUES (271, 2, 28);
INSERT INTO `sys_role_permission` VALUES (272, 2, 32);
INSERT INTO `sys_role_permission` VALUES (273, 2, 38);
INSERT INTO `sys_role_permission` VALUES (274, 2, 43);
INSERT INTO `sys_role_permission` VALUES (275, 2, 47);
INSERT INTO `sys_role_permission` VALUES (276, 2, 51);
INSERT INTO `sys_role_permission` VALUES (277, 2, 55);
INSERT INTO `sys_role_permission` VALUES (278, 2, 57);
INSERT INTO `sys_role_permission` VALUES (279, 2, 58);
INSERT INTO `sys_role_permission` VALUES (280, 2, 59);
INSERT INTO `sys_role_permission` VALUES (281, 2, 61);
INSERT INTO `sys_role_permission` VALUES (282, 2, 62);
INSERT INTO `sys_role_permission` VALUES (283, 2, 63);
INSERT INTO `sys_role_permission` VALUES (284, 2, 66);
INSERT INTO `sys_role_permission` VALUES (285, 2, 68);
INSERT INTO `sys_role_permission` VALUES (286, 2, 69);
INSERT INTO `sys_role_permission` VALUES (287, 2, 70);
INSERT INTO `sys_role_permission` VALUES (288, 2, 72);
INSERT INTO `sys_role_permission` VALUES (289, 2, 73);
INSERT INTO `sys_role_permission` VALUES (290, 2, 74);
INSERT INTO `sys_role_permission` VALUES (268, 2, 75);
INSERT INTO `sys_role_permission` VALUES (269, 2, 76);
INSERT INTO `sys_role_permission` VALUES (270, 2, 77);
INSERT INTO `sys_role_permission` VALUES (159, 3, 23);
INSERT INTO `sys_role_permission` VALUES (160, 3, 38);
INSERT INTO `sys_role_permission` VALUES (152, 3, 43);
INSERT INTO `sys_role_permission` VALUES (147, 3, 51);
INSERT INTO `sys_role_permission` VALUES (153, 3, 55);
INSERT INTO `sys_role_permission` VALUES (155, 3, 59);
INSERT INTO `sys_role_permission` VALUES (151, 3, 63);
INSERT INTO `sys_role_permission` VALUES (156, 3, 66);
INSERT INTO `sys_role_permission` VALUES (150, 3, 70);
INSERT INTO `sys_role_permission` VALUES (148, 3, 71);
INSERT INTO `sys_role_permission` VALUES (149, 3, 72);
INSERT INTO `sys_role_permission` VALUES (154, 3, 74);
INSERT INTO `sys_role_permission` VALUES (158, 3, 75);
INSERT INTO `sys_role_permission` VALUES (146, 3, 76);
INSERT INTO `sys_role_permission` VALUES (157, 3, 77);
INSERT INTO `sys_role_permission` VALUES (174, 4, 23);
INSERT INTO `sys_role_permission` VALUES (175, 4, 38);
INSERT INTO `sys_role_permission` VALUES (168, 4, 43);
INSERT INTO `sys_role_permission` VALUES (162, 4, 51);
INSERT INTO `sys_role_permission` VALUES (169, 4, 55);
INSERT INTO `sys_role_permission` VALUES (171, 4, 59);
INSERT INTO `sys_role_permission` VALUES (167, 4, 63);
INSERT INTO `sys_role_permission` VALUES (166, 4, 70);
INSERT INTO `sys_role_permission` VALUES (163, 4, 71);
INSERT INTO `sys_role_permission` VALUES (164, 4, 72);
INSERT INTO `sys_role_permission` VALUES (165, 4, 73);
INSERT INTO `sys_role_permission` VALUES (170, 4, 74);
INSERT INTO `sys_role_permission` VALUES (173, 4, 75);
INSERT INTO `sys_role_permission` VALUES (161, 4, 76);
INSERT INTO `sys_role_permission` VALUES (172, 4, 77);
INSERT INTO `sys_role_permission` VALUES (187, 5, 38);
INSERT INTO `sys_role_permission` VALUES (180, 5, 43);
INSERT INTO `sys_role_permission` VALUES (178, 5, 51);
INSERT INTO `sys_role_permission` VALUES (177, 5, 52);
INSERT INTO `sys_role_permission` VALUES (179, 5, 53);
INSERT INTO `sys_role_permission` VALUES (184, 5, 59);
INSERT INTO `sys_role_permission` VALUES (182, 5, 60);
INSERT INTO `sys_role_permission` VALUES (183, 5, 62);
INSERT INTO `sys_role_permission` VALUES (181, 5, 74);
INSERT INTO `sys_role_permission` VALUES (186, 5, 75);
INSERT INTO `sys_role_permission` VALUES (176, 5, 76);
INSERT INTO `sys_role_permission` VALUES (185, 5, 77);
INSERT INTO `sys_role_permission` VALUES (205, 6, 38);
INSERT INTO `sys_role_permission` VALUES (194, 6, 43);
INSERT INTO `sys_role_permission` VALUES (193, 6, 44);
INSERT INTO `sys_role_permission` VALUES (195, 6, 45);
INSERT INTO `sys_role_permission` VALUES (201, 6, 47);
INSERT INTO `sys_role_permission` VALUES (200, 6, 48);
INSERT INTO `sys_role_permission` VALUES (202, 6, 49);
INSERT INTO `sys_role_permission` VALUES (198, 6, 55);
INSERT INTO `sys_role_permission` VALUES (196, 6, 56);
INSERT INTO `sys_role_permission` VALUES (197, 6, 58);
INSERT INTO `sys_role_permission` VALUES (192, 6, 63);
INSERT INTO `sys_role_permission` VALUES (199, 6, 74);
INSERT INTO `sys_role_permission` VALUES (204, 6, 75);
INSERT INTO `sys_role_permission` VALUES (191, 6, 76);
INSERT INTO `sys_role_permission` VALUES (203, 6, 77);
INSERT INTO `sys_role_permission` VALUES (221, 7, 38);
INSERT INTO `sys_role_permission` VALUES (218, 7, 39);
INSERT INTO `sys_role_permission` VALUES (222, 7, 40);
INSERT INTO `sys_role_permission` VALUES (219, 7, 41);
INSERT INTO `sys_role_permission` VALUES (220, 7, 42);
INSERT INTO `sys_role_permission` VALUES (210, 7, 43);
INSERT INTO `sys_role_permission` VALUES (208, 7, 63);
INSERT INTO `sys_role_permission` VALUES (209, 7, 64);
INSERT INTO `sys_role_permission` VALUES (207, 7, 65);
INSERT INTO `sys_role_permission` VALUES (215, 7, 66);
INSERT INTO `sys_role_permission` VALUES (212, 7, 67);
INSERT INTO `sys_role_permission` VALUES (213, 7, 68);
INSERT INTO `sys_role_permission` VALUES (214, 7, 69);
INSERT INTO `sys_role_permission` VALUES (211, 7, 74);
INSERT INTO `sys_role_permission` VALUES (217, 7, 75);
INSERT INTO `sys_role_permission` VALUES (206, 7, 76);
INSERT INTO `sys_role_permission` VALUES (216, 7, 77);
INSERT INTO `sys_role_permission` VALUES (239, 8, 70);
INSERT INTO `sys_role_permission` VALUES (238, 8, 71);
INSERT INTO `sys_role_permission` VALUES (241, 8, 75);
INSERT INTO `sys_role_permission` VALUES (237, 8, 76);
INSERT INTO `sys_role_permission` VALUES (240, 8, 77);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录账号',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（加密存储）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '真实姓名',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-正常 0-停用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'staff' COMMENT '角色：admin-管理员 manager-经理 staff-员工 finance-财务',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_dept_id`(`dept_id` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '管理员张三', 2, '13800138000', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-08-17 14:46:25', 'admin');
INSERT INTO `sys_user` VALUES (2, 'manager', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '部门经理李四', 4, '13800138001', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-08-17 14:46:32', 'manager');
INSERT INTO `sys_user` VALUES (3, 'finance', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '财务王五', 3, '13800138002', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-08-17 14:46:37', 'finance');
INSERT INTO `sys_user` VALUES (4, 'sales', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '销售赵六', 4, '13800138003', '123@126.com', NULL, 1, '2026-07-28 19:35:07', '2026-08-17 15:10:02', 'staff');
INSERT INTO `sys_user` VALUES (5, 'purchaser', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '采购钱七', 5, '13800138004', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-08-17 14:46:48', 'staff');
INSERT INTO `sys_user` VALUES (6, 'inventory', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '库管孙八', 6, '13800138005', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-08-17 14:46:55', 'staff');
INSERT INTO `sys_user` VALUES (7, 'staff', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '员工周九', 4, '13800138006', NULL, NULL, 1, '2026-07-28 19:35:07', '2026-08-17 14:47:02', 'staff');
INSERT INTO `sys_user` VALUES (8, 'gm', '$2a$10$tBa7b2HN743ayMCnEn/FJ.ElisEoLeTHZ5SgdGA6TWLlGmCp4w63O', '总经理', 2, '13800138001', NULL, NULL, 1, '2026-08-04 16:40:31', '2026-08-12 23:41:45', 'gm');
INSERT INTO `sys_user` VALUES (9, 'test', '$2a$10$To00j0/AHWv9rEbsnpo3KuW6QvD7I4leqHBLy.KZFXqIIAZOLxOXS', '测试', 7, '', '', NULL, 1, '2026-08-17 16:22:23', '2026-08-17 16:22:23', 'staff');

-- ----------------------------
-- Table structure for sys_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_dept`;
CREATE TABLE `sys_user_dept`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（关联sys_user.id）',
  `dept_id` bigint NOT NULL COMMENT '部门ID（关联sys_department.id）',
  `is_main` tinyint NULL DEFAULT 1 COMMENT '是否主部门：1-是 0-否',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_dept_id`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户-部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_dept
-- ----------------------------
INSERT INTO `sys_user_dept` VALUES (1, 1, 2, 1, '2026-08-11 17:38:37');
INSERT INTO `sys_user_dept` VALUES (2, 8, 2, 1, '2026-08-11 17:38:37');
INSERT INTO `sys_user_dept` VALUES (4, 3, 3, 1, '2026-08-11 17:38:37');
INSERT INTO `sys_user_dept` VALUES (6, 7, 4, 1, '2026-08-11 17:38:37');
INSERT INTO `sys_user_dept` VALUES (7, 5, 5, 1, '2026-08-11 17:38:37');
INSERT INTO `sys_user_dept` VALUES (8, 6, 6, 1, '2026-08-11 17:38:37');
INSERT INTO `sys_user_dept` VALUES (9, 2, 3, 0, '2026-08-16 22:33:22');
INSERT INTO `sys_user_dept` VALUES (10, 2, 4, 1, '2026-08-16 22:33:22');
INSERT INTO `sys_user_dept` VALUES (11, 4, 4, 1, '2026-08-17 15:10:02');
INSERT INTO `sys_user_dept` VALUES (12, 9, 7, 1, '2026-08-17 16:22:23');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (3, 3);
INSERT INTO `sys_user_role` VALUES (4, 4);
INSERT INTO `sys_user_role` VALUES (5, 5);
INSERT INTO `sys_user_role` VALUES (6, 6);
INSERT INTO `sys_user_role` VALUES (7, 7);

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 1, 1);
INSERT INTO `user_role` VALUES (3, 2, 3);
INSERT INTO `user_role` VALUES (10, 3, 3);
INSERT INTO `user_role` VALUES (9, 3, 4);
INSERT INTO `user_role` VALUES (5, 4, 5);
INSERT INTO `user_role` VALUES (6, 5, 6);
INSERT INTO `user_role` VALUES (7, 6, 7);
INSERT INTO `user_role` VALUES (8, 7, 8);
INSERT INTO `user_role` VALUES (2, 8, 2);

-- ----------------------------
-- Table structure for warehouse
-- ----------------------------
DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '仓库ID',
  `warehouse_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库编码',
  `warehouse_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `manager` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-启用 0-停用',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `warehouse_code`(`warehouse_code` ASC) USING BTREE,
  INDEX `idx_warehouse_code`(`warehouse_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '仓库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of warehouse
-- ----------------------------
INSERT INTO `warehouse` VALUES (1, 'WH001', '主仓库', NULL, NULL, NULL, 1, NULL, '2026-07-31 14:29:02', '2026-07-31 14:29:02');
INSERT INTO `warehouse` VALUES (2, '222', '222', '222', '222', '13322222222', 0, NULL, '2026-08-02 23:31:15', '2026-08-03 17:23:17');
INSERT INTO `warehouse` VALUES (4, 'WH20260803-0001', '333', '333', '333', '13333333333', 1, NULL, '2026-08-03 17:23:28', '2026-08-03 17:23:28');

SET FOREIGN_KEY_CHECKS = 1;
