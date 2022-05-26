# TwitterClone

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
