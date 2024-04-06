from datetime import datetime
from typing import List, Optional, Union

from pydantic import BaseModel, ConfigDict, Field, FilePath, HttpUrl, root_validator, validator

class TypesBaseModel(BaseModel):
    model_config = ConfigDict(
        coerce_numbers_to_str=True
    )  # (jarrodnorwell) fixed city_id issue

class Resource(TypesBaseModel):
    pk: str
    video_url: Optional[HttpUrl] = Field(default=None, title="Video URL")
    thumbnail_url: HttpUrl = Field(title="Thumbnail URL")
    media_type: int = Field(title="Media Type")

class User(TypesBaseModel):
    pk: str = Field(title="User ID")
    username: str = Field(title="Username")
    full_name: str = Field(title="Full Name")
    is_private: bool = Field(title="Private Status")
    profile_pic_url: HttpUrl = Field(title="Profile Pic URL")
    profile_pic_url_hd: Optional[HttpUrl] = Field(default=None, title="Profile Pic URL HD")
    is_verified: bool = Field(title="Verified Status")
    media_count: int = Field(title="Media Count")
    follower_count: int = Field(title="Follower Count")
    following_count: int = Field(title="Following Count")
    biography: Optional[str] = Field(default="", title="Biography")
    external_url: Optional[str] = Field(default=None, title="External URL")
    account_type: Optional[int] = Field(default=None, title="Account Type")
    is_business: bool = Field(title="Business Status")

    public_email: Optional[str] = Field(default=None, title="Public Email")
    contact_phone_number: Optional[str] = Field(default=None, title="Contact Phone Number")
    public_phone_country_code: Optional[str] = Field(default=None, title="Public Phone Country Code")
    public_phone_number: Optional[str] = Field(default=None, title="Public Phone Number")
    business_contact_method: Optional[str] = Field(default=None, title="Business Contact Method")
    business_category_name: Optional[str] = Field(default=None, title="Business Category Name")
    category_name: Optional[str] = Field(default=None, title="Category Name")
    category: Optional[str] = Field(default=None, title="Category")

    address_street: Optional[str] = Field(default=None, title="Address Street")
    city_id: Optional[str] = Field(default=None, title="City ID")
    city_name: Optional[str] = Field(default=None, title="City Name")
    latitude: Optional[float] = Field(default=None, title="Latitude")
    longitude: Optional[float] = Field(default=None, title="Longitude")
    zip: Optional[str] = Field(default=None, title="Zip Code")
    instagram_location_id: Optional[str] = Field(default=None, title="Instagram Location ID")
    interop_messaging_user_fbid: Optional[str] = Field(default=None, title="Interop Messaging User FBID")

    _external_url = validator("external_url", allow_reuse=True, always=True)(validate_external_url)

class Account(TypesBaseModel):
    pk: str = Field(title="Account ID")
    username: str = Field(title="Username")
    full_name: str = Field(title="Full Name")
    is_private: bool = Field(title="Private Status")
    profile_pic_url: HttpUrl = Field(title="Profile Pic URL")
    is_verified: bool = Field(title="Verified Status")
    biography: Optional[str] = Field(default="", title="Biography")
    external_url: Optional[str] = Field(default=None, title="External URL")
    is_business: bool = Field(title="Business Status")

    birthday: Optional[str] = Field(default=None, title="Birthday")
    phone_number: Optional[str] = Field(default=None, title="Phone Number")
    gender: Optional[int] = Field(default=None, title="Gender")
    email: Optional[str
