--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: instagram; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA instagram;


ALTER SCHEMA instagram OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: BioLink; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."BioLink"
(
    link_id                               character varying NOT NULL,
    url                                   character varying NOT NULL,
    lynx_url                              character varying,
    link_type                             character varying,
    title                                 character varying,
    description                           text,
    display_text                          character varying,
    is_pinned                             boolean,
    open_external_url_with_in_app_browser boolean,
    click_count                           integer DEFAULT 0,
    last_clicked                          timestamp without time zone,
    referrer                              character varying,
    is_active                             boolean DEFAULT true,
    expiration_date                       timestamp without time zone,
    thumbnail_url                         character varying,
    tags                                  text,
    priority_order                        integer,
    is_verified                           boolean,
    shortened_url                         character varying,
    accessibility_label                   character varying,
    compliance_flags                      jsonb
);


ALTER TABLE instagram."BioLink"
    OWNER TO postgres;

--
-- Name: Collection; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Collection"
(
    id                   character varying NOT NULL,
    name                 character varying NOT NULL,
    type                 character varying NOT NULL,
    media_count          integer           NOT NULL,
    description          text,
    visibility           character varying,
    created_at           timestamp without time zone,
    updated_at           timestamp without time zone,
    like_count           integer,
    share_count          integer,
    view_count           integer,
    tags                 jsonb,
    cover_image_url      character varying,
    sort_order           character varying,
    custom_attributes    jsonb,
    collaborators        jsonb,
    parent_collection_id character varying,
    owner_id             character varying,
    moderation_status    character varying
);


ALTER TABLE instagram."Collection"
    OWNER TO postgres;

--
-- Name: Comment; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Comment"
(
    pk                    character varying           NOT NULL,
    text                  text                        NOT NULL,
    user_pk               character varying           NOT NULL,
    created_at_utc        timestamp without time zone NOT NULL,
    edited_at             timestamp without time zone,
    edit_history          jsonb,
    accessibility_caption text,
    content_type          character varying           NOT NULL,
    status                character varying           NOT NULL,
    replied_to_comment_id character varying,
    reply_count           integer,
    share_count           integer,
    moderation_status     character varying,
    flags                 integer,
    tags                  jsonb,
    sentiment_score       double precision,
    mentions              jsonb,
    parent_media_id       character varying,
    visibility            character varying,
    is_anonymous          boolean,
    has_liked             boolean,
    like_count            integer,
    engagement_metrics    jsonb,
    media_pk              character varying,
    likes_count           character varying,
    created_at            character varying
);


ALTER TABLE instagram."Comment"
    OWNER TO postgres;

--
-- Name: Comment_Mention; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Comment_Mention"
(
    comment_pk          character varying NOT NULL,
    user_pk             character varying NOT NULL,
    context             text,
    mention_type        character varying,
    notification_status character varying,
    acknowledged_at     timestamp without time zone,
    accessibility_info  jsonb,
    added_at            timestamp without time zone,
    is_archived         boolean,
    interaction_outcome character varying,
    engagement_metrics  jsonb
);


ALTER TABLE instagram."Comment_Mention"
    OWNER TO postgres;

--
-- Name: Comment_Reply; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Comment_Reply"
(
    parent_comment_pk     character varying NOT NULL,
    reply_comment_pk      character varying NOT NULL,
    reply_depth           integer,
    reply_order           integer,
    likes_count           integer DEFAULT 0,
    engagement_timestamps jsonb,
    is_flagged            boolean,
    moderation_status     character varying,
    mentioned_users       jsonb,
    hashtags              jsonb,
    edited_at             timestamp without time zone,
    is_archived           boolean
);


ALTER TABLE instagram."Comment_Reply"
    OWNER TO postgres;

