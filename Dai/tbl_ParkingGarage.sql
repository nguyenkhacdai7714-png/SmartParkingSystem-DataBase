USE db_SmartParkingSystem
GO

CREATE TABLE tbl_ParkingGarage(
	GarageID VARCHAR(10) NOT NULL PRIMARY KEY,
	GarageAddress NVARCHAR(255) NOT NULL,
);

INSERT INTO tbl_ParkingGarage
VALUES 
('G000', 'Thu Duc, TP.HCM'),
('G001', 'Binh Thanh, TP.HCM'),
('G002', 'Binh Tan, TP.HCM');