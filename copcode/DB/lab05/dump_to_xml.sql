COPY (SELECT table_to_xml('fs.groups', false, false, '')) to '/home/user/bmstu/DB/lab05/user_fs_groups.xml';
COPY (SELECT table_to_xml('fs.inodes', true, false, '')) to '/home/user/bmstu/DB/lab05/user_fs_inodes.xml';
COPY (SELECT table_to_xml('fs.types', true, false, '')) to '/home/user/bmstu/DB/lab05/user_fs_types.xml';
COPY (SELECT table_to_xml('fs.users', true, false, '')) to '/home/user/bmstu/DB/lab05/user_fs_users.xml';
COPY (SELECT table_to_xml('fs.users_groups', true, false, '')) to '/home/user/bmstu/DB/lab05/user_fs_users_groups.xml';

COPY (SELECT ROW_TO_JSON(t) FROM (SELECT * FROM fs.groups) t)  to '/home/user/bmstu/DB/lab05/user_fs_groups.json';
COPY (SELECT ROW_TO_JSON(t) FROM (SELECT * FROM fs.inodes) t) to '/home/user/bmstu/DB/lab05/user_fs_inodes.json';
COPY (SELECT ROW_TO_JSON(t) FROM (SELECT * FROM fs.types) t) to '/home/user/bmstu/DB/lab05/user_fs_types.json';
COPY (SELECT ROW_TO_JSON(t) FROM (SELECT * FROM fs.users) t) to '/home/user/bmstu/DB/lab05/user_fs_users.json';
COPY (SELECT ROW_TO_JSON(t) FROM (SELECT * FROM fs.users_groups) t) to '/home/user/bmstu/DB/lab05/user_fs_users_groups.json';
