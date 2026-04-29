from pydantic import BaseModel, EmailStr, Field
from typing import List, Optional
from app.models.common import UserLocation

class UserRegister(BaseModel):
    name: str = Field(..., min_length=2)
    email: EmailStr
    password: str = Field(..., min_length=6)
    age: int
    gender: str
    sports_interests: List[str]
    skill_level: str
    lon: float
    lat: float
    bio: Optional[str] = ""

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: str  # mapped from BSON ObjectId
    name: str
    email: EmailStr
    age: int
    gender: str
    sports_interests: List[str]
    skill_level: str
    location: UserLocation
    profile_photo: Optional[str] = None
    bio: Optional[str] = None

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
