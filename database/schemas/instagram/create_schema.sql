-- Create table for User entity
CREATE TABLE IF NOT EXISTS "user"
(
    userID             SERIAL PRIMARY KEY,
    username           VARCHAR(255) NOT NULL,
    fullName           VARCHAR(255),
    isPrivate          BOOLEAN,
    isVerified         BOOLEAN,
    profilePicURL      VARCHAR(255),
    email              VARCHAR(255),
    phoneNumber        VARCHAR(20),
    bio                TEXT,
    website            VARCHAR(255),
    followingCount     INTEGER,
    followerCount      INTEGER,
    postsCount         INTEGER,
    totalLikesReceived INTEGER,
    totalCommentsReceived INTEGER,
    engagementRate     FLOAT,
    lastActiveTime     TIMESTAMP,
    canSendDirectMessages BOOLEAN,
    canTag             BOOLEAN,
    canComment         BOOLEAN,
    canViewStory       BOOLEAN,
    createdAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Location entity
CREATE TABLE IF NOT EXISTS Location
(
    locationID SERIAL PRIMARY KEY,
    name      VARCHAR(255),
    address   TEXT,
    latitude  FLOAT,
    longitude FLOAT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Media entity
CREATE TABLE IF NOT EXISTS Media
(
    mediaID     SERIAL PRIMARY KEY,
    userID      INTEGER REFERENCES "user" (userID),
    locationID  INTEGER REFERENCES Location (locationID),
    mediaType   VARCHAR(10),
    caption     TEXT,
    postedTime  TIMESTAMP,
    likeCount   INTEGER,
    commentCount INTEGER,
    viewCount   INTEGER,
    isArchived  BOOLEAN,
    isVisible   BOOLEAN,
    status      VARCHAR(10),
    isMonetized BOOLEAN,
    earnings    DECIMAL(10, 2),
    sponsorID   INTEGER REFERENCES "user" (userID),
    viewType    VARCHAR(20),
    postType    VARCHAR(10),
    createdAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Resource entity
CREATE TABLE IF NOT EXISTS Resource
(
    resourceID   SERIAL PRIMARY KEY,
    mediaID      INTEGER REFERENCES Media (mediaID),
    resourceURL  VARCHAR(255),
    resourceType VARCHAR(10),
    sequenceNumber INTEGER,
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for MediaOembed entity
CREATE TABLE IF NOT EXISTS MediaOembed
(
    oembedID  SERIAL PRIMARY KEY,
    mediaID   INTEGER REFERENCES Media (mediaID),
    shortURL  VARCHAR(255),
    providerURL VARCHAR(255),
    html      TEXT,
    width     INTEGER,
    height    INTEGER,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserShort entity
CREATE TABLE IF NOT EXISTS UserShort
(
    userShortID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Usertag entity
CREATE TABLE IF NOT EXISTS Usertag
(
    usertagID   SERIAL PRIMARY KEY,
    mediaID     INTEGER REFERENCES Media (mediaID),
    userShortID INTEGER REFERENCES UserShort (userShortID),
    xCoordinate INTEGER,
    yCoordinate INTEGER,
    createdAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Hashtag entity
CREATE TABLE IF NOT EXISTS Hashtag
(
    hashtagID          SERIAL PRIMARY KEY,
    name               VARCHAR(255),
    mediaCount         INTEGER,
    trendingScore      FLOAT,
    relevanceScore     FLOAT,
    status             VARCHAR(10),
    profileID          INTEGER REFERENCES "user" (userID),
    performanceScore   FLOAT,
    userEngagementRate FLOAT,
    algorithmPreferenceScore FLOAT,
    lastUsedDate       TIMESTAMP,
    createdAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Collection entity
CREATE TABLE IF NOT EXISTS Collection
(
    collectionID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    name      VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Comment entity
CREATE TABLE IF NOT EXISTS Comment
(
    commentID SERIAL PRIMARY KEY,
    mediaID   INTEGER REFERENCES Media (mediaID),
    userID    INTEGER REFERENCES "user" (userID),
    text      TEXT,
    postedTime TIMESTAMP,
    isEdited  BOOLEAN,
    likeCount INTEGER,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Highlight entity
CREATE TABLE IF NOT EXISTS Highlight
(
    highlightID  SERIAL PRIMARY KEY,
    userID       INTEGER REFERENCES "user" (userID),
    name         VARCHAR(255),
    coverMediaID INTEGER REFERENCES Media (mediaID),
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Story entity
CREATE TABLE IF NOT EXISTS Story
(
    storyID    SERIAL PRIMARY KEY,
    userID     INTEGER REFERENCES "user" (userID),
    postedTime TIMESTAMP,
    expiresAt  TIMESTAMP,
    viewCount  INTEGER,
    replyCount INTEGER,
    shareCount INTEGER,
    allowReplies BOOLEAN,
    allowSharing BOOLEAN,
    isArchived BOOLEAN,
    locationID INTEGER REFERENCES Location (locationID),
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for DirectThread entity
CREATE TABLE IF NOT EXISTS DirectThread
(
    threadID SERIAL PRIMARY KEY,
    subject  TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for DirectMessage entity
CREATE TABLE IF NOT EXISTS DirectMessage
(
    messageID SERIAL PRIMARY KEY,
    threadID INTEGER REFERENCES DirectThread (threadID),
    senderID INTEGER REFERENCES "user" (userID),
    text     TEXT,
    sentTime TIMESTAMP,
    isSeen   BOOLEAN,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Insight entity
CREATE TABLE IF NOT EXISTS Insight
(
    insightID         SERIAL PRIMARY KEY,
    mediaID           INTEGER REFERENCES Media (mediaID),
    viewType          VARCHAR(20),
    viewCount         INTEGER,
    newFollowersCount INTEGER,
    conversionRate    FLOAT,
    subscriptionConversionRate FLOAT,
    createdAt         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Track entity
CREATE TABLE IF NOT EXISTS Track
(
    trackID   SERIAL PRIMARY KEY,
    name      VARCHAR(255),
    artist    VARCHAR(255),
    licenseInfo TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserVerifiedStatusHistory entity
CREATE TABLE IF NOT EXISTS UserVerifiedStatusHistory
(
    historyID  SERIAL PRIMARY KEY,
    userID     INTEGER REFERENCES "user" (userID),
    verifiedStatus BOOLEAN,
    changeDate TIMESTAMP,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserActivityLog entity
CREATE TABLE IF NOT EXISTS UserActivityLog
(
    activityID SERIAL PRIMARY KEY,
    userID     INTEGER REFERENCES "user" (userID),
    activityType VARCHAR(20),
    activityDate TIMESTAMP,
    details    TEXT,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for MediaInteraction entity
CREATE TABLE IF NOT EXISTS MediaInteraction
(
    interactionID SERIAL PRIMARY KEY,
    mediaID       INTEGER REFERENCES Media (mediaID),
    userID        INTEGER REFERENCES "user" (userID),
    interactionType VARCHAR(20),
    interactionDate TIMESTAMP,
    createdAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserPreferences entity
CREATE TABLE IF NOT EXISTS UserPreferences
(
    preferenceID   SERIAL PRIMARY KEY,
    userID         INTEGER REFERENCES "user" (userID),
    preferenceType VARCHAR(20),
    preferenceValue TEXT,
    createdAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for AdCampaign entity
CREATE TABLE IF NOT EXISTS AdCampaign
(
    campaignID   SERIAL PRIMARY KEY,
    sponsorID    INTEGER REFERENCES "user" (userID),
    campaignName VARCHAR(255),
    startDate    TIMESTAMP,
    endDate      TIMESTAMP,
    budget       DECIMAL(10, 2),
    targetAudience TEXT,
    status       VARCHAR(10),
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for SponsoredContent entity
CREATE TABLE IF NOT EXISTS SponsoredContent
(
    sponsoredID SERIAL PRIMARY KEY,
    mediaID    INTEGER REFERENCES Media (mediaID),
    campaignID INTEGER REFERENCES AdCampaign (campaignID),
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ContentRecommendation entity
CREATE TABLE IF NOT EXISTS ContentRecommendation
(
    recommendationID   SERIAL PRIMARY KEY,
    mediaID            INTEGER REFERENCES Media (mediaID),
    recommendedMediaID INTEGER REFERENCES Media (mediaID),
    recommendationScore FLOAT,
    createdAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Event entity
CREATE TABLE IF NOT EXISTS Event
(
    eventID     SERIAL PRIMARY KEY,
    eventName   VARCHAR(255),
    eventType   VARCHAR(20),
    startDate   TIMESTAMP,
    endDate     TIMESTAMP,
    locationID  INTEGER REFERENCES Location (locationID),
    organizerID INTEGER REFERENCES "user" (userID),
    description TEXT,
    isPublic    BOOLEAN,
    createdAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for SubscriptionPlan entity
CREATE TABLE IF NOT EXISTS SubscriptionPlan
(
    planID   SERIAL PRIMARY KEY,
    planName VARCHAR(255),
    price    DECIMAL(10, 2),
    features TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Transaction entity
CREATE TABLE IF NOT EXISTS Transaction
(
    transactionID SERIAL PRIMARY KEY,
    userID        INTEGER REFERENCES "user" (userID),
    planID        INTEGER REFERENCES SubscriptionPlan (planID),
    transactionDate TIMESTAMP,
    amount        DECIMAL(10, 2),
    status        VARCHAR(10),
    createdAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for MLModel entity
CREATE TABLE IF NOT EXISTS MLModel
(
    modelID   SERIAL PRIMARY KEY,
    modelName VARCHAR(255),
    description TEXT,
    trainedOn TIMESTAMP,
    accuracy  FLOAT,
    status    VARCHAR(10),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for AudienceSegment entity
CREATE TABLE IF NOT EXISTS AudienceSegment
(
    segmentID SERIAL PRIMARY KEY,
    segmentName VARCHAR(255),
    criteria  TEXT,
    description TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for VirtualEvent entity
CREATE TABLE IF NOT EXISTS VirtualEvent
(
    virtualEventID SERIAL PRIMARY KEY,
    eventID    INTEGER REFERENCES Event (eventID),
    platform   VARCHAR(255),
    accessLink VARCHAR(255),
    accessCode VARCHAR(20),
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for InfluencerCampaign entity
CREATE TABLE IF NOT EXISTS InfluencerCampaign
(
    campaignID   SERIAL PRIMARY KEY,
    sponsorID    INTEGER REFERENCES "user" (userID),
    campaignName VARCHAR(255),
    description  TEXT,
    startDate    TIMESTAMP,
    endDate      TIMESTAMP,
    budget       DECIMAL(10, 2),
    targetAudience TEXT,
    status       VARCHAR(10),
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserPrivacySettings entity
CREATE TABLE IF NOT EXISTS UserPrivacySettings
(
    settingID       SERIAL PRIMARY KEY,
    userID          INTEGER REFERENCES "user" (userID),
    privateProfile  BOOLEAN,
    privatePosts    BOOLEAN,
    privateLikes    BOOLEAN,
    privateComments BOOLEAN,
    privateFollowers BOOLEAN,
    privateFollowing BOOLEAN,
    createdAt       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ContentModeration entity
CREATE TABLE IF NOT EXISTS ContentModeration
(
    moderationID   SERIAL PRIMARY KEY,
    userID         INTEGER REFERENCES "user" (userID),
    mediaID        INTEGER REFERENCES Media (mediaID),
    moderationStatus VARCHAR(20),
    moderatedBy    INTEGER REFERENCES "user" (userID),
    moderationDate TIMESTAMP,
    reason         TEXT,
    createdAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for EngagementAnalytics entity
CREATE TABLE IF NOT EXISTS EngagementAnalytics
(
    analyticsID  SERIAL PRIMARY KEY,
    userID       INTEGER REFERENCES "user" (userID),
    postID       INTEGER,
    postType     VARCHAR(20),
    engagementRate FLOAT,
    commentCount INTEGER,
    likeCount    INTEGER,
    shareCount   INTEGER,
    viewCount    INTEGER,
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ABTesting entity
CREATE TABLE IF NOT EXISTS ABTesting
(
    testID    SERIAL PRIMARY KEY,
    testName  VARCHAR(255),
    startDate TIMESTAMP,
    endDate   TIMESTAMP,
    testStatus VARCHAR(10),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ABTestParticipant entity
CREATE TABLE IF NOT EXISTS ABTestParticipant
(
    participantID SERIAL PRIMARY KEY,
    testID    INTEGER REFERENCES ABTesting (testID),
    userID    INTEGER REFERENCES "user" (userID),
    groupID   INTEGER,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ABTestOutcome entity
CREATE TABLE IF NOT EXISTS ABTestOutcome
(
    outcomeID   SERIAL PRIMARY KEY,
    testID      INTEGER REFERENCES ABTesting (testID),
    outcomeType VARCHAR(20),
    outcomeValue TEXT,
    createdAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for MLModelInsights entity
CREATE TABLE IF NOT EXISTS MLModelInsights
(
    insightID   SERIAL PRIMARY KEY,
    modelID     INTEGER REFERENCES MLModel (modelID),
    insightType VARCHAR(20),
    insightValue TEXT,
    createdAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for APIAccessManagement entity
CREATE TABLE IF NOT EXISTS APIAccessManagement
(
    accessID  SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    apiKey    VARCHAR(255),
    accessLevel VARCHAR(20),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for MultimediaProcessingQueue entity
CREATE TABLE IF NOT EXISTS MultimediaProcessingQueue
(
    queueID           SERIAL PRIMARY KEY,
    mediaID           INTEGER REFERENCES Media (mediaID),
    status            VARCHAR(20),
    processingStarted TIMESTAMP,
    processingCompleted TIMESTAMP,
    createdAt         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Internationalization entity
CREATE TABLE IF NOT EXISTS Internationalization
(
    translationID  SERIAL PRIMARY KEY,
    languageCode   VARCHAR(10),
    translationKey VARCHAR(255),
    translationValue TEXT,
    createdAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for EventAttendee entity
CREATE TABLE IF NOT EXISTS EventAttendee
(
    attendeeID SERIAL PRIMARY KEY,
    eventID    INTEGER REFERENCES Event (eventID),
    userID     INTEGER REFERENCES "user" (userID),
    isAttending BOOLEAN,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for EventSession entity
CREATE TABLE IF NOT EXISTS EventSession
(
    sessionID SERIAL PRIMARY KEY,
    eventID   INTEGER REFERENCES Event (eventID),
    sessionName VARCHAR(255),
    startTime TIMESTAMP,
    endTime   TIMESTAMP,
    description TEXT,
    isPublic  BOOLEAN,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for SessionQuestion entity
CREATE TABLE IF NOT EXISTS SessionQuestion
(
    questionID SERIAL PRIMARY KEY,
    sessionID  INTEGER REFERENCES EventSession (sessionID),
    userID     INTEGER REFERENCES "user" (userID),
    questionText TEXT,
    postedTime TIMESTAMP,
    isAnswered BOOLEAN,
    answerText TEXT,
    answerTime TIMESTAMP,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for SessionPoll entity
CREATE TABLE IF NOT EXISTS SessionPoll
(
    pollID     SERIAL PRIMARY KEY,
    sessionID  INTEGER REFERENCES EventSession (sessionID),
    questionText TEXT,
    options    JSONB,
    postedTime TIMESTAMP,
    isClosed   BOOLEAN,
    closedTime TIMESTAMP,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PollVote entity
CREATE TABLE IF NOT EXISTS PollVote
(
    voteID    SERIAL PRIMARY KEY,
    pollID    INTEGER REFERENCES SessionPoll (pollID),
    userID    INTEGER REFERENCES "user" (userID),
    votedOption VARCHAR(255),
    votedTime TIMESTAMP,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Subscription entity
CREATE TABLE IF NOT EXISTS Subscription
(
    subscriptionID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    planID    INTEGER REFERENCES SubscriptionPlan (planID),
    startDate TIMESTAMP,
    endDate   TIMESTAMP,
    status    VARCHAR(10),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserSession entity
CREATE TABLE IF NOT EXISTS UserSession
(
    sessionID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    deviceID  VARCHAR(255),
    ipAddress VARCHAR(45),
    loginTime TIMESTAMP,
    logoutTime TIMESTAMP,
    isLoggedIn BOOLEAN,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for SessionActivity entity
CREATE TABLE IF NOT EXISTS SessionActivity
(
    activityID SERIAL PRIMARY KEY,
    sessionID  INTEGER REFERENCES UserSession (sessionID),
    activityType VARCHAR(20),
    activityTime TIMESTAMP,
    details    TEXT,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserNotification entity
CREATE TABLE IF NOT EXISTS UserNotification
(
    notificationID SERIAL PRIMARY KEY,
    userID         INTEGER REFERENCES "user" (userID),
    notificationType VARCHAR(20),
    notificationText TEXT,
    isRead         BOOLEAN,
    createdAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for NotificationSubscription entity
CREATE TABLE IF NOT EXISTS NotificationSubscription
(
    subscriptionID SERIAL PRIMARY KEY,
    userID         INTEGER REFERENCES "user" (userID),
    subscriptionType VARCHAR(20),
    createdAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for NotificationSetting entity
CREATE TABLE IF NOT EXISTS NotificationSetting
(
    settingID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    notificationType VARCHAR(20),
    isEnabled BOOLEAN,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserAnalytics entity
CREATE TABLE IF NOT EXISTS UserAnalytics
(
    analyticsID        SERIAL PRIMARY KEY,
    userID             INTEGER REFERENCES "user" (userID),
    totalLikesReceived INTEGER,
    totalCommentsReceived INTEGER,
    totalEngagements   INTEGER,
    engagementRate     FLOAT,
    followerCount      INTEGER,
    followingCount     INTEGER,
    postCount          INTEGER,
    createdAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ContentAnalytics entity
CREATE TABLE IF NOT EXISTS ContentAnalytics
(
    analyticsID  SERIAL PRIMARY KEY,
    mediaID      INTEGER REFERENCES Media (mediaID),
    likeCount    INTEGER,
    commentCount INTEGER,
    shareCount   INTEGER,
    viewCount    INTEGER,
    engagementRate FLOAT,
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for UserReport entity
CREATE TABLE IF NOT EXISTS UserReport
(
    reportID       SERIAL PRIMARY KEY,
    reporterID     INTEGER REFERENCES "user" (userID),
    reportedUserID INTEGER REFERENCES "user" (userID),
    reportReason   TEXT,
    reportedTime   TIMESTAMP,
    status         VARCHAR(10),
    resolvedBy     INTEGER REFERENCES "user" (userID),
    resolvedTime   TIMESTAMP,
    resolutionNotes TEXT,
    createdAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for TaggedContent entity
CREATE TABLE IF NOT EXISTS TaggedContent
(
    tagID        SERIAL PRIMARY KEY,
    mediaID      INTEGER REFERENCES Media (mediaID),
    taggerID     INTEGER REFERENCES "user" (userID),
    taggedUserID INTEGER REFERENCES "user" (userID),
    taggedTime   TIMESTAMP,
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for ContentCategorization entity
CREATE TABLE IF NOT EXISTS ContentCategorization
(
    categorizationID SERIAL PRIMARY KEY,
    mediaID         INTEGER REFERENCES Media (mediaID),
    category        VARCHAR(255),
    confidenceScore FLOAT,
    createdAt       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentMethod entity
CREATE TABLE IF NOT EXISTS PaymentMethod
(
    methodID   SERIAL PRIMARY KEY,
    userID     INTEGER REFERENCES "user" (userID),
    cardType   VARCHAR(20),
    cardNumber VARCHAR(20),
    expirationDate DATE,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentTransaction entity
CREATE TABLE IF NOT EXISTS PaymentTransaction
(
    transactionID SERIAL PRIMARY KEY,
    userID        INTEGER REFERENCES "user" (userID),
    methodID      INTEGER REFERENCES PaymentMethod (methodID),
    transactionDate TIMESTAMP,
    amount        DECIMAL(10, 2),
    description   TEXT,
    status        VARCHAR(10),
    createdAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentSubscription entity
CREATE TABLE IF NOT EXISTS PaymentSubscription
(
    subscriptionID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    methodID  INTEGER REFERENCES PaymentMethod (methodID),
    planID    INTEGER REFERENCES SubscriptionPlan (planID),
    startDate TIMESTAMP,
    endDate   TIMESTAMP,
    status    VARCHAR(10),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentInvoice entity
CREATE TABLE IF NOT EXISTS PaymentInvoice
(
    invoiceID     SERIAL PRIMARY KEY,
    userID        INTEGER REFERENCES "user" (userID),
    transactionID INTEGER REFERENCES PaymentTransaction (transactionID),
    description   TEXT,
    amount        DECIMAL(10, 2),
    dueDate       TIMESTAMP,
    status        VARCHAR(10),
    createdAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentRefund entity
CREATE TABLE IF NOT EXISTS PaymentRefund
(
    refundID      SERIAL PRIMARY KEY,
    userID        INTEGER REFERENCES "user" (userID),
    transactionID INTEGER REFERENCES PaymentTransaction (transactionID),
    refundAmount  DECIMAL(10, 2),
    refundReason  TEXT,
    refundDate    TIMESTAMP,
    status        VARCHAR(10),
    createdAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentGateway entity
CREATE TABLE IF NOT EXISTS PaymentGateway
(
    gatewayID SERIAL PRIMARY KEY,
    gatewayName VARCHAR(255),
    apiKey    VARCHAR(255),
    apiSecret VARCHAR(255),
    isActive  BOOLEAN,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for PaymentGatewayConfig entity
CREATE TABLE IF NOT EXISTS PaymentGatewayConfig
(
    configID   SERIAL PRIMARY KEY,
    gatewayID  INTEGER REFERENCES PaymentGateway (gatewayID),
    configName VARCHAR(255),
    configValue TEXT,
    createdAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Add columns for optimizing Instagram growth, targeted audience creation, monetizing followers, and integrating machine learning

-- User table enhancements
ALTER TABLE "user"
    ADD COLUMN IF NOT EXISTS mostEngagedTimeOfDay TIME,
    ADD COLUMN IF NOT EXISTS mostEngagedDayOfWeek VARCHAR(10),
    ADD COLUMN IF NOT EXISTS userInterests        JSONB,
    ADD COLUMN IF NOT EXISTS churnRiskScore       FLOAT;

-- Location table enhancements
ALTER TABLE Location
    ADD COLUMN IF NOT EXISTS popularityScore FLOAT,
    ADD COLUMN IF NOT EXISTS category        VARCHAR(50);

-- Hashtag table enhancements
ALTER TABLE Hashtag
    ADD COLUMN IF NOT EXISTS isActive         BOOLEAN,
    ADD COLUMN IF NOT EXISTS lastTrendingTime TIMESTAMP;

-- AudienceSegment table enhancements
ALTER TABLE AudienceSegment
    ADD COLUMN IF NOT EXISTS segmentSize           INTEGER,
    ADD COLUMN IF NOT EXISTS averageEngagementRate FLOAT;

-- SponsoredContent table enhancements
ALTER TABLE SponsoredContent
    ADD COLUMN IF NOT EXISTS impressionsCount INTEGER,
    ADD COLUMN IF NOT EXISTS clicksCount      INTEGER,
    ADD COLUMN IF NOT EXISTS conversionRate   FLOAT;

-- SubscriptionPlan table enhancements
ALTER TABLE SubscriptionPlan
    ADD COLUMN IF NOT EXISTS subscriptionBenefits JSONB;

-- Event table enhancements
ALTER TABLE Event
    ADD COLUMN IF NOT EXISTS engagementMetrics JSONB;

-- Media table enhancements
ALTER TABLE Media
    ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Feedback table creation
CREATE TABLE IF NOT EXISTS Feedback
(
    feedbackID   SERIAL PRIMARY KEY,
    userID       INTEGER REFERENCES "user" (userID),
    feedbackType VARCHAR(50),
    description  TEXT,
    resolutionStatus VARCHAR(50)
);

-- InfluencerCampaign table enhancements
ALTER TABLE InfluencerCampaign
    ADD COLUMN IF NOT EXISTS targetAchievementRate FLOAT;

-- UserNotification table enhancements
ALTER TABLE UserNotification
    ADD COLUMN IF NOT EXISTS notificationPriority INTEGER;

-- ContentModeration table enhancements
ALTER TABLE ContentModeration
    ADD COLUMN IF NOT EXISTS moderationAction VARCHAR(50);

-- Internationalization table enhancements
ALTER TABLE Internationalization
    ADD COLUMN IF NOT EXISTS context VARCHAR(100);

-- PaymentMethod table enhancements
ALTER TABLE PaymentMethod
    ADD COLUMN IF NOT EXISTS paymentMethodDetails JSONB;

-- CreatorSupport table creation
CREATE TABLE IF NOT EXISTS CreatorSupport
(
    supportID   SERIAL PRIMARY KEY,
    userID      INTEGER REFERENCES "user" (userID),
    supportType VARCHAR(50),
    amount      DECIMAL(10, 2),
    supporterID INTEGER REFERENCES "user" (userID)
);

-- CDNUsage table creation
CREATE TABLE IF NOT EXISTS CDNUsage
(
    usageID      SERIAL PRIMARY KEY,
    mediaID      INTEGER REFERENCES Media (mediaID),
    CDNProvider  VARCHAR(100),
    deliveryTimes INTEGER,
    cacheHitRate FLOAT
);

-- MLModel table enhancements
ALTER TABLE MLModel
    ADD COLUMN IF NOT EXISTS modelVersion           VARCHAR(50),
    ADD COLUMN IF NOT EXISTS trainingDataSummary    TEXT,
    ADD COLUMN IF NOT EXISTS performanceImprovement FLOAT;

-- APIAccessManagement table enhancements
ALTER TABLE APIAccessManagement
    ADD COLUMN IF NOT EXISTS rateLimit  INTEGER,
    ADD COLUMN IF NOT EXISTS usageQuota INTEGER;

-- Add columns for implementing detailed practices to utilize the extended database schema

-- Media table enhancements
ALTER TABLE Media
    ADD COLUMN IF NOT EXISTS postedTime TIMESTAMP,
    ADD COLUMN IF NOT EXISTS mediaType  VARCHAR(50);

-- EngagementAnalytics table enhancements
ALTER TABLE EngagementAnalytics
    ADD COLUMN IF NOT EXISTS contentPerformanceScore FLOAT;

-- ContentRecommendation table creation
CREATE TABLE IF NOT EXISTS ContentRecommendation
(
    recommendationID     SERIAL PRIMARY KEY,
    userID               INTEGER REFERENCES "user" (userID),
    recommendedContentID INTEGER REFERENCES Media (mediaID),
    recommendationType   VARCHAR(50)
);

-- MediaInteraction table enhancements
ALTER TABLE MediaInteraction
    ADD COLUMN IF NOT EXISTS interactionType VARCHAR(50);

-- UserPreferences table enhancements
ALTER TABLE UserPreferences
    ADD COLUMN IF NOT EXISTS contentFormatPreference VARCHAR(50);

-- UIComponentDesign table creation
CREATE TABLE IF NOT EXISTS UIComponentDesign
(
    componentID   SERIAL PRIMARY KEY,
    componentType VARCHAR(50),
    componentDescription TEXT
);

-- AutomationNotification table enhancements

ALTER TABLE AutomationNotification
    ADD COLUMN IF NOT EXISTS notificationType    VARCHAR(50),
    ADD COLUMN IF NOT EXISTS notificationContent TEXT;

-- Extend the User table for segmentation
ALTER TABLE "user"
    ADD COLUMN interests        TEXT[],
    ADD COLUMN activityPatterns JSONB;

-- Incorporate machine learning for automated content analysis in the Media table
ALTER TABLE Media
    ADD COLUMN contentCategory VARCHAR(255),
    ADD COLUMN contentTags     TEXT[];

-- Update the Hashtag table for dynamic performance tracking
ALTER TABLE Hashtag
    ADD COLUMN performanceMetrics JSONB;

-- Expand the Event table for engagement analytics
ALTER TABLE Event
    ADD COLUMN participantCount INTEGER,
    ADD COLUMN interactionCount INTEGER,
    ADD COLUMN conversionRate   FLOAT;

-- Enhance the MediaInteraction table for detailed interaction tracking
ALTER TABLE MediaInteraction
    ADD COLUMN interactionTimestamp TIMESTAMP;

-- Extend the Media table for monetization optimization
ALTER TABLE Media
    ADD COLUMN CPM DECIMAL(10, 2),
    ADD COLUMN CPC DECIMAL(10, 2);

-- Track ad campaign effectiveness
ALTER TABLE AdCampaign
    ADD COLUMN impressions      INTEGER,
    ADD COLUMN clickThroughRate FLOAT,
    ADD COLUMN conversionRate   FLOAT;

-- Introduce a content performance index in the Media table
ALTER TABLE Media
    ADD COLUMN contentPerformanceIndex FLOAT;

-- Add user loyalty and retention metrics in the UserSession table
ALTER TABLE UserSession
    ADD COLUMN sessionDuration   INTERVAL,
    ADD COLUMN frequencyOfVisits INTEGER;

-- Influence impact analysis enhancements in the InfluencerCampaign table
ALTER TABLE InfluencerCampaign
    ADD COLUMN influenceScore     FLOAT,
    ADD COLUMN audienceGrowthRate FLOAT;

-- Add dynamic subscription plans features
ALTER TABLE SubscriptionPlan
    ADD COLUMN dynamicFeatures JSONB;

-- API usage analytics for developers
ALTER TABLE APIAccessManagement
    ADD COLUMN usageMetrics JSONB;

-- Enhancements for virtual events
ALTER TABLE VirtualEvent
    ADD COLUMN interactiveFeatures JSONB;

-- Feedback table for content creation strategies
CREATE TABLE IF NOT EXISTS Feedback
(
    feedbackID   SERIAL PRIMARY KEY,
    userID       INTEGER REFERENCES "user" (userID),
    feedbackType VARCHAR(50),
    description  TEXT,
    resolutionStatus VARCHAR(50),
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CreatorSupport table for managing user support interactions
CREATE TABLE IF NOT EXISTS CreatorSupport
(
    supportID   SERIAL PRIMARY KEY,
    userID      INTEGER REFERENCES "user" (userID),
    supportType VARCHAR(50),
    amount      DECIMAL(10, 2),
    supporterID INTEGER REFERENCES "user" (userID),
    createdAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CDNUsage table for tracking content delivery network statistics
CREATE TABLE IF NOT EXISTS CDNUsage
(
    usageID      SERIAL PRIMARY KEY,
    mediaID      INTEGER REFERENCES Media (mediaID),
    CDNProvider  VARCHAR(100),
    deliveryTimes INTEGER,
    cacheHitRate FLOAT,
    createdAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Engagement Insights Table
CREATE TABLE IF NOT EXISTS UserEngagementInsights
(
    userID       INTEGER REFERENCES "user" (userID),
    bestPostType VARCHAR(255),
    peakEngagementTime TIME,
    followerGrowthRate FLOAT,
    PRIMARY KEY (userID)
);

-- Content Performance Metrics Enhancement for Media Table
ALTER TABLE Media
    ADD COLUMN avgWatchTime FLOAT,
    ADD COLUMN dropOffRate  FLOAT;

-- Dynamic Hashtag Recommendations Table
CREATE TABLE IF NOT EXISTS HashtagRecommendations
(
    recommendationID SERIAL PRIMARY KEY,
    userID           INTEGER REFERENCES "user" (userID),
    mediaID          INTEGER REFERENCES Media (mediaID),
    recommendedHashtags TEXT[],
    relevanceScore   FLOAT
);

-- Automated Content Categorization Enhancement (Assuming category field addition)
ALTER TABLE Media
    ADD COLUMN category VARCHAR(255);

-- Follower Segmentation Table
CREATE TABLE IF NOT EXISTS FollowerSegments
(
    segmentID SERIAL PRIMARY KEY,
    userID    INTEGER REFERENCES "user" (userID),
    segmentName VARCHAR(255),
    criteria  TEXT,
    segmentSize INTEGER
);

-- Sponsorship Opportunities Table
CREATE TABLE IF NOT EXISTS SponsorshipOpportunities
(
    opportunityID SERIAL PRIMARY KEY,
    userID     INTEGER REFERENCES "user" (userID),
    sponsorID  INTEGER REFERENCES "user" (userID),
    matchScore FLOAT
);

-- Audience Interest Profiles Enhancement
ALTER TABLE "user"
    ADD COLUMN detailedInterests JSONB;

-- Predictive Analytics for Content Performance Table
CREATE TABLE IF NOT EXISTS PredictiveContentPerformance
(
    predictionID SERIAL PRIMARY KEY,
    userID       INTEGER REFERENCES "user" (userID),
    mediaType    VARCHAR(50),
    predictedEngagementRate FLOAT
);

-- Real-time Content Engagement Feed Table
CREATE TABLE IF NOT EXISTS RealTimeEngagement
(
    engagementID SERIAL PRIMARY KEY,
    mediaID   INTEGER REFERENCES Media (mediaID),
    likes     INTEGER,
    comments  INTEGER,
    shares    INTEGER,
    timestamp TIMESTAMP
);

-- Influencer Collaboration Platform Enhancement
ALTER TABLE InfluencerCampaign
    ADD COLUMN collaborationDetails TEXT;

-- Monetization Strategies Table
CREATE TABLE IF NOT EXISTS MonetizationStrategies
(
    strategyID SERIAL PRIMARY KEY,
    userID     INTEGER REFERENCES "user" (userID),
    strategyType VARCHAR(255),
    details    TEXT
);

-- User Growth Milestones Table
CREATE TABLE IF NOT EXISTS GrowthMilestones
(
    milestoneID  SERIAL PRIMARY KEY,
    userID       INTEGER REFERENCES "user" (userID),
    milestoneType VARCHAR(255),
    achievedDate DATE
);

-- Interactive Content Features Enhancement
ALTER TABLE Media
    ADD COLUMN interactiveType VARCHAR(255);

-- Personalized Content Discovery Table
CREATE TABLE IF NOT EXISTS ContentDiscoveryPreferences
(
    preferenceID   SERIAL PRIMARY KEY,
    userID         INTEGER REFERENCES "user" (userID),
    preferenceType VARCHAR(255),
    preferenceDetails TEXT
);

-- Ad Performance Tracking Table
CREATE TABLE IF NOT EXISTS AdPerformance
(
    adID        SERIAL PRIMARY KEY,
    userID      INTEGER REFERENCES "user" (userID),
    clicks      INTEGER,
    impressions INTEGER,
    conversionRate FLOAT
);

-- Creator Support Mechanisms Enhancement
ALTER TABLE CreatorSupport
    ADD COLUMN supportMechanismDetails TEXT;

-- Machine Learning Model Feedback Loop Table
CREATE TABLE IF NOT EXISTS ModelFeedback
(
    feedbackID     SERIAL PRIMARY KEY,
    modelID        INTEGER REFERENCES MLModel (modelID),
    userID         INTEGER REFERENCES "user" (userID),
    accuracyRating FLOAT,
    improvementSuggestions TEXT
);

-- Event Engagement Analytics Enhancement
ALTER TABLE Event
    ADD COLUMN detailedEngagementAnalytics JSONB;

-- Customizable User Dashboards Table
CREATE TABLE IF NOT EXISTS UserDashboards
(
    dashboardID SERIAL PRIMARY KEY,
    userID      INTEGER REFERENCES "user" (userID),
    widgetID    INTEGER,
    layoutPreferences JSONB
);

-- Content Trend Forecasting Table
CREATE TABLE IF NOT EXISTS TrendForecasts
(
    forecastID      SERIAL PRIMARY KEY,
    trendName       VARCHAR(255),
    forecastDateRange DATERANGE,
    confidenceLevel FLOAT
);

-- Add indexes for optimization

-- Indexes for User table
CREATE INDEX IF NOT EXISTS idx_user_email ON "user" (email);
CREATE INDEX IF NOT EXISTS idx_user_username ON "user" (username);

-- Indexes for Media table
CREATE INDEX IF NOT EXISTS idx_media_type ON Media (mediaType);
CREATE INDEX IF NOT EXISTS idx_media_created_at ON Media (createdAt);
CREATE INDEX IF NOT EXISTS idx_media_updated_at ON Media (updatedAt);

-- Indexes for AdCampaign table
CREATE INDEX IF NOT EXISTS idx_ad_campaign_start_date ON AdCampaign (startDate);
CREATE INDEX IF NOT EXISTS idx_ad_campaign_end_date ON AdCampaign (endDate);

-- Indexes for SponsoredContent table
CREATE INDEX IF NOT EXISTS idx_sponsored_content_created_at ON SponsoredContent (createdAt);
CREATE INDEX IF NOT EXISTS idx_sponsored_content_updated_at ON SponsoredContent (updatedAt);

-- Indexes for ContentRecommendation table
CREATE INDEX IF NOT EXISTS idx_content_recommendation_media_id ON ContentRecommendation (mediaID);
CREATE INDEX IF NOT EXISTS idx_content_recommendation_recommended_media_id ON ContentRecommendation (recommendedMediaID);
CREATE INDEX IF NOT EXISTS idx_content_recommendation_score ON ContentRecommendation (recommendationScore);

-- Indexes for Event table
CREATE INDEX IF NOT EXISTS idx_event_start_date ON Event (startDate);
CREATE INDEX IF NOT EXISTS idx_event_end_date ON Event (endDate);
CREATE INDEX IF NOT EXISTS idx_event_organizer_id ON Event (organizerID);

-- Indexes for SubscriptionPlan table
CREATE INDEX IF NOT EXISTS idx_subscription_plan_price ON SubscriptionPlan (price);

-- Indexes for Transaction table
CREATE INDEX IF NOT EXISTS idx_transaction_user_id ON Transaction (userID);
CREATE INDEX IF NOT EXISTS idx_transaction_plan_id ON Transaction (planID);
CREATE INDEX IF NOT EXISTS idx_transaction_transaction_date ON Transaction (transactionDate);

-- Indexes for MLModel table
CREATE INDEX IF NOT EXISTS idx_ml_model_trained_on ON MLModel (trainedOn);
CREATE INDEX IF NOT EXISTS idx_ml_model_accuracy ON MLModel (accuracy);

-- Indexes for AudienceSegment table
CREATE INDEX IF NOT EXISTS idx_audience_segment_created_at ON AudienceSegment (createdAt);
CREATE INDEX IF NOT EXISTS idx_audience_segment_updated_at ON AudienceSegment (updatedAt);

-- Indexes for VirtualEvent table
CREATE INDEX IF NOT EXISTS idx_virtual_event_created_at ON VirtualEvent (createdAt);
CREATE INDEX IF NOT EXISTS idx_virtual_event_updated_at ON VirtualEvent (updatedAt);

-- Indexes for InfluencerCampaign table
CREATE INDEX IF NOT EXISTS idx_influencer_campaign_start_date ON InfluencerCampaign (startDate);
CREATE INDEX IF NOT EXISTS idx_influencer_campaign_end_date ON InfluencerCampaign (endDate);

-- Indexes for UserPrivacySettings table
CREATE INDEX IF NOT EXISTS idx_user_privacy_settings_user_id ON UserPrivacySettings (userID);

-- Indexes for ContentModeration table
CREATE INDEX IF NOT EXISTS idx_content_moderation_user_id ON ContentModeration (userID);
CREATE INDEX IF NOT EXISTS idx_content_moderation_media_id ON ContentModeration (mediaID);
CREATE INDEX IF NOT EXISTS idx_content_moderation_moderated_by ON ContentModeration (moderatedBy);
CREATE INDEX IF NOT EXISTS idx_content_moderation_moderation_date ON ContentModeration (moderationDate);

-- Indexes for EngagementAnalytics table
CREATE INDEX IF NOT EXISTS idx_engagement_analytics_user_id ON EngagementAnalytics (userID);
CREATE INDEX IF NOT EXISTS idx_engagement_analytics_post_id ON EngagementAnalytics (postID);
CREATE INDEX IF NOT EXISTS idx_engagement_analytics_post_type ON EngagementAnalytics (postType);

-- Indexes for ABTesting table
CREATE INDEX IF NOT EXISTS idx_ab_testing_start_date ON ABTesting (startDate);
CREATE INDEX IF NOT EXISTS idx_ab_testing_end_date ON ABTesting (endDate);

-- Indexes for ABTestParticipant table
CREATE INDEX IF NOT EXISTS idx_ab_test_participant_user_id ON ABTestParticipant (userID);
CREATE INDEX IF NOT EXISTS idx_ab_test_participant_group_id ON ABTestParticipant (groupID);

-- Indexes for ABTestOutcome table
CREATE INDEX IF NOT EXISTS idx_ab_test_outcome_test_id ON ABTestOutcome (testID);
CREATE INDEX IF NOT EXISTS idx_ab_test_outcome_outcome_type ON ABTestOutcome (outcomeType);

-- Indexes for MLModelInsights table
CREATE INDEX IF NOT EXISTS idx_ml_model_insights_model_id ON MLModelInsights (modelID);
CREATE INDEX IF NOT EXISTS idx_ml_model_insights_insight_type ON MLModelInsights (insightType);

-- Indexes for APIAccessManagement table
CREATE INDEX IF NOT EXISTS idx_api_access_management_user_id ON APIAccessManagement (userID);

-- Indexes for MultimediaProcessingQueue table
CREATE INDEX IF NOT EXISTS idx_multimedia_processing_queue_media_id ON MultimediaProcessingQueue (mediaID);
CREATE INDEX IF NOT EXISTS idx_multimedia_processing_queue_status ON MultimediaProcessingQueue (status);
CREATE INDEX IF NOT EXISTS idx_multimedia_processing_queue_processing_started ON MultimediaProcessingQueue (processingStarted);
CREATE INDEX IF NOT EXISTS idx_multimedia_processing_queue_processing_completed ON MultimediaProcessingQueue (processingCompleted);

-- Indexes for EventAttendee table
CREATE INDEX IF NOT EXISTS idx_event_attendee_event_id ON EventAttendee (eventID);
CREATE INDEX IF NOT EXISTS idx_event_attendee_user_id ON EventAttendee (userID);

-- Indexes for EventSession table
CREATE INDEX IF NOT EXISTS idx_event_session_event_id ON EventSession (eventID);
CREATE INDEX IF NOT EXISTS idx_event_session_start_time ON EventSession (startTime);
CREATE INDEX IF NOT EXISTS idx_event_session_end_time ON EventSession (endTime);

-- Indexes for SessionQuestion table
CREATE INDEX IF NOT EXISTS idx_session_question_session_id ON SessionQuestion (sessionID);
CREATE INDEX IF NOT EXISTS idx_session_question_user_id ON SessionQuestion (userID);
CREATE INDEX IF NOT EXISTS idx_session_question_posted_time ON SessionQuestion (postedTime);
CREATE INDEX IF NOT EXISTS idx_session_question_is_answered ON SessionQuestion (isAnswered);

-- Indexes for SessionPoll table
CREATE INDEX IF NOT EXISTS idx_session_poll_session_id ON SessionPoll (sessionID);
CREATE INDEX IF NOT EXISTS idx_session_poll_posted_time ON SessionPoll (postedTime);
CREATE INDEX IF NOT EXISTS idx_session_poll_closed_time ON SessionPoll (closedTime);
CREATE INDEX IF NOT EXISTS idx_session_poll_is_closed ON SessionPoll (isClosed);

-- Indexes for PollVote table
CREATE INDEX IF NOT EXISTS idx_poll_vote_poll_id ON PollVote (pollID);
CREATE INDEX IF NOT EXISTS idx_poll_vote_user_id ON PollVote (userID);
CREATE INDEX IF NOT EXISTS idx_poll_vote_voted_time ON PollVote (votedTime);

-- Indexes for Subscription table
CREATE INDEX IF NOT EXISTS idx_subscription_user_id ON Subscription (userID);
CREATE INDEX IF NOT EXISTS idx_subscription_plan_id ON Subscription (planID);
CREATE INDEX IF NOT EXISTS idx_subscription_start_date ON Subscription (startDate);
CREATE INDEX IF NOT EXISTS idx_subscription_end_date ON Subscription (endDate);

-- Indexes for UserSession table
CREATE INDEX IF NOT EXISTS idx_user_session_user_id ON UserSession (userID);
CREATE INDEX IF NOT EXISTS idx_user_session_login_time ON UserSession (loginTime);
CREATE INDEX IF NOT EXISTS idx_user_session_logout_time ON UserSession (logoutTime);
CREATE INDEX IF NOT EXISTS idx_user_session_is_logged_in ON UserSession (isLoggedIn);

-- Indexes for SessionActivity table
CREATE INDEX IF NOT EXISTS idx_session_activity_session_id ON SessionActivity (sessionID);
CREATE INDEX IF NOT EXISTS idx_session_activity_activity_time ON SessionActivity (activityTime);

-- Indexes for UserNotification table
CREATE INDEX IF NOT EXISTS idx_user_notification_user_id ON UserNotification (userID);
CREATE INDEX IF NOT EXISTS idx_user_notification_notification_type ON UserNotification (notificationType);
CREATE INDEX IF NOT EXISTS idx_user_notification_is_read ON UserNotification (isRead);

-- Indexes for NotificationSubscription table
CREATE INDEX IF NOT EXISTS idx_notification_subscription_user_id ON NotificationSubscription (userID);
CREATE INDEX IF NOT EXISTS idx_notification_subscription_subscription_type ON NotificationSubscription (subscriptionType);

-- Indexes for NotificationSetting table
CREATE INDEX IF NOT EXISTS idx_notification_setting_user_id ON NotificationSetting (userID);
CREATE INDEX IF NOT EXISTS idx_notification_setting_notification_type ON NotificationSetting (notificationType);
CREATE INDEX IF NOT EXISTS idx_notification_setting_is_enabled ON NotificationSetting (isEnabled);

-- Indexes for UserAnalytics table
CREATE INDEX IF NOT EXISTS idx_user_analytics_user_id ON UserAnalytics (userID);

-- Indexes for ContentAnalytics table
CREATE INDEX IF NOT EXISTS idx_content_analytics_media_id ON ContentAnalytics (mediaID);

-- Indexes for UserReport table
CREATE INDEX IF NOT EXISTS idx_user_report_reporter_id ON UserReport (reporterID);
CREATE INDEX IF NOT EXISTS idx_user_report_reported_user_id ON UserReport (reportedUserID);
CREATE INDEX IF NOT EXISTS idx_user_report_reported_time ON UserReport (reportedTime);
CREATE INDEX IF NOT EXISTS idx_user_report_status ON UserReport (status);
CREATE INDEX IF NOT EXISTS idx_user_report_resolved_by ON UserReport (resolvedBy);
CREATE INDEX IF NOT EXISTS idx_user_report_resolved_time ON UserReport (resolvedTime);

-- Indexes for TaggedContent table
CREATE INDEX IF NOT EXISTS idx_tagged_content_media_id ON TaggedContent (mediaID);
CREATE INDEX IF NOT EXISTS idx_tagged_content_tagger_id ON TaggedContent (taggerID);
CREATE INDEX IF NOT EXISTS idx_tagged_content_tagged_user_id ON TaggedContent (taggedUserID);
CREATE INDEX IF NOT EXISTS idx_tagged_content_tagged_time ON TaggedContent (taggedTime);

-- Indexes for ContentCategorization table
CREATE INDEX IF NOT EXISTS idx_content_categorization_media_id ON ContentCategorization (mediaID);

-- Indexes for PaymentMethod table
CREATE INDEX IF NOT EXISTS idx_payment_method_user_id ON PaymentMethod (userID);

-- Indexes for PaymentTransaction table
CREATE INDEX IF NOT EXISTS idx_payment_transaction_user_id ON PaymentTransaction (userID);
CREATE INDEX IF NOT EXISTS idx_payment_transaction_method_id ON PaymentTransaction (methodID);
CREATE INDEX IF NOT EXISTS idx_payment_transaction_transaction_date ON PaymentTransaction (transactionDate);
CREATE INDEX IF NOT EXISTS idx_payment_transaction_status ON PaymentTransaction (status);

-- Indexes for PaymentSubscription table
CREATE INDEX IF NOT EXISTS idx_payment_subscription_user_id ON PaymentSubscription (userID);
CREATE INDEX IF NOT EXISTS idx_payment_subscription_method_id ON PaymentSubscription (methodID);
CREATE INDEX IF NOT EXISTS idx_payment_subscription_plan_id ON PaymentSubscription (planID);
CREATE INDEX IF NOT EXISTS idx_payment_subscription_start_date ON PaymentSubscription (startDate);
CREATE INDEX IF NOT EXISTS idx_payment_subscription_end_date ON PaymentSubscription (endDate);
CREATE INDEX IF NOT EXISTS idx_payment_subscription_status ON PaymentSubscription (status);

-- Indexes for PaymentInvoice table
CREATE INDEX IF NOT EXISTS idx_payment_invoice_user_id ON PaymentInvoice (userID);
CREATE INDEX IF NOT EXISTS idx_payment_invoice_transaction_id ON PaymentInvoice (transactionID);
CREATE INDEX IF NOT EXISTS idx_payment_invoice_due_date ON PaymentInvoice (dueDate);
CREATE INDEX IF NOT EXISTS idx_payment_invoice_status ON PaymentInvoice (status);

-- Indexes for PaymentRefund table
CREATE INDEX IF NOT EXISTS idx_payment_refund_user_id ON PaymentRefund (userID);
CREATE INDEX IF NOT EXISTS idx_payment_refund_transaction_id ON PaymentRefund (transactionID);
CREATE INDEX IF NOT EXISTS idx_payment_refund_refund_date ON PaymentRefund (refundDate);
CREATE INDEX IF NOT EXISTS idx_payment_refund_status ON PaymentRefund (status);

-- Indexes for PaymentGateway table
CREATE INDEX IF NOT EXISTS idx_payment_gateway_is_active ON PaymentGateway (isActive);

-- Indexes for PaymentGatewayConfig table
CREATE INDEX IF NOT EXISTS idx_payment_gateway_config_gateway_id ON PaymentGatewayConfig (gatewayID);

-- User table indexes
CREATE INDEX IF NOT EXISTS idx_user_interests ON "user" USING GIN (interests);

-- Media table indexes for content categorization and performance
CREATE INDEX IF NOT EXISTS idx_media_contentCategory ON Media (contentCategory);
CREATE INDEX IF NOT EXISTS idx_media_contentTags ON Media USING GIN (contentTags);

-- Hashtag performance tracking
CREATE INDEX IF NOT EXISTS idx_hashtag_performanceMetrics ON Hashtag USING GIN (performanceMetrics);

-- Event engagement analytics
CREATE INDEX IF NOT EXISTS idx_event_participantCount ON Event (participantCount);
CREATE INDEX IF NOT EXISTS idx_event_conversionRate ON Event (conversionRate);

-- Media interaction detailed tracking
CREATE INDEX IF NOT EXISTS idx_mediaInteraction_interactionTimestamp ON MediaInteraction (interactionTimestamp);

-- Ad campaign effectiveness
CREATE INDEX IF NOT EXISTS idx_adCampaign_impressions ON AdCampaign (impressions);
CREATE INDEX IF NOT EXISTS idx_adCampaign_conversionRate ON AdCampaign (conversionRate);

-- API access management optimization
CREATE INDEX IF NOT EXISTS idx_apiAccessManagement_usageMetrics ON APIAccessManagement USING GIN (usageMetrics);

ALTER TABLE Media
    ADD CONSTRAINT fk_media_user FOREIGN KEY (userID) REFERENCES "user" (userID);
ALTER TABLE Media
    ADD CONSTRAINT fk_media_sponsor FOREIGN KEY (sponsorID) REFERENCES "user" (userID);

ALTER TABLE Resource
    ADD CONSTRAINT fk_resource_media FOREIGN KEY (mediaID) REFERENCES Media (mediaID);

ALTER TABLE MediaOembed
    ADD CONSTRAINT fk_mediaoembed_media FOREIGN KEY (mediaID) REFERENCES Media (mediaID);

ALTER TABLE UserShort
    ADD CONSTRAINT fk_usershort_user FOREIGN KEY (userID) REFERENCES "user" (userID);

ALTER TABLE Usertag
    ADD CONSTRAINT fk_usertag_media FOREIGN KEY (mediaID) REFERENCES Media (mediaID);
ALTER TABLE Usertag
    ADD CONSTRAINT fk_usertag_usershort FOREIGN KEY (userShortID) REFERENCES UserShort (userShortID);

ALTER TABLE Comment
    ADD CONSTRAINT fk_comment_media FOREIGN KEY (mediaID) REFERENCES Media (mediaID);
ALTER TABLE Comment
    ADD CONSTRAINT fk_comment_user FOREIGN KEY (userID) REFERENCES "user" (userID);

ALTER TABLE DirectMessage
    ADD CONSTRAINT fk_directmessage_directthread FOREIGN KEY (threadID) REFERENCES DirectThread (threadID);
ALTER TABLE DirectMessage
    ADD CONSTRAINT fk_directmessage_user FOREIGN KEY (senderID) REFERENCES "user" (userID);

ALTER TABLE Story
    ADD CONSTRAINT fk_story_user FOREIGN KEY (userID) REFERENCES "user" (userID);
ALTER TABLE Story
    ADD CONSTRAINT fk_story_location FOREIGN KEY (locationID) REFERENCES Location (locationID);

ALTER TABLE Event
    ADD CONSTRAINT fk_event_user FOREIGN KEY (organizerID) REFERENCES "user" (userID);
ALTER TABLE Event
    ADD CONSTRAINT fk_event_location FOREIGN KEY (locationID) REFERENCES Location (locationID);

ALTER TABLE Transaction
    ADD CONSTRAINT fk_transaction_user FOREIGN KEY (userID) REFERENCES "user" (userID);
ALTER TABLE Transaction
    ADD CONSTRAINT fk_transaction_subscriptionplan FOREIGN KEY (planID) REFERENCES SubscriptionPlan (planID);
