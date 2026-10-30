USE db_SmartParkingSystem
GO

IF OBJECT_ID('tbl_User', 'U') IS NOT NULL
    DROP TABLE tbl_User;
GO

CREATE TABLE tbl_User (
    User_ID VARCHAR(10) NOT NULL,
    Username NVARCHAR(50) NOT NULL,
    Phone VARCHAR(10) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Balance DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_User_Balance DEFAULT (0),
    User_Type VARCHAR(20) NOT NULL,

    CONSTRAINT PK_User PRIMARY KEY (User_ID),
    CONSTRAINT UQ_User_Phone UNIQUE (Phone),
    CONSTRAINT UQ_User_Email UNIQUE (Email),
    CONSTRAINT CK_User_Balance CHECK (Balance >= 0),
    CONSTRAINT CK_User_UserType CHECK (User_Type IN ('CUSTOMER', 'STAFF', 'ADMIN'))
);
GO

INSERT INTO tbl_User
    (User_ID, Username, Phone, Email, Balance, User_Type)
VALUES
    ('U001', N'Nguyen Van An',   '0900000001', 'an@example.com',   500000, 'CUSTOMER'),
    ('U002', N'Tran Thi Binh',   '0900000002', 'binh@example.com', 350000, 'CUSTOMER'),
    ('U003', N'Le Van Cuong',    '0900000003', 'cuong@example.com',200000, 'CUSTOMER'),
    ('U004', N'Pham Thi Dung',   '0900000004', 'dung@example.com', 800000, 'CUSTOMER'),
    ('U005', N'Hoang Van Em',    '0900000005', 'em@example.com',    50000, 'CUSTOMER'),
    ('U006', N'Vo Thi Giang',    '0900000006', 'giang@example.com', 150000, 'CUSTOMER'),
    ('U007', N'Do Van Huy',      '0900000007', 'huy@example.com',        0, 'STAFF'),
    ('U008', N'Bui Thi Lan',     '0900000008', 'lan@example.com',        0, 'STAFF'),
    ('U009', N'Ngo Van Minh',    '0900000009', 'minh@example.com',       0, 'STAFF'),
    ('U010', N'Dang Thi Nga',    '0900000010', 'nga@example.com',        0, 'ADMIN');
GO
