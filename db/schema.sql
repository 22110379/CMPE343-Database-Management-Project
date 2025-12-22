-- This table stores the information about the books (Not to be confused with the inventory of the library)

CREATE TABLE IF NOT EXISTS "genres" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL UNIQUE

);

CREATE TABLE IF NOT EXISTS "bookInfo" (
    "id" SERIAL,
    "title" TEXT NOT NULL,
    "author" TEXT NOT NULL,
    "print" INTEGER, -- Print number
    "year" INTEGER,  -- Which year it was printed in
    "language" TEXT NOT NULL,
    "genres" INTEGER, 
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("genres") REFERENCES "genres"("id")

);

-- This table stores information about each book in the library's inventory.
CREATE TABLE IF NOT EXISTS "inventory" (
    "id" SERIAL,
    "bookID" INTEGER,
    "acquireDate" DATE DEFAULT CURRENT_DATE, --When it was first brought to the library
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("bookID") REFERENCES "bookInfo"("id")
);

-- This table is for storing information on a library member
CREATE TABLE IF NOT EXISTS "member" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "surname" TEXT,
    
    PRIMARY KEY ("id")
);

-- Record of book exchange - Taking (borrowing) from the library
CREATE TABLE IF NOT EXISTS "excTake" (
    "id" SERIAL NOT NULL,
    "memberID" INTEGER,
    "invID" INTEGER,
    "date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("invID") REFERENCES "inventory"("id"),
    FOREIGN KEY ("memberID") REFERENCES "member"("id")
);
-- Record of book exchange - Returning to the library
CREATE TABLE IF NOT EXISTS "excReturn" (
    "id" SERIAL NOT NULL,
    "memberID" INTEGER NOT NULL,
    "invID" INTEGER NOT NULL,
    "date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("invID") REFERENCES "inventory"("id"),
    FOREIGN KEY ("memberID") REFERENCES "member"("id")
);

-- Each book borrowing process initialised by a member. Links to taking and (hopefully) the returning tables
CREATE TABLE IF NOT EXISTS "borrow" (
    "id" SERIAL NOT NULL,
    "invID" INTEGER,
    "memberID" INTEGER, -- id of the member who *initially borrowed* the book. (It may also be returned by another member).
    "takeID" INTEGER,   -- I know it is kinda redundant
    "returnID" INTEGER,

    PRIMARY KEY ("id"),
    FOREIGN KEY ("invID") REFERENCES "inventory"("id"),
    FOREIGN KEY ("memberID") REFERENCES "member"("id"),
    FOREIGN KEY ("takeID") REFERENCES "excTake"("id"),
    FOREIGN KEY ("returnID") REFERENCES "excReturn"("id")
);