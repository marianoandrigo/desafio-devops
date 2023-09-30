# desafio-devops

# 🛠️ Detalles de la Configuración de Infraestructura

> 📖 Este README proporciona una descripción detallada de las decisiones clave de configuración de infraestructura tomadas durante el despliegue de la aplicación y la base de datos en AWS. 

---

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

CREATE TABLE IF NOT EXISTS public.notas
(
    id integer NOT NULL DEFAULT nextval('notas_id_seq'::regclass),
    titulo character varying(255) COLLATE pg_catalog."default",
    contenido text COLLATE pg_catalog."default",
    fecha_creacion timestamp without time zone DEFAULT now(),
    CONSTRAINT notas_pkey PRIMARY KEY (id)
);
```

## 🚀 Configuración de EKS (Elastic Kubernetes Service)

### 📌 Clúster de EKS

Se creó un clúster de Kubernetes administrado utilizando el módulo de Terraform "terraform-aws-modules/eks/aws". Esto proporciona un entorno de orquestación de contenedores escalable y fácil de administrar.

### 📌 Grupos de Nodos Administrados

Se configuraron grupos de nodos administrados para permitir la escalabilidad automática de la infraestructura de Kubernetes. Esto garantiza que el clúster pueda manejar un mayor número de usuarios y cargas de trabajo.



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

