#encoding: utf-8

#REQUIRES:
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

#Функции, before and configure
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

#Get-запросы
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

#Вывод информации о посте
get '/details/:post_id' do
  post_id = params[:post_id]

  results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
  @row = results[0]

  erb :details
end

#POST-запросы

post '/new' do
  #Получаем переменную из POST-запроса
  @content = params[:content]

  if @content.length <= 0
    @error = 'Type post text'
    return erb :new
  end
  #Сохранение данных в БД
  @db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [@content]
  #Перенаправление на главную страницу
  redirect to '/'
end
