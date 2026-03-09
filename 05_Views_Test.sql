-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 05: Testskripte für alle Views
-- Ausführungsreihenfolge: 5. nach 04_Views.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- TEST 1: vw_ReservierungsUebersicht
-- ============================================================
PRINT '========================================';
PRINT 'TEST: vw_ReservierungsUebersicht';
PRINT '========================================';

PRINT '-- Alle aktiven Reservierungen --';
SELECT * FROM vw_ReservierungsUebersicht
WHERE Status = 'Aktiv'
ORDER BY CheckIn;

PRINT '-- Alle abgeschlossenen Reservierungen --';
SELECT * FROM vw_ReservierungsUebersicht
WHERE Status = 'Abgeschlossen'
ORDER BY CheckOut DESC;
GO

-- ============================================================
-- TEST 2: vw_HotelStatistik
-- ============================================================
PRINT '========================================';
PRINT 'TEST: vw_HotelStatistik';
PRINT '========================================';

PRINT '-- Alle Hotels nach Umsatz sortiert --';
SELECT * FROM vw_HotelStatistik
ORDER BY GesamtUmsatz DESC;
GO

-- ============================================================
-- TEST 3: vw_ZimmerAuslastung
-- ============================================================
PRINT '========================================';
PRINT 'TEST: vw_ZimmerAuslastung';
PRINT '========================================';

PRINT '-- Alle Zimmer inkl. nie gebuchte --';
SELECT * FROM vw_ZimmerAuslastung
ORDER BY HotelName, Zimmernummer;

PRINT '-- Nur nie gebuchte Zimmer --';
SELECT * FROM vw_ZimmerAuslastung
WHERE GastInfo = 'Noch nie gebucht';
GO

PRINT '>> Skript 05 abgeschlossen. Weiter mit 06_Funktionen.sql';
GO
