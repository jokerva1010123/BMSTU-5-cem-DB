from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField, TextField, TextAreaField, IntegerField, FileField
from wtforms.validators import ValidationError, DataRequired, Email, EqualTo, Length
from app.models import User, Location
import sqlite3

class LoginForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[DataRequired()])
    password = PasswordField('Пароль', validators=[DataRequired()])
    rememberMe = BooleanField('Запомни меня')
    submit = SubmitField('Войти')


class RegistrationForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Пароль', validators=[DataRequired()])
    password2 = PasswordField(
        'Повторите пароль', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Зарегистрироваться')

    def validate_username(self, username):
        user = User.query.filter_by(username=username.data).first()
        if user is not None:
            raise ValidationError('Пожалуйста, используйте другое имя пользователя.')

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user is not None:
            raise ValidationError('Пожалуйста, используйте другой email.')


class EditProfileForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[DataRequired()])
    about_me = TextAreaField('Обо мне', validators=[Length(min=0, max=150)])
    submit = SubmitField('Подтведить')

    def __init__(self, original_username, *args, **kwargs):
        super(EditProfileForm, self).__init__(*args, **kwargs)
        self.original_username = original_username

    def validate_username(self, username):
        if username.data != self.original_username:
            user = User.query.filter_by(username=self.username.data).first()
            if user is not None:
                raise ValidationError('Пожалуйста, используйте другое имя пользователя.')


class AddBookForm(FlaskForm):
    title = StringField('Название книги', validators=[DataRequired()])
    image = FileField("Обложка книги")
    about_book = TextAreaField('О книге', validators=[Length(min=0, max=300)])
    author = StringField('Автор', validators=[DataRequired()])
    # хз какие валидаторы использовать
    shelving = IntegerField('Стелаж', validators=[DataRequired()])
    shelf = IntegerField('Полка', validators=[DataRequired()])
    column = IntegerField('Ряд', validators=[DataRequired()])
    position = IntegerField('Позиция', validators=[DataRequired()])
    submit = SubmitField('Добавить')

    def validate_shelving(self, shelving):
        res = Location.query.filter_by(shelving=shelving.data, shelf=self.shelf.data, column=self.column.data, position=self.position.data).first()
        if res is not None:
            raise ValidationError('Пожалуйста, используйте другое место.')


class ChangeForm(FlaskForm):
    shelving = IntegerField('Стелаж', validators=[DataRequired()])
    shelf = IntegerField('Полка', validators=[DataRequired()])
    column = IntegerField('Ряд', validators=[DataRequired()])
    position = IntegerField('Позиция', validators=[DataRequired()])
    submit = SubmitField('Применить')

    def validate_shelving(self, shelving):
        res = Location.query.filter_by(shelving=shelving.data, shelf=self.shelf.data, column=self.column.data, position=self.position.data).first()
        if res is not None:
            raise ValidationError('Пожалуйста, используйте другое место.')


class SearchForm(FlaskForm):
    q = StringField('', validators=[DataRequired()])
    submit = SubmitField('Поиск')


class ResetPasswordRequestForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired(), Email()])
    submit = SubmitField('Request Password Reset')


class ResetPasswordForm(FlaskForm):
    password = PasswordField('Password', validators=[DataRequired()])
    password2 = PasswordField('Repeat Password', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Request Password Reset')
