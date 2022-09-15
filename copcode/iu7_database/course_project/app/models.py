from datetime import datetime
from app import db, login, app
from flask_login import UserMixin, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from hashlib import md5
from sqlalchemy import PrimaryKeyConstraint
import sqlite3
from time import time
import jwt
import sys
#import flask_whooshalchemyplus as whooshalchemy


class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key = True)
    username = db.Column(db.String(64), index = True, unique = True)
    email = db.Column(db.String(128), index = True, unique = True)
    password_hash = db.Column(db.String(128))
    about_me = db.Column(db.String(150))
    last_seen = db.Column(db.DateTime, default = datetime.utcnow)
    image = db.Column(db.Text)

    book = db.relationship('Book', secondary='status', backref='users', lazy='dynamic')

    def __repr__(self):
        return '<User {}>'.format(self.username)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def avatar(self, size):
        digest = md5(self.email.lower().encode('utf-8')).hexdigest()
        return 'http://www.gravatar.com/avatar/{}?d=identicon&s={}'.format(digest, size)

    def get_reset_password_token(self, expires_in=600):
        return jwt.encode({'reset_password': self.id, 'exp': time() + expires_in},
                            app.config['SECRET_KEY'], algorithm='HS256').decode('utf-8')

    def get_book(id):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select title, author, image from book where id = %d", id)
        res = cursor.fetchall()
        conn.close()
        return res

    def get_books(self):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select author, title, username, book.image, book.id from (user left outer join status on user.id == status.user_id) as us \
                    join book on us.book_id == book.id \
                    where us.id = (?)", (current_user.id, ))
        res = cursor.fetchall()
        conn.close()
        return res

    def get_books_count(self):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select count(book.id) from (user left outer join status on user.id == status.user_id) as us \
                    join book on us.book_id == book.id\
                    where us.id = (?)", (current_user.id, ))
        res = cursor.fetchall()
        conn.close()
        return res[0][0]

    @staticmethod
    def verify_reset_password_token(token):
        try:
            id = jwt.decode(token, app.config['SECRET_KEY'], algorithm=['HS256'])['reset_password']
        except:
            return
        return User.query.get(id)


@login.user_loader
def load_user(id):
    return User.query.get(int(id))

class Book(db.Model):
    #__searchable__ = ['title']
    id = db.Column(db.Integer, primary_key = True)
    title = db.Column(db.String(60), index = True)
    about_book = db.Column(db.String(150))
    author = db.Column(db.String(60), index = True)
    location = db.relationship('Location', uselist=False, backref='books')
    image = db.Column(db.Text)

    user = db.relationship(
        'User', secondary='status',
        backref='books', lazy='dynamic')

    def __repr__(self):
        return '<Book {}>'.format(self.image)

    def get_book(self, id):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select title, author, image from book where id = %d", id)
        res = cursor.fetchall()
        conn.close()
        return res

    def search_title(search):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select id, title, author, image from book where title like (?) ", (search, ))
        res = cursor.fetchall()
        conn.close()
        return res

    def search_author(search):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select id, title, author, image from book where author like (?) ", (search, ))
        res = cursor.fetchall()
        conn.close()
        return res

    def no_search(search):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select id, title, author, image from book where author like (?) or title like (?)", (search, search))
        res = cursor.fetchall()
        conn.close()
        return res

    def other_books_author(bookid):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select book.id, book.title, book.author, book.image, B.title, B.author, B.about_book, B.image, B.shelving, B.shelf, B.column, B.position, B.id " +
                        "from ( " +
                            "select book.id, title, author, about_book, image, shelving, shelf, column, position " +
                            "from book left join location on book.id = location.book_id  where book.id = (?) " +
                            ") as B left join book on book.author = B.author and B.id != book.id;", (bookid, ))
        res = cursor.fetchall()
        conn.close()
        return res

    def get_status_book(bookid):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select status " +
                        "from ( " +
                            "select username, book.id, status " +
                            "from (user join status on user.id == status.user_id) as us " +
                            "join book on us.book_id == book.id " +
                            "where user.id = (?)  " +
                            ") as res where res.id = (?)", (current_user.id, bookid))
        res = cursor.fetchone()
        conn.close()
        return res

    def delete_book(book_id):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("delete from status where user_id = (?) and book_id = (?)", (current_user.id, book_id))
        conn.commit()
        cursor.execute("delete from location where book_id = (?)", (book_id, ))
        conn.commit()
        cursor.execute("delete from book where id = (?)", (book_id, ))
        conn.commit()
        conn.close()


class Status(db.Model):
    __tablename__ = 'status'
    __table_args__ = (
        PrimaryKeyConstraint('user_id', 'book_id'),
    )

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'))
    status = db.Column(db.Integer)

    # функция, которая проверяет есть ли такое, что у какого-то пользователя статус с этой книгой = 2 (в процессе чтения)
    def check_status_equal_two(book_id):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select S.status, username \
                        from ( \
                                select status, user_id \
                                from status \
                                where book_id = (?) and status = 2 \
                            ) as S join user on S.user_id = user.id \
                             where id != (?);", (book_id, current_user.id)) # если занята книга не текущим пользователям
        res = cursor.fetchone()
        conn.close()
        return res


    def check_all_status_equal_two():
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select S.status, username, S.book_id \
                        from ( \
                            select status, user_id, book_id \
                            from status \
                            where status = 2 \
                            ) as S join user on S.user_id = user.id;") # если занята книга не текущим пользователям
        res = cursor.fetchall()
        conn.close()
        return res


    def set_status(status, book_id, username):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("update status set status = (?) " +
                       "where book_id = (?) and user_id = (?)", (status, book_id, current_user.id))
        conn.commit()
        conn.close()


    def join_book(book_id, status):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("INSERT INTO status VALUES ((?), (?), (?))", (current_user.id, book_id, status))
        conn.commit()
        conn.close()

    def delete_status(book_id):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("delete from status where user_id = (?) and book_id = (?)", (current_user.id, book_id))
        conn.commit()
        conn.close()


class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    shelving = db.Column(db.Integer, index=True)
    shelf = db.Column(db.Integer, index=True)
    column = db.Column(db.Integer, index=True)
    position = db.Column(db.Integer, index=True)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'))

    def update_location(shelving, shelf, column, position, bookid):
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("UPDATE location SET shelving = (?), shelf = (?), column = (?), position = (?) WHERE id = (?)", (shelving,
                                                                                                            shelf,
                                                                                                            column,
                                                                                                            position,
                                                                                                            bookid))
        conn.commit()
        conn.close()
