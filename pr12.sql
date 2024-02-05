CREATE OR REPLACE TRIGGER wilkommenspräsent
AFTER INSERT ON Kunde
FOR EACH ROW
BEGIN
    INSERT INTO Warenkorb(Kundennummer, Artikelnummer, Anzahl) VALUES(:new.Kundennummer, 1, 1);
    COMMIT;
end;

INSERT INTO kunde VALUES (21,'Frau','Herta','Mueller', '04.10.1921', 'fritz@hotmail.de', '39850','Maieskuel', 'Neuerstrasse', null);


CREATE OR REPLACE TRIGGER bestellunglöschen
BEFORE DELETE ON Bestellung
DECLARE
    nichtLöschen EXCEPTION;
BEGIN
    RAISE nichtLöschen;
    EXCEPTION
        WHEN nichtLöschen THEN
            raise_application_error(-20500, 'In Bestellungen darf nicht gelöscht werden');
end;


DELETE FROM Bestellung WHERE BESTELLNUMMER = 50;


CREATE OR REPLACE TRIGGER kundeBestellt
BEFORE INSERT ON Bestellung
FOR EACH ROW
BEGIN
    :new.Bestelldatum := SYSDATE;
    :new.Bestellstatus := 'bestellt';
    COMMIT;
end;

INSERT INTO bestellung VALUES (69,6,'21.07.2016','bestaetigt','23.07.2016 15:00:00');


CREATE OR REPLACE TRIGGER bestellungAbbrechen
BEFORE INSERT ON Bestellung
FOR EACH ROW
DECLARE
    summe NUMBER;
    zuBillig EXCEPTION;
BEGIN
    SELECT SUM(Anzahl*Preis) INTO summe FROM Warenkorb NATURAL JOIN Artikel WHERE warenkorb.Kundennummer = :new.KUNDENNUMMER;
    IF summe < 25 THEN
        RAISE zuBillig;
    end if;
    EXCEPTION
        WHEN zuBillig THEN
            raise_application_error(-20500, 'Mindestbestellwert nicht eingehalten');
end;

CALL bestellen(3);



CREATE VIEW lagermitarbeiter
AS
SELECT b.BESTELLNUMMER, b.Kundennummer, Bestelldatum, Ort, Strasse, SUM(Preis*Anzahl) AS PreisTotal, Bestellstatus
FROM Bestellung b LEFT JOIN Kunde k ON b.KUNDENNUMMER=k.KUNDENNUMMER LEFT JOIN BESTELLPOSITION bp ON b.BESTELLNUMMER=bp.BESTELLNUMMER
GROUP BY b.BESTELLNUMMER, b.Kundennummer, Bestelldatum, Ort, Strasse, Bestellstatus



CREATE OR REPLACE TRIGGER lagermitarbeiterView
INSTEAD OF UPDATE ON lagermitarbeiter
FOR EACH ROW
BEGIN
    UPDATE Bestellung SET Bestellstatus = :new.Bestellstatus WHERE Bestellnummer = :new.Bestellnummer;
end;

UPDATE lagermitarbeiter SET Bestellstatus = 'bestellt' WHERE Bestellnummer=56;


CREATE OR REPLACE TRIGGER max2Standorte
BEFORE INSERT ON Lager
FOR EACH ROW
DECLARE
    anzahlStandorteError EXCEPTION;
    standorteCount Integer;
BEGIN
    SELECT COUNT(*) INTO standorteCount FROM Lager WHERE ANUMMER = :new.ANUMMER;
    IF standorteCount >= 2 THEN
        RAISE anzahlStandorteError;
    end if;
    EXCEPTION
        WHEN anzahlStandorteError THEN
            raise_application_error(-20500,'Mehr als 2 Standorte für Artikel');
end;

INSERT INTO Lager(LAGERNUMMER, STANDORT, ANUMMER, LAGERBESTAND) VALUES(9, 'WIR', 3, 9)

UPDATE Lager SET ANUMMER = 3 WHERE Anummer=8;


CREATE GLOBAL TEMPORARY TABLE temp_lager(
    tempLagernummer INTEGER Primary Key
)ON COMMIT DELETE ROWS;

CREATE OR REPLACE TRIGGER update_max2Standorte
AFTER UPDATE ON Lager
FOR EACH ROW
DECLARE
    maxError EXCEPTION;
    countLager INTEGER;
BEGIN
    SELECT COUNT(*) INTO countLager FROM Lager WHERE ANUMMER = :new.ANUMMER;
    IF countLager >= 2 THEN
        RAISE maxError;
    end if;
    EXCEPTION
        WHEN maxERROR THEN
            raise_application_error(-21500, 'too much');
end;
