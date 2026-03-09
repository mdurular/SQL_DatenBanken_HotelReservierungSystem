-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 11: Testskript für den Trigger
-- Ausführungsreihenfolge: 11. nach 10_Trigger.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- TEST 1: Reservierung stornieren
-- Erwartet: Status → Storniert, IstVerfuegbar → 1
-- ============================================================
PRINT '========================================';
PRINT 'TEST 1: Reservierung stornieren';
PRINT '========================================';

PRINT '-- VORHER --';
SELECT R.ReservierungId, R.ZimmerId, R.Status, Z.IstVerfuegbar
FROM Reservierung R
INNER JOIN Zimmer Z ON R.ZimmerId = Z.ZimmerId
WHERE R.ReservierungId = 2;

UPDATE Reservierung SET Status = 'Storniert' WHERE ReservierungId = 2;

PRINT '-- NACHHER --';
SELECT R.ReservierungId, R.ZimmerId, R.Status, Z.IstVerfuegbar
FROM Reservierung R
INNER JOIN Zimmer Z ON R.ZimmerId = Z.ZimmerId
WHERE R.ReservierungId = 2;
GO

-- ============================================================
-- TEST 2: Reservierung abschließen
-- Erwartet: Status → Abgeschlossen, IstVerfuegbar → 1
-- ============================================================
PRINT '========================================';
PRINT 'TEST 2: Reservierung abschließen';
PRINT '========================================';

PRINT '-- VORHER --';
SELECT R.ReservierungId, R.ZimmerId, R.Status, Z.IstVerfuegbar
FROM Reservierung R
INNER JOIN Zimmer Z ON R.ZimmerId = Z.ZimmerId
WHERE R.ReservierungId = 4;

UPDATE Reservierung SET Status = 'Abgeschlossen' WHERE ReservierungId = 4;

PRINT '-- NACHHER --';
SELECT R.ReservierungId, R.ZimmerId, R.Status, Z.IstVerfuegbar
FROM Reservierung R
INNER JOIN Zimmer Z ON R.ZimmerId = Z.ZimmerId
WHERE R.ReservierungId = 4;
GO

-- ============================================================
-- TEST 3: ReservierungsLog prüfen
-- Erwartet: Alle Änderungen sind protokolliert
-- ============================================================
PRINT '========================================';
PRINT 'TEST 3: ReservierungsLog';
PRINT '========================================';

SELECT * FROM ReservierungsLog ORDER BY GeaendertAm DESC;
GO

PRINT '>> Skript 11 abgeschlossen. Weiter mit 12_Cursor.sql';
GO
