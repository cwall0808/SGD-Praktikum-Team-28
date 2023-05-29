/* validate_pw Trigger TEST */
-- 1. Ausgangslage
SELECT passwort FROM benutzer WHERE b_id = 3;
-- 2. Test mit fehlerhaften Fall
UPDATE benutzer SET passwort = 'passwort123' WHERE b_id = 3;
-- 3. Kontrollanfrage, ob Test fehlgeschlagen ist
SELECT passwort FROM benutzer WHERE b_id = 3;
-- 4. Testfall rückgängig machen
rollback;
-- 5. Test mit korrektem Fall
UPDATE benutzer SET passwort = 'Passwort12!!!<3' WHERE b_id = 3;
-- 6. Kontrollanfrage, ob Test geglückt ist
SELECT passwort FROM benutzer WHERE b_id = 3;
-- 4. Testfall rückgängig machen
rollback;

/* validate_email Trigger TEST */
-- 1. Ausgangslage
SELECT e_mail FROM benutzer WHERE b_id = 3;
-- 2. Test mit fehlerhaften Fall
UPDATE benutzer SET e_mail = 'laura.zinn@webmail.th-koeln.de' WHERE b_id = 3;
-- 3. Kontrollanfrage, ob Test fehlgeschlagen ist
SELECT e_mail FROM benutzer WHERE b_id = 3;
-- 4. Testfall rückgängig machen
rollback;
-- 5. Test mit korrektem Fall
UPDATE benutzer SET e_mail = 'Laura.Zinn@smail.th-koeln.de' WHERE b_id = 3;
-- 6. Kontrollanfrage, ob Test geglückt ist
SELECT e_mail FROM benutzer WHERE b_id = 3;
-- 4. Testfall rückgängig machen
rollback;

/* display_top_posts TEST */
-- 1. Ausgangslage
-- Neuer Post von User 3 mit zwei Kommentaren (von User 1 und 2)
INSERT INTO post (p_id, titel, b_id, g_id) VALUES (2, 'Testfall', 3, NULL);
INSERT INTO text_post (p_id, inhalt)
VALUES (2, 'Heute habe ich einen neuen Test geschrieben. Hoffentlich läuft alles gut.');
INSERT INTO kommentar (k_id, b_id, p_id, inhalt) VALUES (2, 1, 2, 'Hallo User 3.');
INSERT INTO kommentar (k_id, b_id, p_id, inhalt) VALUES (3, 2, 2, 'Ich wollte auch mal Teil des Tests sein.');
-- Neuer Post von User 2 mit einem Kommentar (User 3)
INSERT INTO post (p_id, titel, b_id, g_id) VALUES (3, 'Testfall Nummer 2', 2, NULL);
INSERT INTO text_post (p_id, inhalt)
VALUES (3, 'Hoffentlich werde ich angezeigt.');
INSERT INTO kommentar (k_id, b_id, p_id, inhalt) VALUES (4, 3, 3, 'Hallo User 2.');
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (1, 2);
-- Neuer Post von User 3 ohne Kommentare
INSERT INTO post (p_id, titel, b_id, g_id) VALUES (4, 'Testfall Nummer 3', 2, NULL);
INSERT INTO text_post (p_id, inhalt)
VALUES (4, 'Ich werde ignoriert...');
-- 2. User 1 Loggt sich ein und sieht die Posts mit mindestens einem Kommentar.
BEGIN
    display_top_posts(1);
END;
-- 3. Testfall rückgängig machen
rollback;
-- 5. Ausgangslange mit neuem Post von User 3 ohne Kommentare
INSERT INTO post (p_id, titel, b_id, g_id) VALUES (2, 'Testfall', 3, NULL);
INSERT INTO text_post (p_id, inhalt)
VALUES (2, 'Heute habe ich einen neuen Test geschrieben. Hoffentlich läuft alles gut.');
-- 6. User 1 loggt sich ein und sieht keine Top Posts, da es kein Engagement (= Kommentare) gibt
BEGIN
    display_top_posts(1);
END;
-- 4. Testfall rückgängig machen
rollback;

/* update_degree_groups Prozedur TEST */
-- 1. Ausgangslage, wenn Gruppe zu Studiengang bereits existiert
INSERT INTO studiengang (s_id, name) VALUES (100, 'Philosophie');
INSERT INTO gruppe (g_id, name) VALUES (150, 'Philosophie');
-- 2. Test, dass keine zweite Gruppe zum Studiengang erstellt wurde
SELECT count(name) FROM gruppe WHERE name = 'Philosophie';

BEGIN
    update_degree_groups();
END;

SELECT count(name) FROM gruppe WHERE name = 'Philosophie';
-- 3. Testfall rückgängig machen
rollback;
-- 4. Ausgangslage, wenn KEINE Gruppe zu Studiengang existiert
INSERT INTO studiengang (s_id, name) VALUES (100, 'Philosophie');
-- 5. Test, dass eine neue Gruppe zu Studiengang erstellt wurde
SELECT count(name) FROM gruppe WHERE name = 'Philosophie';

BEGIN
    update_degree_groups();
END;

SELECT count(name) FROM gruppe WHERE name = 'Philosophie';
-- 6. Testfall rückgängig machen
rollback;

/* recommend_friends Trigger TEST */
-- 1. Ausgangslage der Benutzer
INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id)
VALUES (100, 'Lama', 'Anna', 'anna@webmail.th-koeln.de', 'Passwort12!!!<3', 1);
INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id)
VALUES (101, 'Blob', 'Bob', 'bob@webmail.th-koeln.de', 'Passwort12!!!<3', 1);
INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id)
VALUES (102, 'Gasolin', 'Carolin', 'caroline@webmail.th-koeln.de', 'Passwort12!!!<3', 1);
INSERT INTO benutzer (b_id, nachname, vorname, e_mail, passwort, s_id)
VALUES (103, 'Bambina', 'Dina', 'dina@webmail.th-koeln.de', 'Passwort12!!!<3', 1);
-- 2. Ausgangslage von befreundet_mit
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (100, 103);
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (101, 102);
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (101, 103);
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (103, 102);
-- 3. Test, wenn Nutzer 100 Freundesanfrage an Nutzer 101 sendet
-- (sortiert nach meisten Freundesanfragen)
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (100, 101);
-- 4. Test, wenn Nutzer 101 Freundesanfrage an Nutzer 100 sendet
-- (hierbei soll Nutzer 101 sich nicht selbst vorgeschlagen werden)
INSERT INTO befreundet_mit (b1_id, b2_id) VALUES (101, 100);
-- 5. Testfälle rückgängig machen
rollback;
