CREATE TABLE Categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Publishers (
  publisher_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Authors (
  author_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL
);

CREATE TABLE Members (
  member_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  status VARCHAR(15) DEFAULT 'ACTIVE'
);

CREATE TABLE Books (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  category_id INT REFERENCES Categories(category_id),
  publisher_id INT REFERENCES Publishers(publisher_id),
  author_id INT REFERENCES Authors(author_id),
  total_copies INT DEFAULT 1,
  available_copies INT DEFAULT 1
);

CREATE TABLE Loans (
  loan_id SERIAL PRIMARY KEY,
  member_id INT REFERENCES Members(member_id),
  book_id INT REFERENCES Books(book_id),
  loan_date DATE DEFAULT CURRENT_DATE,
  due_date DATE,
  status VARCHAR(15) DEFAULT 'ONGOING'
);