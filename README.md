# Varager

Manage configuration variables for multiple environnements

## How to initialize

```
rake db:create db:migrate db:seed
```

## Tool stack

- Rails 4:
    - [devise](https://github.com/plataformatec/devise): User authentication
    - [ancestry](https://github.com/stefankroes/ancestry): Tree structure for environments
    - [friendly_id](https://github.com/norman/friendly_id): Slug for environments
- Postgresql
- Front:
    - [pnotify](https://github.com/sciactive/pnotify): Notifications

## API Usage

See [API Documentation](APIDOC.md)
