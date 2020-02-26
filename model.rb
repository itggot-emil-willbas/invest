# MODEL (Mvc)
# I denna fil ligger:
# - databasinteraktion
# - Valideringar (passwordcheck, om ej inloggad, kontrollera inkommande data)
# - Authentication (Vem är du?)

# View (mVc)
# - Slimfiler (Delsidor)
# - Partials (Delar av sidor)
# - User Interface
# - Felmeddelanden

# Controller (mvC)
# - App.rb
# - Authorization (Vad får du göra om du är tex inloggad)
# - Alla routes
# - Felhantering
# - Konfiguration (vad menas?)

def connect_to_db()
  db = SQLite3::Database.new('db/invest.db')
  db.results_as_hash = true
  return db
end

def validate_registration(username,password,password_confirmation)
end

def validate_new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place)
  return true
end

def login(username,password,password_confirmation)
  db = connect_to_db()
	password_digest = db.execute("SELECT password_digest FROM users WHERE name = ?",username).first["password_digest"]
  if BCrypt::Password.new(password_digest) == password
    db = connect_to_dn()
    user = db.execute("SELECT id FROM users WHERE name = ?", username).first["id"]
    return user   
  else
    return nil
  end
end



def get_investments_for_user(user)
  db = connect_to_db()
  investments = db.execute("SELECT
    investments.id,
    investments.amount,
    investments.aprice,
    investments.total,
    investments.date,
    investments.item_id,
    items.item_name,
    sellers.seller_name,
    storages.storage_place
    FROM (((investments 
      INNER JOIN items ON investments.item_id = items.id)
      INNER JOIN sellers ON investments.seller_id = sellers.id)
      INNER JOIN storages ON investments.storage_place_id = storages.id)
      WHERE user_id = ?",user)
      return investments
    end

def get_id_from_value(table,column,value)
  db = connect_to_db()
  values = db.execute("SELECT * FROM #{table} WHERE #{column}=?",value).first
  return values
end

def new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place)
  if validate_new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place) != true
    return false
  else
    db = connect_to_db()

    #CHECK IF UNIQUE FIRST
    #storage_place
    db.execute("INSERT INTO storages (storage_place) VALUES (?)",storage_place)
    #item_name
    db.execute("INSERT INTO items (item_name) VALUES (?)",item_name)
    #seller
    db.execute("INSERT INTO sellers (seller_name) VALUES (?)",seller)

    #Foreign keys
    fetched_storage_place_id = get_id_from_value("storages","storage_place",storage_place)["id"]
    fetched_seller_id = get_id_from_value("sellers","seller_name",seller)["id"]
    fetched_item_id = get_id_from_value("items","item_name",item_name)["id"]

    #Investments
    db.execute("INSERT INTO investments (amount,aprice,total,date,user_id,storage_place_id,seller_id,item_id)
     VALUES (?,?,?,?,?,?,?,?)",amount.to_i,aprice.to_i,total.to_i,date,user_id,fetched_storage_place_id.to_i,fetched_seller_id.to_i,fetched_item_id.to_i)
    
    return true

  end
  
      
end