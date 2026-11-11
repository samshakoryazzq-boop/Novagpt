-- ChessNova v1.0.1 D1 migration. Existing players/games tables are retained.
CREATE TABLE IF NOT EXISTS credentials (player_id TEXT PRIMARY KEY, salt TEXT NOT NULL, password_hash TEXT NOT NULL, FOREIGN KEY(player_id) REFERENCES players(id));
CREATE TABLE IF NOT EXISTS sessions (token_hash TEXT PRIMARY KEY, player_id TEXT NOT NULL, expires_at INTEGER NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(player_id) REFERENCES players(id));
CREATE INDEX IF NOT EXISTS idx_sessions_expiry ON sessions(expires_at);
CREATE INDEX IF NOT EXISTS idx_games_white ON games(white_id);
CREATE INDEX IF NOT EXISTS idx_games_black ON games(black_id);
CREATE TABLE IF NOT EXISTS ws_tickets (ticket_hash TEXT PRIMARY KEY, player_id TEXT NOT NULL, expires_at INTEGER NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(player_id) REFERENCES players(id));
CREATE INDEX IF NOT EXISTS idx_ws_tickets_expiry ON ws_tickets(expires_at);
-- A canonical, case-insensitive username registry. The reserved founder handle is claimed now.
CREATE TABLE IF NOT EXISTS username_claims (username_key TEXT PRIMARY KEY, username TEXT NOT NULL, player_id TEXT UNIQUE);
INSERT OR IGNORE INTO username_claims(username_key,username,player_id) SELECT lower(username),username,id FROM players;
INSERT OR IGNORE INTO username_claims(username_key,username,player_id) VALUES('vamxsn','Vamxsn',NULL);
CREATE TABLE IF NOT EXISTS player_roles (player_id TEXT PRIMARY KEY, role TEXT NOT NULL CHECK(role IN ('owner','admin','moderator')), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(player_id) REFERENCES players(id));
CREATE INDEX IF NOT EXISTS idx_player_roles_role ON player_roles(role);
