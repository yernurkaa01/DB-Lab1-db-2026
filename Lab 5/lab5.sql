                   ----------------------------------------------
                        ---- PART 1: CHECK Constraints -----
                   ----------------------------------------------
              ------ Task 1.1: Basic CHECK Constrain ------

CREATE TABLE  employees(
     employee_id integer,
     first_name text,
     last_name text,
     age integer check (age between 18 and 65),
     salary numeric check(salary > 0)
);

              ----- Task 1.2: Named CHECK Constraint -----

CREATE TABLE products_catalog(
    product_id integer,
    product_name text,
    regular_price numeric,
    discount_price numeric,

constraint valid_discount check(
    regular_price > 0
    and discount_price > 0
    and discount_price < regular_price
    )
);
             ----- Task 1.3: Multiple Column CHECK -----

CREATE TABLE bookings(
    booking_id integer,
    check_in_date date,
    check_out_date date,
    num_guests integer check (num_guests between 1 and 10),
    check ( check_out_date > check_in_date  )

);

             ----- Task 1.4: Testing CHECK Constraint -----
     ---- 1 -----

INSERT into employees (employee_id,first_name,last_name,age,salary) values
   (1, 'Yernur', 'Abdimalik', 18, 550000),
   (2,'Nurzhan', 'Oteuli', 35, 600000),
   (3, 'Alizhan', 'Saduakas', 47, 760000);

INSERT INTO products_catalog (product_id ,product_name,regular_price,discount_price) values
   (1, 'laptop', 550000, 500000),
   (2,'watch apple', 250000, 200000),
   (3,'mobile phone', 650000, 500000);

INSERT INTO bookings (booking_id,check_in_date,check_out_date,num_guests) values
    (1, '2026-10-14', '2026-11-14', 5),
    (2,'2026-10-12', '2026-11-12', 6),
    (3,'2026-10-10', '2026-11-10', 2);

   ----- 2 -----

INSERT into employees (employee_id,first_name,last_name,age,salary) values
   (4, 'Malik', 'Abdi', 16, 550000);
-- violates employees_age_check: age 16 is less than 18

INSERT INTO products_catalog (product_id ,product_name,regular_price,discount_price) values
   (4, 'laptop', 550000, 600000);
-- violates valid_discount: discount_price 600000 is greater than regular_price 550000

INSERT INTO bookings (booking_id,check_in_date,check_out_date,num_guests) values
    (4, '2026-10-14', '2026-10-14', 5);
-- violates bookings_check: check_out_date is the same as check_in_date, must be after it

INSERT into employees (employee_id,first_name,last_name,age,salary) values
   (5, 'Malik', 'Abdi', 19, -550000);
-- violates employees_salary_check: salary -550000 is not greater than 0

INSERT INTO bookings (booking_id,check_in_date,check_out_date,num_guests) values
    (5, '2026-10-14', '2026-10-15', 15);
-- violates bookings_num_guests_check: 15 guests is more than the maximum of 10


                        ------------------------------------------------
                            ----- PART 2: NOT NULL Constraint -----
                            ------------------------------------------------
                       ----- Task 2.1: NOT NULL Implementation -----

CREATE TABLE customers(
    customer_id integer NOT NULL,
    email text NOT NULL,
    phone text  NULL,
    registration_date date NOT NULL
);

                       ----- Task 2.2: Combining Constraints -----

CREATE TABLE inventory(
    item_id integer NOT NULL,
    item_name text NOT NULL,
    quantity integer NOT NULL CHECK ( quantity>= 0 ),
    unit_price numeric NOT NULL CHECK ( unit_price > 0 ),
    last_updated timestamp NOT NULL
);

                        ----- Task 2.3: Testing NOT NULL -----
               ----- 1 -----

INSERT INTO customers (customer_id,email,phone,registration_date) values
     (1, 'er@gmail.com', '87776665544', '2026-10-12');

INSERT INTO inventory (item_id,item_name,quantity,unit_price,last_updated) values
     (1, 'lamp', 10, 500, '2026-10-14 06:45:00');

               ----- 2 -----

