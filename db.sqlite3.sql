BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "website_app" (
	"id"	integer NOT NULL,
	"app_name"	varchar(255) NOT NULL,
	"organization"	varchar(255) NOT NULL,
	"app_logo"	varchar(100) NOT NULL,
	"end_at"	datetime,
	"start_at"	datetime,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "website_voice" (
	"id"	integer NOT NULL,
	"candidate_id"	bigint NOT NULL,
	"voter_id"	bigint NOT NULL,
	"vote_at"	datetime,
	FOREIGN KEY("candidate_id") REFERENCES "website_candidate"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("voter_id") REFERENCES "website_voter"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "website_candidate" (
	"id"	integer NOT NULL,
	"code"	varchar(8) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"order"	integer NOT NULL,
	"photo"	varchar(100) NOT NULL,
	"vision"	text NOT NULL,
	"mission"	text NOT NULL,
	"division_id"	bigint,
	FOREIGN KEY("division_id") REFERENCES "website_division"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "website_division" (
	"id"	integer NOT NULL,
	"name"	varchar(255) NOT NULL,
	"code"	varchar(4),
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "website_admin" (
	"id"	integer NOT NULL,
	"name"	varchar(255) NOT NULL,
	"level"	varchar(20) NOT NULL,
	"user_id"	integer NOT NULL UNIQUE,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "website_voter" (
	"id"	integer NOT NULL,
	"name"	varchar(255) NOT NULL,
	"level"	varchar(20) NOT NULL,
	"is_vote"	bool NOT NULL,
	"auth"	varchar(10),
	"division_id"	bigint,
	"user_id"	integer NOT NULL UNIQUE,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("division_id") REFERENCES "website_division"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (1,'contenttypes','0001_initial','2023-01-07 04:12:48.474708');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (2,'auth','0001_initial','2023-01-07 04:12:48.544692');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (3,'admin','0001_initial','2023-01-07 04:12:48.580878');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (4,'admin','0002_logentry_remove_auto_add','2023-01-07 04:12:48.627884');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (5,'admin','0003_logentry_add_action_flag_choices','2023-01-07 04:12:48.671477');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (6,'contenttypes','0002_remove_content_type_name','2023-01-07 04:12:48.743502');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (7,'auth','0002_alter_permission_name_max_length','2023-01-07 04:12:48.781920');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (8,'auth','0003_alter_user_email_max_length','2023-01-07 04:12:48.822918');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (9,'auth','0004_alter_user_username_opts','2023-01-07 04:12:48.849909');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (10,'auth','0005_alter_user_last_login_null','2023-01-07 04:12:48.891504');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (11,'auth','0006_require_contenttypes_0002','2023-01-07 04:12:48.902504');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (12,'auth','0007_alter_validators_add_error_messages','2023-01-07 04:12:48.944495');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (13,'auth','0008_alter_user_username_max_length','2023-01-07 04:12:48.987094');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (14,'auth','0009_alter_user_last_name_max_length','2023-01-07 04:12:49.038101');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (15,'auth','0010_alter_group_name_max_length','2023-01-07 04:12:49.078695');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (16,'auth','0011_update_proxy_permissions','2023-01-07 04:12:49.110705');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (17,'auth','0012_alter_user_first_name_max_length','2023-01-07 04:12:49.154737');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (18,'sessions','0001_initial','2023-01-07 04:12:49.181316');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (19,'website','0001_initial','2023-01-07 04:12:49.302901');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (20,'website','0002_auto_20221231_1400','2023-01-07 04:12:49.356937');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (21,'website','0003_voter_auth','2023-01-07 04:12:49.405496');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (22,'website','0004_voice_vote_at','2023-01-07 04:12:49.455535');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (23,'website','0005_auto_20230107_1108','2023-01-07 04:12:49.515096');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (24,'website','0006_auto_20230107_1110','2023-01-07 04:12:49.614687');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (25,'website','0007_division_code','2023-01-07 04:46:13.476600');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (26,'website','0008_auto_20230111_1556','2023-01-11 08:56:49.523175');
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (1,'2023-01-07 04:13:37.536442','2','prayogisatya','[{"added": {}}]',4,1,1);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (2,'2023-01-07 04:13:41.107273','1','Prayogi Setiawan','[{"added": {}}]',11,1,1);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (3,'2023-01-07 04:14:24.188558','2','prayogisatya','',4,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (4,'2023-01-07 04:15:55.221674','1','EVote','',7,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (5,'2023-01-11 07:46:47.706989','1','Voice object (1)','[{"added": {}}]',10,1,1);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (6,'2023-01-11 07:50:51.207442','1','Voice object (1)','[]',10,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (7,'2023-01-11 07:51:00.185773','2','Voice object (2)','[{"added": {}}]',10,1,1);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (8,'2023-01-11 07:51:05.263422','3','Voice object (3)','[{"added": {}}]',10,1,1);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (9,'2023-01-11 08:19:57.131306','4','Voice object (4)','[{"added": {}}]',10,1,1);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (10,'2023-01-17 06:58:33.879796','7','Voice object (7)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (11,'2023-01-17 06:58:33.887214','6','Voice object (6)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (12,'2023-01-17 06:58:33.892106','5','Voice object (5)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (13,'2023-01-17 06:58:33.899112','4','Voice object (4)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (14,'2023-01-17 06:58:33.904028','3','Voice object (3)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (15,'2023-01-17 06:58:33.910050','2','Voice object (2)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (16,'2023-01-17 06:58:33.915055','1','Voice object (1)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (17,'2023-01-17 06:58:44.716626','100','Muhammad Arif Martadinata','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (18,'2023-01-17 06:58:48.005059','99','Erlin Widianingrum','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (19,'2023-01-17 06:58:51.672412','98','Muhammad Delphi Putra Firdaus','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (20,'2023-01-17 07:22:50.597207','14','Voice object (14)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (21,'2023-01-17 07:22:50.603214','13','Voice object (13)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (22,'2023-01-17 07:22:50.609742','12','Voice object (12)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (23,'2023-01-17 07:22:50.615745','11','Voice object (11)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (24,'2023-01-17 07:22:50.622043','10','Voice object (10)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (25,'2023-01-17 07:22:50.627544','9','Voice object (9)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (26,'2023-01-17 07:22:50.632550','8','Voice object (8)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (27,'2023-01-17 07:23:03.990191','100','Muhammad Arif Martadinata','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (28,'2023-01-17 07:23:06.951572','99','Erlin Widianingrum','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (29,'2023-01-17 07:23:10.471585','98','Muhammad Delphi Putra Firdaus','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (30,'2023-01-17 07:23:13.741109','97','Muhammda Endi','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (31,'2023-01-17 07:23:16.703760','96','Reviana Ageng Lara Wigati','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (32,'2023-01-17 07:23:19.383803','94','Restu Anggia Putra','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (33,'2023-01-17 07:23:22.454759','93','Prayogi Setiawan','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (34,'2023-01-18 05:27:10.870140','21','Voice object (21)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (35,'2023-01-18 05:27:10.875175','20','Voice object (20)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (36,'2023-01-18 05:27:10.879944','19','Voice object (19)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (37,'2023-01-18 05:27:10.884674','18','Voice object (18)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (38,'2023-01-18 05:27:10.889676','17','Voice object (17)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (39,'2023-01-18 05:27:10.896058','16','Voice object (16)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (40,'2023-01-18 05:27:10.900542','15','Voice object (15)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (41,'2023-01-18 05:27:16.711870','100','Muhammad Arif Martadinata','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (42,'2023-01-18 05:27:19.817328','99','Erlin Widianingrum','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (43,'2023-01-18 05:27:23.018528','98','Muhammad Delphi Putra Firdaus','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (44,'2023-01-18 05:27:25.920899','97','Muhammda Endi','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (45,'2023-01-18 05:27:28.698252','96','Reviana Ageng Lara Wigati','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (46,'2023-01-18 05:27:32.176152','94','Restu Anggia Putra','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (47,'2023-01-18 05:27:35.050306','93','Prayogi Setiawan','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (48,'2023-01-21 12:23:20.409392','29','Voice object (29)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (49,'2023-01-21 12:23:20.415714','28','Voice object (28)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (50,'2023-01-21 12:23:20.421242','27','Voice object (27)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (51,'2023-01-21 12:23:20.426275','26','Voice object (26)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (52,'2023-01-21 12:23:20.431798','25','Voice object (25)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (53,'2023-01-21 12:23:20.437818','24','Voice object (24)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (54,'2023-01-21 12:23:20.443373','23','Voice object (23)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (55,'2023-01-21 12:23:20.450378','22','Voice object (22)','',10,1,3);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (56,'2023-01-21 12:23:28.597026','101','Fahri Febrian','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (57,'2023-01-21 12:23:31.380735','100','Muhammad Arif Martadinata','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (58,'2023-01-21 12:23:34.902360','99','Erlin Widianingrum','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (59,'2023-01-21 12:23:38.015980','98','Muhammad Delphi Putra Firdaus','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (60,'2023-01-21 12:23:41.038861','97','Muhammda Endi','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (61,'2023-01-21 12:23:43.888640','96','Reviana Ageng Lara Wigati','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (62,'2023-01-21 12:23:46.782675','94','Restu Anggia Putra','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (63,'2023-01-21 12:23:49.662649','93','Prayogi Setiawan','[{"changed": {"fields": ["Is vote"]}}]',9,1,2);
INSERT INTO "django_admin_log" ("id","action_time","object_id","object_repr","change_message","content_type_id","user_id","action_flag") VALUES (64,'2023-03-20 20:52:18.322610','2','EVote','',7,1,3);
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (1,'admin','logentry');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (2,'auth','permission');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (3,'auth','group');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (4,'auth','user');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (5,'contenttypes','contenttype');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (6,'sessions','session');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (7,'website','app');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (8,'website','candidate');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (9,'website','voter');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (10,'website','voice');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (11,'website','admin');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (12,'website','division');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (1,1,'add_logentry','Can add log entry');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (2,1,'change_logentry','Can change log entry');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (3,1,'delete_logentry','Can delete log entry');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (4,1,'view_logentry','Can view log entry');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (5,2,'add_permission','Can add permission');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (6,2,'change_permission','Can change permission');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (7,2,'delete_permission','Can delete permission');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (8,2,'view_permission','Can view permission');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (9,3,'add_group','Can add group');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (10,3,'change_group','Can change group');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (11,3,'delete_group','Can delete group');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (12,3,'view_group','Can view group');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (13,4,'add_user','Can add user');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (14,4,'change_user','Can change user');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (15,4,'delete_user','Can delete user');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (16,4,'view_user','Can view user');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (17,5,'add_contenttype','Can add content type');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (18,5,'change_contenttype','Can change content type');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (19,5,'delete_contenttype','Can delete content type');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (20,5,'view_contenttype','Can view content type');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (21,6,'add_session','Can add session');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (22,6,'change_session','Can change session');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (23,6,'delete_session','Can delete session');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (24,6,'view_session','Can view session');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (25,7,'add_app','Can add app');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (26,7,'change_app','Can change app');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (27,7,'delete_app','Can delete app');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (28,7,'view_app','Can view app');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (29,8,'add_candidate','Can add candidate');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (30,8,'change_candidate','Can change candidate');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (31,8,'delete_candidate','Can delete candidate');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (32,8,'view_candidate','Can view candidate');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (33,9,'add_voter','Can add voter');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (34,9,'change_voter','Can change voter');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (35,9,'delete_voter','Can delete voter');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (36,9,'view_voter','Can view voter');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (37,10,'add_voice','Can add voice');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (38,10,'change_voice','Can change voice');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (39,10,'delete_voice','Can delete voice');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (40,10,'view_voice','Can view voice');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (41,11,'add_admin','Can add admin');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (42,11,'change_admin','Can change admin');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (43,11,'delete_admin','Can delete admin');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (44,11,'view_admin','Can view admin');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (45,12,'add_division','Can add division');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (46,12,'change_division','Can change division');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (47,12,'delete_division','Can delete division');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (48,12,'view_division','Can view division');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (1,'pbkdf2_sha256$260000$adCl9YZcOIKr7CSlB62IaB$vrjFLJ5aAHNfHtkzG7SeFdKhgVXbyh193ztSCi4gzI4=','2023-03-20 20:52:07.504604',1,'admin','','',1,1,'2023-01-07 04:13:07.741421','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (3,'pbkdf2_sha256$260000$kCN8amkDXeO2dsXr99pHZA$nwwWF2hZRoEQWTjeBdW6rlSCOxb8j9d5aYHJr+WUO2s=','2023-01-22 13:42:59.135666',0,'prayogisatya','','',0,1,'2023-01-07 04:17:15.430484','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (79,'pbkdf2_sha256$260000$BPEJOIKEbrKwk0koPhF8Jh$ImUb0DKnrrK0guhQu5y9bmsg2HWtsk2NaQvTwYTXayI=',NULL,0,'6475706146','','',0,1,'2023-01-07 14:13:26.689064','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (80,'pbkdf2_sha256$260000$WyQPaiwVw9BlRNR2jLGXSV$AvoWbODL9mos5rl7yRM/MZUVtrMiR8r2M36C9XRRLCo=',NULL,0,'1518085164','','',0,1,'2023-01-07 14:13:26.897158','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (81,'pbkdf2_sha256$260000$PixCvB9yr0sZB2X3YMlJdH$CbzRhZ4B258oV8ZW3OivzF9YxYU5vYIGLycovL9Eiu4=',NULL,0,'7187116196','','',0,1,'2023-01-07 14:13:27.230865','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (82,'pbkdf2_sha256$260000$FVmd8LtNYE59CEFMklM6ZZ$2JBYuDqDHsRlVSEEP+rTrwWmBA3AB48r6WHttNjbboI=',NULL,0,'1072768338','','',0,1,'2023-01-07 14:13:27.676411','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (83,'pbkdf2_sha256$260000$8Vga3Ueu4dPTjYV1faMeSD$i/PG7tvMMkILkiuxlxh8DYJg3Kx8cPFPmP5jCIsGHzE=',NULL,0,'4011458928','','',0,1,'2023-01-07 14:13:27.908641','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (84,'pbkdf2_sha256$260000$FOjgN5VOmgnYCPVoyJ99XA$YPTlKHmqYCYL/sdV1MsJhXX8xByUd5bQQG2Tpi2qZc8=',NULL,0,'0288762016','','',0,1,'2023-01-07 14:13:28.087913','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (96,'pbkdf2_sha256$260000$tYGuLKGUaoYPiEKDWrOY4F$wWdu43dsDPHRvwJss6eB7q2wrI7pIn/MqyUqdgRcGTI=','2023-01-21 12:30:46.502211',0,'1138589230','','',0,1,'2023-01-09 02:52:29.758092','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (97,'pbkdf2_sha256$260000$jtViNx65XQBCpz1weBFmNz$6nr65NvxdO3ZkYi8RVtzqmXXKvkAzP3WTGSqkBCyEY4=','2023-01-21 19:40:45.107818',0,'7496998568','','',0,1,'2023-01-09 02:52:29.921763','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (99,'pbkdf2_sha256$260000$PH4klB3MPeZdwOAM4BhDSq$chwU383/m/o9/hZn7a5xFSafcyTn+5OkUo4gbKLoC7M=','2023-01-21 21:20:14.421567',0,'1272579307','','',0,1,'2023-01-09 02:52:30.238508','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (100,'pbkdf2_sha256$260000$El7NtKyn6SaJoi8wIYqCqL$WnOqfw121iYxHZQMRdraaqN0IH8tDMI1H4nlFfAJMOc=','2023-01-21 21:48:22.316766',0,'5584379465','','',0,1,'2023-01-09 02:52:30.423637','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (103,'pbkdf2_sha256$260000$e63miTX9qf93K3kLokWhM8$qkcDy5u1d8IWFQ9w671lqpJ2SmAMr97lJAHxGx/mXPE=','2023-01-10 08:09:21.130754',0,'mendias','','',0,1,'2023-01-10 08:02:21.889916','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (105,'pbkdf2_sha256$260000$OfFZzy62Z8hhIFKDy4SFX3$7hHZ7/qwHxQQTdZ7ISe4D0ZdJ6uDULXistyoi8DbIIc=','2023-01-21 21:50:36.573544',0,'8491238022','','',0,1,'2023-01-11 08:43:42.061606','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (106,'pbkdf2_sha256$260000$Q6GHzdQkRx4D0qiH0O81iU$kXWQ1qtLJCB9wRffPj4N+gh03UAM8qhG2dxAGfPdFvI=','2023-01-19 09:37:18.358080',0,'0426871445','','',0,1,'2023-01-11 08:48:42.926417','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (107,'pbkdf2_sha256$260000$sjWs0ap9K3JvnwVgD0Auou$5umGEFJoSsJO4x7OHaXFev7jGJsydD6h2ChMtYAeJw0=','2023-01-19 09:38:44.510606',0,'1896402401','','',0,1,'2023-01-13 10:38:08.543572','');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (108,'pbkdf2_sha256$260000$WYOgL0Cyu6X1t7YDfl03aB$KXN/xiQ3pDiIiMwFHCnKp168yfTbOv5RZLSDtNwff+c=','2023-01-19 09:56:27.822481',0,'3988455421','','',0,1,'2023-01-19 09:56:10.527798','');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('arl8lxjf973bk2ln69nh0phagxhq7gzh','.eJxVjD0OwjAUg--SGUX5aZqWkZ0zVM57gRRQIjXthLg7qdQBZMmDP9tvMWFb07TVuEwzi7PQ4vSbBdAz5h3wA_leJJW8LnOQe0UetMpr4fi6HN2_g4Sa2toFauphWWnlxo6D99RrUHMzjMYBMVrAtRyq08bDeu8oDMQ31kp8vvvWOHY:1pE0a8:WJ7AAzG6bQMND6tqrdTTH2IkCWbaIAqHFHxofcKw9Mc','2023-01-21 04:13:20.404799');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('l4cdmlp6gbtksfj7gi3pysoo9wpjn4jx','.eJxVjDsOwjAQBe_iGlkOu5YdSnrOEO3HxgFkS_lUEXeHSCmgfTPzNjPQupRhndM0jGouBszpd2OSZ6o70AfVe7PS6jKNbHfFHnS2t6bpdT3cv4NCc_nWWZ1DL4gYMzlJvc_MrKISIrGXDBD7DgGhi4FDCoAczwrsosuQyLw_ALA4Xg:1pE0f6:K85fA79h2wahnS-JZ8bkU6_BR-8t_ztSc5GFhEget4k','2023-01-21 04:18:28.614887');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('t4u7n1whavpmldoxwv2ih9boa1k64qjy','.eJxVjD0OwjAUg--SGUX5aZqWkZ0zVM57gRRQIjXthLg7qdQBZMmDP9tvMWFb07TVuEwzi7PQ4vSbBdAz5h3wA_leJJW8LnOQe0UetMpr4fi6HN2_g4Sa2toFauphWWnlxo6D99RrUHMzjMYBMVrAtRyq08bDeu8oDMQ31kp8vvvWOHY:1pF5if:CLKo5sf9MPa8ppv0F6gdhfqWOhZsWdAz1f6H9rQYITQ','2023-01-24 03:54:37.741773');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('udrotramtorydituyuj7z2zxj8l2rwtr','.eJxVjD0OwjAUg--SGUX5aZqWkZ0zVM57gRRQIjXthLg7qdQBZMmDP9tvMWFb07TVuEwzi7PQ4vSbBdAz5h3wA_leJJW8LnOQe0UetMpr4fi6HN2_g4Sa2toFauphWWnlxo6D99RrUHMzjMYBMVrAtRyq08bDeu8oDMQ31kp8vvvWOHY:1pF9ba:s1yoa1C9eVJx1qLY3hwqJCKh68nqsEuoiP3tgoaAG6o','2023-01-24 08:03:34.890444');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('8krid0jwumc08ib8ybbdunsulqe0dqw7','.eJxVjD0OwjAUg--SGUX5aZqWkZ0zVM57gRRQIjXthLg7qdQBZMmDP9tvMWFb07TVuEwzi7PQ4vSbBdAz5h3wA_leJJW8LnOQe0UetMpr4fi6HN2_g4Sa2toFauphWWnlxo6D99RrUHMzjMYBMVrAtRyq08bDeu8oDMQ31kp8vvvWOHY:1pFVog:7_zo2OHYrvu_YQKKqUdwjmmMn0P8zgZrRgOvwe-bJUA','2023-01-25 07:46:34.041061');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('e0o5ypb9atc50twrusnoak6wd3o9h0y5','.eJxVjMsOwiAQAP-FsyEL5dF69N5vaHYXkKqBpLQn478bkh70OjOZt1jw2PNytLgtaxBXocCLyy8l5GcsXYUHlnuVXMu-rSR7Ik_b5FxDfN3O9m-QseU-9h4iJGWQFXvnNQNbN0xO40gWJmdtsJoMJYxhGIgYAicb0Rk_ajDi8wUcyTgm:1pHHOy:QPM4JZmBpZYfDEXXXRRwGaRlxQRkq2xh5BrOcIo1PJY','2023-01-30 04:47:20.598238');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('wth5wirj9s3e3kxeqveujuholydpw6tf','.eJxVjDsOwjAQBe_iGlkOu5YdSnrOEO3HxgFkS_lUEXeHSCmgfTPzNjPQupRhndM0jGouBszpd2OSZ6o70AfVe7PS6jKNbHfFHnS2t6bpdT3cv4NCc_nWWZ1DL4gYMzlJvc_MrKISIrGXDBD7DgGhi4FDCoAczwrsosuQyLw_ALA4Xg:1pHgJm:WAqK_ZO3D0WaRSdr7rjR1elzDzqOaZJWWSqxiThKQwc','2023-01-31 07:23:38.777399');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('wmdc9uzyw7wctiiqi6ic4lvg6d3ekdt2','.eJxVjDsOwyAQRO9CHSEQ_5Tpcwa0C0twEoFk7MrK3WNLLpJuNO_NbCzCutS4DprjlNmVSWHY5bdFSC9qB8pPaI_OU2_LPCE_FH7Swe890_t2un8HFUbd10Q-OI0WXPZZKmtIBeWlt1CEAVFs9nuS0horCcEhCAzeFaWScFob9vkCJyI34Q:1pHjrA:YFQyVKQErcWrwAgOp2k3-GnEmp3DYB8mdosPw3fJ8e4','2023-01-31 11:10:20.151008');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('adszf7zxxrnztim9ht5riwgkfjq5z1mh','.eJxVjDsOwjAQBe_iGlkOu5YdSnrOEO3HxgFkS_lUEXeHSCmgfTPzNjPQupRhndM0jGouBszpd2OSZ6o70AfVe7PS6jKNbHfFHnS2t6bpdT3cv4NCc_nWWZ1DL4gYMzlJvc_MrKISIrGXDBD7DgGhi4FDCoAczwrsosuQyLw_ALA4Xg:1pI0zI:PCR4hG1xtFCX6iRHY24c9PX0g3NSO21avOMJbPWpU2M','2023-02-01 05:27:52.477133');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('0zu3ufapva461kr2ha7tvgpa5sskd4hs','.eJxVjDsOwjAQBe_iGllrx-sPJT1niDbeNQ6gRMqnQtwdLKWA9s3Me6me9q32-ypLP7I6K6NOv9tA-SFTA3yn6TbrPE_bMg66Kfqgq77OLM_L4f4dVFrrt7a-kM2AXXKORSShCzawKR064xMUAxAFDJOXmBE7jBAbgkLoQ1DvD8GDNog:1pJCtp:JXe2vdFJ3u-aMcavs3vvdYEg8sqsmuQY1US4IfqfV8I','2023-02-04 12:23:09.265518');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('mbk2p81ghxbg5lm25ifq1wunaox3a84d','.eJxVjE0OwiAYRO_C2pBQoIBL956B8P0gVQNJaVeNd7dNutDlzHszm4hpXUpcO89xInEVWlx-O0j44noAeqb6aBJbXeYJ5KHIk3Z5b8Tv2-n-HZTUy762AYzHwBm8ctrCqNnveWDCkGmEZLSzHogoK0Rgk4JyztmcrcuDVeLzBQLnOL4:1pJDtB:a7TfEH3XRWpFTgMaOjJbVfJhsVcCSDfQf4x3pDtdWxs','2023-02-04 20:26:33.476302');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('upoqsdymhhmf96xn74hnyrvze1laf99m','.eJxVjE0OwiAYRO_C2pBQoIBL956B8P0gVQNJaVeNd7dNutDlzHszm4hpXUpcO89xInEVWlx-O0j44noAeqb6aBJbXeYJ5KHIk3Z5b8Tv2-n-HZTUy762AYzHwBm8ctrCqNnveWDCkGmEZLSzHogoK0Rgk4JyztmcrcuDVeLzBQLnOL4:1pJU4B:ETmYViRsX1EGoESHYrIU0zCQecxO6xIDHyj2iAUOBf8','2023-02-05 13:42:59.149241');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('q6pty99qsno2niv9wvdmin46gymg79kv','.eJxVjDsOwjAQBe_iGln-4Q8lfc5grb1rHEC2FCcV4u4QKQW0b2bei0XY1hq3QUuckV2YZKffLUF-UNsB3qHdOs-9rcuc-K7wgw4-daTn9XD_DiqM-q1Jh6ASYZHCQknCGAjZe2sQlCtEZ7JGURYmBa2EVk45qb1H7zAYdIK9P-1bN4E:1peFvj:aL8u5XrOnejTaFUAYTELkwFfCYCfWRYFW1fvhTP2v_A','2023-04-03 20:52:07.535152');
INSERT INTO "website_voice" ("id","candidate_id","voter_id","vote_at") VALUES (30,4,93,'2023-01-21 12:31:00.574104');
INSERT INTO "website_voice" ("id","candidate_id","voter_id","vote_at") VALUES (31,2,94,'2023-01-21 19:40:55.456106');
INSERT INTO "website_voice" ("id","candidate_id","voter_id","vote_at") VALUES (32,2,96,'2023-01-21 21:22:31.155133');
INSERT INTO "website_voice" ("id","candidate_id","voter_id","vote_at") VALUES (33,6,97,'2023-01-21 21:48:44.028217');
INSERT INTO "website_voice" ("id","candidate_id","voter_id","vote_at") VALUES (34,5,98,'2023-01-21 21:50:59.964726');
INSERT INTO "website_candidate" ("id","code","name","order","photo","vision","mission","division_id") VALUES (1,'a633a958','Jhon Doe',1,'photos/voter-1.jpg','                                                                <div style="text-align: left;">Menjadi pelajar yang peduli terhadap pengembangan kualitas sumber daya manusia di bidang kerohanian, pengabdian masyarakat, pelajaran, dan pengembangan teknologi terkini.</div>
                            
                            ','                                                                                                                                <p style="">Misi saya adalah :<ol style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; margin-bottom: 11.5px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;"><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Membentuk wadah belajar kelompok terpadu bagi siswa.</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menyelenggarakan perlombaan yang mendidik</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menyelenggarakan kegiatan masa orientasi siswa yang jauh dari kesan pembodohan</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Aktif belajar di media sosial seperti Brainly, Edmodo, dan Quipper.</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Ikut membantu penyelenggaran kegiatan hari besar keagamaan.</li></ol></p>
                            
                            
                            
                            ',57);
INSERT INTO "website_candidate" ("id","code","name","order","photo","vision","mission","division_id") VALUES (2,'2e9cf1f3','Jean Marry',3,'photos/voter-3.jpg','                                <div style="">Meningkatkan keimanan dan ketaqwaan siswa SMKN 3 Metro terhadap Tuhan Yang Maha Esa, kepedulian siswa terhadap OSIS dan juga SMKN 3 Metro serta menciptakan generasi muda yang berkualitas, berakhlaq mulia dan amanah.<font color="#000000" face="Helvetica Neue, sans-serif"><span style="font-size: 18px;"><br></span></font></div>
                            ','                                                                                                                                                                                                                                                                                                    <p><span style="text-align: justify;">Mengoptimalkan kreativitas siswa&nbsp;</span>SMKN 3 Metro<span style="text-align: justify;">&nbsp;Laut melalui ekstrakurikuler dan meningkatkan kegiatan-kegiatan kegamaan bagi seluruh siswa&nbsp;</span>SMKN 3 Metro<span style="text-align: justify;">.</span><br></p>
                                                                
                                            
                                            
                            
                            
                            
                            ',61);
INSERT INTO "website_candidate" ("id","code","name","order","photo","vision","mission","division_id") VALUES (4,'3df49351','Jack Middle',2,'photos/voter-2.jpg','                                <span style="text-align: justify;">Menjadi wadah bagi siswa untuk mengembangkan segala potensi yang ada sehingga terbentuk siswa yang cerdas, kreatif, dinamis, berprestasi, berakhlak mulia dan menjaga nama baik sekolah menuju sekolah yang Unggul di tingkat nasional.</span>
                            ','                                <p style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; margin-right: 0px; margin-bottom: 15px; margin-left: 0px; overflow-wrap: break-word; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Membentuk karkater pengurus yang cerdas dan solid.</p><ol style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; margin-bottom: 11.5px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;"><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">&nbsp;Melaksanakan kegiatan yang dapat meningkatkan hubungan positif antar guru dan siswa</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menciptakan kondisi lingkungan sekolah yang kondusif dalam belajar, untuk menghasilkan siswa yang berkompetensi dan mandiri</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mengaktifkan kelompok belajar dari masing-masing kelas</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Memaksimalkan peran siswa dalam menjaga kebersihan lingkungan</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Memajukan kualitas ekskul di sekolah agar banyak diminati siswa dan mampu mengukir prestasi diluar sekolah</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mengadakan kerja sama dengan sekolah lain dari sisi akademik, olah raga dan seni</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Membentuk karakter siswa yang unggul dari SQ. IQ, EQ</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menjalin kerja sama dengan organisasi internal sekolah lainnya untuk memicu kreatifitas siswa</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Aktif menyerap dan berbagi informasi tentang kondisi dunia pendidikan</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menjadi jembatan siswa berprestasi untuk mendapatkan beasiswa</li></ol>
                            ',58);
INSERT INTO "website_candidate" ("id","code","name","order","photo","vision","mission","division_id") VALUES (5,'bc4eee21','Kim Seo Hyun',4,'photos/voter-4.jpg','                                <ol style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; margin-bottom: 11.5px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;"><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menjadikan OSIS di sekolah SMKN 3 Metro&nbsp;yang progresif, dinamis, dan solid</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mendorong siswa agar mampu untuk mengasah potensinya sendiri berdasarkan kreativitas yang telah diberikan Tuhan kepadanya.</li></ol>
                            ','                                <ol style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; margin-bottom: 11.5px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;"><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mengutamakan Ketuhanan Yang Maha Esa dalam segala aspek;</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Merangkul dan menjalin hubungan yang baik antar civitas akademik dalam setiap program kerja dan juga keseharian;</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mengutamakan kerjasama dan kebersamaan</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menjalankan dan meningkatkan kualitas program kerja;</li></ol>
                            ',60);
INSERT INTO "website_candidate" ("id","code","name","order","photo","vision","mission","division_id") VALUES (6,'a0de29b7','Lee Mi Dun',5,'photos/voter-5.jpg','<span style="text-align: justify;">Menjadikan OSIS sebagai sarana penampungan kreativitas, inspirasi dan aspirasi siswa, juga meningkatkan sekolah sebagai sekolah yang bermutu, berakhlak mulia, jujur, tampil beda, adil, dan disiplin.</span>','<ol style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; margin-bottom: 11.5px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;"><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mengaktifkan dan memajukan organisasi-organisasi dan ekstrakulikuler yang ada disekolah dan kepengurusannya</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menjalin hubungan yang harmonis antara seluruh anggota sekolah beserta staff- staffnya</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Melaksanakan program-progam yang tersusun sesuai rencana</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Meningkatkan mutu kerja OSIS</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Menjadikan siswa/siswi yang kreatif, berdisiplin tinggi, dan takwa kepada Tuhan yang maha esa</li><li style="text-shadow: rgba(0, 0, 0, 0.024) 1px 1px 1px; -webkit-font-smoothing: antialiased !important; backface-visibility: hidden !important;">Mengadakan kegiatan-kegiatan di bidang sosial dan keagamaan.</li></ol>',59);
INSERT INTO "website_division" ("id","name","code") VALUES (56,'X RPL A','D001');
INSERT INTO "website_division" ("id","name","code") VALUES (57,'X RPL B','D002');
INSERT INTO "website_division" ("id","name","code") VALUES (58,'X MM A','D003');
INSERT INTO "website_division" ("id","name","code") VALUES (59,'X MM B','D004');
INSERT INTO "website_division" ("id","name","code") VALUES (60,'X TKJ A','D005');
INSERT INTO "website_division" ("id","name","code") VALUES (61,'X TKJ B','D006');
INSERT INTO "website_division" ("id","name","code") VALUES (62,'XII RPL B','D008');
INSERT INTO "website_admin" ("id","name","level","user_id") VALUES (2,'Prayogi Setiawan','admin',3);
INSERT INTO "website_admin" ("id","name","level","user_id") VALUES (5,'Muhammad Endis','admin',103);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (93,'Prayogi Setiawan','voter',1,'1138589230',56,96);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (94,'Restu Anggia Putra','voter',1,'7496998568',57,97);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (96,'Reviana Ageng Lara Wigati','voter',1,'1272579307',58,99);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (97,'Muhammda Endi','voter',1,'5584379465',59,100);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (98,'Muhammad Delphi Putra Firdaus','voter',1,'8491238022',58,105);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (99,'Erlin Widianingrum','voter',0,'0426871445',60,106);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (100,'Muhammad Arif Martadinata','voter',0,'1896402401',56,107);
INSERT INTO "website_voter" ("id","name","level","is_vote","auth","division_id","user_id") VALUES (101,'Fahri Febrian','voter',0,'3988455421',58,108);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "website_voice_candidate_id_04a6ab93" ON "website_voice" (
	"candidate_id"
);
CREATE INDEX IF NOT EXISTS "website_voice_voter_id_0c24cc4b" ON "website_voice" (
	"voter_id"
);
CREATE INDEX IF NOT EXISTS "website_candidate_division_id_41b9d089" ON "website_candidate" (
	"division_id"
);
CREATE INDEX IF NOT EXISTS "website_voter_division_id_0edd1645" ON "website_voter" (
	"division_id"
);
COMMIT;
