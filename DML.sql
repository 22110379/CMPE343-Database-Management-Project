INSERT INTO Categories (name) VALUES
('Computer Science'),
('History'),
('Novel');

INSERT INTO Publishers (name) VALUES
('TechPress'),
('Global Books House');

INSERT INTO Authors (full_name) VALUES
('Ahmed Al-Balushi'),
('Sarah Johnson');

INSERT INTO Members (full_name, status) VALUES
('Maria Ali', 'ACTIVE'),
('Salma Al-Harthy', 'ACTIVE'),
('Ali Al-Said', 'SUSPENDED');

INSERT INTO Books (title, category_id, publisher_id, author_id, total_copies, available_copies) VALUES
('Intro to CS', 1, 1, 1, 5, 3),
('Advanced C++', 1, 1, 2, 4, 1),
('Modern History', 2, 2, 2, 3, 2);

INSERT INTO Loans (member_id, book_id, due_date) VALUES
(1, 1, CURRENT_DATE + INTERVAL '10 days');

UPDATE Members
SET status = 'ACTIVE'
WHERE full_name = 'Ali Al-Said';

DELETE FROM Books
WHERE title = 'Modern History'
AND book_id NOT IN (SELECT book_id FROM Loans);