-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 07: Testskripte für alle Funktionen
-- Ausführungsreihenfolge: 7. nach 06_Funktionen.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- TEST: fn_AnzahlNaechte
-- ============================================================
PRINT '========================================';
PRINT 'TEST: fn_AnzahlNaechte';
PRINT '========================================';

SELECT dbo.fn_AnzahlNaechte('2026-04-01', '2026-04-05') AS Naechte_Erwartet_4;
SELECT dbo.fn_AnzahlNaechte('2026-04-01', '2026-04-01') AS Naechte_Erwartet_0_GleicherTag;
SELECT dbo.fn_AnzahlNaechte('2026-04-05', '2026-04-01') AS Naechte_Erwartet_0_Ungueltig;
GO

-- ============================================================
-- TEST: fn_GesamtPreisBerechnen
-- ============================================================
PRINT '========================================';
PRINT 'TEST: fn_GesamtPreisBerechnen';
PRINT '========================================';

-- Zimmer 1 (120 EUR) x 4 Nächte = 480 EUR
SELECT dbo.fn_GesamtPreisBerechnen(1, '2026-04-01', '2026-04-05') AS Preis_Erwartet_480;

-- Zimmer 3 (450 EUR) x 7 Nächte = 3150 EUR
SELECT dbo.fn_GesamtPreisBerechnen(3, '2026-05-01', '2026-05-08') AS Preis_Erwartet_3150;

-- Ungültige ZimmerId → 0 erwartet
SELECT dbo.fn_GesamtPreisBerechnen(999, '2026-04-01', '2026-04-05') AS Preis_Erwartet_0;
GO

-- ============================================================
-- TEST: fn_IstZimmerVerfuegbar
-- ============================================================
PRINT '========================================';
PRINT 'TEST: fn_IstZimmerVerfuegbar';
PRINT '========================================';

-- Zimmer 1 belegt 01.04–05.04 → 0 erwartet
SELECT dbo.fn_IstZimmerVerfuegbar(1, '2026-04-02', '2026-04-04') AS Verfuegbar_Erwartet_0;

-- Zimmer 1 im Juni → frei → 1 erwartet
SELECT dbo.fn_IstZimmerVerfuegbar(1, '2026-06-01', '2026-06-05') AS Verfuegbar_Erwartet_1;

-- Grenzfall: genau angrenzend → 1 erwartet
SELECT dbo.fn_IstZimmerVerfuegbar(1, '2026-04-05', '2026-04-10') AS Verfuegbar_Erwartet_1_Grenzfall;
GO

-- ============================================================
-- TEST: fn_VerfuegbareZimmer (Tabellenwertfunktion)
-- ============================================================
PRINT '========================================';
PRINT 'TEST: fn_VerfuegbareZimmer';
PRINT '========================================';

PRINT '-- Verfügbare Zimmer in Berlin (Mai 2026) --';
SELECT * FROM dbo.fn_VerfuegbareZimmer('2026-05-10', '2026-05-15', 'Berlin')
ORDER BY PreisProNacht;

PRINT '-- Verfügbare Zimmer in Wien (Juni 2026) --';
SELECT * FROM dbo.fn_VerfuegbareZimmer('2026-06-01', '2026-06-05', 'Wien')
ORDER BY PreisProNacht;

PRINT '-- Nicht vorhandene Stadt → leeres Ergebnis erwartet --';
SELECT * FROM dbo.fn_VerfuegbareZimmer('2026-05-01', '2026-05-05', 'Frankfurt');
GO

PRINT '>> Skript 07 abgeschlossen. Weiter mit 08_Prozedur.sql';
GO
