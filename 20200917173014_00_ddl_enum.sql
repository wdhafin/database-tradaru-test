-- +goose Up
-- +goose StatementBegin
DROP TYPE IF EXISTS "public"."content_type";
DROP TYPE IF EXISTS "public"."mute_duration";
DROP TYPE IF EXISTS "public"."file_category";

CREATE TYPE "public"."content_type" AS ENUM ('text/plain', 'text/html', 'multipart/encrypted', 'multipart/mixed');
CREATE TYPE "public"."mute_duration" AS ENUM ('1 day', '1 week', '1 month', '1 year');
CREATE TYPE "public"."file_category" AS ENUM ('image', 'document', 'audio-video','other');
-- +goose StatementEnd