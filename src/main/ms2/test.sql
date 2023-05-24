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