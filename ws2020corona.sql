CREATE TABLE Fahrzeug(
	KFZNr INTEGER PRIMARY KEY,
	Fahrzeugtyp VARCHAR(128) NOT NULL,
	Verbrauch NUMERIC(10,2) CHECK (Verbrauch > 0)
);
CREATE TABLE Fahrzeuglager(
	Abstellplatz INTEGER PRIMARY KEY,
	Abstellort VARCHAR(128) DEFAULT 'LI',
	KFZNr INTEGER,
	FOREIGN KEY (KFZNr) REFERENCES Fahrzeug (KFZNr) ON DELETE CASCADE,
	Fahrzeugbestand INTEGER
);

INSERT INTO Fahrzeug VALUES(1, 'Abraham', 45.34);
INSERT INTO Fahrzeuglager(KFZNr, Abstellplatz, Fahrzeugbestand) VALUES(1, 106, 500);
INSERT INTO Fahrzeuglager(KFZNr, Abstellplatz, Fahrzeugbestand) VALUES(1, 1058, 8213);

SELECT KFZNr, SUM(Fahrzeugbestand) AS Fahrzeugbestand
FROM Fahrzeug NATURAL JOIN Fahrzeuglager
GROUP BY KFZNr
ORDER BY 2 DESC

SHOW ERRORS
CREATE OR REPLACE FUNCTION getMittlereFahrzeuglager(nr IN INTEGER) RETURN NUMBER
AS
	mittelwert NUMERIC(10,2) DEFAULT 0;
	liBool NUMERIC(10,2) DEFAULT 0;
    liBez EXCEPTION;
BEGIN
	SELECT COUNT(*) INTO liBool FROM Fahrzeuglager WHERE KFZNr = nr AND Abstellort LIKE 'LI';
	IF liBool > 0 THEN
		RAISE liBez;
	END IF;
	SELECT AVG(Fahrzeugbestand) INTO mittelwert FROM Fahrzeuglager WHERE KFZNr = nr;
	RETURN mittelwert;
EXCEPTION
    WHEN liBez THEN
        raise_application_error(-20500, 'Abstellort beträgt LI');
END;


CREATE OR REPLACE FUNCTION getMittlereFahrzeuglager(nr IN INTEGER)
RETURN NUMERIC
AS
	liBez EXCEPTION;
	mittelwert NUMERIC(10,2);
	liBool NUMERIC(10,2);
BEGIN
	SELECT AVG(Fahrzeugbestand) INTO mittelwert FROM Fahrzeuglager WHERE KFZNr = nr;
	SELECT COUNT(*) INTO liBool FROM Fahrzeuglager WHERE KFZNr = nr AND Abstellort LIKE 'LI'
	IF liBool > 0 THEN
		RAISE liBez;
	END IF;
	RETURN mittelwert;
	EXCEPTION
		WHEN liBez THEN
			raise_application_error(-20001, 'Abstellort beträgt LI');
END;


CREATE OR REPLACE VIEW ViewFahrzeug
AS
SELECT KFZNr, Verbrauch
FROM Fahrzeug
WHERE KFZNr NOT IN (SELECT KFZNr FROM Fahrzeuglager WHERE Abstellort LIKE 'LI')
WITH CHECK OPTION

SELECT * FROM ViewFahrzeug

SELECT getMittlereFahrzeuglager(2)
FROM Fahrzeug;

(SELECT AVG(Fahrzeugbestand) FROM Fahrzeuglager WHERE KFZNr = 1);

SELECT COUNT(*)  FROM Fahrzeuglager WHERE KFZNr = 1 AND Abstellort LIKE 'LI'

INSERT INTO Fahrzeug VALUES(2, 'Abraham2', 46.34);
INSERT INTO Fahrzeuglager(KFZNr, Abstellplatz, Fahrzeugbestand, ABSTELLORT) VALUES(2, 107, 501, 'penis');
INSERT INTO Fahrzeuglager(KFZNr, Abstellplatz, Fahrzeugbestand) VALUES(2, 1059, 8214);