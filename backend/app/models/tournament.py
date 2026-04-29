from pydantic import BaseModel
from typing import List

class TournamentCreate(BaseModel):
    sport: str
    venue: str
    date: str
    number_of_teams: int

class TournamentResponse(TournamentCreate):
    id: str
    organizer_id: str
    teams_ids: List[str]
