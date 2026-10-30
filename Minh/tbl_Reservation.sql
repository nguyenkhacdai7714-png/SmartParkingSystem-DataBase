USE db_SmartParkingSystem;
GO

IF OBJECT_ID('tbl_Reservation', 'U') IS NOT NULL
    DROP TABLE tbl_Reservation;
GO

CREATE TABLE tbl_Reservation (
    Reservation_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NOT NULL,
    Garage_ID VARCHAR(10) NOT NULL,
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
        FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID)
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

/* ------------------------------------------------------------
   SAMPLE DATA
   Needs: tbl_User (U001-U006) and tbl_ParkingGarage (G0, G1, G2)
   ------------------------------------------------------------ */

INSERT INTO tbl_Reservation
    (Reservation_ID, User_ID, Garage_ID, Start_Time, End_Time, Status, Deposit_Amount)
VALUES
    ('R001', 'U001', 'G0', '20261030 08:00', '20261030 10:00', 'WAITING', 50000),
    ('R002', 'U002', 'G0', '20261030 09:00', '20261030 11:00', 'WAITING', 50000),
    ('R003', 'U003', 'G1', '20261031 14:00', '20261031 16:00', 'WAITING', 30000),
    ('R004', 'U001', 'G1', '20261027 08:00', '20261027 12:00', 'USED',    50000),
    ('R005', 'U004', 'G0', '20261026 18:00', '20261026 20:00', 'EXPIRED', 50000),
    ('R006', 'U005', 'G2', '20261028 07:30', '20261028 09:30', 'USED',    40000),
    ('R007', 'U002', 'G2', '20261101 13:00', '20261101 15:00', 'WAITING', 40000),
    ('R008', 'U006', 'G1', '20261025 10:00', '20261025 14:00', 'EXPIRED', 30000),
    ('R009', 'U003', 'G0', '20261102 09:00', '20261102 11:00', 'WAITING', 50000),
    ('R010', 'U004', 'G2', '20261028 16:00', '20261028 18:00', 'USED',    40000);
GO