USE db_SmartParkingSystem;
GO

DROP TABLE IF EXISTS tbl_ParkingLog;
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

INSERT INTO tbl_ParkingLog (Log_ID, Session_ID, Device_ID, Event_Type, Log_Time, Description)
VALUES
('L001', 'S001', NULL, 'ENTRY', '2026-10-20 07:30:00', N'Vehicle entered'),
('L002', 'S001', NULL, 'EXIT', '2026-10-20 17:45:00', N'Vehicle exited'),
('L003', 'S001', NULL, 'PAYMENT', '2026-10-20 17:44:00', N'Fee paid'),
('L004', 'S002', NULL, 'ENTRY', '2026-10-20 08:10:00', N'Vehicle entered'),
('L005', 'S002', NULL, 'EXIT', '2026-10-20 12:00:00', N'Vehicle exited'),
('L006', 'S003', NULL, 'ENTRY', '2026-10-21 09:00:00', N'Vehicle entered'),
('L007', 'S003', NULL, 'ALERT', '2026-10-21 09:05:00', N'Plate not recognized'),
('L008', 'S004', NULL, 'ENTRY', '2026-10-21 18:20:00', N'Vehicle entered'),
('L009', 'S004', NULL, 'EXIT', '2026-10-22 06:50:00', N'Overnight stay'),
('L010', 'S005', NULL, 'ENTRY', '2026-10-22 10:15:00', N'Vehicle entered');
GO
