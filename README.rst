ruby-wunderlist
===============

ruby-wunderlist is an inofficial Ruby binding for the undocumented Wunderlist API.

Features:

* Change list names
* Get all tasks of a list
* Filter lists
* Reuse login session

Dependencies
------------

* `json <http://rubygems.org/gems/json>`_
* `nokogiri <http://rubygems.org/gems/nokogiri>`_

Example
-------

::

    require "wunderlist"
    api = Wunderlist::API.new
    
    # Login with your credentials
    api.login "johndoe@example.org", "mypassword"
    
    # Get the inbox list
    inbox = api.inbox
    
    # Get all overdue tasks
    overdue = inbox.done
    
    overdue.each do |task|
      task.done = true
      task.save
    end
