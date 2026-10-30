USE db_SmartParkingSystem
GO

IF OBJECT_ID('tbl_ParkingGarage', 'U') IS NOT NULL
    DROP TABLE tbl_ParkingGarage;
GO

CREATE TABLE tbl_ParkingGarage(
	Garage_ID VARCHAR(10) NOT NULL PRIMARY KEY,
	Garage_Address NVARCHAR(255) NOT NULL,
);
GO

INSERT INTO tbl_ParkingGarage
VALUES 
('G0', 'Thu Duc, TP.HCM'),
('G1', 'Binh Thanh, TP.HCM'),
('G2', 'Binh Tan, TP.HCM');
GO