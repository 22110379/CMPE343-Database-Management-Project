-- This table stores the information about the books (Not to be confused with the inventory of the library)
CREATE TABLE IF NOT EXISTS "bookInfo" (
    "id" INTEGER,
    "title" TEXT,
    "author" TEXT,
    "print" INTEGER, -- Print number
    "year" INTEGER,  -- Which year it was printed in
    "language" TEXT,
    "genres" INTEGER, 
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("genres") REFERENCES "genres"("id")

);

CREATE TABLE IF NOT EXISTS "genres" (

    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE, 

    PRIMARY KEY ("id")
);

-- This table stores information about the books in the library's inventory. 
CREATE TABLE IF NOT EXISTS "inventory" (
    "id" INTEGER,
    "bookID" INTEGER,
    "acquireDate" DATETIME DEFAULT CURRENT_TIMESTAMP, --When it was first brought to the library
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("bookID") REFERENCES "bookInfo"("id")
);

-- This table is for storing information on a library member
CREATE TABLE IF NOT EXISTS "member" (
    "id" INTEGER,
    "name" TEXT,
    "surname" TEXT,
    
    PRIMARY KEY ("id")
);

-- Record of book exchange - Taking (borrowing) from the library
CREATE TABLE IF NOT EXISTS "excTake" (
    "id" INTEGER,
    "memberID" INTEGER,
    "invID" INTEGER,
    "date" DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("invID") REFERENCES "inventory"("id"),
    FOREIGN KEY ("memberID") REFERENCES "member"("id")
);
-- Record of book exchange - Returning to the library
CREATE TABLE IF NOT EXISTS "excReturn" (
    "id" INTEGER,
    "memberID" INTEGER,
    "invID" INTEGER,
    "date" DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY ("id"),
    FOREIGN KEY ("invID") REFERENCES "inventory"("id"),
    FOREIGN KEY ("memberID") REFERENCES "member"("id")
);

-- Each book borrowing process initialised by a member. Links to taking and (hopefully) the returning tables
CREATE TABLE IF NOT EXISTS "borrow" (
    "id" INTEGER,
    "invID" INTEGER,
    "memberID" INTEGER, -- id of the member who *initially borrowed* the book. (It may also be returned by another member).
    "takeID" INTEGER,   -- I know it is kinda redundant
    "returnID" INTEGER,

    PRIMARY KEY ("id", "takeID", "returnID")
    FOREIGN KEY ("invID") REFERENCES "inventory"("id"),
    FOREIGN KEY ("memberID") REFERENCES "member"("id"),
    FOREIGN KEY ("takeID") REFERENCES "excTake"("id"),
    FOREIGN KEY ("returnID") REFERENCES "excReturn"("id")
);