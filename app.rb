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
  investments = get_investments_for_user(user).reverse()
  slim(:"investments/index",locals:{investments:investments})
end

get('/investments/new') do

  slim(:"investments/new")
end

get('/investments/:id/edit') do
  invest_id = params["id"]
  p "Invest_id: #{invest_id}"
  investment = get_investment_readable_data(invest_id).first #skapa
  p "investment: #{investment}"
  slim(:"investments/edit",locals:{investment:investment})
  
end

post('/investments/:id/update') do
  item_name = params["item_name"]
  amount = params["amount"]  
  aprice = params["aprice"]  
  total = params["total"]  
  seller = params["seller"]  
  date = params["date"]  
  storage_place= params["storage_place"]  
  user_id = 1
  update = true
  invest_id = params["id"]

  if (session[:user] != nil)
    if new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place,update,invest_id) == true
      redirect('/investments/')
    else
      set_error("Something want crazy with your update")
      redirect('/error')
    end
  end

end

post('/investments/:id/delete') do
  invest_id = params["id"]
  #kolla vilka om fler invests har samma foreignKeys. Om inte: ta bort från tabell2 
end

post('/investments/new') do
  item_name = params["item_name"]
  amount = params["amount"]  
  aprice = params["aprice"]  
  total = params["total"]  
  seller = params["seller"]  
  date = params["date"]  
  storage_place= params["storage_place"]  
  user_id = 1
  update = false
  invest_id = ""
    
  if (session[:user] != nil)
    if new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place,update,invest_id) == true
      redirect('/investments/')
    else
      set_error("Something want crazy with your post")
      redirect('/error')
    end
  end
  
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



get('/upload_image') do
  slim(:upload_image)
end

post('/upload_image') do
  #Skapa en sträng med join "./public/uploaded_pictures/cat.png"
  path = File.join("./public/uploaded_pictures/",params[:file][:filename]) 
  
  #Skriv till path innehållet i tempfile
  File.write(path,File.read(params[:file][:tempfile]))
  
  redirect('/upload_image')
end


# p "Path: #{path}"
#   p "Params[:file]: #{params[:file]}"
#   p "Params[:file][:filename]: #{params[:file][:filename]}"
#   p "Params[:file][:tempfile]: #{params[:file][:tempfile]}"
  
  # p params[:file][:tempfile]
  # File.open('public/uploaded_pictures/' + params[:file][:filename], "w") do |f|
  #   f.write(params[:file][:tempfile].read)
  # end

  #@filename = params[:file][:filename]
  #file = params[:file][:tempfile]
  #File.open("./public/uploaded_pictures/#{@filename}", 'wb') do |f|
  #  f.write(file.read)
  #end
  #return @filename