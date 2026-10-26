
USE db_SmartParkingSystem;
GO

CREATE TABLE dbo.ParkingSession (
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
        REFERENCES dbo.[User](User_ID),
    CONSTRAINT FK_ParkingSession_Vehicle FOREIGN KEY (License_Plate)
        REFERENCES dbo.Vehicle(License_Plate),
    CONSTRAINT FK_ParkingSession_Promotion FOREIGN KEY (Promotion_Code)
        REFERENCES dbo.Promotion(Promotion_Code),
    CONSTRAINT FK_ParkingSession_ParkingGarage FOREIGN KEY (Garage_ID)
        REFERENCES dbo.ParkingGarage(Garage_ID),
    CONSTRAINT CK_ParkingSession_CheckoutTime CHECK (Checkout_Time IS NULL OR Checkout_Time >= Checkin_Time)
);
GO
