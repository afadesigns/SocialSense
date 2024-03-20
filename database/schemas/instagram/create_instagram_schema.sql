-- File: social_media_schema.sql

-- User table with improvements
CREATE TABLE IF NOT EXISTS "User" (
    "pk" VARCHAR PRIMARY KEY,
    "username" VARCHAR NOT NULL,
    "full_name" VARCHAR NOT NULL,
    "account_visibility" INTEGER NOT NULL DEFAULT 0, -- 0: Public, 1: Private, 2: Business
    "is_private" BOOLEAN NOT NULL,
    "profile_pic_url" VARCHAR NOT NULL,
    "profile_pic_url_hd" VARCHAR,
    "is_verified" BOOLEAN NOT NULL,
    "verified_badge_type" VARCHAR,
    "media_count" INTEGER NOT NULL,
    "follower_count" INTEGER NOT NULL,
    "following_count" INTEGER NOT NULL,
    "biography" TEXT DEFAULT '',
    "external_url" VARCHAR,
    "account_type" INTEGER,
    "is_business" BOOLEAN NOT NULL,
    "public_email" VARCHAR,
    "secondary_email" VARCHAR,
    "email_visible" BOOLEAN,
    "contact_phone_number" VARCHAR,
    "public_phone_country_code" VARCHAR,
    "public_phone_number" VARCHAR,
    "business_contact_method" VARCHAR,
    "business_category_name" VARCHAR,
    "category_name" VARCHAR,
    "category" VARCHAR,
    "address_street" VARCHAR,
    "city_id" VARCHAR,
    "city_name" VARCHAR,
    "latitude" FLOAT,
    "longitude" FLOAT,
    "zip" VARCHAR,
    "instagram_location_id" VARCHAR,
    "interop_messaging_user_fbid" VARCHAR,
    "engagement_rate" FLOAT,
    "last_active_at" TIMESTAMP,
    "story_sharing_enabled" BOOLEAN,
    "activity_status_visible" BOOLEAN,
    "followers_visible" BOOLEAN,
    "following_visible" BOOLEAN,
    "content_language" VARCHAR,
    "theme_preference" VARCHAR,
    "website_url" VARCHAR,
    "operating_hours" JSONB,
    "profile_creation_date" TIMESTAMP,
    "account_status" VARCHAR
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_username ON "User" ("username");
CREATE INDEX IF NOT EXISTS idx_public_email ON "User" ("public_email");
CREATE INDEX IF NOT EXISTS idx_account_status ON "User" ("account_status");


-- Enhanced BioLink table
CREATE TABLE IF NOT EXISTS "BioLink" (
    "link_id" VARCHAR PRIMARY KEY,
    "url" VARCHAR NOT NULL,
    "lynx_url" VARCHAR,
    "link_type" VARCHAR,
    "title" VARCHAR,
    "description" TEXT,
    "display_text" VARCHAR,
    "is_pinned" BOOLEAN,
    "open_external_url_with_in_app_browser" BOOLEAN,
    "click_count" INTEGER DEFAULT 0,
    "last_clicked" TIMESTAMP,
    "referrer" VARCHAR,
    "is_active" BOOLEAN DEFAULT TRUE,
    "expiration_date" TIMESTAMP,
    "thumbnail_url" VARCHAR,
    "tags" TEXT,
    "priority_order" INTEGER,
    "is_verified" BOOLEAN,
    "shortened_url" VARCHAR,
    "accessibility_label" VARCHAR,
    "compliance_flags" JSONB
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_is_active ON "BioLink" ("is_active");
CREATE INDEX IF NOT EXISTS idx_expiration_date ON "BioLink" ("expiration_date");
CREATE INDEX IF NOT EXISTS idx_click_count ON "BioLink" ("click_count");

-- Enhanced User_BioLink relationship table
CREATE TABLE IF NOT EXISTS "User_BioLink" (
    "user_pk" VARCHAR NOT NULL,
    "bio_link_id" VARCHAR NOT NULL,
    "added_date" TIMESTAMP,
    "removed_date" TIMESTAMP,
    "is_clicked" BOOLEAN DEFAULT FALSE,
    "click_count" INTEGER DEFAULT 0,
    "last_clicked" TIMESTAMP,
    "custom_title" VARCHAR,
    "is_visible" BOOLEAN DEFAULT TRUE,
    "category" VARCHAR,
    "priority_order" INTEGER,
    "is_approved" BOOLEAN,
    "active_start_date" TIMESTAMP,
    "active_end_date" TIMESTAMP,
    PRIMARY KEY ("user_pk", "bio_link_id"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("bio_link_id") REFERENCES "BioLink" ("link_id")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_user_pk ON "User_BioLink" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_bio_link_id ON "User_BioLink" ("bio_link_id");
CREATE INDEX IF NOT EXISTS idx_is_clicked ON "User_BioLink" ("is_clicked");
CREATE INDEX IF NOT EXISTS idx_added_date ON "User_BioLink" ("added_date");
CREATE INDEX IF NOT EXISTS idx_priority_order ON "User_BioLink" ("priority_order");

-- Enhanced Media table
CREATE TABLE IF NOT EXISTS "Media" (
    "pk" VARCHAR PRIMARY KEY,
    "id" VARCHAR NOT NULL,
    "code" VARCHAR NOT NULL,
    "taken_at" TIMESTAMP NOT NULL,
    "media_type" INTEGER NOT NULL,
    "image_versions2" JSONB,
    "product_type" VARCHAR,
    "thumbnail_url" VARCHAR,
    "comment_count" INTEGER DEFAULT 0,
    "comments_disabled" BOOLEAN DEFAULT FALSE,
    "commenting_disabled_for_viewer" BOOLEAN DEFAULT FALSE,
    "like_count" INTEGER NOT NULL,
    "play_count" INTEGER,
    "has_liked" BOOLEAN,
    "caption_text" TEXT NOT NULL,
    "alt_text" VARCHAR,
    "media_url" VARCHAR,
    "engagement_rate" FLOAT,
    "impressions_count" INTEGER,
    "tags" JSONB,
    "mentions" JSONB,
    "bookmark_count" INTEGER DEFAULT 0,
    "share_count" INTEGER DEFAULT 0,
    "expiration_date" TIMESTAMP,
    "location_name" VARCHAR,
    "latitude" FLOAT,
    "longitude" FLOAT,
    "content_rating" VARCHAR,
    "is_visible" BOOLEAN DEFAULT TRUE,
    "carousel_metadata" JSONB,
    "external_source_id" VARCHAR,
    "external_source_name" VARCHAR,
    "reactions" JSONB,
    PRIMARY KEY ("pk"),
    FOREIGN KEY ("pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_type ON "Media" ("media_type");
CREATE INDEX IF NOT EXISTS idx_taken_at ON "Media" ("taken_at");
CREATE INDEX IF NOT EXISTS idx_engagement_rate ON "Media" ("engagement_rate");

-- Enhanced User_Media relationship table
CREATE TABLE IF NOT EXISTS "User_Media" (
    "user_pk" VARCHAR NOT NULL,
    "media_pk" VARCHAR NOT NULL,
    "posted_at" TIMESTAMP,
    "ownership_type" VARCHAR,
    "role" VARCHAR,
    "visibility" BOOLEAN DEFAULT TRUE,
    "user_has_liked" BOOLEAN DEFAULT FALSE,
    "user_has_saved" BOOLEAN DEFAULT FALSE,
    "user_has_shared" BOOLEAN DEFAULT FALSE,
    "contribution_metric" INTEGER,
    "custom_tags" JSONB,
    "category" VARCHAR,
    "access_level" VARCHAR,
    "permissions" JSONB,
    PRIMARY KEY ("user_pk", "media_pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_user_pk ON "User_Media" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_posted_at ON "User_Media" ("posted_at");

-- Enhanced Resource table
CREATE TABLE IF NOT EXISTS "Resource" (
    "pk" VARCHAR PRIMARY KEY,
    "original_filename" VARCHAR,
    "resolution" VARCHAR,
    "file_size" INTEGER,
    "mime_type" VARCHAR,
    "cdn_url" VARCHAR,
    "accessibility_caption" TEXT,
    "media_versions" JSONB,
    "alt_text" TEXT,
    "like_count" INTEGER DEFAULT 0,
    "share_count" INTEGER DEFAULT 0,
    "tags" JSONB,
    "analytics_data" JSONB,
    "checksum" VARCHAR,
    "is_private" BOOLEAN DEFAULT FALSE,
    "video_url" VARCHAR NOT NULL,
    "thumbnail_url" VARCHAR NOT NULL,
    "media_type" INTEGER NOT NULL
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_type ON "Resource" ("media_type");
CREATE INDEX IF NOT EXISTS idx_mime_type ON "Resource" ("mime_type");
CREATE INDEX IF NOT EXISTS idx_file_size ON "Resource" ("file_size");

-- Enhanced Media_Resource Relationship table
CREATE TABLE IF NOT EXISTS "Media_Resource" (
    "media_pk" VARCHAR NOT NULL,
    "resource_pk" VARCHAR NOT NULL,
    "relation_type" VARCHAR,
    "sequence_order" INTEGER,
    "view_count" INTEGER DEFAULT 0,
    "engagement_data" JSONB,
    "status" VARCHAR,
    "expiration_date" TIMESTAMP,
    "is_accessible" BOOLEAN DEFAULT FALSE,
    "compliance_notes" TEXT,
    "verification_status" VARCHAR,
    "access_control" JSONB,
    "caching_info" JSONB,
    "usage_metrics" JSONB,
    "extended_attributes" JSONB,
    PRIMARY KEY ("media_pk", "resource_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("resource_pk") REFERENCES "Resource" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_relation_type ON "Media_Resource" ("relation_type");
CREATE INDEX IF NOT EXISTS idx_status ON "Media_Resource" ("status");
CREATE INDEX IF NOT EXISTS idx_sequence_order ON "Media_Resource" ("sequence_order");

-- Enhanced Usertag table
CREATE TABLE IF NOT EXISTS "Usertag" (
    "tag_id" VARCHAR PRIMARY KEY,
    "user_pk" VARCHAR NOT NULL,
    "media_pk" VARCHAR NOT NULL,
    "x" FLOAT NOT NULL,
    "y" FLOAT NOT NULL,
    "context" TEXT,
    "is_visible" BOOLEAN DEFAULT TRUE,
    "tagged_by_user_pk" VARCHAR,
    "tagged_at" TIMESTAMP,
    "approval_status" VARCHAR,
    "width" FLOAT,
    "height" FLOAT,
    "custom_attributes" JSONB,
    "engagement_metrics" JSONB,
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("tagged_by_user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_pk ON "Usertag" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_user_pk ON "Usertag" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_tagged_by_user_pk ON "Usertag" ("tagged_by_user_pk");
CREATE INDEX IF NOT EXISTS idx_approval_status ON "Usertag" ("approval_status");

-- Enhanced Location table
CREATE TABLE IF NOT EXISTS "Location" (
    "pk" SERIAL PRIMARY KEY,
    "name" VARCHAR NOT NULL,
    "phone" VARCHAR DEFAULT '',
    "website" VARCHAR DEFAULT '',
    "category" VARCHAR DEFAULT '',
    "hours" JSONB DEFAULT '{}',
    "address" VARCHAR,
    "city" VARCHAR,
    "region" VARCHAR,
    "country" VARCHAR,
    "zip" VARCHAR,
    "lng" FLOAT,
    "lat" FLOAT,
    "place_type" VARCHAR,
    "description" TEXT,
    "tags" JSONB,
    "status" VARCHAR,
    "capacity" INTEGER,
    "popularity_score" FLOAT,
    "check_ins_count" INTEGER,
    "accessibility_info" JSONB,
    "image_url" VARCHAR,
    "is_verified" BOOLEAN DEFAULT FALSE,
    "owner_user_pk" VARCHAR,
    "related_media_count" INTEGER DEFAULT 0,
    "extended_attributes" JSONB,
    FOREIGN KEY ("owner_user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_lng_lat ON "Location" USING GIST (lng, lat);
CREATE INDEX IF NOT EXISTS idx_name ON "Location" ("name");
CREATE INDEX IF NOT EXISTS idx_city ON "Location" ("city");
CREATE INDEX IF NOT EXISTS idx_region ON "Location" ("region");
CREATE INDEX IF NOT EXISTS idx_country ON "Location" ("country");
CREATE INDEX IF NOT EXISTS idx_place_type ON "Location" ("place_type");
CREATE INDEX IF NOT EXISTS idx_is_verified ON "Location" ("is_verified");

CREATE TABLE IF NOT EXISTS "Story" (
    "pk" VARCHAR PRIMARY KEY,
    "id" VARCHAR NOT NULL,
    "code" VARCHAR NOT NULL,
    "taken_at" TIMESTAMP NOT NULL,
    "imported_taken_at" TIMESTAMP,
    "media_type" INTEGER NOT NULL,
    "product_type" VARCHAR,
    "thumbnail_url" VARCHAR,
    "video_url" VARCHAR,
    "video_duration" FLOAT DEFAULT 0.0,
    "is_paid_partnership" BOOLEAN,
    "viewer_count" INTEGER,
    "expiration_date" TIMESTAMP,
    "engagement_metrics" JSONB,
    "caption" TEXT,
    "accessibility_caption" TEXT,
    "hashtags" JSONB,
    "mentions" JSONB,
    "impressions" INTEGER,
    "exit_rates" FLOAT,
    "stickers" JSONB,
    "polls_votes" JSONB,
    "visibility_restriction" VARCHAR,
    "report_count" INTEGER,
    "extended_attributes" JSONB,
    "related_media" JSONB,
    FOREIGN KEY ("pk") REFERENCES "Media" ("pk")
);

CREATE TABLE IF NOT EXISTS "StoryMention" (
    "story_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "x" FLOAT,
    "y" FLOAT,
    "width" FLOAT,
    "height" FLOAT,
    "rotation" FLOAT,
    "scale" FLOAT,
    "mention_type" VARCHAR,
    "text" TEXT,
    "action_url" VARCHAR,
    "is_responded" BOOLEAN,
    "color" VARCHAR,
    "font_style" VARCHAR,
    "view_count" INTEGER,
    "engagement_metrics" JSONB,
    "mentioned_at" TIMESTAMP,
    "accessibility_text" TEXT,
    "moderation_status" VARCHAR,
    PRIMARY KEY ("story_pk", "user_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

CREATE TABLE IF NOT EXISTS "StoryLocation" (
    "story_pk" VARCHAR NOT NULL,
    "location_pk" SERIAL NOT NULL,
    "x" FLOAT,
    "y" FLOAT,
    "width" FLOAT,
    "height" FLOAT,
    "rotation" FLOAT,
    "scale" FLOAT,
    "visibility" BOOLEAN,
    "action_url" VARCHAR,
    "tap_count" INTEGER,
    "color" VARCHAR,
    "font_style" VARCHAR,
    "display_duration" FLOAT,
    "contextual_text" TEXT,
    "location_type" VARCHAR,
    "custom_location_name" VARCHAR,
    "engagement_metrics" JSONB,
    "approval_status" VARCHAR,
    PRIMARY KEY ("story_pk", "location_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("location_pk") REFERENCES "Location" ("pk")
);

CREATE TABLE IF NOT EXISTS "StoryHashtag" (
    "story_pk" VARCHAR NOT NULL,
    "hashtag_id" VARCHAR NOT NULL,
    "x" FLOAT,
    "y" FLOAT,
    "width" FLOAT,
    "height" FLOAT,
    "rotation" FLOAT,
    "visibility" BOOLEAN,
    "tap_count" INTEGER,
    "color" VARCHAR,
    "font_style" VARCHAR,
    "hashtag_type" VARCHAR,
    "custom_text" TEXT,
    "display_duration" FLOAT,
    "mentioned_at" TIMESTAMP,
    "engagement_metrics" JSONB,
    "influence_score" FLOAT,
    "campaign_id" VARCHAR,
    "suggested_hashtags" JSONB,
    PRIMARY KEY ("story_pk", "hashtag_id"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("hashtag_id") REFERENCES "Hashtag" ("id")
);

CREATE TABLE IF NOT EXISTS "StorySticker" (
    "id" SERIAL PRIMARY KEY,
    "story_pk" VARCHAR NOT NULL,
    "type" VARCHAR DEFAULT 'gif',
    "x" FLOAT NOT NULL,
    "y" FLOAT NOT NULL,
    "z" INTEGER DEFAULT 1000005,
    "width" FLOAT NOT NULL,
    "height" FLOAT NOT NULL,
    "rotation" FLOAT DEFAULT 0.0,
    "interaction_type" VARCHAR,
    "text_content" TEXT,
    "tap_count" INTEGER,
    "action_url" VARCHAR,
    "color" VARCHAR,
    "font_style" VARCHAR,
    "engagement_metrics" JSONB,
    "visibility_duration" FLOAT,
    "is_animated" BOOLEAN,
    "resource_id" VARCHAR,
    "response_data" JSONB,
    "custom_attributes" JSONB,
    "moderation_status" VARCHAR,
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk")
);

-- Collection table with improvements
CREATE TABLE IF NOT EXISTS "Collection" (
    "id" VARCHAR PRIMARY KEY,
    "name" VARCHAR NOT NULL,
    "type" VARCHAR NOT NULL,
    "media_count" INTEGER NOT NULL,
    "description" TEXT,
    "visibility" VARCHAR,
    "created_at" TIMESTAMP,
    "updated_at" TIMESTAMP,
    "like_count" INTEGER,
    "share_count" INTEGER,
    "view_count" INTEGER,
    "tags" JSONB,
    "cover_image_url" VARCHAR,
    "sort_order" VARCHAR,
    "custom_attributes" JSONB,
    "collaborators" JSONB,
    "parent_collection_id" VARCHAR,
    "owner_id" VARCHAR,
    "moderation_status" VARCHAR,
    FOREIGN KEY ("parent_collection_id") REFERENCES "Collection" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("owner_id") REFERENCES "User" ("pk") ON DELETE SET NULL
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_collection_owner_id ON "Collection" ("owner_id");

CREATE TABLE IF NOT EXISTS "Comment" (
    "pk" VARCHAR PRIMARY KEY,
    "text" TEXT NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "created_at_utc" TIMESTAMP NOT NULL,
    "edited_at" TIMESTAMP,
    "edit_history" JSONB,
    "accessibility_caption" TEXT,
    "content_type" VARCHAR NOT NULL,
    "status" VARCHAR NOT NULL,
    "replied_to_comment_id" VARCHAR,
    "reply_count" INTEGER,
    "share_count" INTEGER,
    "moderation_status" VARCHAR,
    "flags" INTEGER,
    "tags" JSONB,
    "sentiment_score" FLOAT,
    "mentions" JSONB,
    "parent_media_id" VARCHAR,
    "visibility" VARCHAR,
    "is_anonymous" BOOLEAN,
    "has_liked" BOOLEAN,
    "like_count" INTEGER,
    "engagement_metrics" JSONB,
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("replied_to_comment_id") REFERENCES "Comment" ("pk"),
    FOREIGN KEY ("parent_media_id") REFERENCES "Media" ("pk")
);

CREATE TABLE IF NOT EXISTS "Story_Comment" (
    "story_pk" VARCHAR NOT NULL,
    "comment_pk" VARCHAR NOT NULL,
    "reaction_type" VARCHAR,
    "visibility" BOOLEAN,
    "posted_at" TIMESTAMP,
    "expires_at" TIMESTAMP,
    "contextual_text" TEXT,
    "media_attachment_id" VARCHAR,
    "engagement_score" FLOAT,
    "is_liked" BOOLEAN,
    "like_count" INTEGER,
    "moderation_status" VARCHAR,
    "report_count" INTEGER,
    "mentioned_users" JSONB,
    "extended_attributes" JSONB,
    PRIMARY KEY ("story_pk", "comment_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("comment_pk") REFERENCES "Comment" ("pk"),
    FOREIGN KEY ("media_attachment_id") REFERENCES "Media" ("pk")
);

-- Hashtag table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Hashtag" (
    "id" VARCHAR PRIMARY KEY,
    "name" VARCHAR NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP,
    "popularity_score" FLOAT,
    "like_count" INTEGER,
    "comment_count" INTEGER,
    "share_count" INTEGER,
    "category" VARCHAR,
    "tags" JSONB,
    "top_user" VARCHAR,
    "compliance" BOOLEAN,
    "trending_score" FLOAT,
    "last_trended_at" TIMESTAMP,
    "contributor_count" INTEGER,
    "engagement_rate" FLOAT,
    "related_hashtags" JSONB,
    "parent_hashtag_id" VARCHAR,
    "historical_popularity" JSONB,
    "sentiment_score" FLOAT,
    "cultural_significance" TEXT,
    "language" VARCHAR,
    "gallery_media_ids" JSONB,
    "discovery_score" FLOAT,
    "viewer_growth_rate" FLOAT,
    "quality_score" FLOAT,
    "relevance_score" FLOAT,
    "active_contributor_count" INTEGER,
    "community_engagement_index" FLOAT,
    "lifecycle_stage" VARCHAR,
    "evolution_track" JSONB,
    "user_demographics" JSONB,
    "interaction_types_breakdown" JSONB,
    "seo_impact_score" FLOAT,
    "monetization_potential" BOOLEAN,
    "event_association" JSONB,
    "influencer_impact" JSONB,
    "geographical_trends" JSONB,
    "content_quality_indicators" JSONB,
    "user_sentiment_analysis" JSONB,
    "community_size" INTEGER,
    "copyright_trademark_status" VARCHAR,
    "ethical_guidelines_compliance" BOOLEAN,
    "api_engagement_data" JSONB,
    "cross_platform_identifier" JSONB,
    "data_retention_period" TIMESTAMP,
    "is_archived" BOOLEAN,
    "ar_vr_interaction_count" INTEGER,
    "has_ar_vr_content" BOOLEAN,
    "new_user_growth" INTEGER,
    "user_retention_impact" FLOAT,
    "diversity_index" FLOAT,
    "accessibility_features_count" INTEGER,
    "platform_engagement_differential" JSONB,
    "social_impact_score" FLOAT,
    "ethical_controversy_flag" BOOLEAN,
    "trend_forecasting" JSONB,
    "legal_review_status" VARCHAR,
    "compliance_history" JSONB,
    "user_engagement_depth" FLOAT,
    "algorithmic_impact_score" FLOAT,
    "content_velocity" FLOAT,
    "niche_identification_score" FLOAT
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_hashtag_name ON "Hashtag" ("name");
CREATE INDEX IF NOT EXISTS idx_hashtag_popularity_score ON "Hashtag" ("popularity_score");
CREATE INDEX IF NOT EXISTS idx_hashtag_is_trending ON "Hashtag" ("trending_score");
CREATE INDEX IF NOT EXISTS idx_hashtag_compliance ON "Hashtag" ("compliance") WHERE "compliance" IS TRUE;
CREATE INDEX IF NOT EXISTS idx_hashtag_monetization_potential ON "Hashtag" ("monetization_potential") WHERE "monetization_potential" IS TRUE;

-- Highlight table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Highlight" (
    "pk" VARCHAR PRIMARY KEY,
    "id" VARCHAR NOT NULL,
    "latest_reel_media" INTEGER NOT NULL,
    "title" VARCHAR NOT NULL,
    "description" TEXT, -- Enhanced Highlight Attributes
    "visibility" VARCHAR, -- Enhanced Highlight Attributes
    "cover_media_type" VARCHAR, -- Enhanced Highlight Attributes
    "thumbnail_url" VARCHAR, -- Enhanced Highlight Attributes
    "created_at" TIMESTAMP NOT NULL,
    "is_pinned_highlight" BOOLEAN NOT NULL,
    "media_count" INTEGER NOT NULL,
    "view_count" INTEGER, -- Interaction and Engagement
    "share_count" INTEGER, -- Interaction and Engagement
    "last_updated_at" TIMESTAMP, -- Content Management and Curation
    "expiration_date" TIMESTAMP, -- Content Management and Curation
    "engagement_rate" FLOAT, -- Analytics and Insights
    "interaction_types_breakdown" JSONB, -- Analytics and Insights
    "collaborators" JSONB, -- Social and Collaborative Features
    "mention_count" INTEGER, -- Social and Collaborative Features
    "custom_attributes" JSONB -- Advanced Customization and Presentation
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_highlight_visibility ON "Highlight" ("visibility");
CREATE INDEX IF NOT EXISTS idx_highlight_created_at ON "Highlight" ("created_at");
CREATE INDEX IF NOT EXISTS idx_highlight_view_count ON "Highlight" ("view_count");
CREATE INDEX IF NOT EXISTS idx_highlight_engagement_rate ON "Highlight" ("engagement_rate");

-- Highlight_Media Relationship table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Highlight_Media" (
    "highlight_pk" VARCHAR NOT NULL,
    "media_pk" VARCHAR NOT NULL,
    "order_index" INTEGER, -- Order and Presentation
    "presentation_style" VARCHAR, -- Order and Presentation
    "view_count" INTEGER, -- Interaction and Engagement Metrics
    "interaction_types" JSONB, -- Interaction and Engagement Metrics
    "usage_count" INTEGER, -- Content Management and Usage
    "is_expired" BOOLEAN, -- Content Management and Usage
    "engagement_rate" FLOAT, -- Analytics and Insights
    "sentiment_score" FLOAT, -- Analytics and Insights
    "contributor_id" VARCHAR, -- Social and Collaborative Features
    "mentioned_users" JSONB, -- Social and Collaborative Features
    "custom_attributes" JSONB, -- Advanced Customization and Accessibility
    PRIMARY KEY ("highlight_pk", "media_pk"),
    FOREIGN KEY ("highlight_pk") REFERENCES "Highlight" ("pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_highlight_media_order_index ON "Highlight_Media" ("order_index");
CREATE INDEX IF NOT EXISTS idx_highlight_media_engagement_rate ON "Highlight_Media" ("engagement_rate");

-- Track table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Track" (
    "id" VARCHAR PRIMARY KEY,
    "title" VARCHAR NOT NULL,
    "subtitle" VARCHAR NOT NULL,
    "display_artist" VARCHAR NOT NULL,
    "audio_cluster_id" INTEGER NOT NULL,
    "artist_id" INTEGER,
    "cover_artwork_uri" VARCHAR,
    "cover_artwork_thumbnail_uri" VARCHAR,
    "progressive_download_url" VARCHAR,
    "fast_start_progressive_download_url" VARCHAR,
    "reactive_audio_download_url" VARCHAR,
    "highlight_start_times_in_ms" INTEGER[],
    "is_explicit" BOOLEAN NOT NULL,
    "dash_manifest" VARCHAR NOT NULL,
    "uri" VARCHAR,
    "has_lyrics" BOOLEAN NOT NULL,
    "audio_asset_id" INTEGER NOT NULL,
    "duration_in_ms" INTEGER NOT NULL,
    "allows_saving" BOOLEAN NOT NULL,
    "territory_validity_periods" JSONB,
    "genre" VARCHAR, -- Enhanced Track Metadata
    "release_date" DATE, -- Enhanced Track Metadata
    "bpm" INTEGER, -- Enhanced Track Metadata
    "like_count" INTEGER, -- User Interaction and Engagement
    "play_count" INTEGER, -- User Interaction and Engagement
    "share_count" INTEGER, -- User Interaction and Engagement
    "quality_rating" FLOAT, -- Content Quality and Accessibility
    "accessibility_features" JSONB, -- Content Quality and Accessibility
    "featured_artists" JSONB, -- Social and Collaborative Features
    "ugc_link" JSONB, -- Social and Collaborative Features
    "mood" VARCHAR, -- Advanced Analytics and Insights
    "listener_demographics" JSONB, -- Advanced Analytics and Insights
    "copyright_status" VARCHAR, -- Legal and Copyright Information
    "licensing_info" JSONB -- Legal and Copyright Information
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_track_genre ON "Track" ("genre");
CREATE INDEX IF NOT EXISTS idx_track_release_date ON "Track" ("release_date");
CREATE INDEX IF NOT EXISTS idx_track_play_count ON "Track" ("play_count");
CREATE INDEX IF NOT EXISTS idx_track_like_count ON "Track" ("like_count");

-- Note table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Note" (
    "id" VARCHAR PRIMARY KEY,
    "text" TEXT NOT NULL,
    "title" VARCHAR, -- Enhanced Content and Interaction
    "user_pk" VARCHAR NOT NULL,
    "audience" INTEGER NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "expires_at" TIMESTAMP NOT NULL,
    "is_emoji_only" BOOLEAN NOT NULL,
    "has_translation" BOOLEAN NOT NULL,
    "note_style" INTEGER NOT NULL,
    "tagged_users" JSONB, -- Enhanced Content and Interaction
    "attachment_urls" JSONB, -- Enhanced Content and Interaction
    "like_count" INTEGER, -- User Engagement and Accessibility
    "comment_count" INTEGER, -- User Engagement and Accessibility
    "accessibility_rating" FLOAT, -- User Engagement and Accessibility
    "read_count" INTEGER, -- Analytics and Insights
    "engagement_score" FLOAT, -- Analytics and Insights
    "categories" JSONB, -- Content Categorization and Management
    "tags" JSONB, -- Content Categorization and Management
    "visibility" VARCHAR, -- Privacy and Security
    "is_encrypted" BOOLEAN, -- Privacy and Security
    "formatting_options" JSONB, -- Content Customization and Presentation
    "reaction_types" JSONB -- Content Customization and Presentation
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_note_user_pk ON "Note" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_note_created_at ON "Note" ("created_at");
CREATE INDEX IF NOT EXISTS idx_note_categories ON "Note" USING GIN ("categories" jsonb_path_ops);
CREATE INDEX IF NOT EXISTS idx_note_tags ON "Note" USING GIN ("tags" jsonb_path_ops);

-- Note_User Relationship table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Note_User" (
    "note_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "relationship_type" VARCHAR, -- Diversifying Relationship Types
    "interaction_timestamp" TIMESTAMP, -- Enhancing User Interaction Tracking
    "interaction_type" VARCHAR, -- Enhancing User Interaction Tracking
    "contribution_level" VARCHAR, -- Supporting Collaborative Features
    "permission_level" VARCHAR, -- Supporting Collaborative Features
    "reaction" VARCHAR, -- Facilitating Social Interactions
    "notification_status" BOOLEAN, -- Facilitating Social Interactions
    "accessibility_feedback" TEXT, -- Promoting Accessibility and Inclusivity
    "engagement_score" FLOAT, -- Analytics and Insights
    "view_duration" INTEGER, -- Analytics and Insights
    PRIMARY KEY ("note_pk", "user_pk"),
    FOREIGN KEY ("note_pk") REFERENCES "Note" ("id"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_note_user_note_pk ON "Note_User" ("note_pk");
CREATE INDEX IF NOT EXISTS idx_note_user_user_pk ON "Note_User" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_note_user_relationship_type ON "Note_User" ("relationship_type");
CREATE INDEX IF NOT EXISTS idx_note_user_interaction_timestamp ON "Note_User" ("interaction_timestamp");

-- DirectMessage table with additional refinements and features
CREATE TABLE IF NOT EXISTS "DirectMessage" (
    "id" VARCHAR PRIMARY KEY,
    "user_pk" VARCHAR,
    "thread_pk" VARCHAR,
    "timestamp" TIMESTAMP NOT NULL,
    "item_type" VARCHAR,
    "is_sent_by_viewer" BOOLEAN,
    "is_shh_mode" BOOLEAN,
    "text" TEXT,
    "reply_pk" VARCHAR,
    "link" JSONB,
    "animated_media" JSONB,
    "media_pk" VARCHAR,
    "visual_media" JSONB,
    "media_share_pk" VARCHAR,
    "reel_share" JSONB,
    "story_share" JSONB,
    "felix_share" JSONB,
    "xma_share_pk" VARCHAR,
    "clip_pk" VARCHAR,
    "placeholder" JSONB,
    "read_receipt" TIMESTAMP, -- Enhanced Messaging Features
    "message_status" VARCHAR, -- Enhanced Messaging Features
    "media_description" TEXT, -- Rich Media Integration
    "media_type" VARCHAR, -- Rich Media Integration
    "reaction" JSONB, -- Advanced Interaction and Engagement
    "forward_count" INTEGER, -- Advanced Interaction and Engagement
    "encryption_status" BOOLEAN, -- Security and Privacy Enhancements
    "deletion_flag" BOOLEAN, -- Security and Privacy Enhancements
    "contextual_link" JSONB, -- Contextual and Conversation Management
    "conversation_tags" JSONB, -- Contextual and Conversation Management
    "engagement_score" FLOAT, -- User Engagement and Analytics
    "participation_level" VARCHAR -- User Engagement and Analytics
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_direct_message_thread_pk ON "DirectMessage" ("thread_pk");
CREATE INDEX IF NOT EXISTS idx_direct_message_timestamp ON "DirectMessage" ("timestamp");
CREATE INDEX IF NOT EXISTS idx_direct_message_user_pk ON "DirectMessage" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_direct_message_message_status ON "DirectMessage" ("message_status");

-- DirectMessage_User table with additional refinements and features
CREATE TABLE IF NOT EXISTS "DirectMessage_User" (
    "message_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "user_role" VARCHAR, -- Advanced Role Management
    "read_status" BOOLEAN, -- Interaction and Engagement Tracking
    "reaction" VARCHAR, -- Interaction and Engagement Tracking
    "notification_status" VARCHAR, -- Notification and Privacy Management
    "privacy_setting" VARCHAR, -- Notification and Privacy Management
    "deletion_status" BOOLEAN, -- Content Management and Retention
    "archival_status" BOOLEAN, -- Content Management and Retention
    "engagement_score" FLOAT, -- User Engagement and Analytics
    "message_importance" INTEGER, -- User Engagement and Analytics
    "accessibility_options" JSONB, -- Dynamic Interaction and Accessibility
    PRIMARY KEY ("message_pk", "user_pk"),
    FOREIGN KEY ("message_pk") REFERENCES "DirectMessage" ("id"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_direct_message_user_message_pk ON "DirectMessage_User" ("message_pk");
CREATE INDEX IF NOT EXISTS idx_direct_message_user_user_pk ON "DirectMessage_User" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_direct_message_user_read_status ON "DirectMessage_User" ("read_status");
CREATE INDEX IF NOT EXISTS idx_direct_message_user_user_role ON "DirectMessage_User" ("user_role");

-- DirectMessage_Thread table with additional refinements and features
CREATE TABLE IF NOT EXISTS "DirectMessage_Thread" (
    "message_pk" VARCHAR NOT NULL,
    "thread_pk" VARCHAR NOT NULL,
    "last_read_message_pk" VARCHAR, -- Enhanced Conversation Dynamics
    "message_role" VARCHAR, -- Enhanced Conversation Dynamics
    "unread_count" INTEGER, -- User Interaction and Notification Management
    "mute_status" BOOLEAN, -- User Interaction and Notification Management
    "thread_status" VARCHAR, -- Thread Status and Management
    "pinned_status" BOOLEAN, -- Thread Status and Management
    "access_level" VARCHAR, -- Content Security and Privacy
    "encryption_flag" BOOLEAN, -- Content Security and Privacy
    "participant_engagement" JSONB, -- Advanced Analytics and Insights
    "engagement_score" FLOAT, -- Advanced Analytics and Insights
    PRIMARY KEY ("message_pk", "thread_pk"),
    FOREIGN KEY ("message_pk") REFERENCES "DirectMessage" ("id"),
    FOREIGN KEY ("thread_pk") REFERENCES "DirectThread" ("pk"),
    FOREIGN KEY ("last_read_message_pk") REFERENCES "DirectMessage" ("id")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_direct_message_thread_thread_pk ON "DirectMessage_Thread" ("thread_pk");
CREATE INDEX IF NOT EXISTS idx_direct_message_thread_last_read_message_pk ON "DirectMessage_Thread" ("last_read_message_pk");
CREATE INDEX IF NOT EXISTS idx_direct_message_thread_thread_status ON "DirectMessage_Thread" ("thread_status");

-- DirectThread table with additional refinements and features
CREATE TABLE IF NOT EXISTS "DirectThread" (
    "pk" VARCHAR PRIMARY KEY,
    "id" VARCHAR NOT NULL,
    "last_activity_at" TIMESTAMP NOT NULL,
    "muted" BOOLEAN NOT NULL,
    "named" BOOLEAN NOT NULL,
    "canonical" BOOLEAN NOT NULL,
    "pending" BOOLEAN NOT NULL,
    "archived" BOOLEAN NOT NULL,
    "thread_type" VARCHAR NOT NULL,
    "thread_title" VARCHAR NOT NULL,
    "folder" INTEGER NOT NULL,
    "vc_muted" BOOLEAN NOT NULL,
    "is_group" BOOLEAN NOT NULL,
    "mentions_muted" BOOLEAN NOT NULL,
    "approval_required_for_new_members" BOOLEAN NOT NULL,
    "input_mode" INTEGER NOT NULL,
    "business_thread_folder" INTEGER NOT NULL,
    "read_state" INTEGER NOT NULL,
    "is_close_friend_thread" BOOLEAN NOT NULL,
    "assigned_admin_id" INTEGER NOT NULL,
    "shh_mode_enabled" BOOLEAN NOT NULL,
    "description" TEXT, -- Enhanced Thread Details and Management
    "cover_image_url" VARCHAR, -- Enhanced Thread Details and Management
    "pinned" BOOLEAN, -- Enhanced Thread Details and Management
    "reaction_options" JSONB, -- Advanced Interaction Features
    "last_read_by_user" JSONB, -- Advanced Interaction Features
    "privacy_level" VARCHAR, -- Privacy and Security Enhancements
    "end_to_end_encryption" BOOLEAN, -- Privacy and Security Enhancements
    "member_limit" INTEGER, -- Group Management and Dynamics
    "active_participants" JSONB, -- Group Management and Dynamics
    "content_filters" JSONB, -- Content Curation and Accessibility
    "accessibility_features" JSONB, -- Content Curation and Accessibility
    "engagement_metrics" JSONB, -- Analytics and Insights
    "thread_health_score" FLOAT -- Analytics and Insights
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_direct_thread_last_activity_at ON "DirectThread" ("last_activity_at");
CREATE INDEX IF NOT EXISTS idx_direct_thread_muted ON "DirectThread" ("muted");
CREATE INDEX IF NOT EXISTS idx_direct_thread_pinned ON "DirectThread" ("pinned");
CREATE INDEX IF NOT EXISTS idx_direct_thread_privacy_level ON "DirectThread" ("privacy_level");

-- DirectThread_User Relationship table with additional refinements and features
CREATE TABLE IF NOT EXISTS "DirectThread_User" (
    "thread_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "user_role" VARCHAR, -- Role and Permissions
    "permissions" JSONB, -- Role and Permissions
    "join_date" TIMESTAMP, -- User Engagement and Interaction
    "last_interaction" TIMESTAMP, -- User Engagement and Interaction
    "notification_preferences" VARCHAR, -- Notification Management
    "mute_until" TIMESTAMP, -- Notification Management
    "privacy_setting" VARCHAR, -- Privacy and Accessibility
    "accessibility_options" JSONB, -- Privacy and Accessibility
    "content_contribution_count" INTEGER, -- Social Dynamics and Content Management
    "pinned_by_user" BOOLEAN, -- Social Dynamics and Content Management
    "engagement_score" FLOAT, -- Advanced Analytics and Insights
    "sentiment_analysis" JSONB, -- Advanced Analytics and Insights
    PRIMARY KEY ("thread_pk", "user_pk"),
    FOREIGN KEY ("thread_pk") REFERENCES "DirectThread" ("pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_direct_thread_user_thread_pk ON "DirectThread_User" ("thread_pk");
CREATE INDEX IF NOT EXISTS idx_direct_thread_user_user_pk ON "DirectThread_User" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_direct_thread_user_user_role ON "DirectThread_User" ("user_role");
CREATE INDEX IF NOT EXISTS idx_direct_thread_user_last_interaction ON "DirectThread_User" ("last_interaction");

-- Relationship table with additional refinements and features
CREATE TABLE IF NOT EXISTS "Relationship" (
    "user_pk" VARCHAR PRIMARY KEY,
    "blocking" BOOLEAN NOT NULL,
    "followed_by" BOOLEAN NOT NULL,
    "following" BOOLEAN NOT NULL,
    "incoming_request" BOOLEAN NOT NULL,
    "is_bestie" BOOLEAN NOT NULL,
    "is_blocking_reel" BOOLEAN NOT NULL,
    "is_muting_reel" BOOLEAN NOT NULL,
    "is_private" BOOLEAN NOT NULL,
    "is_restricted" BOOLEAN NOT NULL,
    "muting" BOOLEAN NOT NULL,
    "outgoing_request" BOOLEAN NOT NULL,
    "is_favorite" BOOLEAN, -- Expanded Relationship Types
    "is_hidden" BOOLEAN, -- Expanded Relationship Types
    "is_silenced" BOOLEAN, -- Enhanced Privacy and Security Features
    "is_anonymized" BOOLEAN, -- Enhanced Privacy and Security Features
    "trust_level" INTEGER, -- Relationship Dynamics
    "engagement_score" FLOAT, -- Relationship Dynamics
    "last_interaction_at" TIMESTAMP, -- Advanced Interaction Tracking
    "interaction_frequency" INTEGER, -- Advanced Interaction Tracking
    "shared_interests" JSONB, -- Social Networking Features
    "common_connections_count" INTEGER, -- Social Networking Features
    "content_visibility_preferences" JSONB, -- Content Preferences and Accessibility
    "accessibility_preferences" JSONB -- Content Preferences and Accessibility
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_relationship_user_pk ON "Relationship" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_relationship_blocking ON "Relationship" ("blocking");
CREATE INDEX IF NOT EXISTS idx_relationship_followed_by ON "Relationship" ("followed_by");
CREATE INDEX IF NOT EXISTS idx_relationship_following ON "Relationship" ("following");

-- Redefined Relationship_User table with expanded capabilities
CREATE TABLE IF NOT EXISTS "Relationship_User" (
    "relationship_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "target_user_pk" VARCHAR NOT NULL, -- Clarify Relationship Context
    PRIMARY KEY ("relationship_pk", "user_pk", "target_user_pk"),
    FOREIGN KEY ("relationship_pk") REFERENCES "Relationship" ("user_pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("target_user_pk") REFERENCES "User" ("pk"),
    "relationship_type" VARCHAR, -- Enhanced Relationship Details
    "status" VARCHAR, -- Enhanced Relationship Details
    "status_updated_at" TIMESTAMP, -- Enhanced Relationship Details
    "interaction_history" JSONB, -- Advanced Interaction and Engagement Tracking
    "engagement_level" FLOAT, -- Advanced Interaction and Engagement Tracking
    "privacy_settings" JSONB, -- Privacy and Notifications Control
    "notification_preferences" JSONB, -- Privacy and Notifications Control
    "common_interests" JSONB, -- Relationship Insights and Analytics
    "insights" JSONB -- Relationship Insights and Analytics
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_relationship_user_pk ON "Relationship_User" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_relationship_target_user_pk ON "Relationship_User" ("target_user_pk");
CREATE INDEX IF NOT EXISTS idx_relationship_relationship_pk ON "Relationship_User" ("relationship_pk");
CREATE INDEX IF NOT EXISTS idx_relationship_interaction_history ON "Relationship_User" USING GIN ("interaction_history");

-- Enhanced Media table with advanced features for content management, user engagement, and performance optimization
CREATE TABLE IF NOT EXISTS "Media" (
    "pk" VARCHAR PRIMARY KEY,
    "id" VARCHAR NOT NULL,
    "code" VARCHAR NOT NULL,
    "taken_at" TIMESTAMP NOT NULL,
    "media_type" INTEGER NOT NULL,
    "product_type" VARCHAR NOT NULL,
    "thumbnail_url" VARCHAR,
    "user_pk" VARCHAR NOT NULL,
    "comment_count" INTEGER NOT NULL,
    "comments_disabled" BOOLEAN NOT NULL,
    "commenting_disabled_for_viewer" BOOLEAN NOT NULL,
    "like_count" INTEGER NOT NULL,
    "play_count" INTEGER,
    "has_liked" BOOLEAN,
    "caption_text" TEXT NOT NULL,
    "alt_text" VARCHAR,
    "location_name" VARCHAR,
    "location_coordinates" GEOMETRY,
    "tags" JSONB,
    "quality_score" FLOAT,
    "reaction_count" JSONB,
    "save_count" INTEGER,
    "engagement_rate" FLOAT,
    "sentiment_score" FLOAT,
    "visibility" VARCHAR,
    "report_count" INTEGER,
    "expiration_date" TIMESTAMP,
    "is_archived" BOOLEAN,
    "title" VARCHAR NOT NULL,
    "story_pk" VARCHAR,
    "iso_speed" INTEGER,
    "aperture_value" FLOAT,
    "exposure_time" FLOAT,
    "shared_with_users" JSONB,
    "collaborator_ids" JSONB,
    "view_duration" FLOAT,
    "interactions_timeline" JSONB,
    "recommendation_score" FLOAT,
    "discoverability_flags" JSONB,
    "acl" JSONB,
    "verification_status" VARCHAR,
    "version_history" JSONB,
    "parent_media_id" VARCHAR,
    "original_source_url" VARCHAR,
    "content_hash" VARCHAR,
    "user_interaction_flags" JSONB,
    "custom_accessibility_settings" JSONB,
    "mentions" JSONB,
    "shared_count" INTEGER,
    "trend_participation_score" FLOAT,
    "viewer_demographics" JSONB,
    "usage_rights_information" JSONB,
    "take_down_requests" JSONB,
    "cdn_path" VARCHAR,
    "blur_on_demand" BOOLEAN,
    "expiration_warning" TIMESTAMP,
    "syndication_rights" VARCHAR,
    "external_embedding_allowed" BOOLEAN,
    "content_lifecycle_state" VARCHAR,
    "data_cleanup_policy" VARCHAR,
    "content_impact_score" FLOAT,
    "viewer_engagement_trends" JSONB,
    "engagement_prediction_score" FLOAT,
    "ml_tags" JSONB,
    "user_engagement_patterns" JSONB, -- Dynamic Content Personalization
    "content_performance_index" FLOAT, -- Dynamic Content Personalization
    "drm_info" JSONB, -- Content Authenticity and Trust
    "trust_score" FLOAT, -- Content Authenticity and Trust
    "syndication_metadata" JSONB, -- Advanced Syndication Control
    "cross_platform_sharing_score" FLOAT, -- Advanced Syndication Control
    "adaptive_indexing_strategy" JSONB, -- Operational and Technical Scalability
    "automated_content_archiving" JSONB, -- Operational and Technical Scalability
    "predictive_expiration" TIMESTAMP, -- Proactive Content Management
    "restoration_flag" BOOLEAN, -- Proactive Content Management
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_taken_at ON "Media" ("taken_at");
CREATE INDEX IF NOT EXISTS idx_media_media_type ON "Media" ("media_type");
CREATE INDEX IF NOT EXISTS idx_media_user_pk ON "Media" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_media_location_name ON "Media" ("location_name");
CREATE INDEX IF NOT EXISTS idx_media_tags ON "Media" USING GIN ("tags");

-- Media_Usertag Relationship table (Many-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Usertag" (
    "media_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "x" FLOAT NOT NULL,
    "y" FLOAT NOT NULL,
    "tag_type" VARCHAR, -- Enhanced Tagging Features
    "tagged_at" TIMESTAMP, -- Enhanced Tagging Features
    "visibility_status" VARCHAR, -- Enhanced Tagging Features
    "tag_approval" BOOLEAN, -- Advanced User Engagement
    "engagement_metric" FLOAT, -- Advanced User Engagement
    "relationship_context" VARCHAR, -- Social Interaction and Networking
    "notification_sent" BOOLEAN, -- Social Interaction and Networking
    "tag_importance" INTEGER, -- Content Discovery and Curation
    "tags" JSONB, -- Content Discovery and Curation
    "tagged_entity_id" VARCHAR, -- Data Integrity and Management
    PRIMARY KEY ("media_pk", "user_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_usertag_media_pk ON "Media_Usertag" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_usertag_user_pk ON "Media_Usertag" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_media_usertag_tag_type ON "Media_Usertag" ("tag_type");
CREATE INDEX IF NOT EXISTS idx_media_usertag_visibility_status ON "Media_Usertag" ("visibility_status");

-- Media_Sponsor Relationship table (Many-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Sponsor" (
    "media_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "sponsorship_type" VARCHAR, -- Sponsorship Details Enhancement
    "sponsorship_agreement_id" VARCHAR, -- Sponsorship Details Enhancement
    "campaign_id" VARCHAR, -- Content and Campaign Tracking
    "content_delivery_status" VARCHAR, -- Content and Campaign Tracking
    "engagement_target" FLOAT, -- Engagement and Performance Metrics
    "performance_score" FLOAT, -- Engagement and Performance Metrics
    "visibility_level" VARCHAR, -- Sponsorship Visibility and Consent
    "user_consent" BOOLEAN, -- Sponsorship Visibility and Consent
    "sponsor_engagement_insights" JSONB, -- Advanced Analytics and Insights
    "impact_analysis" JSONB, -- Advanced Analytics and Insights
    "compliance_status" VARCHAR, -- Operational and Legal Compliance
    "audit_trail" JSONB, -- Operational and Legal Compliance
    PRIMARY KEY ("media_pk", "user_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_sponsor_media_pk ON "Media_Sponsor" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_sponsor_user_pk ON "Media_Sponsor" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_media_sponsor_campaign_id ON "Media_Sponsor" ("campaign_id");
CREATE INDEX IF NOT EXISTS idx_media_sponsor_performance_score ON "Media_Sponsor" ("performance_score");

-- Media_Resource Relationship table (Many-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Resource" (
    "media_pk" VARCHAR NOT NULL,
    "resource_pk" VARCHAR NOT NULL,
    "resource_type" VARCHAR, -- Resource Metadata and Management
    "resource_description" TEXT, -- Resource Metadata and Management
    "cdn_path" VARCHAR, -- Content Delivery and Performance Optimization
    "file_size" INTEGER, -- Content Delivery and Performance Optimization
    "accessibility_features" JSONB, -- Accessibility and Internationalization
    "language_code" VARCHAR, -- Accessibility and Internationalization
    "version" INTEGER, -- Version Control and Historical Tracking
    "deprecated" BOOLEAN, -- Version Control and Historical Tracking
    PRIMARY KEY ("media_pk", "resource_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("resource_pk") REFERENCES "Resource" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_resource_media_pk ON "Media_Resource" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_resource_resource_pk ON "Media_Resource" ("resource_pk");

-- Media_Comment Relationship table (One-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Comment" (
    "media_pk" VARCHAR NOT NULL,
    "comment_pk" VARCHAR NOT NULL,
    "comment_order" INTEGER, -- Enhanced Comment Management
    "is_pinned" BOOLEAN, -- Enhanced Comment Management
    "reaction_count" JSONB, -- User Interaction and Engagement
    "reply_count" INTEGER, -- User Interaction and Engagement
    "moderation_status" VARCHAR, -- Content Moderation and Compliance
    "flagged_by_users" JSONB, -- Content Moderation and Compliance
    "sentiment_score" FLOAT, -- Analytical Insights
    "engagement_impact" FLOAT, -- Analytical Insights
    "last_interaction_at" TIMESTAMP, -- Temporal Dynamics
    "parent_comment_pk" VARCHAR, -- Threaded Comments and Hierarchical Structure
    "user_mention_ids" JSONB, -- User Engagement and Interaction
    "is_hidden" BOOLEAN, -- User Engagement and Interaction
    "keywords" JSONB, -- Content Discovery and Recommendation
    "automated_moderation_flags" JSONB, -- Comprehensive Moderation Tools
    "moderation_notes" TEXT, -- Comprehensive Moderation Tools
    "engagement_profile" JSONB, -- In-depth Analytical Insights
    PRIMARY KEY ("media_pk", "comment_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("comment_pk") REFERENCES "Comment" ("pk"),
    FOREIGN KEY ("parent_comment_pk") REFERENCES "Media_Comment" ("comment_pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_comment_media_pk ON "Media_Comment" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_comment_comment_pk ON "Media_Comment" ("comment_pk");
CREATE INDEX IF NOT EXISTS idx_media_comment_moderation_status ON "Media_Comment" ("moderation_status");
CREATE INDEX IF NOT EXISTS idx_media_comment_sentiment_score ON "Media_Comment" ("sentiment_score");
CREATE INDEX IF NOT EXISTS idx_media_comment_parent_comment_pk ON "Media_Comment" ("parent_comment_pk");

-- Media_Location Relationship table (One-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Location" (
    "media_pk" VARCHAR NOT NULL,
    "location_pk" VARCHAR NOT NULL,
    "location_type" VARCHAR, -- Enhanced Location Details and Metadata
    "location_visibility" VARCHAR, -- Enhanced Location Details and Metadata
    "check_in_count" INTEGER, -- Location-based Engagement and Interaction
    "user_engagement_score" FLOAT, -- Location-based Engagement and Interaction
    "location_keywords" JSONB, -- Content Discovery and Recommendation
    "trending_score" FLOAT, -- Content Discovery and Recommendation
    "location_sentiment_score" FLOAT, -- Advanced Analytical Insights
    "geographical_trends" JSONB, -- Advanced Analytical Insights
    "historical_popularity_index" JSONB, -- Operational Efficiency and Data Management
    "last_updated_at" TIMESTAMP, -- Operational Efficiency and Data Management
    PRIMARY KEY ("media_pk", "location_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("location_pk") REFERENCES "Location" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_location_media_pk ON "Media_Location" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_location_location_pk ON "Media_Location" ("location_pk");
CREATE INDEX IF NOT EXISTS idx_media_location_location_type ON "Media_Location" ("location_type");
CREATE INDEX IF NOT EXISTS idx_media_location_trending_score ON "Media_Location" ("trending_score");
CREATE INDEX IF NOT EXISTS idx_media_location_location_sentiment_score ON "Media_Location" ("location_sentiment_score");

-- Media_Story Relationship table (Many-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Story" (
    "media_pk" VARCHAR NOT NULL,
    "story_pk" VARCHAR NOT NULL,
    "story_sequence" INTEGER, -- Story Engagement and Narration Enhancement
    "duration_on_story" INTEGER, -- Story Engagement and Narration Enhancement
    "is_featured" BOOLEAN, -- Content Discovery and Personalization
    "personalization_flags" JSONB, -- Content Discovery and Personalization
    "view_count" INTEGER, -- Analytical Insights and Performance Metrics
    "engagement_metrics" JSONB, -- Analytical Insights and Performance Metrics
    "is_archived" BOOLEAN, -- Operational Efficiency and Content Management
    "expiration_timestamp" TIMESTAMP, -- Operational Efficiency and Content Management
    "interactive_elements" JSONB, -- Advanced Storytelling Features
    "narrative_context" TEXT, -- Advanced Storytelling Features
    PRIMARY KEY ("media_pk", "story_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_story_media_pk ON "Media_Story" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_story_story_pk ON "Media_Story" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_media_story_story_sequence ON "Media_Story" ("story_sequence");
CREATE INDEX IF NOT EXISTS idx_media_story_view_count ON "Media_Story" ("view_count");

-- Media_Hashtag Relationship table (Many-to-Many) with advanced features
CREATE TABLE IF NOT EXISTS "Media_Hashtag" (
    "media_pk" VARCHAR NOT NULL,
    "hashtag_pk" VARCHAR NOT NULL,
    "hashtag_impact_score" FLOAT, -- Hashtag Influence and Reach
    "is_trending" BOOLEAN, -- Hashtag Influence and Reach
    "user_interaction_count" INTEGER, -- User Engagement and Content Curation
    "is_curated" BOOLEAN, -- User Engagement and Content Curation
    "engagement_rate_by_hashtag" FLOAT, -- Analytical Insights and Performance Metrics
    "visibility_and_reach" JSONB, -- Analytical Insights and Performance Metrics
    "hashtag_category" VARCHAR, -- Content Discovery and Personalization
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "contextual_relevance" TEXT, -- Contextual and Temporal Tagging
    "tagged_at" TIMESTAMP, -- Contextual and Temporal Tagging
    "performance_over_time" JSONB, -- Dynamic Hashtag Performance Tracking
    "geo_impact" JSONB, -- Dynamic Hashtag Performance Tracking
    "engagement_types_breakdown" JSONB, -- Advanced User Engagement Insights
    "influencer_impact" JSONB, -- Advanced User Engagement Insights
    "discovery_paths" JSONB, -- Content Discovery Enhancements
    "related_hashtags" JSONB, -- Content Discovery Enhancements
    "tag_lifecycle_status" VARCHAR, -- Operational and Data Management Improvements
    "audit_trail" JSONB, -- Operational and Data Management Improvements
    PRIMARY KEY ("media_pk", "hashtag_pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("hashtag_pk") REFERENCES "Hashtag" ("id")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_media_hashtag_media_pk ON "Media_Hashtag" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_media_hashtag_hashtag_pk ON "Media_Hashtag" ("hashtag_pk");
CREATE INDEX IF NOT EXISTS idx_media_hashtag_hashtag_impact_score ON "Media_Hashtag" ("hashtag_impact_score");
CREATE INDEX IF NOT EXISTS idx_media_hashtag_is_trending ON "Media_Hashtag" ("is_trending");
CREATE INDEX IF NOT EXISTS idx_media_hashtag_engagement_rate_by_hashtag ON "Media_Hashtag" ("engagement_rate_by_hashtag");

-- Story table with advanced features
CREATE TABLE IF NOT EXISTS "Story" (
    "pk" VARCHAR PRIMARY KEY,
    "id" VARCHAR NOT NULL,
    "code" VARCHAR NOT NULL,
    "taken_at" TIMESTAMP NOT NULL,
    "imported_taken_at" TIMESTAMP,
    "media_type" INTEGER NOT NULL,
    "product_type" VARCHAR NOT NULL,
    "thumbnail_url" VARCHAR,
    "user_pk" VARCHAR NOT NULL,
    "video_url" VARCHAR,
    "video_duration" FLOAT NOT NULL,
    "is_paid_partnership" BOOLEAN,
    "caption_text" TEXT NOT NULL,
    "content_format" VARCHAR, -- Rich Media and Interaction Enhancements
    "interactivity_features" JSONB, -- Rich Media and Interaction Enhancements
    "visibility" VARCHAR, -- Content Discovery and Personalization
    "audience_engagement_score" FLOAT, -- Content Discovery and Personalization
    "view_count" INTEGER, -- Analytical Insights and Performance Metrics
    "completion_rate" FLOAT, -- Analytical Insights and Performance Metrics
    "expiration_date" TIMESTAMP, -- Temporal and Geographic Tagging
    "location_tag" VARCHAR, -- Temporal and Geographic Tagging
    "mentions" JSONB, -- Advanced Storytelling Features
    "cover_image_url" VARCHAR, -- Advanced Storytelling Features
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "content_source" VARCHAR, -- Operational Efficiency and Data Management
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_user_pk ON "Story" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_story_taken_at ON "Story" ("taken_at");
CREATE INDEX IF NOT EXISTS idx_story_visibility ON "Story" ("visibility");
CREATE INDEX IF NOT EXISTS idx_story_audience_engagement_score ON "Story" ("audience_engagement_score");

-- Story_User Relationship table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_User" (
    "story_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "view_status" VARCHAR, -- User Engagement and Content Personalization
    "reaction_type" VARCHAR, -- User Engagement and Content Personalization
    "access_level" VARCHAR, -- Privacy and Access Control
    "is_blocked" BOOLEAN, -- Privacy and Access Control
    "discovery_method" VARCHAR, -- Content Discovery and Recommendation
    "interest_score" FLOAT, -- Content Discovery and Recommendation
    "view_timestamp" TIMESTAMP, -- Analytical Insights and User Behavior
    "engagement_duration" INTEGER, -- Analytical Insights and User Behavior
    "shared_with_users" JSONB, -- Social Interactions and Community Building
    "view_history" JSONB, -- Operational Efficiency and Data Management
    PRIMARY KEY ("story_pk", "user_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_user_story_pk ON "Story_User" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_user_user_pk ON "Story_User" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_story_user_view_status ON "Story_User" ("view_status");
CREATE INDEX IF NOT EXISTS idx_story_user_interest_score ON "Story_User" ("interest_score");

-- Story_Usertag Relationship table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Usertag" (
    "story_pk" VARCHAR NOT NULL,
    "usertag_user_pk" VARCHAR NOT NULL,
    "position_x" FLOAT, -- Enhanced Tagging Details
    "position_y" FLOAT, -- Enhanced Tagging Details
    "display_name" VARCHAR, -- Enhanced Tagging Details
    "interaction_type" VARCHAR, -- Interaction and Engagement Insights
    "engagement_timestamp" TIMESTAMP, -- Interaction and Engagement Insights
    "visibility" VARCHAR, -- Social Dynamics and Visibility
    "approval_status" BOOLEAN, -- Social Dynamics and Visibility
    "relevance_score" FLOAT, -- Content Discovery and Recommendation
    "tagged_at" TIMESTAMP, -- Operational Efficiency and Data Integrity
    "tag_status" VARCHAR, -- Operational Efficiency and Data Integrity
    PRIMARY KEY ("story_pk", "usertag_user_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("usertag_user_pk") REFERENCES "Usertag" ("user_pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_usertag_story_pk ON "Story_Usertag" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_usertag_usertag_user_pk ON "Story_Usertag" ("usertag_user_pk");
CREATE INDEX IF NOT EXISTS idx_story_usertag_visibility ON "Story_Usertag" ("visibility");
CREATE INDEX IF NOT EXISTS idx_story_usertag_approval_status ON "Story_Usertag" ("approval_status");

-- Story_Hashtag Relationship table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Hashtag" (
    "story_pk" VARCHAR NOT NULL,
    "hashtag_pk" VARCHAR NOT NULL,
    "visibility" VARCHAR, -- Content Discoverability and Reach
    "engagement_metrics" JSONB, -- Content Discoverability and Reach
    "click_through_rate" FLOAT, -- Audience Engagement and Interaction
    "user_interaction_count" INTEGER, -- Audience Engagement and Interaction
    "is_trending" BOOLEAN, -- Analytical Insights and Hashtag Performance
    "hashtag_impact_score" FLOAT, -- Analytical Insights and Hashtag Performance
    "tagged_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "contextual_relevance" TEXT, -- Advanced Tagging Features
    "hashtag_category" VARCHAR, -- Advanced Tagging Features
    PRIMARY KEY ("story_pk", "hashtag_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("hashtag_pk") REFERENCES "Hashtag" ("id")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_hashtag_story_pk ON "Story_Hashtag" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_hashtag_hashtag_pk ON "Story_Hashtag" ("hashtag_pk");
CREATE INDEX IF NOT EXISTS idx_story_hashtag_visibility ON "Story_Hashtag" ("visibility");
CREATE INDEX IF NOT EXISTS idx_story_hashtag_is_trending ON "Story_Hashtag" ("is_trending");
CREATE INDEX IF NOT EXISTS idx_story_hashtag_hashtag_impact_score ON "Story_Hashtag" ("hashtag_impact_score");

-- Story_Location Relationship table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Location" (
    "story_pk" VARCHAR NOT NULL,
    "location_pk" VARCHAR NOT NULL,
    "location_type" VARCHAR, -- Enhanced Location Details and Story Interaction
    "interaction_count" INTEGER, -- Enhanced Location Details and Story Interaction
    "visibility" VARCHAR, -- Geographical Insights and Content Personalization
    "engagement_metrics" JSONB, -- Geographical Insights and Content Personalization
    "discovery_method" VARCHAR, -- Audience Engagement and Content Discovery
    "audience_demographics" JSONB, -- Audience Engagement and Content Discovery
    "tagged_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "local_popularity_score" FLOAT, -- Location-Based Content Strategies
    "is_trending" BOOLEAN, -- Location-Based Content Strategies
    PRIMARY KEY ("story_pk", "location_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("location_pk") REFERENCES "Location" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_location_story_pk ON "Story_Location" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_location_location_pk ON "Story_Location" ("location_pk");
CREATE INDEX IF NOT EXISTS idx_story_location_visibility ON "Story_Location" ("visibility");
CREATE INDEX IF NOT EXISTS idx_story_location_local_popularity_score ON "Story_Location" ("local_popularity_score");
CREATE INDEX IF NOT EXISTS idx_story_location_is_trending ON "Story_Location" ("is_trending");

-- Story_Sticker Relationship table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Sticker" (
    "story_pk" VARCHAR NOT NULL,
    "sticker_pk" VARCHAR NOT NULL,
    "sticker_type" VARCHAR, -- Enhanced Sticker Details and Interaction
    "user_interaction" JSONB, -- Enhanced Sticker Details and Interaction
    "visibility" VARCHAR, -- Dynamic Content and Personalization
    "personalization_options" JSONB, -- Dynamic Content and Personalization
    "engagement_metrics" JSONB, -- Analytical Insights and Performance Metrics
    "conversion_rate" FLOAT, -- Analytical Insights and Performance Metrics
    "mentioned_users" JSONB, -- Social Interactions and Community Building
    "shared_with_users" JSONB, -- Social Interactions and Community Building
    "added_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "sticker_status" VARCHAR, -- Operational Efficiency and Data Management
    PRIMARY KEY ("story_pk", "sticker_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("sticker_pk") REFERENCES "StorySticker" ("id")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_sticker_story_pk ON "Story_Sticker" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_sticker_sticker_pk ON "Story_Sticker" ("sticker_pk");
CREATE INDEX IF NOT EXISTS idx_story_sticker_sticker_type ON "Story_Sticker" ("sticker_type");
CREATE INDEX IF NOT EXISTS idx_story_sticker_visibility ON "Story_Sticker" ("visibility");

-- Link table with enhanced features
CREATE TABLE IF NOT EXISTS "Link" (
    "id" VARCHAR PRIMARY KEY,
    "url" VARCHAR, -- Comprehensive Link Attributes
    "title" VARCHAR, -- Comprehensive Link Attributes
    "description" TEXT, -- Comprehensive Link Attributes
    "thumbnail_url" VARCHAR, -- Comprehensive Link Attributes
    "link_type" VARCHAR, -- Link Type and Categorization
    "tags" JSONB, -- Link Type and Categorization
    "click_count" INTEGER, -- Engagement and Analytics
    "engagement_metrics" JSONB, -- Engagement and Analytics
    "is_verified" BOOLEAN, -- Security and Validation
    "expiration_date" TIMESTAMP, -- Security and Validation
    "created_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "updated_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "access_restrictions" JSONB, -- Advanced Features
    "embedding_options" JSONB -- Advanced Features
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_link_url ON "Link" ("url");
CREATE INDEX IF NOT EXISTS idx_link_link_type ON "Link" ("link_type");
CREATE INDEX IF NOT EXISTS idx_link_click_count ON "Link" ("click_count");
CREATE INDEX IF NOT EXISTS idx_link_is_verified ON "Link" ("is_verified");

-- Story_Link table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Link" (
    "story_pk" VARCHAR NOT NULL,
    "link_pk" VARCHAR NOT NULL,
    "link_order" INTEGER, -- Link Integration and Interaction
    "interaction_type" VARCHAR, -- Link Integration and Interaction
    "click_count" INTEGER, -- Analytical Insights and Engagement
    "engagement_timestamp" TIMESTAMP, -- Analytical Insights and Engagement
    "visibility" VARCHAR, -- Content Personalization and Discovery
    "audience_engagement_score" FLOAT, -- Content Personalization and Discovery
    "added_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "status" VARCHAR, -- Operational Efficiency and Data Management
    "custom_display_options" JSONB, -- Advanced Features and Customization
    "expiration_date" TIMESTAMP, -- Advanced Features and Customization
    PRIMARY KEY ("story_pk", "link_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("link_pk") REFERENCES "Link" ("id")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_link_story_pk ON "Story_Link" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_link_link_pk ON "Story_Link" ("link_pk");
CREATE INDEX IF NOT EXISTS idx_story_link_click_count ON "Story_Link" ("click_count");
CREATE INDEX IF NOT EXISTS idx_story_link_visibility ON "Story_Link" ("visibility");


-- Story_Comment table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Comment" (
    "story_pk" VARCHAR NOT NULL,
    "comment_pk" VARCHAR NOT NULL,
    "comment_order" INTEGER, -- Comment Interaction and Engagement
    "is_pinned" BOOLEAN, -- Comment Interaction and Engagement
    "reaction_count" JSONB, -- Analytical Insights and User Behavior
    "reply_count" INTEGER, -- Analytical Insights and User Behavior
    "moderation_status" VARCHAR, -- Content Moderation and Compliance
    "flagged_by_users" JSONB, -- Content Moderation and Compliance
    "commented_at" TIMESTAMP, -- Temporal Dynamics and Historical Analysis
    "last_edited_at" TIMESTAMP, -- Temporal Dynamics and Historical Analysis
    "visibility" VARCHAR, -- Operational Efficiency and Data Management
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "mentions" JSONB, -- Advanced Features for Community Engagement
    "sentiment_score" FLOAT, -- Advanced Features for Community Engagement
    PRIMARY KEY ("story_pk", "comment_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("comment_pk") REFERENCES "Comment" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_comment_story_pk ON "Story_Comment" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_comment_comment_pk ON "Story_Comment" ("comment_pk");
CREATE INDEX IF NOT EXISTS idx_story_comment_moderation_status ON "Story_Comment" ("moderation_status");
CREATE INDEX IF NOT EXISTS idx_story_comment_visibility ON "Story_Comment" ("visibility");

-- Story_Highlight table with enhanced features
CREATE TABLE IF NOT EXISTS "Story_Highlight" (
    "story_pk" VARCHAR NOT NULL,
    "highlight_pk" VARCHAR NOT NULL,
    "highlight_order" INTEGER, -- Highlight Organization and Customization
    "customization_options" JSONB, -- Highlight Organization and Customization
    "view_count" INTEGER, -- Engagement and Interaction Insights
    "engagement_metrics" JSONB, -- Engagement and Interaction Insights
    "expiration_date" TIMESTAMP, -- Content Lifespan and Accessibility
    "accessibility_settings" JSONB, -- Content Lifespan and Accessibility
    "added_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "is_featured" BOOLEAN, -- Advanced Features for Content Strategy
    "user_interaction_history" JSONB, -- Advanced Features for Content Strategy
    PRIMARY KEY ("story_pk", "highlight_pk"),
    FOREIGN KEY ("story_pk") REFERENCES "Story" ("pk"),
    FOREIGN KEY ("highlight_pk") REFERENCES "Highlight" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_story_highlight_story_pk ON "Story_Highlight" ("story_pk");
CREATE INDEX IF NOT EXISTS idx_story_highlight_highlight_pk ON "Story_Highlight" ("highlight_pk");
CREATE INDEX IF NOT EXISTS idx_story_highlight_view_count ON "Story_Highlight" ("view_count");

-- Comment table with enhanced features
CREATE TABLE IF NOT EXISTS "Comment" (
    "pk" VARCHAR PRIMARY KEY,
    "text" TEXT NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    "media_pk" VARCHAR,
    "created_at" TIMESTAMP NOT NULL,
    "edited_at" TIMESTAMP, -- Operational Efficiency and Historical Tracking
    "edit_history" JSONB, -- Operational Efficiency and Historical Tracking
    "status" VARCHAR NOT NULL,
    "comment_type" VARCHAR NOT NULL,
    "likes_count" INTEGER DEFAULT 0, -- Enhanced Engagement and Interaction
    "reply_to_comment_pk" VARCHAR, -- Enhanced Engagement and Interaction
    "mentions" JSONB, -- User Experience and Content Discovery
    "hashtags" JSONB, -- User Experience and Content Discovery
    "flagged_by" JSONB, -- Content Moderation and Compliance
    "moderation_review" VARCHAR, -- Content Moderation and Compliance
    "sentiment_score" FLOAT, -- Analytical Insights and Performance
    "engagement_metrics" JSONB, -- Analytical Insights and Performance
    "visibility" VARCHAR, -- Security and Privacy Enhancements
    "is_deleted" BOOLEAN, -- Security and Privacy Enhancements
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    FOREIGN KEY ("media_pk") REFERENCES "Media" ("pk"),
    FOREIGN KEY ("reply_to_comment_pk") REFERENCES "Comment" ("pk")
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_comment_user_pk ON "Comment" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_comment_media_pk ON "Comment" ("media_pk");
CREATE INDEX IF NOT EXISTS idx_comment_likes_count ON "Comment" ("likes_count");
CREATE INDEX IF NOT EXISTS idx_comment_created_at ON "Comment" ("created_at");

-- Comment_Reply table with enhanced features
CREATE TABLE IF NOT EXISTS "Comment_Reply" (
    "parent_comment_pk" VARCHAR NOT NULL,
    "reply_comment_pk" VARCHAR NOT NULL,
    PRIMARY KEY ("parent_comment_pk", "reply_comment_pk"),
    FOREIGN KEY ("parent_comment_pk") REFERENCES "Comment" ("pk"),
    FOREIGN KEY ("reply_comment_pk") REFERENCES "Comment" ("pk"),
    "reply_depth" INTEGER, -- Enhanced Interaction and User Experience
    "reply_order" INTEGER, -- Enhanced Interaction and User Experience
    "likes_count" INTEGER DEFAULT 0, -- Engagement Metrics and Analysis
    "engagement_timestamps" JSONB, -- Engagement Metrics and Analysis
    "is_flagged" BOOLEAN, -- Content Moderation and Compliance
    "moderation_status" VARCHAR, -- Content Moderation and Compliance
    "mentioned_users" JSONB, -- Community Building and Personalization
    "hashtags" JSONB, -- Community Building and Personalization
    "edited_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "is_archived" BOOLEAN -- Operational Efficiency and Data Management
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_comment_reply_parent_comment_pk ON "Comment_Reply" ("parent_comment_pk");
CREATE INDEX IF NOT EXISTS idx_comment_reply_reply_comment_pk ON "Comment_Reply" ("reply_comment_pk");
CREATE INDEX IF NOT EXISTS idx_comment_reply_reply_depth ON "Comment_Reply" ("reply_depth");
CREATE INDEX IF NOT EXISTS idx_comment_reply_likes_count ON "Comment_Reply" ("likes_count");

-- Comment_Mention table with enhanced features
CREATE TABLE IF NOT EXISTS "Comment_Mention" (
    "comment_pk" VARCHAR NOT NULL,
    "user_pk" VARCHAR NOT NULL,
    PRIMARY KEY ("comment_pk", "user_pk"),
    FOREIGN KEY ("comment_pk") REFERENCES "Comment" ("pk"),
    FOREIGN KEY ("user_pk") REFERENCES "User" ("pk"),
    "context" TEXT, -- Contextualization and User Experience
    "mention_type" VARCHAR, -- Contextualization and User Experience
    "notification_status" VARCHAR, -- Engagement and Notification Management
    "acknowledged_at" TIMESTAMP, -- Engagement and Notification Management
    "accessibility_info" JSONB, -- Content Discovery and Accessibility
    "added_at" TIMESTAMP, -- Operational Efficiency and Data Management
    "is_archived" BOOLEAN, -- Operational Efficiency and Data Management
    "interaction_outcome" VARCHAR, -- Advanced Analytics and User Interaction Insights
    "engagement_metrics" JSONB -- Advanced Analytics and User Interaction Insights
);

-- Indexes for optimization
CREATE INDEX IF NOT EXISTS idx_comment_mention_comment_pk ON "Comment_Mention" ("comment_pk");
CREATE INDEX IF NOT EXISTS idx_comment_mention_user_pk ON "Comment_Mention" ("user_pk");
CREATE INDEX IF NOT EXISTS idx_comment_mention_notification_status ON "Comment_Mention" ("notification_status");

-- Add constants
-- Constants table
CREATE TABLE IF NOT EXISTS "Constants" (
    "name" VARCHAR PRIMARY KEY,
    "value" VARCHAR NOT NULL
);

-- Insert API_DOMAIN constant
INSERT INTO "Constants" ("name", "value") VALUES ('API_DOMAIN', 'i.instagram.com') ON CONFLICT DO NOTHING;

-- Insert USER_AGENT_BASE constant
INSERT INTO "Constants" ("name", "value") VALUES ('USER_AGENT_BASE', 'Instagram {app_version} Android ({android_version}/{android_release}; {dpi}; {resolution}; {manufacturer}; {model}; {device}; {cpu}; {locale}; {version_code})') ON CONFLICT DO NOTHING;

-- Insert SOFTWARE constant
INSERT INTO "Constants" ("name", "value") VALUES ('SOFTWARE', '{model}-user+{android_release}+OPR1.170623.032+V10.2.3.0.OAGMIXM+release-keys') ON CONFLICT DO NOTHING;

-- Insert QUERY_HASH constants
INSERT INTO "Constants" ("name", "value") VALUES
    ('QUERY_HASH_PROFILE', 'c9100bf9110dd6361671f113dd02e7d6'),
    ('QUERY_HASH_MEDIAS', '42323d64886122307be10013ad2dcc44'),
    ('QUERY_HASH_IGTVS', 'bc78b344a68ed16dd5d7f264681c4c76'),
    ('QUERY_HASH_STORIES', '5ec1d322b38839230f8e256e1f638d5f'),
    ('QUERY_HASH_HIGHLIGHTS_FOLDERS', 'ad99dd9d3646cc3c0dda65debcd266a7'),
    ('QUERY_HASH_HIGHLIGHTS_STORIES', '5ec1d322b38839230f8e256e1f638d5f'),
    ('QUERY_HASH_FOLLOWERS', 'c76146de99bb02f6415203be841dd25a'),
    ('QUERY_HASH_FOLLOWINGS', 'd04b0a864b4b54837c0d870b0e77e076'),
    ('QUERY_HASH_HASHTAG', '174a5243287c5f3a7de741089750ab3b'),
    ('QUERY_HASH_COMMENTS', '33ba35852cb50da46f5b5e889df7d159'),
    ('QUERY_HASH_TAGGED_MEDIAS', 'be13233562af2d229b008d2976b998b5') ON CONFLICT DO NOTHING;

-- Insert LOGIN_EXPERIMENTS constant
INSERT INTO "Constants" ("name", "value") VALUES ('LOGIN_EXPERIMENTS', 'ig_android_reg_nux_headers_cleanup_universe,ig_android_device_detection_info_upload,ig_android_nux_add_email_device,ig_android_gmail_oauth_in_reg,ig_android_device_info_foreground_reporting,ig_android_device_verification_fb_signup,ig_android_direct_main_tab_universe_v2,ig_android_passwordless_account_password_creation_universe,ig_android_direct_add_direct_to_android_native_photo_share_sheet,ig_growth_android_profile_pic_prefill_with_fb_pic_2,ig_account_identity_logged_out_signals_global_holdout_universe,ig_android_quickcapture_keep_screen_on,ig_android_device_based_country_verification,ig_android_login_identifier_fuzzy_match,ig_android_reg_modularization_universe,ig_android_security_intent_switchoff,ig_android_device_verification_separate_endpoint,ig_android_suma_landing_page,ig_android_sim_info_upload,ig_android_smartlock_hints_universe,ig_android_fb_account_linking_sampling_freq_universe,ig_android_retry_create_account_universe,ig_android_caption_typeahead_fix_on_o_universe') ON CONFLICT DO NOTHING;

-- Insert SUPPORTED_CAPABILITIES constant
INSERT INTO "Constants" ("name", "value") VALUES
    ('SUPPORTED_SDK_VERSIONS', '119.0,120.0,121.0,122.0,123.0,124.0,125.0,126.0'),
    ('FACE_TRACKER_BUILD', '2020110901'),
    ('BUILD_DISPLAY', 'RQ1A.210205.004'),
    ('SUPPORTED_ABIS', 'arm64-v8a;armeabi-v7a;armeabi') ON CONFLICT DO NOTHING;
