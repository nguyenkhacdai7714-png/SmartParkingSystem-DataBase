USE db_SmartParkingSystem
GO

IF OBJECT_ID('tbl_Promotion', 'U') IS NOT NULL
    DROP TABLE tbl_Promotion;
GO

CREATE TABLE tbl_Promotion (
    Promotion_Code VARCHAR(20) NOT NULL,
    Promotion_Name VARCHAR(100) NOT NULL,
    Promotion_Type VARCHAR(20) NOT NULL,
    Promotion_Value DECIMAL(10,2) NOT NULL,
    User_Type VARCHAR(20) NOT NULL,
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NOT NULL,
    Max_Use INT NOT NULL
        CONSTRAINT DF_Promotion_MaxUse DEFAULT (1),

    CONSTRAINT PK_Promotion PRIMARY KEY (Promotion_Code),
    CONSTRAINT UQ_Promotion_Name UNIQUE (Promotion_Name),
    CONSTRAINT CK_Promotion_Type CHECK (Promotion_Type IN ('PERCENTAGE', 'FIXED')),
    CONSTRAINT CK_Promotion_Value CHECK (Promotion_Value > 0),
    CONSTRAINT CK_Promotion_UserType CHECK (User_Type IN ('CUSTOMER', 'STAFF', 'ADMIN', 'ALL')),
    CONSTRAINT CK_Promotion_Date CHECK (End_Date > Start_Date),
    CONSTRAINT CK_Promotion_MaxUse CHECK (Max_Use >= 1)
);
GO

INSERT INTO tbl_Promotion
    (Promotion_Code, Promotion_Name, Promotion_Type,
     Promotion_Value, User_Type, Start_Date, End_Date, Max_Use)
VALUES
    ('PR001', 'Welcome Discount',  'PERCENTAGE', 10,     'CUSTOMER', '2026-01-01', '2027-01-01', 100),
    ('PR002', 'Student Discount',  'PERCENTAGE', 15,     'CUSTOMER', '2026-02-01', '2027-02-01',  50),
    ('PR003', 'Staff Discount',    'PERCENTAGE', 20,     'STAFF',    '2026-01-01', '2027-01-01',  30),
    ('PR004', 'VIP Discount',      'FIXED',      50000,  'CUSTOMER', '2026-03-01', '2027-03-01',  20),
    ('PR005', 'Weekend Offer',     'FIXED',      30000,  'ALL',      '2026-04-01', '2027-04-01', 200),
    ('PR006', 'Summer Promotion',  'PERCENTAGE', 25,     'CUSTOMER', '2026-05-01', '2026-09-01',  80),
    ('PR007', 'Admin Benefit',     'FIXED',      100000, 'ADMIN',    '2026-01-01', '2027-01-01',  10),
    ('PR008', 'Night Discount',    'PERCENTAGE',  5,     'ALL',      '2026-06-01', '2026-12-31', 150),
    ('PR009', 'Holiday Offer',     'FIXED',      40000,  'CUSTOMER', '2026-07-01', '2027-07-01',  60),
    ('PR010', 'Early Bird',        'PERCENTAGE', 12,     'ALL',      '2026-08-01', '2027-08-01',  40);
GO
