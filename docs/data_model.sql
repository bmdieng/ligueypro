-- Schéma conceptuel MVP PostgreSQL

CREATE TABLE users (
  id UUID PRIMARY KEY,
  phone VARCHAR(30) UNIQUE NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  role VARCHAR(30) NOT NULL DEFAULT 'CUSTOMER',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE service_categories (
  id UUID PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  icon VARCHAR(80)
);

CREATE TABLE professional_profiles (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  bio TEXT,
  years_experience INT DEFAULT 0,
  rating NUMERIC(3,2) DEFAULT 0,
  verified BOOLEAN DEFAULT FALSE,
  latitude NUMERIC(10,7),
  longitude NUMERIC(10,7),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE service_requests (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES users(id),
  professional_id UUID REFERENCES professional_profiles(id),
  category_id UUID REFERENCES service_categories(id),
  description TEXT NOT NULL,
  latitude NUMERIC(10,7),
  longitude NUMERIC(10,7),
  scheduled_at TIMESTAMPTZ,
  status VARCHAR(30) NOT NULL DEFAULT 'CREATED',
  estimated_amount BIGINT,
  final_amount BIGINT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE reviews (
  id UUID PRIMARY KEY,
  request_id UUID NOT NULL REFERENCES service_requests(id),
  customer_id UUID NOT NULL REFERENCES users(id),
  professional_id UUID NOT NULL REFERENCES professional_profiles(id),
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
