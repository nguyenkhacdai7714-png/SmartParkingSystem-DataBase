:setvar ProjectPath "C:\FPTschool\FALL2026\DBI202\project\VerFinal\SmartParkingSystem-DataBase-main"
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = N'db_SmartParkingSystem')
BEGIN
    ALTER DATABASE db_SmartParkingSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE db_SmartParkingSystem;
END
GO

CREATE DATABASE db_SmartParkingSystem;
GO

USE db_SmartParkingSystem;
GO

IF OBJECT_ID('tbl_ParkingGarage', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingGarage;
GO

CREATE TABLE tbl_ParkingGarage(
	Garage_ID VARCHAR(10) NOT NULL PRIMARY KEY,
	Garage_Address NVARCHAR(255) NOT NULL,
);
GO

INSERT INTO tbl_ParkingGarage
VALUES 
('G0', 'Thu Duc, TP.HCM'),
('G1', 'Binh Thanh, TP.HCM'),
('G2', 'Binh Tan, TP.HCM');
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

IF OBJECT_ID('tbl_Vehicle', 'U') IS NOT NULL
    DROP TABLE tbl_Vehicle;
GO

CREATE TABLE tbl_Vehicle (
    License_Plate VARCHAR(15) NOT NULL,
    User_ID VARCHAR(10) NULL,

    CONSTRAINT PK_Vehicle PRIMARY KEY (License_Plate),
    CONSTRAINT FK_Vehicle_User FOREIGN KEY (User_ID)
    REFERENCES tbl_User(User_ID) ON DELETE SET NULL
);
GO

INSERT INTO tbl_Vehicle (License_Plate, User_ID)
VALUES
    ('51A-10001', 'U001'),
    ('51A-10002', 'U002'),
    ('51A-10003', 'U003'),
    ('51A-10004', 'U004'),
    ('51A-10005', 'U001'),
    ('51A-10006', 'U005'),
    ('51A-10007', 'U006'),
    ('51A-10008', 'U002'),
    ('51A-10009', 'U003'),
    ('51A-10010', NULL);
GO

IF OBJECT_ID('tbl_Reservation', 'U') IS NOT NULL
    DROP TABLE tbl_Reservation;
GO

CREATE TABLE tbl_Reservation (
    Reservation_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NOT NULL,
    Garage_ID VARCHAR(10) NOT NULL,
    Start_Time DATETIME NOT NULL,
    End_Time DATETIME NOT NULL,
    Status VARCHAR(10) NOT NULL
        CONSTRAINT DF_Reservation_Status DEFAULT 'WAITING',
    Deposit_Amount DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_Reservation_Deposit DEFAULT 0,

    CONSTRAINT PK_tbl_Reservation
        PRIMARY KEY (Reservation_ID),

    CONSTRAINT FK_Reservation_User
        FOREIGN KEY (User_ID)
        REFERENCES tbl_User(User_ID)
        ON DELETE NO ACTION,

    CONSTRAINT FK_Reservation_Garage
        FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID)
        ON DELETE NO ACTION,

    CONSTRAINT UQ_Reservation_User_Start
        UNIQUE (User_ID, Start_Time),

    CONSTRAINT CK_Reservation_Status
        CHECK (Status IN ('WAITING', 'USED', 'EXPIRED')),

    CONSTRAINT CK_Reservation_Deposit
        CHECK (Deposit_Amount >= 0),

    CONSTRAINT CK_Reservation_Time
        CHECK (End_Time > Start_Time)
);
GO

INSERT INTO tbl_Reservation
    (Reservation_ID, User_ID, Garage_ID, Start_Time, End_Time, Status, Deposit_Amount)
