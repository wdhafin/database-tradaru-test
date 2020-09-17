-- +goose Up
-- SQL in this section is executed when the migration is applied.
DROP TABLE IF EXISTS "public"."users" CASCADE;
DROP TABLE IF EXISTS "public"."groups" CASCADE;
DROP TABLE IF EXISTS "public"."user_groups" CASCADE;
DROP TABLE IF EXISTS "public"."conversations" CASCADE;
DROP TABLE IF EXISTS "public"."user_conversations" CASCADE;
DROP TABLE IF EXISTS "public"."messages" CASCADE;
DROP TABLE IF EXISTS "public"."message_recipients" CASCADE;
DROP TABLE IF EXISTS "public"."deleted_messages" CASCADE;
DROP TABLE IF EXISTS "public"."message_details" CASCADE;
DROP TABLE IF EXISTS "public"."message_attachments" CASCADE;
DROP TABLE IF EXISTS "public"."message_links" CASCADE;


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" serial NOT NULL PRIMARY KEY, 

    "phone_number" text NOT NULL,

    "password" text NOT NULL,
    "full_name" text NOT NULL, 
    "picture" text NOT NULL,

    "created_at" timestamptz,
    "updated_at" timestamptz,
    "deleted_at" timestamptz
);

CREATE TABLE IF NOT EXISTS "public"."user_groups" (
    "id" serial NOT NULL PRIMARY KEY,

    "group_id" int NOT NULL,
    "user_id" int NOT NULL,

    "unread_count" integer NOT NULL DEFAULT 0,

    "is_administrator" boolean NOT NULL DEFAULT false,

    "is_muted" boolean NOT NULL DEFAULT false,  
    "mute_duration" mute_duration,  
    "mute_ends_at" timestamptz  
);

CREATE TABLE IF NOT EXISTS "public"."groups" (
    "id" serial NOT NULL PRIMARY KEY,

    "slug" int NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "picture" text NOT NULL,

    "last_msg_uid" uuid,
    "last_msg_sender_icon" text,
    "last_msg_sender_name" text,
    "last_msg_content_type" content_type, 
    "last_msg_content_preview" text,
    "last_msg_date" timestamptz,

    "member_count" integer NOT NULL  DEFAULT 0, 
    "is_pinned" boolean NOT NULL DEFAULT false  
);

CREATE TABLE IF NOT EXISTS "public"."messages" (
    "id" bigserial NOT NULL PRIMARY KEY, 
    "uid" uuid NOT NULL,
    
    "content_type" content_type, 
    "content_preview" text, 
    
    "sender_id" INTEGER NOT NULL,

    "group_id" INTEGER NOT NULL,
    "conversation_id" integer,  

    "reply_to" bigint,  
    "forwarded_from" bigint,  

    "uts" bigint, /* unix timestamp, in nanosecond */
    "sent_at" timestamptz,

    "is_delivered_all" boolean NOT NULL DEFAULT false,  
    "is_read" boolean NOT NULL DEFAULT false,  
    "is_read_all" boolean NOT NULL DEFAULT false,  

    "is_pinned" boolean,  
    "is_emoji_only" boolean,  
    "is_attachment_only" boolean,  
    "is_link_only" boolean,  
    "has_content_detail" boolean,  

    "attachment_count" smallint NOT NULL DEFAULT 0,  
    
    "updated_at" timestamptz,
    "updated_by" integer
);

CREATE TABLE IF NOT EXISTS "public"."message_details" (
    "message_id" bigint NOT NULL,

    "content" text,

    "attachment_ids" int[],

    "server_sent_at" timestamptz,
    "delivered_to_all_at" timestamptz,
    "first_read_at" timestamptz,
    "read_by_all_at" timestamptz
);

CREATE TABLE IF NOT EXISTS "public"."message_attachments" (
    "id" bigserial NOT NULL PRIMARY KEY, 
    "uid" uuid NOT NULL,

    "message_uid" uuid NOT NULL,

    "conversation_id" integer,
    "group_id" integer,

    "category" file_category,

    "mime_type" text, -- image/png, application/pdf, text/html, etc
    "size" integer NOT NULL DEFAULT 0, -- in byte
    "original_name" text, -- original title, allows non-url friendly
    "file_name" text, -- server-converted title, only allows alphanumeric with underscore and hyphen
    "path" text, -- minio relative path to file
    "ext" text, -- file extension, e.g.: .pdf, .docs, .png etc
    "encoding" text, -- e.g. 7bit
    
    "thumbnail_path" text, -- minio relative path to thumbnail file if any,

    "message_date" timestamptz
);


CREATE TABLE IF NOT EXISTS "public"."message_links" (
    "id" bigserial NOT NULL PRIMARY KEY,

    "message_id" bigint NOT NULL,

    "conversation_id" integer,
    "group_id" integer,

    "original_link" text NOT NULL,
    "system_link" text NOT NULL,

    "title" text,
    "sub_title" text,

    "message_date" timestamptz
);

CREATE TABLE IF NOT EXISTS "public"."deleted_messages" (
    "message_id" bigint NOT NULL,

    "user_id" int NOT NULL,

    "done_at" timestamptz
);

CREATE TABLE IF NOT EXISTS "public"."message_recipients" (
    "message_id" bigint NOT NULL,

    "user_id" int NOT NULL,

    "first_read_at" timestamptz,
    "first_delivered_at" timestamptz,

    "is_sender" boolean NOT NULL DEFAULT false,
    "is_bookmarked" boolean
);

CREATE TABLE IF NOT EXISTS "public"."conversations" (
    "id" serial NOT NULL PRIMARY KEY, /* start from 100.000 */

    "participant_hash" text NOT NULL,
    "participant_uids" text[] NOT NULL,

    "initiated_by" integer NOT NULL,

    "last_msg_uid" uuid,
    "last_msg_sender_icon" text,
    "last_msg_sender_name" text,
    "last_msg_content_type" content_type,
    "last_msg_content_preview" text,
    "last_msg_date" timestamptz,

    "is_pinned" boolean NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS "public"."user_conversations" (
    "conversation_id" int NOT NULL,

    "user_id" int NOT NULL,

    "unread_count" integer NOT NULL DEFAULT 0,

    "is_muted" boolean NOT NULL DEFAULT false,
    "mute_duration" mute_duration,
    "mute_ends_at" timestamptz
);


-- +goose Down
-- SQL in this section is executed when the migration is rolled back.
