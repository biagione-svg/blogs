FROM python:3.12-slim as builder

WORKDIR /blogs

# Install uv and make
RUN pip install --no-cache-dir uv && \
    apt-get update && apt-get install -y make

# Copy only the files needed for dependency installation
COPY pyproject.toml Makefile ./
COPY blogs ./blogs

# Use uv to install dependencies
RUN uv pip install --system .

FROM python:3.12-slim

WORKDIR /blogs

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser && \
    pip install --no-cache-dir uv && \
    apt-get update && apt-get install -y make

# Copy the installed dependencies and project files
COPY --from=builder /usr/local/lib/python*/site-packages /usr/local/lib/python*/site-packages/
COPY blogs ./blogs
COPY pyproject.toml Makefile ./

# Switch to non-root user
USER appuser

# Use make start to run the application
ENTRYPOINT ["make"]
CMD ["start"]
