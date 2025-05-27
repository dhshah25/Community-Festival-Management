-- Insert new Volunteer using Procedure
CREATE OR REPLACE PROCEDURE insert_new_volunteer_and_show(
    volunteer_name VARCHAR,
    contact_info VARCHAR,
    availability VARCHAR DEFAULT 'Available',
    volunteer_role VARCHAR DEFAULT 'General Volunteer'
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert a new volunteer into the Volunteer table
    INSERT INTO public."Volunteer" ("Name", "ContactInfo", "Availability", "Role")
    VALUES (volunteer_name, contact_info, availability, volunteer_role);
    
    RAISE NOTICE 'New volunteer added: %', volunteer_name;
    RAISE NOTICE 'Current volunteers in the table:';
    PERFORM * FROM public."Volunteer";
END;
$$;

CALL insert_new_volunteer_and_show('Alice Johnson', 'alice.johnson@example.com', 'Available', 'Event Coordinator');
