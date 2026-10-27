
USE db_SmartParkingSystem;
GO

CREATE TABLE tbl_Reservation (
    Reservation_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NOT NULL,
    GarageID VARCHAR(10) NOT NULL,
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
        FOREIGN KEY (GarageID)
        REFERENCES tbl_ParkingGarage(GarageID)
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
