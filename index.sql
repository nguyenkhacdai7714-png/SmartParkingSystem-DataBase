USE db_SmartParkingSystem;
GO

-- =========================================================================
-- DROP EXISTING INDEXES (GOM TẤT CẢ LÊN ĐẦU FILE)
-- =========================================================================

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_tbl_User_Phone' AND object_id = OBJECT_ID('dbo.tbl_User'))
BEGIN
    DROP INDEX IX_tbl_User_Phone ON tbl_User;
END;
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_tbl_DailyReport_Date_Revenue' AND object_id = OBJECT_ID('dbo.tbl_DailyReport'))
BEGIN
    DROP INDEX IX_tbl_DailyReport_Date_Revenue ON tbl_DailyReport;
END;
GO


-- =========================================================================
-- CREATE INDEXES
-- =========================================================================

CREATE NONCLUSTERED INDEX IX_tbl_User_Phone
ON tbl_User (Phone);
GO

CREATE NONCLUSTERED INDEX IX_tbl_DailyReport_Date_Revenue
ON tbl_DailyReport (Report_Date)
INCLUDE (Total_Revenue);
GO

PRINT ''
PRINT '2 indexes created'
GO