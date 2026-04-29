from fastapi import APIRouter, Depends, HTTPException
from typing import List
from bson import ObjectId
from app.models.tournament import TournamentCreate, TournamentResponse
from app.auth.dependencies import get_current_user
from app.database import get_db

router = APIRouter(prefix="/tournaments", tags=["tournaments"])

@router.post("/create", response_model=TournamentResponse)
async def create_tournament(tournament: TournamentCreate, current_user: dict = Depends(get_current_user)):
    db = get_db()
    tourn_dict = tournament.model_dump() if hasattr(tournament, "model_dump") else tournament.dict()
    tourn_dict["organizer_id"] = str(current_user["_id"])
    tourn_dict["teams_ids"] = [str(current_user["_id"])]
    
    result = await db.tournaments.insert_one(tourn_dict)
    tourn_dict["id"] = str(result.inserted_id)
    return tourn_dict

@router.post("/join/{tournament_id}")
async def join_tournament(tournament_id: str, current_user: dict = Depends(get_current_user)):
    db = get_db()
    result = await db.tournaments.update_one(
        {"_id": ObjectId(tournament_id)},
        {"$addToSet": {"teams_ids": str(current_user["_id"])}}
    )
    if result.modified_count == 0:
        raise HTTPException(status_code=400, detail="Tournament not found or already joined")
    return {"message": "Successfully joined tournament"}

@router.get("/list", response_model=List[TournamentResponse])
async def list_tournaments():
    db = get_db()
    tournaments = await db.tournaments.find().to_list(length=100)
    result = []
    for t in tournaments:
        t["id"] = str(t["_id"])
        result.append(t)
    return result
