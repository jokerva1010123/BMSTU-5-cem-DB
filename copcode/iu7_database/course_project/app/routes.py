from flask import render_template, flash, redirect, session, url_for, request, g, jsonify, make_response, json
from flask_login import login_user, logout_user, current_user, login_required
from werkzeug.urls import url_parse
from werkzeug.utils import secure_filename
from app import app, db
from .forms import LoginForm, RegistrationForm, EditProfileForm, ResetPasswordRequestForm, ResetPasswordForm, AddBookForm, SearchForm, ChangeForm
from .models import User, Book, Location, Status
from .email import send_password_reset_email
from datetime import datetime
import sqlite3
import base64

# привязка адресов к функции
@app.route('/')
@app.route('/index', methods = ['GET', 'POST'])
#@login_required  # декоратор, показывающий, что функция защищенная от невошедших пользователей
def index():
    page = request.args.get('page', 1, type=int)
    books = Book.query.order_by(Book.author).paginate(page, app.config['BOOKS_PER_PAGE'], False)
    next_url = url_for('explore', page = books.next_num) if books.has_next else None
    prev_url = url_for('explore', page = books.prev_num) if books.has_prev else None
    return render_template('index.html', title='Explore', books=books.items, next_url=next_url, prev_url=prev_url)


@app.route('/login', methods = ['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is None or not user.check_password(form.password.data):
            flash('Неверное имя пользователя или пароль.')
            return redirect(url_for('login'))
        login_user(user, remember=form.rememberMe.data)
        next_page = request.args.get('next')
        if not next_page or url_parse(next_page).netloc != '':
            next_page = url_for('index')
        return redirect(next_page)
    return render_template('login.html', title = 'SignIn', form = form)


@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/register', methods = ['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = RegistrationForm()
    if form.validate_on_submit():
        user = User(username = form.username.data, email = form.email.data)
        user.set_password(form.password.data)
        db.session.add(user)
        db.session.commit()
        flash('Поздравляем, теперь вы являетесь зарегистрированным пользователем!')
        return redirect(url_for('login'))
    return render_template('register.html', title = 'Register', form = form)


@app.route('/add_book', methods=['GET', 'POST'])
@login_required
def add_book():
    form = AddBookForm()
    image_string = None
    if form.validate_on_submit():
        result = (form.image.data and form.image.data.read())
        if result:
            image_string = str(base64.b64encode(result))
            image_string = image_string[2:-1]

        book = Book(title=form.title.data, about_book=form.about_book.data,
                    author=form.author.data, image=image_string)
        conn = sqlite3.connect("app.db")
        cursor = conn.cursor()
        cursor.execute("select max(id) from book")
        res1 = cursor.fetchone()
        conn.close()

        location = Location(book_id=res1[0]+1,shelving=form.shelving.data,
                            shelf=form.shelf.data, column=form.column.data,
                            position=form.position.data)
        db.session.add(book)
        db.session.add(location)
        db.session.commit()
        flash('Поздравляем, новая книга добавлена!')
        return redirect(url_for('index'))
    return render_template('add_book.html', title='Add Book', form=form)


@app.route('/change_location/<bookid>', methods=['GET', 'POST'])
@login_required
def change_location():
    locate = ChangeForm()
    if locate.validate_on_submit():
        Location.update_location(locate.shelving.data, locate.shelf.data, locate.column.data, locate.position.data, bookid)
        return render_template('book.html', locate=locate)
    return render_template('book.html', locate=locate)



@app.route('/search', methods=['POST', 'GET'])
#@login_required
def search():
    r = request.args.get('q', type=str)
    f = request.args.get('search[field]')

    search = "%{}%".format(r)

    if f == "title":
        res = Book.search_title(search)
    elif f == "author":
        res = Book.search_author(search)
    else:
        res = Book.no_search(search)

    books = []
    for b in res:
        books.append({'id':b[0], 'title': b[1], 'author': b[2], 'image': b[3]})

    return render_template('search.html', title="Search", books=books)


@app.route('/user/<username>')
@login_required
def user(username):
    user = User.query.filter_by(username=username).first_or_404()
    page = request.args.get('page', 1, type=int)
    book = user.get_books()

    books = []
    for b in book:
        books.append({'author': b[0], 'title': b[1], 'image': b[3], 'id': b[4]})
    return render_template('user.html', user=user, books=books)


@app.before_request
def before_request():
    if current_user.is_authenticated:
        current_user.last_seen = datetime.utcnow()
        db.session.commit()


@app.route('/edit_profile', methods=['GET', 'POST'])
@login_required
def edit_profile():
    form = EditProfileForm(current_user.username)
    if form.validate_on_submit():
        # копируем данные из формы в объект пользователя
        # и записываем объект в бд
        current_user.username = form.username.data
        current_user.about_me = form.about_me.data
        db.session.commit()
        flash('Your changes have been saved.')
        return render_template('edit_profile.html', title='Edit Profile', form=form)
    elif request.method == 'GET':
        # отображаем значения, которые хранятся в бд
        form.username.data = current_user.username
        form.about_me.data = current_user.about_me
    return render_template('edit_profile.html', title='Edit Profile', form=form)


@app.route('/explore', methods=['GET', 'POST'])
#@login_required
def explore():
    page = request.args.get('page', 1, type=int)

    books = Book.query.order_by(Book.author).paginate(page, app.config['BOOKS_PER_PAGE'], False)

    next_url = url_for('explore', page = books.next_num) if books.has_next else None
    prev_url = url_for('explore', page = books.prev_num) if books.has_prev else None
    return render_template('index.html', title='Explore', books=books.items, next_url=next_url, prev_url=prev_url)


@app.route('/reset_password_request', methods=['GET', 'POST'])
def reset_password_request():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = ResetPasswordRequestForm()
    if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()
        if user:
            send_password_reset_email(user)
        flash("Check your email for the instructions to reset your password")
        return redirect(url_for('login'))
    return render_template('reset_password_request.html', title='Reset Password', form=form)


@app.route('/reset_password/<token>', methods=['GET', 'POST'])
def reset_password(token):
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    user = User.verify_reset_password_token(token)
    if not user:
        return redirect(url_for('index'))
    form = ResetPasswordForm()
    if form.validate_on_submit():
        user.set_password(form.password.data)
        db.session.commit()
        flash('Ypor password has been reset.')
        return resirect(url_for('login'))
    return render_template('reset_password.html', form=form)


@app.route('/book/<username>/<bookid>', methods=['GET', 'POST'])
@login_required
def book(username, bookid):
    locate = ChangeForm()
    if locate.validate_on_submit():
        Location.update_location(locate.shelving.data, locate.shelf.data, locate.column.data, locate.position.data, bookid)
    res = Book.other_books_author(bookid)

    res1 = Book.get_status_book(bookid)

    if res1 == None:
        book = {'title': res[0][4], 'author': res[0][5], 'about_book':res[0][6], 'image': res[0][7], 'shelving': res[0][8], 'shelf': res[0][9], 'column': res[0][10], 'position': res[0][11], 'book_id': res[0][12], 'status': 0}
    else:
        book = {'title': res[0][4], 'author': res[0][5], 'about_book':res[0][6], 'image': res[0][7], 'shelving': res[0][8], 'shelf': res[0][9], 'column': res[0][10], 'position': res[0][11], 'book_id': res[0][12], 'status': res1[0]}

    books = []
    for b in res:
        books.append({'id':b[0], 'title': b[1], 'author': b[2], 'image': b[3]})

    return render_template('book.html', book=book, books=books, locate=locate)


@app.route('/set_status', methods=["PUT", "OPTIONS"])
@login_required
def set_status():
    r = request.json['info']
    status = r["status"]
    username = current_user.username
    book_id = r["book_id"]

    if status == 2:
        res = Status.check_status_equal_two(book_id)
        if res != None:
            print(res[1])
            return make_response(jsonify({"Ratatoskr": "occupied", "username": res[1]}))

    Status.set_status(status, book_id, username)

    return make_response(jsonify({"Ratatoskr": status}), 200)


@app.route('/set_join_user_book', methods=["POST", "OPTIONS"])
@login_required
def set_join_user_book():
    r = request.json['info']
    status = r["status"]
    book_id = r["book_id"]

    if status == 2:
        res = Status.check_status_equal_two(book_id)
        if res != None:
            print(res[1])
            return make_response(jsonify({"Ratatoskr": "occupied", "username": res[1]}))
    Status.join_book(book_id, status)

    return make_response(jsonify({"Ratatoskr": status}), 200)


@app.route('/delete_status', methods=["DELETE", "OPTIONS"])
@login_required
def delete_status():
    r = request.json["info"]
    book_id = r["book_id"]

    Status.delete_status(book_id)

    return make_response(jsonify({"Ratatoskr": "OK"}))


@app.route('/check_status_equal_two', methods=["POST", "OPTIONS"])
@login_required
def check_status_equal_two():
    book_id = request.json["book_id"]

    res = Status.check_status_equal_two(book_id)
    if res != None:
        print(res[1])
        return make_response(jsonify({"Ratatoskr": "occupied", "username": res[1]}))
    return make_response(jsonify({"Ratatoskr": "OK"}), 200)

@app.route('/check_all_status_equal_two', methods=["GET", "OPTIONS"])
@login_required
def check_status_all_equal_two():
    #book_id = request.json["book_id"]

    res = Status.check_all_status_equal_two()
    status = []
    for s in res:
        status.append({'status':s[0], 'username': s[1], 'book_id': s[2]})
    return make_response(jsonify({"Ratatoskr": status}), 200)

@app.route('/delete_book', methods=["DELETE", "OPTIONS"])
@login_required
def delete_book():
    r = request.json["info"]
    book_id = r["book_id"]

    Book.delete_book(book_id)

    return make_response(jsonify({"Ratatoskr": "OK"}), 200)
