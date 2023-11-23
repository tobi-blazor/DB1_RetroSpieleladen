ALTER SESSION SET NLS_DATE_FORMAT='DD.MM.YYYY';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD.MM.YYYY HH24:MI:SS.FF';

DROP TABLE Lager;
DROP TABLE ZubehoerKompatibel;
DROP TABLE Zubehoer;
DROP TABLE SpielKompatibel;
DROP TABLE Spiel;
DROP TABLE Modell;
DROP TABLE Kategorie;
DROP TABLE Konsole;

CREATE TABLE Konsole
(
    KonsoleNr           INTEGER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Marke               VARCHAR(100),
    Name                VARCHAR(100),
    Beschreibung        VARCHAR(100),
    RichardsRetroFaktor NUMERIC(1),
    Anmkerkung          VARCHAR(500)
);

CREATE TABLE Kategorie
(
    KategorieID     CHAR(5) PRIMARY KEY,
    Bezeichnung     VARCHAR(50),
    OberkategorieID CHAR(5),
    FOREIGN KEY (OberkategorieID) REFERENCES Kategorie (KategorieID)
);

CREATE TABLE Modell
(
    ModellNr    INTEGER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    KonsoleNr   INTEGER,
    Seriennr    VARCHAR(20),
    Region      VARCHAR(50),
    ReleaseJahr INTEGER,
    UVP         NUMERIC(7, 2),
    Anmerkung   VARCHAR(500),
    FOREIGN KEY (KonsoleNr) REFERENCES Konsole (KonsoleNr)
);

CREATE TABLE Spiel
(
    SpielNr     INTEGER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    KategorieID CHAR(5),
    Name        VARCHAR(100),
    Publisher   VARCHAR(100),
    Region      VARCHAR(100),
    ReleaseJahr INTEGER,
    FOREIGN KEY (KategorieID) REFERENCES Kategorie (KategorieID)
);

CREATE TABLE SpielKompatibel
(
    KonsoleNr INTEGER,
    SpielNr INTEGER,
    PRIMARY KEY (KonsoleNr, SpielNr),
    FOREIGN KEY (KonsoleNr) REFERENCES Konsole(KonsoleNr),
    FOREIGN KEY (SpielNr) REFERENCES Spiel(SpielNr)
);

CREATE TABLE Zubehoer
(
    ZubehoerNr  INTEGER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    Name        VARCHAR(100),
    KategorieID CHAR(5),
    FOREIGN KEY (KategorieID) REFERENCES Kategorie (KategorieID)
);

CREATE TABLE ZubehoerKompatibel
(
    ZubehoerNr INTEGER,
    ModellNr   INTEGER,
    PRIMARY KEY (ZubehoerNr, ModellNr),
    FOREIGN KEY (ZubehoerNr) REFERENCES Zubehoer (ZubehoerNr),
    FOREIGN KEY (ModellNr) REFERENCES Modell (ModellNr)
);

CREATE TABLE Lager
(
    LagerNr     INTEGER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    SpielNr     INTEGER NULL,
    ModellNr    INTEGER NULL,
    ZubehoerNr  INTEGER NULL,
    Zustand     VARCHAR(100),
    Anzahl      INTEGER,
    Preis       NUMERIC(7, 2),
    FOREIGN KEY (SpielNr) REFERENCES Spiel (SpielNr),
    FOREIGN KEY (ModellNr) REFERENCES Modell (ModellNr),
    FOREIGN KEY (ZubehoerNr) REFERENCES Zubehoer (ZubehoerNr)
);



--- Konsole/Modell
INSERT INTO Konsole(Marke, Name, Beschreibung, RichardsRetroFaktor, Anmkerkung) VALUES ('Sony', 'PlayStation 2', 'auch bekannt als PS2', 8, NULL);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (1, 'SCPH-18000', 'Japan', 2000, 300, NULL);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (1, 'SCPH-35004', 'Japan', 2000, 300, NULL);

