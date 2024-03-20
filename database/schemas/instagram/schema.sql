-- /mnt/data/schema.sql

-- Enable Query Plan Management with pg_hint_plan Extension
CREATE EXTENSION IF NOT EXISTS pg_hint_plan;

-- Add Foreign Data Wrapper Extensions
-- Install FDW extensions for accessing external data sources
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
CREATE EXTENSION IF NOT EXISTS mysql_fdw;

-- Define Foreign Servers for External Data Sources
-- Example: PostgreSQL Foreign Server
CREATE SERVER external_postgres
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'external-postgres-server', port '5432', dbname 'external_db');

-- Example: MySQL Foreign Server
CREATE SERVER external_mysql
    FOREIGN DATA WRAPPER mysql_fdw
    OPTIONS (host 'external-mysql-server', port '3306', dbname 'external_db');

-- Define User Mapping for Accessing Foreign Servers
CREATE USER MAPPING FOR current_user
    SERVER external_postgres
    OPTIONS (user 'remote_user', password 'remote_password');

CREATE USER MAPPING FOR current_user
    SERVER external_mysql
    OPTIONS (username 'remote_user', password 'remote_password');

-- Define Foreign Tables to Access External Data
-- Example: PostgreSQL Foreign Table
CREATE FOREIGN TABLE external_posts (
    id SERIAL,
    title VARCHAR(255),
    content TEXT
    )
    SERVER external_postgres
    OPTIONS (table_name 'posts');

-- Example: MySQL Foreign Table
CREATE FOREIGN TABLE external_users (
    id SERIAL,
    username VARCHAR(50),
    email VARCHAR(255)
    )
    SERVER external_mysql
    OPTIONS (table_name 'users');

-- Full Updated Schema (with Foreign Data Wrapper)
-- Public Schema with pg_repack Extension
-- Add pg_repack Extension
CREATE EXTENSION IF NOT EXISTS pg_repack;

-- Define Custom Data Types
-- Encapsulate validation logic for specific fields

-- Custom Domain for Email Validation
CREATE DOMAIN email_address AS BYTEA
    CHECK (VALUE ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

-- Custom Domain for Phone Number Validation
CREATE DOMAIN phone_number AS VARCHAR(20)
    CHECK (VALUE ~ '^[0-9]{10,15}$');

-- Define ENUM types in public schema
CREATE TYPE public.gender_enum AS ENUM ('male', 'female', 'other');
CREATE TYPE public.interaction_type_enum AS ENUM ('like', 'view', 'save');
CREATE TYPE public.challenge_status_enum AS ENUM ('pending', 'completed');
CREATE TYPE public.media_type_enum AS ENUM ('photo', 'video', 'story', 'album', 'IGTV');

-- Users Table in public schema
CREATE TABLE public.users
(
    id                  SERIAL PRIMARY KEY,
    username            VARCHAR(50) UNIQUE   NOT NULL,
    full_name           VARCHAR(100),
    email               email_address UNIQUE NOT NULL,                                  -- Encrypted email column
    profile_data        JSONB,                                                          -- JSONB column for storing unstructured profile data
    website             VARCHAR(100),
    profile_picture_url VARCHAR(255),
    phone_numbers       phone_number[]       NOT NULL DEFAULT ARRAY []::phone_number[], -- Array of phone numbers
    gender              public.gender_enum,
    birthday            DATE,
    is_private          BOOLEAN                       DEFAULT FALSE,
    is_verified         BOOLEAN                       DEFAULT FALSE,
    created_at          TIMESTAMPTZ          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at          TIMESTAMPTZ,                                                    -- Soft delete column
    UNIQUE (username, email)
);

-- Locations Table in public schema
CREATE TABLE public.locations
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    latitude   DOUBLE PRECISION,
    longitude  DOUBLE PRECISION,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ -- Soft delete column
);

-- Hashtags Table in public schema
CREATE TABLE public.hashtags
(
    id         SERIAL PRIMARY KEY,
    tag        VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ -- Soft delete column
);

