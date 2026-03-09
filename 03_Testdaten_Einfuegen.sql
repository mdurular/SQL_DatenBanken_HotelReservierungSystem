-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 03: Testdaten einfügen
-- Ausführungsreihenfolge: 3. nach 02_Tabellen_Index_Constraints.sql
-- ============================================================

USE HotelReservierung;
GO

-- Länder
INSERT INTO Land (LandName, LandCode) VALUES
    ('Deutschland', 'DE'),
    ('Österreich',  'AT'),
    ('Schweiz',     'CH'),
    ('Türkei',      'TR'),
    ('Frankreich',  'FR');
GO

-- Städte
INSERT INTO Stadt (StadtName, LandId) VALUES
    ('Berlin',   1),
    ('München',  1),
    ('Hamburg',  1),
    ('Wien',     2),
    ('Zürich',   3),
    ('Istanbul', 4),
    ('Paris',    5);
GO

-- Hotels
INSERT INTO Hotel (HotelName, Sternebewertung, Email, Telefon, StadtId) VALUES
    ('Grand Hotel Berlin',     5, 'info@grandberlin.de',          '+49301234567', 1),
    ('Stadthotel München',     4, 'info@stadthotel-muenchen.de',  '+498912345',   2),
    ('Hafen Residenz Hamburg', 4, 'kontakt@hafen-residenz.de',    '+494012345',   3),
    ('Vienna Palace',          5, 'office@viennapalace.at',       '+4315678901',  4),
    ('Zürich Comfort Inn',     3, 'info@zurichcomfort.ch',        '+41443456789', 5);
GO

-- Zimmerkategorien
INSERT INTO Zimmerkategorie (KategorieName, MaxPersonen) VALUES
    ('Einzelzimmer',   1),
    ('Doppelzimmer',   2),
    ('Suite',          4),
    ('Familienzimmer', 5),
    ('Penthouse',      6);
GO

-- Zimmer
INSERT INTO Zimmer (Zimmernummer, HotelId, KategorieId, PreisProNacht, IstVerfuegbar, Beschreibung) VALUES
    ('101', 1, 1,  120.00, 1, 'Einzelzimmer mit Stadtblick'),
    ('102', 1, 2,  180.00, 1, 'Doppelzimmer mit Balkon'),
    ('201', 1, 3,  450.00, 1, 'Luxus-Suite mit Panoramablick'),
    ('101', 2, 1,   90.00, 1, 'Ruhiges Einzelzimmer'),
    ('102', 2, 2,  140.00, 1, 'Doppelzimmer Gartenblick'),
    ('301', 2, 3,  320.00, 1, 'Premium Suite'),
    ('101', 3, 2,  160.00, 1, 'Doppelzimmer Hafenblick'),
    ('201', 3, 4,  280.00, 1, 'Familienzimmer'),
    ('101', 4, 3,  600.00, 1, 'Wiener Suite'),
    ('501', 4, 5, 1200.00, 1, 'Penthouse mit Terrasse');
GO

-- Gäste
INSERT INTO Gast (Vorname, Nachname, Email, Telefon, Geburtsdatum, LandId) VALUES
    ('Anna',   'Müller',  'anna.mueller@email.de',  '+491701234', '1985-06-15', 1),
    ('Thomas', 'Schmidt', 'thomas.schmidt@mail.de', '+491759876', '1990-03-22', 1),
    ('Sophie', 'Wagner',  'sophie.w@mail.at',       '+4369912345','1988-11-30', 2),
    ('Mehmet', 'Yilmaz',  'mehmet.y@email.tr',      '+905321234', '1975-08-10', 4),
    ('Claire', 'Dupont',  'claire.d@mail.fr',       '+33612345',  '1995-01-25', 5),
    ('Stefan', 'Bauer',   'stefan.bauer@mail.de',   '+491771111', '1982-07-14', 1),
    ('Laura',  'Hoffman', 'laura.h@email.de',       '+491762222', '1993-04-05', 1);
GO

