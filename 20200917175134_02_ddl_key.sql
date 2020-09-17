-- +goose Up
-- SQL in this section is executed when the migration is applied.

-- users
ALTER TABLE "users" ADD UNIQUE("phone_number");
-- end of users

-- user_groups
ALTER TABLE "user_groups" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "user_groups" ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id");
-- end of user_groups

-- groups
ALTER TABLE "groups" ADD UNIQUE("slug");
-- end of groups

-- messages
ALTER TABLE "messages" ADD UNIQUE("uid");
ALTER TABLE "messages" ADD FOREIGN KEY ("sender_id") REFERENCES "users" ("id");
ALTER TABLE "messages" ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id");
ALTER TABLE "messages" ADD FOREIGN KEY ("conversation_id") REFERENCES "conversations" ("id");
ALTER TABLE "messages" ADD FOREIGN KEY ("reply_to") REFERENCES "messages" ("id");
ALTER TABLE "messages" ADD FOREIGN KEY ("forwarded_from") REFERENCES "messages" ("id");
-- end of messages

-- message_details
ALTER TABLE "message_details" ADD FOREIGN KEY ("message_id") REFERENCES "messages" ("id");
-- end of message_details

-- messsage_attachments
ALTER TABLE "message_attachments" ADD UNIQUE("uid");
ALTER TABLE "message_attachments" ADD FOREIGN KEY ("message_uid") REFERENCES "messages" ("uid");
ALTER TABLE "message_attachments" ADD FOREIGN KEY ("conversation_id") REFERENCES "conversations" ("id");
ALTER TABLE "message_attachments" ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id");
-- end of message_attachment

-- message_links
ALTER TABLE "message_links" ADD FOREIGN KEY ("message_id") REFERENCES "messages" ("id");
ALTER TABLE "message_links" ADD FOREIGN KEY ("conversation_id") REFERENCES "conversations" ("id");
ALTER TABLE "message_links" ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id");
-- end of message_links

-- deleted_messages
ALTER TABLE "deleted_messages" ADD FOREIGN KEY ("message_id") REFERENCES "messages" ("id");
ALTER TABLE "deleted_messages" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
-- end of deleted_messages

-- message_recepients
ALTER TABLE "message_recipients" ADD FOREIGN KEY ("message_id") REFERENCES "messages" ("id");
ALTER TABLE "message_recipients" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
-- end of message_recepients

-- conversations
ALTER TABLE "conversations" ADD FOREIGN KEY ("initiated_by") REFERENCES "users" ("id");
ALTER TABLE "conversations" ADD FOREIGN KEY ("last_msg_uid") REFERENCES "messages" ("uid");
-- end of conversations

-- user_conversations
ALTER TABLE "user_conversations" ADD FOREIGN KEY ("conversation_id") REFERENCES "conversations" ("id");
ALTER TABLE "user_conversations" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
-- end of user_conversations
;
-- +goose Down
-- SQL in this section is executed when the migration is rolled back.
