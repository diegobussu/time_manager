&nbsp;

# ShiftSync <img src="time_manager_front/favicon.png" href="https://github.com/dodoll27/TimeManager" width="100" align="left">

[![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Vue.js](https://img.shields.io/badge/vuejs-%2335495e.svg?style=for-the-badge&logo=vuedotjs&logoColor=%234FC08D)](https://vuejs.org/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/fr/)
[![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)](https://www.postman.com/)
[![Swagger](https://img.shields.io/badge/-Swagger-%23Clojure?style=for-the-badge&logo=swagger&logoColor=white)](https://swagger.io/)


&nbsp;

**ShiftSync is a comprehensive time-tracking system tailored for Gotham Enterprises. Designed to cater to various user roles, including Employees, Managers, and Super Managers, it facilitates efficient management of work hours and group activities.**


&nbsp;

# Project Setup Instructions

Welcome to the ShiftSync project. Follow these steps to get your development environment up and running.

## Cloning the Repository

First, you need to clone the repository:

```bash
git clone https://github.com/diegobussu/time_manager
cd time_manager
```

## Environment Configuration

Before running the application, you need to set up the environment variables:

1. Take a look at the `.env.template` file in the `time_manager_front/` directory which contains a sample configuration. Review the file to understand the required environment variables.

2. Create a new `.env` file by copying the `.env.template` file:

```bash
cd time_manager_front
cp .env.template .env
```

3. Edit the .env file with your specific configurations (Do not pay attention to others .env.template files which are intended for production).


## Building locally

- Ensure you have npm, elixir and pgsql installed on your machine.
  
```bash
cd time_manager_front
npm install
```

```bash
npm run dev
```

```bash
cd time_manager_api
mix setup
```

```bash
mix phx.server
```

## Building with Docker

- Ensure you have Docker and Docker Compose installed on your machine. Then, build and start the services:

```bash
docker-compose up --build
```

## Accessing the Application

- Navigate to the URL specified in your `.env` file's `VITE_AXIOSBASEURL` value, for example :
  
```bash
 http://localhost:5173
```

## Repository Mirror

https://github.com/dodoll27/TimeManager

### Enjoy your time with the ShiftSync application !
