-- 建立資料庫指令
-- CREATE DATABASE final_project COLLATE Chinese_Taiwan_Stroke_CI_AS; --

Use final_project;

DROP TABLE if exists facilities;
DROP TABLE if exists facility_images;
DROP TABLE if exists facility_reservation;
DROP TABLE if exists point_account;
DROP TABLE if exists point_source;
DROP TABLE if exists point_transaction;

-- 公共設施表
CREATE TABLE facilities (
	facility_id INT IDENTITY(1,1) PRIMARY KEY,           -- 公設ID，自動遞增
	community_id INT,                                    -- 社區識別欄位
    facility_name NVARCHAR(100) NOT NULL,                -- 公設名稱
	max_users INT,                                       -- 使用人數上限
    facility_description NVARCHAR(255),                  -- 公設描述
    facility_location NVARCHAR(100) NOT NULL,            -- 公設地點
    open_time TIME NOT NULL,                             -- 開始營運時間
    close_time TIME NOT NULL,                            -- 結束營運時間
    reservable_duration INT,                             -- 單次可預約時長（單位：分鐘）
    fee INT DEFAULT 0 NOT NULL,                          -- 每次預約費用（單位：點數或元）
	facility_status NVARCHAR(20) DEFAULT 'active',       -- 使用狀態：啟用、停用、維修中等    
    created_at DATETIME DEFAULT GETDATE(),               -- 建立時間
    updated_at DATETIME                                  -- 最後更新時間
	--FOREIGN KEY (community_id) REFERENCES communities(community_id),
);

-- 公共設施圖片
CREATE TABLE facility_images (
    image_id INT IDENTITY(1,1) PRIMARY KEY,           -- 照片主鍵
    facility_id INT NOT NULL,                         -- 關聯公設
    image_url NVARCHAR(255) NOT NULL,                 -- 照片使用url儲存
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
	is_active BIT DEFAULT 1,                         -- 紀錄用戶是否被刪除
    updated_at DATETIME DEFAULT GETDATE(),           -- 最後更新時間
    CONSTRAINT UQ_unit_community UNIQUE (unit_id, community_id)
    -- FOREIGN KEY (community_id) REFERENCES communities(community_id)
    -- FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);

-- 點數來源與效期明細表 (point_sources)
CREATE TABLE point_source (
    source_id INT IDENTITY(1,1) PRIMARY KEY,          -- 點數來源 ID
    community_id INT NOT NULL,                        -- 所屬社區
    unit_id INT NOT NULL,                             -- 所屬住戶單位
    source_type NVARCHAR(50) NOT NULL,                -- monthly、topup 等
    source_description NVARCHAR(50),                  -- 說明點數來源
    amount INT NOT NULL,                              -- 發放點數
    remaining INT NOT NULL,                           -- 剩餘可用點數
    issued_at DATETIME DEFAULT GETDATE(),             -- 發放時間
    expired_at DATETIME NULL,                         -- 到期時間（NULL 為永久）
    point_status NVARCHAR(20) DEFAULT 'active'        -- active / expired / used_up
    -- FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);

-- 點數異動紀錄表 (point_transactions)
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


TRUNCATE TABLE facilities;
INSERT INTO facilities (
    community_id, facility_name, max_users, facility_description, facility_location,
    open_time, close_time, reservable_duration, fee, facility_status, created_at
) VALUES
(1, N'交誼廳', NULL, N'可供住戶聚會、會議或活動使用', N'A棟1樓', '09:00', '21:00', 60, 15, 'active', GETDATE()),
(1, N'健身房', 10, N'配有跑步機、啞鈴、飛輪等設備', N'B棟地下1樓', '06:00', '22:00', 60, 10, 'active', GETDATE()),
(1, N'游泳池', 30, N'僅限住戶使用，請著泳裝並遵守規定', N'戶外區', '09:00', '21:00', 60, 10, 'active', GETDATE()),
(1, N'桌球室B101', NULL, N'提供標準雙人桌球場地，限時使用', N'B1-B101', '09:00', '21:00', 60, 10, 'active', GETDATE()),
(1, N'桌球室B102', NULL, N'提供標準雙人桌球場地，限時使用', N'B1-B102', '09:00', '21:00', 60, 10, 'active', GETDATE()),
(1, N'撞球室', NULL, N'提供撞球桌與器材，需預約使用', N'B2撞球室', '09:00', '21:00', 60, 20, 'active', GETDATE()),
(1, N'停車格A1', NULL, N'地下停車場 A1 車位，可短時預約停車', N'地下1樓-A1', '00:00', '23:59', 60, 5, 'active', GETDATE()),
(1, N'停車格A2', NULL, N'地下停車場 A2 車位，可短時預約停車', N'地下1樓-A2', '00:00', '23:59', 60, 5, 'active', GETDATE());