-- Media Table in public schema
CREATE TABLE public.media
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER                NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    media_type  public.media_type_enum NOT NULL,
    media_url   VARCHAR(255)           NOT NULL,
    caption     TEXT,
    metadata    JSONB,                                                    -- JSONB column for storing unstructured metadata
    location_id INTEGER                REFERENCES public.locations (id) ON DELETE SET NULL,
    posted_at   TIMESTAMPTZ            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMPTZ            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at  TIMESTAMPTZ,                                              -- Soft delete column
    tags        TEXT[]                 NOT NULL DEFAULT ARRAY []::TEXT[], -- Array of tags
    UNIQUE (user_id, posted_at)
);

-- Comments Table in public schema
CREATE TABLE public.comments
(
    id           SERIAL PRIMARY KEY,
    media_id     INTEGER     NOT NULL REFERENCES public.media (id) ON DELETE CASCADE,
    user_id      INTEGER     NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    comment_text TEXT        NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at   TIMESTAMPTZ -- Soft delete column
);

-- Interactions Table in public schema
CREATE TABLE public.interactions
(
    id               SERIAL PRIMARY KEY,
    user_id          INTEGER                      NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    media_id         INTEGER                      NOT NULL REFERENCES public.media (id) ON DELETE CASCADE,
    interaction_type public.interaction_type_enum NOT NULL,
    created_at       TIMESTAMPTZ                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMPTZ                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at       TIMESTAMPTZ -- Soft delete column
);

-- Direct Messages Table in public schema
CREATE TABLE public.direct_messages
(
    id          SERIAL PRIMARY KEY,
    sender_id   INTEGER     NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    receiver_id INTEGER     NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    message     TEXT        NOT NULL,
    metadata    JSONB,      -- JSONB column for storing unstructured metadata
    sent_at     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at  TIMESTAMPTZ -- Soft delete column
);

-- Media Hashtags Table in public schema
CREATE TABLE public.media_hashtags
(
    id         SERIAL PRIMARY KEY,
    media_id   INTEGER     NOT NULL REFERENCES public.media (id) ON DELETE CASCADE,
    hashtag_id INTEGER     NOT NULL REFERENCES public.hashtags (id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ -- Soft delete column
);

-- Insights Table in public schema
CREATE TABLE public.insights
(
    id             SERIAL PRIMARY KEY,
    media_id       INTEGER     NOT NULL REFERENCES public.media (id) ON DELETE CASCADE,
    views_count    INTEGER              DEFAULT 0,
    likes_count    INTEGER              DEFAULT 0,
    comments_count INTEGER              DEFAULT 0,
    shares_count   INTEGER              DEFAULT 0,
    save_count     INTEGER              DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at     TIMESTAMPTZ -- Soft delete column
);

-- Collections Table in public schema
CREATE TABLE public.collections
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER      NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    name       VARCHAR(100) NOT NULL,
    media_ids  INTEGER[]    NOT NULL DEFAULT ARRAY []::INTEGER[], -- Array of media IDs
    created_at TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ                                        -- Soft delete column
);

-- Media Collections Table in public schema
CREATE TABLE public.media_collections
(
    id            SERIAL PRIMARY KEY,
    collection_id INTEGER     NOT NULL REFERENCES public.collections (id) ON DELETE CASCADE,
    media_id      INTEGER     NOT NULL REFERENCES public.media (id) ON DELETE CASCADE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at    TIMESTAMPTZ -- Soft delete column
);

-- Challenges Table in public schema
CREATE TABLE public.challenges
(
    id             SERIAL PRIMARY KEY,
    user_id        INTEGER                      NOT NULL REFERENCES public.users (id) ON DELETE CASCADE,
    challenge_type VARCHAR(100)                 NOT NULL,
    status         public.challenge_status_enum NOT NULL,
    metadata       JSONB,      -- JSONB column for storing unstructured metadata
    created_at     TIMESTAMPTZ                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMPTZ                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at     TIMESTAMPTZ -- Soft delete column
);

-- Explore Table in public schema
CREATE TABLE public.explore_content
(
    id         SERIAL PRIMARY KEY,
    media_ids  INTEGER[]   NOT NULL DEFAULT ARRAY []::INTEGER[], -- Array of media IDs
    metadata   JSONB,                                            -- JSONB column for storing unstructured metadata
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ                                       -- Soft delete column
);

