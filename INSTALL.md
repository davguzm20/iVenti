# iVenti - Guia de instalacion

## Requisitos

- Flutter SDK 3.44.0. Verifica con `flutter --version`.
- JDK 17. Verifica con `java -version`.
- Android SDK configurado. Verifica con `flutter doctor`.
- Cuenta en [Neon](https://neon.tech).
- Cuenta en [Cloudinary](https://cloudinary.com).
- Gmail con App Password.

---

## Paso 1. Clonar el repositorio

```bash
git clone https://github.com/davguzm20/iVenti.git
cd iVenti
```

Dentro de `database/` estan los scripts SQL que crean la estructura de la base de datos. Los ejecutaras en Neon en el paso 5.

---

## Paso 2. Generar ENCRYPTION_KEY para el .env

La aplicacion usa `ENCRYPTION_KEY` para dos tareas de seguridad: cifrar los DNI de los clientes (AES-256) y validar los PIN de los usuarios (HMAC-SHA256). Es una clave de 32 bytes codificada en Base64, resultado: 44 caracteres.

Elige una de estas opciones para generarla. Todas producen el mismo tipo de resultado.

- **Git Bash** (incluido con Git for Windows):
  ```bash
  openssl rand -base64 32
  ```
- **macOS o Linux**:
  ```bash
  openssl rand -base64 32
  ```
- **Dart** (ya incluido con Flutter):
  ```bash
  dart run -c "import 'dart:convert'; import 'dart:math'; final r=Random.secure(); final b=List<int>.generate(32,(i)=>r.nextInt(256)); print(base64.encode(b));"
  ```
- **En linea**: busca "generate random base64 32 bytes" en Google y usa un generador de confianza.

Guarda la clave generada. En el siguiente paso la pondras en tu archivo `.env`, en la variable `ENCRYPTION_KEY`. No hay forma de recuperarla si la pierdes.

---

## Paso 3. Crear el archivo .env

Copia la plantilla a un archivo nuevo llamado `.env`:

```bash
cp .env.example .env
```

Abre `.env` en tu editor. Cada linea tiene el formato `VARIABLE=valor`. Reemplaza los valores de ejemplo con los reales:

| Variable | Que poner |
|----------|-----------|
| `ENCRYPTION_KEY` | La clave de 44 caracteres que generaste en el paso 2 |
| `PGHOST` | Lo obtendras en el paso 4 |
| `PGPORT` | Lo obtendras en el paso 4 |
| `PGDATABASE` | Lo obtendras en el paso 4 |
| `PGUSER` | Lo obtendras en el paso 4 |
| `PGPASSWORD` | Lo obtendras en el paso 4 |
| `SMTP_EMAIL` | Correo de Gmail |
| `SMTP_PASSWORD` | App Password de Gmail |
| `CLOUDINARY_URL` | `cloudinary://key:secret@name` |

De donde sacar cada valor:

- **ENCRYPTION_KEY**: la generaste en el paso 2.
- **PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD**: las obtendras en el paso 4.
- **SMTP_EMAIL y SMTP_PASSWORD**: entra a https://myaccount.google.com/security > Verificacion en 2 pasos > Contrasenas de aplicaciones. Genera una contrasena para "Correo" en "Otra aplicacion". El usuario es tu correo Gmail y la password son los 16 caracteres generados (sin espacios).
- **CLOUDINARY_URL**: entra a tu dashboard de Cloudinary. En la seccion de configuracion encontraras `cloud_name`, `api_key` y `api_secret`. Construye la URL asi: `cloudinary://api_key:api_secret@cloud_name`.

---

## Paso 4. Configurar Neon

Entra a https://console.neon.tech, inicia sesion y crea un proyecto nuevo. Neon te asigna una rama llamada `main`.

### 4.1 Crear los roles

En la barra lateral, ve a **Branches**, selecciona `main` y abre la pestana **Roles**. Crea estos tres roles con **Add role**:

1. `iventi_admin_user` — administrador, sera el dueño de la base de datos.
2. `iventi_app_user` — la aplicacion se conecta con este rol.
3. `iventi_audit_user` — solo lectura, para consultas de auditoria.

Neon genera una password para cada rol. Copia la de `iventi_app_user` y ponla en tu `.env` como valor de `PGPASSWORD` (lo haras en el paso 4.3).

### 4.2 Crear la base de datos

En la misma pagina, ve a la pestana **Databases** y haz clic en **Create database**.

1. Nombre: por ejemplo `iventi_db`.
2. Owner: selecciona `iventi_admin_user`.

### 4.3 Obtener las credenciales

Vuelve al dashboard del proyecto y haz clic en el boton **Connect**. En el modal, selecciona la rama `main`, tu base de datos y el rol `iventi_app_user`. El modal muestra cinco datos. Copialos a tu `.env`:

| Modal | `.env` |
|-------|--------|
| Host | `PGHOST` |
| Port | `PGPORT` |
| Database | `PGDATABASE` |
| User | `PGUSER` |
| Password | `PGPASSWORD` |

Con esto, el archivo `.env` ya tiene todas las variables configuradas.

---

## Paso 5. Ejecutar los scripts SQL

Los scripts que crean las tablas, funciones y datos iniciales estan en la carpeta `database/`. Abre el SQL Editor desde la barra lateral de Neon y asegurate de estar conectado a tu base de datos.

Ejecuta los scripts en orden. Para cada uno: abre el archivo, copia su contenido, pegalo en el SQL Editor y haz clic en **Run**. Espera a que termine antes de pasar al siguiente.

| Orden | Archivo |
|-------|---------|
| 1 | `database/iventi-schema.sql` |
| 2 | `database/iventi-triggers.sql` |
| 3 | `database/iventi-inserts.sql` |
| 4 | `database/iventi-users.sql` |

Para verificar que los datos iniciales se insertaron correctamente, ejecuta esta consulta. Debe devolver 8 filas:

```sql
SELECT * FROM unidades;
SELECT * FROM categorias;
```

---

## Paso 6. Ejecutar la aplicacion

La base de datos esta lista y las credenciales configuradas. Al iniciar la app por primera vez, el flujo de bienvenida te permite registrar el usuario inicial.

```bash
flutter pub get
```

En Windows, define `JAVA_HOME`:

```bash
set "JAVA_HOME=<ruta_de_tu_jdk_17>"
```

Ejecuta:

```bash
flutter run --debug
```

Para generar un APK instalable en cualquier dispositivo:

```bash
flutter build apk --release
```

---

## Paso 7. Base de datos de pruebas (opcional)

Si necesitas una base de datos aparte para ejecutar tests, crea otra en Neon y guarda sus credenciales en un archivo `.env.test`. Con una sola base de datos, omite este paso.
