USE db_SmartParkingSystem;
GO

CREATE TABLE tbl_ParkingRule (
    Rule_ID VARCHAR(10) NOT NULL,
    GarageID VARCHAR(10) NOT NULL,
    Vehicle_Type VARCHAR(20) NOT NULL,
    Price_Per_Hour DECIMAL(15,2) NOT NULL,
    Free_Minutes INT NOT NULL
        CONSTRAINT DF_ParkingRule_Free DEFAULT 0,
    Overnight_Fee DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_ParkingRule_Night DEFAULT 0,

    CONSTRAINT PK_tbl_ParkingRule
        PRIMARY KEY (Rule_ID),

    CONSTRAINT FK_ParkingRule_Garage
        FOREIGN KEY (GarageID)
        REFERENCES tbl_ParkingGarage(GarageID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_ParkingRule_Garage_Type
        UNIQUE (GarageID, Vehicle_Type),

    CONSTRAINT CK_ParkingRule_Type
        CHECK (Vehicle_Type IN ('MOTORBIKE', 'CAR', 'BICYCLE')),

    CONSTRAINT CK_ParkingRule_Price
        CHECK (Price_Per_Hour >= 0 AND Overnight_Fee >= 0),

    CONSTRAINT CK_ParkingRule_Free
        CHECK (Free_Minutes >= 0)
);
GO
