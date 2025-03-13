# 🚀 RedisProject
[![Demonstrate](https://img.youtube.com/vi/FKPFuGUTF2o/maxresdefault.jpg)](https://youtu.be/FKPFuGUTF2o)

## 📌 Overview
RedisProject is a Phoenix-based web application that utilizes Redis for managing key-value pairs. The app allows users to create, update, delete, and view key-value data stored in Redis via an interactive table with modals. 🔑📊

## ✨ Features
- 📄 Key-Value management via Redis.
- 🛠️ Modal-based UI for creating, updating, and deleting key-value pairs.
- 📡 Live updates using Phoenix LiveView.
- ✅ Full test coverage for API and UI.

## ⚡ Setup Instructions
### 🔧 Prerequisites
- 🦀 Elixir & Erlang installed
- 🐳 Docker & Docker Compose installed

### 📥 Installation Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/redis_project.git
   cd redis_project
   ```
2. Set up dependencies:
   ```sh
   mix setup
   ```
3. Start Redis via Docker:
   ```sh
   sudo docker compose up -d
   ```
4. Start the Phoenix server:
   ```sh
   mix phx.server
   ```
   Or with IEx:
   ```sh
   iex -S mix phx.server
   ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. 🌐