INSERT INTO customers (customer_id,email,phone,registration_date) values
     (2, null, '87776665543', '2026-10-13');
-- violates NOT NULL on email: email cannot be NULL

INSERT INTO inventory (item_id,item_name,quantity,unit_price,last_updated) values
     (2, null, 11, 550, '2026-11-14 08:45:00');
-- violates NOT NULL on item_name: item_name cannot be NULL

               ----- 3 -----

INSERT INTO customers (customer_id,email,phone,registration_date) values
     (3, 'nur@gmail.com', null, '2026-12-12');
-- succeeds: phone is nullable, so NULL is allowed

                            -------------------------------------------------
                            ----- Part 3: UNIQUE Constraints -----
                    ------------------------------------------------------
                        ----- Task 3.1: Single Column UNIQUE -----

CREATE TABLE  users(
    user_id integer,
    username text unique,
    email text unique,
    created_at timestamp
);

                         ----- Task 3.2: Multi-Column UNIQUE -----

CREATE TABLE course_enrollments(
    enrollment_id integer,
    student_id integer,
    course_code text,
    semester text,
    unique (student_id, course_code,semester)
);

                          ----- Task 3.3: Named UNIQUE Constraints -----

-- remove auto-named UNIQUE constraints from Task 3.1
ALTER TABLE users DROP CONSTRAINT users_username_key;
ALTER TABLE users DROP CONSTRAINT users_email_key;

               ----- 1 -----

ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);

               ----- 2 -----

ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

               ----- 3 -----

INSERT INTO users (user_id, username, email, created_at) values
     (1, 'yernur', 'yernur@gmail.com', now()),
     (2, 'nurzhan', 'nurzhan@gmail.com', now());
-- succeeds: all usernames and emails are unique

INSERT INTO users (user_id, username, email, created_at) values
     (3, 'yernur', 'ergg@gmail.com', now());
-- violates unique_username: username 'yernur' already exists

INSERT INTO users (user_id, username, email, created_at) values
     (4, 'alizhan', 'ewgre@gmail.com', now());
-- violates unique_email: email 'nurzhan@gmail.com' already exists


                     ----------------------------------------------------
                          ------ Part 4: PRIMARY KEY Constraints -----
                    ----------------------------------------------------
                    ----- Task 4.1: Single Column Primary Key -----

CREATE TABLE departments(
    dept_id integer PRIMARY KEY,
    dept_name text NOT NULL,
    location text
);

INSERT INTO departments (dept_id, dept_name, location) values
     (1, 'IT', 'Almaty'),
     (2, 'Sales', 'Astana'),
     (3, 'HR', 'Almaty');
-- succeeds: all dept_id values are unique and not NULL

               ----- 1 -----
INSERT INTO departments (dept_id, dept_name, location) values
     (1, 'Marketing', 'Shymkent');
-- violates departments_pkey: dept_id 1 already exists

               ----- 2 -----
INSERT INTO departments (dept_id, dept_name, location) values
     (NULL, 'Finance', 'Astana');
-- violates NOT NULL on dept_id: a PRIMARY KEY column cannot be NULL


                        ----- Task 4.2: Composite Primary Key -----

