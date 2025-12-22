-- 1) Select the title, print number and the print year of every *kind* of book that was printed before 2022
SELECT * 
FROM "bookInfo" WHERE "year" < 2022;


-- 2) The count of how many of each book the library has:
SELECT "title", count("bookID") AS count
FROM "inventory" 
INNER JOIN "bookInfo" ON "inventory"."bookID" = "bookInfo"."id"
GROUP BY "title";


-- 3) List of every book that the library has more than one of.
SELECT "title", count("bookID") AS count
FROM "inventory" 
INNER JOIN "bookInfo" ON "inventory"."bookID" = "bookInfo"."id"
GROUP BY "title"
HAVING COUNT("bookID") > 1;


-- 4) List of every member and how many books they have borrowed.
SELECT
  member.id AS member_id,
  name,
  surname,
  COUNT(borrow.id) AS borrow_count
FROM "member"
LEFT JOIN "borrow" ON borrow."memberID" = member.id
GROUP BY member.id, name, surname
ORDER BY borrow_count DESC;


-- 5) Likewise, list of every member that hasnt borrowed a single book, shame.
SELECT member.id, member.name, member.surname
FROM "member"
LEFT JOIN "borrow" ON "memberID" = member.id
WHERE borrow.id IS NULL;


-- 6) This lists all the the times where a book has been borrowed and how long it has been borrowed for.
  b.id AS borrow_id,
  m.id AS member_id,
  m.name,
  m.surname,
  bi.id           AS book_id,
  bi.title,
  t.date             AS take_date,
  r.date             AS return_date,
  (r.date - t.date)  AS duration
FROM "borrow" b
LEFT JOIN "member" m     ON b."memberID" = m.id
LEFT JOIN "excTake" t    ON b."takeID"   = t.id
LEFT JOIN "excReturn" r  ON b."returnID" = r.id
LEFT JOIN "inventory" i  ON b."invID"    = i.id
LEFT JOIN "bookInfo" bi  ON i."bookID"   = bi.id
ORDER BY (r.date - t.date) DESC;

-- 7) Lists all the times a book has been borrowed and returned after more than 2 weeks
SELECT
  b.id AS borrow_id,
  m.id AS member_id,
  m.name,
  m.surname,
  bi.id           AS book_id,
  bi.title,
  t.date             AS take_date,
  r.date             AS return_date,
  (r.date - t.date)  AS duration
FROM "borrow" b
LEFT JOIN "member" m     ON b."memberID" = m.id
LEFT JOIN "excTake" t    ON b."takeID"   = t.id
LEFT JOIN "excReturn" r  ON b."returnID" = r.id
LEFT JOIN "inventory" i  ON b."invID"    = i.id
LEFT JOIN "bookInfo" bi  ON i."bookID"   = bi.id
WHERE r.date IS NOT NULL
  AND t.date IS NOT NULL
  AND r.date > t.date + INTERVAL '14 days'
ORDER BY (r.date - t.date) DESC;

-- 8) Lists each book and how many times it has been borrowed by somebody.
SELECT
bi.id AS book_id,
bi.title,
COUNT(b.id) AS borrow_count
FROM "bookInfo" bi
LEFT JOIN "inventory" i ON i."bookID" = bi.id
LEFT JOIN "borrow" b ON b."invID" = i.id
GROUP BY bi.id, bi.title
ORDER BY borrow_count DESC;

-- 9) Average print year
SELECT AVG(year) AS avg_print_year
FROM "bookInfo"
WHERE year IS NOT NULL;

--10) Average print year per genre
SELECT g.name AS genre_name,
AVG(b.year) AS avg_print_year
FROM "bookInfo" b
JOIN genres g ON b.genres = g.id
WHERE b.year IS NOT null
GROUP BY g.id, g.name;

--11) Average times a book has been borrowed
SELECT 
AVG(borrow_count) AS avg_borrow_per_book
FROM(
  SELECT COUNT(br.id) AS borrow_count
  FROM "inventory" i
  LEFT JOIN "borrow" br ON br."invID" = i.id
  GROUP BY i.id
);

--12)Average days books has been borrowed
SELECT bi.title,
AVG(
  (r.date - t.date)
) AS avg_borrow_days
FROM "borrow" b
JOIN "excTake" t ON b."takeID" = t.id
JOIN "excReturn" r ON b."returnID" = r.id
JOIN "inventory" i ON b."invID" = i.id
JOIN "bookInfo" bi ON i."bookID" = bi.id
GROUP BY bi.id, bi.title;

--13)How many days, on average, did each members borrow a book?
SELECT 
m.id,
m.name,
m.surname,
AVG((r.date-t.date))AS avg_borrow_days
FROM "member" m 
JOIN "borrow" b ON b."memberID" = m.id
JOIN "excTake" t ON b."takeID" = t.id
JOIN "excReturn" r ON b."returnID" = r.id
GROUP BY m.id, m.name, m.surname;

--14)The average retention period for returned books.
SELECT 
AVG((r.date-t.date)) AS avg_borrow_days
FROM "borrow" b
JOIN "excTake" t ON b."takeID" = t.id
JOIN "excReturn" r ON b."returnID"= r.id;

--15)Average late return time for members who have returned at least one book.
SELECT
m.id,
m.name,
m.surname,
AVG((r.date-t.date)) AS avg_return_delay_days
FROM "member" m
JOIN "borrow" b ON b."memberID" = m.id
JOIN "excTake" t ON b."takeID" = t.id
JOIN "excReturn" r ON b."returnID" = r.id
GROUP BY m.id, m.name, m.surname
HAVING COUNT(b.id) >= 1
ORDER BY avg_return_delay_days DESC;