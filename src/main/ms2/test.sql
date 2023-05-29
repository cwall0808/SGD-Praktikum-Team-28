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