import os, sys, sqlite3
from flask import Flask, render_template, flash, url_for, session, request, logging, g, redirect
from wtforms import Form, StringField, TextAreaField, PasswordField, validators, IntegerField
from passlib.hash import sha256_crypt, pbkdf2_sha256
from functools import wraps
#from flask_debugtoolbar import DebugToolbarExtension

''' Hauptseite - wird angezeigt, wenn man auf 127.0.0.1:5000 bzw localhost:5000 geht (vorher ausführen) '''

"""Create and configure an instance of the Flask application."""
app = Flask(__name__)
app.debug=True
app.secret_key="key123"
#toolbar = DebugToolbarExtension(app)

DATABASE = 'Oper.db'

# Hilfestellung bzw. Quelle der Funktionen: http://flask.pocoo.org/docs/1.0/patterns/sqlite3/
# Alternativ gehts so https://www.tutorialspoint.com/flask/flask_sqlite.htm aber wills lieber mal auf diesem Web probieren

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
    

CheckIfDbExists()

@app.route('/')
def index():
    return render_template('home.html')

@app.route('/suche')
def suche():
    return render_template('suche.html')

@app.route('/buchung')
def buchung():
    return render_template('buchung.html')

@app.route('/bevorstehend')
def bevorstehend():

    auffuehrungen = query_db("SELECT * FROM users")

    if auffuehrungen:
        return render_template('bevorstehend.html', auffuehrungen = auffuehrungen)
    else:
        msg = 'No Articles Found'
        return render_template('bevorstehend.html', msg=msg)

# Register Form Class
class RegisterForm(Form):
    username = StringField('Username', [validators.Length(min=4, max=25)])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    ])
    confirm = PasswordField('Confirm Password')

# User Register
@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm(request.form)
    if request.method == 'POST' and form.validate():
        username = request.form['username']
        password = pbkdf2_sha256.hash(request.form['password'])

        query = 'INSERT INTO users (username, password) VALUES(?,?);'

        try:
            insert_db(query, (username, password))
            flash('You are now registered and can log in', 'success')
            return redirect(url_for('login'))
        except: 
            flash('Error bei SQL Query','error')
            return redirect(url_for('register'))
    return render_template('register.html', form=form)


# User login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Get Form Fields
        username = request.form['username']
        password_candidate = request.form['password']

        result = query_db("SELECT * FROM users WHERE username = ?", (username,), one=True)
        if result:
            # Get stored hash
            password = result['password']
            # Compare Passwords
            if pbkdf2_sha256.verify(password_candidate, password):
                # Passed
                session['logged_in'] = True
                session['username'] = username

                flash('You are now logged in', 'success')
                return redirect(url_for('index'))
            else:
                error = 'Invalid login'
                return render_template('login.html', error=error)
        else:
            error = 'Username not found'
            return render_template('login.html', error=error)

    return render_template('login.html')

# Check if user logged in
def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash('Unauthorized, Please login', 'danger')
            return redirect(url_for('login'))
    return wrap

# Logout
@app.route('/logout')
@is_logged_in
def logout():
    session.clear()
    flash('You are now logged out', 'success')
    return redirect(url_for('login'))


if __name__ == "__main__":
    app.secret_key="key123"
    app.run(debug=True)

