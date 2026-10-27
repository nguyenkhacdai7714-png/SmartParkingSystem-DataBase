USE db_SmartParkingSystem;
GO

CREATE TABLE tbl_DailyReport (
    Report_ID VARCHAR(10) NOT NULL,
    GarageID VARCHAR(10) NOT NULL,
    Report_Date DATE NOT NULL,
    Total_Vehicles INT NOT NULL
        CONSTRAINT DF_DailyReport_Veh DEFAULT 0,
    Total_Revenue DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_DailyReport_Rev DEFAULT 0,

    CONSTRAINT PK_tbl_DailyReport
        PRIMARY KEY (Report_ID),

    CONSTRAINT FK_DailyReport_Garage
        FOREIGN KEY (GarageID)
        REFERENCES tbl_ParkingGarage(GarageID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_DailyReport_Garage_Date
        UNIQUE (GarageID, Report_Date),

    CONSTRAINT CK_DailyReport_Values
        CHECK (Total_Vehicles >= 0 AND Total_Revenue >= 0)
);
GO
