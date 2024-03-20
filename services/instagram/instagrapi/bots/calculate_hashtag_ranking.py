def calculate_ranking_difficulty(H, U, P, C, E, Q):
    # Inputs:
    # H: The hashtag for which to calculate ranking difficulty
    # U: The current user attempting to rank for the hashtag
    # P: Popularity score of the hashtag (H.popularity_score)
    # C: Contributor count for the hashtag (H.contributor_count)
    # E: Average engagement rate for content under the hashtag (H.engagement_rate)
    # Q: Quality score of the user's content (derived from user-specific metrics)

    # Steps:
    # Calculate the base difficulty based on popularity and competition
    base_difficulty = P + C

    # Adjust the difficulty based on engagement rate
    adjusted_difficulty = base_difficulty * E

    # Incorporate the user's content quality
    if Q > average(QualityScore):
        final_difficulty = adjusted_difficulty * 0.75
    else:
        final_difficulty = adjusted_difficulty * 1.25

    # Normalize the difficulty score to a 0-100 scale (or another suitable range) for easier interpretation

    # Output:
    # final_difficulty: A numeric score representing the difficulty of ranking on the hashtag for the current user,
    # with lower scores indicating easier ranking

    return final_difficulty