--
-- Name: Constants; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Constants"
(
    name  character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE instagram."Constants"
    OWNER TO postgres;

--
-- Name: DirectMessage; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."DirectMessage"
(
    id                  character varying           NOT NULL,
    user_pk             character varying,
    thread_pk           character varying,
    "timestamp"         timestamp without time zone NOT NULL,
    item_type           character varying,
    is_sent_by_viewer   boolean,
    is_shh_mode         boolean,
    text                text,
    reply_pk            character varying,
    link                jsonb,
    animated_media      jsonb,
    media_pk            character varying,
    visual_media        jsonb,
    media_share_pk      character varying,
    reel_share          jsonb,
    story_share         jsonb,
    felix_share         jsonb,
    xma_share_pk        character varying,
    clip_pk             character varying,
    placeholder         jsonb,
    read_receipt        timestamp without time zone,
    message_status      character varying,
    media_description   text,
    media_type          character varying,
    reaction            jsonb,
    forward_count       integer,
    encryption_status   boolean,
    deletion_flag       boolean,
    contextual_link     jsonb,
    conversation_tags   jsonb,
    engagement_score    double precision,
    participation_level character varying
);


ALTER TABLE instagram."DirectMessage"
    OWNER TO postgres;

--
-- Name: DirectMessage_Thread; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."DirectMessage_Thread"
(
    message_pk             character varying NOT NULL,
    thread_pk              character varying NOT NULL,
    last_read_message_pk   character varying,
    message_role           character varying,
    unread_count           integer,
    mute_status            boolean,
    thread_status          character varying,
    pinned_status          boolean,
    access_level           character varying,
    encryption_flag        boolean,
    participant_engagement jsonb,
    engagement_score       double precision
);


ALTER TABLE instagram."DirectMessage_Thread"
    OWNER TO postgres;

--
-- Name: DirectMessage_User; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."DirectMessage_User"
(
    message_pk            character varying NOT NULL,
    user_pk               character varying NOT NULL,
    user_role             character varying,
    read_status           boolean,
    reaction              character varying,
    notification_status   character varying,
    privacy_setting       character varying,
    deletion_status       boolean,
    archival_status       boolean,
    engagement_score      double precision,
    message_importance    integer,
    accessibility_options jsonb
);


ALTER TABLE instagram."DirectMessage_User"
    OWNER TO postgres;

--
-- Name: DirectThread; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."DirectThread"
(
    pk                                character varying           NOT NULL,
    id                                character varying           NOT NULL,
    last_activity_at                  timestamp without time zone NOT NULL,
    muted                             boolean                     NOT NULL,
    named                             boolean                     NOT NULL,
    canonical                         boolean                     NOT NULL,
    pending                           boolean                     NOT NULL,
    archived                          boolean                     NOT NULL,
    thread_type                       character varying           NOT NULL,
    thread_title                      character varying           NOT NULL,
    folder                            integer                     NOT NULL,
    vc_muted                          boolean                     NOT NULL,
    is_group                          boolean                     NOT NULL,
    mentions_muted                    boolean                     NOT NULL,
    approval_required_for_new_members boolean                     NOT NULL,
    input_mode                        integer                     NOT NULL,
    business_thread_folder            integer                     NOT NULL,
    read_state                        integer                     NOT NULL,
    is_close_friend_thread            boolean                     NOT NULL,
    assigned_admin_id                 integer                     NOT NULL,
    shh_mode_enabled                  boolean                     NOT NULL,
    description                       text,
    cover_image_url                   character varying,
    pinned                            boolean,
    reaction_options                  jsonb,
    last_read_by_user                 jsonb,
    privacy_level                     character varying,
    end_to_end_encryption             boolean,
    member_limit                      integer,
    active_participants               jsonb,
    content_filters                   jsonb,
    accessibility_features            jsonb,
    engagement_metrics                jsonb,
    thread_health_score               double precision
);


ALTER TABLE instagram."DirectThread"
    OWNER TO postgres;

--
-- Name: DirectThread_User; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."DirectThread_User"
(
    thread_pk                  character varying NOT NULL,
    user_pk                    character varying NOT NULL,
    user_role                  character varying,
    permissions                jsonb,
    join_date                  timestamp without time zone,
    last_interaction           timestamp without time zone,
    notification_preferences   character varying,
    mute_until                 timestamp without time zone,
    privacy_setting            character varying,
    accessibility_options      jsonb,
    content_contribution_count integer,
    pinned_by_user             boolean,
    engagement_score           double precision,
    sentiment_analysis         jsonb
);


ALTER TABLE instagram."DirectThread_User"
    OWNER TO postgres;

--
-- Name: Hashtag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Hashtag"
(
    id                               character varying NOT NULL,
    name                             character varying NOT NULL,
    description                      text,
    created_at                       timestamp without time zone,
    popularity_score                 double precision,
    like_count                       integer,
    comment_count                    integer,
    share_count                      integer,
    category                         character varying,
    tags                             jsonb,
    top_user                         character varying,
    compliance                       boolean,
    trending_score                   double precision,
    last_trended_at                  timestamp without time zone,
    contributor_count                integer,
    engagement_rate                  double precision,
    related_hashtags                 jsonb,
    parent_hashtag_id                character varying,
    historical_popularity            jsonb,
    sentiment_score                  double precision,
    cultural_significance            text,
    language                         character varying,
    gallery_media_ids                jsonb,
    discovery_score                  double precision,
    viewer_growth_rate               double precision,
    quality_score                    double precision,
    relevance_score                  double precision,
    active_contributor_count         integer,
    community_engagement_index       double precision,
    lifecycle_stage                  character varying,
    evolution_track                  jsonb,
    user_demographics                jsonb,
    interaction_types_breakdown      jsonb,
    seo_impact_score                 double precision,
    monetization_potential           boolean,
    event_association                jsonb,
    influencer_impact                jsonb,
    geographical_trends              jsonb,
    content_quality_indicators       jsonb,
    user_sentiment_analysis          jsonb,
    community_size                   integer,
    copyright_trademark_status       character varying,
    ethical_guidelines_compliance    boolean,
    api_engagement_data              jsonb,
    cross_platform_identifier        jsonb,
    data_retention_period            timestamp without time zone,
    is_archived                      boolean,
    ar_vr_interaction_count          integer,
    has_ar_vr_content                boolean,
    new_user_growth                  integer,
    user_retention_impact            double precision,
    diversity_index                  double precision,
    accessibility_features_count     integer,
    platform_engagement_differential jsonb,
    social_impact_score              double precision,
    ethical_controversy_flag         boolean,
    trend_forecasting                jsonb,
    legal_review_status              character varying,
    compliance_history               jsonb,
    user_engagement_depth            double precision,
    algorithmic_impact_score         double precision,
    content_velocity                 double precision,
    niche_identification_score       double precision
);


ALTER TABLE instagram."Hashtag"
    OWNER TO postgres;

--
-- Name: Highlight; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Highlight"
(
    pk                          character varying           NOT NULL,
    id                          character varying           NOT NULL,
    latest_reel_media           integer                     NOT NULL,
    title                       character varying           NOT NULL,
    description                 text,
    visibility                  character varying,
    cover_media_type            character varying,
    thumbnail_url               character varying,
    created_at                  timestamp without time zone NOT NULL,
    is_pinned_highlight         boolean                     NOT NULL,
    media_count                 integer                     NOT NULL,
    view_count                  integer,
    share_count                 integer,
    last_updated_at             timestamp without time zone,
    expiration_date             timestamp without time zone,
    engagement_rate             double precision,
    interaction_types_breakdown jsonb,
    collaborators               jsonb,
    mention_count               integer,
    custom_attributes           jsonb
);


ALTER TABLE instagram."Highlight"
    OWNER TO postgres;

--
-- Name: Highlight_Media; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Highlight_Media"
(
    highlight_pk       character varying NOT NULL,
    media_pk           character varying NOT NULL,
    order_index        integer,
    presentation_style character varying,
    view_count         integer,
    interaction_types  jsonb,
    usage_count        integer,
    is_expired         boolean,
    engagement_rate    double precision,
    sentiment_score    double precision,
    contributor_id     character varying,
    mentioned_users    jsonb,
    custom_attributes  jsonb
);


ALTER TABLE instagram."Highlight_Media"
    OWNER TO postgres;

--
-- Name: Link; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Link"
(
    id                  character varying NOT NULL,
    url                 character varying,
    title               character varying,
    description         text,
    thumbnail_url       character varying,
    link_type           character varying,
    tags                jsonb,
    click_count         integer,
    engagement_metrics  jsonb,
    is_verified         boolean,
    expiration_date     timestamp without time zone,
    created_at          timestamp without time zone,
    updated_at          timestamp without time zone,
    access_restrictions jsonb,
    embedding_options   jsonb
);


ALTER TABLE instagram."Link"
    OWNER TO postgres;

--
-- Name: Location; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Location"
(
    pk                  integer           NOT NULL,
    name                character varying NOT NULL,
    phone               character varying DEFAULT ''::character varying,
    website             character varying DEFAULT ''::character varying,
    category            character varying DEFAULT ''::character varying,
    hours               jsonb             DEFAULT '{}'::jsonb,
    address             character varying,
    city                character varying,
    region              character varying,
    country             character varying,
    zip                 character varying,
    lng                 double precision,
    lat                 double precision,
    place_type          character varying,
    description         text,
    tags                jsonb,
    status              character varying,
    capacity            integer,
    popularity_score    double precision,
    check_ins_count     integer,
    accessibility_info  jsonb,
    image_url           character varying,
    is_verified         boolean           DEFAULT false,
    owner_user_pk       character varying,
    related_media_count integer           DEFAULT 0,
    extended_attributes jsonb
);


ALTER TABLE instagram."Location"
    OWNER TO postgres;

--
-- Name: Location_pk_seq; Type: SEQUENCE; Schema: instagram; Owner: postgres
--

CREATE SEQUENCE instagram."Location_pk_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE instagram."Location_pk_seq" OWNER TO postgres;

--
-- Name: Location_pk_seq; Type: SEQUENCE OWNED BY; Schema: instagram; Owner: postgres
--

ALTER SEQUENCE instagram."Location_pk_seq" OWNED BY instagram."Location".pk;


--
-- Name: Media; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media"
(
    pk                             character varying           NOT NULL,
    id                             character varying           NOT NULL,
    code                           character varying           NOT NULL,
    taken_at                       timestamp without time zone NOT NULL,
    media_type                     integer                     NOT NULL,
    image_versions2                jsonb,
    product_type                   character varying,
    thumbnail_url                  character varying,
    comment_count                  integer DEFAULT 0,
    comments_disabled              boolean DEFAULT false,
    commenting_disabled_for_viewer boolean DEFAULT false,
    like_count                     integer                     NOT NULL,
    play_count                     integer,
    has_liked                      boolean,
    caption_text                   text                        NOT NULL,
    alt_text                       character varying,
    media_url                      character varying,
    engagement_rate                double precision,
    impressions_count              integer,
    tags                           jsonb,
    mentions                       jsonb,
    bookmark_count                 integer DEFAULT 0,
    share_count                    integer DEFAULT 0,
    expiration_date                timestamp without time zone,
    location_name                  character varying,
    latitude                       double precision,
    longitude                      double precision,
    content_rating                 character varying,
    is_visible                     boolean DEFAULT true,
    carousel_metadata              jsonb,
    external_source_id             character varying,
    external_source_name           character varying,
    reactions                      jsonb
);


ALTER TABLE instagram."Media"
    OWNER TO postgres;

--
-- Name: Media_Comment; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Comment"
(
    media_pk                   character varying NOT NULL,
    comment_pk                 character varying NOT NULL,
    comment_order              integer,
    is_pinned                  boolean,
    reaction_count             jsonb,
    reply_count                integer,
    moderation_status          character varying,
    flagged_by_users           jsonb,
    sentiment_score            double precision,
    engagement_impact          double precision,
    last_interaction_at        timestamp without time zone,
    parent_comment_pk          character varying,
    user_mention_ids           jsonb,
    is_hidden                  boolean,
    keywords                   jsonb,
    automated_moderation_flags jsonb,
    moderation_notes           text,
    engagement_profile         jsonb
);


ALTER TABLE instagram."Media_Comment"
    OWNER TO postgres;

--
-- Name: Media_Hashtag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Hashtag"
(
    media_pk                   character varying NOT NULL,
    hashtag_pk                 character varying NOT NULL,
    hashtag_impact_score       double precision,
    is_trending                boolean,
    user_interaction_count     integer,
    is_curated                 boolean,
    engagement_rate_by_hashtag double precision,
    visibility_and_reach       jsonb,
    hashtag_category           character varying,
    is_archived                boolean,
    contextual_relevance       text,
    tagged_at                  timestamp without time zone,
    performance_over_time      jsonb,
    geo_impact                 jsonb,
    engagement_types_breakdown jsonb,
    influencer_impact          jsonb,
    discovery_paths            jsonb,
    related_hashtags           jsonb,
    tag_lifecycle_status       character varying,
    audit_trail                jsonb
);


ALTER TABLE instagram."Media_Hashtag"
    OWNER TO postgres;

--
-- Name: Media_Location; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Location"
(
    media_pk                    character varying NOT NULL,
    location_pk                 integer           NOT NULL,
    location_type               character varying,
    location_visibility         character varying,
    check_in_count              integer,
    user_engagement_score       double precision,
    location_keywords           jsonb,
    trending_score              double precision,
    location_sentiment_score    double precision,
    geographical_trends         jsonb,
    historical_popularity_index jsonb,
    last_updated_at             timestamp without time zone
);


ALTER TABLE instagram."Media_Location"
    OWNER TO postgres;

--
-- Name: Media_Resource; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Resource"
(
    media_pk            character varying NOT NULL,
    resource_pk         character varying NOT NULL,
    relation_type       character varying,
    sequence_order      integer,
    view_count          integer DEFAULT 0,
    engagement_data     jsonb,
    status              character varying,
    expiration_date     timestamp without time zone,
    is_accessible       boolean DEFAULT false,
    compliance_notes    text,
    verification_status character varying,
    access_control      jsonb,
    caching_info        jsonb,
    usage_metrics       jsonb,
    extended_attributes jsonb
);


ALTER TABLE instagram."Media_Resource"
    OWNER TO postgres;

--
-- Name: Media_Sponsor; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Sponsor"
(
    media_pk                    character varying NOT NULL,
    user_pk                     character varying NOT NULL,
    sponsorship_type            character varying,
    sponsorship_agreement_id    character varying,
    campaign_id                 character varying,
    content_delivery_status     character varying,
    engagement_target           double precision,
    performance_score           double precision,
    visibility_level            character varying,
    user_consent                boolean,
    sponsor_engagement_insights jsonb,
    impact_analysis             jsonb,
    compliance_status           character varying,
    audit_trail                 jsonb
);


ALTER TABLE instagram."Media_Sponsor"
    OWNER TO postgres;

--
-- Name: Media_Story; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Story"
(
    media_pk              character varying NOT NULL,
    story_pk              character varying NOT NULL,
    story_sequence        integer,
    duration_on_story     integer,
    is_featured           boolean,
    personalization_flags jsonb,
    view_count            integer,
    engagement_metrics    jsonb,
    is_archived           boolean,
    expiration_timestamp  timestamp without time zone,
    interactive_elements  jsonb,
    narrative_context     text
);


ALTER TABLE instagram."Media_Story"
    OWNER TO postgres;

--
-- Name: Media_Usertag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Media_Usertag"
(
    media_pk             character varying NOT NULL,
    user_pk              character varying NOT NULL,
    x                    double precision  NOT NULL,
    y                    double precision  NOT NULL,
    tag_type             character varying,
    tagged_at            timestamp without time zone,
    visibility_status    character varying,
    tag_approval         boolean,
    engagement_metric    double precision,
    relationship_context character varying,
    notification_sent    boolean,
    tag_importance       integer,
    tags                 jsonb,
    tagged_entity_id     character varying
);


ALTER TABLE instagram."Media_Usertag"
    OWNER TO postgres;

--
-- Name: Note; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Note"
(
    id                   character varying           NOT NULL,
    text                 text                        NOT NULL,
    title                character varying,
    user_pk              character varying           NOT NULL,
    audience             integer                     NOT NULL,
    created_at           timestamp without time zone NOT NULL,
    expires_at           timestamp without time zone NOT NULL,
    is_emoji_only        boolean                     NOT NULL,
    has_translation      boolean                     NOT NULL,
    note_style           integer                     NOT NULL,
    tagged_users         jsonb,
    attachment_urls      jsonb,
    like_count           integer,
    comment_count        integer,
    accessibility_rating double precision,
    read_count           integer,
    engagement_score     double precision,
    categories           jsonb,
    tags                 jsonb,
    visibility           character varying,
    is_encrypted         boolean,
    formatting_options   jsonb,
    reaction_types       jsonb
);


ALTER TABLE instagram."Note"
    OWNER TO postgres;

--
-- Name: Note_User; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Note_User"
(
    note_pk                character varying NOT NULL,
    user_pk                character varying NOT NULL,
    relationship_type      character varying,
    interaction_timestamp  timestamp without time zone,
    interaction_type       character varying,
    contribution_level     character varying,
    permission_level       character varying,
    reaction               character varying,
    notification_status    boolean,
    accessibility_feedback text,
    engagement_score       double precision,
    view_duration          integer
);


ALTER TABLE instagram."Note_User"
    OWNER TO postgres;

--
-- Name: Relationship; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Relationship"
(
    user_pk                        character varying NOT NULL,
    blocking                       boolean           NOT NULL,
    followed_by                    boolean           NOT NULL,
    following                      boolean           NOT NULL,
    incoming_request               boolean           NOT NULL,
    is_bestie                      boolean           NOT NULL,
    is_blocking_reel               boolean           NOT NULL,
    is_muting_reel                 boolean           NOT NULL,
    is_private                     boolean           NOT NULL,
    is_restricted                  boolean           NOT NULL,
    muting                         boolean           NOT NULL,
    outgoing_request               boolean           NOT NULL,
    is_favorite                    boolean,
    is_hidden                      boolean,
    is_silenced                    boolean,
    is_anonymized                  boolean,
    trust_level                    integer,
    engagement_score               double precision,
    last_interaction_at            timestamp without time zone,
    interaction_frequency          integer,
    shared_interests               jsonb,
    common_connections_count       integer,
    content_visibility_preferences jsonb,
    accessibility_preferences      jsonb
);


ALTER TABLE instagram."Relationship"
    OWNER TO postgres;

--
-- Name: Relationship_User; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Relationship_User"
(
    relationship_pk          character varying NOT NULL,
    user_pk                  character varying NOT NULL,
    target_user_pk           character varying NOT NULL,
    relationship_type        character varying,
    status                   character varying,
    status_updated_at        timestamp without time zone,
    interaction_history      jsonb,
    engagement_level         double precision,
    privacy_settings         jsonb,
    notification_preferences jsonb,
    common_interests         jsonb,
    insights                 jsonb
);


ALTER TABLE instagram."Relationship_User"
    OWNER TO postgres;

--
-- Name: Resource; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Resource"
(
    pk                    character varying NOT NULL,
    original_filename     character varying,
    resolution            character varying,
    file_size             integer,
    mime_type             character varying,
    cdn_url               character varying,
    accessibility_caption text,
    media_versions        jsonb,
    alt_text              text,
    like_count            integer DEFAULT 0,
    share_count           integer DEFAULT 0,
    tags                  jsonb,
    analytics_data        jsonb,
    checksum              character varying,
    is_private            boolean DEFAULT false,
    video_url             character varying NOT NULL,
    thumbnail_url         character varying NOT NULL,
    media_type            integer           NOT NULL
);


ALTER TABLE instagram."Resource"
    OWNER TO postgres;

--
-- Name: Story; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story"
(
    pk                        character varying           NOT NULL,
    id                        character varying           NOT NULL,
    code                      character varying           NOT NULL,
    taken_at                  timestamp without time zone NOT NULL,
    imported_taken_at         timestamp without time zone,
    media_type                integer                     NOT NULL,
    product_type              character varying           NOT NULL,
    thumbnail_url             character varying,
    user_pk                   character varying           NOT NULL,
    video_url                 character varying,
    video_duration            double precision            NOT NULL,
    is_paid_partnership       boolean,
    caption_text              text                        NOT NULL,
    content_format            character varying,
    interactivity_features    jsonb,
    visibility                character varying,
    audience_engagement_score double precision,
    view_count                integer,
    completion_rate           double precision,
    expiration_date           timestamp without time zone,
    location_tag              character varying,
    mentions                  jsonb,
    cover_image_url           character varying,
    is_archived               boolean,
    content_source            character varying
);


ALTER TABLE instagram."Story"
    OWNER TO postgres;

--
-- Name: StoryHashtag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."StoryHashtag"
(
    story_pk           character varying NOT NULL,
    hashtag_id         character varying NOT NULL,
    x                  double precision,
    y                  double precision,
    width              double precision,
    height             double precision,
    rotation           double precision,
    visibility         boolean,
    tap_count          integer,
    color              character varying,
    font_style         character varying,
    hashtag_type       character varying,
    custom_text        text,
    display_duration   double precision,
    mentioned_at       timestamp without time zone,
    engagement_metrics jsonb,
    influence_score    double precision,
    campaign_id        character varying,
    suggested_hashtags jsonb
);


ALTER TABLE instagram."StoryHashtag"
    OWNER TO postgres;

--
-- Name: StoryLocation; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."StoryLocation"
(
    story_pk             character varying NOT NULL,
    location_pk          integer           NOT NULL,
    x                    double precision,
    y                    double precision,
    width                double precision,
    height               double precision,
    rotation             double precision,
    scale                double precision,
    visibility           boolean,
    action_url           character varying,
    tap_count            integer,
    color                character varying,
    font_style           character varying,
    display_duration     double precision,
    contextual_text      text,
    location_type        character varying,
    custom_location_name character varying,
    engagement_metrics   jsonb,
    approval_status      character varying
);


ALTER TABLE instagram."StoryLocation"
    OWNER TO postgres;

--
-- Name: StoryLocation_location_pk_seq; Type: SEQUENCE; Schema: instagram; Owner: postgres
--

CREATE SEQUENCE instagram."StoryLocation_location_pk_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE instagram."StoryLocation_location_pk_seq" OWNER TO postgres;

--
-- Name: StoryLocation_location_pk_seq; Type: SEQUENCE OWNED BY; Schema: instagram; Owner: postgres
--

ALTER SEQUENCE instagram."StoryLocation_location_pk_seq" OWNED BY instagram."StoryLocation".location_pk;


--
-- Name: StoryMention; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."StoryMention"
(
    story_pk           character varying NOT NULL,
    user_pk            character varying NOT NULL,
    x                  double precision,
    y                  double precision,
    width              double precision,
    height             double precision,
    rotation           double precision,
    scale              double precision,
    mention_type       character varying,
    text               text,
    action_url         character varying,
    is_responded       boolean,
    color              character varying,
    font_style         character varying,
    view_count         integer,
    engagement_metrics jsonb,
    mentioned_at       timestamp without time zone,
    accessibility_text text,
    moderation_status  character varying
);


ALTER TABLE instagram."StoryMention"
    OWNER TO postgres;

--
-- Name: StorySticker; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."StorySticker"
(
    id                  integer           NOT NULL,
    story_pk            character varying NOT NULL,
    type                character varying DEFAULT 'gif'::character varying,
    x                   double precision  NOT NULL,
    y                   double precision  NOT NULL,
    z                   integer           DEFAULT 1000005,
    width               double precision  NOT NULL,
    height              double precision  NOT NULL,
    rotation            double precision  DEFAULT 0.0,
    interaction_type    character varying,
    text_content        text,
    tap_count           integer,
    action_url          character varying,
    color               character varying,
    font_style          character varying,
    engagement_metrics  jsonb,
    visibility_duration double precision,
    is_animated         boolean,
    resource_id         character varying,
    response_data       jsonb,
    custom_attributes   jsonb,
    moderation_status   character varying
);


ALTER TABLE instagram."StorySticker"
    OWNER TO postgres;

--
-- Name: StorySticker_id_seq; Type: SEQUENCE; Schema: instagram; Owner: postgres
--

CREATE SEQUENCE instagram."StorySticker_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE instagram."StorySticker_id_seq" OWNER TO postgres;

--
-- Name: StorySticker_id_seq; Type: SEQUENCE OWNED BY; Schema: instagram; Owner: postgres
--

ALTER SEQUENCE instagram."StorySticker_id_seq" OWNED BY instagram."StorySticker".id;


--
-- Name: Story_Comment; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Comment"
(
    story_pk            character varying NOT NULL,
    comment_pk          character varying NOT NULL,
    reaction_type       character varying,
    visibility          boolean,
    posted_at           timestamp without time zone,
    expires_at          timestamp without time zone,
    contextual_text     text,
    media_attachment_id character varying,
    engagement_score    double precision,
    is_liked            boolean,
    like_count          integer,
    moderation_status   character varying,
    report_count        integer,
    mentioned_users     jsonb,
    extended_attributes jsonb
);


ALTER TABLE instagram."Story_Comment"
    OWNER TO postgres;

--
-- Name: Story_Hashtag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Hashtag"
(
    story_pk               character varying NOT NULL,
    hashtag_pk             character varying NOT NULL,
    visibility             character varying,
    engagement_metrics     jsonb,
    click_through_rate     double precision,
    user_interaction_count integer,
    is_trending            boolean,
    hashtag_impact_score   double precision,
    tagged_at              timestamp without time zone,
    is_archived            boolean,
    contextual_relevance   text,
    hashtag_category       character varying
);


ALTER TABLE instagram."Story_Hashtag"
    OWNER TO postgres;

--
-- Name: Story_Highlight; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Highlight"
(
    story_pk                 character varying NOT NULL,
    highlight_pk             character varying NOT NULL,
    highlight_order          integer,
    customization_options    jsonb,
    view_count               integer,
    engagement_metrics       jsonb,
    expiration_date          timestamp without time zone,
    accessibility_settings   jsonb,
    added_at                 timestamp without time zone,
    is_archived              boolean,
    is_featured              boolean,
    user_interaction_history jsonb
);


ALTER TABLE instagram."Story_Highlight"
    OWNER TO postgres;

--
-- Name: Story_Link; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Link"
(
    story_pk                  character varying NOT NULL,
    link_pk                   character varying NOT NULL,
    link_order                integer,
    interaction_type          character varying,
    click_count               integer,
    engagement_timestamp      timestamp without time zone,
    visibility                character varying,
    audience_engagement_score double precision,
    added_at                  timestamp without time zone,
    status                    character varying,
    custom_display_options    jsonb,
    expiration_date           timestamp without time zone
);


ALTER TABLE instagram."Story_Link"
    OWNER TO postgres;

--
-- Name: Story_Location; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Location"
(
    story_pk               character varying NOT NULL,
    location_pk            integer           NOT NULL,
    location_type          character varying,
    interaction_count      integer,
    visibility             character varying,
    engagement_metrics     jsonb,
    discovery_method       character varying,
    audience_demographics  jsonb,
    tagged_at              timestamp without time zone,
    is_archived            boolean,
    local_popularity_score double precision,
    is_trending            boolean
);


ALTER TABLE instagram."Story_Location"
    OWNER TO postgres;

--
-- Name: Story_Sticker; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Sticker"
(
    story_pk                character varying NOT NULL,
    sticker_pk              integer           NOT NULL,
    sticker_type            character varying,
    user_interaction        jsonb,
    visibility              character varying,
    personalization_options jsonb,
    engagement_metrics      jsonb,
    conversion_rate         double precision,
    mentioned_users         jsonb,
    shared_with_users       jsonb,
    added_at                timestamp without time zone,
    sticker_status          character varying
);


ALTER TABLE instagram."Story_Sticker"
    OWNER TO postgres;

--
-- Name: Story_User; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_User"
(
    story_pk            character varying NOT NULL,
    user_pk             character varying NOT NULL,
    view_status         character varying,
    reaction_type       character varying,
    access_level        character varying,
    is_blocked          boolean,
    discovery_method    character varying,
    interest_score      double precision,
    view_timestamp      timestamp without time zone,
    engagement_duration integer,
    shared_with_users   jsonb,
    view_history        jsonb
);


ALTER TABLE instagram."Story_User"
    OWNER TO postgres;

--
-- Name: Story_Usertag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Story_Usertag"
(
    story_pk             character varying NOT NULL,
    usertag_user_pk      character varying NOT NULL,
    position_x           double precision,
    position_y           double precision,
    display_name         character varying,
    interaction_type     character varying,
    engagement_timestamp timestamp without time zone,
    visibility           character varying,
    approval_status      boolean,
    relevance_score      double precision,
    tagged_at            timestamp without time zone,
    tag_status           character varying
);


ALTER TABLE instagram."Story_Usertag"
    OWNER TO postgres;

--
-- Name: Track; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Track"
(
    id                                  character varying NOT NULL,
    title                               character varying NOT NULL,
    subtitle                            character varying NOT NULL,
    display_artist                      character varying NOT NULL,
    audio_cluster_id                    integer           NOT NULL,
    artist_id                           integer,
    cover_artwork_uri                   character varying,
    cover_artwork_thumbnail_uri         character varying,
    progressive_download_url            character varying,
    fast_start_progressive_download_url character varying,
    reactive_audio_download_url         character varying,
    highlight_start_times_in_ms         integer[],
    is_explicit                         boolean           NOT NULL,
    dash_manifest                       character varying NOT NULL,
    uri                                 character varying,
    has_lyrics                          boolean           NOT NULL,
    audio_asset_id                      integer           NOT NULL,
    duration_in_ms                      integer           NOT NULL,
    allows_saving                       boolean           NOT NULL,
    territory_validity_periods          jsonb,
    genre                               character varying,
    release_date                        date,
    bpm                                 integer,
    like_count                          integer,
    play_count                          integer,
    share_count                         integer,
    quality_rating                      double precision,
    accessibility_features              jsonb,
    featured_artists                    jsonb,
    ugc_link                            jsonb,
    mood                                character varying,
    listener_demographics               jsonb,
    copyright_status                    character varying,
    licensing_info                      jsonb
);


ALTER TABLE instagram."Track"
    OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."User"
(
    pk                          character varying NOT NULL,
    username                    character varying NOT NULL,
    full_name                   character varying NOT NULL,
    account_visibility          integer DEFAULT 0 NOT NULL,
    is_private                  boolean           NOT NULL,
    profile_pic_url             character varying NOT NULL,
    profile_pic_url_hd          character varying,
    is_verified                 boolean           NOT NULL,
    verified_badge_type         character varying,
    media_count                 integer           NOT NULL,
    follower_count              integer           NOT NULL,
    following_count             integer           NOT NULL,
    biography                   text    DEFAULT ''::text,
    external_url                character varying,
    account_type                integer,
    is_business                 boolean           NOT NULL,
    public_email                character varying,
    secondary_email             character varying,
    email_visible               boolean,
    contact_phone_number        character varying,
    public_phone_country_code   character varying,
    public_phone_number         character varying,
    business_contact_method     character varying,
    business_category_name      character varying,
    category_name               character varying,
    category                    character varying,
    address_street              character varying,
    city_id                     character varying,
    city_name                   character varying,
    latitude                    double precision,
    longitude                   double precision,
    zip                         character varying,
    instagram_location_id       character varying,
    interop_messaging_user_fbid character varying,
    engagement_rate             double precision,
    last_active_at              timestamp without time zone,
    story_sharing_enabled       boolean,
    activity_status_visible     boolean,
    followers_visible           boolean,
    following_visible           boolean,
    content_language            character varying,
    theme_preference            character varying,
    website_url                 character varying,
    operating_hours             jsonb,
    profile_creation_date       timestamp without time zone,
    account_status              character varying
);


ALTER TABLE instagram."User"
    OWNER TO postgres;

--
-- Name: User_BioLink; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."User_BioLink"
(
    user_pk           character varying NOT NULL,
    bio_link_id       character varying NOT NULL,
    added_date        timestamp without time zone,
    removed_date      timestamp without time zone,
    is_clicked        boolean DEFAULT false,
    click_count       integer DEFAULT 0,
    last_clicked      timestamp without time zone,
    custom_title      character varying,
    is_visible        boolean DEFAULT true,
    category          character varying,
    priority_order    integer,
    is_approved       boolean,
    active_start_date timestamp without time zone,
    active_end_date   timestamp without time zone
);


ALTER TABLE instagram."User_BioLink"
    OWNER TO postgres;

--
-- Name: User_Media; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."User_Media"
(
    user_pk             character varying NOT NULL,
    media_pk            character varying NOT NULL,
    posted_at           timestamp without time zone,
    ownership_type      character varying,
    role                character varying,
    visibility          boolean DEFAULT true,
    user_has_liked      boolean DEFAULT false,
    user_has_saved      boolean DEFAULT false,
    user_has_shared     boolean DEFAULT false,
    contribution_metric integer,
    custom_tags         jsonb,
    category            character varying,
    access_level        character varying,
    permissions         jsonb
);


ALTER TABLE instagram."User_Media"
    OWNER TO postgres;

--
-- Name: Usertag; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram."Usertag"
(
    tag_id             character varying NOT NULL,
    media_pk           character varying NOT NULL,
    x                  double precision  NOT NULL,
    y                  double precision  NOT NULL,
    context            text,
    is_visible         boolean DEFAULT true,
    tagged_by_user_pk  character varying,
    tagged_at          timestamp without time zone,
    approval_status    character varying,
    width              double precision,
    height             double precision,
    custom_attributes  jsonb,
    engagement_metrics jsonb,
    user_pk            character varying
);


ALTER TABLE instagram."Usertag"
    OWNER TO postgres;

--
-- Name: analytics_data; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram.analytics_data
(
    analytics_id integer NOT NULL,
    data         jsonb   NOT NULL,
    processed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE instagram.Analytics_Data
    OWNER TO postgres;

--
-- Name: analytics_data_analytics_id_seq; Type: SEQUENCE; Schema: instagram; Owner: postgres
--

CREATE SEQUENCE instagram.analytics_data_analytics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE instagram.analytics_data_analytics_id_seq OWNER TO postgres;

--
-- Name: analytics_data_analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: instagram; Owner: postgres
--

ALTER SEQUENCE instagram.analytics_data_analytics_id_seq OWNED BY instagram.Analytics_Data.analytics_id;


--
-- Name: log_entries; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram.log_entries
(
    id          integer NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    log_level   character varying(255),
    message     text,
    log_data    jsonb
);


ALTER TABLE instagram.Log_Entries
    OWNER TO postgres;

--
-- Name: log_entries_id_seq; Type: SEQUENCE; Schema: instagram; Owner: postgres
--

CREATE SEQUENCE instagram.log_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE instagram.log_entries_id_seq OWNER TO postgres;

--
-- Name: log_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: instagram; Owner: postgres
--

ALTER SEQUENCE instagram.log_entries_id_seq OWNED BY instagram.Log_Entries.id;


--
-- Name: reporting_data; Type: TABLE; Schema: instagram; Owner: postgres
--

CREATE TABLE instagram.reporting_data
(
    report_id  integer NOT NULL,
    data       jsonb   NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE instagram.Reporting_Data
    OWNER TO postgres;

--
-- Name: public_reporting_data; Type: VIEW; Schema: instagram; Owner: postgres
--

CREATE VIEW instagram.public_reporting_data AS
SELECT report_id,
       data,
       created_at
FROM instagram.Reporting_Data;


ALTER VIEW instagram.public_reporting_data OWNER TO postgres;

--
-- Name: reporting_data_report_id_seq; Type: SEQUENCE; Schema: instagram; Owner: postgres
--

CREATE SEQUENCE instagram.reporting_data_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE instagram.reporting_data_report_id_seq OWNER TO postgres;

--
-- Name: reporting_data_report_id_seq; Type: SEQUENCE OWNED BY; Schema: instagram; Owner: postgres
--

ALTER SEQUENCE instagram.reporting_data_report_id_seq OWNED BY instagram.Reporting_Data.report_id;


--
-- Name: Location pk; Type: DEFAULT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Location"
    ALTER COLUMN pk SET DEFAULT nextval('instagram."Location_pk_seq"'::regclass);


--
-- Name: StoryLocation location_pk; Type: DEFAULT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryLocation"
    ALTER COLUMN location_pk SET DEFAULT nextval('instagram."StoryLocation_location_pk_seq"'::regclass);


--
-- Name: StorySticker id; Type: DEFAULT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StorySticker"
    ALTER COLUMN id SET DEFAULT nextval('instagram."StorySticker_id_seq"'::regclass);


--
-- Name: analytics_data analytics_id; Type: DEFAULT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram.Analytics_Data
    ALTER COLUMN analytics_id SET DEFAULT nextval('instagram.analytics_data_analytics_id_seq'::regclass);


--
-- Name: log_entries id; Type: DEFAULT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram.Log_Entries
    ALTER COLUMN id SET DEFAULT nextval('instagram.log_entries_id_seq'::regclass);


--
-- Name: reporting_data report_id; Type: DEFAULT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram.Reporting_Data
    ALTER COLUMN report_id SET DEFAULT nextval('instagram.reporting_data_report_id_seq'::regclass);


--
-- Data for Name: BioLink; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."BioLink" (link_id, url, lynx_url, link_type, title, description, display_text, is_pinned,
                          open_external_url_with_in_app_browser, click_count, last_clicked, referrer, is_active,
                          expiration_date, thumbnail_url, tags, priority_order, is_verified, shortened_url,
                          accessibility_label, compliance_flags) FROM stdin;
\.


--
-- Data for Name: Collection; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Collection" (id, name, type, media_count, description, visibility, created_at, updated_at, like_count,
                             share_count, view_count, tags, cover_image_url, sort_order, custom_attributes,
                             collaborators, parent_collection_id, owner_id, moderation_status) FROM stdin;
\.


--
-- Data for Name: Comment; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Comment" (pk, text, user_pk, created_at_utc, edited_at, edit_history, accessibility_caption,
                          content_type, status, replied_to_comment_id, reply_count, share_count, moderation_status,
                          flags, tags, sentiment_score, mentions, parent_media_id, visibility, is_anonymous, has_liked,
                          like_count, engagement_metrics, media_pk, likes_count, created_at) FROM stdin;
\.


--
-- Data for Name: Comment_Mention; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Comment_Mention" (comment_pk, user_pk, context, mention_type, notification_status, acknowledged_at,
                                  accessibility_info, added_at, is_archived, interaction_outcome,
                                  engagement_metrics) FROM stdin;
