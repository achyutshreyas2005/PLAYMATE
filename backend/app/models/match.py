from pydantic import BaseModel
from typing import List

class MatchCreate(BaseModel):
    sport: str
    location: str
    time: str
    number_of_players: int
    skill_level: str

class MatchResponse(MatchCreate):
    id: str
    organizer_id: str
    participants_ids: List[str]
