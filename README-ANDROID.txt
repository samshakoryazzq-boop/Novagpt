CHESSNOVA 1.0 — ANDROID / WEB PROJECT
======================================

This is an upgraded PWA project based on the supplied ChessNova v0.9 files.

WHAT IS INCLUDED IN THIS BUILD
------------------------------
- Account-first onboarding gate: registration or sign-in is shown before the app.
- Existing Cloudflare API account, profile, leaderboard and game-history integration retained.
- Existing chess.js local legal-move board retained.
- Improved dark purple/neon visual system and stronger piece contrast.
- Separate vertical Chess Reels section with embedded creator playlists; the feed stays inside the app shell.
- Global in-app audio player. Users can choose a local audio file; it is not uploaded.
- Language selector with 31 locale choices (including Persian, Arabic, Urdu and Hebrew RTL).
- UI translations currently included for: English, Persian, Arabic, German, French, Spanish, Portuguese, Italian, Russian, Turkish, Simplified/Traditional Chinese, Japanese, Korean and Hindi.
- Remaining locale choices currently fall back to English for untranslated interface strings. They are selectable, but should NOT be considered fully translated yet.
- PWA manifest and offline shell cache.

IMPORTANT IMPLEMENTATION LIMITS
-------------------------------
This is a v1.0 FOUNDATION BUILD, not a claim that every feature in the large product brief is complete.
The following are not fully implemented or verified in this archive:
- Server-authoritative online chess move validation, clocks, reconnect/resume and rated Elo.
- Stockfish engine integration and move-classification labels (Brilliant/Great/etc.).
- Complete multi-variant rules (Chess960, Crazyhouse, Atomic, etc.).
- Complete social network: user-uploaded videos, comments, DMs, stories, notifications, moderation workflows.
- A licensed global video hosting pipeline. Embedded playlists depend on the creator/platform's embed permissions and network access. Some videos may refuse embedding.
- A licensed music catalogue or background playback when the browser/app is suspended. Local audio playback works while the app is active; Android background playback may require a native audio service.
- Full 31-language translation of every screen, lesson, notification and user-generated post.
- Tournament pairing, Swiss/Arena/Knockout management, anti-cheat review and appeals.
- Full Nova IQ, Nova Replay export, opening explorer database, puzzle rush/battle and full course authoring.
- APK compilation and store publication.

SERVER
------
The existing Worker URL is:
https://chessnova-api-v07.chessnova-arena.workers.dev

This archive retains the v0.9 worker source. It does not automatically deploy or change your Cloudflare account.
Do not overwrite the live Worker with this source unless you intentionally want to redeploy it.
Check DEPLOYMENT-STATUS.txt and wrangler.toml before deploying.

RUN ON ANDROID
--------------
1. Extract the ZIP with ZArchiver.
2. Upload the project folder to a static host (Cloudflare Pages is suitable for the frontend).
3. Configure the frontend API URL in index.html if your Worker URL changes.
4. Open the deployed HTTPS site in Chrome.
5. Use Chrome menu > Add to Home screen to install the PWA shortcut.

LOCAL TEST
----------
You can inspect index.html directly, but browser security may restrict some API and service-worker features on file:// URLs. Use an HTTPS static host for a realistic test.

ACCOUNT REQUIREMENTS
--------------------
- Username: 3–18 letters, numbers or underscores.
- Password: 10–128 characters.
- Use a unique password. Do not share passwords or API secrets.

VIDEO AND MUSIC RIGHTS
---------------------
Videos are embedded using the provider's permitted player interface; no attempt is made to bypass embed restrictions or download protected videos.
Choose music files you own or are licensed to use.

OWNER IDENTITY + USERNAME RESERVATION (v1.0.1)
----------------------------------------------
The Worker now reads roles from the D1 `player_roles` table. The founder role is linked to a permanent player UUID; the string `Vamxsn` alone never grants OWNER. The `username_claims` table reserves normalized handles and prevents duplicate/case-variant registrations at the database layer. `Vamxsn` is pre-reserved.

Database migration (run once against the existing production D1 database before deploying the new Worker):
  npx wrangler d1 execute chessnova-v07-db --remote --file=./schema.sql

Configure the one-time founder secret as a Cloudflare Worker secret (do not put its value in source code or chat):
  npx wrangler secret put OWNER_SETUP_SECRET
Choose a long random value and keep it private. This command deploys a Worker version; deploy the updated Worker source after applying the migration. If you use the Cloudflare dashboard instead, add `OWNER_SETUP_SECRET` under the Worker Settings > Variables and Secrets as a Secret.

Founder activation:
1. For a brand-new founder account, select Create account, use the reserved username `Vamxsn`, and enter the Cloudflare secret in the Founder setup secret field. The server atomically claims the reserved handle and creates the OWNER role against the new player UUID.
2. For an existing legacy Vamxsn account, sign in, open Account, enter the same one-time secret in the Founder account verification card, and select Verify founder account.
3. The server checks the authenticated player UUID, reserved username, secret, and whether another owner already exists. It writes the `owner` role against that UUID.
4. The account receives the gold OWNER crown. The Profile page exposes staff role management. OWNER cannot be assigned through the ordinary role-management endpoint or removed by that endpoint.

If a legacy Vamxsn account already exists, the migration preserves its username claim; the authenticated account must still complete the one-time claim. Never share the setup secret. If it is exposed, rotate it in Cloudflare.

The 31 locale options have localized text for the duplicate-username message. Other untranslated parts of the app still fall back to English as described above.
