Face-app Server
===============

* Ruby 1.8.7+

Install Dependencies
--------------------

    % gem install bundler
    % bundle install


Config
------

    % cp sample.config.yml config.yml

edit it.


Run
---

    % ruby development.ru

open [http://localhost:8080](http://localhost:8080)


Deploy
------
use Passenger with "config.ru"
