CREATE OR REPLACE FUNCTION ZwischensummeArtikel(kundenId IN NUMBER) RETURN NUMBER
IS
    rueckgabe NUMBER;
BEGIN
    SELECT SUM(w.ANZAHL*a.PREIS) INTO rueckgabe FROM WARENKORB w LEFT JOIN ARTIKEL a ON w.ARTIKELNUMMER = a.ARTIKELNUMMER WHERE w.KUNDENNUMMER=kundenId;
    RETURN rueckgabe;
END;

SELECT KUNDENNUMMER, ZwischensummeArtikel(KUNDENNUMMER)
FROM KUNDE
WHERE ZwischensummeArtikel(KUNDENNUMMER) IS NOT NULL;


CREATE OR REPLACE FUNCTION gesamterLagerbestand(aNr IN INTEGER) RETURN INTEGER
IS
    returnvalue INTEGER;
BEGIN
    SELECT SUM(LAGERBESTAND) INTO returnvalue FROM LAGER WHERE ANUMMER=aNr;
    RETURN returnvalue;
END;

SELECT Artikelnummer, gesamterLagerbestand(ARTIKELNUMMER)
FROM ARTIKEL





DROP SEQUENCE BEST_SEQ;
DROP SEQUENCE POS_SEQ;
DROP TABLE BESTELLUNG CASCADE CONSTRAINTS ;

CREATE TABLE Bestellung (
    Bestellnummer INTEGER GENERATED AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    Kundennummer INTEGER,
    FOREIGN KEY (Kundennummer) REFERENCES Kunde (Kundennummer) ON DELETE SET NULL,
    Bestelldatum DATE DEFAULT SYSDATE,
    Bestellstatus VARCHAR(20) CHECK ( Bestellstatus IN ('bestaetigt', 'bestellt', 'geliefert') ),
    Wunschtermin DATE DEFAULT SYSDATE
)



DROP TABLE BESTELLPOSITION CASCADE CONSTRAINTS ;
CREATE TABLE Bestellposition
(
    POS INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    Bestellnummer INTEGER,
    FOREIGN KEY (Bestellnummer) REFERENCES Bestellung (Bestellnummer),
    Artikelnummer INTEGER,
    FOREIGN KEY (Artikelnummer) REFERENCES Artikel(Artikelnummer),
    Anzahl INTEGER,
    Preis NUMERIC(7,2)
)


CREATE OR REPLACE PROCEDURE bestellen(kundenNr INTEGER)
IS
    bestellnr INTEGER;
    CURSOR artikelcursor IS SELECT w.ARTIKELNUMMER, ANZAHL, PREIS FROM WARENKORB w LEFT JOIN ARTIKEL a ON w.Artikelnummer = a.Artikelnummer WHERE Kundennummer = kundenNr ORDER BY 1;
    anzahlWK INTEGER;
    keinWK EXCEPTION;
BEGIN
    SELECT COUNT(Kundennummer) INTO anzahlWK FROM Warenkorb WHERE Kundennummer = kundenNr;
    IF anzahlWK = 0 THEN
        RAISE keinWK;
    end if;
    INSERT INTO BESTELLUNG(Kundennummer, Bestelldatum, Bestellstatus, Wunschtermin) VALUES(kundenNr, SYSDATE, 'bestellt', CURRENT_TIMESTAMP);

    SELECT Bestellnummer INTO bestellnr FROM Bestellung WHERE Kundennummer=kundenNr ORDER BY Bestellnummer FETCH FIRST 1 ROWS ONLY;
    FOR a in artikelcursor LOOP
        INSERT INTO Bestellposition(Bestellnummer, Artikelnummer, Anzahl, Preis) VALUES (bestellnr, a.ARTIKELNUMMER,  a.ANZAHL, a.Preis);
    END LOOP;
    DELETE FROM WARENKORB WHERE KUNDENNUMMER = kundenNr;
    COMMIT;
    EXCEPTION
        WHEN keinWK THEN
            rollback;
            raise_application_error(-20500, 'Keine Artikel im Warenkorb');
end;


CALL bestellen(5)
















