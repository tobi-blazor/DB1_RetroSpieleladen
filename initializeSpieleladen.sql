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
    KonsoleNr           INTEGER PRIMARY KEY,
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
    ModellNr    INTEGER PRIMARY KEY,
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
    SpielNr     INTEGER,
    KategorieID CHAR(5),
    Name        VARCHAR(100),
    Publisher   VARCHAR(100),
    ReleaseJahr INTEGER,
    PRIMARY KEY (SpielNr),
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
    ZubehoerNr  INTEGER,
    ModellNr    INTEGER,
    Name        VARCHAR(100),
    KategorieID CHAR(10),
    PRIMARY KEY (ZubehoerNr),
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
    LagerNr     INTEGER PRIMARY KEY,
    SpielNr     INTEGER NULL,
    ModellNr    INTEGER NULL,
    ZubehoerNr  INTEGER NULL,
    Zustand     VARCHAR(100),
    Anzahl      INTEGER,
    Preis       NUMERIC(7, 2),
    RabattInEUR NUMERIC(7, 2),
    FOREIGN KEY (SpielNr) REFERENCES Spiel (SpielNr),
    FOREIGN KEY (ModellNr) REFERENCES Modell (ModellNr),
    FOREIGN KEY (ZubehoerNr) REFERENCES Zubehoer (ZubehoerNr)
);

