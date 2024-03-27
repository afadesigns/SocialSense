API_DOMAIN = "i.instagram.com"

USER_AGENT_BASE = (
    "Instagram {app_version} "
    "Android ({android_version}/{android_release}; "
    "{dpi}; {resolution}; {manufacturer}; "
    "{model}; {device}; {cpu}; {locale}; {version_code})"
)

SOFTWARE = (
    "{model}-user+{android_release}+OPR1.170623.032+V10.2.3.0.OAGMIXM+release-keys"
)

QUERY_HASHES = {
    "profile": "c9100bf9110dd6361671f113dd02e7d6",
    "medias": "42323d64886122307be10013ad2dcc44",
    "igtvs": "bc78b344a68ed16dd5d7f264681c4c76",
    "stories": "5ec1d322b38839230f8e256e1f638d5f",
    "highlights_folders": "ad99dd9d3646cc3c0dda65debcd266a7",
    "highlights_stories": "5ec1d322b38839230f8e256e1f638d5f",
    "followers": "c76146de99bb02f6415203be841dd25a",
    "followings": "d04b0a864b4b54837c0d870b0e77e076",
    "hashtag": "174a5243287c5f3a7de741089750ab3b",
    "comments": "33ba35852cb50da46f5b5e889df7d159",
    "tagged_medias": "be13233562af2d229b008d2976b998b5",
}

LOGIN_EXPERIMENTS = {
    "ig_android_reg_nux_headers_cleanup_universe": True,
    "ig_android_device_detection_info_upload": True,
    "ig_android_nux_add_email_device": True,
    "ig_android_gmail_oauth_in_reg": True,
    "ig_android_device_info_foreground_reporting": True,
    "ig_android_device_verification_fb_signup": True,
    "ig_android_direct_main_tab_universe_v2": True,
    "ig_android_passwordless_account_password_creation_universe": True,
    "ig_android_direct_add_direct_to_android_native_photo_share_sheet": True,
    "ig_growth_android_profile_pic_prefill_with_fb_pic_2": True,
    "ig_account_identity_logged_out_signals_global_holdout_universe": True,
    "ig_android_quickcapture_keep_screen_on": True,
    "ig_android_device_based_country_verification": True,
    "ig_android_login_identifier_fuzzy_match": True,
    "ig_android_reg_modularization_universe": True,
    "ig_android_security_intent_switchoff": True,
    "ig_android_device_verification_separate_endpoint": True,
    "ig_android_suma_landing_page": True,
    "ig_android_sim_info_upload": True,
    "ig_android
