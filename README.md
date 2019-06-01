TShield
=======
## API mocks for development and testing
TShield is an open source proxy for mocks API responses.

* REST
* SOAP
* Session manager to separate multiple scenarios (success, error, sucess variation, ...)
* Lightweight
* MIT license
    
## Basic Usage
### Install

    gem install tshield

### Using

To run server execute this command

    tshield
    
Default port is **4567**
    

#### Config example

Before run `tshield` command is necessary to create config file.
This is an example of `config/tshield.yml`

```yaml
request:
  # wait time for real service
  timeout: 8

# list of domains that will be used
domains:
  # Base URI of service
  'https://service.com':
    # name to identify the domain in the generated files
    name: 'service'

    # paths list of all services that will be called
    paths:
      - /users
```

#### Admin UI

**[WIP]**
http://localhost:4567/admin/sessions

## Config options
```yaml
request:
  timeout: 8
  verify_ssl: <<value>>
domains:
  'http://my-soap-service:80':
    name: 'my-soap-service'
    headers:
      HTTP_AUTHORIZATION: Authorization
      HTTP_COOKIE: Cookie
    not_save_headers:
      - transfer-encoding
    cache_request: <<value>>
    filters: 
      - <<value>>
    excluded_headers:
      - <<value>>
    paths:
      - /Operation

  'http://localhost:9090':
    name: 'my-service'
    headers:
      HTTP_AUTHORIZATION: Authorization
      HTTP_COOKIE: Cookie
      HTTP_DOCUMENTID: DocumentId
    not_save_headers:
      - transfer-encoding
    paths:
      - /secure

  'http://localhost:9092':
    name: 'my-other-service'
    headers:
      HTTP_AUTHORIZATION: Authorization
      HTTP_COOKIE: Cookie
    not_save_headers:
      - transfer-encoding
    paths:
      - /users
```
**request**
* timeout: wait time for real service in seconds
* verify_ssl: <<some_description>>

**domain**
* Define Base URI of service
* name: Name to identify the domain in the generated files
* headers: <<some_description>>
* not_save_headers: <<some_description>>
* cache_request: <<some_description>>
* filters: <<some_description>>
* excluded_headers: <<some_description>>
* paths: paths list of all services that will be called

## Manage Sessions
**[WIP]**

You can use TShield sessions to separate multiple scenarios for your mocks

TShield use <<folder_name>> as default session

### Start TShield session
Start new or existing session

POST to http://localhost:4567/sessions with payload 

{ name: <<<same_name>> }

### Stop TShield session
Stop current session

DELETE to http://localhost:4567/sessions

## Custom controllers

All custom controller should be created in `controllers` directory.

Example of controller file called `controllers/foo_controller.rb`

```ruby
require 'json'
require 'tshield/controller'

module FooController
  include TShield::Controller
  action :tracking, methods: [:post], path: '/foo'

  module Actions
    def tracking(params, request)
      status 201
      headers 'Content-Type' => 'application/json'
      {message: 'foo'}.to_json
    end
  end
end
```

## Samples
#### Basic sample for a client app requesting a server API
**[WIP]**
#### Basic sample for componente/integration test
**[WIP]**

## Setup for local development

### Build
**[WIP]**
### Test
**[WIP]**
