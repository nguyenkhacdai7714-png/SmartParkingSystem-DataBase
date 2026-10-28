USE db_SmartParkingSystem;
GO

-- Remove the old version of this table
DROP TABLE IF EXISTS tbl_ParkingLog;
GO

-- Parking Log: records events in the system (USER / ADMIN / ERROR / WARN)
-- Not linked to any other table, so it has no foreign keys
CREATE TABLE tbl_ParkingLog (
    Log_ID VARCHAR(10) NOT NULL,
    Log_Time DATETIME NOT NULL
        CONSTRAINT DF_ParkingLog_Time DEFAULT GETDATE(),
    Log_Type VARCHAR(10) NOT NULL,
    Log_Content VARCHAR(500) NOT NULL,

    CONSTRAINT PK_tbl_ParkingLog
        PRIMARY KEY (Log_ID),

    CONSTRAINT CK_ParkingLog_Type
        CHECK (Log_Type IN ('USER', 'ADMIN', 'ERROR', 'WARN'))
);
GO

INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
VALUES
('L001', '2026-10-20T07:30:00', 'USER',  'Registered customer checked in at entrance gate'),
('L002', '2026-10-20T07:45:00', 'USER',  'Guest vehicle checked in, parking ticket issued'),
('L003', '2026-10-20T12:00:00', 'WARN',  'Remaining capacity dropped to 30% at Garage G0'),
('L004', '2026-10-20T17:45:00', 'USER',  'Customer checked out, bill printed'),
('L005', '2026-10-20T21:10:00', 'ERROR', 'Camera at entrance gate failed to read license plate'),
('L006', '2026-10-21T08:15:00', 'ADMIN', 'Admin disabled rule Night Surcharge'),
('L007', '2026-10-21T09:05:00', 'USER',  'Customer created a reservation and paid deposit'),
('L008', '2026-10-21T09:40:00', 'WARN',  'Device 192.168.1.15 went offline unexpectedly'),
('L009', '2026-10-21T13:20:00', 'WARN',  'Remaining capacity dropped to 20% at Garage G1'),
('L010', '2026-10-22T06:50:00', 'USER',  'Overnight vehicle checked out, extra fee applied'),
('L011', '2026-10-22T10:00:00', 'ERROR', 'Payment service timeout while closing a parking session'),
('L012', '2026-10-22T14:30:00', 'ADMIN', 'Admin updated promotion settings'),
('L013', '2026-10-23T11:25:00', 'WARN',  'Remaining capacity dropped to 10% at Garage G0'),
('L014', '2026-10-23T16:00:00', 'USER',  'Reservation expired after 30 minutes without check-in'),
('L015', '2026-10-24T02:15:00', 'ERROR', 'Sensor reported FOUND_VEHICLE but no parking session exists'),
('L016', '2026-10-24T09:00:00', 'ADMIN', 'Admin generated daily statistics report');
GO
