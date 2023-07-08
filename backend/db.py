import MySQLdb

# db = MySQLdb.connect(
#     host="34.246.195.200",
#     user="root",
#     password="p@ssword",
#     database="kitty"
# )
# cursor = db.cursor(MySQLdb.cursors.DictCursor)


class DB():
    def __init__(self, **kwargs):
        self.conn = MySQLdb.connect(
            host="34.246.195.200",
            user="root",
            password="p@ssword",
            database="kitty"
        )
        try:
            if (self.conn):
                status = "DB init success"
            else:
                status = "DB init failed"
            self.conn.autocommit(True)
            # self.conn.select_db(DB_NAME)
            self.cursor = self.conn.cursor(MySQLdb.cursors.DictCursor)
        except Exception as e:
            status = "DB init fail %s " % str(e)
        print(status)

    def execute(self, sql, values=None):
        try:
            if self.conn is None:
                self.__init__()
            else:
                self.conn.ping(True)
                if values is None:
                    self.cursor.execute(sql)
                else:
                    self.cursor.execute(sql, values)
                self.conn.commit()
            # return True
        except Exception as e:
            import traceback
            traceback.print_exc()
            # error ocurs,rollback
            self.conn.rollback()
            return False

    def executeQuery(self, query, values=None):
        try:
            if self.conn is None:
                self.__init__()
            else:
                self.conn.ping(True)
                if values is None:
                    self.cursor.execute(query)
                else:
                    self.cursor.execute(query, values)
            return self.cursor.fetchall()
        except Exception as e:
            import traceback
            traceback.print_exc()
            # error ocurs,rollback
            self.conn.rollback()
            return False
