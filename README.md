# desafio-devops

# 🛠️ Detalles de la Configuración de Infraestructura

> 📖 Este README proporciona una descripción detallada de las decisiones clave de configuración de infraestructura tomadas durante el despliegue de la aplicación y la base de datos en AWS. 

---

# Descripción del Proyecto 📝

Este proyecto se centra en el despliegue de una aplicación web de creación de notas, diseñada para gestionar y almacenar notas de manera eficiente. La aplicación se encuentra conectada a una base de datos donde se almacenan todas las notas creadas.

## Pasos Clave del Proyecto 🔑

1. **Creación de la Infraestructura con Terraform**: Para garantizar la disponibilidad y escalabilidad de nuestra aplicación, comenzamos creando la infraestructura necesaria utilizando Terraform. Esto incluye la configuración de redes virtuales (VPC), subredes, grupos de seguridad y otros recursos esenciales en la nube de AWS.

2. **Desarrollo de la Aplicación Web**: La aplicación web de creación de notas se desarrolló y empaquetó en una imagen Docker. Esta imagen se utiliza posteriormente para implementar la aplicación en un clúster de Kubernetes.

3. **Almacenamiento de Datos en una Base de Datos**: Las notas creadas por los usuarios se almacenan de manera segura en una base de datos PostgreSQL. Se configura la base de datos para que sea escalable y capaz de manejar una carga significativa de usuarios concurrentes.

4. **Subida de la Imagen de la Aplicación a Amazon ECR**: La imagen Docker de la aplicación se almacena en Amazon Elastic Container Registry (ECR), lo que nos permite gestionar y desplegar la aplicación de manera eficiente en el clúster de Kubernetes.

5. **Despliegue de la Aplicación en Kubernetes**: Utilizando Kubernetes, desplegamos la aplicación web y garantizamos que se ejecute de manera confiable y escalable en un clúster administrado.

6. **Acceso Público a la Aplicación**: Para que la aplicación sea accesible públicamente, configuramos un Ingress en Kubernetes. Esto permite que la aplicación sea accesible a través de una dirección IP pública de nuestro clúster de Kubernetes.


En conjunto, este proyecto demuestra cómo crear y gestionar una infraestructura en la nube, desarrollar una aplicación web, conectarla a una base de datos, y luego desplegarla en un clúster de Kubernetes, asegurando su accesibilidad pública.



## 🌍 Selección de Región de AWS

Se eligió la región **us-east-1** de AWS para este proyecto debido a su disponibilidad y capacidad de escalabilidad. Esta región es una de las más utilizadas y confiables en AWS, lo que garantiza una buena disponibilidad de servicios y recursos.

---

## 🌐 Creación de la VPC y Subredes

### 📌 VPC (Virtual Private Cloud)

Se creó una VPC con la dirección IP de rango `10.0.0.0/16`. Esta elección permite un espacio de direcciones lo suficientemente grande para acomodar futuras expansiones de recursos. Se habilitó el soporte DNS y las resoluciones de nombres de host para garantizar la conectividad y el funcionamiento correcto de los recursos.

### 📌 Subredes Públicas

Se crearon dos subredes públicas, **subnet_a** y **subnet_b**, en diferentes zonas de disponibilidad (us-east-1a y us-east-1b). Estas subredes se eligieron como públicas para permitir que los recursos, como los nodos EC2 de EKS, puedan acceder a Internet y recibir actualizaciones de paquetes y software.

---

## 🔐 Grupos de Seguridad

| Nombre del Grupo | Descripción |
|------------------|-------------|
| **all_traffic**  | Este grupo de seguridad permite todo el tráfico de entrada y salida. Aunque esta configuración no es recomendada en un entorno de producción, se utilizó aquí para simplificar la configuración y demostrar cómo se pueden aplicar políticas de seguridad más estrictas en una implementación real. |
| **db_sg**        | Este grupo de seguridad se creó específicamente para la base de datos (RDS). Solo permite el tráfico TCP en el puerto 5432, que es el puerto estándar de PostgreSQL. Esta configuración limita el acceso a la base de datos solo desde direcciones IP específicas. |

---

## 🗄️ Creación de la Base de Datos RDS

Se implementó una instancia de base de datos Amazon RDS para alojar los datos generados por la aplicación. La elección de PostgreSQL como motor de base de datos se basó en su confiabilidad y escalabilidad.

## 🗄️ Creación de la Base de Datos PostgreSQL y Tabla

### 📜 Script de Creación de la Base de Datos

```sql
CREATE DATABASE base_mariano_desafio;
📜 Script de Creación de la Tabla "notas"
sql

CREATE TABLE notas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255),
    contenido TEXT,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);
```

## 🚀 Configuración de EKS (Elastic Kubernetes Service)

### 📌 Clúster de EKS

Se creó un clúster de Kubernetes administrado utilizando el módulo de Terraform "terraform-aws-modules/eks/aws". Esto proporciona un entorno de orquestación de contenedores escalable y fácil de administrar.

### 📌 Grupos de Nodos Administrados

