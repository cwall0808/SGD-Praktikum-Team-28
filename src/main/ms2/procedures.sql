/* popular posts defined by engagement (most comments),
   right now it just prints all posts by friends that have at least 1 comment
*/
CREATE OR REPLACE PROCEDURE display_top_posts (user_id NUMBER)
IS
    comment_count number;
    op_vorname varchar2(50);
    op_nachname varchar2(50);
    post_content varchar2(1000);

    CURSOR c_posts IS SELECT p_id, titel, b_id, g_id FROM post
        WHERE b_id IN (SELECT b1_id FROM befreundet_mit WHERE b2_id = user_id)
        OR b_id IN (SELECT b2_id FROM befreundet_mit WHERE b1_id = user_id); -- only posts by friends
BEGIN
    dbms_output.put_line( '---------------');
    dbms_output.put_line( 'Die jetzigen Top Posts: ');
    FOR record in c_posts LOOP
        SELECT count(*) INTO comment_count FROM kommentar WHERE record.p_id = kommentar.p_id;
        IF comment_count >= 1 THEN
            SELECT vorname INTO op_vorname FROM benutzer WHERE b_id = record.b_id;
            SELECT nachname INTO op_nachname FROM benutzer WHERE b_id = record.b_id;
            SELECT inhalt INTO post_content FROM text_post WHERE p_id = record.p_id; -- todo: differentiate between text / image posts
            dbms_output.put_line( '---------------');
            dbms_output.put_line( record.titel || ' von ' || op_vorname || ' ' || op_nachname);
            dbms_output.put_line( post_content);
        END IF;
    END LOOP;
END;

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