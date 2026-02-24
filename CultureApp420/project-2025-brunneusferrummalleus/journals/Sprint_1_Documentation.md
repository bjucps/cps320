# Sprint One Documentation

## Overview

Sprint One (September 6–13, 2025) focused on establishing our development environment, setting up PostgreSQL with Docker, preparing security practices like GPG commit signing, and beginning groundwork for program information storage.

## Sprint Goals / Achievements

- **Basic Django Setup**
- **PostgreSQL Dockerized for development**
    
    *Note: Django dockerization was attempted but not yet successful.*
    
- **Start program information storage (PC-1)**

## Development Log Highlights

### Environment Setup & Security

- Implemented GPG key signing for all commits
- Retroactively signed previous commits using `git rebase`
- Removed secrets from Django configuration
- Set up environment variables for secure configuration

### Docker Configuration

- Docker Compose used to containerize **PostgreSQL** successfully
- Django container build attempted but remains broken; currently Django must be run directly with `python manage.py runserver` (assuming `uv` is set up and synced)
- Initial work begun on a **multi-stage build** for optimized image size (not yet committed)
- Set up environment variable integration and separation of development vs. production settings
- Volume management configured for database persistence

### Database Integration

- Configured Django to connect with PostgreSQL
- Implemented proper environment variable handling for database credentials

## Project Analysis

### Throughput

- **Story Points Completed**: 5
- **Major Features Delivered**:
    - PostgreSQL dockerized development environment (3)
    - Environment variable configuration (1)
    - GPG commit signing setup (1)

### Stability

- **Bug Count**: 2 introduced and resolved during sprint
    - Issue with `psycopg2` installation in Docker container (*bug still being worked on; kept here for tracking*)
    - Environment variable loading in Windows development environment

### Velocity Projection

- **Next Sprint Estimate**: 20 points
- **Reasoning**: With PostgreSQL dockerized and base environment/security practices in place, the team expects to accelerate feature development. The team has overcome key setup hurdles and built momentum.

### Corrections from Previous Feedback

Not applicable for Sprint One.

## Security Documentation

### GPG Commit Signing

All commits are now signed with GPG keys to ensure code authenticity. This addresses security requirement SR-3 (secure data handling) at the source code level.

### Environment Variable Management

Implemented secure handling of configuration through environment variables:

- Database credentials
- Django secret key
- Debug settings
- Allowed hosts

## DevOps Documentation

### Docker / Development Environment Setup

1. **Prerequisites**
    - Docker and Docker Compose installed
    - Git with GPG configured for commit signing
2. **Initial Setup**
    
    ```bash
    git clone [repository]
    cd [project-directory]
    cp .env.example .env
    # Edit .env with appropriate values
    docker compose up -d   # starts PostgreSQL
    python manage.py runserver   # starts Django app (Docker build currently broken)
    
    ```
    
3. **Accessing the Application**
    - Web application: [http://localhost:8000](http://localhost:8000/)
    - PostgreSQL database: [http://localhost:5432](http://localhost:5432/)

### Common Issues and Solutions

- **psycopg2 installation fails**: Installing `libpq-dev` and `gcc` in the Docker image helps, but this is currently more of a debug workaround than a final fix
- **Environment variables not loading**: Check `.env` file format and Docker Compose configuration
- **GPG signing errors**: Verify GPG key is properly configured with Git

## Questions for Customer

1. Are there specific report formats needed for attendance exports?

## Next Sprint Goals

- Complete authentication framework integration
- Implement CI pipeline with GitHub Actions
- Build unit tests for event API endpoints

## Resources Used

- Docker and Django integration: [BetterStack Guide](https://betterstack.com/community/guides/scaling-python/dockerize-django/)
- GPG commit signing: [GitHub Documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- psycopg2 in Docker: [Medium Article](https://wbarillon.medium.com/docker-python-image-with-psycopg2-installed-c10afa228016)
- Environment variables in Windows: [Stack Overflow](https://stackoverflow.com/questions/48607302/using-env-files-to-set-environment-variables-in-windows)