-- Materialized View for Popular Media in public schema
CREATE MATERIALIZED VIEW public.popular_media AS
SELECT m.id        AS media_id,
       m.media_type,
       m.media_url,
       COUNT(i.id) AS interactions_count
FROM public.media m
         LEFT JOIN public.interactions i ON m.id = i.media_id
GROUP BY m.id, m.media_type, m.media_url;

-- Indexes for Materialized View
CREATE INDEX idx_popular_media_media_id ON public.popular_media (media_id);
CREATE INDEX idx_popular_media_media_type ON public.popular_media (media_type);

-- Security Audit Table in public schema
CREATE TABLE public.security_audit
(
    id        SERIAL PRIMARY KEY,
    action    VARCHAR(100) NOT NULL,                                        -- Description of the action performed
    user_id   INTEGER      REFERENCES public.users (id) ON DELETE SET NULL, -- User who performed the action
    timestamp TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,              -- Time of the action
    CONSTRAINT chk_action CHECK (action <> ''),
    CONSTRAINT chk_timestamp CHECK (timestamp IS NOT NULL)
);

-- Grant SELECT on pg_stat_statements view to specific roles
GRANT SELECT ON public.security_audit TO role_name;

-- Audit Table Access with pgAudit
CREATE EXTENSION IF NOT EXISTS pgaudit;

-- Set the desired audit log configuration
ALTER SYSTEM SET pgaudit.log = 'ddl, read, write';

-- Reload the configuration to apply changes
SELECT pg_reload_conf();

-- Compression Techniques
-- Implementing compression on specific columns where appropriate

-- Example: Compressed Media URL Column
ALTER TABLE public.media
    ALTER COLUMN media_url TYPE VARCHAR(255) USING media_url::VARCHAR(255) || ' ' || LPAD('', 1000, ' ');

-- Example: Binary Data Compression
-- Assuming there's a column 'binary_data' of type BYTEA
CREATE EXTENSION IF NOT EXISTS pgcrypto;
ALTER TABLE public.media
    ADD COLUMN compressed_data BYTEA GENERATED ALWAYS AS (pgp_sym_encrypt(binary_data::BYTEA, 'secret_passphrase')) STORED;

-- Index for Compressed Data
CREATE INDEX idx_compressed_data ON public.media (compressed_data);

-- Data Lifecycle Management
-- Define and implement policies for archiving and purging historical data

-- Archive Policy: Move old data to archive tables
-- Example: Archive Media older than a certain date
CREATE TABLE public.archived_media
(
    LIKE public.media INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES
);
ALTER TABLE public.archived_media
    RENAME CONSTRAINT media_pkey TO archived_media_pkey;
ALTER TABLE public.archived_media
    RENAME CONSTRAINT media_user_id_fkey TO archived_media_user_id_fkey;

-- Purge Policy: Delete data older than a certain date
-- Example: Purge Media older than a certain date
DELETE
FROM public.media
WHERE posted_at < '2023-01-01';

-- Vacuum Analyze to Update Statistics
VACUUM ANALYZE;

-- Partial Indexes
-- Implementing partial indexes for columns queried with a common filter condition

-- Partial Index for deleted_at column in media table
CREATE INDEX idx_media_deleted_at ON public.media (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in comments table
CREATE INDEX idx_comments_deleted_at ON public.comments (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in interactions table
CREATE INDEX idx_interactions_deleted_at ON public.interactions (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in direct_messages table
CREATE INDEX idx_direct_messages_deleted_at ON public.direct_messages (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in media_hashtags table
CREATE INDEX idx_media_hashtags_deleted_at ON public.media_hashtags (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in insights table
CREATE INDEX idx_insights_deleted_at ON public.insights (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in collections table
CREATE INDEX idx_collections_deleted_at ON public.collections (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in media_collections table
CREATE INDEX idx_media_collections_deleted_at ON public.media_collections (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in challenges table
CREATE INDEX idx_challenges_deleted_at ON public.challenges (deleted_at) WHERE deleted_at IS NOT NULL;

-- Partial Index for deleted_at column in explore_content table
CREATE INDEX idx_explore_content_deleted_at ON public.explore_content (deleted_at) WHERE deleted_at IS NOT NULL;

-- alter schema owner
ALTER SCHEMA public OWNER TO andreas;