INSERT INTO Konsole(Marke, Name, Beschreibung, RichardsRetroFaktor, Anmkerkung) VALUES ('Nintendo', 'GameCube', 'stationäre Spielkonsole, Nachfolger des Nintendo 64, vorgänger der Wii', 7, NULL);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (2, 'DOL-001', 'Japan', 2001, 129.99, '4 controller ports, 2 memory, manche haben keinen 2. serial port');
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (2, 'DOL-101', 'Europa', 2004, 99.99, 'Kostenreduzierte Version');

INSERT INTO Konsole(Marke, Name, Beschreibung, RichardsRetroFaktor, Anmkerkung) VALUES ('Sony', 'Playstation 1', 'stationäre Spielkonsole, auch PS1 genannt', 9, NULL);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (3, 'SCPH-1000', 'Japan', 1994, 129.99, 'Erste PS1, hat S-Video Port');
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (3, 'SCPH-1001', 'Nordamerika', 1994, 129.99, 'erste NA PS1, hat keinen S-Video Port');
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Anmerkung) VALUES (3, 'SCPH-5552', 'Japan', 1997, 129.99, 'bessere qualität, zeug gefixt');

--- Kategorien
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('SP', 'Spiel', NULL);
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('HW', 'Hardware', NULL);
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('ADP', 'Adapter', 'HW');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('CNTRL', 'Controller', 'HW');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('GSK', 'Geschick', 'SP');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('RACE', 'Racing', 'SP');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID) VALUES ('LSIM', 'Lebenssimulation', 'SP');

--- Zubehör
INSERT INTO Zubehoer(Name, KategorieID) VALUES ('Festplattenadapter', 'ADP');
INSERT INTO ZubehoerKompatibel(ZubehoerNr, ModellNr) VALUES (1,2); --- PS2
INSERT INTO Zubehoer(Name, KategorieID) VALUES ('Wavebird-Controller', 'CNTRL');
INSERT INTO ZubehoerKompatibel(ZubehoerNr, ModellNr) VALUES (2, 3); --- GameCube
INSERT INTO ZubehoerKompatibel(ZubehoerNr, ModellNr) VALUES (2, 4); --- GameCube
INSERT INTO Zubehoer(Name, KategorieID) VALUES ('DK Bongos', 'HW');
INSERT INTO ZubehoerKompatibel(ZubehoerNr, ModellNr) VALUES (3, 3); --- GameCube
INSERT INTO ZubehoerKompatibel(ZubehoerNr, ModellNr) VALUES (3, 4); --- GameCube

--- Spiele
INSERT INTO Spiel(KategorieID, Name, Publisher, Region, ReleaseJahr) VALUES ('GSK', 'Donkey Konga', 'Nintendo', 'Japan', 2003);
INSERT INTO SpielKompatibel(KonsoleNr, SpielNr) VALUES (2, 1);  --- Donkey für GameCube
INSERT INTO Spiel(KategorieID, Name, Publisher, Region, ReleaseJahr) VALUES ('RACE', 'Kirby Air Ride', 'Nintendo', 'Japan', 2003);
INSERT INTO SpielKompatibel(KonsoleNr, SpielNr) VALUES (2, 2);
INSERT INTO Spiel(KategorieID, Name, Publisher, Region, ReleaseJahr) VALUES ('LSIM', 'Animal Crossing', 'Nintendo', 'Japan', 2001);
INSERT INTO SpielKompatibel(KonsoleNr, SpielNr) VALUES (2, 3);

--- Lager
INSERT INTO Lager(SpielNr, ModellNr, ZubehoerNr, Zustand, Anzahl, Preis) VALUES (NULL, NULL, 1, 'Gut', 4, 9.99);
INSERT INTO Lager(SpielNr, ModellNr, ZubehoerNr, Zustand, Anzahl, Preis) VALUES (1, NULL, NULL, 'Sehr Gut', 3, 14.99);
INSERT INTO Lager(SpielNr, ModellNr, ZubehoerNr, Zustand, Anzahl, Preis) VALUES (NULL, 3, NULL, 'Exzellent', 1, 160.00);
INSERT INTO Lager(SpielNr, ModellNr, ZubehoerNr, Zustand, Anzahl, Preis) VALUES (NULL, 3, NULL, 'Akzeptabel', 5, 79.99);



COMMIT;