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

def get_all(table_name,id)
  db = connect_to_db()
  result = db.execute("SELECT * FROM #{table_name} WHERE id = ?",id.to_i)
  return result
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

    def get_investment_readable_data(invest_id)
      db = connect_to_db()
        investment = db.execute("SELECT
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
          WHERE investments.id = ?",invest_id.to_i)
          return investment
        end

def get_id_from_value(table,column,value)
  db = connect_to_db()
  values = db.execute("SELECT * FROM #{table} WHERE #{column}=?",value).first
  return values
end

def check_if_exists(table,column,value)
  db = connect_to_db()
  result = db.execute("SELECT * from #{table} WHERE #{column} = ?",value)
  if result == []
    p "Nothing new! Returning false"
    return false
  else
    p "There was something new! Returning true"
    return true
  end
end

def delete_cascade()

def new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place,update,invest_id)
  if validate_new_investment(user_id,item_name,amount,aprice,total,seller,date,storage_place) != true
    return false
  else
    db = connect_to_db()

    #CHECK IF UNIQUE FIRST
    if check_if_exists("storages","storage_place",storage_place) == false
      db.execute("INSERT INTO storages (storage_place) VALUES (?)",storage_place)
    else
      p "Storage fanns redan"
    end
    if check_if_exists("items","item_name",item_name) == false
      db.execute("INSERT INTO items (item_name) VALUES (?)",item_name)
    else
      p "item fanns redan"
    end
    if check_if_exists("sellers","seller_name",seller) == false
      db.execute("INSERT INTO sellers (seller_name) VALUES (?)",seller)
    else
      p "Seller fanns redan"
    end

    fetched_storage_place_id = get_id_from_value("storages","storage_place",storage_place)["id"]
    fetched_seller_id = get_id_from_value("sellers","seller_name",seller)["id"]
    fetched_item_id = get_id_from_value("items","item_name",item_name)["id"]

    if update == false
      db.execute("INSERT INTO investments (amount,aprice,total,date,user_id,storage_place_id,seller_id,item_id)
      VALUES (?,?,?,?,?,?,?,?)",amount.to_i,aprice.to_i,total.to_i,date,user_id,fetched_storage_place_id.to_i,fetched_seller_id.to_i,fetched_item_id.to_i)
    else
      db.execute("UPDATE investments SET amount = ?,aprice = ?,total = ?,date = ?,user_id = ?,storage_place_id = ?,seller_id = ?,item_id = ? WHERE investments.id = ? ",amount.to_i,aprice.to_i,total.to_i,date,user_id,fetched_storage_place_id.to_i,fetched_seller_id.to_i,fetched_item_id.to_i,invest_id.to_i)
    end
    return true
  end    
end

def delete_investment(invest_id)
  # lists = [
  #   {
  #     table:"investments",column:"seller_id",value:
  #   }
  # ]
  # lists.each do |list|
  db = connect_to_db()
  foreign_keys = db.execute("SELECT item_id,seller_id,storage_place_id FROM investments WHERE id=?",invest_id)
  delete_cascade()
  db.execute("DELETE FROM investments WHERE id = ?",invest_id)

end