VALUES
    ('R001', 'U001', 'G0', '20261030 08:00', '20261030 10:00', 'WAITING', 50000),
    ('R002', 'U002', 'G0', '20261030 09:00', '20261030 11:00', 'WAITING', 50000),
    ('R003', 'U003', 'G1', '20261031 14:00', '20261031 16:00', 'WAITING', 30000),
    ('R004', 'U001', 'G1', '20261027 08:00', '20261027 12:00', 'USED',    50000),
    ('R005', 'U004', 'G0', '20261026 18:00', '20261026 20:00', 'EXPIRED', 50000),
    ('R006', 'U005', 'G2', '20261028 07:30', '20261028 09:30', 'USED',    40000),
    ('R007', 'U002', 'G2', '20261101 13:00', '20261101 15:00', 'WAITING', 40000),
    ('R008', 'U006', 'G1', '20261025 10:00', '20261025 14:00', 'EXPIRED', 30000),
    ('R009', 'U003', 'G0', '20261102 09:00', '20261102 11:00', 'WAITING', 50000),
    ('R010', 'U004', 'G2', '20261028 16:00', '20261028 18:00', 'USED',    40000);
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('tbl_ParkingStaff', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingStaff;
GO

CREATE TABLE tbl_ParkingStaff (
    Staff_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NULL,
    Garage_ID VARCHAR(10) NOT NULL,
    Role VARCHAR(10) NOT NULL
        CONSTRAINT DF_ParkingStaff_Role DEFAULT 'STAFF',
    Address VARCHAR(255) NOT NULL,

    CONSTRAINT PK_tbl_ParkingStaff
        PRIMARY KEY (Staff_ID),

    CONSTRAINT FK_ParkingStaff_User
        FOREIGN KEY (User_ID)
        REFERENCES tbl_User(User_ID)
        ON DELETE SET NULL,

    CONSTRAINT FK_ParkingStaff_Garage
        FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID)
        ON DELETE NO ACTION,

    CONSTRAINT CK_ParkingStaff_Role
        CHECK (Role IN ('STAFF', 'ADMIN'))
);
GO

CREATE UNIQUE INDEX UX_ParkingStaff_User
ON tbl_ParkingStaff(User_ID)
WHERE User_ID IS NOT NULL;
GO

INSERT INTO tbl_ParkingStaff
    (Staff_ID, User_ID, Garage_ID, Role, Address)
VALUES
    ('S001', 'U007', 'G0', 'ADMIN', '12 Le Loi Street, District 1, Ho Chi Minh City'),
    ('S002', 'U008', 'G0', 'STAFF', '45 Nguyen Hue Street, District 1, Ho Chi Minh City'),
    ('S003', 'U009', 'G1', 'STAFF', '78 Tran Hung Dao Street, District 5, Ho Chi Minh City'),
    ('S004', 'U010', 'G2', 'STAFF', '23 Vo Van Tan Street, District 3, Ho Chi Minh City'),
    ('S005', NULL,   'G0', 'STAFF', '9 Hai Ba Trung Street, District 1, Ho Chi Minh City'),
    ('S006', NULL,   'G0', 'STAFF', '31 Pasteur Street, District 3, Ho Chi Minh City'),
    ('S007', NULL,   'G1', 'STAFF', '66 Cach Mang Thang Tam Street, District 10, Ho Chi Minh City'),
    ('S008', NULL,   'G1', 'STAFF', '5 Dien Bien Phu Street, Binh Thanh District, Ho Chi Minh City'),
    ('S009', NULL,   'G2', 'STAFF', '102 Nguyen Trai Street, District 5, Ho Chi Minh City'),
    ('S010', NULL,   'G2', 'ADMIN', '18 Ly Thuong Kiet Street, Tan Binh District, Ho Chi Minh City');
GO