\.


--
-- Data for Name: Comment_Reply; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Comment_Reply" (parent_comment_pk, reply_comment_pk, reply_depth, reply_order, likes_count,
                                engagement_timestamps, is_flagged, moderation_status, mentioned_users, hashtags,
                                edited_at, is_archived) FROM stdin;
\.


--
-- Data for Name: Constants; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Constants" (name, value) FROM stdin;
API_DOMAIN	i.instagram.com
USER_AGENT_BASE	Instagram {app_version} Android ({android_version}/{android_release}; {dpi}; {resolution}; {manufacturer}; {model}; {device}; {cpu}; {locale}; {version_code})
SOFTWARE	{model}-user+{android_release}+OPR1.170623.032+V10.2.3.0.OAGMIXM+release-keys
QUERY_HASH_PROFILE	c9100bf9110dd6361671f113dd02e7d6
QUERY_HASH_MEDIAS	42323d64886122307be10013ad2dcc44
QUERY_HASH_IGTVS	bc78b344a68ed16dd5d7f264681c4c76
QUERY_HASH_STORIES	5ec1d322b38839230f8e256e1f638d5f
QUERY_HASH_HIGHLIGHTS_FOLDERS	ad99dd9d3646cc3c0dda65debcd266a7
QUERY_HASH_HIGHLIGHTS_STORIES	5ec1d322b38839230f8e256e1f638d5f
QUERY_HASH_FOLLOWERS	c76146de99bb02f6415203be841dd25a
QUERY_HASH_FOLLOWINGS	d04b0a864b4b54837c0d870b0e77e076
QUERY_HASH_HASHTAG	174a5243287c5f3a7de741089750ab3b
QUERY_HASH_COMMENTS	33ba35852cb50da46f5b5e889df7d159
QUERY_HASH_TAGGED_MEDIAS	be13233562af2d229b008d2976b998b5
LOGIN_EXPERIMENTS	ig_android_reg_nux_headers_cleanup_universe,ig_android_device_detection_info_upload,ig_android_nux_add_email_device,ig_android_gmail_oauth_in_reg,ig_android_device_info_foreground_reporting,ig_android_device_verification_fb_signup,ig_android_direct_main_tab_universe_v2,ig_android_passwordless_account_password_creation_universe,ig_android_direct_add_direct_to_android_native_photo_share_sheet,ig_growth_android_profile_pic_prefill_with_fb_pic_2,ig_account_identity_logged_out_signals_global_holdout_universe,ig_android_quickcapture_keep_screen_on,ig_android_device_based_country_verification,ig_android_login_identifier_fuzzy_match,ig_android_reg_modularization_universe,ig_android_security_intent_switchoff,ig_android_device_verification_separate_endpoint,ig_android_suma_landing_page,ig_android_sim_info_upload,ig_android_smartlock_hints_universe,ig_android_fb_account_linking_sampling_freq_universe,ig_android_retry_create_account_universe,ig_android_caption_typeahead_fix_on_o_universe
SUPPORTED_SDK_VERSIONS	119.0,120.0,121.0,122.0,123.0,124.0,125.0,126.0
FACE_TRACKER_BUILD	2020110901
BUILD_DISPLAY	RQ1A.210205.004
SUPPORTED_ABIS	arm64-v8a;armeabi-v7a;armeabi
\.


