BEGIN;

-- Insert 100 records with the same VolunteerID
DO $$
DECLARE 
    i INT;
BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO public."Volunteer" ("VolunteerID", "Name", "ContactInfo", "Availability", "Role")
        VALUES (1, 'Johnny Doe', 'johnny.doe@example.com', 'Available', 'Stage Manager');
    END LOOP;
END $$;

COMMIT;
