-- Supabase SQL Migration for Chat Feature
-- Run this SQL in your Supabase SQL Editor to set up the database

-- Create conversations table
CREATE TABLE IF NOT EXISTS conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_1_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT different_participants CHECK (participant_1_id != participant_2_id),
  UNIQUE(LEAST(participant_1_id, participant_2_id), GREATEST(participant_1_id, participant_2_id))
);

-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  receiver_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  message_type TEXT NOT NULL DEFAULT 'text',
  attachments JSONB NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  is_read BOOLEAN NOT NULL DEFAULT false
);

-- Create indexes for better query performance
CREATE INDEX idx_conversations_participant_1 ON conversations(participant_1_id);
CREATE INDEX idx_conversations_participant_2 ON conversations(participant_2_id);
CREATE INDEX idx_conversations_updated_at ON conversations(updated_at DESC);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX idx_messages_is_read ON messages(is_read) WHERE NOT is_read;

-- Enable Row Level Security (RLS)
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for conversations
-- Users can view conversations they are part of
CREATE POLICY "Users can view conversations they participate in"
ON conversations FOR SELECT
USING (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

-- Users can create conversations
CREATE POLICY "Users can create conversations"
ON conversations FOR INSERT
WITH CHECK (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

-- Users can update conversations they participate in
CREATE POLICY "Users can update conversations they participate in"
ON conversations FOR UPDATE
USING (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

-- Users can delete conversations they participate in
CREATE POLICY "Users can delete conversations they participate in"
ON conversations FOR DELETE
USING (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

-- RLS Policies for messages
-- Users can view messages in conversations they participate in
CREATE POLICY "Users can view messages in their conversations"
ON messages FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM conversations
    WHERE conversations.id = messages.conversation_id
      AND (conversations.participant_1_id = auth.uid() OR conversations.participant_2_id = auth.uid())
  )
);

-- Users can insert messages if they are the sender
CREATE POLICY "Users can send messages in their conversations"
ON messages FOR INSERT
WITH CHECK (
  auth.uid() = sender_id
  AND EXISTS (
    SELECT 1 FROM conversations
    WHERE conversations.id = conversation_id
      AND (conversations.participant_1_id = auth.uid() OR conversations.participant_2_id = auth.uid())
  )
);

-- Users can update messages they sent
CREATE POLICY "Users can only update their own messages"
ON messages FOR UPDATE
USING (auth.uid() = sender_id);

-- Users can delete messages they sent
CREATE POLICY "Users can only delete their own messages"
ON messages FOR DELETE
USING (auth.uid() = sender_id);

-- Create a function to update conversation updated_at timestamp
CREATE OR REPLACE FUNCTION update_conversation_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE conversations
  SET updated_at = now()
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to update conversation timestamp when new message is inserted
CREATE TRIGGER trigger_update_conversation_on_message_insert
AFTER INSERT ON messages
FOR EACH ROW
EXECUTE FUNCTION update_conversation_timestamp();

-- Create a view for easier querying of conversations with last message
CREATE OR REPLACE VIEW conversations_with_last_message AS
SELECT
  c.id,
  c.participant_1_id,
  c.participant_2_id,
  c.created_at,
  c.updated_at,
  m.id as last_message_id,
  m.sender_id as last_message_sender_id,
  m.message as last_message_text,
  m.created_at as last_message_at
FROM conversations c
LEFT JOIN LATERAL (
  SELECT *
  FROM messages
  WHERE messages.conversation_id = c.id
  ORDER BY messages.created_at DESC
  LIMIT 1
) m ON true;

-- Grant permissions to authenticated users
GRANT SELECT ON conversations_with_last_message TO authenticated;
