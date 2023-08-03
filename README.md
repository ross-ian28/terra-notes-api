<a name="readme-top"></a>


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <img src="./src/logo.png" alt="Logo" width="20%" height="20%" >
  <h1 align="center">TerraNotes</h1>
  <p align="center">
    Create and save your own sticky notes
    <br />
    <br />
  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
      <li><a href="#installation">Installation</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



## About The Project

A notes application where a user can login into an account and see their saved information
Functionality includes creating sticky notes, reading created notes, edit notes, or deleting notes



## Built With
  ![BadgeURLHere](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
  ![BadgeURLHere](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
  ![BadgeURLHere](https://img.shields.io/badge/json-5E5C5C?style=for-the-badge&logo=json&logoColor=white)

  <p align="right">(<a href="#readme-top">back to top</a>)</p>

  
## Installation

1. Fork this Repo
2. Clone the repo down to your machine
   ```sh
     git clone git@github.com:ross-ian28/terra-notes-api.git
   ```
4. `cd terra-notes-api` to move into the project directory
5. Install gems and dependencies
   ```sh
     bundle install
   ```
6. Create database
   ```sh
     rails db:create
   ```
7. To run RSpec tests
   ```sh
     bundle exec rspec
   ```
8. Run your server
   ```sh
     rails s
   ```
9. Be sure that both <a href="https://github.com/ross-ian28/TerraNotesUI/tree/main">front-end</a> and back-end servers are running at the same time

<p align="right">(<a href="#readme-top">back to top</a>)</p>



## Endpoints
```
http://localhost:5000
```
### Returns a registered user
```
POST /api/v1/register

body: 
{
    "name": "Pabu",
    "email": "pabu@2pabu.com",
    "password": "pabu123"
}
headers: Content-Type = application/json
```
```
{
    "data": {
        "type": "users",
        "id": 2,
        "attributes": {
            "name": "Pabu",
            "email": "pabu@2pabu.com",
            "username": null,
            "logged_in": false,
            "incognito_mode": false
        }
    }
}
```


## Contact

Ian Ross - [@LinkedIn](https://github.com/ross-ian28) - ianross.codes@gmail.com
