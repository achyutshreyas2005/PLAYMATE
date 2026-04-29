# PlayMate – AI-Powered Sports Matchmaking App

PlayMate is a **Flutter-based mobile application** designed to connect sports enthusiasts, help them find nearby players, create matches, and promote an active lifestyle through smart matchmaking and real-time interaction.

---

## 🚀 Features

* 🔐 **User Authentication** (Firebase Auth)
* 👤 **User Profile Management**
* 📍 **Real-Time Match Creation & Joining**
* ⚡ **Live Updates using Firestore**
* 🗺 **Google Maps Integration (Location-based matches)**
* 👥 **Player Count & Match Capacity System**
* 🚫 **Duplicate Join Prevention**
* 📱 **Clean UI with Bottom Navigation**

---

## 🧠 Future Enhancements

* 🤖 AI-based player matchmaking (skill + distance + availability)
* 📊 Fitness tracking integration (Google Fit / Apple Health)
* 🏆 Tournament creation & leaderboards
* 💬 In-app chat system
* 🎯 Smart match recommendations

---

## 🏗 Tech Stack

| Layer          | Technology      |
| -------------- | --------------- |
| Frontend       | Flutter (Dart)  |
| Backend        | Firebase        |
| Database       | Cloud Firestore |
| Authentication | Firebase Auth   |
| Maps           | Google Maps API |
| Location       | Geolocator      |

---

## 📂 Project Structure

```
lib/
├── core/
├── models/
├── services/
├── providers/
├── screens/
│   ├── auth/
│   ├── home/
│   ├── match/
│   ├── map/
│   └── profile/
├── widgets/
└── main.dart
```

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the repository

```
git clone https://github.com/achyutshreyas2005/PLAYMATE.git
cd PLAYMATE
```

---

### 2️⃣ Install dependencies

```
flutter pub get
```

---

### 3️⃣ Setup Firebase

* Add `google-services.json` in:

  ```
  android/app/
  ```
* Enable:

  * Authentication (Email/Password)
  * Firestore Database

---

### 4️⃣ Add Google Maps API Key

Inside:

```
android/app/src/main/AndroidManifest.xml
```

Add:

```
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_API_KEY"/>
```

---

### 5️⃣ Run the app

```
flutter run
```

---

## 📸 Screenshots

> *(Add your app screenshots here for better presentation)*

---

## 🎯 Key Highlights

* Real-time database-driven architecture
* Scalable Flutter + Firebase design
* Location-based match discovery
* Clean modular code structure
* Production-level features implementation

---

## 👨‍💻 Author

**Achyut Shreyas(B.tech Student)**

* Passionate about mobile app development & AI
* Building real-world scalable applications

---

## ⭐ Contributing

Contributions are welcome!
Feel free to fork the repo and submit a pull request.

---

## 📄 License

This project is open-source and available under the MIT License.
