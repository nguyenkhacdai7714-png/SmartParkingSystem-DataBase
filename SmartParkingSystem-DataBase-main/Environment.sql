:setvar ProjectPath "C:\Users\KHAC DAI\Downloads\SmartParkingSystem-DataBase-main\SmartParkingSystem-DataBase-main"
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = N'db_SmartParkingSystem')
BEGIN
    ALTER DATABASE db_SmartParkingSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE db_SmartParkingSystem;
END
GO

CREATE DATABASE db_SmartParkingSystem;
GO

USE db_SmartParkingSystem;
GO

:r $(ProjectPath)\Dai\tbl_ParkingGarage.sql
:r $(ProjectPath)\Vuong\tbl_User.sql
:r $(ProjectPath)\Vuong\tbl_Promotion.sql
GO

:r $(ProjectPath)\Vuong\tbl_Vehicle.sql
:r $(ProjectPath)\Minh\tbl_Reservation.sql
:r $(ProjectPath)\Minh\tbl_ParkingStaff.sql
:r $(ProjectPath)\Dai\tbl_ParkingFloor.sql
GO

:r $(ProjectPath)\Dai\tbl_Spot.sql
:r $(ProjectPath)\Vuong\tbl_ParkingSession.sql
GO

:r $(ProjectPath)\Minh\tbl_ParkingDevice.sql
:r $(ProjectPath)\Thanh\tbl_ParkingLog.sql
:r $(ProjectPath)\Thanh\tbl_ParkingRule.sql
:r $(ProjectPath)\Thanh\tbl_DailyReport.sql
GO