TRUNCATE TABLE facility_images;
INSERT INTO facility_images (facility_id, image_url, image_description, sort_order)
VALUES 
(1, '/images/facilities/lounge.jpg', N'交誼廳外觀', 0),
(2, '/images/facilities/gym.jpg', N'健身房設備照', 0),
(3, '/images/facilities/pool.jpg', N'游泳池環境', 0),
(4, '/images/facilities/tabletennis.jpg', N'桌球室B101外觀', 0),
(5, '/images/facilities/tabletennis.jpg', N'桌球室B102外觀', 0),
(6, '/images/facilities/snooker.jpg', N'撞球室環境', 0),
(7, '/images/facilities/parking_grid.jpg', N'地下停車場 A1 車位', 0),
(8, '/images/facilities/parking_grid.jpg', N'地下停車場 A2 車位', 0);


TRUNCATE TABLE facility_reservation;
INSERT INTO facility_reservation (
    community_id, unit_id, created_by, facility_id,
    number_of_users, reservation_start_time, reservation_end_time,
    is_admin, required_points, actual_used_points, remark,
    reservation_status, created_at
) VALUES
(1, 101, N'張三', 1, 5, '2025-06-25 10:00', '2025-06-25 11:00', 0, 15, 15, N'首次預約交誼廳', 'APPROVED', GETDATE()),
(1, 102, N'李四', 2, 2, '2025-06-25 08:00', '2025-06-25 09:00', 0, 10, 10, N'早晨健身', 'APPROVED', GETDATE()),
(1, 103, N'王五', 3, 1, '2025-06-25 17:00', '2025-06-25 18:00', 0, 10, 10, N'傍晚游泳', 'APPROVED', GETDATE()),
(1, 101, N'張三', 4, 2, '2025-06-26 14:00', '2025-06-26 15:00', 0, 10, 10, NULL, 'APPROVED', GETDATE()),
(1, 104, N'陳六', 5, 2, '2025-06-26 15:00', '2025-06-26 16:00', 0, 10, 10, NULL, 'APPROVED', GETDATE()),
(1, 105, N'林七', 6, 4, '2025-06-27 19:00', '2025-06-27 20:00', 0, 20, 20, N'週五撞球', 'APPROVED', GETDATE()),
(1, 101, N'張三', 2, 1, '2025-06-28 07:00', '2025-06-28 08:00', 0, 10, 10, N'健身重訓', 'APPROVED', GETDATE()),
(1, 102, N'李四', 1, 6, '2025-06-28 18:00', '2025-06-28 19:00', 0, 15, 15, NULL, 'APPROVED', GETDATE()),
(1, 103, N'王五', 3, 2, '2025-06-29 12:00', '2025-06-29 13:00', 0, 10, 10, NULL, 'APPROVED', GETDATE()),
(1, 104, N'陳六', 4, 2, '2025-06-29 20:00', '2025-06-29 21:00', 0, 10, 10, NULL, 'APPROVED', GETDATE());


TRUNCATE TABLE point_account;
INSERT INTO point_account (
    community_id, unit_id, total_balance, system_balance, topup_balance, updated_at
) VALUES
(1, 101, 100, 100, 0, GETDATE()),   -- 張三：剛領 100 系統點
(1, 102, 150, 100, 50, GETDATE()),  -- 李四：有儲值 50 點
(1, 103, 80, 80, 0, GETDATE()),     -- 王五：系統點已用部分
(1, 104, 200, 100, 100, GETDATE()), -- 陳六：用戶很活躍
(1, 105, 0, 0, 0, GETDATE());       -- 林七：尚未領點


TRUNCATE TABLE point_source;
INSERT INTO point_source (
    community_id, unit_id, source_type, amount, remaining, issued_at, expired_at, point_status
) VALUES
(1, 101, 'monthly', 100, 100, GETDATE(), '2025-07-31', 'active'),   
(1, 102, 'monthly', 100, 100, GETDATE(), '2025-07-31', 'active'),   -- 李四：領 100 系統點 + 儲值 50
(1, 102, 'topup', 50, 50, GETDATE(), NULL, 'active'),               
(1, 103, 'monthly', 100, 80, GETDATE(), '2025-07-31', 'active'),    -- 王五：領 100 系統點，用掉 20（剩 80）
(1, 104, 'monthly', 100, 100, GETDATE(), '2025-07-31', 'active'),   -- 陳六：領 100 系統點 + 儲值 100
(1, 104, 'topup', 100, 100, GETDATE(), NULL, 'active');


TRUNCATE TABLE point_transaction;
INSERT INTO point_transaction (
    community_id, unit_id, source_id, change_type, amount,
    related_unit_id, transaction_description, created_at
) VALUES
(1, 101, 1, 'reservation', -15, NULL, N'預約交誼廳扣點', GETDATE()),
(1, 102, 2, 'reservation', -10, NULL, N'預約健身房扣點', GETDATE()),
(1, 103, 4, 'reservation', -10, NULL, N'預約游泳池扣點', GETDATE()),
(1, 104, 6, 'reservation', -10, NULL, N'預約桌球室扣點', GETDATE());