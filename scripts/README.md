# QuickReach Scripts

One-time admin scripts for seeding Firestore data.

## Setup

1. Go to [Firebase Console](https://console.firebase.google.com) → Project `quickreach-ca7c4`
2. Click the ⚙️ gear icon → **Project Settings**
3. Go to **Service Accounts** tab
4. Click **Generate new private key** → Download the JSON file
5. Rename it to `serviceAccountKey.json`
6. Place it in this `scripts/` folder

## Seed Staff Directory

```bash
cd scripts
npm install
node seed_staff.js
```

Expected output:
```
🚀 Starting staff seeding...

  ✓ Queued: Bill Gates (Principal)
  ✓ Queued: Sundar Pichai (HOD)
  ... (20 entries)

✅ Done! 20 staff members seeded to Firestore.
```

> ⚠️ `serviceAccountKey.json` is in `.gitignore` — never commit it.
