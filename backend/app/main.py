from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import init_db
from app.routes import auth, users, swipe, matches, tournaments, equipment

app = FastAPI(title="PLAYMATE API", description="Sports Networking and Matchmaking API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup_event():
    await init_db()

@app.get("/")
def read_root():
    return {"message": "Welcome to the PLAYMATE API"}

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(swipe.router)
app.include_router(matches.router)
app.include_router(tournaments.router)
app.include_router(equipment.router)
