# TwitterClone <img src="https://github.com/BryanVanWinnendael/TwitterClone/blob/main/apps/twitter_clone_web/priv/static/images/twitter.png" alt="drawing" width="50"/> 

## Setup Database

```docker
 docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=t -d mysql
```

## Setup Project

```mix
 mix deps.get
```

apps/twitter_clone:

```mix
 mix ecto.reset
```

## Startup

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
**Overview users**
<br />
`GET:` /api/public/users
<br />
<br />
**Create user**
<br />
`POST:` /api/public/users
```
 {
  user[username]: {username}
  user[password]: {password}
  user[date_of_birth][day]: {day}
  user[date_of_birth][month]: {month}
  user[date_of_birth][year]: {year}
  user[email]: {email}
 }
```

### Private api
#### Generate first an api_key on the settings page of your account
**Delete user**
<br />
`DEL:` /api/private/users/{user_id}
<br />
<br />
**Update user**
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


