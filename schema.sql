-- Initialize the database.
-- Drop any existing data and create empty tables.

DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Telefonnummer;
DROP TABLE IF EXISTS Besucher;
DROP TABLE IF EXISTS Oper_gehört_Rollenbuchtypen;
DROP TABLE IF EXISTS Aufführung_von;
DROP TABLE IF EXISTS reservieren;
DROP TABLE IF EXISTS Bank;
DROP TABLE IF EXISTS Angestellte_hat_Gehaltskonto;
DROP TABLE IF EXISTS Sänger;
DROP TABLE IF EXISTS singen;
DROP TABLE IF EXISTS Besucher_bevorzugen;
DROP TABLE IF EXISTS Sprache;
DROP TABLE IF EXISTS kann;
DROP TABLE IF EXISTS Requisiteur;
DROP TABLE IF EXISTS Rollenbücher_haben;
DROP TABLE IF EXISTS Rollenbücher_entlehnen;
DROP TABLE IF EXISTS vertragen_sich_nicht;
DROP TABLE IF EXISTS users;


CREATE TABLE Person 
(
    SozNr NUMBER(10),
    Vorname VARCHAR2(50),
    Nachname VARCHAR2(50),
    Ort VARCHAR2 (20),
    Adresse VARCHAR2(50),
    CONSTRAINT pk_Person PRIMARY KEY (SozNr)
);


CREATE TABLE users 
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    SozNr NUMBER(10) NOT NULL,
    CONSTRAINT fk_users FOREIGN KEY (SozNr) REFERENCES Person (SozNr)
);

CREATE TABLE Telefonnummer
(
    SozNr NUMBER(10),
    Telefonnummer VARCHAR(20),
    CONSTRAINT pk_Telefonnummer PRIMARY KEY (SozNr, Telefonnummer),
    CONSTRAINT fk_Telefonnummer_Person FOREIGN KEY (SozNr) REFERENCES Person (SozNr) ON DELETE CASCADE
);

CREATE TABLE Besucher
(
    SozNr NUMBER(10),
    Kundennummer NUMBER(10)
        CONSTRAINT nn_Besucher_Kundennummer NOT NULL,
    CONSTRAINT pk_Besucher PRIMARY KEY (SozNr),
    CONSTRAINT fk_Besucher_Person FOREIGN KEY (SozNr) REFERENCES Person (SozNr) ON DELETE CASCADE
);

CREATE TABLE Oper_gehört_Rollenbuchtypen
(
    Name VARCHAR2(50),
    Probendauer NUMBER(10),
    NrRequisiteure NUMBER(5),
    ISBN VARCHAR2(20)
        CONSTRAINT nn_ISBN NOT NULL,
    Komponist VARCHAR2(50),
    CONSTRAINT pk_Oper_gehört_Roll PRIMARY KEY (Name)
);

CREATE TABLE Aufführung_von
(
    Datum DATE,
    Uhrzeit TIME,
    Dirigent VARCHAR2(30),
    Budget NUMBER(7),
    Name VARCHAR2(30),
    CONSTRAINT pk_Aufführung_von PRIMARY KEY (Datum, Uhrzeit),
    CONSTRAINT fk_Aufführung_von_Oper_gR FOREIGN KEY (Name) REFERENCES Oper_gehört_Rollenbuchtypen (Name)
);

CREATE TABLE reservieren
(
    SozNr NUMBER(10),
    Reservierungsnummer VARCHAR2(8),
    Datum DATE
        CONSTRAINT nn_reservieren_Datum NOT NULL,
    Uhrzeit TIME
        CONSTRAINT nn_reservieren_Uhrzeit NOT NULL,
    Sitzplatz VARCHAR2(4),
    CONSTRAINT pk_reservieren PRIMARY KEY (Reservierungsnummer),
    CONSTRAINT fk_reservieren_Besucher FOREIGN KEY (SozNr) REFERENCES Besucher (SozNr) ON DELETE CASCADE,
    CONSTRAINT fk_reservieren_Aufführung_von FOREIGN KEY (Datum, Uhrzeit) REFERENCES Aufführung_von (Datum, Uhrzeit)
);

CREATE TABLE Bank
(
    BLZ VARCHAR2(10),
    Bankname VARCHAR2(50),
    CONSTRAINT pk_Bank PRIMARY KEY (BLZ)
);

CREATE TABLE Angestellte_hat_Gehaltskonto
(
    SozNr NUMBER(10),
    Angestelltennummer VARCHAR2(20)
        CONSTRAINT nn_AN_hat_Gkonto_Anr NOT NULL
        CONSTRAINT unq_AN_hat_Gkonto_Anr UNIQUE,
    Kontonummer VARCHAR2(30)
        CONSTRAINT nn_AN_hat_Gkonto_Knr NOT NULL
        CONSTRAINT unq_AN_hat_Gkonto_Knr UNIQUE,
    Kontostand NUMBER(15),
    BLZ VARCHAR2(10)
        CONSTRAINT nn_AN_hat_Gkonto_BLZ NOT NULL,
    CONSTRAINT pk_AN_hat_Gkonto PRIMARY KEY (SozNr),
    CONSTRAINT fk_AN_hat_Gkonto_Person FOREIGN KEY (SozNr) REFERENCES Person (SozNr) ON DELETE CASCADE, 
    CONSTRAINT fk_AN_hat_Gkonto_Bank FOREIGN KEY (BLZ) REFERENCES Bank (BLZ)
);

