USE db_SmartParkingSystem
GO

DROP TABLE IF EXISTS tbl_Promotion;
GO

CREATE TABLE tbl_Promotion (
    Promotion_Code VARCHAR(20) NOT NULL,
    Promotion_Name VARCHAR(100) NOT NULL,
    Promotion_Type VARCHAR(20) NOT NULL,
    Promotion_Value DECIMAL(10,2) NOT NULL,
    User_Type VARCHAR(20) NOT NULL,
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NOT NULL,
    Max_Use INT NOT NULL
        CONSTRAINT DF_Promotion_MaxUse DEFAULT (1),

    CONSTRAINT PK_Promotion PRIMARY KEY (Promotion_Code),
    CONSTRAINT UQ_Promotion_Name UNIQUE (Promotion_Name),
    CONSTRAINT CK_Promotion_Type CHECK (Promotion_Type IN ('PERCENTAGE', 'FIXED')),
    CONSTRAINT CK_Promotion_Value CHECK (Promotion_Value > 0),
    CONSTRAINT CK_Promotion_UserType CHECK (User_Type IN ('CUSTOMER', 'STAFF', 'ADMIN', 'ALL')),
    CONSTRAINT CK_Promotion_Date CHECK (End_Date > Start_Date),
    CONSTRAINT CK_Promotion_MaxUse CHECK (Max_Use >= 1)
);
GO
