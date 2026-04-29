# PLAYMATE

**PLAYMATE** is a mobile sports networking and matchmaking app that helps players find teammates, join matches, organize tournaments, and share sports equipment.

Many people want to play sports but struggle to find players nearby. PLAYMATE solves this by connecting sports enthusiasts based on **skill level, location, and interests**.

## Features

- Find players nearby with similar sports interests
- Join or create matches instantly
- Organize sports tournaments and competitions
- Buy, rent, or share sports equipment
- Create personalized player profiles
- Match players based on skill level, location, and interests

## Screenshots

### Login Screen
Users can log in securely using their email and password.

<p align="center">
  <img src="screenshots/login.png" alt="Login Screen" width="250"/>
</p>

**Highlights:**
- Dark modern UI
- Simple login process
- Quick access to signup

---

### Create Account Screen
New users can register by entering their personal and sports details.

<p align="center">
  <img src="screenshots/signup.png" alt="Create Account Screen" width="250"/>
</p>

**Users can add:**
- Full Name
- Email
- Password
- Age
- Gender
- Skill Level
- Sports Interests
- Bio (optional)

This helps the system match players with similar interests and skill levels.

---

### Matches Screen
Users can browse available matches and join instantly.

<p align="center">
  <img src="screenshots/matches.png" alt="Matches Screen" width="250"/>
</p>

**Match cards display:**
- Sport type
- Location
- Match time
- Players required
- Skill level

Users can tap **Join Match** to participate.

---

### Profile Screen
Each user has a personalized profile showing their sports identity.

<p align="center">
  <img src="screenshots/profile.png" alt="Profile Screen" width="250"/>
</p>

**Profile includes:**
- Profile picture
- Name
- Age and gender
- Sports interests
- Skill level
- Bio

This helps players connect with compatible teammates.

---

### Equipment Marketplace
The equipment section allows users to buy, rent, or share sports gear.

<p align="center">
  <img src="screenshots/equipment.png" alt="Equipment Screen" width="250"/>
</p>

**Users can:**
- Buy sports gear
- Rent equipment
- Share sports equipment with other players

## Key Features

### Player Matching
PLAYMATE matches players based on:
- Skill level
- Sports interests
- Location

### Match Creation
Users can:
- Create matches
- Join matches
- Invite other players

### Tournament Organization
Users can organize sports tournaments and competitions.

### Equipment Sharing
Users can:
- Buy sports equipment
- Rent gear
- Share equipment with other players

### Player Profiles
Each user has a customizable profile displaying their sports preferences.

## Technology Stack

### Frontend
- Flutter
- Dart
- Material UI

### Backend
- FastAPI
- Python

### Database
- MongoDB

### API
- REST API

## Project Structure

```bash
PLAYMATE
│
├── frontend
│   └── Flutter Mobile App
│
├── backend
│   ├── main.py
│   ├── seed.py
│   ├── requirements.txt
│   │
│   └── app
│       ├── database.py
│       ├── models
│       ├── schemas
│       └── routes
│           ├── auth.py
│           ├── users.py
│           ├── swipe.py
│           ├── matches.py
│           ├── tournaments.py
│           └── equipment.py
│
└── screenshots
    ├── login.png.png
    ├── signup.png.png
    ├── matches.png.png
    ├── profile.png.png
    └── equipment.png.png
