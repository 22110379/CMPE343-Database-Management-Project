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