--
-- Data for Name: DirectMessage; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."DirectMessage" (id, user_pk, thread_pk, "timestamp", item_type, is_sent_by_viewer, is_shh_mode, text,
                                reply_pk, link, animated_media, media_pk, visual_media, media_share_pk, reel_share,
                                story_share, felix_share, xma_share_pk, clip_pk, placeholder, read_receipt,
                                message_status, media_description, media_type, reaction, forward_count,
                                encryption_status, deletion_flag, contextual_link, conversation_tags, engagement_score,
                                participation_level) FROM stdin;
\.


--
-- Data for Name: DirectMessage_Thread; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."DirectMessage_Thread" (message_pk, thread_pk, last_read_message_pk, message_role, unread_count,
                                       mute_status, thread_status, pinned_status, access_level, encryption_flag,
                                       participant_engagement, engagement_score) FROM stdin;
\.


--
-- Data for Name: DirectMessage_User; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."DirectMessage_User" (message_pk, user_pk, user_role, read_status, reaction, notification_status,
                                     privacy_setting, deletion_status, archival_status, engagement_score,
                                     message_importance, accessibility_options) FROM stdin;
\.


--
-- Data for Name: DirectThread; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."DirectThread" (pk, id, last_activity_at, muted, named, canonical, pending, archived, thread_type,
                               thread_title, folder, vc_muted, is_group, mentions_muted,
                               approval_required_for_new_members, input_mode, business_thread_folder, read_state,
                               is_close_friend_thread, assigned_admin_id, shh_mode_enabled, description,
                               cover_image_url, pinned, reaction_options, last_read_by_user, privacy_level,
                               end_to_end_encryption, member_limit, active_participants, content_filters,
                               accessibility_features, engagement_metrics, thread_health_score) FROM stdin;
\.


--
-- Data for Name: DirectThread_User; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."DirectThread_User" (thread_pk, user_pk, user_role, permissions, join_date, last_interaction,
                                    notification_preferences, mute_until, privacy_setting, accessibility_options,
                                    content_contribution_count, pinned_by_user, engagement_score,
                                    sentiment_analysis) FROM stdin;
\.


--
-- Data for Name: Hashtag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Hashtag" (id, name, description, created_at, popularity_score, like_count, comment_count, share_count,
                          category, tags, top_user, compliance, trending_score, last_trended_at, contributor_count,
                          engagement_rate, related_hashtags, parent_hashtag_id, historical_popularity, sentiment_score,
                          cultural_significance, language, gallery_media_ids, discovery_score, viewer_growth_rate,
                          quality_score, relevance_score, active_contributor_count, community_engagement_index,
                          lifecycle_stage, evolution_track, user_demographics, interaction_types_breakdown,
                          seo_impact_score, monetization_potential, event_association, influencer_impact,
                          geographical_trends, content_quality_indicators, user_sentiment_analysis, community_size,
                          copyright_trademark_status, ethical_guidelines_compliance, api_engagement_data,
                          cross_platform_identifier, data_retention_period, is_archived, ar_vr_interaction_count,
                          has_ar_vr_content, new_user_growth, user_retention_impact, diversity_index,
                          accessibility_features_count, platform_engagement_differential, social_impact_score,
                          ethical_controversy_flag, trend_forecasting, legal_review_status, compliance_history,
                          user_engagement_depth, algorithmic_impact_score, content_velocity,
                          niche_identification_score) FROM stdin;
\.


--
-- Data for Name: Highlight; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Highlight" (pk, id, latest_reel_media, title, description, visibility, cover_media_type, thumbnail_url,
                            created_at, is_pinned_highlight, media_count, view_count, share_count, last_updated_at,
                            expiration_date, engagement_rate, interaction_types_breakdown, collaborators, mention_count,
                            custom_attributes) FROM stdin;
\.


--
-- Data for Name: Highlight_Media; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Highlight_Media" (highlight_pk, media_pk, order_index, presentation_style, view_count,
                                  interaction_types, usage_count, is_expired, engagement_rate, sentiment_score,
                                  contributor_id, mentioned_users, custom_attributes) FROM stdin;
\.


--
-- Data for Name: Link; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Link" (id, url, title, description, thumbnail_url, link_type, tags, click_count, engagement_metrics,
                       is_verified, expiration_date, created_at, updated_at, access_restrictions,
                       embedding_options) FROM stdin;
\.


--
-- Data for Name: Location; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Location" (pk, name, phone, website, category, hours, address, city, region, country, zip, lng, lat,
                           place_type, description, tags, status, capacity, popularity_score, check_ins_count,
                           accessibility_info, image_url, is_verified, owner_user_pk, related_media_count,
                           extended_attributes) FROM stdin;
\.


--
-- Data for Name: Media; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media" (pk, id, code, taken_at, media_type, image_versions2, product_type, thumbnail_url, comment_count,
                        comments_disabled, commenting_disabled_for_viewer, like_count, play_count, has_liked,
                        caption_text, alt_text, media_url, engagement_rate, impressions_count, tags, mentions,
                        bookmark_count, share_count, expiration_date, location_name, latitude, longitude,
                        content_rating, is_visible, carousel_metadata, external_source_id, external_source_name,
                        reactions) FROM stdin;
\.


--
-- Data for Name: Media_Comment; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Comment" (media_pk, comment_pk, comment_order, is_pinned, reaction_count, reply_count,
                                moderation_status, flagged_by_users, sentiment_score, engagement_impact,
                                last_interaction_at, parent_comment_pk, user_mention_ids, is_hidden, keywords,
                                automated_moderation_flags, moderation_notes, engagement_profile) FROM stdin;
\.


--
-- Data for Name: Media_Hashtag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Hashtag" (media_pk, hashtag_pk, hashtag_impact_score, is_trending, user_interaction_count,
                                is_curated, engagement_rate_by_hashtag, visibility_and_reach, hashtag_category,
                                is_archived, contextual_relevance, tagged_at, performance_over_time, geo_impact,
                                engagement_types_breakdown, influencer_impact, discovery_paths, related_hashtags,
                                tag_lifecycle_status, audit_trail) FROM stdin;
\.


--
-- Data for Name: Media_Location; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Location" (media_pk, location_pk, location_type, location_visibility, check_in_count,
                                 user_engagement_score, location_keywords, trending_score, location_sentiment_score,
                                 geographical_trends, historical_popularity_index, last_updated_at) FROM stdin;
\.


--
-- Data for Name: Media_Resource; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Resource" (media_pk, resource_pk, relation_type, sequence_order, view_count, engagement_data,
                                 status, expiration_date, is_accessible, compliance_notes, verification_status,
                                 access_control, caching_info, usage_metrics, extended_attributes) FROM stdin;
\.


--
-- Data for Name: Media_Sponsor; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Sponsor" (media_pk, user_pk, sponsorship_type, sponsorship_agreement_id, campaign_id,
                                content_delivery_status, engagement_target, performance_score, visibility_level,
                                user_consent, sponsor_engagement_insights, impact_analysis, compliance_status,
                                audit_trail) FROM stdin;
\.


--
-- Data for Name: Media_Story; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Story" (media_pk, story_pk, story_sequence, duration_on_story, is_featured, personalization_flags,
                              view_count, engagement_metrics, is_archived, expiration_timestamp, interactive_elements,
                              narrative_context) FROM stdin;
\.


--
-- Data for Name: Media_Usertag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Media_Usertag" (media_pk, user_pk, x, y, tag_type, tagged_at, visibility_status, tag_approval,
                                engagement_metric, relationship_context, notification_sent, tag_importance, tags,
                                tagged_entity_id) FROM stdin;
\.


--
-- Data for Name: Note; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Note" (id, text, title, user_pk, audience, created_at, expires_at, is_emoji_only, has_translation,
                       note_style, tagged_users, attachment_urls, like_count, comment_count, accessibility_rating,
                       read_count, engagement_score, categories, tags, visibility, is_encrypted, formatting_options,
                       reaction_types) FROM stdin;
\.


--
-- Data for Name: Note_User; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Note_User" (note_pk, user_pk, relationship_type, interaction_timestamp, interaction_type,
                            contribution_level, permission_level, reaction, notification_status, accessibility_feedback,
                            engagement_score, view_duration) FROM stdin;
\.


