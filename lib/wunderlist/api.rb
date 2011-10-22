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

require "net/http"
require "digest/md5"
require "psych"
require "json"
require "nokogiri"
require "date"

require "wunderlist/list"
require "wunderlist/task"

module Wunderlist
  class API
    attr_reader :domain, :path, :email, :session

    def initialize(domain = "www.wunderlist.com", path = "/")
      @domain = domain
      @path = path
      @http = Net::HTTP.new(@domain)
    end

    def login(email, password)
      get_session if @session == nil
      @email = email

      req = prepare_request(Net::HTTP::Post.new "#{@path}/account")
      req.set_form_data({ "email" => @email, "password" => password })
      @http.request req

      req = prepare_request(Net::HTTP::Post.new "#{@path}/ajax/user")
      req.set_form_data({ "email" => @email, "password" => Digest::MD5.hexdigest(password) })
      @http.request req
    end

    def lists
      request = prepare_request(Net::HTTP::Get.new "#{@path}/ajax/lists/all")
      response = @http.request request
      result = {}
      
      Psych.load(response.body)["data"].each do |list_elem|
        list = Wunderlist::List.new
        list.id = list_elem[0].to_i
        list.name = list_elem[1]["name"]
        list.inbox = list_elem[1]["inbox"] == "1" ? true : false
        list.shared = list_elem[1]["shared"] == "1" ? true : false
        list.api = self

        result[list.id] = list
      end

      result
    end

    def tasks(list)
      list = list.id if list.is_a? Wunderlist::List

      request = prepare_request(Net::HTTP::Get.new "#{@path}/ajax/lists/id/#{list}")
      response = @http.request request
      result = []

      Nokogiri::HTML(JSON.parse(response.body)["data"]).css("li.more").each do |html_task|
        task = Wunderlist::Task.new
        task.id = html_task.attributes["id"].value.to_i
        task.name = html_task.css("span.description").first.content
        task.important = html_task.css("span.fav").empty? ? false : true
        task.done = html_task.attributes["class"].value.split(" ").include?("done")
        html_timestamp = html_task.css("span.timestamp")
        task.date = Time.at(html_timestamp.first.attributes["rel"].
        value.to_i).to_date unless html_timestamp.empty?
        task.api = self

        result << task
      end

      result
    end

    protected
    def get_session
      res = @http.request_get("#{@path}/account")
      @session = res["Set-Cookie"].match(/WLSESSID=([0-9a-zA-Z]+)/)[1]
    end

    def prepare_request(req)
      req["Cookie"] = "WLSESSID=#{@session}"
      req
    end
  end
end
