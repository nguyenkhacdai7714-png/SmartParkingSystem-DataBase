
USE db_SmartParkingSystem;
GO

-- =============================================
-- DROP EXISTING FUNCTIONS
-- =============================================

IF OBJECT_ID('dbo.fn_GetAvailableParkingSpots', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetAvailableParkingSpots;
GO

IF OBJECT_ID('dbo.fn_GetTotalUsers', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetTotalUsers;
GO

IF OBJECT_ID('dbo.fn_GetTotalVehicles', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetTotalVehicles;
GO

IF OBJECT_ID('dbo.fn_GetReservationsAtTime', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetReservationsAtTime;
GO

IF OBJECT_ID('dbo.fn_CalculateCheckoutAmount', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_CalculateCheckoutAmount;
GO


-- =============================================
-- 1. GET AVAILABLE PARKING SPOTS
-- Count EMPTY parking and electric spots
-- =============================================

CREATE FUNCTION dbo.fn_GetAvailableParkingSpots
(
    @Garage_ID VARCHAR(10)
)
RETURNS INT
AS
BEGIN
    DECLARE @AvailableSpots INT;

    SELECT @AvailableSpots = COUNT(d.Device_ID)
    FROM tbl_ParkingDevice d
    JOIN tbl_Spot s
        ON d.Spot_ID = s.Spot_ID
    JOIN tbl_ParkingFloor f
        ON s.Floor_ID = f.Floor_ID
    WHERE f.Garage_ID = @Garage_ID
      AND s.Spot_Type IN ('PARKING', 'ELECTRIC')
      AND d.Status = 'EMPTY';

    RETURN ISNULL(@AvailableSpots, 0);
END;
GO


-- =============================================
-- 2. GET TOTAL USERS
-- =============================================

CREATE FUNCTION dbo.fn_GetTotalUsers()
RETURNS INT
AS
BEGIN
    DECLARE @TotalUsers INT;

    SELECT @TotalUsers = COUNT(User_ID)
    FROM tbl_User;

    RETURN ISNULL(@TotalUsers, 0);
END;
GO


-- =============================================
-- 3. GET TOTAL REGISTERED VEHICLES
-- Only count vehicles associated with users
-- =============================================

CREATE FUNCTION dbo.fn_GetTotalVehicles()
RETURNS INT
AS
BEGIN
    DECLARE @TotalVehicles INT;

    SELECT @TotalVehicles = COUNT(License_Plate)
    FROM tbl_Vehicle
    WHERE User_ID IS NOT NULL;

    RETURN ISNULL(@TotalVehicles, 0);
END;
GO


-- =============================================
-- 4. GET WAITING RESERVATIONS AT SPECIFIC TIME
-- =============================================

CREATE FUNCTION dbo.fn_GetReservationsAtTime
(
    @CheckTime DATETIME
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Reservation_ID,
        User_ID,
        Garage_ID,
        'From :' + CONVERT(VARCHAR(16), Start_Time, 120) AS [Start_Time],
        'To :' + CONVERT(VARCHAR(16), End_Time, 120) AS [End_Time],
        Status,
        Deposit_Amount
    FROM tbl_Reservation
    WHERE Start_Time <= @CheckTime
      AND End_Time >= @CheckTime
      AND Status = 'WAITING'
);
GO


-- =============================================
-- 5. CALCULATE CHECKOUT AMOUNT
-- Base price: 5,000 VND/hour
-- Promotion: PERCENTAGE or FIXED
-- =============================================

CREATE FUNCTION dbo.fn_CalculateCheckoutAmount
(
    @Session_ID VARCHAR(10)
)
RETURNS @ResultTable TABLE 
(
    Session_ID VARCHAR(10),
    Checkin_Time DATETIME,
    Checkout_Time DATETIME,
    Total_Hours INT,
    Base_Price INT,
    Before_Promotion DECIMAL(15,2),
    Promo_Code VARCHAR(20),
    Promo_Type VARCHAR(20),
    Promo_Value DECIMAL(10,2),
    Final_Amount DECIMAL(15,2)
)
AS
BEGIN
    DECLARE @Checkin_Time DATETIME;
    DECLARE @Checkout_Time DATETIME;
    DECLARE @PromoCode VARCHAR(20);
    DECLARE @PromoType VARCHAR(20) = 'NONE';
    DECLARE @PromoValue DECIMAL(10,2) = 0;
    DECLARE @BasePrice INT;
    DECLARE @TotalHours INT;
    DECLARE @BeforePromotion DECIMAL(15,2) = 0;
    DECLARE @FinalAmount DECIMAL(15,2) = 0;

    SELECT
        @Checkin_Time = Checkin_Time,
        @Checkout_Time = ISNULL(Checkout_Time, GETDATE()),
        @PromoCode = Promotion_Code
    FROM tbl_ParkingSession
    WHERE Session_ID = @Session_ID;

    IF @Checkin_Time IS NULL
        RETURN;

    SELECT @BasePrice = CAST(Rule_Value AS INT)
    FROM tbl_ParkingRules
    WHERE Rule_ID = 'R011';

    SET @BasePrice = ISNULL(@BasePrice, 0);

     SET @TotalHours = CEILING(DATEDIFF(SECOND, @Checkin_Time, @Checkout_Time) / 3600.0);

     IF @TotalHours <= 0
        SET @TotalHours = 1;

     SET @BeforePromotion = @TotalHours * @BasePrice;
    SET @FinalAmount = @BeforePromotion;

     IF @PromoCode IS NOT NULL
    BEGIN
        SELECT
            @PromoType = Promotion_Type,
            @PromoValue = Promotion_Value
        FROM tbl_Promotion
        WHERE Promotion_Code = @PromoCode;

        IF @PromoType = 'PERCENTAGE'
        BEGIN
            SET @FinalAmount = @BeforePromotion * (1 - (@PromoValue / 100.0));
        END
        ELSE IF @PromoType = 'FIXED'
        BEGIN
            SET @FinalAmount = @BeforePromotion - @PromoValue;
        END
    END;

    IF @FinalAmount < 0
        SET @FinalAmount = 0;

     INSERT INTO @ResultTable
    VALUES (
        @Session_ID, 
        @Checkin_Time, 
        @Checkout_Time, 
        @TotalHours, 
        @BasePrice, 
        @BeforePromotion,
        @PromoCode, 
        @PromoType, 
        @PromoValue, 
        @FinalAmount
    );

    RETURN;
END;
GO

PRINT ''
PRINT '5 functions created'