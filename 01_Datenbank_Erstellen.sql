-- ============================================================
-- Hotel-Reservierungssystem | Abschlussprojekt SQL
-- Dozent: Lev A. Brodski | Stand: März 2026
-- ============================================================
-- SKRIPT 01: Datenbank erstellen
-- Ausführungsreihenfolge: 1. nach 00_Cleanup.sql
-- ============================================================

USE master;
GO

CREATE DATABASE HotelReservierung;
GO

PRINT '>> Datenbank HotelReservierung erfolgreich erstellt.';
PRINT '>> Weiter mit 02_Tabellen_Index_Constraints.sql';
GO