CREATE TABLE Sänger
(
    SozNr NUMBER(10),
    Künstlername VARCHAR2(30)
        CONSTRAINT nn_Sänger_Künstlername NOT NULL
        CONSTRAINT unq_Sänger_Künstlername UNIQUE,
    Datum DATE,
    CONSTRAINT pk_Sänger PRIMARY KEY (SozNr),
    CONSTRAINT fk_Sänger_AN_hat_Gkonto FOREIGN KEY (SozNr) REFERENCES Angestellte_hat_Gehaltskonto (SozNr) ON DELETE CASCADE
);

CREATE TABLE singen
(
    SozNr NUMBER(10),
    Datum DATE,
    Uhrzeit TIME,
    CONSTRAINT pk_singen PRIMARY KEY (SozNr),
    CONSTRAINT fk_singen_Sänger FOREIGN KEY (SozNr) REFERENCES Sänger (SozNr) ON DELETE CASCADE,
    CONSTRAINT fk_singen_Aufführung_von FOREIGN KEY (Datum, Uhrzeit) REFERENCES Aufführung_von ON DELETE CASCADE
);


CREATE TABLE Besucher_bevorzugen
(
    SozNr NUMBER(10),
    Kundennummer NUMBER(10),
    CONSTRAINT pk_Besucher_bevorzugen PRIMARY KEY (Kundennummer),
    CONSTRAINT fk_Besucher FOREIGN KEY (SozNr) REFERENCES Besucher (SozNr) ON DELETE CASCADE,
    CONSTRAINT fk_Besucher_bevorz_Sänger FOREIGN KEY (SozNr) REFERENCES Sänger (SozNr) ON DELETE CASCADE
);

CREATE TABLE Sprache
(
    Sprache VARCHAR2(20),
    CONSTRAINT pk_Sprache PRIMARY KEY (Sprache)
);

CREATE TABLE kann
(
    SozNr NUMBER(10),
    Name VARCHAR2(50), 
    Sprache VARCHAR2(20),
    CONSTRAINT pk_kann PRIMARY KEY (SozNr),
    CONSTRAINT fk_kann_Oper_gehört_R FOREIGN KEY (Name) REFERENCES Oper_gehört_Rollenbuchtypen (Name),
    CONSTRAINT fk_kann_Sänger FOREIGN KEY (SozNr) REFERENCES Sänger (SozNr),
    CONSTRAINT fk_kann_Sprache FOREIGN KEY (Sprache) REFERENCES Sprache (Sprache)
);

CREATE TABLE Requisiteur
(
    SozNr NUMBER(10),
    CONSTRAINT pk_Requisiteur PRIMARY KEY (SozNr),
    CONSTRAINT fk_Requisiteur_A_hat_Gkonto FOREIGN KEY (SozNr) REFERENCES Angestellte_hat_Gehaltskonto ON DELETE CASCADE
);

CREATE TABLE Rollenbücher_haben
(
    Inventarnr VARCHAR2(25),
    SozNr NUMBER(10),
    Name VARCHAR2(30)
        CONSTRAINT nn_Rb_haben_Name NOT NULL,
    Komponist VARCHAR2(50),
    CONSTRAINT pk_Rb_haben PRIMARY KEY (Inventarnr),
    CONSTRAINT fk_Rb_Oper_gehört_R FOREIGN KEY (Name) REFERENCES Oper_gehört_Rollenbuchtypen (Name),
    CONSTRAINT fk_Rb_A_hat_Gkonto FOREIGN KEY (SozNr) REFERENCES Angestellte_hat_Gehaltskonto (SozNr)
);

CREATE TABLE Rollenbücher_entlehnen
(
    SozNr NUMBER(10),
    Inventarnr VARCHAR2(25)
        CONSTRAINT unq_Rb_entl_Inventarnr UNIQUE,
    CONSTRAINT pk_Rb_entlehnen PRIMARY KEY (SozNr),
    CONSTRAINT fk_Rb_entl_Rb_haben FOREIGN KEY (Inventarnr) REFERENCES Rollenbücher_haben,
    CONSTRAINT fk_Rb_entl_A_hat_Gkonto FOREIGN KEY (SozNr) REFERENCES Angestellte_hat_Gehaltskonto (SozNr)
);

CREATE TABLE vertragen_sich_nicht
(
    Vorher NUMBER(10),
    Nachher NUMBER(10),
    CONSTRAINT pk_vertragen_sich_nicht PRIMARY KEY (Vorher, Nachher),
    CONSTRAINT fk_vorher_Sänger FOREIGN KEY (Vorher) REFERENCES Sänger (SozNr),
    CONSTRAINT fk_nachher_Sänger FOREIGN KEY (Nachher) REFERENCES Sänger (SozNr)
);
