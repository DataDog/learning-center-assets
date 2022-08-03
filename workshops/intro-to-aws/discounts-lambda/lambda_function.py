import os
import sys
import logging
import random
import psycopg2
import json
from psycopg2.extras import RealDictCursor
# from aws_xray_sdk.core import xray_recorder
# from aws_xray_sdk.core import patch_all

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
# patch_all()

def get_random_word(count=1):
    word_list = [ "act", "action", "actor", "bonus", "book", "boost", "border", "cat", "fudge", "positron",
                  "question", "quiz", "rotation", "radiator", "radar", "transcendence", "tubular",
                  "possible", "post", "potato", "turtle", "twelve", "twenty", "twice", "wolf", "vegan",
                  "woman", "wonder", "woof", "wabbit", "word", "yard", "work"]
    words = []
    for i in range(0, count):
        words.append(random.choice(word_list))
    return " ".join(words)

def create_table():

    logger.debug("create_table() called")

    connection = None

    try:
        connection = psycopg2.connect(f"host={os.environ['POSTGRES_HOST']} dbname=discounts user=postgres password=postgres")
        connection.set_session(autocommit=True)
    except Exception as error:
        logger.error("Could not connect to discounts database.")
        logger.exception(error)
        sys.exit(1)
        
    cur = connection.cursor()
    cur.execute("CREATE TABLE discounts (id serial primary key, name varchar(128), code varchar(64), value int)")

    for i in range(100):
        discount_name = get_random_word(random.randint(2,4))
        code = get_random_word().upper()
        value = random.randrange(1,100) * random.random()
        logger.debug(f"Creating record: {discount_name}, {code}, {value}")
        cur.execute(f"INSERT INTO discounts VALUES (DEFAULT, %s, %s, %s)", (discount_name, code, value))


def prepare_database():

    logger.debug("prepare_database() called")

    connection = None

    try:
        connection = psycopg2.connect(f"host={os.environ['POSTGRES_HOST']} user=postgres password=postgres")
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


def get_random_discounts(limit=1):

    rand_discount_query = f"SELECT * FROM discounts ORDER by RANDOM() LIMIT {limit}"

    connection = None

    try:
        connection = psycopg2.connect(f"host={os.environ['POSTGRES_HOST']} dbname=discounts user=postgres password=postgres")
    except Exception as error:
        logger.error("Could not connect to database.")
        logger.exception(error)
        sys.exit(1)

    cur = connection.cursor(cursor_factory=RealDictCursor)
    cur.execute(rand_discount_query)
    result = cur.fetchall()

    cur.close()
    connection.close()

    return result
    

def lambda_handler(event, context):

    prepare_database()
    return json.dumps(get_random_discounts(10))


# print(lambda_handler(None, None))