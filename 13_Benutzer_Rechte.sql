-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 13: Datenbankbenutzer & Rechte
-- Ausführungsreihenfolge: 13. nach 12_Cursor.sql
-- ============================================================

-- ============================================================
-- BENUTZER 1: HotelLeser
-- Rolle: Nur Lesezugriff (z.B. Buchhaltung, Controlling)
-- ============================================================
USE HotelReservierung;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'HotelLeser')
    CREATE LOGIN HotelLeser WITH PASSWORD = 'Lesen#2026!';
GO

USE HotelReservierung;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'HotelLeser')
    CREATE USER HotelLeser FOR LOGIN HotelLeser;
GO

GRANT SELECT ON SCHEMA::dbo TO HotelLeser;
GO

PRINT '>> Benutzer HotelLeser erstellt (nur SELECT).';
GO

-- ============================================================
-- BENUTZER 2: HotelRezeption
-- Rolle: Tagesgeschäft – lesen, schreiben, ausführen
-- ============================================================
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'HotelRezeption')
    CREATE LOGIN HotelRezeption WITH PASSWORD = 'Rezeption#2026!';
GO

USE HotelReservierung;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'HotelRezeption')
    CREATE USER HotelRezeption FOR LOGIN HotelRezeption;
GO

GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo  TO HotelRezeption;
GRANT EXECUTE ON dbo.sp_ReservierungErstellen TO HotelRezeption;
GRANT EXECUTE ON dbo.fn_AnzahlNaechte         TO HotelRezeption;
GRANT EXECUTE ON dbo.fn_GesamtPreisBerechnen  TO HotelRezeption;
GRANT EXECUTE ON dbo.fn_IstZimmerVerfuegbar   TO HotelRezeption;
GRANT SELECT  ON dbo.fn_VerfuegbareZimmer     TO HotelRezeption;
GO

PRINT '>> Benutzer HotelRezeption erstellt (SELECT/INSERT/UPDATE + EXECUTE).';
PRINT '>> Weiter mit 14_Abschluss.sql';
GO
