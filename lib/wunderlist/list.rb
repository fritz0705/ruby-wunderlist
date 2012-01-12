# (Inofficial) Wunderlist API Bindings
# vim: sw=2 ts=2 ai et
#
# Copyright (c) 2011 Fritz Grimpen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module Wunderlist
  ##
  # A FilterableList represents an array of Tasks and provides methods to
  # filter the list by the tasks
  class FilterableList
    ##
    # Array of tasks
    attr_accessor :tasks

    def initialize(tasks = [])
      @tasks = tasks
    end

    ##
    # Get all tasks whose date is today
    def today
      FilterableList.new(tasks.clone.keep_if do |t|
        t.date == Date.today && !t.done
      end)
    end

    ##
    # Get all tasks which are important
    def priority
      FilterableList.new(tasks.clone.keep_if do |t|
        t.important && !t.done
      end)
    end

    ##
    # Get all tasks which are not important
    def not_priority
      FilterableList.new(tasks.clone.keep_if do |t|
        !t.important && !t.done
      end)
    end

    ##
    # Get all done tasks
    def done
      FilterableList.new(tasks.clone.keep_if do |t|
        t.done == true
      end)
    end

    ##
    # Get all non-done tasks
    def not_done
      FilterableList.new(tasks.clone.keep_if do |t|
        t.done != true
      end)
    end

    ##
    # Get all overdue tasks
    def overdue
      FilterableList.new(tasks.clone.keep_if do |t|
        t.date && t.date < Date.today && !t.done
      end)
    end

    ##
    # Get all non-overdue tasks
    def not_overdue
      FilterableList.new(tasks.clone.keep_if do |t|
        (!t.date || t.date < Date.today) && !t.done
      end)
    end
    
    def to_s
      lines = []
      lines << "[List] [Filtered] #{tasks.count != 1 ? "#{tasks.count} tasks" : "#{tasks.count} task"}"

      tasks.each do |task|
        lines << "  #{task}"
      end
      
      lines.join "\n"
    end
  end

  ##
  # A List is a FilterableList which can be synchronized with an API object
  class List < FilterableList
    ##
    # ID of the list on the Wunderlist server
    attr_accessor :id

    ##
    # Name of the list
    attr_accessor :name

    ##
    # Value which determines whether this list is a INBOX or or not
    attr_accessor :inbox

    ##
    # true, if list is shared, otherwise false
    attr_accessor :shared

    ##
    # Reference to the associated API object. Necessary for many methods.
    attr_accessor :api

    def initialize(name = nil, inbox = nil, api = nil)
      @name = name
      @inbox = inbox
      @api = api
    end
    
    ##
    # Get all tasks
    def tasks
      @tasks = @api.tasks self if @tasks == nil
      @tasks
    end

    ##
    # Create task with specified name and date
    def create_task(name, date = nil)
      Wunderlist::Task.new(name, date, self, @api).save
    end

    ##
    # Save list with api
    def save(api = nil)
      @api ||= api
      @api.save(self)
    end

    ##
    # Destroy list with api
    def destroy(api = nil)
      @api ||= api
      @api.destroy(self)
    end

    ##
    # Remove tasks cache
    def flush
      @tasks = nil
    end

    def to_s
      lines = []
      lines << "[List]#{inbox ? " [INBOX]" : ""} #{name} - #{tasks.count != 1 ? (tasks.count.to_s + " tasks") : tasks.count.to_s + " task"}"

      tasks.each do |task|
        lines << "  #{task}"
      end

      lines.join "\n"
    end
  end
end
