from datetime import datetime
from typing import List, Optional, Union

from pydantic import BaseModel, ConfigDict, FilePath, HttpUrl, ValidationError, validator

class TypesBaseModel(BaseModel):
    model_config = ConfigDict(coerce_numbers_to_str=True)  # fix city_id issue

def validate_external_url(cls, v):
    if v is None or (v.startswith("http") and "://" in v) or isinstance(v, str):
        return v
    raise ValidationError("external_url must been URL or string")

class Resource(TypesBaseModel):
    pk: str
    video_url: Optional[HttpUrl] = None  # for Video and IGTV
    thumbnail_url: HttpUrl
    media_type: int

