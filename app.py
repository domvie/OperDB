#!/usr/bin/env python3

from flask import Flask, render_template, flash, url_for, session, request, logging, redirect
from passlib.hash import sha256_crypt, pbkdf2_sha256
from functools import wraps
from datetime import datetime, time
from db import get_db, init_db, query_db, insert_db, close_connection, CheckIfDbExists, insert_dummies
import random, sqlite3

''' Hauptseite - wird angezeigt, wenn man auf 127.0.0.1:5000 bzw localhost:5000 geht (vorher ausführen) '''

"""Erstellt eine Flask-App"""
app = Flask(__name__)
app.debug=True
app.secret_key="key123"
DATABASE = 'Oper.db'

# Hilfestellung bzw. Quelle der Funktionen: http://flask.pocoo.org/docs/1.0/patterns/sqlite3/
# Alternativ gehts so https://www.tutorialspoint.com/flask/flask_sqlite.htm aber wills lieber mal auf diesem Web probieren

# DB erstellen nach Schema und mit Dummys befüllen, falls sie noch nicht existiert:
CheckIfDbExists()

#Anschließend import der Formularklassen da diese auf DB zugreifen
from forms import RegisterForm, SearchForm, ReservierungsFormular

@app.route('/')
def index():
    return render_template('home.html')

#Suchfunktion
@app.route('/suche', methods=['GET', 'POST'])
def suche():
    form = SearchForm(request.form)
    if request.method == 'POST':
        results = []
        if request.form['name']:
            name = request.form['name']
            results += query_db("SELECT * FROM Aufführung_von WHERE Name LIKE ?", (name,))
        elif request.form['dirigent']:
            dirigent = request.form['dirigent']
            results += query_db("SELECT * FROM Aufführung_von WHERE Dirigent LIKE ?", (dirigent,))
        elif request.form['datum']:
            datum = request.form['datum']
            results += query_db("SELECT * FROM Aufführung_von WHERE Datum LIKE ?", (datum,))
        return render_template("ergebnisse.html", results = results)
    
    return render_template("suche.html", form=form)

#Zeigt alle angelegten Personen an
@app.route('/allusers')
def allusers():

    users = query_db("SELECT * FROM users NATURAL JOIN Person")
    angestellte = query_db("SELECT * FROM Angestellte_hat_Gehaltskonto NATURAL JOIN Person")
    besucher = query_db("SELECT * FROM Besucher NATURAL JOIN Person")
    saenger = query_db("SELECT * FROM Sänger NATURAL JOIN Person")
    if users or angestellte or besucher or saenger:
        return render_template('allusers.html', users = users, angestellte=angestellte, besucher=besucher, saenger=saenger)
    else:
        msg = 'No Persons found. DB empty?'
        return render_template('allusers.html', msg=msg)

#Anzeigen der bevorstehenden Aufführungen
@app.route('/bevorstehend')
@app.route('/bevorstehend/<string:Name>')
def bevorstehend(Name=None):

    if Name is None:
        auffuehrungen = query_db("SELECT * FROM Aufführung_von WHERE Datum > DATE('now')")
        if auffuehrungen:
            return render_template('bevorstehend.html', auffuehrungen = auffuehrungen)
        else:
            msg = 'No Articles Found'
            return render_template('bevorstehend.html', msg=msg)
    else:
        auffuehrungen = query_db("SELECT * FROM Aufführung_von WHERE Name = ? AND Datum > DATE('now')", (Name,))
        return render_template('bevorstehend.html', auffuehrungen=auffuehrungen)

# User Register
@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm(request.form)
    if request.method == 'POST' and form.validate():
        username = request.form['username']
        vorname = request.form['vorname']
        nachname = request.form['nachname']
        soznr = request.form['soznr']
        ort = request.form['ort']
        adresse = request.form['adresse']
        password = pbkdf2_sha256.hash(request.form['password'])

        query = 'INSERT INTO users (username, password, SozNr) VALUES(?,?,?);'
        query_person = 'INSERT INTO Person (SozNr, Vorname, Nachname, Ort, Adresse) VALUES(?,?,?,?,?);'
        try:
            insert_db(query, (username, password, soznr))
            insert_db(query_person, (soznr, vorname, nachname, ort, adresse))
            flash('Vielen Dank für die Registrierung! Sie sind nun angelegt und können sich mit Username & Passwort einloggen.', 'success')
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
            soznr = result['SozNr']
            # Compare Passwords
            if pbkdf2_sha256.verify(password_candidate, password):
                # Passed
                session['logged_in'] = True
                session['username'] = username
                session['soznr'] = soznr

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

