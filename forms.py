from wtforms import Form, StringField, TextAreaField, PasswordField, validators, IntegerField, DateField, TimeField, SelectField
import sqlite3 
class SearchForm(Form):
    name = StringField('Titel/Name der Aufführung', [validators.Length(min=0, max=30)])
    datum = DateField('Datum (YYYY-MM-DD)')
    dirigent = StringField('Dirigent', [validators.Length(min=0, max=30)])
    saenger = StringField('Sänger', [validators.Length(min=0, max=30)])

# Register Form Class
class RegisterForm(Form):
    username = StringField('Username', [validators.Length(min=0, max=25)])
    soznr = StringField('SozNr (10 stellig)')
    vorname = StringField('Vorname', [validators.Length(min=0, max=25)])
    nachname = StringField('Nachname', [validators.Length(min=0, max=25)])
    ort = StringField('Ort', [validators.Length(min=0, max=25)])
    adresse = StringField('Addresse', [validators.Length(min=0, max=25)])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    ])
    confirm = PasswordField('Confirm Password')

# Buchung/reservieren Formular
class ReservierungsFormular(Form):
    choices = [('Zauberflöte', 'Zauberflöte'),('La Bohème', 'La Bohème'),('Aida', 'Aida')]
    name = SelectField('Titel/Name der Aufführung', choices = choices)
    datum = DateField('Datum (YYYY-MM-DD)')
    uhrzeit = TimeField('Uhrzeit (HH:MM)')

