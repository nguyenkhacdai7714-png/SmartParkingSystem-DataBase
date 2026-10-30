USE db_SmartParkingSystem;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('tbl_ParkingStaff', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingStaff;
GO

CREATE TABLE tbl_ParkingStaff (
    Staff_ID VARCHAR(10) NOT NULL,
    User_ID VARCHAR(10) NULL,
    Garage_ID VARCHAR(10) NOT NULL,
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
        FOREIGN KEY (Garage_ID)
        REFERENCES tbl_ParkingGarage(Garage_ID)
        ON DELETE NO ACTION,

    CONSTRAINT CK_ParkingStaff_Role
        CHECK (Role IN ('STAFF', 'ADMIN'))
);
GO

CREATE UNIQUE INDEX UX_ParkingStaff_User
ON tbl_ParkingStaff(User_ID)
WHERE User_ID IS NOT NULL;
GO

/* ------------------------------------------------------------
   SAMPLE DATA
   Needs: tbl_User (U007-U010) and tbl_ParkingGarage (G0, G1, G2)
   S001-S004 have a user account, S005-S010 do not.
   ------------------------------------------------------------ */

INSERT INTO tbl_ParkingStaff
    (Staff_ID, User_ID, Garage_ID, Role, Address)
VALUES
    ('S001', 'U007', 'G0', 'ADMIN', '12 Le Loi Street, District 1, Ho Chi Minh City'),
    ('S002', 'U008', 'G0', 'STAFF', '45 Nguyen Hue Street, District 1, Ho Chi Minh City'),
    ('S003', 'U009', 'G1', 'STAFF', '78 Tran Hung Dao Street, District 5, Ho Chi Minh City'),
    ('S004', 'U010', 'G2', 'STAFF', '23 Vo Van Tan Street, District 3, Ho Chi Minh City'),
    ('S005', NULL,   'G0', 'STAFF', '9 Hai Ba Trung Street, District 1, Ho Chi Minh City'),
    ('S006', NULL,   'G0', 'STAFF', '31 Pasteur Street, District 3, Ho Chi Minh City'),
    ('S007', NULL,   'G1', 'STAFF', '66 Cach Mang Thang Tam Street, District 10, Ho Chi Minh City'),
    ('S008', NULL,   'G1', 'STAFF', '5 Dien Bien Phu Street, Binh Thanh District, Ho Chi Minh City'),
    ('S009', NULL,   'G2', 'STAFF', '102 Nguyen Trai Street, District 5, Ho Chi Minh City'),
    ('S010', NULL,   'G2', 'ADMIN', '18 Ly Thuong Kiet Street, Tan Binh District, Ho Chi Minh City');
GO