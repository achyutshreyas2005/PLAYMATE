import asyncio
from app.database import db, init_db
from app.utils.security import get_password_hash
from datetime import datetime, timezone

async def seed_data():
    await init_db()
    print("Clearing existing data...")
    await db.users.delete_many({})
    await db.matches.delete_many({})
    await db.swipes.delete_many({})
    await db.tournaments.delete_many({})
    await db.equipment.delete_many({})
    await db.matches_between_users.delete_many({})

    print("Inserting sample users...")
    users = [
        {
            "name": "Alex Hooper",
            "email": "alex@playmate.com",
            "hashed_password": get_password_hash("password123"),
            "age": 25,
            "gender": "Male",
            "sports_interests": ["Basketball", "Tennis"],
            "skill_level": "Advanced",
            "location": {"type": "Point", "coordinates": [-122.4194, 37.7749]}, 
            "bio": "Always down for weekend basketball. Looking for competitive runs.",
            "profile_photo": "https://images.unsplash.com/photo-1599566150163-29194dcaad36"
        },
        {
            "name": "Jordan Kicks",
            "email": "jordan@playmate.com",
            "hashed_password": get_password_hash("password123"),
            "age": 28,
            "gender": "Female",
            "sports_interests": ["Soccer", "Running"],
            "skill_level": "Intermediate",
            "location": {"type": "Point", "coordinates": [-122.4294, 37.7849]}, 
            "bio": "Local soccer enthusiast. Hoping to start a casual 5v5 team.",
            "profile_photo": "https://images.unsplash.com/photo-1527980965255-d3b416303d12"
        },
        {
            "name": "Sam Rivers",
            "email": "sam@playmate.com",
            "hashed_password": get_password_hash("password123"),
            "age": 22,
            "gender": "Non-binary",
            "sports_interests": ["Tennis", "Pickleball"],
            "skill_level": "Beginner",
            "location": {"type": "Point", "coordinates": [-122.4094, 37.7649]}, 
            "bio": "Just bought a tennis racket! Anyone willing to teach me?",
            "profile_photo": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde"
        }
    ]
    
    user_result = await db.users.insert_many(users)
    alex_id = str(user_result.inserted_ids[0])
    jordan_id = str(user_result.inserted_ids[1])
    sam_id = str(user_result.inserted_ids[2])
    print(f"Inserted 3 users. (Alex ID: {alex_id})")
    
    print("Inserting sample match...")
    match = {
        "sport": "Basketball",
        "location": "SF Central Park Indoor Courts",
        "time": str(datetime.now(timezone.utc)),
        "number_of_players": 10,
        "skill_level": "Intermediate/Advanced",
        "organizer_id": alex_id,
        "participants_ids": [alex_id, jordan_id]
    }
    await db.matches.insert_one(match)

    print("Inserting sample mutual swipe (Match!)...")
    await db.swipes.insert_many([
        {
            "swiper_id": alex_id,
            "swiped_id": jordan_id,
            "direction": "right",
            "timestamp": datetime.now(timezone.utc)
        },
        {
            "swiper_id": jordan_id,
            "swiped_id": alex_id,
            "direction": "right",
            "timestamp": datetime.now(timezone.utc)
        }
    ])
    await db.matches_between_users.insert_one({
        "user1_id": alex_id,
        "user2_id": jordan_id,
        "timestamp": datetime.now(timezone.utc)
    })
    
    print("Inserting sample equipment listing...")
    await db.equipment.insert_one({
        "item_name": "Pro Staff 97 v13 Tennis Racket",
        "price": 150.0,
        "condition": "Like New",
        "sport_type": "Tennis",
        "seller_id": sam_id,
        "is_available": True
    })

    print("Seed complete! You can log in with alex@playmate.com / password123")

if __name__ == "__main__":
    asyncio.run(seed_data())
