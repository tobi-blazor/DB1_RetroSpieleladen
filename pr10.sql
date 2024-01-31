DROP VIEW aufgabe1a;
CREATE VIEW aufgabe1a
AS
    SELECT  KUNDENNUMMER AS idKunde, NACHNAME AS Nachnamen, VORNAME AS Vornamen, Anrede, Geburtsdatum, STRASSE AS Straße, FLOOR((SYSDATE-GEBURTSDATUM)/365) AS "Alter"
    FROM KUNDE
    WHERE ANREDE  LIKE '%Frau%' AND ORT LIKE '%Maieskuel%';

DROP VIEW aufgabe1b;
CREATE VIEW aufgabe1b("Alter", Anzahl)
AS
    SELECT "Alter", COUNT(*)
    FROM aufgabe1a
    GROUP BY  "Alter";

DROP VIEW aufgabe1c;
CREATE VIEW aufgabe1c
AS
    SELECT KUNDENNUMMER, BESTELLNUMMER, BESTELLSTATUS
    FROM aufgabe1a a JOIN BESTELLUNG b ON a.idKunde = b.KUNDENNUMMER
    ORDER BY KUNDENNUMMER,BESTELLNUMMER ASC

CREATE VIEW aufgabe1d
AS
    SELECT KUNDENNUMMER, COUNT(*) AS Menge
    FROM aufgabe1c
    WHERE BESTELLSTATUS LIKE '%bestaetigt%'
    GROUP BY KUNDENNUMMER
    HAVING COUNT(*) > 0


CREATE VIEW ViewAufgabe_1a AS SELECT kundennummer, Nachname, Vorname, Anrede, Geburtsdatum, FLOOR ((SYSDATE - Geburtsdatum) /365) AS Lebensalter FROM Kunde WHERE Anrede='Frau' AND Ort='Maieskuel';

CREATE VIEW ViewAufgabe_1b (Lebensalter, Anzahl) AS SELECT Lebensalter, COUNT (*) FROM ViewAufgabe_1a GROUP BY Lebensalter;

CREATE VIEW ViewAufgabe_1c AS SELECT VA1a.*, Bestellnummer, bestellstatus FROM ViewAufgabe_1a VA1a JOIN Bestellung b ON VA1a.kundennummer=b.kundennummer ORDER BY VA1a.kundennummer, b.bestellnummer;

DROP VIEW VIEWAUFGABE_1D;
CREATE VIEW ViewAufgabe_1d AS SELECT kundennummer, Nachname, Vorname, Anrede, Geburtsdatum, count(*) AS AnzahlBestellungen FROM ViewAufgabe_1c WHERE bestellstatus='bestaetigt' GROUP By kundennummer, Nachname, Vorname, Anrede, Geburtsdatum HAVING count (*)>0

UPDATE KUNDE SET STRASSE='Friedhofsgasse 12'
    WHERE VORNAME = 'Herta'

UPDATE KUNDE SET GEBURTSDATUM