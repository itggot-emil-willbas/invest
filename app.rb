require 'sinatra'
require 'slim'
require 'byebug'
require 'sqlite3'
require 'bcrypt'

require_relative './model.rb'

# MODEL (Mvc)
# I denna fil ligger:
# - databasinteraktion
# - Valideringar (passwordcheck, om ej inloggad, kontrollera inkommande data)
# - Authentication (Vem är du?)

# View (mVc)
# - Slimfiler (Delsidor)
# - CSS, JS
# - Partials (Delar av sidor)
# - User Interface
# - Felmeddelanden

# Controller (mvC)
# - App.rb
# - Alla routes
# - Sessioner
# - Authorization (Vad får du göra om du är tex inloggad)
# - Felhantering

enable :sessions



before do
  session[:user] = 1
  if (session[:user] ==  nil) && (request.path_info != '/')
    p "If-sats körs"
    session[:error] = "You need to log in to see this"
    redirect('/error')
  end
end

def set_error(errormsg) 
 session[:errormsg] = errormsg
end

def get_error()
  errormsg = session[:errormsg]
  session[:errormsg] = nil
  return errormsg
end

get('/') do
  slim(:start)
end

get('/error') do
  slim(:error)
end

get('/investments/') do
  user = session[:user]
  investments = get_investments_for_user(user)
  slim(:"investments/index",locals:{investments:investments})
end

get('/investments/new') do
  slim(:"investments/new")
end

post('/login') do
  username = params["username"]
  password = params["password"]
  password_confirmation = params["password_confirmation"]

  errormsg = validate(username,password,password_confirmation)
  
  if errormsg == ""
    user = login(username,password,password_confirmation)
    if user == nil
      set_error("Username or password doesn't match.")
    else
      session[:user] = user  
      redirect('/investments')
    end
  else
    set_error(errormsg)
  end


	

end


