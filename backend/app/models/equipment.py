from pydantic import BaseModel

class EquipmentCreate(BaseModel):
    item_name: str
    price: float
    condition: str
    sport_type: str

class EquipmentResponse(EquipmentCreate):
    id: str
    seller_id: str
    is_available: bool
