-- FUNCTION
CREATE OR REPLACE FUNCTION on_signin() RETURNS trigger LANGUAGE plpgsql SECURITY definer
SET search_path = '' AS $$ BEGIN
INSERT INTO "public"."players"(id, name)
VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'name', 'anonymous')
    );
RETURN NEW;
END;
$$;
--
REVOKE EXECUTE ON FUNCTION "public"."on_signin" FROM "public";
REVOKE EXECUTE ON FUNCTION "public"."on_signin"
FROM "anon";
REVOKE EXECUTE ON FUNCTION "public"."on_signin"
FROM "authenticated";
--
--
-- TRIGGER
DROP TRIGGER IF EXISTS on_signin_trigger ON "auth"."users";
--
CREATE TRIGGER on_signin_trigger
AFTER
INSERT ON "auth"."users" FOR EACH ROW EXECUTE FUNCTION on_signin();