-- Mitarbeiter
INSERT INTO Mitarbeiter (Vorname, Nachname, Position, HotelId, Email, EinstellungsDatum) VALUES
    ('Klaus', 'Fischer', 'Rezeptionist', 1, 'k.fischer@grandberlin.de',  '2020-01-15'),
    ('Maria', 'Becker',  'Manager',      1, 'm.becker@grandberlin.de',   '2018-05-01'),
    ('Peter', 'Krause',  'Rezeptionist', 2, 'p.krause@stadthotel.de',    '2021-03-10'),
    ('Julia', 'Wolf',    'Manager',      3, 'j.wolf@hafen-residenz.de',  '2019-07-20'),
    ('Hans',  'Richter', 'Rezeptionist', 4, 'h.richter@viennapalace.at', '2022-01-05');
GO

-- Reservierungen
INSERT INTO Reservierung (GastId, ZimmerId, MitarbeiterId, CheckIn, CheckOut, AnzahlPersonen, Status) VALUES
    (1, 1, 1, '2026-04-01', '2026-04-05', 1, 'Aktiv'),
    (2, 2, 1, '2026-04-10', '2026-04-15', 2, 'Aktiv'),
    (3, 3, 2, '2026-02-01', '2026-02-07', 2, 'Abgeschlossen'),
    (4, 9, 5, '2026-05-05', '2026-05-10', 2, 'Aktiv'),
    (5, 7, 4, '2026-04-20', '2026-04-25', 2, 'Aktiv'),
    (6, 5, 3, '2026-01-15', '2026-01-20', 1, 'Abgeschlossen'),
    (7, 8, 4, '2026-06-01', '2026-06-07', 4, 'Aktiv'),
    (1, 4, 3, '2025-12-24', '2025-12-27', 1, 'Abgeschlossen');
GO

-- GesamtPreis berechnen
UPDATE R
SET R.GesamtPreis = DATEDIFF(DAY, R.CheckIn, R.CheckOut) * Z.PreisProNacht
FROM Reservierung R
INNER JOIN Zimmer Z ON Z.ZimmerId = R.ZimmerId;
GO

-- Zahlungen
INSERT INTO Zahlung (ReservierungId, Betrag, Zahlungsmethode, Bemerkung) VALUES
    (3, 2700.00, 'Kreditkarte', 'Vollständig bezahlt'),
    (6,  700.00, 'Bar',         'Bei Check-in bezahlt'),
    (8,  270.00, 'Überweisung', 'Vorauszahlung');
GO

-- Bewertungen
INSERT INTO Bewertung (ReservierungId, Sterne, Kommentar) VALUES
    (3, 5, 'Fantastisches Hotel! Sehr sauber und freundliches Personal.'),
    (6, 4, 'Gutes Hotel, Frühstück könnte besser sein.'),
    (8, 5, 'Tolles Preis-Leistungs-Verhältnis. Sehr zu empfehlen!');
GO

-- Ausstattung
INSERT INTO Ausstattung (AusstattungName, Beschreibung) VALUES
    ('WLAN',         'Kostenloses WLAN im ganzen Hotel'),
    ('Pool',         'Beheizter Innenpool'),
    ('Spa',          'Wellnessbereich mit Sauna und Massage'),
    ('Restaurant',   'À-la-carte Restaurant'),
    ('Parkplatz',    'Kostenloser Tiefgaragenparkplatz'),
    ('Fitnessstudio','Modernes Fitnesscenter 24/7'),
    ('Bar',          'Hotelbar bis 02:00 Uhr geöffnet');
GO

-- Hotel-Ausstattung Zuordnungen (m:n Beziehung)
INSERT INTO HotelAusstattung (HotelId, AusstattungId) VALUES
    (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),
    (2,1),(2,4),(2,5),
    (3,1),(3,4),(3,7),
    (4,1),(4,2),(4,3),(4,4),(4,6),(4,7),
    (5,1),(5,5);
GO

PRINT '>> Alle Testdaten erfolgreich eingefügt.';
PRINT '>> Weiter mit 04_Views.sql';
GO