CREATE TABLE student_courses(
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses (student_id, course_id, enrollment_date, grade) values
     (1, 101, '2026-09-01', 'A'),
     (1, 102, '2026-09-01', 'B'),
     (2, 101, '2026-09-02', 'A');
-- succeeds: every (student_id, course_id) pair is unique

INSERT INTO student_courses (student_id, course_id, enrollment_date, grade) values
     (1, 101, '2026-09-05', 'C');
-- violates student_courses_pkey: pair (1, 101) already exists


                        ----- Task 4.3: Comparison Exercise -----

-- 1. Difference between UNIQUE and PRIMARY KEY
--    PRIMARY KEY = UNIQUE + NOT NULL. It identifies each row of the table.
--    UNIQUE only forbids duplicate values; NULL is allowed, and several rows
--    can have NULL in a UNIQUE column, because NULL is not equal to NULL.
--    FOREIGN KEYs in other tables usually reference the PRIMARY KEY.
--
-- 2. Single-column vs composite PRIMARY KEY
--    Single-column: when one column identifies a row on its own,
--    e.g. dept_id in departments, emp_id in employees.
--    Composite: when only a combination of columns is unique,
--    e.g. (student_id, course_id) in student_courses: a student takes many
--    courses and a course has many students, but each pair appears once.
--    Typical for linking tables in many-to-many relationships.
--
-- 3. Why only one PRIMARY KEY but many UNIQUE constraints
--    The PRIMARY KEY is THE main identifier of a row, and a table can have only
--    one main identifier; other tables reference it through FOREIGN KEYs.
--    UNIQUE just marks additional columns that must not repeat
--    (email, username, isbn), and a table can have as many of those as needed.


                  -------------------------------------------------------
                        ----- PART 5: FOREIGN KEY Constraints -----
             -----------------------------------------------------
                        ----- Task 5.1: Basic Foreign Key -----

CREATE TABLE employees_dept(
    emp_id integer PRIMARY KEY,
    emp_name text NOT NULL,
    dept_id integer REFERENCES departments,
    hire_date date
);

               ----- 1 -----
INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date) values
     (1, 'Yernur', 1, '2026-01-15'),
     (2, 'Nurzhan', 2, '2026-03-10'),
     (3, 'Alizhan', 3, '2026-05-20');
-- succeeds: dept_id 1, 2 and 3 exist in departments

               ----- 2 -----
INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date) values
     (4, 'Dana', 99, '2026-06-01');
-- violates employees_dept_dept_id_fkey: dept_id 99 does not exist in departments


                        ----- Task 5.2: Multiple Foreign Keys -----

CREATE TABLE authors(
    author_id integer PRIMARY KEY,
    author_name text NOT NULL,
    country text
);

CREATE TABLE publishers(
    publisher_id integer PRIMARY KEY,
    publisher_name text NOT NULL,
    city text
);

CREATE TABLE books(
    book_id integer PRIMARY KEY,
    title text NOT NULL,
    author_id integer REFERENCES authors,
    publisher_id integer REFERENCES publishers,
    publication_year integer,
    isbn text UNIQUE
);

INSERT INTO authors (author_id, author_name, country) values
     (1, 'Abai Kunanbayev', 'Kazakhstan'),
     (2, 'Mukhtar Auezov', 'Kazakhstan'),
     (3, 'Leo Tolstoy', 'Russia');

INSERT INTO publishers (publisher_id, publisher_name, city) values
     (1, 'Atamura', 'Almaty'),
     (2, 'Foliant', 'Astana'),
     (3, 'Eksmo', 'Moscow');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn) values
     (1, 'Book of Words', 1, 1, 2015, '978-601-00-0001-1'),
     (2, 'The Path of Abai', 2, 2, 2018, '978-601-00-0002-2'),
     (3, 'War and Peace', 3, 3, 2020, '978-5-04-000003-3'),
     (4, 'Anna Karenina', 3, 3, 2021, '978-5-04-000004-4');
-- succeeds: every author_id and publisher_id exists, all isbn values are unique


                        ----- Task 5.3: ON DELETE Options -----

CREATE TABLE categories(
    category_id integer PRIMARY KEY,
    category_name text NOT NULL
);

