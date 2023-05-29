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

/* email requirements:
   - domain "smail.th-koeln.de" required
   - exactly 1 "@"
   - allowed symbols: A-Z, a-z, 0-9, +, -
*/
CREATE OR REPLACE TRIGGER validate_email
    BEFORE INSERT OR UPDATE OF e_mail ON Benutzer
    FOR EACH ROW
DECLARE
    email_length number;
    current_char varchar2(1);

    email_domain varchar2(50);
    at_the_rate_count number := 0;
    only_allowed_symbols boolean := true;  
BEGIN
    email_length := LENGTH(:NEW.e_mail);

    FOR i IN 1..email_length LOOP
        current_char := SUBSTR(:NEW.e_mail, i, 1);
        
        IF(REGEXP_LIKE(current_char, '[$&+,:;=?#|''<>^*()%!]')) THEN /* is a special character */
            only_allowed_symbols := false;
            RAISE_APPLICATION_ERROR(-20111, 'Die Email-Adresse darf keine Sonderzeichen, au�er . und - beinhalten.');
        ELSIF(current_char = '@') THEN                /* is at the rate sign */
            at_the_rate_count := at_the_rate_count + 1;
            IF(at_the_rate_count > 1) THEN
                RAISE_APPLICATION_ERROR(-20111, 'Die Email-Adresse darf nur einmal "@" enthalten.');
            ELSE
                email_domain := SUBSTR(:NEW.e_mail, i+1);
                IF(NOT email_domain = 'smail.th-koeln.de') THEN
                    RAISE_APPLICATION_ERROR(-20111, 'Die Domain der Email-Adresse muss "@smail.th-koeln.de" sein.');
                END IF;  
                EXIT;
            END IF;    
        END IF;
    END LOOP;

    IF(at_the_rate_count < 1) THEN
        RAISE_APPLICATION_ERROR(-20111, 'Die Email muss genau einmal "@" enthalten um die Domain einzuleiten.');
    END IF;
END;

CREATE OR REPLACE TRIGGER recommend_friends
FOR INSERT ON befreundet_mit
COMPOUND TRIGGER
    current_user_id befreundet_mit.b1_id%TYPE;
    requested_friend_id befreundet_mit.b2_id%TYPE;

    CURSOR recommended_friends IS
    SELECT b1_id, b2_id, count(b2_id) FROM befreundet_mit
    WHERE (b1_id = requested_friend_id OR b2_id = requested_friend_id)
    AND (b1_id != current_user_id AND b2_id != current_user_id)
    GROUP BY b1_id, b2_id
    ORDER BY count(b2_id) DESC
    FETCH FIRST 5 ROWS ONLY;

    AFTER EACH ROW IS
    BEGIN
        current_user_id := :NEW.b1_id;
        requested_friend_id := :NEW.b2_id;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        DBMS_OUTPUT.put_line('More friends from user ' || requested_friend_id || ':');
        FOR recommended_friend IN recommended_friends LOOP
            IF recommended_friend.b1_id = requested_friend_id
            THEN DBMS_OUTPUT.put_line(recommended_friend.b2_id);
            ELSE DBMS_OUTPUT.put_line(recommended_friend.b1_id);
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END recommend_friends;

/* doesn't fully work yet */
-- CREATE OR REPLACE TRIGGER send_welcome_email
-- AFTER INSERT ON BENUTZER
-- FOR EACH ROW
-- DECLARE
--     smtp_connection UTL_SMTP.connection;
--     domain VARCHAR2(50) := 'smtp.intranet.fh-koeln.de';
--     from_email VARCHAR2(50) := 'junis.el-ahmad@smail.th-koeln.de';
--     email_body VARCHAR2(500) := 'test';
-- BEGIN
--     smtp_connection := UTL_SMTP.open_connection(domain, 25);
--     UTL_SMTP.helo(smtp_connection, domain);
--     UTL_SMTP.mail(smtp_connection, from_email);
--     UTL_SMTP.rcpt(smtp_connection, :NEW.e_mail);
--
--     UTL_SMTP.open_data(smtp_connection);
--     UTL_SMTP.write_data(smtp_connection, email_body || UTL_TCP.crlf || UTL_TCP.crlf);
--     UTL_SMTP.close_data(smtp_connection);
--
--     UTL_SMTP.quit(smtp_connection);
-- END;