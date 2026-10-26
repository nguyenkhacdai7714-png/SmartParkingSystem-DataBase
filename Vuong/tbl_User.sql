
CREATE TABLE dbo.[User] (
    User_ID VARCHAR(10) NOT NULL,
    Username NVARCHAR(50) NOT NULL,
    Phone VARCHAR(10) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Balance DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_User_Balance DEFAULT (0),
    User_Type VARCHAR(20) NOT NULL,

    CONSTRAINT PK_User PRIMARY KEY (User_ID),
    CONSTRAINT UQ_User_Phone UNIQUE (Phone),
    CONSTRAINT UQ_User_Email UNIQUE (Email),
    CONSTRAINT CK_User_Balance CHECK (Balance >= 0),
    CONSTRAINT CK_User_UserType CHECK (User_Type IN ('CUSTOMER', 'STAFF', 'ADMIN'))
);
GO
