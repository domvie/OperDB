import sqlite3, os
from flask import Flask, g

app = Flask(__name__)
app.secret_key="key123"


DATABASE = 'Oper.db'

# Funktion baut Verbindung zur DB auf und returned db Objekt
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    #Ergebnisse zu einem dict konvertieren
    def make_dicts(cursor, row):
        return dict((cursor.description[idx][0], value)
            for idx, value in enumerate(row))
    db.row_factory = make_dicts
    return db


#Funktion um eine query durchzuführen, returned Ergebnisliste
def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

def insert_db(query, args=()):
    with sqlite3.connect(DATABASE) as con:
        cur = con.cursor()
        cur.execute(query,args)
    con.commit()
    con.close()

# Initialisiert die DB mit dem Schema
def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

def insert_dummies():
    with app.app_context():
        db = get_db()
        with app.open_resource('dummys.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

# Überprüft ob DB bereits besteht und initialisiert die DB wenn nicht
def CheckIfDbExists():
    if not os.path.isfile(DATABASE):
        print("Database does not exist yet. Creating new Database: ", DATABASE)
        init_db()
        print("\nDatabase created successfully. Inserting Dummy values.. ")
        try:
            insert_dummies()
            print("Success")
        except:
            print("Error inserting dummies")
    else:
        print("Using existing database: " + DATABASE)