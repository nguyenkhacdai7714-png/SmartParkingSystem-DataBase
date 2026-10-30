
USE db_SmartParkingSystem;
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
