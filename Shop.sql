ALTER SESSION SET NLS_DATE_FORMAT='DD.MM.YYYY';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD.MM.YYYY HH24:MI:SS.FF';

drop table kunde cascade constraints;
drop table artikelkategorie cascade constraints;
drop table artikel cascade constraints;
drop table warenkorb cascade constraints;
drop table lager cascade constraints;
drop table bestellung cascade constraints;
drop table bestellposition cascade constraints;
drop table lieferer cascade constraints;
drop table lieferer_has_artikel cascade constraints;
drop sequence pos_seq;
drop sequence best_seq;
CREATE TABLE Kunde(
Kundennummer  INTEGER PRIMARY KEY,
Anrede        CHARACTER(4)   CHECK (Anrede IN ('Herr','Frau')),
Vorname       CHARACTER(50),
Nachname      CHARACTER(30)  DEFAULT 'N.N.',
Geburtsdatum  DATE,
email varchar(30),
plz VARCHAR(10),
Ort     CHARACTER(50),
strasse varchar(50),
hausnummer varchar(5)
);

CREATE TABLE Artikelkategorie(
KategorieKrz  CHAR(3) PRIMARY KEY,
Bezeichnung   VARCHAR(50),
Oberkategorie CHAR(3),
FOREIGN KEY (Oberkategorie) REFERENCES Artikelkategorie(KategorieKrz)
);

CREATE TABLE Artikel(
Artikelnummer INTEGER PRIMARY KEY,
Artikelname   VARCHAR (1000),
Preis         NUMERIC (7,2)   CHECK (Preis >=0),
KategorieKrz  CHAR(3) NOT NULL,
FOREIGN KEY (KategorieKrz) REFERENCES Artikelkategorie(KategorieKrz)
);

CREATE TABLE Warenkorb(
Kundennummer  INTEGER,
Artikelnummer INTEGER,
Anzahl        INTEGER      CHECK( Anzahl >=0),
PRIMARY KEY   (Kundennummer, Artikelnummer),
FOREIGN KEY   (Kundennummer)  REFERENCES Kunde(Kundennummer)
ON DELETE CASCADE,
FOREIGN KEY   (Artikelnummer) REFERENCES Artikel(Artikelnummer)
ON DELETE CASCADE
);

CREATE TABLE Lager(
Lagernummer  INTEGER,
Standort      VARCHAR (3) CHECK (Standort IN ('INF', 'MED', 'FAN', 'WIR')),
ANummer       INTEGER,
Lagerbestand  INTEGER         CHECK (Lagerbestand >=0),
PRIMARY KEY (Lagernummer),
FOREIGN KEY (ANummer)         REFERENCES Artikel(Artikelnummer)
ON DELETE SET NULL
);

CREATE TABLE Bestellung(
Bestellnummer INTEGER,
Kundennummer INTEGER,
Bestelldatum DATE,
Bestellstatus VARCHAR(10) CHECK (Bestellstatus IN ('bestellt', 'bestaetigt', 'geliefert')),
wunschtermin          TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (Bestellnummer),
FOREIGN KEY (Kundennummer) REFERENCES Kunde (Kundennummer)
);
CREATE TABLE Bestellposition(
Pos INTEGER,
Bestellnummer INTEGER,
Artikelnummer INTEGER,
Anzahl INTEGER CHECK( Anzahl >=0),
Preis NUMERIC (7,2) CHECK (Preis >0),
Reduktion NUMERIC (4,2) DEFAULT 0.0,
PRIMARY KEY (Bestellnummer, Pos),
FOREIGN KEY (Bestellnummer) REFERENCES Bestellung(Bestellnummer)
ON DELETE CASCADE,
FOREIGN KEY (Artikelnummer) REFERENCES Artikel(Artikelnummer)
);


CREATE TABLE lieferer (
  lieferernummer      NUMBER(10)   NOT NULL PRIMARY KEY,
  anrede          CHARACTER(4) CHECK (Anrede IN ('Herr','Frau')),
  vorname         VARCHAR(45)  NOT NULL,
  nachname        VARCHAR(45)  NOT NULL
) ;

CREATE TABLE Lieferer_has_Artikel (
  lieferernummer      NUMBER(10)   NOT NULL,
  artikelnummer number(10) not null,
  FOREIGN KEY   (Artikelnummer) REFERENCES Artikel(Artikelnummer),
  FOREIGN KEY   (lieferernummer) REFERENCES Lieferer(lieferernummer),
  Primary key(artikelnummer,lieferernummer)
) ;

