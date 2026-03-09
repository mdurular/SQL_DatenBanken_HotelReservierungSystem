# 🏨 Hotel-Reservierungssystem
### SQL Abschlussprojekt | Dozent: Lev A. Brodski | März 2026

![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-005C84?style=for-the-badge&logo=databricks&logoColor=white)
![Status](https://img.shields.io/badge/Status-Abgeschlossen-brightgreen?style=for-the-badge)

---

## 📋 Projektbeschreibung

Gegenstand dieses Projekts ist die Konzeption und Implementierung einer relationalen Datenbankumgebung für ein **Hotel-Reservierungssystem** unter Microsoft SQL Server. Die Architektur implementiert konsequent die **3. Normalform (3NF)** zur Sicherstellung der referentiellen Integrität und Redundanzfreiheit.

Das System bildet den vollständigen operativen Zyklus ab:
- 🏢 **Stammdatenverwaltung** – Hotels, Zimmer, Gäste, Mitarbeiter
- 📅 **Buchungsprozess** – Reservierungen, Zahlungen
- ⭐ **After-Sales** – Bewertungen, Erinnerungen

Die gesamte Business-Logik wurde mittels T-SQL Objekten direkt in der Datenbankschicht gekapselt, um eine konsistente Datenvalidierung und hohe Performanz zu gewährleisten.

---

## 🗄️ Datenbankstruktur (13 Tabellen)

| Tabelle | Beschreibung | Beziehung |
|---|---|---|
| `Land` | Länderstammdaten mit ISO-Code | 1:n → Stadt |
| `Stadt` | Städte mit geografischer Landzuordnung | 1:n → Hotel |
| `Hotel` | Hotelstammdaten (Name, Kategorisierung, Kontakt) | 1:n → Zimmer, Mitarbeiter |
| `Zimmerkategorie` | Definition von Zimmertypen (Einzel, Doppel, Suite) | 1:n → Zimmer |
| `Zimmer` | Inventar mit Preisgestaltung und Status | 1:n → Reservierung |
| `Gast` | Personenbezogene Daten und Kontaktinformationen | 1:n → Reservierung |
| `Mitarbeiter` | Personalstamm mit funktionaler Positionierung | 1:n → Reservierung |
| `Reservierung` | Zentrale Transaktionstabelle für Buchungen | 1:n → Zahlung, Bewertung |
| `Zahlung` | Finanzielle Transaktionsdaten pro Buchung | n:1 → Reservierung |
| `Bewertung` | Qualitätsmanagement (1–5 Sterne Skala) | 1:1 → Reservierung |
| `Ausstattung` | Katalog der Ausstattungsmerkmale (Pool, WLAN etc.) | m:n → Hotel |
| `HotelAusstattung` | Cross-Reference-Tabelle für Hotelausstattung | **m:n Beziehung** |
| `ReservierungsLog` | System Audit Table (populiert via Trigger) | N/A – System-Audit |

---

## ⚙️ Technische Implementierung

| Objekt-Typ | Name | Funktionalität |
|---|---|---|
| **Views** | `vw_ReservierungsUebersicht`, `vw_HotelStatistik`, `vw_ZimmerAuslastung` | Abstraktion der Join-Komplexität (bis zu 7 Tabellen) und Bereitstellung aggregierter KPI-Daten |
| **Funktionen** | `fn_AnzahlNaechte`, `fn_GesamtPreisBerechnen`, `fn_IstZimmerVerfuegbar`, `fn_VerfuegbareZimmer` | Skalar- und Tabellenwertfunktionen zur Kapselung berechneter Business-Logik |
| **Prozedur** | `sp_ReservierungErstellen` | Zentraler Buchungsworkflow mit 6 Validierungsschritten, ACID-konformer Transaktionssteuerung und OUTPUT-Parametern |
| **Trigger** | `trg_Reservierung_StatusAenderung` | Automatisierte State Machine: Protokollierung im Log und synchrone Aktualisierung des Zimmerstatus |
| **Cursor** | `cur_OhneBewertung` | Iterative Logik zur Identifikation ausstehender Gäste-Feedbacks für automatisierte Erinnerungen *(Note: Sehr gut)* |
| **Sicherheit** | `HotelLeser`, `HotelRezeption` | Rollenbasierte Zugriffskontrolle (RBAC) nach dem Principle of Least Privilege |

---

## 🚀 Deployment – Skript-Ablauf

> ⚠️ Skripte **in dieser Reihenfolge** ausführen!

| Nr. | Dateiname | Inhalt / Zweck |
|---|---|---|
| 00 | `00_Cleanup.sql` | Bereinigung bestehender Schemata und Datenbankstrukturen |
| 01 | `01_Datenbank_Erstellen.sql` | Physische Initialisierung der Datenbankinstanz |
| 02 | `02_Tabellen_Index_Constraints.sql` | Definition von 13 Tabellen, 3 Indizes sowie FK- und CHECK-Constraints |
| 03 | `03_Testdaten_Einfuegen.sql` | Befüllung des Schemas mit validen Grunddaten für alle Entitäten |
| 04 | `04_Views.sql` | Erstellung der logischen Abstraktionsschicht (3 Views) |
| 05 | `05_Views_Test.sql` | Unit-Tests zur Verifizierung der View-Ergebnismengen |
| 06 | `06_Funktionen.sql` | Implementierung der Rechenlogik (Skalar- und Tabellenwertfunktionen) |
| 07 | `07_Funktionen_Test.sql` | Funktionale Validierung der Rückgabewerte |
| 08 | `08_Prozedur.sql` | Bereitstellung der zentralen Stored Procedure für den Buchungsprozess |
| 09 | `09_Prozedur_Test.sql` | Durchführung von 5 dedizierten Testfällen (Positiv/Negativ-Tests) |
| 10 | `10_Trigger.sql` | Aktivierung der automatisierten Audit- und Status-Logik |
| 11 | `11_Trigger_Test.sql` | Überprüfung der Datenkonsistenz nach Trigger-Ausführung |
| 12 | `12_Cursor.sql` | Implementierung der cursorbasierten Berichtslogik |
| 13 | `13_Benutzer_Rechte.sql` | Konfiguration der DB-Sicherheit und Rollenberechtigungen |
| 14 | `14_Abschluss.sql` | Übergreifender Systemtest und finale Integritätsprüfung |

---

## 🗂️ Ordnerstruktur

```
HotelReservierungSystem/
├── 001-DB-Create-Scripts/
│   ├── 00_Cleanup.sql
│   ├── 01_Datenbank_Erstellen.sql
│   └── 02_Tabellen_Index_Constraints.sql
├── 002-Abfragen und View/
│   ├── 04_Views.sql
│   └── 05_Views_Test.sql
├── 003-StoredFunctions/
│   ├── 06_Funktionen.sql
│   └── 07_Funktionen_Test.sql
├── 004-StoredProcedures/
│   ├── 08_Prozedur.sql
│   └── 09_Prozedur_Test.sql
├── 005-DML-Trigger/
│   ├── 10_Trigger.sql
│   ├── 11_Trigger_Test.sql
│   └── 12_Cursor.sql
├── 005-LOGN-USER-ROLE/
│   └── 13_Benutzer_Rechte.sql
├── 006-BackUp/
│   └── HotelReservierung.bak
├── 007-Datenimport/
│   └── 03_Testdaten_Einfuegen.sql
├── 14_Abschluss.sql
└── README.md
```

---

## 🛠️ Voraussetzungen

- Microsoft SQL Server 2019 oder höher
- SQL Server Management Studio (SSMS)
- Windows Authentifizierung oder SQL Server Login

---

*alfatraining Bildungszentrum GmbH | Modul: SQL | Stand: März 2026*
