USE db_SmartParkingSystem;
GO

DROP TABLE IF EXISTS tbl_DailyReport;
GO

CREATE TABLE tbl_DailyReport (
    Report_ID VARCHAR(10) NOT NULL,
    Garage_ID VARCHAR(10) NOT NULL,
    Report_Date DATE NOT NULL,
    Total_Vehicles INT NOT NULL
        CONSTRAINT DF_DailyReport_Veh DEFAULT 0,
    Total_Revenue DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_DailyReport_Rev DEFAULT 0,

    CONSTRAINT PK_tbl_DailyReport
        PRIMARY KEY (Report_ID),

    CONSTRAINT FK_DailyReport_Garage
        FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_DailyReport_Garage_Date
        UNIQUE (Garage_ID, Report_Date),

    CONSTRAINT CK_DailyReport_Values
        CHECK (Total_Vehicles >= 0 AND Total_Revenue >= 0)
);
GO

INSERT INTO tbl_DailyReport (Report_ID, Garage_ID, Report_Date, Total_Vehicles, Total_Revenue)
VALUES
('DR001', 'G000', '2026-10-20', 120, 1850000),
('DR002', 'G000', '2026-10-21', 135, 2100000),
('DR003', 'G000', '2026-10-22', 98, 1500000),
('DR004', 'G000', '2026-10-23', 142, 2250000),
('DR005', 'G001', '2026-10-20', 210, 3400000),
('DR006', 'G001', '2026-10-21', 198, 3150000),
('DR007', 'G001', '2026-10-22', 225, 3700000),
('DR008', 'G001', '2026-10-23', 240, 3950000),
('DR009', 'G002', '2026-10-20', 80, 950000),
('DR010', 'G002', '2026-10-21', 95, 1200000),
('DR011', 'G002', '2026-10-22', 70, 880000),
('DR012', 'G002', '2026-10-23', 110, 1400000);
GO
