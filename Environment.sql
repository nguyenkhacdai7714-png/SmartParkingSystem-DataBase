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

:r .\Dai\ParkingGarage.sql
:r .\Vuong\User.sql
:r .\Vuong\Promotion.sql
GO
:r .\Vuong\Vehicle.sql
:r .\Minh\Reservation.sql
:r .\Minh\ParkingStaff.sql
:r .\Dai\ParkingFloor.sql
GO
:r .\Dai\Spot.sql
:r .\Vuong\ParkingSession.sql
GO
:r .\Minh\ParkingDevice.sql
:r .\Thanh\ParkingLog.sql
:r .\Thanh\ParkingRule.sql
:r .\Thanh\DailyReport.sql
GO