CREATE SEQUENCE Best_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 10;

CREATE SEQUENCE Pos_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 10;




--
-- Dumping data for table kunde
--
INSERT INTO kunde VALUES (1,'Frau','Herta','Mueller', '04.10.1921', 'fritz@hotmail.de', '39850','Maieskuel', 'Neuerstrasse', null);
INSERT INTO kunde VALUES (6,'Herr','Dagobert','Duck', '24.09.1930', 'dd@gmx.de', '39850', 'Maieskuel', 'Am Geldspeicher', '5');
INSERT INTO kunde VALUES (7,'Frau','Freya','Wille', '22.05.1979', 'freyaw@satannet.org', '39846', 'Maieskuel', 'Feldweg', '5');
INSERT INTO kunde VALUES (8,'Herr','Hubert','Humbug','12.04.1966', 'hubihum@yahoo.com', '39846', 'Maieskuel', 'Am Markt', '88');
INSERT INTO kunde VALUES (9,'Frau','Amber','Love','04.02.1983', 'amberlove@forsale.de', '39846', 'Maieskuel', 'Rotlichtgasse', '7');
INSERT INTO kunde VALUES (10,'Herr','P.','Usher','22.02.1988', 'Drugstore@gmx.at', '39000', 'Maieskuel', 'Rotlichtgasse', '4');
INSERT INTO kunde VALUES (11,'Frau','Kriemhild','Kratzbaum','23.05.1944', 'katzenlady@whiskas.de', '39000', 'Maieskuel', 'Feldweg', '17');
INSERT INTO kunde VALUES (12,'Herr','A.','S. S. Assin','29.06.1967', 'gunfreak@hotmail.com', '39846', 'Maieskuel', 'Am Friedhof', '666');
INSERT INTO kunde VALUES (13,'Frau','Mathilda','Metzger','24.04.1977', 'metzgereimetzger@gmx.de', '39846', 'Maieskuel', 'Am Markt', '1');
INSERT INTO kunde VALUES (14,'Herr','Vlad','Draculea','09.09.1431', 'tepes@gmx.ru', '39001', 'Maieskuel', 'Am Friedhof', '77');
INSERT INTO kunde VALUES (2,'Herr','Jeffrey','Döhmer','21.03.1960', 'jeff@gmx.de', '39846', 'Maieskuel', 'An der Schokoladenfabrik', '8');
INSERT INTO kunde VALUES (4,'Frau','Pueppi','Lawless','24.10.1983', 'plawless@gmx.de', '39850', 'Maieskuel', 'Freier Fall', '24');
INSERT INTO kunde VALUES (5,'Frau','Stefanie','Meier','04.11.1979', 'mutti@yahoo.com', '39850', 'Maieskuel', 'Am Markt', '20');
INSERT INTO kunde VALUES (3,'Herr','Rupert','Ratte','22.07.1963', 'harleyfahrer@web.de', '39850', 'Maieskuel', 'Rotlichtgasse', '55');
INSERT INTO kunde VALUES (16,'Herr','Georg','Hausierer','12.12.1990', 'rodentizid@web.de', '39850', 'Maieskuel', 'Am Trigger', '88');
INSERT INTO kunde VALUES (17,'Frau','Chantal','Schulze','12.01.1998', 'discomaus18@gmx.net', '39000', 'Maieskuel', 'An der Schokoladenfabrik', '8');

UPDATE kunde SET vorname='Vladimir', nachname='Drach' WHERE kundennummer='14';
-- UPDATE kunde SET passwort='curare', anrede='Herr', vorname='Georg', nachname='Hausierer', geburtsdatum='12.12.1990', strasse='Am Trigger 88', wohnort='Orakel', plz='39850', tel='0346-465483', mail='rodentizid@web.de', konto_nr='5236785', blz='370001', bankname='Sparkasse Orakel' WHERE idKunde='16';

