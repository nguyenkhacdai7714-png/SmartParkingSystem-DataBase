USE db_SmartParkingSystem;
GO

DROP TABLE IF EXISTS tbl_DailyReport;
GO

-- Daily Report: one statistics record per day for the whole system
-- Not linked to any other table, so it has no foreign keys
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

    -- Every error or warning is also a log
    CONSTRAINT CK_DailyReport_Logs
        CHECK (Total_Errors + Total_Warns <= Total_Logs)
);
GO

-- Sample data: the same 4 days as tbl_ParkingLog
-- Total_Logs, Total_Errors, Total_Warns equal the number of rows in tbl_ParkingLog for that day
-- Total_Checkin, Total_Checkout, Total_Reservation equal the matching USER logs for that day
-- Revenue is estimated from the rule "Hourly Parking Price" (PARKING = 5000 per hour)
INSERT INTO tbl_DailyReport
    (Report_ID, Report_Date, Total_Revenue, Total_Promotion_Cost, Total_Logs, Total_Errors,
     Total_Warns, Total_Reservation, Total_Checkin, Total_Checkout)
VALUES
('DR001', '2026-10-20', 100000,     0, 6, 1, 1, 0, 2, 2),
('DR002', '2026-10-21',  35000,     0, 7, 0, 2, 1, 2, 1),
('DR003', '2026-10-22',  90000, 10000, 6, 1, 0, 0, 2, 2),
('DR004', '2026-10-23',  95000,     0, 7, 0, 1, 1, 1, 2);
GO
