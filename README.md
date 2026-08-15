# Express.js App

A basic [Express.js](https://expressjs.com/) application.

## Getting Started

### Prerequisites
- [Node.js](https://nodejs.org/) v18 or higher
- npm

### Installation

```bash
npm install
```

### Running the app

**Development** (with auto-reload via nodemon):
```bash
npm run dev
```

**Production:**
```bash
npm start
```

The server will start on [http://localhost:3000](http://localhost:3000).

## Endpoints

| Method | Route     | Description          |
|--------|-----------|----------------------|
| GET    | `/`       | Welcome message      |
| GET    | `/health` | Health check         |

## Project Structure

```
.
├── src/
│   └── index.js    # Application entry point
├── .gitignore
├── package.json
└── README.md
```
