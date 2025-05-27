-- Function to Insert a New Artist
CREATE OR REPLACE FUNCTION insert_new_artist(
    artist_name VARCHAR,
    artist_genre VARCHAR,
    artist_contact VARCHAR,
    artist_bio TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO public."Artist" ("Name", "Genre", "ContactInfo", "Bio")
    VALUES (artist_name, artist_genre, artist_contact, artist_bio);
END;
$$ LANGUAGE plpgsql;

SELECT insert_new_artist('Jane Smith', 'Jazz', 'jane@example.com', 'Jazz musician with a soulful voice.');


