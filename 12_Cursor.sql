-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 12: Cursor – Note: Sehr gut
-- Ausführungsreihenfolge: 12. nach 11_Trigger_Test.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- CURSOR: Bewertungserinnerungen generieren
--
-- Logik: Alle abgeschlossenen Reservierungen ohne Bewertung
--        werden zeilenweise durchlaufen und eine persönliche
--        Erinnerungsnachricht wird ausgegeben.
--
-- Praxisbeispiel: In einem echten System würde diese Ausgabe
--        an ein E-Mail-System weitergegeben, das automatisch
--        Erinnerungsmails an die Gäste versendet
--        (z.B. wie bei Booking.com oder Airbnb).
-- ============================================================

DECLARE @ResId     INT;
DECLARE @GastName  NVARCHAR(200);
DECLARE @HotelName NVARCHAR(150);
DECLARE @CheckOut  DATE;
DECLARE @Counter   INT = 0;

PRINT '========================================';
PRINT 'CURSOR: Bewertungserinnerungen';
PRINT '========================================';

DECLARE cur_OhneBewertung CURSOR FOR
    SELECT
        R.ReservierungId,
        G.Vorname + ' ' + G.Nachname AS GastName,
        H.HotelName,
        R.CheckOut
    FROM Reservierung R
    INNER JOIN Gast   G ON R.GastId   = G.GastId
    INNER JOIN Zimmer Z ON R.ZimmerId = Z.ZimmerId
    INNER JOIN Hotel  H ON Z.HotelId  = H.HotelId
    WHERE R.Status = 'Abgeschlossen'
      AND NOT EXISTS (
          SELECT 1 FROM Bewertung B
          WHERE B.ReservierungId = R.ReservierungId
      );

OPEN cur_OhneBewertung;
FETCH NEXT FROM cur_OhneBewertung INTO @ResId, @GastName, @HotelName, @CheckOut;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Counter += 1;
    PRINT 'Erinnerung #' + CAST(@Counter AS NVARCHAR) + ': ' +
          'Liebe/r ' + @GastName +
          ', bitte bewerten Sie Ihren Aufenthalt im ' + @HotelName +
          ' (Check-out: ' + CAST(@CheckOut AS NVARCHAR) + ').';

    FETCH NEXT FROM cur_OhneBewertung INTO @ResId, @GastName, @HotelName, @CheckOut;
END;

CLOSE      cur_OhneBewertung;
DEALLOCATE cur_OhneBewertung;

PRINT '---';
PRINT 'Insgesamt ' + CAST(@Counter AS NVARCHAR) + ' Erinnerungen generiert.';
GO

PRINT '>> Skript 12 abgeschlossen. Weiter mit 13_Benutzer_Rechte.sql';
GO
