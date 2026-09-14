# Snowflake student Docker environment

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Snowflake configuration.

This environment provides a focused Snowflake workspace. Unlike the AWS, Azure, and GCP choices, it does not include a local Snowflake server emulator and requires access to a real Snowflake account for queries.

## What is included

- **code-server:** Visual Studio Code in the browser, available on port 8080.
- **Snowflake CLI:** Provides the `snow` command for connections, SQL, objects, and projects.
- **Snowflake Connector for Python:** Allows Python programs to connect and run SQL.
- **Snowpark Python:** Supports Snowpark DataFrame and application exercises.
- **Shared student tools:** Python, PySpark, Jupyter, Node.js, npm, Git, and the standard editor extensions.

## Important points

- A Snowflake account supplied by the instructor or organization is required.
- Credentials are not included in the image or Compose file.
- Snowflake configuration is stored in a dedicated Docker volume at `/home/coder/.snowflake`.
- The project repository is mounted at `/home/coder/project`.
- Do not commit passwords, private keys, tokens, or populated connection files to Git.
- Prefer browser-based authentication, key-pair authentication, or another instructor-approved method instead of storing a password in plain text.

## Start

Run from the repository root:

```bash
docker compose -f environments/snowflake/compose.yaml up -d --build
```

Open <http://localhost:8080> and sign in with the classroom password `Tinitiate!23456`. An instructor can optionally override it with `CODE_SERVER_PASSWORD` in `.env`.

## Configure and verify

Open the workspace terminal:

```bash
snow --version
snow connection add
snow connection test
```

Follow the prompts using the account information supplied by the instructor. Connection names and available authentication options can differ by course or organization.

After a connection is working, run a simple query:

```bash
snow sql -q "select current_version(), current_user()"
```

## Useful commands

```bash
docker compose -f environments/snowflake/compose.yaml ps
docker compose -f environments/snowflake/compose.yaml logs -f dev
docker compose -f environments/snowflake/compose.yaml restart
docker compose -f environments/snowflake/compose.yaml down
```

Use `down -v` only when you intend to erase the saved editor and Snowflake connection configuration.

## Troubleshooting

- If port 8080 is busy, change `CODE_SERVER_PORT` in `.env`.
- Use `snow connection list` to confirm the expected connection exists.
- Check the account identifier, user, role, warehouse, and authentication method when a connection test fails.
- Corporate VPN, proxy, or firewall settings may prevent the container from reaching Snowflake.
