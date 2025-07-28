
# Digital Diary

A modern, private digital diary web application built with Ruby on Rails and Bulma CSS.

## Features

- Secure user authentication (Devise)
- Rich text diary entries with image uploads (Action Text, Active Storage)
- Clean, responsive Bulma-styled interface
- Personalized home page and navigation
- Archive and browse entries by year and month
- Edit or delete entries at any time
- Delete account functionality

## Getting Started

### Prerequisites
- Ruby 3.x
- Rails 8.x
- SQLite (default for development)
- Node.js & Yarn (for JS/CSS assets)

### Setup
1. **Clone the repository:**
   ```sh
   git clone https://github.com/pmnoos/digial_diary.git
   cd digial_diary/diary_app
   ```
2. **Install dependencies:**
   ```sh
   bundle install
   yarn install --check-files
   ```
3. **Set up the database:**
   ```sh
   rails db:setup
   ```
4. **Start the server:**
   ```sh
   rails server
   ```
5. **Visit** `http://localhost:3000` in your browser.

### Configuration
- Credentials and secrets are managed via Rails credentials. Make sure you have `config/master.key` (not committed to git).
- Uploaded files are stored locally in `/storage` (ignored by git).

## Usage
- Sign up for a new account.
- Create, edit, and delete diary entries with formatted text and images.
- Browse your archive and search past entries.
- Delete your account at any time from the home page.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License.

---

**Created by EasyABC-International**

---

### Screenshots
_Add screenshots here if desired._
