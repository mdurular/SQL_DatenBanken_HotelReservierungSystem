-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 10: Trigger erstellen
-- Ausführungsreihenfolge: 10. nach 09_Prozedur_Test.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- TRIGGER: trg_Reservierung_StatusAenderung
-- Tabelle:  Reservierung
-- Ereignis: AFTER INSERT, UPDATE
--
-- Business-Logik:
--   1. Jede Änderung in ReservierungsLog protokollieren
--   2. Zimmerstatus automatisch aktualisieren:
--      → Status 'Storniert' / 'Abgeschlossen'
--        = Zimmer wieder verfügbar (IstVerfuegbar = 1)
--      → Neue aktive Reservierung im laufenden Zeitraum
--        = Zimmer belegt (IstVerfuegbar = 0)
-- ============================================================
CREATE TRIGGER trg_Reservierung_StatusAenderung
ON Reservierung
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- TEIL 1: Statusänderung protokollieren
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO ReservierungsLog (ReservierungId, Aktion, AlterStatus, NeuerStatus)
        SELECT
            i.ReservierungId,
            CASE
                WHEN EXISTS (SELECT 1 FROM deleted d WHERE d.ReservierungId = i.ReservierungId)
                THEN 'UPDATE'
                ELSE 'INSERT'
            END      AS Aktion,
            d.Status AS AlterStatus,
            i.Status AS NeuerStatus
        FROM inserted i
        LEFT JOIN deleted d ON i.ReservierungId = d.ReservierungId;
    END;

    -- TEIL 2: Zimmer wieder freigeben
    UPDATE Zimmer
    SET IstVerfuegbar = 1
    WHERE ZimmerId IN (
        SELECT i.ZimmerId
        FROM inserted i
        WHERE i.Status IN ('Storniert', 'Abgeschlossen')
          AND NOT EXISTS (
              SELECT 1 FROM Reservierung R
              WHERE R.ZimmerId       = i.ZimmerId
                AND R.Status         = 'Aktiv'
                AND R.ReservierungId <> i.ReservierungId
          )
    );

    -- TEIL 3: Zimmer als belegt markieren
    UPDATE Zimmer
    SET IstVerfuegbar = 0
    WHERE ZimmerId IN (
        SELECT i.ZimmerId
        FROM inserted i
        WHERE i.Status   = 'Aktiv'
          AND i.CheckIn  <= CAST(GETDATE() AS DATE)
          AND i.CheckOut >  CAST(GETDATE() AS DATE)
    );
END;
GO

PRINT '>> Trigger trg_Reservierung_StatusAenderung erstellt.';
PRINT '>> Weiter mit 11_Trigger_Test.sql';
GO