Se configuraron grupos de nodos administrados para permitir la escalabilidad automática de la infraestructura de Kubernetes. Esto garantiza que el clúster pueda manejar un mayor número de usuarios y cargas de trabajo.



## Ejecucion y pasos para la Implementacion


## 🛠️ Requisitos Previos

Antes de comenzar, asegúrate de tener instaladas las siguientes herramientas:

- **Terraform**: Para la automatización de recursos en la nube.
- **Kubernetes (kubectl)**: Para interactuar con el clúster de Kubernetes.
- **Docker**: Para crear y administrar contenedores.
- **AWS CLI**: Para configurar el entorno de AWS.


## 🐳 Build de la Imagen con Docker y Subida al Amazon ECR

### **Aclaracion**
Reemplaza tu-id-de-cuenta, tu-region y mi-app:v1 con los valores adecuados

### **Paso 1: Construcción de la Imagen con Docker**

Dentro del directorio donde se encuentra tu `Dockerfile`, construye la imagen utilizando el siguiente comando:

docker build -t mi-app:v1 .

### **Paso 2: Iniciar Sesión en Amazon ECR**

Para poder subir la imagen a Amazon ECR, es necesario autenticarse en tu registro de contenedores de Amazon ECR. Ejecuta el siguiente comando:

aws ecr get-login-password --region tu-region | docker login --username AWS --password-stdin tu-id-de-cuenta.dkr.ecr.tu-region.amazonaws.com

### **Paso 3: Etiquetar la Imagen para Amazon ECR**

Antes de subir la imagen a ECR, es necesario etiquetarla con la URL de tu repositorio de ECR. Utiliza el siguiente comando:

docker tag mi-app:v1 tu-id-de-cuenta.dkr.ecr.tu-region.amazonaws.com/mi-app:v1

### **Paso 4: Subir la Imagen a Amazon ECR**

Con la imagen correctamente etiquetada, ya puedes subirla a tu repositorio de ECR:

docker push tu-id-de-cuenta.dkr.ecr.tu-region.amazonaws.com/mi-app:v1


## Pasos para el Despliegue 🚀

1. Abre una terminal y navega hasta el directorio donde se encuentran los archivos de Terraform (main.tf, db.tf, securitygroups.tf, eks.tf,secrets.tf)

2. Inicializa Terraform y descarga los módulos necesarios con el comando:
   
    terraform init

3. Obtén un resumen de los cambios que Terraform aplicará a tu infraestructura:

    terraform plan
   
    Revisa cuidadosamente la salida para asegurarte de que se crearán los recursos deseados y de que no haya errores.

4. Si todo se ve bien en el plan, aplica los cambios para crear la infraestructura:
   
    terraform apply

    Terraform te pedirá confirmación antes de aplicar los cambios. Ingresa "yes" para continuar.

5. Una vez completado el despliegue, Terraform mostrará información sobre los recursos creados.


## Despliegue en Kubernetes 🌐

Después de haber creado la infraestructura en AWS y subido la imagen de Docker a Amazon ECR, puedes proceder con el despliegue de la aplicación en Kubernetes.

### Requisitos Previos

Antes de comenzar, asegúrate de tener instalado `kubectl` y de haber configurado tu archivo `kubeconfig` para que apunte al clúster de Kubernetes donde deseas desplegar la aplicación.

1. Abre una terminal y navega hasta el directorio donde se encuentran los archivos YAML para Kubernetes (`deployment.yaml`, `service.yaml`, `ingress.yaml`) y tu archivo `kubeconfig`.
   
2. Configura el archivo `kubeconfig` para acceder al clúster de Kubernetes utilizando el siguiente comando (reemplaza `<TU-REGION>` y `<NOMBRE-DE-TU-CLUSTER>`):

    aws eks --region <TU-REGION> update-kubeconfig --name <NOMBRE-DE-TU-CLUSTER>

### Pasos para el Despliegue

1. Abre una terminal y navega hasta el directorio donde se encuentran los archivos YAML para Kubernetes (`deployment.yaml`, `service.yaml`, `ingress.yaml`) y tu archivo `kubeconfig`.
   
2. Ejecuta el siguiente comando para aplicar el despliegue del servicio y del despliegue de la aplicación:

    kubectl apply -f deployment.yaml

   Esto creará los pods de la aplicación y los servicios necesarios.

3. A continuación, ejecuta el siguiente comando para aplicar la configuración del servicio de Ingress:

    kubectl apply -f ingress.yaml

   Esto configurará las reglas de Ingress para dirigir el tráfico a los pods de la aplicación.

4. Puedes verificar que los pods de la aplicación se estén ejecutando correctamente mediante el siguiente comando:

    kubectl get pods

   Deberías ver una lista de pods con el nombre de la aplicación y el estado "Running".

5. Ahora, para acceder a tu aplicación, visita la dirección con el dominio que agregaste en tu `ingress.yaml` en tu navegador web:

    En mi caso creé un dominio gratuito de ejemplo para poder probarlo:
    [http://myapp-mariano-andrigo.freeddns.org/](http://myapp-mariano-andrigo.freeddns.org/)

Tu aplicación web debería estar funcionando en Kubernetes y accesible a través de la dirección proporcionada.



