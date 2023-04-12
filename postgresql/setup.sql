/* Create the tables */

CREATE SCHEMA airbnb;
CREATE TABLE airbnb.users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'administrator'))
);

CREATE TABLE airbnb.listings (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  street_address VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  zipcode VARCHAR(20) NOT NULL,
  user_id INTEGER NOT NULL REFERENCES users(id),
  price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE airbnb.bookings (
  id SERIAL PRIMARY KEY,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  listing_id INTEGER NOT NULL REFERENCES listings(id),
  booked_by INTEGER NOT NULL REFERENCES users(id),
  UNIQUE (listing_id, start_date, end_date)
);

CREATE TABLE airbnb.guests (
  id SERIAL PRIMARY KEY,
  booking_id INTEGER NOT NULL REFERENCES bookings(id),
  guest_name VARCHAR(100) NOT NULL,
  guest_email VARCHAR(100) NOT NULL
);

/* Only administrator can create listings */
CREATE FUNCTION is_administrator(user_id INTEGER) RETURNS BOOLEAN AS $$
  SELECT EXISTS (SELECT 1 FROM users WHERE id = user_id AND role = 'administrator')
$$ LANGUAGE SQL;

ALTER TABLE listings ADD CONSTRAINT chk_admin_listing CHECK (
  is_administrator(user_id) = true
);