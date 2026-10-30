USE db_SmartParkingSystem;
GO


IF OBJECT_ID('tbl_ParkingLog', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingLog;
GO

-- Parking Log: records events in the system (USER / ADMIN / ERROR / WARN)
-- Not linked to any other table, so it has no foreign keys
CREATE TABLE tbl_ParkingLog (
    Log_ID INT NOT NULL,
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

-- Sample data: 4 days of events at Garage G0 (the garage that has spots in tbl_Spot)
-- Every overnight vehicle checks in on one day and checks out the next morning
INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
VALUES
-- 2026-10-20
(1,  '2026-10-20T07:30:00', 'USER',  'Registered customer checked in at Garage G0, spot A3'),
(2,  '2026-10-20T07:45:00', 'USER',  'Guest vehicle checked in at Garage G0, parking ticket issued'),
(3,  '2026-10-20T12:00:00', 'WARN',  'Remaining capacity dropped to 30% at Garage G0'),
(4,  '2026-10-20T17:45:00', 'USER',  'Customer checked out at Garage G0, bill printed'),
(5,  '2026-10-20T18:05:00', 'USER',  'Guest vehicle checked out at Garage G0, ticket returned'),
(6,  '2026-10-20T21:10:00', 'ERROR', 'Camera at the entrance gate failed to read a license plate'),
-- 2026-10-21
(7,  '2026-10-21T08:15:00', 'ADMIN', 'Admin disabled rule Night Surcharge'),
(8,  '2026-10-21T09:05:00', 'USER',  'Customer created a reservation and paid the deposit'),
(9,  '2026-10-21T09:40:00', 'WARN',  'Device 192.168.1.15 went offline unexpectedly'),
(10, '2026-10-21T10:00:00', 'USER',  'Customer checked in at Garage G0 using a reservation'),
(11, '2026-10-21T13:20:00', 'WARN',  'Remaining capacity dropped to 20% at Garage G0'),
(12, '2026-10-21T16:30:00', 'USER',  'Customer checked out at Garage G0, deposit refunded'),
(13, '2026-10-21T18:20:00', 'USER',  'Guest vehicle checked in at Garage G0, parking ticket issued'),
-- 2026-10-22
(14, '2026-10-22T06:50:00', 'USER',  'Overnight vehicle checked out at Garage G0, extra fee applied'),
(15, '2026-10-22T09:15:00', 'USER',  'Customer checked in at Garage G0, spot B3'),
(16, '2026-10-22T10:00:00', 'ERROR', 'Payment service timeout while closing a parking session'),
(17, '2026-10-22T14:30:00', 'ADMIN', 'Admin updated promotion settings'),
(18, '2026-10-22T15:10:00', 'USER',  'Customer checked out at Garage G0, promotion applied'),
(19, '2026-10-22T19:00:00', 'USER',  'Guest vehicle checked in at Garage G0, parking ticket issued'),
-- 2026-10-23
(20, '2026-10-23T07:10:00', 'USER',  'Overnight vehicle checked out at Garage G0, extra fee applied'),
(21, '2026-10-23T09:00:00', 'USER',  'Customer created a reservation and paid the deposit'),
(22, '2026-10-23T11:25:00', 'WARN',  'Remaining capacity dropped to 10% at Garage G0'),
(23, '2026-10-23T12:10:00', 'USER',  'Customer checked in at Garage G0, spot C3'),
(24, '2026-10-23T16:00:00', 'USER',  'Reservation expired after 30 minutes without check-in'),
(25, '2026-10-23T17:20:00', 'USER',  'Customer checked out at Garage G0, bill printed'),
(26, '2026-10-23T23:50:00', 'ADMIN', 'Admin generated daily statistics report');
GO