CREATE TABLE products_fk(
    product_id integer PRIMARY KEY,
    product_name text NOT NULL,
    category_id integer REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders(
    order_id integer PRIMARY KEY,
    order_date date NOT NULL
);

CREATE TABLE order_items(
    item_id integer PRIMARY KEY,
    order_id integer REFERENCES orders ON DELETE CASCADE,
    product_id integer REFERENCES products_fk,
    quantity integer CHECK (quantity > 0)
);

INSERT INTO categories (category_id, category_name) values
     (1, 'Electronics'),
     (2, 'Books'),
     (3, 'Toys');

INSERT INTO products_fk (product_id, product_name, category_id) values
     (1, 'Laptop', 1),
     (2, 'Phone', 1),
     (3, 'Novel', 2);

INSERT INTO orders (order_id, order_date) values
     (1, '2026-10-01'),
     (2, '2026-10-05');

INSERT INTO order_items (item_id, order_id, product_id, quantity) values
     (1, 1, 1, 1),
     (2, 1, 2, 2),
     (3, 2, 3, 1);

               ----- 1 -----
DELETE FROM categories WHERE category_id = 1;
-- fails: products_fk_category_id_fkey (ON DELETE RESTRICT)
-- category 1 is still used by products 1 and 2, so it cannot be deleted

DELETE FROM categories WHERE category_id = 3;
-- succeeds: no product references category 3, RESTRICT does not block it

               ----- 2 -----
SELECT * FROM order_items WHERE order_id = 1;
-- before: 2 rows (item 1 and item 2)

DELETE FROM orders WHERE order_id = 1;
-- succeeds: ON DELETE CASCADE

SELECT * FROM order_items WHERE order_id = 1;
-- after: 0 rows, items 1 and 2 were deleted automatically together with order 1

               ----- 3 -----
-- RESTRICT: the parent row (category) cannot be deleted while child rows
--           (products) reference it; PostgreSQL returns an error and nothing changes.
-- CASCADE:  deleting the parent row (order) also deletes all child rows
--           (order_items) that reference it.


                   ---------------------------------------------------
                        ----- PART 6: Practical Application -----
                     -------------------------------------------------------
                        ----- Task 6.1: E-commerce Database Design -----

-- tables are prefixed with ec_ because of what customers (Task 2.1) and orders (Task 5.3)
-- this columns was already exist in this database

               ----- 1. CREATE TABLE -----

CREATE TABLE ec_customers(
    customer_id integer PRIMARY KEY,
    name text NOT NULL,
    email text NOT NULL UNIQUE,
    phone text,
    registration_date date NOT NULL
);

CREATE TABLE ec_products(
    product_id integer PRIMARY KEY,
    name text NOT NULL,
    description text,
    price numeric NOT NULL CHECK (price >= 0),
    stock_quantity integer NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE ec_orders(
    order_id integer PRIMARY KEY,
    customer_id integer NOT NULL REFERENCES ec_customers ON DELETE RESTRICT,
    order_date date NOT NULL,
    total_amount numeric NOT NULL CHECK (total_amount >= 0),
    status text NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE ec_order_details(
    order_detail_id integer PRIMARY KEY,
    order_id integer NOT NULL REFERENCES ec_orders ON DELETE CASCADE,
    product_id integer NOT NULL REFERENCES ec_products ON DELETE RESTRICT,
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric NOT NULL CHECK (unit_price >= 0)
);

-- ON DELETE choices:
-- ec_orders.customer_id   RESTRICT: a customer with orders cannot be deleted (order history is kept)
-- ec_order_details.order_id CASCADE: order details have no meaning without their order
-- ec_order_details.product_id RESTRICT: a product that was already sold cannot be deleted

               ----- 2. Sample data -----

INSERT INTO ec_customers (customer_id, name, email, phone, registration_date) values
     (1, 'Yernur Abdimalik', 'yernur@gmail.com', '87776665544', '2026-01-10'),
     (2, 'Nurzhan Oteuli', 'nurzhan@gmail.com', '87012223344', '2026-02-15'),
     (3, 'Alizhan Saduakas', 'alizhan@gmail.com', NULL, '2026-03-20'),
     (4, 'Dana Serikova', 'dana@gmail.com', '87475556677', '2026-04-05'),
     (5, 'Arman Bekov', 'arman@gmail.com', '87081112233', '2026-05-12');

INSERT INTO ec_products (product_id, name, description, price, stock_quantity) values
     (1, 'Laptop', '15.6 inch, 16GB RAM', 450000, 10),
     (2, 'Mouse', 'Wireless mouse', 8000, 50),
     (3, 'Keyboard', 'Mechanical keyboard', 15000, 30),
     (4, 'Monitor', '27 inch IPS', 120000, 15),
     (5, 'Headphones', 'Bluetooth headphones', 25000, 20);

INSERT INTO ec_orders (order_id, customer_id, order_date, total_amount, status) values
     (1, 1, '2026-10-01', 466000, 'delivered'),
     (2, 2, '2026-10-03', 120000, 'shipped'),
     (3, 3, '2026-10-05', 30000, 'processing'),
     (4, 1, '2026-10-10', 25000, 'pending'),
     (5, 4, '2026-10-12', 50000, 'cancelled');

INSERT INTO ec_order_details (order_detail_id, order_id, product_id, quantity, unit_price) values
     (1, 1, 1, 1, 450000),
     (2, 1, 2, 2, 8000),
     (3, 2, 4, 1, 120000),
     (4, 3, 3, 2, 15000),
     (5, 4, 5, 1, 25000),
     (6, 5, 5, 2, 25000);
-- total_amount of each order = sum of quantity * unit_price of its details

               ----- 3. Test queries -----

-- PRIMARY KEY
INSERT INTO ec_customers (customer_id, name, email, phone, registration_date) values
     (1, 'Test User', 'test@gmail.com', NULL, '2026-10-14');
-- violates ec_customers_pkey: customer_id 1 already exists

-- UNIQUE email
INSERT INTO ec_customers (customer_id, name, email, phone, registration_date) values
     (6, 'Test User', 'yernur@gmail.com', NULL, '2026-10-14');
-- violates ec_customers_email_key: email 'yernur@gmail.com' already exists

-- NOT NULL
INSERT INTO ec_customers (customer_id, name, email, phone, registration_date) values
     (6, NULL, 'test@gmail.com', NULL, '2026-10-14');
-- violates NOT NULL on name: name cannot be NULL

-- CHECK price >= 0
INSERT INTO ec_products (product_id, name, description, price, stock_quantity) values
     (6, 'Cable', 'USB-C cable', -500, 10);
-- violates ec_products_price_check: price -500 is negative

-- CHECK stock_quantity >= 0
INSERT INTO ec_products (product_id, name, description, price, stock_quantity) values
     (6, 'Cable', 'USB-C cable', 500, -1);
-- violates ec_products_stock_quantity_check: stock_quantity -1 is negative

-- CHECK status
INSERT INTO ec_orders (order_id, customer_id, order_date, total_amount, status) values
     (6, 2, '2026-10-14', 8000, 'returned');
-- violates ec_orders_status_check: 'returned' is not in the allowed list

-- CHECK quantity > 0
INSERT INTO ec_order_details (order_detail_id, order_id, product_id, quantity, unit_price) values
     (7, 2, 2, 0, 8000);
-- violates ec_order_details_quantity_check: quantity 0 is not positive

-- FOREIGN KEY customer
INSERT INTO ec_orders (order_id, customer_id, order_date, total_amount, status) values
     (6, 99, '2026-10-14', 8000, 'pending');
-- violates ec_orders_customer_id_fkey: customer 99 does not exist

-- FOREIGN KEY product
INSERT INTO ec_order_details (order_detail_id, order_id, product_id, quantity, unit_price) values
     (7, 2, 99, 1, 8000);
-- violates ec_order_details_product_id_fkey: product 99 does not exist

-- ON DELETE RESTRICT (customer)
DELETE FROM ec_customers WHERE customer_id = 1;
-- fails: ec_orders_customer_id_fkey, customer 1 has orders 1 and 4

-- ON DELETE RESTRICT (product)
DELETE FROM ec_products WHERE product_id = 1;
-- fails: ec_order_details_product_id_fkey, product 1 is used in order details

-- ON DELETE CASCADE (order)
DELETE FROM ec_orders WHERE order_id = 5;
-- succeeds

SELECT * FROM ec_order_details WHERE order_id = 5;
-- 0 rows: detail 6 was deleted automatically together with order 5

