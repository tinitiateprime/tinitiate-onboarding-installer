# GCP student Docker environment

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for GCP-specific exercises.

This environment provides Google Cloud development tools and a local GCP-compatible emulator. It supports exercises that should run without a Google Cloud account, service-account key, or cloud charges.

## What is included

- **code-server:** Visual Studio Code in the browser, available on port 8080.
- **Google Cloud CLI:** Provides `gcloud`, `bq`, and related command-line tools.
- **Google Cloud Python SDKs:** Includes Cloud Storage, Pub/Sub, and Firestore packages.
- **Floci GCP:** Locally emulates supported GCP services on port 4588.
- **Floci UI:** Provides a browser dashboard on port 4500.
- **Shared student tools:** Python, PySpark, Jupyter, Node.js, npm, Git, and the standard editor extensions.

## Important points

- The default local project is `floci-local`; change `GCP_PROJECT_ID` in `.env` if needed.
- Storage, Pub/Sub, Firestore, Datastore, and Secret Manager endpoint variables are already directed to `floci-gcp`.
- Local Floci exercises do not require `gcloud auth login`.
- Commands for unsupported or real GCP services can still require a Google Cloud account and billing project.
- Google Cloud configuration, editor settings, and emulator data use separate named volumes.
- The Docker socket is mounted into Floci for services that run supporting containers. Only use trusted course code and images.

## Start

Run from the repository root:

```bash
docker compose -f environments/gcp/compose.yaml up -d --build
```

Open:

- Workspace: <http://localhost:8080>
- Floci UI: <http://localhost:4500>
- Floci GCP API: <http://localhost:4588>

## Verify and try Cloud Storage

Open the workspace terminal and run:

```bash
gcloud version
gcloud config get-value project
gcloud storage buckets create gs://student-demo
gcloud storage buckets list
```

The environment variables in Compose direct supported commands and SDKs to Floci.

## Useful commands

```bash
docker compose -f environments/gcp/compose.yaml ps
docker compose -f environments/gcp/compose.yaml logs -f floci-gcp
docker compose -f environments/gcp/compose.yaml restart
docker compose -f environments/gcp/compose.yaml down
```

Use `down -v` only when you intend to erase the saved GCP configuration, editor data, and locally emulated resources.

## Troubleshooting

- If port 4588, 4500, or 8080 is busy, change the corresponding value in `.env`.
- Confirm `GCP_PROJECT_ID` contains a simple project identifier suitable for classroom exercises.
- Check `docker compose -f environments/gcp/compose.yaml logs floci-gcp` when the emulator is unavailable.