--
-- Data for Name: Relationship; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Relationship" (user_pk, blocking, followed_by, following, incoming_request, is_bestie, is_blocking_reel,
                               is_muting_reel, is_private, is_restricted, muting, outgoing_request, is_favorite,
                               is_hidden, is_silenced, is_anonymized, trust_level, engagement_score,
                               last_interaction_at, interaction_frequency, shared_interests, common_connections_count,
                               content_visibility_preferences, accessibility_preferences) FROM stdin;
\.


--
-- Data for Name: Relationship_User; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Relationship_User" (relationship_pk, user_pk, target_user_pk, relationship_type, status,
                                    status_updated_at, interaction_history, engagement_level, privacy_settings,
                                    notification_preferences, common_interests, insights) FROM stdin;
\.


--
-- Data for Name: Resource; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Resource" (pk, original_filename, resolution, file_size, mime_type, cdn_url, accessibility_caption,
                           media_versions, alt_text, like_count, share_count, tags, analytics_data, checksum,
                           is_private, video_url, thumbnail_url, media_type) FROM stdin;
\.


--
-- Data for Name: Story; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story" (pk, id, code, taken_at, imported_taken_at, media_type, product_type, thumbnail_url, user_pk,
                        video_url, video_duration, is_paid_partnership, caption_text, content_format,
                        interactivity_features, visibility, audience_engagement_score, view_count, completion_rate,
                        expiration_date, location_tag, mentions, cover_image_url, is_archived,
                        content_source) FROM stdin;
\.


--
-- Data for Name: StoryHashtag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."StoryHashtag" (story_pk, hashtag_id, x, y, width, height, rotation, visibility, tap_count, color,
                               font_style, hashtag_type, custom_text, display_duration, mentioned_at,
                               engagement_metrics, influence_score, campaign_id, suggested_hashtags) FROM stdin;
\.


--
-- Data for Name: StoryLocation; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."StoryLocation" (story_pk, location_pk, x, y, width, height, rotation, scale, visibility, action_url,
                                tap_count, color, font_style, display_duration, contextual_text, location_type,
                                custom_location_name, engagement_metrics, approval_status) FROM stdin;
\.


--
-- Data for Name: StoryMention; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."StoryMention" (story_pk, user_pk, x, y, width, height, rotation, scale, mention_type, text, action_url,
                               is_responded, color, font_style, view_count, engagement_metrics, mentioned_at,
                               accessibility_text, moderation_status) FROM stdin;
\.


--
-- Data for Name: StorySticker; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."StorySticker" (id, story_pk, type, x, y, z, width, height, rotation, interaction_type, text_content,
                               tap_count, action_url, color, font_style, engagement_metrics, visibility_duration,
                               is_animated, resource_id, response_data, custom_attributes,
                               moderation_status) FROM stdin;
\.


--
-- Data for Name: Story_Comment; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Comment" (story_pk, comment_pk, reaction_type, visibility, posted_at, expires_at, contextual_text,
                                media_attachment_id, engagement_score, is_liked, like_count, moderation_status,
                                report_count, mentioned_users, extended_attributes) FROM stdin;
\.


--
-- Data for Name: Story_Hashtag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Hashtag" (story_pk, hashtag_pk, visibility, engagement_metrics, click_through_rate,
                                user_interaction_count, is_trending, hashtag_impact_score, tagged_at, is_archived,
                                contextual_relevance, hashtag_category) FROM stdin;
\.


--
-- Data for Name: Story_Highlight; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Highlight" (story_pk, highlight_pk, highlight_order, customization_options, view_count,
                                  engagement_metrics, expiration_date, accessibility_settings, added_at, is_archived,
                                  is_featured, user_interaction_history) FROM stdin;
\.


--
-- Data for Name: Story_Link; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Link" (story_pk, link_pk, link_order, interaction_type, click_count, engagement_timestamp,
                             visibility, audience_engagement_score, added_at, status, custom_display_options,
                             expiration_date) FROM stdin;
\.


--
-- Data for Name: Story_Location; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Location" (story_pk, location_pk, location_type, interaction_count, visibility,
                                 engagement_metrics, discovery_method, audience_demographics, tagged_at, is_archived,
                                 local_popularity_score, is_trending) FROM stdin;
\.


--
-- Data for Name: Story_Sticker; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Sticker" (story_pk, sticker_pk, sticker_type, user_interaction, visibility,
                                personalization_options, engagement_metrics, conversion_rate, mentioned_users,
                                shared_with_users, added_at, sticker_status) FROM stdin;
\.


--
-- Data for Name: Story_User; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_User" (story_pk, user_pk, view_status, reaction_type, access_level, is_blocked, discovery_method,
                             interest_score, view_timestamp, engagement_duration, shared_with_users,
                             view_history) FROM stdin;
\.


--
-- Data for Name: Story_Usertag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Story_Usertag" (story_pk, usertag_user_pk, position_x, position_y, display_name, interaction_type,
                                engagement_timestamp, visibility, approval_status, relevance_score, tagged_at,
                                tag_status) FROM stdin;
\.


--
-- Data for Name: Track; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Track" (id, title, subtitle, display_artist, audio_cluster_id, artist_id, cover_artwork_uri,
                        cover_artwork_thumbnail_uri, progressive_download_url, fast_start_progressive_download_url,
                        reactive_audio_download_url, highlight_start_times_in_ms, is_explicit, dash_manifest, uri,
                        has_lyrics, audio_asset_id, duration_in_ms, allows_saving, territory_validity_periods, genre,
                        release_date, bpm, like_count, play_count, share_count, quality_rating, accessibility_features,
                        featured_artists, ugc_link, mood, listener_demographics, copyright_status,
                        licensing_info) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."User" (pk, username, full_name, account_visibility, is_private, profile_pic_url, profile_pic_url_hd,
                       is_verified, verified_badge_type, media_count, follower_count, following_count, biography,
                       external_url, account_type, is_business, public_email, secondary_email, email_visible,
                       contact_phone_number, public_phone_country_code, public_phone_number, business_contact_method,
                       business_category_name, category_name, category, address_street, city_id, city_name, latitude,
                       longitude, zip, instagram_location_id, interop_messaging_user_fbid, engagement_rate,
                       last_active_at, story_sharing_enabled, activity_status_visible, followers_visible,
                       following_visible, content_language, theme_preference, website_url, operating_hours,
                       profile_creation_date, account_status) FROM stdin;
\.


--
-- Data for Name: User_BioLink; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."User_BioLink" (user_pk, bio_link_id, added_date, removed_date, is_clicked, click_count, last_clicked,
                               custom_title, is_visible, category, priority_order, is_approved, active_start_date,
                               active_end_date) FROM stdin;
\.


--
-- Data for Name: User_Media; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."User_Media" (user_pk, media_pk, posted_at, ownership_type, role, visibility, user_has_liked,
                             user_has_saved, user_has_shared, contribution_metric, custom_tags, category, access_level,
                             permissions) FROM stdin;
\.


--
-- Data for Name: Usertag; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram."Usertag" (tag_id, media_pk, x, y, context, is_visible, tagged_by_user_pk, tagged_at, approval_status,
                          width, height, custom_attributes, engagement_metrics, user_pk) FROM stdin;
\.


--
-- Data for Name: analytics_data; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram.Analytics_Data (analytics_id, data, processed_at) FROM stdin;
\.


--
-- Data for Name: log_entries; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram.Log_Entries (id, "timestamp", log_level, message, log_data) FROM stdin;
\.


--
-- Data for Name: reporting_data; Type: TABLE DATA; Schema: instagram; Owner: postgres
--

COPY instagram.Reporting_Data (report_id, data, created_at) FROM stdin;
\.


--
-- Name: Location_pk_seq; Type: SEQUENCE SET; Schema: instagram; Owner: postgres
--

SELECT pg_catalog.setval('instagram."Location_pk_seq"', 1, false);


--
-- Name: StoryLocation_location_pk_seq; Type: SEQUENCE SET; Schema: instagram; Owner: postgres
--

SELECT pg_catalog.setval('instagram."StoryLocation_location_pk_seq"', 1, false);


--
-- Name: StorySticker_id_seq; Type: SEQUENCE SET; Schema: instagram; Owner: postgres
--

SELECT pg_catalog.setval('instagram."StorySticker_id_seq"', 1, false);


--
-- Name: analytics_data_analytics_id_seq; Type: SEQUENCE SET; Schema: instagram; Owner: postgres
--

SELECT pg_catalog.setval('instagram.analytics_data_analytics_id_seq', 1, false);


--
-- Name: log_entries_id_seq; Type: SEQUENCE SET; Schema: instagram; Owner: postgres
--

SELECT pg_catalog.setval('instagram.log_entries_id_seq', 1, false);


--
-- Name: reporting_data_report_id_seq; Type: SEQUENCE SET; Schema: instagram; Owner: postgres
--

SELECT pg_catalog.setval('instagram.reporting_data_report_id_seq', 1, false);


--
-- Name: BioLink BioLink_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."BioLink"
    ADD CONSTRAINT "BioLink_pkey" PRIMARY KEY (link_id);


--
-- Name: Collection Collection_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Collection"
    ADD CONSTRAINT "Collection_pkey" PRIMARY KEY (id);


--
-- Name: Comment_Mention Comment_Mention_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment_Mention"
    ADD CONSTRAINT "Comment_Mention_pkey" PRIMARY KEY (comment_pk, user_pk);


--
-- Name: Comment_Reply Comment_Reply_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment_Reply"
    ADD CONSTRAINT "Comment_Reply_pkey" PRIMARY KEY (parent_comment_pk, reply_comment_pk);


--
-- Name: Comment Comment_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment"
    ADD CONSTRAINT "Comment_pkey" PRIMARY KEY (pk);


--
-- Name: Constants Constants_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Constants"
    ADD CONSTRAINT "Constants_pkey" PRIMARY KEY (name);


--
-- Name: DirectMessage_Thread DirectMessage_Thread_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_Thread"
    ADD CONSTRAINT "DirectMessage_Thread_pkey" PRIMARY KEY (message_pk, thread_pk);


--
-- Name: DirectMessage_User DirectMessage_User_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_User"
    ADD CONSTRAINT "DirectMessage_User_pkey" PRIMARY KEY (message_pk, user_pk);


--
-- Name: DirectMessage DirectMessage_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage"
    ADD CONSTRAINT "DirectMessage_pkey" PRIMARY KEY (id);


--
-- Name: DirectThread_User DirectThread_User_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectThread_User"
    ADD CONSTRAINT "DirectThread_User_pkey" PRIMARY KEY (thread_pk, user_pk);


--
-- Name: DirectThread DirectThread_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectThread"
    ADD CONSTRAINT "DirectThread_pkey" PRIMARY KEY (pk);


--
-- Name: Hashtag Hashtag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Hashtag"
    ADD CONSTRAINT "Hashtag_pkey" PRIMARY KEY (id);


--
-- Name: Highlight_Media Highlight_Media_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Highlight_Media"
    ADD CONSTRAINT "Highlight_Media_pkey" PRIMARY KEY (highlight_pk, media_pk);


--
-- Name: Highlight Highlight_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Highlight"
    ADD CONSTRAINT "Highlight_pkey" PRIMARY KEY (pk);


--
-- Name: Link Link_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Link"
    ADD CONSTRAINT "Link_pkey" PRIMARY KEY (id);


--
-- Name: Location Location_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Location"
    ADD CONSTRAINT "Location_pkey" PRIMARY KEY (pk);


--
-- Name: Media_Comment Media_Comment_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Comment"
    ADD CONSTRAINT "Media_Comment_pkey" PRIMARY KEY (media_pk, comment_pk);


--
-- Name: Media_Hashtag Media_Hashtag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Hashtag"
    ADD CONSTRAINT "Media_Hashtag_pkey" PRIMARY KEY (media_pk, hashtag_pk);


--
-- Name: Media_Location Media_Location_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Location"
    ADD CONSTRAINT "Media_Location_pkey" PRIMARY KEY (media_pk, location_pk);


--
-- Name: Media_Resource Media_Resource_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Resource"
    ADD CONSTRAINT "Media_Resource_pkey" PRIMARY KEY (media_pk, resource_pk);


--
-- Name: Media_Sponsor Media_Sponsor_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Sponsor"
    ADD CONSTRAINT "Media_Sponsor_pkey" PRIMARY KEY (media_pk, user_pk);


--
-- Name: Media_Story Media_Story_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Story"
    ADD CONSTRAINT "Media_Story_pkey" PRIMARY KEY (media_pk, story_pk);


--
-- Name: Media_Usertag Media_Usertag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Usertag"
    ADD CONSTRAINT "Media_Usertag_pkey" PRIMARY KEY (media_pk, user_pk);


--
-- Name: Media Media_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media"
    ADD CONSTRAINT "Media_pkey" PRIMARY KEY (pk);


--
-- Name: Note_User Note_User_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Note_User"
    ADD CONSTRAINT "Note_User_pkey" PRIMARY KEY (note_pk, user_pk);


--
-- Name: Note Note_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Note"
    ADD CONSTRAINT "Note_pkey" PRIMARY KEY (id);


--
-- Name: Relationship_User Relationship_User_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Relationship_User"
    ADD CONSTRAINT "Relationship_User_pkey" PRIMARY KEY (relationship_pk, user_pk, target_user_pk);


--
-- Name: Relationship Relationship_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Relationship"
    ADD CONSTRAINT "Relationship_pkey" PRIMARY KEY (user_pk);


--
-- Name: Resource Resource_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Resource"
    ADD CONSTRAINT "Resource_pkey" PRIMARY KEY (pk);


