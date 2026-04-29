from fastapi import APIRouter, Depends, HTTPException
from typing import List
from bson import ObjectId
from app.models.equipment import EquipmentCreate, EquipmentResponse
from app.auth.dependencies import get_current_user
from app.database import get_db

router = APIRouter(prefix="/equipment", tags=["equipment"])

@router.post("/add", response_model=EquipmentResponse)
async def add_equipment(equip: EquipmentCreate, current_user: dict = Depends(get_current_user)):
    db = get_db()
    equip_dict = equip.model_dump() if hasattr(equip, "model_dump") else equip.dict()
    equip_dict["seller_id"] = str(current_user["_id"])
    equip_dict["is_available"] = True
    
    result = await db.equipment.insert_one(equip_dict)
    equip_dict["id"] = str(result.inserted_id)
    return equip_dict

@router.get("/list", response_model=List[EquipmentResponse])
async def list_equipment():
    db = get_db()
    equipment = await db.equipment.find({"is_available": True}).to_list(length=100)
    result = []
    for e in equipment:
        e["id"] = str(e["_id"])
        result.append(e)
    return result

@router.post("/buy/{equipment_id}")
async def buy_equipment(equipment_id: str, current_user: dict = Depends(get_current_user)):
    db = get_db()
    result = await db.equipment.update_one(
        {"_id": ObjectId(equipment_id), "is_available": True},
        {"$set": {"is_available": False, "buyer_id": str(current_user["_id"])}}
    )
    if result.modified_count == 0:
        raise HTTPException(status_code=400, detail="Equipment not found or already sold")
    return {"message": "Successfully purchased equipment"}
