# Projektübersicht SGD Praktikum Team 28

Dies ist das Repository zur Bearbeitung des Praktikums des Moduls SGD an der TH Köln im Sommersemester 2023

## Inhalt
- [MS1](./src/main/ms1)
  - Projektkonzept als PDF
  - SQL-Script mit Beispieldatensätzen
- [MS2](./src/main/ms2)
  - SQL-Script mit Prozeduren
  - SQL-Script mit Triggern
  - SQL-Script mit Tests

## Projektkonzept
Im Ordner zum MS1 findet man das Projektkonzept auch zusätzlich als PDF-Datei

### Teamvorstellung
- Carina Wall (inf2506) - Teamleiter
- Junis El Ahmad (inf2397)
- Laura Zinn (inf 2395)

### Projektidee - Social-Media-App für die Studenten der TH Köln

#### Ziele
- Vernetzung der Studenten
- Erleichterte Kommunikation zwischen Kommilitonen

Das Ziel der Social-Media-App für Studenten der TH Köln ist eine bessere Vernetzung der Studenten. Dort sollen sich
Studierende zusammenfinden können um z.B. aus Gruppen die sich aus den Studierenden eines Kurses zusammensetzen besser
Lern- und Arbeitsgruppen bilden zu können. Gleichermaßen ist die App aber auch zur privaten Kommunikation der Studierenden
um so eine bessere Arbeitsumgebung an der TH Köln zu schaffen.

#### Typische Arbeitsabläufe
- Account erstellen
- nach Benutzer suchen
- Post erstellen
  - verschiedene Postarten z.B. Text oder Bild
  - in einer Gruppe posten oder öffentlich
- Post kommentieren
- Gruppe erstellen

Wenn man sich die App downloadet muss man sich erst einmal einen Account erstellen. Dabei muss man dann schon eine
E-Mail-Adresse der TH Köln hinterlegen und ein Passwort eingeben. Einmal angemeldet kann man dann eine Gruppe z.B. für 
seine private Lerngruppe erstellen und mit Hilfe einer Suchfunktion seine Kommilitonen zu dieser hinzufügen. Zudem kann 
man noch Posts in Form von Bildern oder Texten erstellen. Diese können in einer Gruppe oder öffentlich gepostet und von
Kommilitonen kommentiert werden.

#### ER-Diagramm
![ER-Diagramm](./src/main/ms1/diagramme/er_diagramm.png "ER-Diagramm")

#### Relationenmodell
![Relationenmodell](./src/main/ms1/diagramme/relationenmodell.png "Relationenmodell")


#### PL/SQL - Übersicht

| Student | Prozedur / Funktion | Trigger |
| --- |---------------------|---------|
| Carina Wall | (3)                 | (1)     |
| Junis El Ahmad | (1)                 | (3)     |
| Laura Zinn | (2)                 | (2)     |

#### Prozeduren / Funktionen
1. **Automatische Erstellung von Gruppen für einzelne Studiengänge**

    Wird ein Studiengang erstellt, soll auch automatisch eine Gruppe für diesen
    erstellt werden, es sei denn, es existiert bereits eine solche Gruppe.

2. **Top-Posts anzeigen**

    Es werden die aktuellen Top-Posts, gemessen an der Anzahl der Kommentare, angezeigt


3. **Benutzer suchen / filtern**

    Es gibt die Möglichkeit die Benutzer mit Hilfe des Namens zu suchen. Des Weiteren werden die Benutzer danach
   gefiltert ob sie noch aktiv sind. Dabei wird geschaut ob der Benutzer schon entweder einen Post
   verfasst oder einen kommentiert hat.

    

#### Trigger
1. **Bei Erstellen eines Accounts testen, ob die E-Mail korrekt ist**
  
    Beim Erstellen eines Accounts wird die hinterlegte E-Mail-Adresse geprüft. Zum einen wird getestet ob die Domain
   "smail.th-koeln.de" vorhanden ist. Des Weiteren wird darauf geachtet das nur 1 Mal das "@" Zeichen vorkommt und das 
    die E-Mail ansonsten nur aus Groß- und Kleinbuchstaben, sowie Zahlen, dem Minus und dem Punkt besteht.


2. **Bei Erstellen eines Accounts testen, ob Passwort die Bedingungen erfüllt**

    Beim Erstellen eines Accounts wird getestet ob das Passwort folgende Bedingungen erfüllt: min. 13 Zeichen lang, min. 
1 Klein-, sowie min. 1 Großbuchstaben, min. 1 Zahl und min. 3 Sonderzeichen.


3. **Nach dem Senden einer Freundesanfrage weitere Nutzer empfehlen**
    
    Sendet ein Nutzer einem zweiten Nutzer eine Freundesanfrage, soll der erste
    Nutzer Freundesempfehlungen bekommen. Hierbei sollen Nutzer vorgeschlagen werden,
    welche bereits mit dem zweiten Nutzer befreundet sind. Die empfohlenen Freunde
    sollen nach Popularität (Anzahl von Freundesanfragen) sortiert werden.