--
-- Name: StoryHashtag StoryHashtag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryHashtag"
    ADD CONSTRAINT "StoryHashtag_pkey" PRIMARY KEY (story_pk, hashtag_id);


--
-- Name: StoryLocation StoryLocation_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryLocation"
    ADD CONSTRAINT "StoryLocation_pkey" PRIMARY KEY (story_pk, location_pk);


--
-- Name: StoryMention StoryMention_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryMention"
    ADD CONSTRAINT "StoryMention_pkey" PRIMARY KEY (story_pk, user_pk);


--
-- Name: StorySticker StorySticker_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StorySticker"
    ADD CONSTRAINT "StorySticker_pkey" PRIMARY KEY (id);


--
-- Name: Story_Comment Story_Comment_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Comment"
    ADD CONSTRAINT "Story_Comment_pkey" PRIMARY KEY (story_pk, comment_pk);


--
-- Name: Story_Hashtag Story_Hashtag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Hashtag"
    ADD CONSTRAINT "Story_Hashtag_pkey" PRIMARY KEY (story_pk, hashtag_pk);


--
-- Name: Story_Highlight Story_Highlight_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Highlight"
    ADD CONSTRAINT "Story_Highlight_pkey" PRIMARY KEY (story_pk, highlight_pk);


--
-- Name: Story_Link Story_Link_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Link"
    ADD CONSTRAINT "Story_Link_pkey" PRIMARY KEY (story_pk, link_pk);


--
-- Name: Story_Location Story_Location_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Location"
    ADD CONSTRAINT "Story_Location_pkey" PRIMARY KEY (story_pk, location_pk);


--
-- Name: Story_Sticker Story_Sticker_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Sticker"
    ADD CONSTRAINT "Story_Sticker_pkey" PRIMARY KEY (story_pk, sticker_pk);


--
-- Name: Story_User Story_User_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_User"
    ADD CONSTRAINT "Story_User_pkey" PRIMARY KEY (story_pk, user_pk);


--
-- Name: Story_Usertag Story_Usertag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Usertag"
    ADD CONSTRAINT "Story_Usertag_pkey" PRIMARY KEY (story_pk, usertag_user_pk);


--
-- Name: Story Story_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story"
    ADD CONSTRAINT "Story_pkey" PRIMARY KEY (pk);


--
-- Name: Track Track_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Track"
    ADD CONSTRAINT "Track_pkey" PRIMARY KEY (id);


--
-- Name: User_BioLink User_BioLink_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User_BioLink"
    ADD CONSTRAINT "User_BioLink_pkey" PRIMARY KEY (user_pk, bio_link_id);


--
-- Name: User_Media User_Media_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User_Media"
    ADD CONSTRAINT "User_Media_pkey" PRIMARY KEY (user_pk, media_pk);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (pk);


--
-- Name: Usertag Usertag_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Usertag"
    ADD CONSTRAINT "Usertag_pkey" PRIMARY KEY (tag_id);


--
-- Name: analytics_data analytics_data_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram.Analytics_Data
    ADD CONSTRAINT analytics_data_pkey PRIMARY KEY (analytics_id);


--
-- Name: log_entries log_entries_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram.Log_Entries
    ADD CONSTRAINT log_entries_pkey PRIMARY KEY (id);


--
-- Name: reporting_data reporting_data_pkey; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram.Reporting_Data
    ADD CONSTRAINT reporting_data_pkey PRIMARY KEY (report_id);


--
-- Name: Comment unique_comment_pk; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment"
    ADD CONSTRAINT unique_comment_pk UNIQUE (pk);


--
-- Name: Usertag user_pk; Type: CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Usertag"
    ADD CONSTRAINT user_pk UNIQUE (user_pk);


--
-- Name: idx_account_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_account_status ON instagram."User" USING btree (account_status);


--
-- Name: idx_added_date; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_added_date ON instagram."User_BioLink" USING btree (added_date);


--
-- Name: idx_approval_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_approval_status ON instagram."Usertag" USING btree (approval_status);


--
-- Name: idx_bio_link_id; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_bio_link_id ON instagram."User_BioLink" USING btree (bio_link_id);


--
-- Name: idx_city; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_city ON instagram."Location" USING btree (city);


--
-- Name: idx_click_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_click_count ON instagram."BioLink" USING btree (click_count);


--
-- Name: idx_collection_owner_id; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_collection_owner_id ON instagram."Collection" USING btree (owner_id);


--
-- Name: idx_comment_created_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_created_at ON instagram."Comment" USING btree (created_at);


--
-- Name: idx_comment_likes_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_likes_count ON instagram."Comment" USING btree (likes_count);


--
-- Name: idx_comment_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_media_pk ON instagram."Comment" USING btree (media_pk);


--
-- Name: idx_comment_mention_comment_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_mention_comment_pk ON instagram."Comment_Mention" USING btree (comment_pk);


--
-- Name: idx_comment_mention_notification_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_mention_notification_status ON instagram."Comment_Mention" USING btree (notification_status);


--
-- Name: idx_comment_mention_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_mention_user_pk ON instagram."Comment_Mention" USING btree (user_pk);


--
-- Name: idx_comment_reply_likes_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_reply_likes_count ON instagram."Comment_Reply" USING btree (likes_count);


--
-- Name: idx_comment_reply_parent_comment_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_reply_parent_comment_pk ON instagram."Comment_Reply" USING btree (parent_comment_pk);


--
-- Name: idx_comment_reply_reply_comment_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_reply_reply_comment_pk ON instagram."Comment_Reply" USING btree (reply_comment_pk);


--
-- Name: idx_comment_reply_reply_depth; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_reply_reply_depth ON instagram."Comment_Reply" USING btree (reply_depth);


--
-- Name: idx_comment_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_comment_user_pk ON instagram."Comment" USING btree (user_pk);


--
-- Name: idx_country; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_country ON instagram."Location" USING btree (country);


--
-- Name: idx_direct_message_message_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_message_status ON instagram."DirectMessage" USING btree (message_status);


--
-- Name: idx_direct_message_thread_last_read_message_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_thread_last_read_message_pk ON instagram."DirectMessage_Thread" USING btree (last_read_message_pk);


--
-- Name: idx_direct_message_thread_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_thread_pk ON instagram."DirectMessage" USING btree (thread_pk);


--
-- Name: idx_direct_message_thread_thread_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_thread_thread_pk ON instagram."DirectMessage_Thread" USING btree (thread_pk);


--
-- Name: idx_direct_message_thread_thread_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_thread_thread_status ON instagram."DirectMessage_Thread" USING btree (thread_status);


--
-- Name: idx_direct_message_timestamp; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_timestamp ON instagram."DirectMessage" USING btree ("timestamp");


--
-- Name: idx_direct_message_user_message_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_user_message_pk ON instagram."DirectMessage_User" USING btree (message_pk);


--
-- Name: idx_direct_message_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_user_pk ON instagram."DirectMessage" USING btree (user_pk);


--
-- Name: idx_direct_message_user_read_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_user_read_status ON instagram."DirectMessage_User" USING btree (read_status);


--
-- Name: idx_direct_message_user_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_user_user_pk ON instagram."DirectMessage_User" USING btree (user_pk);


--
-- Name: idx_direct_message_user_user_role; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_message_user_user_role ON instagram."DirectMessage_User" USING btree (user_role);


--
-- Name: idx_direct_thread_last_activity_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_last_activity_at ON instagram."DirectThread" USING btree (last_activity_at);


--
-- Name: idx_direct_thread_muted; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_muted ON instagram."DirectThread" USING btree (muted);


--
-- Name: idx_direct_thread_pinned; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_pinned ON instagram."DirectThread" USING btree (pinned);


--
-- Name: idx_direct_thread_privacy_level; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_privacy_level ON instagram."DirectThread" USING btree (privacy_level);


--
-- Name: idx_direct_thread_user_last_interaction; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_user_last_interaction ON instagram."DirectThread_User" USING btree (last_interaction);


--
-- Name: idx_direct_thread_user_thread_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_user_thread_pk ON instagram."DirectThread_User" USING btree (thread_pk);


--
-- Name: idx_direct_thread_user_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_user_user_pk ON instagram."DirectThread_User" USING btree (user_pk);


--
-- Name: idx_direct_thread_user_user_role; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_direct_thread_user_user_role ON instagram."DirectThread_User" USING btree (user_role);


--
-- Name: idx_engagement_rate; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_engagement_rate ON instagram."Media" USING btree (engagement_rate);


--
-- Name: idx_expiration_date; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_expiration_date ON instagram."BioLink" USING btree (expiration_date);


--
-- Name: idx_file_size; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_file_size ON instagram."Resource" USING btree (file_size);


--
-- Name: idx_hashtag_compliance; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_hashtag_compliance ON instagram."Hashtag" USING btree (compliance) WHERE (compliance IS TRUE);


--
-- Name: idx_hashtag_is_trending; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_hashtag_is_trending ON instagram."Hashtag" USING btree (trending_score);


--
-- Name: idx_hashtag_monetization_potential; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_hashtag_monetization_potential ON instagram."Hashtag" USING btree (monetization_potential) WHERE (monetization_potential IS TRUE);


--
-- Name: idx_hashtag_name; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_hashtag_name ON instagram."Hashtag" USING btree (name);


--
-- Name: idx_hashtag_popularity_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_hashtag_popularity_score ON instagram."Hashtag" USING btree (popularity_score);


--
-- Name: idx_highlight_created_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_highlight_created_at ON instagram."Highlight" USING btree (created_at);


--
-- Name: idx_highlight_engagement_rate; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_highlight_engagement_rate ON instagram."Highlight" USING btree (engagement_rate);


--
-- Name: idx_highlight_media_engagement_rate; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_highlight_media_engagement_rate ON instagram."Highlight_Media" USING btree (engagement_rate);


--
-- Name: idx_highlight_media_order_index; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_highlight_media_order_index ON instagram."Highlight_Media" USING btree (order_index);


--
-- Name: idx_highlight_view_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_highlight_view_count ON instagram."Highlight" USING btree (view_count);


--
-- Name: idx_highlight_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_highlight_visibility ON instagram."Highlight" USING btree (visibility);


--
-- Name: idx_is_active; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_is_active ON instagram."BioLink" USING btree (is_active);


--
-- Name: idx_is_clicked; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_is_clicked ON instagram."User_BioLink" USING btree (is_clicked);


--
-- Name: idx_is_verified; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_is_verified ON instagram."Location" USING btree (is_verified);


--
-- Name: idx_link_click_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_link_click_count ON instagram."Link" USING btree (click_count);


--
-- Name: idx_link_is_verified; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_link_is_verified ON instagram."Link" USING btree (is_verified);


--
-- Name: idx_link_link_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_link_link_type ON instagram."Link" USING btree (link_type);


--
-- Name: idx_link_url; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_link_url ON instagram."Link" USING btree (url);


--
-- Name: idx_lng_lat; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_lng_lat ON instagram."Location" USING gist (instagram.ll_to_earth(lat, lng));


--
-- Name: idx_media_comment_comment_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_comment_comment_pk ON instagram."Media_Comment" USING btree (comment_pk);


--
-- Name: idx_media_comment_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_comment_media_pk ON instagram."Media_Comment" USING btree (media_pk);


--
-- Name: idx_media_comment_moderation_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_comment_moderation_status ON instagram."Media_Comment" USING btree (moderation_status);


--
-- Name: idx_media_comment_parent_comment_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_comment_parent_comment_pk ON instagram."Media_Comment" USING btree (parent_comment_pk);


--
-- Name: idx_media_comment_sentiment_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_comment_sentiment_score ON instagram."Media_Comment" USING btree (sentiment_score);


--
-- Name: idx_media_hashtag_engagement_rate_by_hashtag; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_hashtag_engagement_rate_by_hashtag ON instagram."Media_Hashtag" USING btree (engagement_rate_by_hashtag);


--
-- Name: idx_media_hashtag_hashtag_impact_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_hashtag_hashtag_impact_score ON instagram."Media_Hashtag" USING btree (hashtag_impact_score);


--
-- Name: idx_media_hashtag_hashtag_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_hashtag_hashtag_pk ON instagram."Media_Hashtag" USING btree (hashtag_pk);


--
-- Name: idx_media_hashtag_is_trending; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_hashtag_is_trending ON instagram."Media_Hashtag" USING btree (is_trending);


--
-- Name: idx_media_hashtag_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_hashtag_media_pk ON instagram."Media_Hashtag" USING btree (media_pk);


--
-- Name: idx_media_location_location_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_location_location_pk ON instagram."Media_Location" USING btree (location_pk);


--
-- Name: idx_media_location_location_sentiment_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_location_location_sentiment_score ON instagram."Media_Location" USING btree (location_sentiment_score);


--
-- Name: idx_media_location_location_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_location_location_type ON instagram."Media_Location" USING btree (location_type);


--
-- Name: idx_media_location_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_location_media_pk ON instagram."Media_Location" USING btree (media_pk);


--
-- Name: idx_media_location_name; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_location_name ON instagram."Media" USING btree (location_name);


--
-- Name: idx_media_location_trending_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_location_trending_score ON instagram."Media_Location" USING btree (trending_score);


--
-- Name: idx_media_media_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_media_type ON instagram."Media" USING btree (media_type);


--
-- Name: idx_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_pk ON instagram."Usertag" USING btree (media_pk);


--
-- Name: idx_media_resource_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_resource_media_pk ON instagram."Media_Resource" USING btree (media_pk);


