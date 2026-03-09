-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 09: Testskripte für sp_ReservierungErstellen
-- Ausführungsreihenfolge: 9. nach 08_Prozedur.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- TEST 1: Gültige Reservierung → ERFOLG erwartet
-- ============================================================
PRINT '========================================';
PRINT 'TEST 1: Gültige Reservierung';
PRINT '========================================';
DECLARE @NeuId INT; DECLARE @Msg NVARCHAR(500);
EXEC sp_ReservierungErstellen
    @GastId             = 5,
    @ZimmerId           = 6,
    @MitarbeiterId      = 3,
    @CheckIn            = '2026-07-01',
    @CheckOut           = '2026-07-05',
    @AnzahlPersonen     = 2,
    @NeueReservierungId = @NeuId OUTPUT,
    @Fehlermeldung      = @Msg   OUTPUT;
PRINT @Msg;
PRINT 'Neue ID: ' + CAST(@NeuId AS NVARCHAR);
GO

-- ============================================================
-- TEST 2: Zimmer bereits belegt → FEHLER erwartet
-- ============================================================
PRINT '========================================';
PRINT 'TEST 2: Zimmer bereits belegt';
PRINT '========================================';
DECLARE @NeuId INT; DECLARE @Msg NVARCHAR(500);
EXEC sp_ReservierungErstellen
    @GastId             = 2,
    @ZimmerId           = 1,
    @CheckIn            = '2026-04-02',
    @CheckOut           = '2026-04-04',
    @AnzahlPersonen     = 1,
    @NeueReservierungId = @NeuId OUTPUT,
    @Fehlermeldung      = @Msg   OUTPUT;
PRINT @Msg;
GO

-- ============================================================
-- TEST 3: Zu viele Personen → FEHLER erwartet
-- ============================================================
PRINT '========================================';
PRINT 'TEST 3: Zu viele Personen für Einzelzimmer';
PRINT '========================================';
DECLARE @NeuId INT; DECLARE @Msg NVARCHAR(500);
EXEC sp_ReservierungErstellen
    @GastId             = 3,
    @ZimmerId           = 1,
    @CheckIn            = '2026-08-01',
    @CheckOut           = '2026-08-05',
    @AnzahlPersonen     = 3,
    @NeueReservierungId = @NeuId OUTPUT,
    @Fehlermeldung      = @Msg   OUTPUT;
PRINT @Msg;
GO

-- ============================================================
-- TEST 4: CheckIn in der Vergangenheit → FEHLER erwartet
-- ============================================================
PRINT '========================================';
PRINT 'TEST 4: CheckIn in der Vergangenheit';
PRINT '========================================';
DECLARE @NeuId INT; DECLARE @Msg NVARCHAR(500);
EXEC sp_ReservierungErstellen
    @GastId             = 1,
    @ZimmerId           = 2,
    @CheckIn            = '2020-01-01',
    @CheckOut           = '2020-01-05',
    @AnzahlPersonen     = 1,
    @NeueReservierungId = @NeuId OUTPUT,
    @Fehlermeldung      = @Msg   OUTPUT;
PRINT @Msg;
GO

-- ============================================================
-- TEST 5: Ungültiger Gast → FEHLER erwartet
-- ============================================================
PRINT '========================================';
PRINT 'TEST 5: Ungültige Gast-ID';
PRINT '========================================';
DECLARE @NeuId INT; DECLARE @Msg NVARCHAR(500);
EXEC sp_ReservierungErstellen
    @GastId             = 999,
    @ZimmerId           = 2,
    @CheckIn            = '2026-09-01',
    @CheckOut           = '2026-09-05',
    @AnzahlPersonen     = 1,
    @NeueReservierungId = @NeuId OUTPUT,
    @Fehlermeldung      = @Msg   OUTPUT;
PRINT @Msg;
GO

PRINT '>> Skript 09 abgeschlossen. Weiter mit 10_Trigger.sql';
GO
