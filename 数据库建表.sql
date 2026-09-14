-- ============================================
-- ERP系统数据库建表SQL
-- 数据库：erp_db
-- 字符集：utf8mb4
-- ============================================

USE erp_db;

-- --------------------------------------------
-- 1. 部门表
-- --------------------------------------------
DROP TABLE IF EXISTS sys_department;
CREATE TABLE sys_department (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '部门ID',
    dept_name VARCHAR(50) NOT NULL COMMENT '部门名称',
    parent_id BIGINT DEFAULT 0 COMMENT '父部门ID，0表示根部门',
    sort INT DEFAULT 0 COMMENT '排序号',
    leader VARCHAR(50) COMMENT '负责人',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_parent_id (parent_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='部门表';

-- --------------------------------------------
-- 2. 角色表
-- --------------------------------------------
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(200) COMMENT '角色描述',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- --------------------------------------------
-- 3. 用户表
-- --------------------------------------------
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录账号',
    password VARCHAR(100) NOT NULL COMMENT '密码（加密存储）',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    dept_id BIGINT COMMENT '部门ID',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    avatar VARCHAR(255) COMMENT '头像URL',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_dept_id (dept_id),
    INDEX idx_username (username),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- --------------------------------------------
-- 4. 用户角色关联表
-- --------------------------------------------
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    PRIMARY KEY (user_id, role_id),
    INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

CREATE TABLE `user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 接口权限表：存储所有后端接口的权限配置
DROP TABLE IF EXISTS sys_permission;
CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `permission_name` varchar(100) NOT NULL COMMENT '权限名称，如"用户新增"',
  `permission_code` varchar(100) NOT NULL COMMENT '权限编码，如"USER_ADD"',
  `api_path` varchar(200) NOT NULL COMMENT '接口路径，如"/user/add"',
  `api_method` varchar(10) NOT NULL COMMENT '请求方法，如"POST"',
  `description` varchar(255) DEFAULT NULL COMMENT '权限描述',
  `status` tinyint DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_code` (`permission_code`),
  UNIQUE KEY `uk_api_path_method` (`api_path`,`api_method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接口权限表';

-- 角色权限关联表：存储角色和权限的对应关系
DROP TABLE IF EXISTS sys_role_permission;
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 1. 新增用户-部门多对多中间表（支持一人多部门）
DROP TABLE IF EXISTS sys_user_dept;
CREATE TABLE sys_user_dept (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID（关联sys_user.id）',
    dept_id BIGINT NOT NULL COMMENT '部门ID（关联sys_department.id）',
    is_main TINYINT DEFAULT 1 COMMENT '是否主部门：1-是 0-否',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_dept (user_id, dept_id),
    INDEX idx_user_id (user_id),
    INDEX idx_dept_id (dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户-部门关联表';
-- --------------------------------------------
-- 5. 字典表
-- --------------------------------------------
DROP TABLE IF EXISTS sys_dict;
CREATE TABLE sys_dict (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '字典ID',
    dict_type VARCHAR(50) NOT NULL COMMENT '字典类型',
    dict_label VARCHAR(100) NOT NULL COMMENT '字典标签（显示的文字）',
    dict_value VARCHAR(100) NOT NULL COMMENT '字典值（实际存储的值）',
    sort INT DEFAULT 0 COMMENT '排序号',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    remark VARCHAR(200) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_dict_type (dict_type),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典表';

-- --------------------------------------------
-- 6. 商品/物料表（17个属性，严格执行）
-- --------------------------------------------
DROP TABLE IF EXISTS product;
CREATE TABLE product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '商品ID',
    sku_code VARCHAR(50) NOT NULL UNIQUE COMMENT '商品编码（SKU）',
    product_name VARCHAR(200) NOT NULL COMMENT '商品名称',
    mnemonic_code VARCHAR(50) COMMENT '助记码（拼音首字母）',
    category_id BIGINT COMMENT '商品分类ID（关联字典表）',
    spec VARCHAR(200) COMMENT '商品规格',
    model VARCHAR(100) COMMENT '商品型号',
    unit VARCHAR(20) COMMENT '计量单位（台/个/箱/公斤）',
    barcode VARCHAR(100) UNIQUE COMMENT '条形码',
    cost_price DECIMAL(10,2) DEFAULT 0.00 COMMENT '成本价',
    sale_price DECIMAL(10,2) DEFAULT 0.00 COMMENT '销售价',
    min_stock INT DEFAULT 0 COMMENT '最低库存预警',
    max_stock INT DEFAULT 0 COMMENT '最高库存预警',
    supplier_id BIGINT COMMENT '默认供应商ID',
    shelf_life INT DEFAULT 0 COMMENT '保质期天数（0表示无保质期）',
    storage_location VARCHAR(100) COMMENT '存放位置（如：A区3排5号）',
    status TINYINT DEFAULT 1 COMMENT '状态：1-启用 0-停用',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_sku_code (sku_code),
    INDEX idx_product_name (product_name),
    INDEX idx_category_id (category_id),
    INDEX idx_barcode (barcode),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品/物料表';

-- --------------------------------------------
-- 7. 供应商表
-- --------------------------------------------
DROP TABLE IF EXISTS supplier;
CREATE TABLE supplier (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '供应商ID',
    supplier_name VARCHAR(200) NOT NULL COMMENT '供应商名称',
    contact_person VARCHAR(50) COMMENT '联系人',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    address VARCHAR(500) COMMENT '地址',
    bank_name VARCHAR(100) COMMENT '开户行',
    bank_account VARCHAR(50) COMMENT '银行账号',
    tax_number VARCHAR(50) COMMENT '税号',
    initial_payable DECIMAL(10,2) DEFAULT 0.00 COMMENT '期初应付款',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_supplier_name (supplier_name),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

-- 检查是否有supplier_code字段
ALTER TABLE supplier ADD COLUMN supplier_code VARCHAR(50) UNIQUE COMMENT '供应商编码';
UPDATE supplier SET supplier_code = CONCAT('SUP', LPAD(id, 3, '0')) WHERE supplier_code IS NULL;

-- --------------------------------------------
-- 8. 客户表
-- --------------------------------------------
DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '客户ID',
    customer_name VARCHAR(200) NOT NULL COMMENT '客户名称',
    contact_person VARCHAR(50) COMMENT '联系人',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    address VARCHAR(500) COMMENT '地址',
    level VARCHAR(20) COMMENT '客户等级（普通/VIP/战略）',
    credit_limit DECIMAL(10,2) DEFAULT 0.00 COMMENT '信用额度',
    initial_receivable DECIMAL(10,2) DEFAULT 0.00 COMMENT '期初应收款',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_customer_name (customer_name),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户表';

ALTER TABLE customer ADD COLUMN customer_code VARCHAR(50) UNIQUE COMMENT '客户编码';
UPDATE customer SET customer_code = CONCAT('CUS', LPAD(id, 3, '0')) WHERE customer_code IS NULL;

-- --------------------------------------------
-- 9. 仓库表
-- --------------------------------------------
DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '仓库ID',
    warehouse_name VARCHAR(100) NOT NULL COMMENT '仓库名称',
    warehouse_code VARCHAR(50) NOT NULL UNIQUE COMMENT '仓库编码',
    address VARCHAR(500) COMMENT '仓库地址',
    keeper VARCHAR(50) COMMENT '保管员',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常 0-停用',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库表';

DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '仓库ID',
    warehouse_code VARCHAR(50) NOT NULL UNIQUE COMMENT '仓库编码',
    warehouse_name VARCHAR(100) NOT NULL COMMENT '仓库名称',
    address VARCHAR(200) COMMENT '地址',
    manager VARCHAR(50) COMMENT '负责人',
    phone VARCHAR(20) COMMENT '联系电话',
    status TINYINT DEFAULT 1 COMMENT '状态：1-启用 0-停用',
    remark VARCHAR(200) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_warehouse_code (warehouse_code),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库表';

-- 初始化一个默认仓库
INSERT INTO warehouse (warehouse_code, warehouse_name, status) VALUES ('WH001', '主仓库', 1);

-- --------------------------------------------
-- 10. 库存表（实时库存）
-- --------------------------------------------
DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '库存ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    warehouse_id BIGINT NOT NULL COMMENT '仓库ID',
    quantity INT DEFAULT 0 COMMENT '当前库存数量',
    lock_quantity INT DEFAULT 0 COMMENT '锁定数量（已开单但未出库）',
    cost_price DECIMAL(10,2) COMMENT '成本价（冗余字段，便于查询）',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_product_warehouse (product_id, warehouse_id),
    INDEX idx_product_id (product_id),
    INDEX idx_warehouse_id (warehouse_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

DROP TABLE IF EXISTS inventory_flow;
CREATE TABLE inventory_flow (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '流水ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    warehouse_id BIGINT NOT NULL COMMENT '仓库ID',
    flow_type VARCHAR(20) NOT NULL COMMENT '类型：PURCHASE_IN-采购入库 SALE_OUT-销售出库 STOCK_CHECK-盘点',
    quantity_change INT NOT NULL COMMENT '变动数量（正数入库，负数出库）',
    quantity_after INT NOT NULL COMMENT '变动后库存',
    related_order_no VARCHAR(50) COMMENT '关联单号',
    operator_id BIGINT COMMENT '操作人ID',
    flow_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发生时间',
    remark VARCHAR(200) COMMENT '备注',
    INDEX idx_product_warehouse (product_id, warehouse_id),
    INDEX idx_flow_time (flow_time),
    INDEX idx_related_order_no (related_order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存流水表';

-- --------------------------------------------
-- 11. 采购入库单头表
-- --------------------------------------------
DROP TABLE IF EXISTS purchase_order;
CREATE TABLE purchase_order (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '采购单ID',
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '采购单号（系统自动生成）',
    supplier_id BIGINT NOT NULL COMMENT '供应商ID',
    warehouse_id BIGINT NOT NULL COMMENT '入库仓库ID',
    total_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT '总金额',
    status TINYINT DEFAULT 0 COMMENT '状态：0-草稿 1-已入库 2-已取消',
    purchaser_id BIGINT COMMENT '采购员ID',
    order_date DATE COMMENT '采购日期',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_order_no (order_no),
    INDEX idx_supplier_id (supplier_id),
    INDEX idx_status (status),
    INDEX idx_order_date (order_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购入库单头表';

-- --------------------------------------------
-- 12. 采购入库单明细表
-- --------------------------------------------
DROP TABLE IF EXISTS purchase_order_item;
CREATE TABLE purchase_order_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
    order_id BIGINT NOT NULL COMMENT '采购单ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    quantity INT NOT NULL COMMENT '数量',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额（数量×单价）',
    remark VARCHAR(200) COMMENT '备注',
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购入库单明细表';

-- --------------------------------------------
-- 13. 销售出库单头表
-- --------------------------------------------
DROP TABLE IF EXISTS sales_order;
CREATE TABLE sales_order (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '销售单ID',
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '销售单号（系统自动生成）',
    customer_id BIGINT NOT NULL COMMENT '客户ID',
    warehouse_id BIGINT NOT NULL COMMENT '出库仓库ID',
    total_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT '总金额',
    status TINYINT DEFAULT 0 COMMENT '状态：0-草稿 1-已出库 2-已取消',
    salesman_id BIGINT COMMENT '销售员ID',
    order_date DATE COMMENT '销售日期',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_order_no (order_no),
    INDEX idx_customer_id (customer_id),
    INDEX idx_status (status),
    INDEX idx_order_date (order_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售出库单头表';

-- --------------------------------------------
-- 14. 销售出库单明细表
-- --------------------------------------------
DROP TABLE IF EXISTS sales_order_item;
CREATE TABLE sales_order_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
    order_id BIGINT NOT NULL COMMENT '销售单ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    quantity INT NOT NULL COMMENT '数量',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额（数量×单价）',
    remark VARCHAR(200) COMMENT '备注',
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售出库单明细表';

-- --------------------------------------------
-- 15. 库存盘点单表
-- --------------------------------------------
DROP TABLE IF EXISTS stock_check;
CREATE TABLE stock_check (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '盘点单ID',
    check_no VARCHAR(50) NOT NULL UNIQUE COMMENT '盘点单号',
    warehouse_id BIGINT NOT NULL COMMENT '仓库ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    book_quantity INT NOT NULL COMMENT '账面数量',
    actual_quantity INT NOT NULL COMMENT '实际数量',
    difference INT GENERATED ALWAYS AS (actual_quantity - book_quantity) COMMENT '差异数量（自动计算）',
    reason VARCHAR(200) COMMENT '差异原因',
    status TINYINT DEFAULT 0 COMMENT '状态：0-草稿 1-已审核',
    checker_id BIGINT COMMENT '盘点人ID',
    check_date DATE COMMENT '盘点日期',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_check_no (check_no),
    INDEX idx_warehouse_id (warehouse_id),
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存盘点表';

-- --------------------------------------------
-- 16. 报销单头表
-- --------------------------------------------
DROP TABLE IF EXISTS expense_form;
CREATE TABLE expense_form (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '报销单ID',
    form_no VARCHAR(50) NOT NULL UNIQUE COMMENT '报销单号',
    applicant_id BIGINT NOT NULL COMMENT '申请人ID',
    dept_id BIGINT NOT NULL COMMENT '所属部门ID',
    apply_date DATE NOT NULL COMMENT '申请日期',
    total_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT '报销总金额',
    reason VARCHAR(500) COMMENT '报销事由',
    current_approver_id BIGINT COMMENT '当前审批人ID',
    status TINYINT DEFAULT 0 COMMENT '状态：0-草稿 1-审批中 2-已通过 3-已驳回 4-已付款',
    payment_date DATE COMMENT '付款日期',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_form_no (form_no),
    INDEX idx_applicant_id (applicant_id),
    INDEX idx_status (status),
    INDEX idx_apply_date (apply_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报销单头表';
ALTER TABLE expense_form ADD COLUMN attachment_urls VARCHAR(500) COMMENT '发票附件URL，多个用逗号分隔';

-- --------------------------------------------
-- 17. 报销单明细表
-- --------------------------------------------
DROP TABLE IF EXISTS expense_item;
CREATE TABLE expense_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
    form_id BIGINT NOT NULL COMMENT '报销单ID',
    expense_type_id BIGINT NOT NULL COMMENT '费用类型ID（关联字典表）',
    expense_date DATE NOT NULL COMMENT '费用发生日期',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额',
    invoice_count INT DEFAULT 0 COMMENT '发票张数',
    invoice_image VARCHAR(255) COMMENT '发票图片URL',
    remark VARCHAR(200) COMMENT '备注',
    INDEX idx_form_id (form_id),
    INDEX idx_expense_type_id (expense_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报销单明细表';

-- --------------------------------------------
-- 18. 审批记录表
-- --------------------------------------------
DROP TABLE IF EXISTS approval_record;
CREATE TABLE approval_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '审批记录ID',
    form_id BIGINT NOT NULL COMMENT '单据ID（报销单ID等）',
    form_type VARCHAR(50) NOT NULL COMMENT '单据类型（expense/purchase等）',
    approver_id BIGINT NOT NULL COMMENT '审批人ID',
    approve_result TINYINT NOT NULL COMMENT '审批结果：1-同意 0-驳回',
    approve_comment VARCHAR(500) COMMENT '审批意见',
    approve_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '审批时间',
    level INT NOT NULL COMMENT '审批层级（第几级审批）',
    INDEX idx_form_id (form_id),
    INDEX idx_form_type (form_type),
    INDEX idx_approver_id (approver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审批记录表';

-- --------------------------------------------
-- 19. 操作日志表
-- --------------------------------------------
DROP TABLE IF EXISTS operation_log;
CREATE TABLE operation_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id BIGINT COMMENT '操作用户ID',
    username VARCHAR(50) COMMENT '用户名',
    module VARCHAR(50) COMMENT '操作模块',
    action VARCHAR(100) COMMENT '操作动作',
    method VARCHAR(200) COMMENT '请求方法',
    params TEXT COMMENT '请求参数',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    status TINYINT COMMENT '状态：1-成功 0-失败',
    error_msg VARCHAR(500) COMMENT '错误信息',
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    INDEX idx_user_id (user_id),
    INDEX idx_module (module),
    INDEX idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- 先删掉生成列
ALTER TABLE stock_check DROP COLUMN difference;

-- 再加回普通字段
ALTER TABLE stock_check ADD COLUMN difference INT COMMENT '差异数量' AFTER actual_quantity;

ALTER TABLE stock_check ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
CREATE TABLE `stock_check` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '盘点单ID',
  `check_no` varchar(50) NOT NULL COMMENT '盘点单号',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `book_quantity` int NOT NULL COMMENT '账面数量',
  `actual_quantity` int NOT NULL COMMENT '实际数量',
  `difference` int DEFAULT NULL COMMENT '差异数量',
  `reason` varchar(200) DEFAULT NULL COMMENT '差异原因',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-草稿 1-已审核',
  `checker_id` bigint DEFAULT NULL COMMENT '盘点人ID',
  `check_date` date DEFAULT NULL COMMENT '盘点日期',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `check_no` (`check_no`),
  KEY `idx_check_no` (`check_no`),
  KEY `idx_warehouse_id` (`warehouse_id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库存盘点表'

-- ============================================
-- 初始数据插入
-- ============================================

-- 部门初始数据
INSERT INTO sys_department (dept_name, parent_id, leader, sort) VALUES
('总公司', 0, '张三', 1),
('总经办', 1, '张三', 1),
('财务部', 1, '李四', 2),
('销售部', 1, '王五', 3),
('采购部', 1, '赵六', 4),
('仓储部', 1, '钱七', 5);

-- 角色初始数据
INSERT INTO sys_role (role_name, role_code, description) VALUES
('超级管理员', 'SUPER_ADMIN', '系统最高权限'),
('总经理', 'GM', '公司总经理，审批大额报销'),
('部门经理', 'DEPT_MANAGER', '部门负责人，审批本部门报销'),
('财务', 'FINANCE', '财务人员，审核报销、确认付款'),
('销售员', 'SALES', '销售人员，开具销售单'),
('采购员', 'PURCHASER', '采购人员，开具采购单'),
('仓管员', 'INVENTORY', '仓库管理人员，执行出入库'),
('普通员工', 'STAFF', '普通员工，提交报销');

-- 用户初始数据（密码：123456，实际开发中要用BCrypt加密）
-- 这里先用明文，后面教你加密
INSERT INTO sys_user (username, password, real_name, dept_id, phone, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '张三', 2, '13800138000', 1),
('gm', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '总经理', 3, '13800138001', 1),
('manager', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '李四', 3, '13800138001', 1),
('finance', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '王五', 3, '13800138002', 1),
('sales', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '赵六', 4, '13800138003', 1),
('purchaser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '钱七', 5, '13800138004', 1),
('inventory', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '孙八', 6, '13800138005', 1),
('staff', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iYqiSfSYt5Hc9VVdKqY7Z8J5Q5Q5', '周九', 4, '13800138006', 1);

-- 用户角色关联
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 1),  -- admin -> 超级管理员
(2, 2),  -- manager -> 总经理
(3, 3),  -- finance -> 财务
(4, 4),  -- sales -> 销售员
(5, 5),  -- purchaser -> 采购员
(6, 6),  -- inventory -> 仓管员
(7, 7);  -- staff -> 普通员工

-- 字典初始数据
-- 商品分类
INSERT INTO sys_dict (dict_type, dict_label, dict_value, sort) VALUES
('product_category', '电子产品', '1', 1),
('product_category', '办公用品', '2', 2),
('product_category', '劳保用品', '3', 3),
('product_category', '原材料', '4', 4),
('product_category', '成品', '5', 5);

-- 计量单位
INSERT INTO sys_dict (dict_type, dict_label, dict_value, sort) VALUES
('unit', '台', '1', 1),
('unit', '个', '2', 2),
('unit', '箱', '3', 3),
('unit', '公斤', '4', 4),
('unit', '米', '5', 5),
('unit', '套', '6', 6);

-- 费用类型
INSERT INTO sys_dict (dict_type, dict_label, dict_value, sort) VALUES
('expense_type', '差旅费', '1', 1),
('expense_type', '交通费', '2', 2),
('expense_type', '招待费', '3', 3),
('expense_type', '办公费', '4', 4),
('expense_type', '通讯费', '5', 5),
('expense_type', '其他', '6', 6);

-- 仓库初始数据
INSERT INTO warehouse (warehouse_name, warehouse_code, keeper) VALUES
('主仓库', 'WH001', '孙八'),
('样品库', 'WH002', '孙八');


-- ============================================================
-- 1. 角色表 sys_role（若已有数据，INSERT IGNORE 不会重复插入）
-- ============================================================
INSERT IGNORE INTO sys_role (id, role_name, role_code, description, status) VALUES
(1, '超级管理员', 'ADMIN',       '系统最高权限', 1),
(2, '总经理',     'GM',           '公司总经理，审批大额报销', 1),
(3, '部门经理',   'DEPT_MANAGER','部门负责人，审批本部门报销', 1),
(4, '财务',       'FINANCE',     '财务人员，审核报销、确认付款', 1),
(5, '销售员',     'SALES',       '销售人员，开具销售单', 1),
(6, '采购员',     'PURCHASER',   '采购人员，开具采购单', 1),
(7, '仓管员',     'INVENTORY',   '仓库管理人员，执行出入库', 1),
(8, '普通员工',   'STAFF',       '普通员工，提交报销', 1);

-- ============================================================
-- 2. 权限表 sys_permission（接口级权限，全部接口全覆盖）
-- ============================================================
INSERT IGNORE INTO sys_permission (permission_name, permission_code, api_path, api_method, description, status) VALUES
-- 用户管理
('用户列表',     'USER_LIST',       '/user/list',           'GET',    '查询用户列表', 1),
('用户新增',     'USER_ADD',       '/user/add',           'POST',   '新增用户', 1),
('用户修改',     'USER_UPDATE',    '/user/update',        'PUT',    '修改用户', 1),
('用户删除',     'USER_DELETE',    '/user/delete',        'DELETE', '删除用户', 1),
('用户分配角色', 'USER_ASSIGN',    '/user/assign-roles',  'POST',   '分配用户角色', 1),
-- 角色管理
('角色列表',     'ROLE_LIST',      '/role/list',          'GET',    '查询角色列表', 1),
('角色新增',     'ROLE_ADD',      '/role/add',          'POST',   '新增角色', 1),
('角色修改',     'ROLE_UPDATE',    '/role/update',        'PUT',    '修改角色', 1),
('角色删除',     'ROLE_DELETE',    '/role/delete',        'DELETE', '删除角色', 1),
-- 权限管理
('权限列表',     'PERM_LIST',      '/permission/list',     'GET',    '查询权限列表', 1),
('权限新增',     'PERM_ADD',      '/permission/add',     'POST',   '新增权限', 1),
('权限修改',     'PERM_UPDATE',    '/permission/update',   'PUT',    '修改权限', 1),
('权限删除',     'PERM_DELETE',    '/permission/delete',   'DELETE', '删除权限', 1),
('角色权限查询', 'PERM_ROLE_QUERY','/permission/role',    'GET',    '查询角色权限', 1),
('角色权限分配', 'PERM_ROLE_ASSIGN','/permission/assign',  'POST',   '分配角色权限', 1),
-- 仓库管理
('仓库列表',     'WH_LIST',        '/warehouse/list',      'GET',    '查询仓库列表', 1),
('仓库新增',     'WH_ADD',        '/warehouse/add',      'POST',   '新增仓库', 1),
('仓库修改',     'WH_UPDATE',      '/warehouse/update',    'PUT',    '修改仓库', 1),
('仓库停用',     'WH_DISABLE',     '/warehouse/disable',   'PUT',    '停用仓库', 1),
('仓库启用',     'WH_ENABLE',      '/warehouse/enable',    'PUT',    '启用仓库', 1),
-- 商品管理
('商品列表',     'PRODUCT_LIST',   '/product/list',       'GET',    '查询商品列表', 1),
('商品新增',     'PRODUCT_ADD',    '/product/add',       'POST',   '新增商品', 1),
('商品修改',     'PRODUCT_UPDATE', '/product/update',     'PUT',    '修改商品', 1),
('商品删除',     'PRODUCT_DELETE', '/product/delete',     'DELETE', '删除商品', 1),
-- 供应商管理
('供应商列表',   'SUPPLIER_LIST',  '/supplier/list',      'GET',    '查询供应商列表', 1),
('供应商新增',   'SUPPLIER_ADD',   '/supplier/add',      'POST',   '新增供应商', 1),
('供应商修改',   'SUPPLIER_UPDATE','/supplier/update',    'PUT',    '修改供应商', 1),
('供应商删除',   'SUPPLIER_DELETE','/supplier/delete',    'DELETE', '删除供应商', 1),
-- 客户管理
('客户列表',     'CUSTOMER_LIST',  '/customer/list',      'GET',    '查询客户列表', 1),
('客户新增',     'CUSTOMER_ADD',   '/customer/add',      'POST',   '新增客户', 1),
('客户修改',     'CUSTOMER_UPDATE','/customer/update',    'PUT',    '修改客户', 1),
('客户删除',     'CUSTOMER_DELETE','/customer/delete',    'DELETE', '删除客户', 1),
-- 采购管理
('采购列表',     'PURCHASE_LIST',  '/purchase/list',      'GET',    '查询采购单', 1),
('采购新增',     'PURCHASE_ADD',   '/purchase/add',      'POST',   '新增采购单', 1),
('采购审批',     'PURCHASE_APPROVE','/purchase/approve',  'PUT',    '审批采购单', 1),
('采购删除',     'PURCHASE_DELETE','/purchase/delete',    'DELETE', '删除采购单', 1),
-- 销售管理
('销售列表',     'SALES_LIST',     '/sales/list',         'GET',    '查询销售单', 1),
('销售新增',     'SALES_ADD',      '/sales/add',         'POST',   '新增销售单', 1),
('销售审批',     'SALES_APPROVE',  '/sales/approve',     'PUT',    '审批销售单', 1),
('销售删除',     'SALES_DELETE',   '/sales/delete',      'DELETE', '删除销售单', 1),
-- 库存管理
('库存列表',     'INV_LIST',       '/inventory/list',     'GET',    '查询库存', 1),
('库存出库',     'INV_OUT',        '/inventory/out',      'POST',   '库存出库', 1),
('库存入库',     'INV_IN',         '/inventory/in',       'POST',   '库存入库', 1),
-- 盘点管理
('盘点列表',     'STOCK_LIST',     '/stock-check/list',   'GET',    '查询盘点单', 1),
('盘点新增',     'STOCK_ADD',      '/stock-check/add',    'POST',   '新增盘点单', 1),
('盘点审批',     'STOCK_APPROVE',  '/stock-check/approve','PUT',    '审批盘点单', 1),
('盘点删除',     'STOCK_DELETE',   '/stock-check/delete', 'DELETE', '删除盘点单', 1),
-- 报销管理
('报销列表',     'EXPENSE_LIST',   '/expense/list',       'GET',    '查询报销单', 1),
('报销新增',     'EXPENSE_ADD',    '/expense/add',       'POST',   '新增报销单', 1),
('报销审批',     'EXPENSE_APPROVE','/expense/approve',    'PUT',    '审批报销单', 1),
('报销删除',     'EXPENSE_DELETE', '/expense/delete',     'DELETE', '删除报销单', 1),
-- 报表
('报表查询',     'REPORT_QUERY',   '/report/**',          'GET',    '查询统计报表', 1),
-- 登录态
('获取用户信息', 'USER_INFO',      '/user/info',          'GET',    '获取当前用户信息', 1),
('修改密码',     'CHANGE_PWD',     '/user/change-password','POST',  '修改密码', 1),
('更新个人信息', 'UPDATE_PROFILE',  '/user/profile',       'PUT',    '更新个人信息', 1);

-- ============================================================
-- 3. 角色-权限关联 sys_role_permission（每个角色的默认权限，完整覆盖）
-- ============================================================

-- 3.1 ADMIN 拥有全部权限
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'ADMIN';

-- 3.2 GM（总经理）：看报表、审批采购/销售/报销/盘点，管理部门
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'GM'
AND p.permission_code IN (
  'USER_LIST','ROLE_LIST','PERM_LIST',
  'WH_LIST','PRODUCT_LIST','SUPPLIER_LIST','CUSTOMER_LIST',
  'PURCHASE_LIST','PURCHASE_APPROVE','PURCHASE_DELETE',
  'SALES_LIST','SALES_APPROVE','SALES_DELETE',
  'INV_LIST','STOCK_LIST','STOCK_APPROVE','STOCK_DELETE',
  'EXPENSE_LIST','EXPENSE_APPROVE','EXPENSE_DELETE',
  'REPORT_QUERY','USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- 3.3 DEPT_MANAGER（部门经理）：审批本部门报销，看本部门数据
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'DEPT_MANAGER'
AND p.permission_code IN (
  'USER_LIST','WH_LIST','PRODUCT_LIST','CUSTOMER_LIST',
  'PURCHASE_LIST','SALES_LIST','INV_LIST','STOCK_LIST',
  'EXPENSE_LIST','EXPENSE_APPROVE','EXPENSE_ADD',
  'REPORT_QUERY','USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- 3.4 FINANCE（财务）：报销审批、财务复核、报表
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'FINANCE'
AND p.permission_code IN (
  'USER_LIST','WH_LIST','PRODUCT_LIST','CUSTOMER_LIST',
  'PURCHASE_LIST','SALES_LIST','INV_LIST',
  'EXPENSE_LIST','EXPENSE_APPROVE','EXPENSE_DELETE','EXPENSE_ADD',
  'REPORT_QUERY','USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- 3.5 SALES（销售员）：销售单、客户、商品、报表查询
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'SALES'
AND p.permission_code IN (
  'CUSTOMER_LIST','CUSTOMER_ADD','CUSTOMER_UPDATE',
  'PRODUCT_LIST','WH_LIST',
  'SALES_LIST','SALES_ADD','SALES_DELETE',
  'REPORT_QUERY','USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- 3.6 PURCHASER（采购员）：采购单、供应商、商品
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'PURCHASER'
AND p.permission_code IN (
  'SUPPLIER_LIST','SUPPLIER_ADD','SUPPLIER_UPDATE',
  'PRODUCT_LIST','PRODUCT_ADD','PRODUCT_UPDATE',
  'WH_LIST','INV_LIST',
  'PURCHASE_LIST','PURCHASE_ADD','PURCHASE_DELETE',
  'REPORT_QUERY','USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- 3.7 INVENTORY（仓管员）：仓库、库存、盘点
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'INVENTORY'
AND p.permission_code IN (
  'WH_LIST','WH_ADD','WH_UPDATE','WH_DISABLE','WH_ENABLE',
  'PRODUCT_LIST','INV_LIST','INV_IN','INV_OUT',
  'STOCK_LIST','STOCK_ADD','STOCK_APPROVE','STOCK_DELETE',
  'REPORT_QUERY','USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- 3.8 STAFF（普通员工）：仅本人报销、查看个人信息
INSERT IGNORE INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.role_code = 'STAFF'
AND p.permission_code IN (
  'EXPENSE_LIST','EXPENSE_ADD',
  'USER_INFO','CHANGE_PWD','UPDATE_PROFILE'
);

-- ============================================================
-- 4. 用户-角色关联 user_role（给内置用户绑定默认角色）
-- ============================================================
-- 假设你的 sys_user 里已有这些账号；若用户名不同，请改成你实际的
INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'admin'    AND r.role_code = 'ADMIN';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'gm'        AND r.role_code = 'GM';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'manager'   AND r.role_code = 'DEPT_MANAGER';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'finance'   AND r.role_code = 'FINANCE';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'sales'     AND r.role_code = 'SALES';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'purchaser' AND r.role_code = 'PURCHASER';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'inventory' AND r.role_code = 'INVENTORY';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r
WHERE u.username = 'staff'     AND r.role_code = 'STAFF';

COMMIT;