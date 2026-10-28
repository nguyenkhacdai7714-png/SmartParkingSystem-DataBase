USE db_SmartParkingSystem;
GO

DROP TABLE IF EXISTS tbl_ParkingRule;
GO

CREATE TABLE tbl_ParkingRule (
    Rule_ID VARCHAR(10) NOT NULL,
    Garage_ID VARCHAR(10) NOT NULL,
    Vehicle_Type VARCHAR(20) NOT NULL,
    Price_Per_Hour DECIMAL(15,2) NOT NULL,
    Free_Minutes INT NOT NULL
        CONSTRAINT DF_ParkingRule_Free DEFAULT 0,
    Overnight_Fee DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_ParkingRule_Night DEFAULT 0,

    CONSTRAINT PK_tbl_ParkingRule
        PRIMARY KEY (Rule_ID),

    CONSTRAINT FK_ParkingRule_Garage
        FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_ParkingRule_Garage_Type
        UNIQUE (Garage_ID, Vehicle_Type),

    CONSTRAINT CK_ParkingRule_Type
        CHECK (Vehicle_Type IN ('MOTORBIKE', 'CAR', 'BICYCLE')),

    CONSTRAINT CK_ParkingRule_Price
        CHECK (Price_Per_Hour >= 0 AND Overnight_Fee >= 0),

    CONSTRAINT CK_ParkingRule_Free
        CHECK (Free_Minutes >= 0)
);
GO

INSERT INTO tbl_ParkingRule (Rule_ID, Garage_ID, Vehicle_Type, Price_Per_Hour, Free_Minutes, Overnight_Fee)
VALUES
('R001', 'G000', 'MOTORBIKE', 5000, 15, 10000),
('R002', 'G000', 'CAR', 20000, 15, 50000),
('R003', 'G000', 'BICYCLE', 2000, 30, 5000),
('R004', 'G001', 'MOTORBIKE', 6000, 10, 12000),
('R005', 'G001', 'CAR', 25000, 10, 60000),
('R006', 'G001', 'BICYCLE', 2000, 30, 5000),
('R007', 'G002', 'MOTORBIKE', 4000, 15, 8000),
('R008', 'G002', 'CAR', 18000, 15, 45000),
('R009', 'G002', 'BICYCLE', 1000, 30, 3000);
GO
