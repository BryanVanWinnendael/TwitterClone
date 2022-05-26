# TwitterClone <img src="https://github.com/BryanVanWinnendael/TwitterClone/blob/main/apps/twitter_clone_web/priv/static/images/twitter.png" alt="drawing" width="50"/> 

## Setup Database

```docker
 docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=t -d mysql
```

## Setup Project

Voer de volgende opdrachten uit in de projectmap om aan de slag te gaan:

```mix
 mix deps.get
```

apps/twitter_clone:

```mix
 mix ecto.reset
```

## Project opstarten

In de projectmap:

```mix
 mix phx.server
```

## Default users

| username | password | role  |
| -------- | -------- | ----- |
| test     | test     | User  |
| test2    | test     | User  |
| admin    | admin    | Admin |

## API
### Public api
**Krijg overzicht users**
<br />
`GET:` /api/public/users
<br />
<br />
**Maak een user**
<br />
`POST:` /api/private/users
```
 {
  user[username]: {username}
  user[password]: {password}
  user[date_of_birth]: {date_of_birth}
  user[email]: {email}
 }
```

### Private api
#### Genereer eerst een api_key op de settings pagina van je account
**Verwijder een user**
<br />
`DEL:` /api/private/users/{user_id}
<br />
<br />
**Update een user**
<br />
`PUT:` /api/private/users/{user_id}
```
 {
  user[username]: {username}
  user[password]: {password}
  user[date_of_birth]: {date_of_birth}
  user[email]: {email}
  user[profile_image]: {profile_image}
  user[banner_image]: {banner_image}
 }
```


