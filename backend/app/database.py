import motor.motor_asyncio
import os
import asyncio

MONGO_DETAILS = os.environ.get("MONGODB_URI", "mongodb://localhost:27017")

client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_DETAILS)
db = client.playmate

# Helper function to configure indexes
async def init_db():
    # 2dsphere index for location-based queries
    await db.users.create_index([("location", "2dsphere")])

def get_db():
    return db
