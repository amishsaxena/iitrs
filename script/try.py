import psycop


# connection.execute(psycop.text("UPDATE availability SET general = 144 WHERE av_id = 56;"))
# # psycop.db.execute_ddl_and_dml_commands_trial(psycop.text("UPDATE availability SET general = 140 WHERE av_id = 56;"), connection)
# input()
# # psycop.db.execute_dql_commands(psycop.text("ROLLBACK;"))

#!/usr/bin/python3
# -*- coding: utf-8 -*-

# import Python's JSON lib
import json
from psycopg2.extras import Json

# import the new JSON method from psycopg2
import psycopg2

connection = psycop.db.open_connect()
trans = connection.begin()
hell = json.loads('{"ticket" : [{"name": "R", "age": "23", "gender": "M", "seat": "S11/72", "date": "2022-03-26"}, {"name": "J", "age": "21", "gender": "F", "seat": "S10/71", "date": "2022-03-26"}]}')
print(hell)

new_hell = Json(hell)
print(new_hell)

connection.execute(psycop.text("INSERT INTO ticket (pnr, train_no, uid, train_name, source, destination, date, seats, amount) VALUES ('8264078722', 19999, 2, 'Test', 'LDH', 'ASR', '04/25/2022', {}, 1000)".format(new_hell)))

trans.commit()
connection.close()