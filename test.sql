SELECT * FROM Spiel s, SpielKompatibel sk WHERE sk.SpielNr = s.SpielNr AND sk.KonsoleNr = 2

SELECT * FROM SPIEL COMMIT

SELECT s.SpielNr, s.KategorieID, s.Name, s.Publisher, s.Region, s.ReleaseJahr FROM Spiel s, SpielKompatibel sk WHERE sk.SpielNr = s.SpielNr AND sk.KonsoleNr = 2

DELETE FROM KATEGORIE WHERE KATEGORIEID = 'LSIM'



SELECT * FROM KONSOLE

INSERT INTO KONSOLE(MARKE, NAME, BESCHREIBUNG, RICHARDSRETROFAKTOR) VALUES('Tobtech', 'TobKonsole', NULL, 9)


INSERT INTO Modell(KONSOLENR, SERIENNR, REGION, RELEASEJAHR, UVP, BESCHREIBUNG) VALUES (4, 'TOB-XX', 'Tobland', 2023, 69, NULL)

INSERT INTO

SELECT s.SPIELNR, s.NAME, kat.BEZEICHNUNG, k.NAME  FROM SPIEL s, SPIELKOMPATIBEL sk, KONSOLE k, KATEGORIE kat WHERE s.SPIELNR = sk.SPIELNR AND sk.SPIELNR = k.KONSOLENR AND s.KATEGORIEID = kat.KATEGORIEID

SELECT * FROM KATEGORIE WHERE OBERKATEGORIEID = KATEGORIEID OR OBERKATEGORIEID = NULL

SELECT KategorieID, LPAD(' ', LEVEL-1) || Bezeichnung AS Bezeichnung, OberkategorieID
FROM Kategorie
START WITH OberkategorieID IS NULL
CONNECT BY PRIOR KategorieID = OberkategorieID
ORDER SIBLINGS BY KategorieID;

INSERT INTO KATEGORIE(KATEGORIEID, BEZEICHNUNG, OBERKATEGORIEID) VALUES ('RAC1', 'race test', 'RACE')



Kühlschrank(KNummer, Bestand)
Käse(Käsenummer, Markenname)

SELECT KNummer, Bestand, (SELECT Markenname
                          FROM Käse
                          WHERE Käsenummer = k.KNummer) AS Marke
FROM Kühlschrank k

SELECT 'true' FROM KONSOLE
WHERE 0 EXISTS IN (1, 4 ,5)