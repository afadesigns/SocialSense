-- query_plan_management.sql

-- Advanced Partitioning Strategies

-- List Partitioning for Categorical Data (Example: Users Table)
-- Assuming 'gender' column for list partitioning
CREATE TABLE public.users_partitioned
(
    CHECK (gender IN ('male', 'female', 'other'))
) PARTITION BY LIST (gender);

-- Partition for Male Users
CREATE TABLE public.users_partition_male PARTITION OF public.users_partitioned FOR VALUES IN ('male');

-- Partition for Female Users
CREATE TABLE public.users_partition_female PARTITION OF public.users_partitioned FOR VALUES IN ('female');

-- Partition for Other Gender Users
CREATE TABLE public.users_partition_other PARTITION OF public.users_partitioned FOR VALUES IN ('other');

-- Composite Partitioning (Example: Media Table)
-- Assuming 'media_type' and 'posted_at' columns for composite partitioning
CREATE TABLE public.media_partitioned
(
    CHECK (media_type IN ('photo', 'video', 'story', 'album', 'IGTV'))
) PARTITION BY LIST (media_type);

-- Partition for Photo Media
CREATE TABLE public.media_partition_photo PARTITION OF public.media_partitioned FOR VALUES IN ('photo');

-- Partition for Video Media
CREATE TABLE public.media_partition_video PARTITION OF public.media_partitioned FOR VALUES IN ('video');

-- Partition for Story Media
CREATE TABLE public.media_partition_story PARTITION OF public.media_partitioned FOR VALUES IN ('story');

-- Partition for Album Media
CREATE TABLE public.media_partition_album PARTITION OF public.media_partitioned FOR VALUES IN ('album');

-- Partition for IGTV Media
CREATE TABLE public.media_partition_igtv PARTITION OF public.media_partitioned FOR VALUES IN ('IGTV');

-- Create Range Partitions within each List Partition based on 'posted_at'
-- Example: Partitioning by Year
-- Assuming 'posted_at' is the timestamp column
CREATE TABLE public.media_partition_photo_2022 PARTITION OF public.media_partition_photo
    FOR VALUES IN ('2022') PARTITION BY RANGE (posted_at);

-- Repeat the above process for other media types and years

-- Full Updated Schema
