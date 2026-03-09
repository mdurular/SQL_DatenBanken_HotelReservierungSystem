-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 04: Sichten (Views) erstellen
-- Ausführungsreihenfolge: 4. nach 03_Testdaten_Einfuegen.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- VIEW 1: Reservierungsübersicht (INNER JOIN)
-- Verknüpft: Reservierung, Gast, Zimmer, Hotel,
--            Stadt, Zimmerkategorie, Mitarbeiter
-- ============================================================
CREATE VIEW vw_ReservierungsUebersicht AS
SELECT
    R.ReservierungId,
    G.Vorname + ' ' + G.Nachname        AS GastName,
    G.Email                              AS GastEmail,
    H.HotelName,
    S.StadtName,
    Z.Zimmernummer,
    KG.KategorieName,
    Z.PreisProNacht,
    R.CheckIn,
    R.CheckOut,
    DATEDIFF(DAY, R.CheckIn, R.CheckOut) AS AnzahlNaechte,
    R.GesamtPreis,
    R.AnzahlPersonen,
    R.Status,
    M.Vorname + ' ' + M.Nachname        AS Rezeptionist
FROM Reservierung R
INNER JOIN Gast           G  ON R.GastId       = G.GastId
INNER JOIN Zimmer         Z  ON R.ZimmerId      = Z.ZimmerId
INNER JOIN Hotel          H  ON Z.HotelId       = H.HotelId
INNER JOIN Stadt          S  ON H.StadtId       = S.StadtId
INNER JOIN Zimmerkategorie KG ON Z.KategorieId  = KG.KategorieId
LEFT  JOIN Mitarbeiter    M  ON R.MitarbeiterId = M.MitarbeiterId;
GO

PRINT '>> View vw_ReservierungsUebersicht (INNER JOIN) erstellt.';
GO

-- ============================================================
-- VIEW 2: Hotelstatistik (GROUP BY, COUNT, SUM, AVG, HAVING)
-- ============================================================
CREATE VIEW vw_HotelStatistik AS
SELECT
    H.HotelId,
    H.HotelName,
    H.Sternebewertung,
    S.StadtName,
    COUNT(R.ReservierungId)                   AS AnzahlReservierungen,
    SUM(R.GesamtPreis)                        AS GesamtUmsatz,
    AVG(CAST(R.GesamtPreis AS DECIMAL(10,2))) AS DurchschnittUmsatz,
    AVG(CAST(B.Sterne      AS DECIMAL(3,2)))  AS DurchschnittsBewertung,
    COUNT(B.BewertungId)                      AS AnzahlBewertungen
FROM Hotel H
INNER JOIN Stadt      S  ON H.StadtId         = S.StadtId
INNER JOIN Zimmer     Z  ON H.HotelId         = Z.HotelId
LEFT  JOIN Reservierung R ON Z.ZimmerId       = R.ZimmerId
LEFT  JOIN Bewertung  B  ON R.ReservierungId  = B.ReservierungId
GROUP BY H.HotelId, H.HotelName, H.Sternebewertung, S.StadtName
HAVING COUNT(R.ReservierungId) >= 0;
GO

PRINT '>> View vw_HotelStatistik (GROUP BY / COUNT / SUM) erstellt.';
GO

-- ============================================================
-- VIEW 3: Zimmerauslastung (LEFT OUTER JOIN) – Note: Sehr gut
-- Zeigt ALLE Zimmer, auch ohne aktive Reservierung
-- ============================================================
CREATE VIEW vw_ZimmerAuslastung AS
SELECT
    H.HotelName,
    Z.Zimmernummer,
    KG.KategorieName,
    Z.PreisProNacht,
    Z.IstVerfuegbar,
    R.ReservierungId,
    R.CheckIn,
    R.CheckOut,
    R.Status,
    CASE
        WHEN R.ReservierungId IS NULL THEN 'Noch nie gebucht'
        ELSE G.Vorname + ' ' + G.Nachname
    END AS GastInfo
FROM Zimmer Z
INNER JOIN      Hotel          H  ON Z.HotelId    = H.HotelId
INNER JOIN      Zimmerkategorie KG ON Z.KategorieId = KG.KategorieId
LEFT OUTER JOIN Reservierung   R  ON Z.ZimmerId   = R.ZimmerId AND R.Status = 'Aktiv'
LEFT OUTER JOIN Gast           G  ON R.GastId     = G.GastId;
GO

PRINT '>> View vw_ZimmerAuslastung (LEFT OUTER JOIN) erstellt.';
PRINT '>> Weiter mit 05_Views_Test.sql';
GO
