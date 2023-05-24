/* password requirements:
   - at least 13 characters long
   - at least one lowercase letter
   - at least one uppercase letter
   - at least one number
   - at least three special characters (for no reason whatsoever)
*/
CREATE OR REPLACE TRIGGER validate_pw
    BEFORE INSERT OR UPDATE OF passwort ON Benutzer
    FOR EACH ROW
DECLARE
    pw_length number;
    current_char varchar2(1);

    has_caps boolean := false;
    has_lowercase boolean := false;
    has_number boolean := false;
    special_character_count number := 0;
BEGIN
    pw_length := LENGTH(:NEW.passwort);

    IF pw_length < 13 THEN
        RAISE_APPLICATION_ERROR(-20111, 'Das Passwort ist zu kurz. Es muss mindestens 13 Zeichen enthalten.');
    END IF;

    FOR i IN 1..pw_length LOOP
        current_char := SUBSTR(:NEW.passwort, i, 1);
        IF(REGEXP_LIKE(current_char, '^[[:digit:]]+$')) THEN          /* is a number */
            has_number := true;
        ELSIF(REGEXP_LIKE(current_char, '[$&+,:;=?@#|''<>.^*()%!-]')) THEN /* is a special character */
            special_character_count := special_character_count + 1;
        ELSIF(current_char = UPPER(current_char)) THEN                /* is uppercase */
            has_caps := true;
        ELSE                                                          /* is lowercase */
            has_lowercase := true;
        END IF;
    END LOOP;

    IF(NOT has_caps) THEN
        RAISE_APPLICATION_ERROR(-20111, 'Das Passwort benötigt mindestens einen Großbuchstaben.');
    end if;
    IF(NOT has_lowercase) THEN
        RAISE_APPLICATION_ERROR(-20111, 'Das Passwort benötigt mindestens einen Kleinbuchstaben.');
    end if;
    IF(NOT has_number) THEN
        RAISE_APPLICATION_ERROR(-20111, 'Das Passwort benötigt mindestens eine Zahl.');
    end if;
    IF(special_character_count < 3) THEN
        RAISE_APPLICATION_ERROR(-20111, 'Das Passwort benötigt mindestens drei Sonderzeichen.');
    end if;
END;

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

BEGIN
    display_top_posts(3);
END;