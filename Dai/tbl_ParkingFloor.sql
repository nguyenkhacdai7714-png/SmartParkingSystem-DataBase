USE db_SmartParkingSystem
GO

CREATE TABLE tbl_ParkingFloor(
	FloorID VARCHAR(10) NOT NULL PRIMARY KEY,
	GarageID VARCHAR(10) NOT NULL,
	FloorNumber INT NOT NULL CHECK(FloorNumber <= 10 AND FloorNumber >= -3), 

	CONSTRAINT FK_GarageID FOREIGN KEY (GarageID) REFERENCES tbl_ParkingGarage(GarageID) ON DELETE CASCADE,
	UNIQUE (GarageID, FloorNumber)
);
GO


INSERT INTO tbl_ParkingFloor
VALUES
('F0000', 'G000', -1),
('F0001', 'G001', -2),
('F0002', 'G002', 0);