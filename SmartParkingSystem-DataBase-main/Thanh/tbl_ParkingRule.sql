USE db_SmartParkingSystem;
GO

IF OBJECT_ID('tbl_ParkingRules', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingRules;
GO

-- Parking Rules: general rules of the whole system
-- Rule_Value is nullable and can hold JSON for rules that need calculation
-- Not linked to any other table, so it has no foreign keys
CREATE TABLE tbl_ParkingRules (
    Rule_ID VARCHAR(10) NOT NULL,
    Rule_Name VARCHAR(100) NOT NULL,
    Rule_Description VARCHAR(255) NOT NULL,
    Rule_Status VARCHAR(10) NOT NULL
        CONSTRAINT DF_ParkingRules_Status DEFAULT 'ENABLED',
    Rule_Value VARCHAR(500) NULL,
    Modified_Date DATETIME NOT NULL
        CONSTRAINT DF_ParkingRules_Modified DEFAULT GETDATE(),

    CONSTRAINT PK_tbl_ParkingRules
        PRIMARY KEY (Rule_ID),

    CONSTRAINT UQ_ParkingRules_Name
        UNIQUE (Rule_Name),

    CONSTRAINT CK_ParkingRules_Status
        CHECK (Rule_Status IN ('ENABLED', 'DISABLED'))
);
GO

INSERT INTO tbl_ParkingRules (Rule_ID, Rule_Name, Rule_Description, Rule_Status, Rule_Value, Modified_Date)
VALUES
('R001', 'Reservation Deposit',
    'Customers pay a deposit when booking a spot. The deposit is refunded after check-in.',
    'ENABLED', '{"deposit_amount":20000}', '2026-10-01T09:00:00'),
('R002', 'Reservation Auto Cancel',
    'A reservation is cancelled automatically if the customer does not arrive in time (minutes).',
    'ENABLED', '30', '2026-10-01T09:00:00'),
('R003', 'Overstay Penalty',
    'Extra fee when a vehicle stays longer than the reserved time. Part of it goes to customers whose reservation failed because the lot was full.',
    'ENABLED', '{"penalty_rate":1.5,"compensation_share":0.3}', '2026-10-05T10:30:00'),
('R004', 'Best Promotion Auto Apply',
    'At check-out the system automatically applies the promotion that is best for the customer.',
    'ENABLED', NULL, '2026-10-01T09:00:00'),
('R005', 'Guest Vehicle Removal',
    'Vehicles without a User_ID are removed from the system after check-out.',
    'ENABLED', NULL, '2026-10-01T09:00:00'),
('R006', 'Capacity Warning Levels',
    'A WARN log is created when the remaining capacity drops to these percentages.',
    'ENABLED', '[30,20,10]', '2026-10-03T14:00:00'),
('R007', 'Device Offline Warning',
    'A WARN log is created when a device stays offline unexpectedly for this many minutes.',
    'ENABLED', '5', '2026-10-03T14:00:00'),
('R008', 'Guest Parking Ticket',
    'Guest vehicles receive a parking ticket and the barrier opens at check-in.',
    'ENABLED', NULL, '2026-10-01T09:00:00'),
('R009', 'Night Surcharge',
    'Extra fee for vehicles parked during the night hours.',
    'DISABLED', '{"start":"22:00","end":"06:00","surcharge":10000}', '2026-10-21T08:15:00'),
('R010', 'Staff Free Parking',
    'Users of these types park for free.',
    'ENABLED', '{"user_types":["STAFF","ADMIN"]}', '2026-10-08T11:00:00'),
('R011', 'Hourly Parking Price',
    'Parking price per hour for each spot type.',
    'ENABLED', '{"PARKING":5000,"ELECTRIC":15000}', '2026-10-10T08:00:00');
GO
