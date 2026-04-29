from fastapi import APIRouter, Depends
from typing import List
from app.models.user import UserResponse
from app.auth.dependencies import get_current_user
from app.database import get_db

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/profile", response_model=UserResponse)
async def get_profile(current_user: dict = Depends(get_current_user)):
    return current_user

@router.get("/nearby", response_model=List[UserResponse])
async def get_nearby_users(
    max_distance_km: int = 20,
    current_user: dict = Depends(get_current_user)
):
    db = get_db()
    
    if "location" not in current_user:
        return []
        
    pipeline = [
        {
            "$geoNear": {
                "near": current_user["location"],
                "distanceField": "distance",
                "maxDistance": max_distance_km * 1000,
                "spherical": True
            }
        },
        {
            "$match": {
                "_id": {"$ne": current_user["_id"]}
            }
        }
    ]
    
    nearby_users = await db.users.aggregate(pipeline).to_list(length=100)
    
    result = []
    for u in nearby_users:
        u["id"] = str(u["_id"])
        result.append(u)
        
    return result

@router.put("/location")
async def update_location(
    lat: float, lon: float,
    current_user: dict = Depends(get_current_user)
):
    db = get_db()
    
    await db.users.update_one(
        {"_id": current_user["_id"]},
        {"$set": {"location": {"type": "Point", "coordinates": [lon, lat]}}}
    )
    
    return {"message": "Location updated successfully"}
