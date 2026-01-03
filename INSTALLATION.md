# My Diary App – Docker Installation Guide

This guide explains how to install and run **My Diary App** using **Docker**. It is written for **both non‑technical (inexperienced) users** and **technical (experienced) users**.

> ✅ **Important:** You do **not** need to install Ruby, Rails, PostgreSQL, or any other dependencies manually. Everything runs inside Docker.

---

## Who Is This Guide For?

* **Inexperienced users**: Follow the **Quick Start** section. Minimal commands, step‑by‑step.
* **Experienced users**: Skip to **Docker Commands & Advanced Usage**.

---

## What Docker Does (Plain English)

Docker runs the Diary App in an isolated container on your computer. This means:

* No complicated setup
* No system configuration issues
* The app runs the same on Windows, macOS, and Linux
* Your data stays on your machine

Think of Docker as a **self‑contained box** that already includes everything the app needs.

---

## Prerequisites (Required Once)

You must install **Docker Desktop** before running the app.

### Windows & macOS

1. Download Docker Desktop:
   [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Install it using the default options
3. Start Docker Desktop
4. Confirm Docker is running (Docker icon is visible)

> ⚠️ Docker must be running before starting the Diary App.

### Linux (Ubuntu / Debian)

```bash
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

Log out and back in to apply permissions.

---

## Getting the Diary App Files

You can obtain the app in **one of two ways**:

### Option 1: Download (Recommended for Beginners)

* Download the ZIP/TAR file from the official release page
* Extract it to a folder on your computer

### Option 2: Clone from GitHub (Experienced Users)

```bash
git clone https://github.com/pmnoos/digial_diary.git
cd digial_diary
```

---

# 🚀 QUICK START (Beginner Friendly)

### Windows Users

1. Make sure **Docker Desktop is running**
2. Extract the Diary App files
3. Double‑click:

   ```
   install.bat
   ```
4. Wait while Docker builds and starts the app
5. Open your browser and visit:

   👉 **[http://localhost:3000](http://localhost:3000)**

That’s it. 🎉

---

# 🛠 MANUAL INSTALLATION (All Platforms)

### Step 1: Open a Terminal or Command Prompt

Navigate to the folder containing the Diary App files.

### Step 2: Build and Start the App

```bash
docker-compose up --build -d
```

This command:

* Builds the app container
* Starts the web server and database
* Runs everything in the background

### Step 3: Open the App

Visit:

👉 **[http://localhost:3000](http://localhost:3000)**

---

# ▶️ Managing the Application

### Start the App

```bash
docker-compose up -d
```

### Stop the App

```bash
docker-compose down
```

### Restart the App

```bash
docker-compose restart
```

### View Logs (Useful for Debugging)

```bash
docker-compose logs -f
```

### Update the App

```bash
docker-compose down
docker-compose up --build -d
```

---

## 💾 Data Persistence (Your Entries Are Safe)

Your diary entries and user data are stored in **Docker volumes**, which means:

* Data survives restarts
* Data remains on your computer
* Data is not deleted unless you explicitly remove volumes

> ⚠️ Do **not** run `docker-compose down -v` unless you want to delete all data.

---

## 🧯 Troubleshooting

### Port 3000 Already in Use

If you see a port conflict error:

1. Stop the app:

   ```bash
   docker-compose down
   ```
2. Open `docker-compose.yml`
3. Change:

   ```yaml
   "3000:80"
   ```

   to:

   ```yaml
   "3001:80"
   ```
4. Restart:

   ```bash
   docker-compose up -d
   ```
5. Open:
   👉 [http://localhost:3001](http://localhost:3001)

---

### Database Startup Issues

```bash
docker-compose down -v
docker-compose up --build -d
```

⚠️ This removes stored data.

---

### Docker Is Not Running

* Start Docker Desktop
* Wait until Docker reports it is ready
* Try again

---

## 🖥 System Requirements

* **OS**: Windows 10/11, macOS 10.15+, Linux
* **RAM**: 4 GB minimum (8 GB recommended)
* **Disk Space**: 2 GB minimum
* **Docker**: Docker Desktop or Docker Engine

---

## 🔐 Security Notes

* App runs locally only
* No data is sent externally
* Local development credentials only
* Suitable for personal use and private hosting

---

## 🆘 Support

If something goes wrong:

1. Confirm Docker is running
2. Restart Docker Desktop
3. Restart the Diary App
4. Check logs:

   ```bash
   docker-compose logs -f
   ```

For further help, see the documentation or project repository.

---

✅ **You are now ready to use My Diary App. Enjoy writing.** ✍️
