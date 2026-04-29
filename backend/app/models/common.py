from pydantic import BaseModel, ConfigDict
from typing import Optional, List, Dict, Any

class PyObjectId(str):
    @classmethod
    def __get_validators__(cls):
        yield cls.validate

    @classmethod
    def validate(cls, v, *args):
        try:
            from bson import ObjectId
        except ImportError:
            pass
        else:
            if isinstance(v, ObjectId):
                return str(v)
            if not ObjectId.is_valid(v):
                raise ValueError("Invalid ObjectId")
        return str(v)
        
    @classmethod
    def __get_pydantic_core_schema__(cls, source_type: Any, handler: Any):
        from pydantic_core import core_schema
        return core_schema.str_schema()

class UserLocation(BaseModel):
    type: str = "Point"
    coordinates: List[float]  # [longitude, latitude]
