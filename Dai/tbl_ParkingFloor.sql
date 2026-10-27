USE db_SmartParkingSystem
GO

DROP TABLE IF EXISTS tbl_ParkingFloor;
GO

CREATE TABLE tbl_ParkingFloor(
	Floor_ID VARCHAR(10) NOT NULL PRIMARY KEY,
	Garage_ID VARCHAR(10) NOT NULL,
		CONSTRAINT FK_GarageID FOREIGN KEY (Garage_ID) REFERENCES tbl_ParkingGarage(Garage_ID) ON DELETE CASCADE,
	Floor_Number INT NOT NULL CHECK(Floor_Number <= 10 AND Floor_Number >= -3), 
		CONSTRAINT Unique_Garage_Floor UNIQUE (Garage_ID, Floor_Number)
);
GO


INSERT INTO tbl_ParkingFloor
VALUES
('F0', 'G0', 9),
('F1', 'G0', 8),
('F2', 'G0', 7),

('F3', 'G1', -1),
('F4', 'G1', -2),
('F5', 'G1', -3),

('F6', 'G2', 0),
('F7', 'G2', -1),
('F8', 'G2', -2);
GO