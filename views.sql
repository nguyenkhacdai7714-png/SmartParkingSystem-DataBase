USE db_SmartParkingSystem;
GO

IF OBJECT_ID('vw_GarageFreeSpots', 'V') IS NOT NULL DROP VIEW vw_GarageFreeSpots;
GO
IF OBJECT_ID('vw_DailyRevenueGrowth', 'V') IS NOT NULL DROP VIEW vw_DailyRevenueGrowth;
GO

CREATE VIEW vw_GarageFreeSpots AS
SELECT g.Garage_ID,
       g.Garage_Address,
       COALESCE(sp.Total_Spots, 0)    AS Total_Spots,
       COALESCE(ss.Occupied_Spots, 0) AS Occupied_Spots,
       COALESCE(rv.Reserved_Spots, 0) AS Reserved_Spots,
       CASE WHEN COALESCE(sp.Total_Spots, 0) - COALESCE(ss.Occupied_Spots, 0) - COALESCE(rv.Reserved_Spots, 0) < 0
            THEN 0
            ELSE COALESCE(sp.Total_Spots, 0) - COALESCE(ss.Occupied_Spots, 0) - COALESCE(rv.Reserved_Spots, 0)
       END AS Free_Spots
FROM tbl_ParkingGarage g
LEFT JOIN (SELECT f.Garage_ID, COUNT(*) AS Total_Spots
           FROM tbl_ParkingFloor f
           INNER JOIN tbl_Spot s ON s.Floor_ID = f.Floor_ID
           WHERE s.Spot_Type = 'PARKING'
           GROUP BY f.Garage_ID) sp ON sp.Garage_ID = g.Garage_ID
LEFT JOIN (SELECT Garage_ID, COUNT(*) AS Occupied_Spots
           FROM tbl_ParkingSession
           WHERE Checkout_Time IS NULL
           GROUP BY Garage_ID) ss ON ss.Garage_ID = g.Garage_ID
LEFT JOIN (SELECT Garage_ID, COUNT(*) AS Reserved_Spots
           FROM tbl_Reservation
           WHERE Status = 'WAITING'
           GROUP BY Garage_ID) rv ON rv.Garage_ID = g.Garage_ID;
GO

CREATE VIEW vw_DailyRevenueGrowth AS
SELECT Report_Date,
       Total_Revenue,
       Previous_Revenue,
       CASE WHEN Previous_Revenue IS NULL OR Previous_Revenue = 0 THEN NULL
            ELSE CAST(ROUND((Total_Revenue - Previous_Revenue) * 100.0 / Previous_Revenue, 2) AS DECIMAL(18,2))
       END AS Growth_Percent
FROM (SELECT Report_Date,
             Total_Revenue,
             LAG(Total_Revenue) OVER (ORDER BY Report_Date) AS Previous_Revenue
      FROM tbl_DailyReport) AS T;
GO


PRINT ''
PRINT '2 views created'
GO
