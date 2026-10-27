
USE db_SmartParkingSystem;
GO

CREATE TABLE tbl_ParkingStaff (
    Staff_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NULL,
    GarageID VARCHAR(10) NOT NULL,
    Role VARCHAR(10) NOT NULL
        CONSTRAINT DF_ParkingStaff_Role DEFAULT 'STAFF',
    Address VARCHAR(255) NOT NULL,

    CONSTRAINT PK_tbl_ParkingStaff
        PRIMARY KEY (Staff_ID),

    CONSTRAINT FK_ParkingStaff_User
        FOREIGN KEY (User_ID)
        REFERENCES tbl_User(User_ID)
        ON DELETE SET NULL,

    CONSTRAINT FK_ParkingStaff_Garage
        FOREIGN KEY (GarageID)
        REFERENCES tbl_ParkingGarage(GarageID)
        ON DELETE NO ACTION,

    CONSTRAINT CK_ParkingStaff_Role
        CHECK (Role IN ('STAFF', 'ADMIN'))
);
GO

CREATE UNIQUE INDEX UX_ParkingStaff_User
ON tbl_ParkingStaff(User_ID)
WHERE User_ID IS NOT NULL;
GO
