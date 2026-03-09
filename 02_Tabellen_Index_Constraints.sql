-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 02: Tabellen, Indizes, Fremdschlüssel & Constraints
-- Ausführungsreihenfolge: 2. nach 01_Datenbank_Erstellen.sql
-- ============================================================

USE HotelReservierung;
GO

-- ============================================================
-- TABELLEN ERSTELLEN
-- ============================================================

-- Tabelle: Land
CREATE TABLE Land (
    LandId      INT IDENTITY(1,1) PRIMARY KEY,
    LandName    NVARCHAR(100) NOT NULL,
    LandCode    CHAR(2) NOT NULL UNIQUE  -- z.B. DE, TR, AT
);
GO

-- Tabelle: Stadt
CREATE TABLE Stadt (
    StadtId     INT IDENTITY(1,1) PRIMARY KEY,
    StadtName   NVARCHAR(100) NOT NULL,
    LandId      INT NOT NULL
);
GO

-- Tabelle: Hotel
CREATE TABLE Hotel (
    HotelId         INT IDENTITY(1,1) PRIMARY KEY,
    HotelName       NVARCHAR(150) NOT NULL,
    Sternebewertung TINYINT NOT NULL DEFAULT 3,
    Email           NVARCHAR(150),
    Telefon         NVARCHAR(30),
    StadtId         INT NOT NULL,
    ErstelltAm      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabelle: Zimmerkategorie
CREATE TABLE Zimmerkategorie (
    KategorieId     INT IDENTITY(1,1) PRIMARY KEY,
    KategorieName   NVARCHAR(50) NOT NULL,  -- Einzelzimmer, Doppelzimmer, Suite
    MaxPersonen     TINYINT NOT NULL DEFAULT 2
);
GO

-- Tabelle: Zimmer
CREATE TABLE Zimmer (
    ZimmerId        INT IDENTITY(1,1) PRIMARY KEY,
    Zimmernummer    NVARCHAR(10) NOT NULL,
    HotelId         INT NOT NULL,
    KategorieId     INT NOT NULL,
    PreisProNacht   DECIMAL(10,2) NOT NULL,
    IstVerfuegbar   BIT NOT NULL DEFAULT 1,
    Beschreibung    NVARCHAR(500)
);
GO

-- Tabelle: Gast
CREATE TABLE Gast (
    GastId          INT IDENTITY(1,1) PRIMARY KEY,
    Vorname         NVARCHAR(100) NOT NULL,
    Nachname        NVARCHAR(100) NOT NULL,
    Email           NVARCHAR(150) NOT NULL UNIQUE,
    Telefon         NVARCHAR(30),
    Geburtsdatum    DATE,
    LandId          INT,
    ErstelltAm      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabelle: Mitarbeiter
CREATE TABLE Mitarbeiter (
    MitarbeiterId     INT IDENTITY(1,1) PRIMARY KEY,
    Vorname           NVARCHAR(100) NOT NULL,
    Nachname          NVARCHAR(100) NOT NULL,
    Position          NVARCHAR(100) NOT NULL,
    HotelId           INT NOT NULL,
    Email             NVARCHAR(150),
    EinstellungsDatum DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
GO

-- Tabelle: Reservierung (Kernentität)
CREATE TABLE Reservierung (
    ReservierungId  INT IDENTITY(1,1) PRIMARY KEY,
    GastId          INT NOT NULL,
    ZimmerId        INT NOT NULL,
    MitarbeiterId   INT,
    CheckIn         DATE NOT NULL,
    CheckOut        DATE NOT NULL,
    AnzahlPersonen  TINYINT NOT NULL DEFAULT 1,
    GesamtPreis     DECIMAL(10,2),
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Aktiv',
    ErstelltAm      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabelle: Zahlung
CREATE TABLE Zahlung (
    ZahlungId       INT IDENTITY(1,1) PRIMARY KEY,
    ReservierungId  INT NOT NULL,
    Betrag          DECIMAL(10,2) NOT NULL,
    Zahlungsmethode NVARCHAR(50) NOT NULL DEFAULT 'Kreditkarte',
    ZahlungsDatum   DATETIME NOT NULL DEFAULT GETDATE(),
    Bemerkung       NVARCHAR(300)
);
GO

-- Tabelle: Bewertung (1:1 zu Reservierung)
CREATE TABLE Bewertung (
    BewertungId     INT IDENTITY(1,1) PRIMARY KEY,
    ReservierungId  INT NOT NULL UNIQUE,
    Sterne          TINYINT NOT NULL,
    Kommentar       NVARCHAR(1000),
    BewertungsDatum DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabelle: Ausstattung (Ausstattungsmerkmale)
CREATE TABLE Ausstattung (
    AusstattungId   INT IDENTITY(1,1) PRIMARY KEY,
    AusstattungName NVARCHAR(100) NOT NULL,
    Beschreibung    NVARCHAR(300)
);
GO

-- Tabelle: HotelAusstattung (m:n Verbindungstabelle Hotel <-> Ausstattung) 
CREATE TABLE HotelAusstattung (
    HotelId         INT NOT NULL,
    AusstattungId   INT NOT NULL,
    CONSTRAINT PK_HotelAusstattung PRIMARY KEY (HotelId, AusstattungId)
);
GO

-- Tabelle: ReservierungsLog (Trigger-Protokolltabelle)
CREATE TABLE ReservierungsLog (
    LogId           INT IDENTITY(1,1) PRIMARY KEY,
    ReservierungId  INT NOT NULL,
    Aktion          NVARCHAR(20) NOT NULL,
    AlterStatus     NVARCHAR(20),
    NeuerStatus     NVARCHAR(20),
    GeaendertAm     DATETIME NOT NULL DEFAULT GETDATE(),
    GeaendertVon    NVARCHAR(100) DEFAULT SYSTEM_USER
);
GO

PRINT '>> Alle 13 Tabellen erfolgreich erstellt.';
GO

-- ============================================================
-- NONCLUSTERED INDIZES
-- ============================================================

CREATE NONCLUSTERED INDEX IX_Zimmer_HotelId
    ON Zimmer (HotelId)
    INCLUDE (Zimmernummer, PreisProNacht, IstVerfuegbar);
GO

CREATE NONCLUSTERED INDEX IX_Reservierung_GastId
    ON Reservierung (GastId);
GO

CREATE NONCLUSTERED INDEX IX_Reservierung_Datum
    ON Reservierung (CheckIn, CheckOut);
GO

PRINT '>> 3 NONCLUSTERED INDEX erfolgreich erstellt.';
GO

-- ============================================================
-- FOREIGN KEY CONSTRAINTS
-- ============================================================

ALTER TABLE Stadt
    ADD CONSTRAINT FK_Stadt_Land
    FOREIGN KEY (LandId) REFERENCES Land(LandId);
GO

ALTER TABLE Hotel
    ADD CONSTRAINT FK_Hotel_Stadt
    FOREIGN KEY (StadtId) REFERENCES Stadt(StadtId);
GO

ALTER TABLE Zimmer
    ADD CONSTRAINT FK_Zimmer_Hotel
    FOREIGN KEY (HotelId) REFERENCES Hotel(HotelId);

ALTER TABLE Zimmer
    ADD CONSTRAINT FK_Zimmer_Kategorie
    FOREIGN KEY (KategorieId) REFERENCES Zimmerkategorie(KategorieId);
GO

ALTER TABLE Gast
    ADD CONSTRAINT FK_Gast_Land
    FOREIGN KEY (LandId) REFERENCES Land(LandId);
GO

ALTER TABLE Mitarbeiter
    ADD CONSTRAINT FK_Mitarbeiter_Hotel
    FOREIGN KEY (HotelId) REFERENCES Hotel(HotelId);
GO

ALTER TABLE Reservierung
    ADD CONSTRAINT FK_Reservierung_Gast
    FOREIGN KEY (GastId) REFERENCES Gast(GastId);

ALTER TABLE Reservierung
    ADD CONSTRAINT FK_Reservierung_Zimmer
    FOREIGN KEY (ZimmerId) REFERENCES Zimmer(ZimmerId);

ALTER TABLE Reservierung
    ADD CONSTRAINT FK_Reservierung_Mitarbeiter
    FOREIGN KEY (MitarbeiterId) REFERENCES Mitarbeiter(MitarbeiterId);
GO

ALTER TABLE Zahlung
    ADD CONSTRAINT FK_Zahlung_Reservierung
    FOREIGN KEY (ReservierungId) REFERENCES Reservierung(ReservierungId);
GO

ALTER TABLE Bewertung
    ADD CONSTRAINT FK_Bewertung_Reservierung
    FOREIGN KEY (ReservierungId) REFERENCES Reservierung(ReservierungId);
GO

ALTER TABLE HotelAusstattung
    ADD CONSTRAINT FK_HotelAusstattung_Hotel
    FOREIGN KEY (HotelId) REFERENCES Hotel(HotelId);

ALTER TABLE HotelAusstattung
    ADD CONSTRAINT FK_HotelAusstattung_Ausstattung
    FOREIGN KEY (AusstattungId) REFERENCES Ausstattung(AusstattungId);
GO

PRINT '>> Alle FOREIGN KEY Constraints erfolgreich erstellt.';
GO

-- ============================================================
-- CHECK CONSTRAINTS
-- ============================================================

ALTER TABLE Hotel
    ADD CONSTRAINT CHK_Hotel_Sterne
    CHECK (Sternebewertung BETWEEN 1 AND 5);
GO

ALTER TABLE Zimmer
    ADD CONSTRAINT CHK_Zimmer_Preis
    CHECK (PreisProNacht > 0);
GO

ALTER TABLE Reservierung
    ADD CONSTRAINT CHK_Reservierung_Datum
    CHECK (CheckOut > CheckIn);
GO

ALTER TABLE Reservierung
    ADD CONSTRAINT CHK_Reservierung_Status
    CHECK (Status IN ('Aktiv', 'Abgeschlossen', 'Storniert'));
GO

ALTER TABLE Bewertung
    ADD CONSTRAINT CHK_Bewertung_Sterne
    CHECK (Sterne BETWEEN 1 AND 5);
GO

ALTER TABLE Zahlung
    ADD CONSTRAINT CHK_Zahlung_Betrag
    CHECK (Betrag > 0);
GO

ALTER TABLE Reservierung
    ADD CONSTRAINT CHK_Reservierung_Personen
    CHECK (AnzahlPersonen BETWEEN 1 AND 20);
GO

PRINT '>> Alle CHECK Constraints erfolgreich erstellt.';
PRINT '>> Weiter mit 03_Testdaten_Einfuegen.sql';
GO
