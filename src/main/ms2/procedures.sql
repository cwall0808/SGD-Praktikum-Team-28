CREATE OR REPLACE PROCEDURE update_degree_groups
IS
    CURSOR studiengaenge IS SELECT name FROM STUDIENGANG;
    anzahl_studiengang_gruppen NUMBER;
    studiengang_name VARCHAR2(30);
    next_id NUMBER;
BEGIN
    FOR studiengang IN studiengaenge LOOP
        anzahl_studiengang_gruppen := 0;
        studiengang_name := studiengang.NAME;

        SELECT count(*)
        INTO anzahl_studiengang_gruppen
        FROM GRUPPE
        WHERE name LIKE studiengang_name;

        IF anzahl_studiengang_gruppen = 0 THEN
            SELECT MAX(g_id) + 1
            INTO next_id
            FROM GRUPPE;

            INSERT INTO GRUPPE VALUES (next_id, studiengang_name);
            dbms_output.put_line('created group ' || studiengang_name);
        END IF;
    END LOOP;
END;
