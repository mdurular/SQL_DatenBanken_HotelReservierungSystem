-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 08: Gespeicherte Prozedur erstellen
-- Ausführungsreihenfolge: 8. nach 07_Funktionen_Test.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- STORED PROCEDURE: sp_ReservierungErstellen
--
-- Erstellt eine neue Reservierung mit vollständiger
-- Business-Logik-Prüfung und Fehlerbehandlung.
--
-- Eingabeparameter:
--   @GastId         INT     – ID des Gastes
--   @ZimmerId       INT     – ID des Zimmers
--   @MitarbeiterId  INT     – ID des Mitarbeiters (optional)
--   @CheckIn        DATE    – Anreisedatum
--   @CheckOut       DATE    – Abreisedatum
--   @AnzahlPersonen TINYINT – Personenanzahl (Standard: 1)
--
-- Ausgabeparameter:
--   @NeueReservierungId INT     – ID der erstellten Reservierung
--   @Fehlermeldung NVARCHAR(500) – Erfolgs- oder Fehlermeldung
-- ============================================================
CREATE PROCEDURE sp_ReservierungErstellen
    @GastId             INT,
    @ZimmerId           INT,
    @MitarbeiterId      INT = NULL,
    @CheckIn            DATE,
    @CheckOut           DATE,
    @AnzahlPersonen     TINYINT = 1,
    @NeueReservierungId INT OUTPUT,
    @Fehlermeldung      NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @NeueReservierungId = 0;
    SET @Fehlermeldung      = '';

    BEGIN TRY

        -- VALIDIERUNG 1: Gast muss existieren
        IF NOT EXISTS (SELECT 1 FROM Gast WHERE GastId = @GastId)
        BEGIN
            SET @Fehlermeldung = 'FEHLER: Gast mit ID ' + CAST(@GastId AS NVARCHAR) + ' nicht gefunden.';
            RETURN;
        END;

        -- VALIDIERUNG 2: Zimmer muss existieren
        IF NOT EXISTS (SELECT 1 FROM Zimmer WHERE ZimmerId = @ZimmerId)
        BEGIN
            SET @Fehlermeldung = 'FEHLER: Zimmer mit ID ' + CAST(@ZimmerId AS NVARCHAR) + ' nicht gefunden.';
            RETURN;
        END;

        -- VALIDIERUNG 3: CheckIn nicht in der Vergangenheit
        IF @CheckIn < CAST(GETDATE() AS DATE)
        BEGIN
            SET @Fehlermeldung = 'FEHLER: Check-in Datum (' + CAST(@CheckIn AS NVARCHAR) + ') liegt in der Vergangenheit.';
            RETURN;
        END;

        -- VALIDIERUNG 4: CheckOut muss nach CheckIn liegen
        IF dbo.fn_AnzahlNaechte(@CheckIn, @CheckOut) <= 0
        BEGIN
            SET @Fehlermeldung = 'FEHLER: Check-out muss nach Check-in liegen.';
            RETURN;
        END;

        -- VALIDIERUNG 5: Personenanzahl vs. Zimmerkapazität
        DECLARE @MaxPersonen TINYINT;
        SELECT @MaxPersonen = KG.MaxPersonen
        FROM Zimmer Z
        INNER JOIN Zimmerkategorie KG ON Z.KategorieId = KG.KategorieId
        WHERE Z.ZimmerId = @ZimmerId;

        IF @AnzahlPersonen > @MaxPersonen
        BEGIN
            SET @Fehlermeldung = 'FEHLER: Zimmer hat max. ' + CAST(@MaxPersonen AS NVARCHAR) +
                                 ' Personen Kapazität. Gewünscht: ' + CAST(@AnzahlPersonen AS NVARCHAR) + '.';
            RETURN;
        END;

        -- VALIDIERUNG 6: Zimmerverfügbarkeit prüfen
        IF dbo.fn_IstZimmerVerfuegbar(@ZimmerId, @CheckIn, @CheckOut) = 0
        BEGIN
            SET @Fehlermeldung = 'FEHLER: Zimmer ' + CAST(@ZimmerId AS NVARCHAR) +
                                 ' ist vom ' + CAST(@CheckIn AS NVARCHAR) +
                                 ' bis ' + CAST(@CheckOut AS NVARCHAR) + ' nicht verfügbar.';
            RETURN;
        END;

        -- RESERVIERUNG ANLEGEN
        DECLARE @Gesamtpreis DECIMAL(10,2);
        SET @Gesamtpreis = dbo.fn_GesamtPreisBerechnen(@ZimmerId, @CheckIn, @CheckOut);

        BEGIN TRANSACTION;

            INSERT INTO Reservierung
                (GastId, ZimmerId, MitarbeiterId, CheckIn, CheckOut, AnzahlPersonen, GesamtPreis, Status)
            VALUES
                (@GastId, @ZimmerId, @MitarbeiterId, @CheckIn, @CheckOut, @AnzahlPersonen, @Gesamtpreis, 'Aktiv');

            SET @NeueReservierungId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @Fehlermeldung = 'ERFOLG: Reservierung #' + CAST(@NeueReservierungId AS NVARCHAR) +
                             ' erstellt. Gesamtpreis: ' + CAST(@Gesamtpreis AS NVARCHAR) + ' EUR.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SET @Fehlermeldung      = 'SYSTEMFEHLER: ' + ERROR_MESSAGE();
        SET @NeueReservierungId = -1;
    END CATCH;
END;
GO

PRINT '>> sp_ReservierungErstellen erfolgreich erstellt.';
PRINT '>> Weiter mit 09_Prozedur_Test.sql';
GO
