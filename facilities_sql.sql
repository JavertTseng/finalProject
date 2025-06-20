-- 建立資料庫指令
-- CREATE DATABASE final_project COLLATE Chinese_Taiwan_Stroke_CI_AS; --

Use final_project;

DROP TABLE if exists facilities;
DROP TABLE if exists facility_images;
DROP TABLE if exists facility_reservation_table;

-- 公共設施表
CREATE TABLE facilities (
	facility_id INT IDENTITY(1,1) PRIMARY KEY,           -- 公設ID，自動遞增
	community_id INT,                                    -- 社區識別欄位
    facility_name NVARCHAR(100) NOT NULL,                -- 公設名稱
    facility_description NVARCHAR(255),                  -- 公設描述
    facility_location NVARCHAR(100) NOT NULL,            -- 公設地點
    open_time TIME NOT NULL,                             -- 開始營運時間
    close_time TIME NOT NULL,                            -- 結束營運時間
    reservable_duration INT,                             -- 單次可預約時長（單位：分鐘）
    fee INT DEFAULT 0 NOT NULL,                          -- 每次預約費用（單位：點數或元）
	facility_status NVARCHAR(20) DEFAULT 'acitve',       -- 使用狀態：啟用、停用、維修中等    
    created_at DATETIME DEFAULT GETDATE(),               -- 建立時間
    updated_at DATETIME                                  -- 最後更新時間
	--FOREIGN KEY (community_id) REFERENCES communities(community_id),
);

-- 公共設施圖片
CREATE TABLE facility_images (
    image_id INT IDENTITY(1,1) PRIMARY KEY,           -- 照片主鍵
    facility_id INT NOT NULL,                         -- 關聯公設
    base64_data NVARCHAR(MAX) NOT NULL,               -- Base64 照片內容
    image_description NVARCHAR(255),                  -- 照片說明（可選）
    sort_order INT DEFAULT 0 NOT NULL,                -- 照片排序值（小的排前面）
    created_at DATETIME DEFAULT GETDATE(),            -- 建立時間
	updated_at DATETIME                               -- 最後更新時間
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

-- 公設預約表
CREATE TABLE facility_reservation (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,          -- 預約紀錄 ID
    community_id INT,                                      -- 所屬社區 ID
    unit_id INT NOT NULL,                                  -- 預約者所屬住戶單位 ID
    created_by NVARCHAR(100) NOT NULL,                     -- 預約建立人（帳號或姓名）
    facility_id INT NOT NULL,                              -- 預約的設施 ID    
    number_of_users INT,                                   -- 使用人數
    reservation_start_time DATETIME NOT NULL,              -- 預約起始時間
    reservation_end_time DATETIME NOT NULL,                -- 預約結束時間    
    is_admin BIT NOT NULL DEFAULT 0,                       -- 是否為公用
    required_points INT,                                   -- 預約所需點數
    actual_used_points INT,                                -- 實際扣除點數
    remark NVARCHAR(255),                                  -- 備註
    reservation_status NVARCHAR(50) DEFAULT 'APPROVED',    -- 狀態（APPROVED、CANCELLED）
    created_at DATETIME DEFAULT GETDATE(),                 -- 建立時間
    updated_at DATETIME,                                   -- 最後修改時間   
    canceled_at DATETIME,                                  -- 取消時間（可為 NULL）
    cancel_reason NVARCHAR(255),                           -- 取消原因
    --FOREIGN KEY (community_id) REFERENCES communities(community_id),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
    -- FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);


-- 住戶點數帳戶表 (point_accounts)，記錄每戶當前可用點數
CREATE TABLE point_account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,        -- 帳戶編號
    community_id INT NOT NULL,                       -- 所屬社區
    unit_id INT NOT NULL,                            -- 所屬住戶單位
    total_balance INT DEFAULT 0,                     -- 總可用點數
    system_balance INT DEFAULT 0,                    -- 系統撥發點數（有效期限）
    topup_balance INT DEFAULT 0,                     -- 儲值點數（無效期限）
    updated_at DATETIME DEFAULT GETDATE(),           -- 最後更新時間
    CONSTRAINT UQ_unit_community UNIQUE (unit_id, community_id)
    -- FOREIGN KEY (community_id) REFERENCES communities(community_id)
    -- FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);

-- 2. 點數來源與效期明細表 (point_sources)
CREATE TABLE point_source (
    source_id INT IDENTITY(1,1) PRIMARY KEY,          -- 點數來源 ID
    community_id INT NOT NULL,                        -- 所屬社區
    unit_id INT NOT NULL,                             -- 所屬住戶單位
    source_type NVARCHAR(50) NOT NULL,                -- monthly、topup 等
    amount INT NOT NULL,                              -- 發放點數
    remaining INT NOT NULL,                           -- 剩餘可用點數
    issued_at DATETIME DEFAULT GETDATE(),             -- 發放時間
    expired_at DATETIME NULL,                         -- 到期時間（NULL 為永久）
    point_status NVARCHAR(20) DEFAULT 'active'        -- active / expired / used_up
    -- FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);

