ALTER SESSION SET NLS_DATE_FORMAT='DD.MM.YYYY';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD.MM.YYYY HH24:MI:SS.FF';

DROP TABLE Lager;
DROP TABLE SpielKompatibel;
DROP TABLE Spiel;
DROP TABLE Modell;
DROP TABLE Kategorie;
DROP TABLE Konsole;

CREATE TABLE Konsole
(
    KonsoleNr           INTEGER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    Marke               VARCHAR(100) NOT NULL,
    Name                VARCHAR(100) NOT NULL,
    Beschreibung        VARCHAR(300),
    RichardsRetroFaktor NUMERIC(1) CHECK (RichardsRetroFaktor BETWEEN 0 AND 9)
);

CREATE TABLE Kategorie
(
    KategorieID     CHAR(5) PRIMARY KEY NOT NULL,
    Bezeichnung     VARCHAR(50) NOT NULL,
    OberkategorieID CHAR(5),
    FOREIGN KEY (OberkategorieID) REFERENCES Kategorie (KategorieID) ON DELETE CASCADE
);

CREATE TABLE Modell
(
    ModellNr     INTEGER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    KonsoleNr    INTEGER NOT NULL ,
    Seriennr     VARCHAR(20) NOT NULL ,
    Region       VARCHAR(50) CHECK (Region IN ('Europa', 'Nordamerika', 'Japan', 'Welt')) NOT NULL,
    ReleaseJahr  INTEGER NOT NULL ,
    UVP          NUMERIC(7, 2) CHECK (UVP > 0) NOT NULL ,
    Beschreibung VARCHAR(300),
    FOREIGN KEY (KonsoleNr) REFERENCES Konsole (KonsoleNr) ON DELETE CASCADE
);

CREATE TABLE Spiel
(
    SpielNr     INTEGER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    KategorieID CHAR(5) NOT NULL ,
    Name        VARCHAR(100) NOT NULL ,
    Publisher   VARCHAR(100) NOT NULL ,
    Region      VARCHAR(50) CHECK (Region IN ('Europa', 'Nordamerika', 'Japan', 'Welt')) NOT NULL ,
    ReleaseJahr INTEGER CHECK (ReleaseJahr BETWEEN 0 AND 3000) NOT NULL ,
    FOREIGN KEY (KategorieID) REFERENCES Kategorie (KategorieID) ON DELETE SET NULL
);

CREATE TABLE SpielKompatibel
(
    KonsoleNr INTEGER,
    SpielNr   INTEGER,
    PRIMARY KEY (KonsoleNr, SpielNr),
    FOREIGN KEY (KonsoleNr) REFERENCES Konsole (KonsoleNr) ON DELETE CASCADE,
    FOREIGN KEY (SpielNr) REFERENCES Spiel (SpielNr) ON DELETE CASCADE
);





CREATE TABLE Lager
(
    LagerNr    INTEGER GENERATED ALWAYS as IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    SpielNr    INTEGER,
    ModellNr   INTEGER,
    Zustand    VARCHAR(100) NOT NULL ,
    Anzahl     INTEGER NOT NULL ,
    Preis      NUMERIC(7, 2) CHECK (Preis > 0) NOT NULL ,
    FOREIGN KEY (SpielNr) REFERENCES Spiel (SpielNr) ON DELETE CASCADE,
    FOREIGN KEY (ModellNr) REFERENCES Modell (ModellNr) ON DELETE CASCADE
);


--- Konsole/Modell
INSERT INTO Konsole(Marke, Name, Beschreibung, RichardsRetroFaktor)
VALUES ('Sony', 'PlayStation 2', 'auch bekannt als PS2', 8);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (1, 'SCPH-18000', 'Japan', 2000, 300, NULL);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (1, 'SCPH-35004', 'Japan', 2000, 300, NULL);

INSERT INTO Konsole(Marke, Name, Beschreibung, RichardsRetroFaktor)
VALUES ('Nintendo', 'GameCube', 'stationäre Spielkonsole, Nachfolger des Nintendo 64, vorgänger der Wii', 7);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (2, 'DOL-001', 'Japan', 2001, 129.99, '4 controller ports, 2 memory, manche haben keinen 2. serial port');
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (2, 'DOL-101', 'Europa', 2004, 99.99, 'Kostenreduzierte Version');

INSERT INTO Konsole(Marke, Name, Beschreibung, RichardsRetroFaktor)
VALUES ('Sony', 'Playstation 1', 'stationäre Spielkonsole, auch PS1 genannt', 9);
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (3, 'SCPH-1000', 'Japan', 1994, 129.99, 'Erste PS1, hat S-Video Port');
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (3, 'SCPH-1001', 'Nordamerika', 1994, 129.99, 'erste NA PS1, hat keinen S-Video Port');
INSERT INTO Modell(KonsoleNr, Seriennr, Region, ReleaseJahr, UVP, Beschreibung)
VALUES (3, 'SCPH-5552', 'Japan', 1997, 129.99, 'bessere qualität, zeug gefixt');

--- Kategorien
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('SP', 'Spiel', NULL);
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('HW', 'Hardware', NULL);
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('ADP', 'Adapter', 'HW');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('CNTRL', 'Controller', 'HW');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('GSK', 'Geschick', 'SP');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('RACE', 'Racing', 'SP');
INSERT INTO Kategorie(KategorieID, Bezeichnung, OberkategorieID)
VALUES ('LSIM', 'Lebenssimulation', 'SP');



--- Spiele
INSERT INTO Spiel(KategorieID, Name, Publisher, Region, ReleaseJahr)
VALUES ('GSK', 'Donkey Konga', 'Nintendo', 'Japan', 2003);
INSERT INTO SpielKompatibel(KonsoleNr, SpielNr)
VALUES (2, 1); --- Donkey für GameCube
INSERT INTO Spiel(KategorieID, Name, Publisher, Region, ReleaseJahr)
VALUES ('RACE', 'Kirby Air Ride', 'Nintendo', 'Japan', 2003);
INSERT INTO SpielKompatibel(KonsoleNr, SpielNr)
VALUES (2, 2);
INSERT INTO Spiel(KategorieID, Name, Publisher, Region, ReleaseJahr)
VALUES ('LSIM', 'Animal Crossing', 'Nintendo', 'Japan', 2001);
INSERT INTO SpielKompatibel(KonsoleNr, SpielNr)
VALUES (2, 3);

--- Lager
INSERT INTO Lager(SpielNr, ModellNr, Zustand, Anzahl, Preis)
VALUES (NULL, 1, 'Gut', 4, 9.99);
INSERT INTO Lager(SpielNr, ModellNr, Zustand, Anzahl, Preis)
VALUES (1, NULL, 'Sehr Gut', 3, 14.99);
INSERT INTO Lager(SpielNr, ModellNr, Zustand, Anzahl, Preis)
VALUES (NULL, 3, 'Exzellent', 1, 160.00);
INSERT INTO Lager(SpielNr, ModellNr, Zustand, Anzahl, Preis)
VALUES (NULL, 3, 'Akzeptabel', 5, 79.99);



COMMIT;