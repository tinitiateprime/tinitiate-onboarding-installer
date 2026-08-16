# AWS student Docker environment

This environment gives students a browser-based development workspace with AWS tools and a local AWS-compatible emulator. It is intended for exercises that should not require an AWS account or create cloud charges.

## What is included

- **code-server:** Visual Studio Code in the browser, available on port 8080.
- **AWS CLI v2:** Runs AWS commands from the workspace terminal.
- **boto3:** Builds Python applications that use AWS services.
- **Floci AWS:** Locally emulates AWS APIs such as S3, SQS, DynamoDB, and Lambda on port 4566.
- **Floci UI:** Provides a browser dashboard on port 4500.
- **Shared student tools:** Python, PySpark, Jupyter, Node.js, npm, Git, and the standard editor extensions.

## Important points

- The workspace is configured to use `http://floci:4566` automatically.
- `test` credentials are deliberately used because Floci does not require a real AWS account.
- The default region is `us-east-1`; change `AWS_DEFAULT_REGION` in `.env` if a lesson needs another region.
- Files in the repository are mounted at `/home/coder/project`.
- AWS CLI configuration, editor settings, and emulator data use separate named volumes.
- The Docker socket is mounted into Floci so it can launch containers for services such as Lambda and databases. Only use trusted course code and images.

## Start

Run from the repository root:

```bash
docker compose -f environments/aws/compose.yaml up -d --build
```

Open:

- Workspace: <http://localhost:8080>
- Floci UI: <http://localhost:4500>
- Floci API: <http://localhost:4566>

Sign in with the classroom password `Tinitiate!23456`. An instructor can optionally override it with `CODE_SERVER_PASSWORD` in `.env`.

## Verify and try S3

Open the workspace terminal and run:

```bash
aws --version
aws sts get-caller-identity
aws s3 mb s3://student-demo
aws s3 ls
```

`AWS_ENDPOINT_URL` is already defined, so these commands target Floci rather than AWS.

## Useful commands

```bash
docker compose -f environments/aws/compose.yaml ps
docker compose -f environments/aws/compose.yaml logs -f floci
docker compose -f environments/aws/compose.yaml restart
docker compose -f environments/aws/compose.yaml down
```

Use `down -v` only when you intend to erase the saved AWS configuration, editor data, and locally emulated resources.

## Troubleshooting

- If port 4566, 4500, or 8080 is busy, change the corresponding value in `.env`.
- If Floci-backed services cannot create containers, confirm Docker Desktop is running and has access to its Docker socket.
- Run `docker compose -f environments/aws/compose.yaml logs floci` when an emulated AWS service is unavailable.
