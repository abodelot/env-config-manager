#!/usr/bin/env ruby

##
# Usage: varager-cli.rb --email EMAIL --password PASSWORD --app APPNAME
#

require 'net/http'
require 'json'
require 'rack'
require 'optparse'
require 'byebug'

options = {}
OptionParser.new do |opts|
  opts.on('--email EMAIL') do |value|
    options[:email] = value
  end
  opts.on('--password PASSWORD') do |value|
    options[:password] = value
  end
end.parse!

class VaragerApi
  def initialize(url)
    uri = URI.parse(url)
    @http = Net::HTTP.new(uri.host, uri.port)
  end

  def sign_in(email, password)
    request = Net::HTTP::Post.new("/users/sign_in.json")
    request.body = Rack::Utils.build_nested_query({
      :user => {
        :email => email,
        :password => password
      }
    })
    response = @http.request(request)
    if response.code == '200'
      @email = email
      @authentication_token = JSON.parse(response.body)['authentication_token']
      print_response(response)
      return true
    end
    print_response(response)
    return false
  end

  def get(method)
    request = Net::HTTP::Get.new(method)
    self.send(request)
  end

  def put(method, data)
    request = Net::HTTP::Put.new(method)
    request.body = Rack::Utils.build_nested_query(data)
    self.send(request)
  end

  def delete(method)
    request = Net::HTTP::Delete.new(method)
    self.send(request)
  end

  def send(request)
    request.add_field('X-User-Email', @email)
    request.add_field('X-User-Token', @authentication_token)
    @http.request(request)
  end

end

def print_response(response)
  begin
    json = JSON.parse(response.body)
    puts JSON.pretty_generate(json)
  rescue JSON::ParserError => e
    puts e.message
  end
end

api = VaragerApi.new('http://localhost:3000')
puts "Authentication..."
if !api.sign_in(options[:email], options[:password])
  exit
end


input = ''
while true
  print '>> '
  input = gets.chomp
  if input != 'exit'
    verb, method = input.split()
    case verb
    when 'get'
      response = api.get(method)
    when 'put'
      puts "Arguments?"
      arguments = {}
      gets.chomp.split(',').each do |arg|
        args = arg.split('=')
        arguments[args.first] = args.last
      end
      response = api.put(method, {:config => arguments})
    when 'delete'
      response = api.delete(method)
    end

    if response.code == '200'
      puts 'API success'
    else
      puts 'API error'
    end
    print_response(response)
  else
    break
  end
end

