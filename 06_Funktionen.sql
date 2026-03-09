-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 06: Gespeicherte Funktionen erstellen
-- Ausführungsreihenfolge: 6. nach 05_Views_Test.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- SKALARWERTFUNKTION 1: Anzahl der Übernachtungen berechnen
-- Parameter: CheckIn DATE, CheckOut DATE
-- Rückgabe:  INT (0 wenn Eingabe ungültig)
-- ============================================================
CREATE FUNCTION fn_AnzahlNaechte
(
    @CheckIn  DATE,
    @CheckOut DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Naechte INT;

    IF @CheckOut <= @CheckIn
        SET @Naechte = 0;
    ELSE
        SET @Naechte = DATEDIFF(DAY, @CheckIn, @CheckOut);

    RETURN @Naechte;
END;
GO

PRINT '>> fn_AnzahlNaechte erstellt.';
GO

-- ============================================================
-- SKALARWERTFUNKTION 2: Gesamtpreis berechnen
-- Parameter: ZimmerId INT, CheckIn DATE, CheckOut DATE
-- Rückgabe:  DECIMAL(10,2)
-- Verwendet: fn_AnzahlNaechte
-- ============================================================
CREATE FUNCTION fn_GesamtPreisBerechnen
(
    @ZimmerId INT,
    @CheckIn  DATE,
    @CheckOut DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @PreisProNacht DECIMAL(10,2);
    DECLARE @Naechte       INT;
    DECLARE @Gesamtpreis   DECIMAL(10,2);

    SELECT @PreisProNacht = PreisProNacht
    FROM Zimmer WHERE ZimmerId = @ZimmerId;

    SET @Naechte = dbo.fn_AnzahlNaechte(@CheckIn, @CheckOut);

    IF @PreisProNacht IS NULL OR @Naechte = 0
        SET @Gesamtpreis = 0;
    ELSE
        SET @Gesamtpreis = @PreisProNacht * @Naechte;

    RETURN @Gesamtpreis;
END;
GO

PRINT '>> fn_GesamtPreisBerechnen erstellt.';
GO

-- ============================================================
-- SKALARWERTFUNKTION 3: Zimmerverfügbarkeit prüfen
-- Parameter: ZimmerId INT, CheckIn DATE, CheckOut DATE
-- Rückgabe:  BIT (1 = verfügbar, 0 = belegt)
-- ============================================================
CREATE FUNCTION fn_IstZimmerVerfuegbar
(
    @ZimmerId INT,
    @CheckIn  DATE,
    @CheckOut DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @AnzahlKonflikte INT;
    DECLARE @Ergebnis        BIT;

    SELECT @AnzahlKonflikte = COUNT(*)
    FROM Reservierung
    WHERE ZimmerId = @ZimmerId
      AND Status   = 'Aktiv'
      AND NOT (@CheckOut <= CheckIn OR @CheckIn >= CheckOut);

    IF @AnzahlKonflikte > 0
        SET @Ergebnis = 0;
    ELSE
        SET @Ergebnis = 1;

    RETURN @Ergebnis;
END;
GO

PRINT '>> fn_IstZimmerVerfuegbar erstellt.';
GO

-- ============================================================
-- TABELLENWERTFUNKTION: Verfügbare Zimmer suchen
-- Parameter: CheckIn DATE, CheckOut DATE, StadtName NVARCHAR
-- Rückgabe:  Tabelle aller verfügbaren Zimmer in der Stadt
-- Verwendet: fn_GesamtPreisBerechnen, fn_AnzahlNaechte,
--            fn_IstZimmerVerfuegbar
-- ============================================================
CREATE FUNCTION fn_VerfuegbareZimmer
(
    @CheckIn   DATE,
    @CheckOut  DATE,
    @StadtName NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        Z.ZimmerId,
        H.HotelName,
        S.StadtName,
        Z.Zimmernummer,
        KG.KategorieName,
        KG.MaxPersonen,
        Z.PreisProNacht,
        dbo.fn_GesamtPreisBerechnen(Z.ZimmerId, @CheckIn, @CheckOut) AS GesamtPreis,
        dbo.fn_AnzahlNaechte(@CheckIn, @CheckOut)                    AS AnzahlNaechte
    FROM Zimmer Z
    INNER JOIN Hotel           H  ON Z.HotelId    = H.HotelId
    INNER JOIN Stadt           S  ON H.StadtId    = S.StadtId
    INNER JOIN Zimmerkategorie KG ON Z.KategorieId = KG.KategorieId
    WHERE Z.IstVerfuegbar = 1
      AND S.StadtName     = @StadtName
      AND dbo.fn_IstZimmerVerfuegbar(Z.ZimmerId, @CheckIn, @CheckOut) = 1
);
GO

PRINT '>> fn_VerfuegbareZimmer (Tabellenwertfunktion) erstellt.';
PRINT '>> Weiter mit 07_Funktionen_Test.sql';
GO
