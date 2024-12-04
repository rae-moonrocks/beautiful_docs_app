
# Beautiful Docs App
Inspired by the [Beautiful Docs repository](https://github.com/matheusfelipeog/beautiful-docs), this app serves as an exploration of various methods and techniques for documenting code effectively.
## Prerequisites

 -  [Ruby/Rails](https://gorails.com/setup/macos/15-sequoia)
-  	[NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
-   [PostgreSQL](https://www.postgresql.org/)


  
  

## Getting Setup

Clone the repository from GitHub

```
git@github.com:rachel-moonrocks/beautiful_docs_app.git
```

Install gems

```
bundle install
```

  

Install Javascript dependencies

```
npm install flowbite
```

Create, migrate, and seed the database

```
bundle exec rails db:create && bundle exec rails db:migrate && bundle exec rails db::seed
```

  
  

Start the server

  

```
bin/rails server
```