from fastapi import APIRouter, Depends, HTTPException
from typing import List
from bson import ObjectId
from app.models.match import MatchCreate, MatchResponse
from app.auth.dependencies import get_current_user
from app.database import get_db

router = APIRouter(prefix="/matches", tags=["matches"])

@router.post("/create", response_model=MatchResponse)
async def create_match(match: MatchCreate, current_user: dict = Depends(get_current_user)):
    db = get_db()
    match_dict = match.model_dump() if hasattr(match, "model_dump") else match.dict()
    match_dict["organizer_id"] = str(current_user["_id"])
    match_dict["participants_ids"] = [str(current_user["_id"])]
    
    result = await db.matches.insert_one(match_dict)
    match_dict["id"] = str(result.inserted_id)
    return match_dict

@router.post("/join/{match_id}")
async def join_match(match_id: str, current_user: dict = Depends(get_current_user)):
    db = get_db()
    result = await db.matches.update_one(
        {"_id": ObjectId(match_id)},
        {"$addToSet": {"participants_ids": str(current_user["_id"])}}
    )
    if result.modified_count == 0:
        raise HTTPException(status_code=400, detail="Match not found or already joined")
    return {"message": "Successfully joined match"}

@router.get("/list", response_model=List[MatchResponse])
async def list_matches():
    db = get_db()
    matches = await db.matches.find().to_list(length=100)
    result = []
    for m in matches:
        m["id"] = str(m["_id"])
        result.append(m)
    return result