--
-- Name: idx_media_resource_resource_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_resource_resource_pk ON instagram."Media_Resource" USING btree (resource_pk);


--
-- Name: idx_media_sponsor_campaign_id; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_sponsor_campaign_id ON instagram."Media_Sponsor" USING btree (campaign_id);


--
-- Name: idx_media_sponsor_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_sponsor_media_pk ON instagram."Media_Sponsor" USING btree (media_pk);


--
-- Name: idx_media_sponsor_performance_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_sponsor_performance_score ON instagram."Media_Sponsor" USING btree (performance_score);


--
-- Name: idx_media_sponsor_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_sponsor_user_pk ON instagram."Media_Sponsor" USING btree (user_pk);


--
-- Name: idx_media_story_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_story_media_pk ON instagram."Media_Story" USING btree (media_pk);


--
-- Name: idx_media_story_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_story_story_pk ON instagram."Media_Story" USING btree (story_pk);


--
-- Name: idx_media_story_story_sequence; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_story_story_sequence ON instagram."Media_Story" USING btree (story_sequence);


--
-- Name: idx_media_story_view_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_story_view_count ON instagram."Media_Story" USING btree (view_count);


--
-- Name: idx_media_tags; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_tags ON instagram."Media" USING gin (tags);


--
-- Name: idx_media_taken_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_taken_at ON instagram."Media" USING btree (taken_at);


--
-- Name: idx_media_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_type ON instagram."Resource" USING btree (media_type);


--
-- Name: idx_media_usertag_media_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_usertag_media_pk ON instagram."Media_Usertag" USING btree (media_pk);


--
-- Name: idx_media_usertag_tag_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_usertag_tag_type ON instagram."Media_Usertag" USING btree (tag_type);


--
-- Name: idx_media_usertag_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_usertag_user_pk ON instagram."Media_Usertag" USING btree (user_pk);


--
-- Name: idx_media_usertag_visibility_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_media_usertag_visibility_status ON instagram."Media_Usertag" USING btree (visibility_status);


--
-- Name: idx_mime_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_mime_type ON instagram."Resource" USING btree (mime_type);


--
-- Name: idx_name; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_name ON instagram."Location" USING btree (name);


--
-- Name: idx_note_categories; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_categories ON instagram."Note" USING gin (categories jsonb_path_ops);


--
-- Name: idx_note_created_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_created_at ON instagram."Note" USING btree (created_at);


--
-- Name: idx_note_tags; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_tags ON instagram."Note" USING gin (tags jsonb_path_ops);


--
-- Name: idx_note_user_interaction_timestamp; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_user_interaction_timestamp ON instagram."Note_User" USING btree (interaction_timestamp);


--
-- Name: idx_note_user_note_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_user_note_pk ON instagram."Note_User" USING btree (note_pk);


--
-- Name: idx_note_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_user_pk ON instagram."Note" USING btree (user_pk);


--
-- Name: idx_note_user_relationship_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_user_relationship_type ON instagram."Note_User" USING btree (relationship_type);


--
-- Name: idx_note_user_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_note_user_user_pk ON instagram."Note_User" USING btree (user_pk);


--
-- Name: idx_place_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_place_type ON instagram."Location" USING btree (place_type);


--
-- Name: idx_posted_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_posted_at ON instagram."User_Media" USING btree (posted_at);


--
-- Name: idx_priority_order; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_priority_order ON instagram."User_BioLink" USING btree (priority_order);


--
-- Name: idx_public_email; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_public_email ON instagram."User" USING btree (public_email);


--
-- Name: idx_region; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_region ON instagram."Location" USING btree (region);


--
-- Name: idx_relation_type; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relation_type ON instagram."Media_Resource" USING btree (relation_type);


--
-- Name: idx_relationship_blocking; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_blocking ON instagram."Relationship" USING btree (blocking);


--
-- Name: idx_relationship_followed_by; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_followed_by ON instagram."Relationship" USING btree (followed_by);


--
-- Name: idx_relationship_following; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_following ON instagram."Relationship" USING btree (following);


--
-- Name: idx_relationship_interaction_history; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_interaction_history ON instagram."Relationship_User" USING gin (interaction_history);


--
-- Name: idx_relationship_relationship_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_relationship_pk ON instagram."Relationship_User" USING btree (relationship_pk);


--
-- Name: idx_relationship_target_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_target_user_pk ON instagram."Relationship_User" USING btree (target_user_pk);


--
-- Name: idx_relationship_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_relationship_user_pk ON instagram."Relationship" USING btree (user_pk);


--
-- Name: idx_sequence_order; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_sequence_order ON instagram."Media_Resource" USING btree (sequence_order);


--
-- Name: idx_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_status ON instagram."Media_Resource" USING btree (status);


--
-- Name: idx_story_audience_engagement_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_audience_engagement_score ON instagram."Story" USING btree (audience_engagement_score);


--
-- Name: idx_story_comment_comment_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_comment_comment_pk ON instagram."Story_Comment" USING btree (comment_pk);


--
-- Name: idx_story_comment_moderation_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_comment_moderation_status ON instagram."Story_Comment" USING btree (moderation_status);


--
-- Name: idx_story_comment_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_comment_story_pk ON instagram."Story_Comment" USING btree (story_pk);


--
-- Name: idx_story_comment_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_comment_visibility ON instagram."Story_Comment" USING btree (visibility);


--
-- Name: idx_story_hashtag_hashtag_impact_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_hashtag_hashtag_impact_score ON instagram."Story_Hashtag" USING btree (hashtag_impact_score);


--
-- Name: idx_story_hashtag_hashtag_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_hashtag_hashtag_pk ON instagram."Story_Hashtag" USING btree (hashtag_pk);


--
-- Name: idx_story_hashtag_is_trending; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_hashtag_is_trending ON instagram."Story_Hashtag" USING btree (is_trending);


--
-- Name: idx_story_hashtag_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_hashtag_story_pk ON instagram."Story_Hashtag" USING btree (story_pk);


--
-- Name: idx_story_hashtag_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_hashtag_visibility ON instagram."Story_Hashtag" USING btree (visibility);


--
-- Name: idx_story_highlight_highlight_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_highlight_highlight_pk ON instagram."Story_Highlight" USING btree (highlight_pk);


--
-- Name: idx_story_highlight_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_highlight_story_pk ON instagram."Story_Highlight" USING btree (story_pk);


--
-- Name: idx_story_highlight_view_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_highlight_view_count ON instagram."Story_Highlight" USING btree (view_count);


--
-- Name: idx_story_link_click_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_link_click_count ON instagram."Story_Link" USING btree (click_count);


--
-- Name: idx_story_link_link_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_link_link_pk ON instagram."Story_Link" USING btree (link_pk);


--
-- Name: idx_story_link_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_link_story_pk ON instagram."Story_Link" USING btree (story_pk);


--
-- Name: idx_story_link_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_link_visibility ON instagram."Story_Link" USING btree (visibility);


--
-- Name: idx_story_location_is_trending; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_location_is_trending ON instagram."Story_Location" USING btree (is_trending);


--
-- Name: idx_story_location_local_popularity_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_location_local_popularity_score ON instagram."Story_Location" USING btree (local_popularity_score);


--
-- Name: idx_story_location_location_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_location_location_pk ON instagram."Story_Location" USING btree (location_pk);


--
-- Name: idx_story_location_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_location_story_pk ON instagram."Story_Location" USING btree (story_pk);


--
-- Name: idx_story_location_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_location_visibility ON instagram."Story_Location" USING btree (visibility);


--
-- Name: idx_story_taken_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_taken_at ON instagram."Story" USING btree (taken_at);


--
-- Name: idx_story_user_interest_score; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_user_interest_score ON instagram."Story_User" USING btree (interest_score);


--
-- Name: idx_story_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_user_pk ON instagram."Story" USING btree (user_pk);


--
-- Name: idx_story_user_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_user_story_pk ON instagram."Story_User" USING btree (story_pk);


--
-- Name: idx_story_user_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_user_user_pk ON instagram."Story_User" USING btree (user_pk);


--
-- Name: idx_story_user_view_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_user_view_status ON instagram."Story_User" USING btree (view_status);


--
-- Name: idx_story_usertag_approval_status; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_usertag_approval_status ON instagram."Story_Usertag" USING btree (approval_status);


--
-- Name: idx_story_usertag_story_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_usertag_story_pk ON instagram."Story_Usertag" USING btree (story_pk);


--
-- Name: idx_story_usertag_usertag_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_usertag_usertag_user_pk ON instagram."Story_Usertag" USING btree (usertag_user_pk);


--
-- Name: idx_story_usertag_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_usertag_visibility ON instagram."Story_Usertag" USING btree (visibility);


--
-- Name: idx_story_visibility; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_story_visibility ON instagram."Story" USING btree (visibility);


--
-- Name: idx_tagged_by_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_tagged_by_user_pk ON instagram."Usertag" USING btree (tagged_by_user_pk);


--
-- Name: idx_taken_at; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_taken_at ON instagram."Media" USING btree (taken_at);


--
-- Name: idx_track_genre; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_track_genre ON instagram."Track" USING btree (genre);


--
-- Name: idx_track_like_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_track_like_count ON instagram."Track" USING btree (like_count);


--
-- Name: idx_track_play_count; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_track_play_count ON instagram."Track" USING btree (play_count);


--
-- Name: idx_track_release_date; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_track_release_date ON instagram."Track" USING btree (release_date);


--
-- Name: idx_user_pk; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_user_pk ON instagram."User_BioLink" USING btree (user_pk);


--
-- Name: idx_username; Type: INDEX; Schema: instagram; Owner: postgres
--

CREATE INDEX idx_username ON instagram."User" USING btree (username);


--
-- Name: Collection Collection_owner_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Collection"
    ADD CONSTRAINT "Collection_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES instagram."User" (pk) ON DELETE SET NULL;


--
-- Name: Collection Collection_parent_collection_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Collection"
    ADD CONSTRAINT "Collection_parent_collection_id_fkey" FOREIGN KEY (parent_collection_id) REFERENCES instagram."Collection" (id) ON DELETE CASCADE;


--
-- Name: Comment_Mention Comment_Mention_comment_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment_Mention"
    ADD CONSTRAINT "Comment_Mention_comment_pk_fkey" FOREIGN KEY (comment_pk) REFERENCES instagram."Comment" (pk);


--
-- Name: Comment_Mention Comment_Mention_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment_Mention"
    ADD CONSTRAINT "Comment_Mention_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Comment_Reply Comment_Reply_parent_comment_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment_Reply"
    ADD CONSTRAINT "Comment_Reply_parent_comment_pk_fkey" FOREIGN KEY (parent_comment_pk) REFERENCES instagram."Comment" (pk);


--
-- Name: Comment_Reply Comment_Reply_reply_comment_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment_Reply"
    ADD CONSTRAINT "Comment_Reply_reply_comment_pk_fkey" FOREIGN KEY (reply_comment_pk) REFERENCES instagram."Comment" (pk);


--
-- Name: Comment Comment_parent_media_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment"
    ADD CONSTRAINT "Comment_parent_media_id_fkey" FOREIGN KEY (parent_media_id) REFERENCES instagram."Media" (pk);


--
-- Name: Comment Comment_replied_to_comment_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment"
    ADD CONSTRAINT "Comment_replied_to_comment_id_fkey" FOREIGN KEY (replied_to_comment_id) REFERENCES instagram."Comment" (pk);


--
-- Name: Comment Comment_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Comment"
    ADD CONSTRAINT "Comment_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: DirectMessage_Thread DirectMessage_Thread_last_read_message_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_Thread"
    ADD CONSTRAINT "DirectMessage_Thread_last_read_message_pk_fkey" FOREIGN KEY (last_read_message_pk) REFERENCES instagram."DirectMessage" (id);


--
-- Name: DirectMessage_Thread DirectMessage_Thread_message_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_Thread"
    ADD CONSTRAINT "DirectMessage_Thread_message_pk_fkey" FOREIGN KEY (message_pk) REFERENCES instagram."DirectMessage" (id);


--
-- Name: DirectMessage_Thread DirectMessage_Thread_thread_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_Thread"
    ADD CONSTRAINT "DirectMessage_Thread_thread_pk_fkey" FOREIGN KEY (thread_pk) REFERENCES instagram."DirectThread" (pk);


--
-- Name: DirectMessage_User DirectMessage_User_message_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_User"
    ADD CONSTRAINT "DirectMessage_User_message_pk_fkey" FOREIGN KEY (message_pk) REFERENCES instagram."DirectMessage" (id);


--
-- Name: DirectMessage_User DirectMessage_User_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectMessage_User"
    ADD CONSTRAINT "DirectMessage_User_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: DirectThread_User DirectThread_User_thread_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectThread_User"
    ADD CONSTRAINT "DirectThread_User_thread_pk_fkey" FOREIGN KEY (thread_pk) REFERENCES instagram."DirectThread" (pk);


--
-- Name: DirectThread_User DirectThread_User_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."DirectThread_User"
    ADD CONSTRAINT "DirectThread_User_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Highlight_Media Highlight_Media_highlight_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Highlight_Media"
    ADD CONSTRAINT "Highlight_Media_highlight_pk_fkey" FOREIGN KEY (highlight_pk) REFERENCES instagram."Highlight" (pk);


