# MusicArts Leaflet Builder  
## EJM Ops

### Project Manager: Jong Mar
### DevOps Engineer: Jong Mar
### Developer: Jethro Badar
### Security Administrator: Yi Tang


### Prerequisites
Make sure you have these installed:
- Python 3.13+  
- pip  
- PostgreSQL 17+  
- Git  


### Django Environment Setup  
To successfully run the project, follow these steps:  
 - Create a virtual environment for this project by running 'python -m venv <yourenv>'.
 - Use the new venv as the python environment for this project to c
 - run  ```git clone <repository>```
 - Create a .env file in the root folder with this structure:
```bash
    SECRET_KEY='your-own-secret-key'
    DB_NAME='your_db_name'
    DB_USER='your_db_user'
    DB_PASSWORD='your_db_password'
    DB_HOST='localhost'
    DB_PORT=5432
```

## Run with Docker
 - Install Docker Desktop.
 - Start the stack:
   ```bash
   docker-compose up --build

### Running the Tests

**NOTE**: To get the container's pid, just run ```docker ps``` in another terminal to see all the running container/s. 

If you want to see the test coverage of the whole code, just run:
```bash
docker exec <container pid> run --source='.' manage.py test
docker exec <container pid> coverage html
open htmlcov/index.html  # macOS
start htmlcov\index.html  # Windows
xdg-open htmlcov/index.html # Linux
```

### Implemented Features
 - Successfully set up the Django environment.
 - Successfully integrated PostgresSQL.
 - Created Event and Division models (models are not yet finalized and may change as the project progresses).
 - Implemented login, signup, and logout functionality, including styled pages for the signup and login forms.
 - Designed a user-friendly hero section on the homepage.
 - Completed base.html with dynamic header and footer to serve as the layout template for all pages.
 - Event leaflet generator following the given format
 - Event leaflet builder form for the admins to add events.
 - Further refine the models.
 - Decide what pages can be access depending on the permission level
 - Added a feature for the admins to delete created events
 - Added the initial version of the event's footer  
 - Added an ellipsis menu to store all the buttons to manage event's sections and its elements. It is the best practice to prepare the code for expansion of features.
 - Added a feature for the admins to delete created event's sections.
 - Responsive UI for different screen sizes
 - Added QR code in the footer


