-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 00: Cleanup – alte Datenbank löschen
-- Ausführungsreihenfolge: ZUERST ausführen!
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'HotelReservierung')
BEGIN
    ALTER DATABASE HotelReservierung SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HotelReservierung;
    PRINT '>> Alte Datenbank wurde gelöscht.';
END
ELSE
    PRINT '>> Datenbank existiert noch nicht – OK.';
GO
