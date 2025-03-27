SET bytea_output = 'hex';             -- Set the blob output as hexadecimal as opposed to an escaped decimal output
SET TIMEZONE = 'America/Chicago';     -- Set the current timezone

DROP TABLE templates;
DROP TABLE mfa;
DROP TABLE bans;
DROP TABLE blog;
DROP TABLE users;

CREATE TABLE IF NOT EXISTS templates (
    tid SERIAL PRIMARY KEY,           -- Auto-incrementing template ID
    gid INT,                          -- Template Group ID for multiple template themes/groups
    updated TIMESTAMPTZ DEFAULT NOW(),  -- The last time this template was modified for cache-reloading
    name TEXT NOT NULL,               -- Template name
    data TEXT NOT NULL                -- The template data
);

CREATE TABLE IF NOT EXISTS users (
    uid SERIAL PRIMARY KEY,           -- Auto-incrementing user ID
    access INT,                       -- The account access value (0 = Banned, 1 = Regular)
    created TIMESTAMPTZ DEFAULT NOW(),  -- The UTC timestamp when the account was created
    username TEXT NOT NULL UNIQUE,    -- The user name (of course)
    passhash TEXT NOT NULL            -- Argon2id password hash
);

CREATE TABLE IF NOT EXISTS mfa (
    uid SERIAL REFERENCES users,      -- Foreign key from the users table that maps a user ID to a 2FA/TOTP/MFA key
    key TEXT NOT NULL,                -- The 2FA/TOTP/MFA key that is used to generate and track one-time use codes
    created TIMESTAMPTZ DEFAULT NOW(),  -- The UTC timestamp when the 2FA/TOTP/MFA key was generated
    backups TEXT NOT NULL             -- The backup tokens for account recovery, this gets regenerated upon use for security reasons
);

CREATE TABLE IF NOT EXISTS bans (
    bid SERIAL PRIMARY KEY,           -- The ban ID for quick reference
    uid SERIAL REFERENCES users,      -- Foreign key from the users table that maps a user ID to a ban
    created TIMESTAMPTZ DEFAULT NOW(),  -- The UTC timestamp when the ban was issued
    expires TIMESTAMPTZ NOT NULL,       -- The UTC timestamp when the ban is set to expire (0 = never)
    reason TEXT DEFAULT NULL          -- The ban reason (optional of course but a nice thing to have)
);

CREATE TABLE IF NOT EXISTS blog (
    pid SERIAL PRIMARY KEY,           -- The blog post ID for quick reference
    uid SERIAL REFERENCES users,      -- Foreign key from the users table that maps a user ID to a blog post
    created TIMESTAMPTZ DEFAULT NOW(),  -- The UTC timestamp when the blog post was written
    title TEXT NOT NULL,              -- The blog post title text
    body TEXT NOT NULL                -- The templated contents of the blog post
);