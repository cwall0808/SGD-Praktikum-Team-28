/* popular posts defined by engagement (most comments),
   right now it just prints all posts by friends that have at least 1 comment
*/
CREATE OR REPLACE PROCEDURE display_top_posts (user_id NUMBER)
IS
    comment_count number;
    op_vorname varchar2(50);
    op_nachname varchar2(50);
    post_content varchar2(1000);
    found_posts boolean := false;

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
            found_posts := true;
        END IF;
    END LOOP;

    IF NOT found_posts THEN
        dbms_output.put_line( 'Momentan gibt es keine Top Posts!');
    END IF;
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

/* user that match the query and are active
    active means they already made a post or comment
 */
CREATE OR REPLACE PROCEDURE query_active_user (user_id NUMBER, query VARCHAR2)
    IS
        query_matches boolean;
        user_vorname varchar2(50);
        user_nachname varchar2(50);
        found_matches boolean;
        CURSOR active_user IS SELECT b_id, nachname, vorname FROM BENUTZER
            WHERE b_id IN (SELECT b_id FROM POST)
            OR b_id IN (SELECT b_id FROM KOMMENTAR);
BEGIN
    found_matches := false;
    dbms_output.put_line( '---------------');
    dbms_output.put_line( 'Aktive User die auf deine Suche passen: ');
    FOR user IN active_user LOOP
        query_matches := false;
        IF NOT user_id = user.B_ID THEN
            IF instr(user.nachname, query) > 0 THEN
                    query_matches := true;
                    found_matches := true;
                    user_vorname := user.VORNAME;
                    user_nachname := user.NACHNAME;
            ELSIF instr(user.vorname, query) > 0 THEN
                    query_matches := true;
                    found_matches := true;
                    user_vorname := user.VORNAME;
                    user_nachname := user.NACHNAME;
            END IF;
        END IF;

        IF query_matches THEN
                dbms_output.put_line(user_vorname || ' ' || user_nachname);
        END IF;
    END LOOP;
    IF NOT found_matches THEN
        dbms_output.put_line('Es wurden leider keine passenden, aktiven User gefunden.');
    end if;
END;