-- 3. 點數異動紀錄表 (point_transactions)
CREATE TABLE point_transaction (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,      -- 交易 ID
    community_id INT NOT NULL,                         -- 所屬社區
    unit_id INT NOT NULL,                              -- 當事住戶單位
    source_id INT NULL,                                -- 對應的點數來源
    change_type NVARCHAR(50) NOT NULL,                 -- reservation / cancel / topup / transfer_in / transfer_out...
    amount INT NOT NULL,                               -- 正為加點，負為扣點
    related_unit_id INT NULL,                          -- 轉移點數時的對象住戶
    transaction_description NVARCHAR(255),             -- 備註說明
    created_at DATETIME DEFAULT GETDATE(),             -- 建立時間
    FOREIGN KEY (source_id) REFERENCES point_source(source_id)
);














INSERT INTO product values (1,'Coca Cola',20, '2007-01-01',365);
INSERT INTO product values (2,'Milk Tea',15, '2007-02-14',150);
INSERT INTO product values (3,'Easy Coffe',10, '2007-10-01',200);
INSERT INTO product values (4,'Coffe Square',15, '2007-02-20',100);
INSERT INTO product values (5,'Cookie',25, '2007-03-27',45);
INSERT INTO product values (6,'Prince Noodle',5, '2007-04-02',365);
INSERT INTO product values (7,'Chicken Noodle',20, '2006-10-30',300);
INSERT INTO product values (8,'Qwi-Qwi',20, '2007-02-28',200);
INSERT INTO product values (9,'Ice Pop',15, '2007-05-30',150);
INSERT INTO product values (10,'HotDog',25, '2007-04-30',1);

/*==========================================================================*/

CREATE TABLE detail (
   photoid  integer primary key REFERENCES product(id),
   photo    image
);

/*==========================================================================*/

DROP TABLE if exists  customer;
CREATE TABLE customer (
   custid     varchar(20) primary key,
   password   varbinary(50),
   email      nvarchar(30),
   birth      datetime
);

INSERT INTO customer values ('Alex', 0x41, 'alex@lab.com', '2001-07-20');
INSERT INTO customer values ('Babe', 0x42, 'babe@lab.com', '2003-03-20');
INSERT INTO customer values ('Carol', 0x43, 'carol@lab.com', '2001-09-11');
INSERT INTO customer values ('Dave', 0x44, 'dave@lab.com', '2001-01-20');
INSERT INTO customer values ('Ellen', 0x45, 'ellen@lab.com', '2000-05-20');

/*==========================================================================*/
DROP TABLE if exists projemp;
DROP TABLE if exists proj;
DROP TABLE if exists emp;
DROP TABLE if exists dept;

CREATE TABLE dept (
  deptid     integer  primary key,
  deptname   NVARCHAR(20)
);

INSERT INTO DEPT VALUES (10, 'Java');
INSERT INTO DEPT VALUES (20, 'Delphi');
INSERT INTO DEPT VALUES (30, 'Visual Basic');

/*=====================================================================*/

CREATE TABLE proj (
  projid    integer  primary key,
  projname  NVARCHAR(50)
);

INSERT INTO PROJ VALUES (100, 'Online Shopping');
INSERT INTO PROJ VALUES (200, 'Mobile Banking');

/*=====================================================================*/

CREATE TABLE emp (
  empid     integer primary key identity,
  empname   NVARCHAR(10),
  salary    integer,
  sex       CHAR(1),
  photo     image,
  deptid    integer NOT NULL REFERENCES DEPT(DEPTID)
);

INSERT INTO EMP (EMPNAME, SALARY, SEX, DEPTID) VALUES ('Samuel', 10, 'M', 10);
INSERT INTO EMP (EMPNAME, SALARY, SEX, DEPTID) VALUES ('Crystal', 100, 'F', 30);
INSERT INTO EMP (EMPNAME, SALARY, SEX, DEPTID) VALUES ('Sammy', 1000, 'M', 10);
INSERT INTO EMP (EMPNAME, SALARY, SEX, DEPTID) VALUES ('Momo', 10000, 'M', 20);

/*=====================================================================*/

CREATE TABLE projemp (
  projid  integer,
  empid   integer,
  CONSTRAINT PK_PROJEMP_PROJIDEMPID PRIMARY KEY(PROJID, EMPID),
  CONSTRAINT FK_PROJEMP_PROJ_PROJID FOREIGN KEY(PROJID) REFERENCES PROJ(PROJID),
  CONSTRAINT FK_PROJEMP_EMP_EMPID FOREIGN KEY(EMPID) REFERENCES EMP(EMPID)
);

INSERT INTO PROJEMP VALUES (100, 1);
INSERT INTO PROJEMP VALUES (100, 2);
INSERT INTO PROJEMP VALUES (100, 4);
INSERT INTO PROJEMP VALUES (200, 3);
INSERT INTO PROJEMP VALUES (200, 4);

/*=====================================================================*/
DROP PROCEDURE if exists proProductByPrice;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE proProductByPrice
	@param_price float AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM product WHERE price>@param_price
END
GO

/*==========================================================================*/