--
-- Name: Highlight_Media Highlight_Media_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Highlight_Media"
    ADD CONSTRAINT "Highlight_Media_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Location Location_owner_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Location"
    ADD CONSTRAINT "Location_owner_user_pk_fkey" FOREIGN KEY (owner_user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Media_Comment Media_Comment_comment_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Comment"
    ADD CONSTRAINT "Media_Comment_comment_pk_fkey" FOREIGN KEY (comment_pk) REFERENCES instagram."Comment" (pk);


--
-- Name: Media_Comment Media_Comment_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Comment"
    ADD CONSTRAINT "Media_Comment_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Comment Media_Comment_parent_comment_pk_comment_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Comment"
    ADD CONSTRAINT "Media_Comment_parent_comment_pk_comment_pk_fkey" FOREIGN KEY (parent_comment_pk, comment_pk) REFERENCES instagram."Media_Comment" (media_pk, comment_pk);


--
-- Name: Media_Hashtag Media_Hashtag_hashtag_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Hashtag"
    ADD CONSTRAINT "Media_Hashtag_hashtag_pk_fkey" FOREIGN KEY (hashtag_pk) REFERENCES instagram."Hashtag" (id);


--
-- Name: Media_Hashtag Media_Hashtag_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Hashtag"
    ADD CONSTRAINT "Media_Hashtag_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Location Media_Location_location_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Location"
    ADD CONSTRAINT "Media_Location_location_pk_fkey" FOREIGN KEY (location_pk) REFERENCES instagram."Location" (pk);


--
-- Name: Media_Location Media_Location_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Location"
    ADD CONSTRAINT "Media_Location_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Resource Media_Resource_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Resource"
    ADD CONSTRAINT "Media_Resource_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Resource Media_Resource_resource_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Resource"
    ADD CONSTRAINT "Media_Resource_resource_pk_fkey" FOREIGN KEY (resource_pk) REFERENCES instagram."Resource" (pk);


--
-- Name: Media_Sponsor Media_Sponsor_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Sponsor"
    ADD CONSTRAINT "Media_Sponsor_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Sponsor Media_Sponsor_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Sponsor"
    ADD CONSTRAINT "Media_Sponsor_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Media_Story Media_Story_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Story"
    ADD CONSTRAINT "Media_Story_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Story Media_Story_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Story"
    ADD CONSTRAINT "Media_Story_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Media_Usertag Media_Usertag_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Usertag"
    ADD CONSTRAINT "Media_Usertag_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Media_Usertag Media_Usertag_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media_Usertag"
    ADD CONSTRAINT "Media_Usertag_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Media Media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Media"
    ADD CONSTRAINT "Media_pk_fkey" FOREIGN KEY (pk) REFERENCES instagram."User" (pk);


--
-- Name: Note_User Note_User_note_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Note_User"
    ADD CONSTRAINT "Note_User_note_pk_fkey" FOREIGN KEY (note_pk) REFERENCES instagram."Note" (id);


--
-- Name: Note_User Note_User_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Note_User"
    ADD CONSTRAINT "Note_User_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Relationship_User Relationship_User_relationship_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Relationship_User"
    ADD CONSTRAINT "Relationship_User_relationship_pk_fkey" FOREIGN KEY (relationship_pk) REFERENCES instagram."Relationship" (user_pk);


--
-- Name: Relationship_User Relationship_User_target_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Relationship_User"
    ADD CONSTRAINT "Relationship_User_target_user_pk_fkey" FOREIGN KEY (target_user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Relationship_User Relationship_User_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Relationship_User"
    ADD CONSTRAINT "Relationship_User_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: StoryHashtag StoryHashtag_hashtag_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryHashtag"
    ADD CONSTRAINT "StoryHashtag_hashtag_id_fkey" FOREIGN KEY (hashtag_id) REFERENCES instagram."Hashtag" (id);


--
-- Name: StoryHashtag StoryHashtag_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryHashtag"
    ADD CONSTRAINT "StoryHashtag_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: StoryLocation StoryLocation_location_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryLocation"
    ADD CONSTRAINT "StoryLocation_location_pk_fkey" FOREIGN KEY (location_pk) REFERENCES instagram."Location" (pk);


--
-- Name: StoryLocation StoryLocation_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryLocation"
    ADD CONSTRAINT "StoryLocation_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: StoryMention StoryMention_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryMention"
    ADD CONSTRAINT "StoryMention_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: StoryMention StoryMention_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StoryMention"
    ADD CONSTRAINT "StoryMention_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: StorySticker StorySticker_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."StorySticker"
    ADD CONSTRAINT "StorySticker_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Comment Story_Comment_comment_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Comment"
    ADD CONSTRAINT "Story_Comment_comment_pk_fkey" FOREIGN KEY (comment_pk) REFERENCES instagram."Comment" (pk);


--
-- Name: Story_Comment Story_Comment_media_attachment_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Comment"
    ADD CONSTRAINT "Story_Comment_media_attachment_id_fkey" FOREIGN KEY (media_attachment_id) REFERENCES instagram."Media" (pk);


--
-- Name: Story_Comment Story_Comment_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Comment"
    ADD CONSTRAINT "Story_Comment_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Hashtag Story_Hashtag_hashtag_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Hashtag"
    ADD CONSTRAINT "Story_Hashtag_hashtag_pk_fkey" FOREIGN KEY (hashtag_pk) REFERENCES instagram."Hashtag" (id);


--
-- Name: Story_Hashtag Story_Hashtag_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Hashtag"
    ADD CONSTRAINT "Story_Hashtag_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Highlight Story_Highlight_highlight_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Highlight"
    ADD CONSTRAINT "Story_Highlight_highlight_pk_fkey" FOREIGN KEY (highlight_pk) REFERENCES instagram."Highlight" (pk);


--
-- Name: Story_Highlight Story_Highlight_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Highlight"
    ADD CONSTRAINT "Story_Highlight_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Link Story_Link_link_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Link"
    ADD CONSTRAINT "Story_Link_link_pk_fkey" FOREIGN KEY (link_pk) REFERENCES instagram."Link" (id);


--
-- Name: Story_Link Story_Link_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Link"
    ADD CONSTRAINT "Story_Link_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Location Story_Location_location_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Location"
    ADD CONSTRAINT "Story_Location_location_pk_fkey" FOREIGN KEY (location_pk) REFERENCES instagram."Location" (pk);


--
-- Name: Story_Location Story_Location_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Location"
    ADD CONSTRAINT "Story_Location_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Sticker Story_Sticker_sticker_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Sticker"
    ADD CONSTRAINT "Story_Sticker_sticker_pk_fkey" FOREIGN KEY (sticker_pk) REFERENCES instagram."StorySticker" (id);


--
-- Name: Story_Sticker Story_Sticker_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Sticker"
    ADD CONSTRAINT "Story_Sticker_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_User Story_User_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_User"
    ADD CONSTRAINT "Story_User_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_User Story_User_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_User"
    ADD CONSTRAINT "Story_User_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Story_Usertag Story_Usertag_story_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Usertag"
    ADD CONSTRAINT "Story_Usertag_story_pk_fkey" FOREIGN KEY (story_pk) REFERENCES instagram."Story" (pk);


--
-- Name: Story_Usertag Story_Usertag_usertag_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story_Usertag"
    ADD CONSTRAINT "Story_Usertag_usertag_user_pk_fkey" FOREIGN KEY (usertag_user_pk) REFERENCES instagram."Usertag" (user_pk);


--
-- Name: Story Story_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Story"
    ADD CONSTRAINT "Story_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: User_BioLink User_BioLink_bio_link_id_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User_BioLink"
    ADD CONSTRAINT "User_BioLink_bio_link_id_fkey" FOREIGN KEY (bio_link_id) REFERENCES instagram."BioLink" (link_id);


--
-- Name: User_BioLink User_BioLink_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User_BioLink"
    ADD CONSTRAINT "User_BioLink_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: User_Media User_Media_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User_Media"
    ADD CONSTRAINT "User_Media_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: User_Media User_Media_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."User_Media"
    ADD CONSTRAINT "User_Media_user_pk_fkey" FOREIGN KEY (user_pk) REFERENCES instagram."User" (pk);


--
-- Name: Usertag Usertag_media_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Usertag"
    ADD CONSTRAINT "Usertag_media_pk_fkey" FOREIGN KEY (media_pk) REFERENCES instagram."Media" (pk);


--
-- Name: Usertag Usertag_tagged_by_user_pk_fkey; Type: FK CONSTRAINT; Schema: instagram; Owner: postgres
--

ALTER TABLE ONLY instagram."Usertag"
    ADD CONSTRAINT "Usertag_tagged_by_user_pk_fkey" FOREIGN KEY (tagged_by_user_pk) REFERENCES instagram."User" (pk);


--
-- Name: TABLE "BioLink"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."BioLink" FROM postgres;
GRANT ALL ON TABLE instagram."BioLink" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Collection"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Collection" FROM postgres;
GRANT ALL ON TABLE instagram."Collection" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Comment"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Comment" FROM postgres;
GRANT ALL ON TABLE instagram."Comment" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Comment_Mention"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Comment_Mention" FROM postgres;
GRANT ALL ON TABLE instagram."Comment_Mention" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Comment_Reply"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Comment_Reply" FROM postgres;
GRANT ALL ON TABLE instagram."Comment_Reply" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Constants"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Constants" FROM postgres;
GRANT ALL ON TABLE instagram."Constants" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "DirectMessage"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."DirectMessage" FROM postgres;
GRANT ALL ON TABLE instagram."DirectMessage" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "DirectMessage_Thread"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."DirectMessage_Thread" FROM postgres;
GRANT ALL ON TABLE instagram."DirectMessage_Thread" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "DirectMessage_User"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."DirectMessage_User" FROM postgres;
GRANT ALL ON TABLE instagram."DirectMessage_User" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "DirectThread"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."DirectThread" FROM postgres;
GRANT ALL ON TABLE instagram."DirectThread" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "DirectThread_User"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."DirectThread_User" FROM postgres;
GRANT ALL ON TABLE instagram."DirectThread_User" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Hashtag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Hashtag" FROM postgres;
GRANT ALL ON TABLE instagram."Hashtag" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Highlight"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Highlight" FROM postgres;
GRANT ALL ON TABLE instagram."Highlight" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Highlight_Media"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Highlight_Media" FROM postgres;
GRANT ALL ON TABLE instagram."Highlight_Media" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Link"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Link" FROM postgres;
GRANT ALL ON TABLE instagram."Link" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Location"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Location" FROM postgres;
GRANT ALL ON TABLE instagram."Location" TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE "Location_pk_seq"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON SEQUENCE instagram."Location_pk_seq" FROM postgres;
GRANT ALL ON SEQUENCE instagram."Location_pk_seq" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media" FROM postgres;
GRANT ALL ON TABLE instagram."Media" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Comment"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Comment" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Comment" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Hashtag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Hashtag" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Hashtag" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Location"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Location" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Location" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Resource"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Resource" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Resource" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Sponsor"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Sponsor" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Sponsor" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Story"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Story" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Story" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Media_Usertag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Media_Usertag" FROM postgres;
GRANT ALL ON TABLE instagram."Media_Usertag" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Note"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Note" FROM postgres;
GRANT ALL ON TABLE instagram."Note" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Note_User"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Note_User" FROM postgres;
GRANT ALL ON TABLE instagram."Note_User" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Relationship"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Relationship" FROM postgres;
GRANT ALL ON TABLE instagram."Relationship" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Relationship_User"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Relationship_User" FROM postgres;
GRANT ALL ON TABLE instagram."Relationship_User" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Resource"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Resource" FROM postgres;
GRANT ALL ON TABLE instagram."Resource" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story" FROM postgres;
GRANT ALL ON TABLE instagram."Story" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "StoryHashtag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."StoryHashtag" FROM postgres;
GRANT ALL ON TABLE instagram."StoryHashtag" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "StoryLocation"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."StoryLocation" FROM postgres;
GRANT ALL ON TABLE instagram."StoryLocation" TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE "StoryLocation_location_pk_seq"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON SEQUENCE instagram."StoryLocation_location_pk_seq" FROM postgres;
GRANT ALL ON SEQUENCE instagram."StoryLocation_location_pk_seq" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "StoryMention"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."StoryMention" FROM postgres;
GRANT ALL ON TABLE instagram."StoryMention" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "StorySticker"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."StorySticker" FROM postgres;
GRANT ALL ON TABLE instagram."StorySticker" TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE "StorySticker_id_seq"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON SEQUENCE instagram."StorySticker_id_seq" FROM postgres;
GRANT ALL ON SEQUENCE instagram."StorySticker_id_seq" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Comment"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Comment" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Comment" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Hashtag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Hashtag" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Hashtag" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Highlight"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Highlight" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Highlight" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Link"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Link" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Link" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Location"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Location" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Location" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Sticker"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Sticker" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Sticker" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_User"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_User" FROM postgres;
GRANT ALL ON TABLE instagram."Story_User" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Story_Usertag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Story_Usertag" FROM postgres;
GRANT ALL ON TABLE instagram."Story_Usertag" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Track"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Track" FROM postgres;
GRANT ALL ON TABLE instagram."Track" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "User"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."User" FROM postgres;
GRANT ALL ON TABLE instagram."User" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "User_BioLink"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."User_BioLink" FROM postgres;
GRANT ALL ON TABLE instagram."User_BioLink" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "User_Media"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."User_Media" FROM postgres;
GRANT ALL ON TABLE instagram."User_Media" TO postgres WITH GRANT OPTION;


--
-- Name: TABLE "Usertag"; Type: ACL; Schema: instagram; Owner: postgres
--

REVOKE ALL ON TABLE instagram."Usertag" FROM postgres;
GRANT ALL ON TABLE instagram."Usertag" TO postgres WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--
