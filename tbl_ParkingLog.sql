USE db_SmartParkingSystem;
GO

CREATE TABLE tbl_ParkingLog (
    Log_ID VARCHAR(10) NOT NULL,
    Session_ID VARCHAR(10) NOT NULL,
    Device_ID VARCHAR(10) NULL,
    Event_Type VARCHAR(15) NOT NULL,
    Log_Time DATETIME NOT NULL
        CONSTRAINT DF_ParkingLog_Time DEFAULT GETDATE(),
    Description NVARCHAR(255) NULL,

    CONSTRAINT PK_tbl_ParkingLog
        PRIMARY KEY (Log_ID),

    CONSTRAINT FK_ParkingLog_Session
        FOREIGN KEY (Session_ID)
        REFERENCES tbl_ParkingSession(Session_ID)
        ON DELETE CASCADE,

    CONSTRAINT FK_ParkingLog_Device
        FOREIGN KEY (Device_ID)
        REFERENCES tbl_ParkingDevice(Device_ID)
        ON DELETE SET NULL,

    CONSTRAINT CK_ParkingLog_Event
        CHECK (Event_Type IN ('ENTRY', 'EXIT', 'PAYMENT', 'ALERT'))
);
GO
