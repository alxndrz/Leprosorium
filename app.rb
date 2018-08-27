#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db

	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		created_date DATE,
		content TEXT
	)'
end

#Get
get '/' do

	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'

  erb :index
end

get '/new' do
  erb :new
end

get '/posts' do
  erb :posts
end

get '/details/:post_id' do
	post_id = params[:post_id]
	erb "Displaying information for post with id #{post_id}"
end

#POST

post '/new' do
  @content = params[:content]

  if @content.length <= 0
  	@error = 'Type post text'
  	return erb :new
  end

  @db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [@content]
  redirect to '/'
  erb  "You typed #{@content}"
end
