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