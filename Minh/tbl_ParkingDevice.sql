USE db_SmartParkingSystem;
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