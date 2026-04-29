from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone
from app.models.swipe import SwipeCreate
from app.auth.dependencies import get_current_user
from app.database import get_db

router = APIRouter(prefix="/swipe", tags=["swipe"])

@router.post("/{direction}")
async def swipe_user(direction: str, swipe: SwipeCreate, current_user: dict = Depends(get_current_user)):
    if direction not in ["right", "left"]:
        raise HTTPException(status_code=400, detail="Direction must be right or left")
        
    db = get_db()
    
    swipe_doc = {
        "swiper_id": str(current_user["_id"]),
        "swiped_id": swipe.swiped_id,
        "direction": direction,
        "timestamp": datetime.now(timezone.utc)
    }
    await db.swipes.insert_one(swipe_doc)
    
    is_match = False
    if direction == "right":
        mutual = await db.swipes.find_one({
            "swiper_id": swipe.swiped_id,
            "swiped_id": str(current_user["_id"]),
            "direction": "right"
        })
        if mutual:
            is_match = True
            await db.matches_between_users.insert_one({
                "user1_id": str(current_user["_id"]),
                "user2_id": swipe.swiped_id,
                "timestamp": datetime.now(timezone.utc)
            })
            
    return {"message": "Swiped", "is_match": is_match}
