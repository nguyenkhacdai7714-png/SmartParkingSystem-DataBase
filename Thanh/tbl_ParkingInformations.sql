USE db_SmartParkingSystem;
GO

DROP TABLE IF EXISTS tbl_ParkingInformations;
GO

-- Parking Informations: one statistics record per day for the whole system
-- Not linked to any other table, so it has no foreign keys
CREATE TABLE tbl_ParkingInformations (
    Stat_ID VARCHAR(10) NOT NULL,
    [Date] DATE NOT NULL,
    Total_Revenue DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_ParkingInfo_Revenue DEFAULT 0,
    Total_Promotion_Cost DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_ParkingInfo_PromoCost DEFAULT 0,
    Total_Logs INT NOT NULL
        CONSTRAINT DF_ParkingInfo_Logs DEFAULT 0,
    Total_Errors INT NOT NULL
        CONSTRAINT DF_ParkingInfo_Errors DEFAULT 0,
    Total_Warns INT NOT NULL
        CONSTRAINT DF_ParkingInfo_Warns DEFAULT 0,
    Total_Reservation INT NOT NULL
        CONSTRAINT DF_ParkingInfo_Reservation DEFAULT 0,
    Total_Checkin INT NOT NULL
        CONSTRAINT DF_ParkingInfo_Checkin DEFAULT 0,
    Total_Checkout INT NOT NULL
        CONSTRAINT DF_ParkingInfo_Checkout DEFAULT 0,

    CONSTRAINT PK_tbl_ParkingInformations
        PRIMARY KEY (Stat_ID),

    CONSTRAINT UQ_ParkingInformations_Date
        UNIQUE ([Date]),

    CONSTRAINT CK_ParkingInformations_NonNegative
        CHECK (Total_Revenue >= 0 AND Total_Promotion_Cost >= 0
           AND Total_Logs >= 0 AND Total_Errors >= 0 AND Total_Warns >= 0
           AND Total_Reservation >= 0 AND Total_Checkin >= 0 AND Total_Checkout >= 0),

    -- Every error or warning is also a log
    CONSTRAINT CK_ParkingInformations_Logs
        CHECK (Total_Errors + Total_Warns <= Total_Logs)
);
GO

INSERT INTO tbl_ParkingInformations
    (Stat_ID, [Date], Total_Revenue, Total_Promotion_Cost, Total_Logs, Total_Errors,
     Total_Warns, Total_Reservation, Total_Checkin, Total_Checkout)
VALUES
('ST001', '2026-10-20', 6200000, 310000, 1240,  6, 18, 25, 410, 405),
('ST002', '2026-10-21', 6450000, 280000, 1295,  4, 21, 30, 428, 421),
('ST003', '2026-10-22', 6080000, 250000, 1190,  9, 16, 22, 393, 398),
('ST004', '2026-10-23', 7600000, 420000, 1480,  3, 27, 41, 492, 485),
('ST005', '2026-10-24', 7150000, 390000, 1405,  5, 24, 36, 470, 468),
('ST006', '2026-10-25', 5200000, 150000,  980,  2, 12, 15, 330, 334),
('ST007', '2026-10-26', 4100000,  90000,  820,  1,  9, 10, 262, 265);
GO
