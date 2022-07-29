import os
import sys
import logging
import random
import psycopg2
import json
from psycopg2.extras import RealDictCursor
# from aws_xray_sdk.core import xray_recorder
# from aws_xray_sdk.core import patch_all

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import words

logger = logging.getLogger()
logger.setLevel(logging.INFO)
# patch_all()

def create_table():

    logger.debug("create_table() called")

    connection = None

    try:
        connection = psycopg2.connect(f"host={os.environ['DB_HOST']} dbname=discounts user=postgres password=postgres")
        connection.set_session(autocommit=True)
    except Exception as error:
        logger.error("Could not connect to discounts database.")
        logger.exception(error)
        sys.exit(1)
        
    cur = connection.cursor()
    cur.execute("CREATE TABLE discounts (id serial primary key, name varchar(128), code varchar(64), value int)")

    for i in range(100):
        discount_name = words.get_random(random.randint(2,4))
        code = words.get_random().upper()
        value = random.randrange(1,100) * random.random()
        logger.debug(f"Creating record: {discount_name}, {code}, {value}")
        cur.execute(f"INSERT INTO discounts VALUES (DEFAULT, %s, %s, %s)", (discount_name, code, value))


def prepare_database():

    logger.debug("prepare_database() called")

    connection = None

    try:
        connection = psycopg2.connect(f"host={os.environ['DB_HOST']} user=postgres password=postgres")
        connection.set_session(autocommit=True)
    except Exception as error:
        logger.error("Could not connect to PostgresSQL server.")
        logger.exception(error)
        sys.exit(1)
        
    cur = connection.cursor()
    cur.execute("SELECT * FROM pg_database WHERE datname = 'discounts'")
    result = cur.fetchone()

    if result is None:
        logger.debug("discounts database does not exist. Creating.")
        cur.execute("CREATE DATABASE discounts")
        create_table()
    
    cur.close()
    connection.close()


def get_random_discount():

    rand_discount_query = "SELECT * FROM discounts ORDER by RANDOM() LIMIT 1"
    fast_rand_discount_query = "SELECT * FROM discounts OFFSET floor(random() * (SELECT COUNT(*) FROM discounts))"

    connection = None

    try:
        connection = psycopg2.connect(f"host={os.environ['DB_HOST']} dbname=discounts user=postgres password=postgres")
    except Exception as error:
        logger.error("Could not connect to database.")
        logger.exception(error)
        sys.exit(1)

    cur = connection.cursor(cursor_factory=RealDictCursor)
    cur.execute(rand_discount_query)
    result = cur.fetchone()

    cur.close()
    connection.close()

    return result
    

def lambda_handler(event, context):

    prepare_database()
    return json.dumps(get_random_discount())


print(lambda_handler(None, None))