IF OBJECT_ID('tbl_ParkingFloor', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingFloor;
GO

CREATE TABLE tbl_ParkingFloor(
	Floor_ID VARCHAR(10) NOT NULL PRIMARY KEY,
	Garage_ID VARCHAR(10) NOT NULL,
		CONSTRAINT FK_GarageID FOREIGN KEY (Garage_ID) REFERENCES tbl_ParkingGarage(Garage_ID) ON DELETE CASCADE,
	Floor_Number INT NOT NULL CHECK(Floor_Number <= 10 AND Floor_Number >= -3), 
		CONSTRAINT Unique_Garage_Floor UNIQUE (Garage_ID, Floor_Number)
);
GO


INSERT INTO tbl_ParkingFloor
VALUES
('F0', 'G0', 9),
('F1', 'G0', 8),
('F2', 'G0', 7),

('F3', 'G1', -1),
('F4', 'G1', -2),
('F5', 'G1', -3),

('F6', 'G2', 0),
('F7', 'G2', -1),
('F8', 'G2', -2);
GO

IF OBJECT_ID('tbl_Spot', 'U') IS NOT NULL
    DROP TABLE tbl_Spot;
GO

CREATE TABLE tbl_Spot (
    Spot_ID INT NOT NULL,
    Spot_Name VARCHAR(20) NOT NULL,
    Spot_Type VARCHAR(20) NOT NULL 
        CONSTRAINT DF_Spot_SpotType DEFAULT 'PARKING',
    Floor_ID VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tbl_Spot PRIMARY KEY (Spot_ID),
    CONSTRAINT CK_Spot_Type CHECK (Spot_Type IN ('PARKING', 'CHECKIN', 'CHECKOUT', 'ELECTRIC')),
    CONSTRAINT FK_Floor_ID FOREIGN KEY (Floor_ID) REFERENCES tbl_ParkingFloor(Floor_ID) ON DELETE CASCADE
);
GO

INSERT INTO tbl_Spot
VALUES 
(0, 'A0', 'CHECKIN', 'F0'),
(1, 'A1', 'CHECKOUT', 'F0'),
(2, 'A2', 'ELECTRIC', 'F0'),
(3, 'A3', 'PARKING', 'F0'),

(4, 'B0', 'CHECKIN', 'F1'),
(5, 'B1', 'CHECKOUT', 'F1'),
(6, 'B2', 'ELECTRIC', 'F1'),
(7, 'B3', 'PARKING', 'F1'),

(8, 'C0', 'CHECKIN', 'F2'),
(9, 'C1', 'CHECKOUT', 'F2'),
(10, 'C2', 'ELECTRIC', 'F2'),
(11, 'C3', 'PARKING', 'F2');
GO

IF OBJECT_ID('tbl_ParkingSession', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingSession;
GO

CREATE TABLE tbl_ParkingSession (
    Session_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NULL,
    License_Plate VARCHAR(15) NOT NULL,
    Promotion_Code VARCHAR(20) NULL,
    Garage_ID VARCHAR(10) NOT NULL,

    Checkin_Time DATETIME NOT NULL
        DEFAULT GETDATE(),

    Checkout_Time DATETIME NULL,

    CONSTRAINT PK_ParkingSession PRIMARY KEY (Session_ID),
    CONSTRAINT FK_ParkingSession_User FOREIGN KEY (User_ID)
        REFERENCES tbl_User(User_ID),
    CONSTRAINT FK_ParkingSession_Vehicle FOREIGN KEY (License_Plate)
        REFERENCES tbl_Vehicle(License_Plate),
    CONSTRAINT FK_ParkingSession_Promotion FOREIGN KEY (Promotion_Code)
        REFERENCES tbl_Promotion(Promotion_Code),
    CONSTRAINT FK_ParkingSession_ParkingGarage FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID),
    CONSTRAINT CK_ParkingSession_CheckoutTime CHECK (Checkout_Time IS NULL OR Checkout_Time >= Checkin_Time)
);
GO

INSERT INTO tbl_ParkingSession
    (Session_ID, User_ID, License_Plate, Promotion_Code,
     Garage_ID, Checkin_Time, Checkout_Time)
VALUES
    ('PS001', 'U001', '51A-10001', 'PR001', 'G0',
     '2026-10-28 08:00:00', '2026-10-28 10:00:00'),

    ('PS002', 'U002', '51A-10002', 'PR002', 'G0',
     '2026-10-28 09:00:00', '2026-10-28 11:00:00'),

    ('PS003', 'U003', '51A-10003', NULL,    'G1',
     '2026-10-28 10:00:00', '2026-10-28 12:00:00'),

    ('PS004', 'U004', '51A-10004', 'PR004', 'G1',
     '2026-10-29 07:30:00', '2026-10-29 09:30:00'),

    ('PS005', 'U001', '51A-10005', 'PR005', 'G0',
     '2026-10-29 13:00:00', '2026-10-29 15:00:00'),

    ('PS006', 'U005', '51A-10006', 'PR006', 'G2',
     '2026-10-29 08:30:00', '2026-10-29 10:30:00'),

    ('PS007', 'U006', '51A-10007', NULL,    'G2',
     '2026-10-30 09:30:00', NULL),

    ('PS008', 'U002', '51A-10008', 'PR008', 'G1',
     '2026-10-30 14:00:00', NULL),

    ('PS009', 'U003', '51A-10009', 'PR009', 'G0',
     '2026-10-30 16:00:00', NULL),

    ('PS010', NULL,  '51A-10010', 'PR010', 'G2',
     '2026-10-30 18:00:00', NULL);
GO

IF OBJECT_ID('tbl_ParkingDevice', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingDevice;
GO

CREATE TABLE tbl_ParkingDevice (
    Device_ID VARCHAR(10) NOT NULL,
    Spot_ID INT NOT NULL,
    IP_Address VARCHAR(45) NOT NULL,
    Device_Type VARCHAR(20) NOT NULL,
    Status VARCHAR(15) NOT NULL
        CONSTRAINT DF_ParkingDevice_Status DEFAULT 'OFFLINE',
    Maintenance DATE NULL,

    CONSTRAINT PK_tbl_ParkingDevice
        PRIMARY KEY (Device_ID),

    CONSTRAINT FK_ParkingDevice_Spot
        FOREIGN KEY (Spot_ID)
        REFERENCES tbl_Spot(Spot_ID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_ParkingDevice_IP
        UNIQUE (IP_Address),

    CONSTRAINT CK_ParkingDevice_Type
        CHECK (
            Device_Type IN (
                'SENSOR', 'CAMERA', 'CAMERA IN', 'CAMERA OUT'
            )
        ),

    CONSTRAINT CK_ParkingDevice_Status
        CHECK (
            Status IN ('OFFLINE', 'FOUND_VEHICLE', 'EMPTY')
        )
);
GO

INSERT INTO tbl_ParkingDevice
    (Device_ID, Spot_ID, IP_Address, Device_Type, Status, Maintenance)
VALUES
    ('D001', 0,  '192.168.1.101', 'CAMERA IN',  'FOUND_VEHICLE', '20260915'),
    ('D002', 1,  '192.168.1.102', 'CAMERA OUT', 'EMPTY',         '20260915'),
    ('D003', 2,  '192.168.1.103', 'SENSOR',     'EMPTY',         '20260820'),
    ('D004', 3,  '192.168.1.104', 'SENSOR',     'FOUND_VEHICLE', '20260701'),
    ('D005', 4,  '192.168.1.105', 'CAMERA IN',  'EMPTY',         NULL),      
    ('D006', 5,  '192.168.1.106', 'CAMERA OUT', 'OFFLINE',       '20261001'),
    ('D007', 6,  '192.168.1.107', 'SENSOR',     'EMPTY',         '20260915'),
    ('D008', 7,  '192.168.1.108', 'SENSOR',     'OFFLINE',       '20260610'),
    ('D009', 8,  '192.168.1.109', 'CAMERA',     'EMPTY',         NULL),
    ('D010', 11, '192.168.1.110', 'SENSOR',     'FOUND_VEHICLE', '20261005');  
GO

IF OBJECT_ID('tbl_ParkingLog', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingLog;
GO

CREATE TABLE tbl_ParkingLog (
    Log_ID INT NOT NULL,
    Log_Time DATETIME NOT NULL
        CONSTRAINT DF_ParkingLog_Time DEFAULT GETDATE(),
    Log_Type VARCHAR(10) NOT NULL,
    Log_Content VARCHAR(500) NOT NULL,

    CONSTRAINT PK_tbl_ParkingLog
        PRIMARY KEY (Log_ID),

    CONSTRAINT CK_ParkingLog_Type
        CHECK (Log_Type IN ('USER', 'ADMIN', 'ERROR', 'WARN'))
);
GO

INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
VALUES

(1,  '2026-10-20T07:30:00', 'USER',  'Registered customer checked in at Garage G0, spot A3'),
(2,  '2026-10-20T07:45:00', 'USER',  'Guest vehicle checked in at Garage G0, parking ticket issued'),
(3,  '2026-10-20T12:00:00', 'WARN',  'Remaining capacity dropped to 30% at Garage G0'),
(4,  '2026-10-20T17:45:00', 'USER',  'Customer checked out at Garage G0, bill printed'),
(5,  '2026-10-20T18:05:00', 'USER',  'Guest vehicle checked out at Garage G0, ticket returned'),
(6,  '2026-10-20T21:10:00', 'ERROR', 'Camera at the entrance gate failed to read a license plate'),

(7,  '2026-10-21T08:15:00', 'ADMIN', 'Admin disabled rule Night Surcharge'),
(8,  '2026-10-21T09:05:00', 'USER',  'Customer created a reservation and paid the deposit'),
(9,  '2026-10-21T09:40:00', 'WARN',  'Device 192.168.1.15 went offline unexpectedly'),
(10, '2026-10-21T10:00:00', 'USER',  'Customer checked in at Garage G0 using a reservation'),
(11, '2026-10-21T13:20:00', 'WARN',  'Remaining capacity dropped to 20% at Garage G0'),
(12, '2026-10-21T16:30:00', 'USER',  'Customer checked out at Garage G0, deposit refunded'),
(13, '2026-10-21T18:20:00', 'USER',  'Guest vehicle checked in at Garage G0, parking ticket issued'),

(14, '2026-10-22T06:50:00', 'USER',  'Overnight vehicle checked out at Garage G0, extra fee applied'),
(15, '2026-10-22T09:15:00', 'USER',  'Customer checked in at Garage G0, spot B3'),
(16, '2026-10-22T10:00:00', 'ERROR', 'Payment service timeout while closing a parking session'),
(17, '2026-10-22T14:30:00', 'ADMIN', 'Admin updated promotion settings'),
(18, '2026-10-22T15:10:00', 'USER',  'Customer checked out at Garage G0, promotion applied'),
(19, '2026-10-22T19:00:00', 'USER',  'Guest vehicle checked in at Garage G0, parking ticket issued'),

(20, '2026-10-23T07:10:00', 'USER',  'Overnight vehicle checked out at Garage G0, extra fee applied'),
(21, '2026-10-23T09:00:00', 'USER',  'Customer created a reservation and paid the deposit'),
(22, '2026-10-23T11:25:00', 'WARN',  'Remaining capacity dropped to 10% at Garage G0'),
(23, '2026-10-23T12:10:00', 'USER',  'Customer checked in at Garage G0, spot C3'),
(24, '2026-10-23T16:00:00', 'USER',  'Reservation expired after 30 minutes without check-in'),
(25, '2026-10-23T17:20:00', 'USER',  'Customer checked out at Garage G0, bill printed'),
(26, '2026-10-23T23:50:00', 'ADMIN', 'Admin generated daily statistics report');
GO

IF OBJECT_ID('tbl_ParkingRules', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingRules;
GO

CREATE TABLE tbl_ParkingRules (
    Rule_ID VARCHAR(10) NOT NULL,
    Rule_Name VARCHAR(100) NOT NULL,
    Rule_Description VARCHAR(255) NOT NULL,
    Rule_Status VARCHAR(10) NOT NULL
        CONSTRAINT DF_ParkingRules_Status DEFAULT 'ENABLED',
    Rule_Value VARCHAR(500) NULL,
    Modified_Date DATETIME NOT NULL
        CONSTRAINT DF_ParkingRules_Modified DEFAULT GETDATE(),

    CONSTRAINT PK_tbl_ParkingRules
        PRIMARY KEY (Rule_ID),

    CONSTRAINT UQ_ParkingRules_Name
        UNIQUE (Rule_Name),

    CONSTRAINT CK_ParkingRules_Status
        CHECK (Rule_Status IN ('ENABLED', 'DISABLED'))
);
GO

INSERT INTO tbl_ParkingRules (Rule_ID, Rule_Name, Rule_Description, Rule_Status, Rule_Value, Modified_Date)
VALUES
('R001', 'Reservation Deposit',
    'Customers pay a deposit when booking a spot. The deposit is refunded after check-in.',
    'ENABLED', '{"deposit_amount":20000}', '2026-10-01T09:00:00'),
('R002', 'Reservation Auto Cancel',
    'A reservation is cancelled automatically if the customer does not arrive in time (minutes).',
    'ENABLED', '30', '2026-10-01T09:00:00'),
('R003', 'Overstay Penalty',
    'Extra fee when a vehicle stays longer than the reserved time. Part of it goes to customers whose reservation failed because the lot was full.',
    'ENABLED', '{"penalty_rate":1.5,"compensation_share":0.3}', '2026-10-05T10:30:00'),
('R004', 'Best Promotion Auto Apply',
    'At check-out the system automatically applies the promotion that is best for the customer.',
    'ENABLED', NULL, '2026-10-01T09:00:00'),
('R005', 'Guest Vehicle Removal',
    'Vehicles without a User_ID are removed from the system after check-out.',
    'ENABLED', NULL, '2026-10-01T09:00:00'),
('R006', 'Capacity Warning Levels',
    'A WARN log is created when the remaining capacity drops to these percentages.',
    'ENABLED', '[30,20,10]', '2026-10-03T14:00:00'),
('R007', 'Device Offline Warning',
    'A WARN log is created when a device stays offline unexpectedly for this many minutes.',
    'ENABLED', '5', '2026-10-03T14:00:00'),
('R008', 'Guest Parking Ticket',
    'Guest vehicles receive a parking ticket and the barrier opens at check-in.',
    'ENABLED', NULL, '2026-10-01T09:00:00'),
('R009', 'Night Surcharge',
    'Extra fee for vehicles parked during the night hours.',
    'DISABLED', '{"start":"22:00","end":"06:00","surcharge":10000}', '2026-10-21T08:15:00'),
('R010', 'Staff Free Parking',
    'Users of these types park for free.',
    'ENABLED', '{"user_types":["STAFF","ADMIN"]}', '2026-10-08T11:00:00'),
('R011', 'Hourly Parking Price',
    'Parking price per hour for each spot type.',
    'ENABLED', '{"PARKING":5000,"ELECTRIC":15000}', '2026-10-10T08:00:00');
GO

IF OBJECT_ID('tbl_DailyReport', 'U') IS NOT NULL
    DROP TABLE tbl_DailyReport;
GO

CREATE TABLE tbl_DailyReport (
    Report_ID VARCHAR(10) NOT NULL,
    Report_Date DATE NOT NULL,
    Total_Revenue DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_DailyReport_Revenue DEFAULT 0,
    Total_Promotion_Cost DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_DailyReport_PromoCost DEFAULT 0,
    Total_Logs INT NOT NULL
        CONSTRAINT DF_DailyReport_Logs DEFAULT 0,
    Total_Errors INT NOT NULL
        CONSTRAINT DF_DailyReport_Errors DEFAULT 0,
    Total_Warns INT NOT NULL
        CONSTRAINT DF_DailyReport_Warns DEFAULT 0,
    Total_Reservation INT NOT NULL
        CONSTRAINT DF_DailyReport_Reservation DEFAULT 0,
    Total_Checkin INT NOT NULL
        CONSTRAINT DF_DailyReport_Checkin DEFAULT 0,
    Total_Checkout INT NOT NULL
        CONSTRAINT DF_DailyReport_Checkout DEFAULT 0,

    CONSTRAINT PK_tbl_DailyReport
        PRIMARY KEY (Report_ID),

    CONSTRAINT UQ_DailyReport_Date
        UNIQUE (Report_Date),

    CONSTRAINT CK_DailyReport_NonNegative
        CHECK (Total_Revenue >= 0 AND Total_Promotion_Cost >= 0
           AND Total_Logs >= 0 AND Total_Errors >= 0 AND Total_Warns >= 0
           AND Total_Reservation >= 0 AND Total_Checkin >= 0 AND Total_Checkout >= 0),

    CONSTRAINT CK_DailyReport_Logs
        CHECK (Total_Errors + Total_Warns <= Total_Logs)
);
GO

INSERT INTO tbl_DailyReport
    (Report_ID, Report_Date, Total_Revenue, Total_Promotion_Cost, Total_Logs, Total_Errors,
     Total_Warns, Total_Reservation, Total_Checkin, Total_Checkout)
VALUES
('DR001', '2026-10-20', 100000,     0, 6, 1, 1, 0, 2, 2),
('DR002', '2026-10-21',  35000,     0, 7, 0, 2, 1, 2, 1),
('DR003', '2026-10-22',  90000, 10000, 6, 1, 0, 0, 2, 2),
('DR004', '2026-10-23',  95000,     0, 7, 0, 1, 1, 1, 2);
GO
