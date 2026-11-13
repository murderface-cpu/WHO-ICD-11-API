# WHO ICD-11 API — local offline container

Runs the official `whoicd/icd-api` Docker image locally. It needs internet only
when the container is first created (to pull the image and load ICD-11 data). After
that it works fully offline. No API credentials are needed locally.

## Use

```powershell
docker compose up -d      # create + start (first time needs internet)
docker compose stop       # stop (data is kept)
docker compose start      # start again, works offline
docker logs -f icd-api    # logs
.\test-api.ps1 -Query asthma   # smoke test
```

| What | URL |
|---|---|
| API base | http://localhost:8382/icd/ |
| Swagger | http://localhost:8382/swagger/index.html |
| ICD-11 Browser | http://localhost:8382/browse |
| Coding Tool | http://localhost:8382/ct |

Every API call needs these headers: `API-Version: v2`, `Accept-Language: en`, `Accept: application/json`.

```bash
curl -H "API-Version: v2" -H "Accept-Language: en" -H "Accept: application/json" \
  "http://localhost:8382/icd/release/11/2026-01/mms/search?q=diabetes"
```

## Configuration (`.env`)

- `ICD_PORT`: host port (default 8382; 8000 was already taken on this machine).
- `ICD_INCLUDE`: release and languages, e.g. `2026-01_en`, `2026-01_en-es-fr`, `2026-01_en,2025-01_en`.
- `ICD_SAVE_ANALYTICS`: `false` means no search data is sent to WHO.
- `ICD_ENABLE_DORIS`, `ICD_FHIR_SUPPORT`: optional features.

**Do not run `docker compose down`** while offline. It deletes the container and its
loaded data. The next `up` would need internet again. Use `stop` and `start` instead.

## Updating

With internet: `docker compose pull`, then `docker compose up -d --force-recreate`.
You also need to recreate the container after you change `ICD_INCLUDE`.
