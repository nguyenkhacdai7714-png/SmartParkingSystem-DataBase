USE db_SmartParkingSystem
GO

DROP TABLE IF EXISTS tbl_Spot;
GO

CREATE TABLE tbl_Spot (
    Spot_ID INT NOT NULL,
    Spot_Name VARCHAR(20) NOT NULL,
    Spot_Type VARCHAR(20) NOT NULL 
        CONSTRAINT DF_Spot_SpotType DEFAULT 'PARKING',
    Floor_ID VARCHAR(10) NOT NULL,

    CONSTRAINT PK_tbl_Spot PRIMARY KEY (Spot_ID),
    CONSTRAINT CK_Spot_Type CHECK (Spot_Type IN ('PARKING', 'CHECKIN', 'CHECKOUT', 'ELECTRIC')),
    CONSTRAINT FK_Floor_ID FOREIGN KEY (Floor_ID) REFERENCES tbl_ParkingFloor(Floor_ID) ON DELETE CASCADE
);
GO

INSERT INTO tbl_Spot
VALUES 
(0, 'A0', 'CHECKIN', 'F0'),
(1, 'A1', 'CHECKOUT', 'F0'),
(2, 'A2', 'ELECTRIC', 'F0'),
(3, 'A3', 'PARKING', 'F0'),

(4, 'B0', 'CHECKIN', 'F1'),
(5, 'B1', 'CHECKOUT', 'F1'),
(6, 'B2', 'ELECTRIC', 'F1'),
(7, 'B3', 'PARKING', 'F1'),

(8, 'C0', 'CHECKIN', 'F2'),
(9, 'C1', 'CHECKOUT', 'F2'),
(10, 'C2', 'ELECTRIC', 'F2'),
(11, 'C3', 'PARKING', 'F2');
GO