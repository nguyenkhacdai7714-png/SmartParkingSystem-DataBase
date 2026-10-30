
USE db_SmartParkingSystem
GO

IF OBJECT_ID('tbl_Vehicle', 'U') IS NOT NULL
    DROP TABLE tbl_Vehicle;
GO

CREATE TABLE tbl_Vehicle (
    License_Plate VARCHAR(15) NOT NULL,
    User_ID VARCHAR(10) NULL,

    CONSTRAINT PK_Vehicle PRIMARY KEY (License_Plate),
    CONSTRAINT FK_Vehicle_User FOREIGN KEY (User_ID)
    REFERENCES tbl_User(User_ID) ON DELETE SET NULL
);
GO

INSERT INTO tbl_Vehicle (License_Plate, User_ID)
VALUES
    ('51A-10001', 'U001'),
    ('51A-10002', 'U002'),
    ('51A-10003', 'U003'),
    ('51A-10004', 'U004'),
    ('51A-10005', 'U001'),
    ('51A-10006', 'U005'),
    ('51A-10007', 'U006'),
    ('51A-10008', 'U002'),
    ('51A-10009', 'U003'),
    ('51A-10010', NULL);
GO
