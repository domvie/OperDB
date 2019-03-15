import os, sys, sqlite3
from flask import Flask, render_template, flash, url_for, session, request, logging, g, redirect
from wtforms import Form, StringField, TextAreaField, PasswordField, validators, IntegerField
from passlib.hash import sha256_crypt
from functools import wraps
from flask_debugtoolbar import DebugToolbarExtension

''' Hauptseite - wird angezeigt, wenn man auf 127.0.0.1:5000 bzw localhost:5000 geht (vorher ausführen) '''

"""Create and configure an instance of the Flask application."""
app = Flask(__name__)
app.debug=True
app.secret_key="key123"
toolbar = DebugToolbarExtension(app)

DATABASE = 'Oper.db'

# Hilfestellung bzw. Quelle der Funktionen: http://flask.pocoo.org/docs/1.0/patterns/sqlite3/
# Alternativ gehts so https://www.tutorialspoint.com/flask/flask_sqlite.htm aber wills lieber mal auf diesem Web probieren

# Funktion baut Verbindung zur DB auf und returned db Objekt
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

#Funktion um eine query durchzuführen, returned Ergebnisliste
def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

# Initialisiert die DB mit dem Schema
def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
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
        print("not true")
        init_db()
    else:
        print("Using existing database: " + DATABASE)
        
def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value)
                for idx, value in enumerate(row))

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
    return render_template('bevorstehend.html')


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
        username = form.username.data
        password = sha256_crypt.encrypt(str(form.password.data))

        ''' Hier gibt es irgendwie noch Probleme. Mit dem aktuellen kommt zumindest keine Fehlermeldung
        aber irgendwie schreibt er keine Daten in die Tabelle users (ist nur zum Testen, gehört nicht zum Oper Schema)'''
        #query = 'INSERT INTO users(username, password) VALUES("{}","{}")'.format(username,password)
        #query = 'INSERT INTO users(username, password) VALUES("?","?")'
        query = 'INSERT INTO users(username, password) VALUES(?,?)'
        query_db(query, (username, password))

        flash('You are now registered and can log in', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', form=form)


# User login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Get Form Fields
        username = request.form['username']
        password_candidate = request.form['password']

        # Create cursor
        #cur = db.cursor()
        # Get user by username
        #result = cur.execute("SELECT * FROM users WHERE username = %s", [username])
        
        result = query_db("SELECT * FROM users WHERE username = ?", username)
    #FUNKTIONIERT NOCH NICHT
        if result:
            # Get stored hash
            #data = cur.fetchone()
            password = result['password']
            flash(result)
            # Compare Passwords
            if sha256_crypt.verify(password_candidate, password):
                # Passed
                session['logged_in'] = True
                session['username'] = username

                flash('You are now logged in', 'success')
                return redirect(url_for('dashboard'))
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


# apply the blueprints to the app
#import auth, blog
#app.register_blueprint(auth.bp)
#app.register_blueprint(blog.bp)

if __name__ == "__main__":
    app.secret_key="key123"
    app.run(debug=True)

