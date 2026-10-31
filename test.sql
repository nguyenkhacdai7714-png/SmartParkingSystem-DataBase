USE db_SmartParkingSystem
GO

SELECT Garage_ID, Garage_Address, Total_Spots, Occupied_Spots, Reserved_Spots, Free_Spots 
FROM vw_GarageFreeSpots 
WHERE Free_Spots > 0;
GO