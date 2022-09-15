import psycopg2
from py_linq import Enumerable
from psycopg2.extras import DictConnection, DictCursor


connect = psycopg2.connect(
    dbname="postgres",
    user="user",
    password="",
    host="localhost",
    connection_factory=DictConnection,
    cursor_factory=DictCursor
)


def query1_1():
    query = "select department " \
            "from (" \
            "   select department, count(id) as c " \
            "   from rk3.students " \
            "   where teacher_id is null " \
            "   group by department " \
            ") as dc " \
            "order by c desc " \
            "limit 1"

    cursor = connect.cursor(cursor_factory=DictCursor)
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()

    return result


def query1_2():
    cursor = connect.cursor(cursor_factory=DictCursor)
    cursor.execute("select * from rk3.students")

    filtered = Enumerable(cursor.fetchall()) \
        .where(lambda s: s["teacher_id"] is None).to_list()

    departments_freq = {}
    for student in filtered:
        if student["department"] in departments_freq:
            departments_freq[student["department"]] += 1
        else:
            departments_freq[student["department"]] = 1

    return departments_freq.items().sort(key=lambda x: x[1])[-1] if departments_freq.items() else []


def query2_1():
    query = "select rk3.students.* " \
            "from rk3.students " \
            "join rk3.teachers on teacher_id = teachers.id " \
            "where teachers.name = 'Рудаков Игорь Владимирович' " \
            "and extract(year from birthday) = 1990"

    cursor = connect.cursor(cursor_factory=DictCursor)
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()

    return result


def query2_2():
    query = "select * from rk3.students"
    cursor = connect.cursor(cursor_factory=DictCursor)
    cursor.execute(query)
    students = cursor.fetchall()

    query = "select * from rk3.teachers"
    cursor.execute(query)
    teachers = cursor.fetchall()
    cursor.close()

    return Enumerable(students) \
        .join(Enumerable(teachers),
              lambda s: s['teacher_id'],
              lambda t: t['id'],
              lambda r: r) \
        .where(lambda r: r[1]['name'] == 'Рудаков Игорь Владимирович') \
        .where(lambda r: r[0]['birthday'].year == 1990) \
        .select(lambda r: r[0])


def query3_1():
    query = "select rk3.teachers.* " \
            "from rk3.teachers " \
            "where department = 'Л' and max_students = (" \
            "   select count(*)" \
            "   from students" \
            "   where teacher_id = rk3.teachers.id" \
            ")"

    cursor = connect.cursor(cursor_factory=DictCursor)
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()

    return result


def query3_2():
    def count_students(studs, tid):
        return Enumerable(studs).where(lambda s: s['teacher_id'] == tid).count()

    query = "select * from rk3.students"
    cursor = connect.cursor(cursor_factory=DictCursor)
    cursor.execute(query)
    students = cursor.fetchall()

    query = "select * from rk3.teachers"
    cursor.execute(query)
    teachers = cursor.fetchall()
    cursor.close()

    return Enumerable(teachers) \
        .where(lambda t: t['department'] == 'Л') \
        .where(lambda t: t['max_students'] == count_students(students, t['id'])) \
        .to_list()


def main():
    print(query1_1())
    print(query1_2())
    print(query2_1())
    print(query2_2())
    print(query3_1())
    print(query3_2())


if __name__ == "__main__":
    main()
