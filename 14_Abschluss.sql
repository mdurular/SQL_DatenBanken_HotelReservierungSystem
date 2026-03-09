-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 14: Abschlussübersicht & Gesamttest
-- Ausführungsreihenfolge: 14. – letztes Skript
-- ============================================================

USE HotelReservierung;
GO

PRINT '========================================';
PRINT ' ABSCHLUSSÜBERSICHT – HotelReservierung ';
PRINT '========================================';

-- Alle DB-Objekte zählen
SELECT 'Tabellen'                AS Typ, COUNT(*) AS Anzahl FROM sys.tables
UNION ALL
SELECT 'Views',                           COUNT(*) FROM sys.views
UNION ALL
SELECT 'Funktionen',                      COUNT(*) FROM sys.objects WHERE type IN ('FN','IF','TF')
UNION ALL
SELECT 'Prozeduren',                      COUNT(*) FROM sys.procedures
UNION ALL
SELECT 'Trigger',                         COUNT(*) FROM sys.triggers
UNION ALL
SELECT 'Indizes (NONCLUSTERED)',          COUNT(*) FROM sys.indexes WHERE type = 2
UNION ALL
SELECT 'DB-Benutzer',                     COUNT(*) FROM sys.database_principals
                                                    WHERE type = 'S'
                                                      AND name NOT IN ('guest','INFORMATION_SCHEMA','sys');
GO

-- Datensätze pro Tabelle
PRINT '-- Datensätze pro Tabelle --';
SELECT
    t.name   AS Tabelle,
    p.rows   AS Zeilenanzahl
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
ORDER BY t.name;
GO

-- Aktive Reservierungen
PRINT '-- Aktive Reservierungen --';
SELECT * FROM vw_ReservierungsUebersicht
WHERE Status = 'Aktiv'
ORDER BY CheckIn;
GO

-- Hotelstatistik
PRINT '-- Hotelstatistik --';
SELECT * FROM vw_HotelStatistik
ORDER BY GesamtUmsatz DESC;
GO

-- Verfügbare Zimmer in Berlin
PRINT '-- Verfügbare Zimmer in Berlin (Mai 2026) --';
SELECT * FROM dbo.fn_VerfuegbareZimmer('2026-05-10', '2026-05-15', 'Berlin')
ORDER BY PreisProNacht;
GO

-- ReservierungsLog
PRINT '-- ReservierungsLog --';
SELECT * FROM ReservierungsLog ORDER BY GeaendertAm DESC;
GO

PRINT '========================================';
PRINT '>> ALLE 14 SKRIPTE ERFOLGREICH ABGESCHLOSSEN!';
PRINT '>> Hotel-Reservierungssystem ist vollständig bereit.';
PRINT '========================================';
GO
