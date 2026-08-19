import os

from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)


def get_connection():
    return mysql.connector.connect(
        host=os.environ["MYSQL_HOST"],
        user=os.environ["MYSQL_USER"],
        password=os.environ["MYSQL_PASSWORD"],
        database=os.environ["MYSQL_DATABASE"],
    )


def initialize_database():
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS products (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            quantity INT NOT NULL DEFAULT 0,
            price DECIMAL(10,2) NOT NULL DEFAULT 0
        )
        """
    )

    connection.commit()
    cursor.close()
    connection.close()


@app.route("/")
def index():
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT id, name, quantity, price FROM products ORDER BY id DESC"
    )

    products = cursor.fetchall()

    cursor.close()
    connection.close()

    return render_template("index.html", products=products)


@app.route("/add", methods=["POST"])
def add_product():

    name = request.form["name"]
    quantity = request.form["quantity"]
    price = request.form["price"]

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute(
        """
        INSERT INTO products (name, quantity, price)
        VALUES (%s, %s, %s)
        """,
        (name, quantity, price),
    )

    connection.commit()

    cursor.close()
    connection.close()

    return redirect("/")


@app.route("/delete/<int:product_id>")
def delete_product(product_id):

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute(
        "DELETE FROM products WHERE id = %s",
        (product_id,),
    )

    connection.commit()

    cursor.close()
    connection.close()

    return redirect("/")


if __name__ == "__main__":

    initialize_database()

    app.run(
        host="0.0.0.0",
        port=5000,
    )
