# TwitterClone

## Setup Database

```docker
 docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=t -d mysql
```

## Setup Project

Om de dependencies te installeren ga naar de root folder van het project en voer uit:

```mix
 mix deps.get
```

Hierna in de apps/twitter_clone:

```mix
 mix ecto.reset
```

## Project opstarten

In de root folder voer uit:

```mix
 mix phx.server
```

## Default users

| username | password | role  |
| -------- | -------- | ----- |
| test     | test     | User  |
| test2    | test     | User  |
| admin    | admin    | Admin |
