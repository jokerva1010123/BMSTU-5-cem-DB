import faker

fake = faker.Faker()


def random(x):
    return int(fake.random.random() * x)


def directory_size():
    return 4096


def regular_file_size():
    return random(65536)


header = {
    'types': ('id', 'name', 'shortcut'),
    'groups': ('id', 'name'),
    'users': ('id', 'name'),
    'users_groups': ('id', 'user', 'group'),
    'inodes': ('inode', 'name', 'size', 'parent_inode', 'type_id', 'owner_id', 'group_id'),
}

types = [
    # (name, shortcut)
    ('regular file', '-'),
    ('directory', 'd'),
    ('link', 'l'),
]

groups = [
    # (name)
    ('root',),
]

users = [
    # (name)
    ('root',),
]

users_groups = [
    # (user, group)
    (0, 0),
]

inodes = [
    # (name, size, parent, type, owner, group)
    ('root', directory_size(), '', 1, 0, 0),
]


def create_groups(n):
    for i in range(n):
        groups.append((fake.word(),))


def create_users(n):
    for i in range(n):
        user = len(users)
        users.append((fake.word(),))
        for group in fake.random.sample(range(len(groups)), random(3) + 1):
            users_groups.append((user, group))


def create_inodes(n_inodes, parent, name_faker, size_faker, file_type):
    for inode in range(n_inodes):
        name = name_faker()
        size = size_faker()
        owner = random(len(users))
        group = random(len(groups))

        inodes.append((name, size, parent, file_type, owner, group))


def create_directories(n_inodes, parent):
    create_inodes(n_inodes, parent, fake.word, directory_size, 1)


def create_regular_files(n_inodes, parent):
    create_inodes(n_inodes, parent, fake.file_name, regular_file_size, 0)


def write_csv(name, table):
    with open(name + '.csv', 'w') as file:
        file.write(','.join(header[name]) + '\n')
        for i in range(len(table)):
            file.write(str(i) + ',' + ','.join(map(str, table[i])) + '\n')


def main():
    create_groups(1000)
    create_users(1000)

    create_directories(10, 0)
    for i in range(1, 11):
        create_directories(10, i)

    # created 110 dirs

    for i in range(111):
        create_regular_files(10, i)

    write_csv('types', types)
    write_csv('users', users)
    write_csv('groups', groups)
    write_csv('users_groups', users_groups)
    write_csv('inodes', inodes)


if __name__ == '__main__':
    main()
