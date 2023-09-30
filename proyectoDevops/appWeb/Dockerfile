# Usa una imagen base de Python
FROM python:3.8-slim

# Establece el directorio de trabajo en /app
WORKDIR /app

# Instala las bibliotecas necesarias
RUN apt-get update && apt-get install -y libpq-dev gcc

# Copia el archivo requirements.txt al directorio de trabajo
COPY requirements.txt /app/requirements.txt

# Actualiza pip a la última versión
RUN pip install --upgrade pip

# Instala las dependencias del proyecto
RUN pip install --verbose --no-cache-dir -r requirements.txt

# Copia el contenido de la aplicación al directorio de trabajo
COPY . .

# Expone el puerto en el que se ejecutará la aplicación Flask
EXPOSE 5000

# Define el comando para ejecutar la aplicación Flask
CMD ["python", "app.py"]