INSERT INTO kunde (Kundennummer, anrede, vorname, nachname, geburtsdatum, plz, ort,strasse, hausnummer) VALUES ('18', 'Herr', 'Pierre', 'Bauklo', '28.02.1998','39000', 'Maieskuel', 'Feldweg', '6');
INSERT INTO kunde (Kundennummer, anrede, vorname, nachname, geburtsdatum, plz, ort, strasse, hausnummer) VALUES ('19', 'Herr', 'Marco', 'Mark', '30.05.1977', '39850', 'Maieskuel', 'Am Markt', '20');

--
-- Dumping data for table artikelkategorie
--
INSERT INTO artikelkategorie VALUES('GET', 'Getraenke', NULL);
INSERT INTO artikelkategorie VALUES('AKF','Alkoholfreie','GET');
INSERT INTO artikelkategorie VALUES('SAE','Saefte','GET');
INSERT INTO artikelkategorie VALUES('WAS','Wasser','GET');
INSERT INTO artikelkategorie VALUES('LIM','Limonade','GET');
INSERT INTO artikelkategorie VALUES('ALK','Alkoholhaltige','GET');
INSERT INTO artikelkategorie VALUES('WEI','Wein','ALK');
INSERT INTO artikelkategorie VALUES('BIE','Bier','ALK');
INSERT INTO artikelkategorie VALUES('MIL','Milchhaltige','GET');
INSERT INTO artikelkategorie VALUES('MIS','Milchsorte','MIL');
INSERT INTO artikelkategorie VALUES('SPE','Spezielles','GET');
INSERT INTO artikelkategorie VALUES ('WHI', 'Whiskey', 'ALK');
INSERT INTO artikelkategorie VALUES ('SEK', 'Sekt', 'ALK');

UPDATE artikelkategorie SET bezeichnung='Koelsch' WHERE KategorieKrz='BIE';

INSERT INTO artikelkategorie VALUES ('COL', 'Cola', 'LIM');
INSERT INTO artikelkategorie VALUES ('KAF', 'Kaffeegetraenk', 'MIS');
INSERT INTO artikelkategorie VALUES ('HMI', 'H-Milch', 'MIS');
INSERT INTO artikelkategorie VALUES ('KAK', 'Kakao', 'MIS');
INSERT INTO artikelkategorie VALUES ('PIL', 'Pils', 'BIE');
INSERT INTO artikelkategorie VALUES ('APF', 'Apfelsaft', 'SAE');
INSERT INTO artikelkategorie VALUES ('ORA', 'Orangensaft', 'SAE');
INSERT INTO artikelkategorie VALUES ('KOH', 'Kohlensaeurenhaltig', 'GET');

--
-- Dumping data for table artikel
--
INSERT INTO artikel VALUES (1,'Multisaft',2.95,'SAE');
INSERT INTO artikel VALUES(2,'Bonaqua',2.95,'KOH');
INSERT INTO artikel VALUES(3,'Cola',2.95,'KOH');
INSERT INTO artikel VALUES(4,'Bordeaux',5,'ALK');
INSERT INTO artikel VALUES(5,'Pils',2.5,'ALK');
INSERT INTO artikel VALUES(6,'LatteGetraenk',2.55,'MIL');
INSERT INTO artikel VALUES(7,'Kirschsaft',2.55,'SAE');
INSERT INTO artikel VALUES(8,'Sanguis',65.95,'ALK');

--
-- Dumping data for table bestellung
--

INSERT INTO bestellung VALUES (50,6,'21.07.2016','bestaetigt','23.07.2016 15:00:00');
INSERT INTO bestellung VALUES (49,14,'21.07.2016','bestaetigt','23.07.2016 14:30:00');
INSERT INTO bestellung VALUES (48,10,'21.07.2016','bestaetigt','23.7.2016 11:30:00');
INSERT INTO bestellung VALUES (47,1,'20.07.2016','bestaetigt','24.07.2016 14:00:00');
INSERT INTO bestellung VALUES (46,4,'20.07.2016','bestaetigt','22.07.2016 12:00:00');
INSERT INTO bestellung VALUES (45,3,'20.07.2016','bestaetigt','23.07.2016 15:00:00');
INSERT INTO bestellung VALUES (44,7,'20.07.2016','bestaetigt','21.07.2016 14:00:00');
INSERT INTO bestellung VALUES (43,11,'20.07.2016','bestaetigt','25.07.2016 16:00:00');
INSERT INTO bestellung VALUES (51,12,'22.07.2016','bestellt','26.07.2016 17:00:00');
INSERT INTO bestellung VALUES (52,8,'22.07.2016','bestellt','26.07.2016 07:00:00');
INSERT INTO bestellung VALUES (53,9,'22.07.2016','bestellt','26.07.2016 11:00:00');
INSERT INTO bestellung VALUES (54,11,'23.07.2016','bestellt','01.08.2016 14:00:00');
INSERT INTO bestellung VALUES (55,5,'23.07.2016','bestaetigt','25.07.2016 12:00:00');
INSERT INTO bestellung VALUES (56,2,'23.07.2016','bestaetigt','25.07.2016 14:10:00');
INSERT INTO bestellung VALUES (57,6,'23.07.2016','bestellt','31.07.2016 14:30:00');
INSERT INTO bestellung VALUES (58,13,'24.07.2016','bestellt','02.08.2016 16:00:00');
INSERT INTO bestellung VALUES (59,7,'24.07.2016','bestellt','01.08.2016 07:00:00');
INSERT INTO bestellung VALUES (60,14,'25.07.2016','bestellt','04.08.2016 16:00:00');
INSERT INTO bestellung VALUES (61, 9, '25.07.2016', 'bestellt', '31.07.2016 14:00:00');


