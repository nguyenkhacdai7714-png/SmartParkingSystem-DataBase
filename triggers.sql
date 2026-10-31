USE db_SmartParkingSystem;
GO

-- =========================================================================
-- DROP EXISTING TRIGGERS (GOM TẤT CẢ LÊN ĐẦU FILE)
-- =========================================================================

IF OBJECT_ID('dbo.trg_LogNewParkingSession', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.trg_LogNewParkingSession;
END;
GO

IF OBJECT_ID('dbo.trg_LogAdminRuleChanges', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.trg_LogAdminRuleChanges;
END;
GO

IF OBJECT_ID('dbo.trg_WarnDeviceMaintenance', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.trg_WarnDeviceMaintenance;
END;
GO

IF OBJECT_ID('dbo.trg_ErrorDeviceOffline', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.trg_ErrorDeviceOffline;
END;
GO

IF OBJECT_ID('dbo.trg_UpdateDailyReport', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.trg_UpdateDailyReport;
END;
GO


-- =========================================================================
-- CREATE TRIGGERS
-- =========================================================================

-- 1. CREATE log khi có parking session mới
CREATE TRIGGER dbo.trg_LogNewParkingSession
ON tbl_ParkingSession
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LogID INT;
    SELECT @LogID = ISNULL(MAX(Log_ID), 0) + 1 FROM tbl_ParkingLog;

    INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
    SELECT 
        @LogID + ROW_NUMBER() OVER (ORDER BY i.Session_ID) - 1,
        GETDATE(),
        'USER',
        'New parking session created: ' + i.Session_ID + ' for License Plate: ' + i.License_Plate + ' at Garage: ' + i.Garage_ID
    FROM inserted i;
END;
GO

-- 2. CREATE log khi admin sửa hệ thống
CREATE TRIGGER dbo.trg_LogAdminRuleChanges
ON tbl_ParkingRules
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LogID INT;
    SELECT @LogID = ISNULL(MAX(Log_ID), 0) + 1 FROM tbl_ParkingLog;

    INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
    SELECT 
        @LogID + ROW_NUMBER() OVER (ORDER BY i.Rule_ID) - 1,
        GETDATE(),
        'ADMIN',
        'Rule updated: ' + i.Rule_Name + ' (Status: ' + i.Rule_Status + ', Value: ' + ISNULL(i.Rule_Value, 'NULL') + ')'
    FROM inserted i;
END;
GO

-- 3. CREATE warn khi device tới ngày bảo trì
CREATE TRIGGER dbo.trg_WarnDeviceMaintenance
ON tbl_ParkingDevice
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LogID INT;
    SELECT @LogID = ISNULL(MAX(Log_ID), 0) + 1 FROM tbl_ParkingLog;

    INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
    SELECT 
        @LogID + ROW_NUMBER() OVER (ORDER BY i.Device_ID) - 1,
        GETDATE(),
        'WARN',
        'Device requires maintenance: ' + i.Device_ID + ' (IP: ' + i.IP_Address + '). Maintenance date reached: ' + CONVERT(VARCHAR(10), i.Maintenance, 120)
    FROM inserted i
    WHERE i.Maintenance IS NOT NULL AND i.Maintenance <= CAST(GETDATE() AS DATE);
END;
GO

-- 4. CREATE error khi device bị OFFLINE
CREATE TRIGGER dbo.trg_ErrorDeviceOffline
ON tbl_ParkingDevice
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Status)
    BEGIN
        DECLARE @LogID INT;
        SELECT @LogID = ISNULL(MAX(Log_ID), 0) + 1 FROM tbl_ParkingLog;

        INSERT INTO tbl_ParkingLog (Log_ID, Log_Time, Log_Type, Log_Content)
        SELECT 
            @LogID + ROW_NUMBER() OVER (ORDER BY i.Device_ID) - 1,
            GETDATE(),
            'ERROR',
            'Device critical alert: ' + i.Device_ID + ' (IP: ' + i.IP_Address + ') changed status to OFFLINE'
        FROM inserted i
        JOIN deleted d ON i.Device_ID = d.Device_ID
        WHERE i.Status = 'OFFLINE' AND d.Status <> 'OFFLINE';
    END;
END;
GO

-- 5. Update Daily Report với datetime là hôm nay khi có xe ra / vào hoặc khi có log
CREATE TRIGGER dbo.trg_UpdateDailyReport
ON tbl_ParkingLog
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);
    DECLARE @ReportID VARCHAR(10);

    IF NOT EXISTS (SELECT 1 FROM tbl_DailyReport WHERE Report_Date = @Today)
    BEGIN
        SELECT @ReportID = 'DR' + RIGHT('000' + CAST(ISNULL(MAX(CAST(RIGHT(Report_ID, 3) AS INT)), 0) + 1 AS VARCHAR(3)), 3)
        FROM tbl_DailyReport;

        INSERT INTO tbl_DailyReport (
            Report_ID, Report_Date, Total_Revenue, Total_Promotion_Cost, 
            Total_Logs, Total_Errors, Total_Warns, Total_Reservation, Total_Checkin, Total_Checkout
        )
        VALUES (@ReportID, @Today, 0, 0, 0, 0, 0, 0, 0, 0);
    END;

    UPDATE r
    SET 
        r.Total_Logs = (SELECT COUNT(*) FROM tbl_ParkingLog WHERE CAST(Log_Time AS DATE) = @Today),
        r.Total_Errors = (SELECT COUNT(*) FROM tbl_ParkingLog WHERE CAST(Log_Time AS DATE) = @Today AND Log_Type = 'ERROR'),
        r.Total_Warns = (SELECT COUNT(*) FROM tbl_ParkingLog WHERE CAST(Log_Time AS DATE) = @Today AND Log_Type = 'WARN'),
        r.Total_Checkin = (SELECT COUNT(*) FROM tbl_ParkingLog WHERE CAST(Log_Time AS DATE) = @Today AND Log_Content LIKE '%checked in%'),
        r.Total_Checkout = (SELECT COUNT(*) FROM tbl_ParkingLog WHERE CAST(Log_Time AS DATE) = @Today AND Log_Content LIKE '%checked out%'),
        r.Total_Reservation = (SELECT COUNT(*) FROM tbl_ParkingLog WHERE CAST(Log_Time AS DATE) = @Today AND Log_Content LIKE '%reservation%')
    FROM tbl_DailyReport r
    WHERE r.Report_Date = @Today;
END;
GO

PRINT ''
PRINT '5 triggers created'