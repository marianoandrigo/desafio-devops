from flask import Flask, request, jsonify, render_template
import psycopg2

app = Flask(__name__)

# Configura la conexión a la base de datos
try:
    connection = psycopg2.connect(
        host="TU-CUENTA-AWS",
        database="TU-BD",
        user="TU-USUARIO",
        password="TU-PASSWORD"
    )
    print("Conexión exitosa a la base de datos")
except Exception as e:
    print("Error en la conexión a la base de datos:", str(e))

# Variable para almacenar las notas como diccionarios
notas = []

@app.route('/')
def index():
    return render_template('index.html', notas=notas)

@app.route('/notas', methods=['GET', 'POST'])
def gestionar_notas():
    global notas

    if request.method == 'GET':
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM notas")
        notas = cursor.fetchall()
        cursor.close()
        return jsonify({"notas": notas})

    if request.method == 'POST':
        cursor = connection.cursor()

        nota = request.form.get('nota')
        if nota is None:
            return jsonify({"error": "Falta el campo 'nota'"}), 400

        # Inserta la nota en la base de datos
        cursor.execute("INSERT INTO notas (titulo, contenido) VALUES (%s, %s)", (nota, ""))
        connection.commit()
        cursor.close()

        return jsonify({"mensaje": "Nota añadida!"}), 201

    return jsonify({"notas": notas})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
