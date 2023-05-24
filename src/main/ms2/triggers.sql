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

/* doesn't fully work yet */
-- CREATE OR REPLACE TRIGGER send_welcome_email
-- AFTER INSERT ON BENUTZER
-- FOR EACH ROW
-- DECLARE
--     smtp_connection UTL_SMTP.connection;
--     domain VARCHAR2(50) := 'smtp.smail.thkoeln.de';
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

BEGIN
    display_top_posts(3);
END;
