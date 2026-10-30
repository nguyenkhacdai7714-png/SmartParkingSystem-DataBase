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

/* ------------------------------------------------------------
   SAMPLE DATA
   Needs: tbl_Spot (Spot_ID 0-11). Device type follows Spot_Type:
   cameras IN on CHECKIN spots, cameras OUT on CHECKOUT spots,
   sensors on ELECTRIC and PARKING spots.
   ------------------------------------------------------------ */

INSERT INTO tbl_ParkingDevice
    (Device_ID, Spot_ID, IP_Address, Device_Type, Status, Maintenance)
VALUES
    ('D001', 0,  '192.168.1.101', 'CAMERA IN',  'FOUND_VEHICLE', '20260915'),  -- A0 CHECKIN
    ('D002', 1,  '192.168.1.102', 'CAMERA OUT', 'EMPTY',         '20260915'),  -- A1 CHECKOUT
    ('D003', 2,  '192.168.1.103', 'SENSOR',     'EMPTY',         '20260820'),  -- A2 ELECTRIC
    ('D004', 3,  '192.168.1.104', 'SENSOR',     'FOUND_VEHICLE', '20260701'),  -- A3 PARKING
    ('D005', 4,  '192.168.1.105', 'CAMERA IN',  'EMPTY',         NULL),        -- B0 CHECKIN
    ('D006', 5,  '192.168.1.106', 'CAMERA OUT', 'OFFLINE',       '20261001'),  -- B1 CHECKOUT
    ('D007', 6,  '192.168.1.107', 'SENSOR',     'EMPTY',         '20260915'),  -- B2 ELECTRIC
    ('D008', 7,  '192.168.1.108', 'SENSOR',     'OFFLINE',       '20260610'),  -- B3 PARKING
    ('D009', 8,  '192.168.1.109', 'CAMERA',     'EMPTY',         NULL),        -- C0 CHECKIN
    ('D010', 11, '192.168.1.110', 'SENSOR',     'FOUND_VEHICLE', '20261005');  -- C3 PARKING
GO