--
-- Dumping data for table bestellposition
--
INSERT INTO bestellposition VALUES (117,60,8,20, 65.95,0);
INSERT INTO bestellposition VALUES (116,59,3,10,2.95,0);
INSERT INTO bestellposition VALUES (115,58,2,25,2.95,0);
INSERT INTO bestellposition VALUES (114,57,8,9,65.95,0);
INSERT INTO bestellposition VALUES (113,56,7,4,2.55,0);
INSERT INTO bestellposition VALUES (112,55,5,18, 2.5,0);
INSERT INTO bestellposition VALUES (111,54,8,4,65.95,0);
INSERT INTO bestellposition VALUES (110,53,1,4,2.95,0);
INSERT INTO bestellposition VALUES (109,52,3,15,2.95,0);
INSERT INTO bestellposition VALUES (108,51,4,4,5,0);
INSERT INTO bestellposition VALUES (107,50,8,8,65.95,0);
INSERT INTO bestellposition VALUES (106,49,8,5,65.95,0);
INSERT INTO bestellposition VALUES (105,48,1,10, 2.95,0);
INSERT INTO bestellposition VALUES (104,47,8,7,65.95,0);
INSERT INTO bestellposition VALUES (103,46,2,20, 2.95,0);
INSERT INTO bestellposition VALUES (102,45,6,10, 2.55,0);
INSERT INTO bestellposition VALUES (101,44,5,12, 2.5,0);
INSERT INTO bestellposition VALUES (100,43,8,6,65.95,0);
INSERT INTO bestellposition VALUES (118, 61, 4, 4,5,0);

--
-- Dumping data for table lieferer
--
INSERT INTO lieferer VALUES (1,'Herr','Lars','Mayer');
INSERT INTO lieferer VALUES (2,'Frau','Anastasia','Mueller');
INSERT INTO lieferer VALUES (3,'Herr','Eric','Beckers');
INSERT INTO lieferer VALUES (4,'Herr','Dorian','Graie');

--
-- Dumping data for table warenkorb
--
INSERT INTO warenkorb VALUES (3,3,2);
INSERT INTO warenkorb VALUES (3,5,4);
INSERT INTO warenkorb VALUES (5,1,5);

--
-- Dumping data for table lager
--
INSERT INTO Lager VALUES (27135,'INF',1, 2);
INSERT INTO Lager VALUES (27136,'INF',2, 18);
INSERT INTO Lager VALUES (27432,'FAN',3, 0);
INSERT INTO Lager VALUES (27522,'MED',4, 1);
INSERT INTO Lager VALUES (27523,'MED',5, 3);
INSERT INTO Lager VALUES (27525,'MED',6, 5);
INSERT INTO Lager VALUES (27527,'INF',7, 3);
INSERT INTO Lager VALUES (27528,'MED',8, 5);

INSERT INTO Lieferer_has_Artikel VALUES(1,1);
INSERT INTO Lieferer_has_Artikel VALUES(2,2);
INSERT INTO Lieferer_has_Artikel VALUES(3,3);
INSERT INTO Lieferer_has_Artikel VALUES(4,4);
INSERT INTO Lieferer_has_Artikel VALUES(4,8);
COMMIT;