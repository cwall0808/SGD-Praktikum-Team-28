DROP TABLE Studiengang CASCADE CONSTRAINTS;
DROP TABLE Benutzer CASCADE CONSTRAINTS;
DROP TABLE befreundet_mit CASCADE CONSTRAINTS;
DROP TABLE Gruppe CASCADE CONSTRAINTS;
DROP TABLE ist_teil_von CASCADE CONSTRAINTS;
DROP TABLE Post CASCADE CONSTRAINTS;
DROP TABLE Bild_Post CASCADE CONSTRAINTS;
DROP TABLE Text_Post CASCADE CONSTRAINTS;
DROP TABLE Kommentar CASCADE CONSTRAINTS;

CREATE TABLE Studiengang (
  s_id number PRIMARY KEY,
  name varchar2(50) NOT NULL
);

CREATE TABLE Benutzer (
  b_id      number        PRIMARY KEY,
  nachname  varchar2(50)  NOT NULL,
  vorname   varchar2(50)  NOT NULL,
  profilbild_url varchar2(50) NULL,
  beschreibung varchar2(50) NULL,
  e_mail    varchar2(50)  NOT NULL,
  passwort  varchar2(50)  NOT NULL,
  s_id      number NOT NULL,
  CONSTRAINT studiengang_benutzer FOREIGN KEY (s_id) REFERENCES Studiengang (s_id)
);

CREATE TABLE befreundet_mit (
  b1_id number,
  b2_id number,
  CONSTRAINT pk_befreundet_mit PRIMARY KEY (b1_id, b2_id),
  CONSTRAINT b1_befreundet_mit FOREIGN KEY (b1_id) REFERENCES Benutzer (b_id),
  CONSTRAINT b2_befreundet_mit FOREIGN KEY (b2_id) REFERENCES Benutzer (b_id)
);

CREATE TABLE Gruppe (
  g_id number PRIMARY KEY,
  name varchar2(50) NOT NULL
);

CREATE TABLE ist_teil_von (
  b_id number,
  g_id number,
  CONSTRAINT pk_ist_teil_von PRIMARY KEY (b_id, g_id),
  CONSTRAINT benutzer_ist_teil_von FOREIGN KEY (b_id) REFERENCES Benutzer (b_id),
  CONSTRAINT gruppe_ist_teil_von FOREIGN KEY (g_id) REFERENCES Gruppe (g_id)
);

CREATE TABLE Post (
  p_id number PRIMARY KEY,
  titel varchar2(50) NOT NULL,
  b_id number NOT NULL,
  g_id number NULL,
  CONSTRAINT benutzer_post FOREIGN KEY (b_id) REFERENCES Benutzer (b_id),
  CONSTRAINT group_post FOREIGN KEY (b_id) REFERENCES Gruppe (g_id)
); 

CREATE TABLE Bild_Post (
  p_id number PRIMARY KEY,
  bild_url varchar2(50) NOT NULL,
  CONSTRAINT fk_bild_post FOREIGN KEY (p_id) REFERENCES Post (p_id)
);

CREATE TABLE Text_Post (
  p_id number PRIMARY KEY,
  inhalt varchar2(1000) NOT NULL,
  CONSTRAINT fk_text_post FOREIGN KEY (p_id) REFERENCES Post (p_id)
);

CREATE TABLE Kommentar (
  k_id number PRIMARY KEY,
  b_id number NOT NULL,
  p_id number NOT NULL,
  inhalt varchar2(500) NOT NULL,
  CONSTRAINT benutzer_kommentar FOREIGN KEY (b_id) REFERENCES Benutzer (b_id),
  CONSTRAINT post_kommentar FOREIGN KEY (p_id) REFERENCES Post (p_id)
);

INSERT INTO studiengang (s_id, name) VALUES (1, 'Informatik');
INSERT INTO studiengang (s_id, name) VALUES (2, 'Mathematik');
INSERT INTO studiengang (s_id, name) VALUES (3, 'Kunst');

INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id) 
VALUES (1, 'El Ahmad', 'Junis', 'Junis.El-Ahmad@webmail.th-koeln.de', 'geheim', 1);

INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id) 
VALUES (2, 'Wall', 'Carina', 'Carina.Wall@webmail.th-koeln.de', 'geheimnis', 2);

INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id) 
VALUES (3, 'Zinn', 'Laura', 'Laura.Zinn@webmail.th-koeln.de', 'geheimnis123', 3);

INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (1, 3);
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (2, 3);

INSERT INTO gruppe (g_id, name) VALUES (1, 'Programmierer');

INSERT INTO ist_teil_von (b_id, g_id) VALUES (1, 1);
INSERT INTO ist_teil_von (b_id, g_id) VALUES (2, 1);

INSERT INTO post (p_id, titel, b_id, g_id) VALUES (1, 'Neue Freunde', 1, NULL);
INSERT INTO text_post (p_id, inhalt) 
VALUES (1, 'Heute habe ich neue Freunde kennengelernt. Alles nur Dank unserer SUPER Datenbank!! ^__^');

INSERT INTO kommentar (k_id, b_id, p_id, inhalt) VALUES (1, 3, 1, 'Wow ich LIEBE diese Datenbank.');

UPDATE benutzer SET passwort = 'PASSWORt123%%$3123' WHERE b_id = 3;
