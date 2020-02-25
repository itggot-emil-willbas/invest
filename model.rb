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

def get_id_from_value(table,value)
  db = connect_to_db()
  values = db.execute("SELECT * FROM ? WHERE id=?",table,id).first
  return values
end

def new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place)
  if validate_new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place) != true
    return false
  else
    db = connect_to_db()
    #user 
    db.execute("INSERT INTO investments (user_id) VALUES (?)",user_id)
    #item_name + item_id
    db.execute("INSERT INTO items VALUES (?)",item_name)
    fetched_item_id = get_id_from_value("items",item_name)["item_name"]
    db.execute("INSERT INTO investments (item_id) VALUES (?)",fetched_item_id.to_i)
    #amount 
    db.execute("INSERT INTO investments (amount) VALUES (?)",amount.to_i)
    #aprice
    db.execute("INSERT INTO investments (aprice) VALUES (?)",aprice.to_i)
    #total
    db.execute("INSERT INTO investments (total) VALUES (?)",total.to_i)
    #seller,seller_id
    db.execute("INSERT INTO sellers VALUES (?)",seller)
    fetched_seller_id = get_id_from_value("sellers",seller)["seller_name"]
    db.execute("INSERT INTO investments (seller_id) VALUES (?)",fetched_seller_id.to_i)
    #date
    db.execute("INSERT INTO investments (date) VALUES (?)",date)
    #storage,store_id
    db.execute("INSERT INTO storages VALUES (?)",storage_place)
    fetched_storage_place_id = get_id_from_value("storages",storage_place)["storage_place"]
    db.execute("INSERT INTO investments (storage_place_id) VALUES (?)",fetched_storage_place_id.to_i)

    return true

  end
  
      
end