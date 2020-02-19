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

def validate(username,password,password_confirmation)
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