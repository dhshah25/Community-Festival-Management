-- Insert Queries
INSERT INTO public."Artist" ("ArtistID", "Name", "Genre", "ContactInfo", "Bio") 
VALUES (3001, 'John Doe', 'Rock', 'johndoe@example.com', 'An experienced rock artist.');

SELECT * FROM public."Artist" ORDER BY "ArtistID" DESC; 
