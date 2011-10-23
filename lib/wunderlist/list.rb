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
  class List
    attr_accessor :id, :name, :inbox, :shared, :api

    def initialize(name = nil, inbox = nil)
      @name = name
      @inbox = inbox
    end
    
    def tasks
      @tasks = @api.tasks self if @tasks == nil
      @tasks
    end

    def save(api = nil)
      @api ||= api
      @api.save_list(self)
    end

    def flush
      @tasks = nil
    end
  end
end