# Aufführung buchen
@app.route('/buchung', methods=['GET', 'POST'])
@app.route('/buchung/<string:Datum>', methods=['GET', 'POST'])
@is_logged_in
def buchung(Datum=None):

    form = ReservierungsFormular(request.form)
    # Falls man nicht weitergeleitet wurde von "bevorstehend.html"
    if Datum is None:
        if request.method == 'POST' and form.validate():
            name = request.form['name']
            datum = request.form['datum']
            uhrzeit = request.form['uhrzeit']
            soznr = session['soznr']
            resnr = random.randint(10000,99999)
            sitzplatz = "A" + str(random.randint(1,100))

            result = query_db("SELECT * FROM Aufführung_von WHERE (Datum, Uhrzeit, Name) = (?,?,?) AND Datum > DATE('now') ",(datum,uhrzeit,name))
            if result:
                try:
                    insert_db("INSERT INTO reservieren(SozNr, Reservierungsnummer, Datum, Uhrzeit, Sitzplatz) VALUES (?,?,?,?,?)", (soznr, resnr, datum, uhrzeit, sitzplatz))
                    flash('Buchung erfolgreich!')
                except:
                    flash('Fehler bei der Buchung! Datum & Uhrzeit richtig?')
                    return redirect(url_for('buchung'))
            else:
                flash('Aufführung existiert nicht! Bitte richtiges Datum & Uhrzeit wählen.')
                return redirect(url_for('buchung'))
        return render_template('buchung.html', form=form)
    
    # Falls man weitergeleitet wurde von "bevorstehend.html", Formulardaten ausfüllen
    else:
        # Buchung ausfüllen
        try:
            auffuehrung = query_db("SELECT * FROM Aufführung_von WHERE Datum = ?", (Datum,), one=True)
        except:
            flash('query error')
        form.name.data = auffuehrung['Name']
        form.datum.data = datetime.strptime(auffuehrung['Datum'], '%Y-%m-%d')
        form.uhrzeit.data = datetime.strptime(auffuehrung['Uhrzeit'], '%H:%M')

        if request.method == 'POST' and form.validate():
            name = request.form['name']
            datum = request.form['datum']
            uhrzeit = request.form['uhrzeit']
            soznr = session['soznr']
            resnr = random.randint(10000,99999)
            sitzplatz = "A" + str(random.randint(1,100))

            result = query_db("SELECT * FROM Aufführung_von WHERE (Datum, Uhrzeit, Name) = (?,?,?) AND Datum > DATE('now') ",(datum,uhrzeit,name))
            if result:
                try:
                    insert_db("INSERT INTO reservieren(SozNr, Reservierungsnummer, Datum, Uhrzeit, Sitzplatz) VALUES (?,?,?,?,?)", (soznr, resnr, datum, uhrzeit, sitzplatz))
                    flash('Buchung erfolgreich!')
                except:
                    flash('Fehler bei der Buchung! Datum & Uhrzeit richtig?')
                    return redirect(url_for('buchung'))
            else:
                flash('Aufführung existiert nicht! Bitte richtiges Datum & Uhrzeit wählen.')
                return redirect(url_for('buchung'))
        return render_template('buchung.html', form=form)

#Eigene Buchungen anzeigen lassen (mit SozNr verbunden)
@app.route('/buchungen')
@is_logged_in
def buchungen():
    soznr = session['soznr']
    buchungen = query_db("SELECT * FROM reservieren r JOIN Aufführung_von a ON r.Datum = a.Datum AND r.Uhrzeit = a.Uhrzeit WHERE SozNr = ?", (soznr,))

    if buchungen:
        return render_template('buchungen.html', buchungen=buchungen)
    else:
        msg = 'Sie haben keine Buchungen'
        return render_template('buchungen.html', msg=msg)

# Buchung bearbeiten
@app.route('/edit_buchung/<string:Reservierungsnummer>', methods=['GET', 'POST'])
@is_logged_in
def edit_buchung(Reservierungsnummer):

    # Buchung per Resnr. bekommen
    buchung = query_db("SELECT * FROM reservieren r JOIN Aufführung_von a ON r.Datum = a.Datum AND r.Uhrzeit = a.Uhrzeit WHERE Reservierungsnummer = ?", (Reservierungsnummer,), one=True)

    form = ReservierungsFormular(request.form)

    # Felder vorbelegen mit alten Daten
    form.name.data = buchung['Name']
    form.datum.data = datetime.strptime(buchung['Datum'], '%Y-%m-%d')
    form.uhrzeit.data = datetime.strptime(buchung['Uhrzeit'], '%H:%M')
    form.sitzplatz.data = buchung['Sitzplatz']

    if request.method == 'POST' and form.validate():
        name = request.form['name']
        datum = request.form['datum']
        uhrzeit = request.form['uhrzeit']
        sitzplatz = request.form['sitzplatz']

        result = query_db("SELECT * FROM Aufführung_von WHERE (Datum, Uhrzeit, Name) = (?,?,?) AND Datum > DATE('now') ",(datum,uhrzeit,name))
        if result:
            insert_db("UPDATE reservieren SET Datum = ?, Uhrzeit = ?, Sitzplatz = ? WHERE Reservierungsnummer = ?", (datum, uhrzeit, sitzplatz, Reservierungsnummer))
            flash('Buchung geändert', 'success')
            return redirect(url_for('buchungen'))
        else:
            flash('Aufführung existiert nicht! Bitte Eingaben überprüfen.')
            return redirect(url_for('edit_buchung', Reservierungsnummer = Reservierungsnummer))

    return render_template('edit_buchung.html', form=form)

# Buchung löschen
@app.route('/delete_buchung/<string:Reservierungsnummer>', methods=['POST'])
@is_logged_in
def delete_buchung(Reservierungsnummer):

    # Löschen
    insert_db("DELETE FROM reservieren WHERE Reservierungsnummer = ?", (Reservierungsnummer,))

    flash('Reservierung gelöscht', 'success')

    return redirect(url_for('buchungen'))

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
