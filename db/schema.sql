-- This table stores the information about the books (Not to be confused with the inventory of the library)
CREATE TABLE IF NOT EXISTS "bookInfo" (
    "id" INTEGER,
    "title" TEXT,
    "author" TEXT,
    "print" INTEGER, -- Print number
    "year" INTEGER,  -- Which year it was printed in
    "language" TEXT
);

-- This table stores information about the books in the library's inventory. 
CREATE TABLE IF NOT EXISTS "inventory" (
    "id" INTEGER,
    "bookID" INTEGER,
    "acquirDate", --When it was first brought to the library
)

-- This table is for storing information on a library member
CREATE TABLE IF NOT EXISTS "member" (
    "id" INTEGER,
    "name" TEXT,
    "surname" TEXT
)

-- Record of book exchange - Taking (borrowing) from the library
CREATE TABLE IF NOT EXISTS "exchBorrow" (
    "id" INTEGER,
    "name" TEXT,
    "surname" TEXT
)
-- Record of book exchange - Returning to the library


-- Each book borrowng process initialised by a member. Links to taking and (hopefully) the returning tables