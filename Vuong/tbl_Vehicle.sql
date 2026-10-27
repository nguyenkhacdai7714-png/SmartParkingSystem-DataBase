
USE db_SmartParkingSystem
GO

DROP TABLE IF EXISTS tbl_Vehicle;
GO

CREATE TABLE tbl_Vehicle (
    License_Plate VARCHAR(15) NOT NULL,
    User_ID VARCHAR(10) NULL,

    CONSTRAINT PK_Vehicle PRIMARY KEY (License_Plate),
    CONSTRAINT FK_Vehicle_User FOREIGN KEY (User_ID)
    REFERENCES tbl_User(User_ID) ON DELETE SET NULL
);
GO
