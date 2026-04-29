from pydantic import BaseModel

class SwipeCreate(BaseModel):
    swiped_id: str
    direction: str  # "right" or "left"

class SwipeResponse(BaseModel):
    id: str
    swiper_id: str
    swiped_id: str
    direction: str
    is_match: bool
