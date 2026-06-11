# Sistema de Inventario y Ventas iVenti

Aplicación móvil para la gestión eficiente de inventarios y ventas, diseñada para optimizar la administración de una tienda de multiservicios.

## ✨ Características principales

- **Control total del inventario:** Registro preciso de productos, lotes, cantidades y fechas de vencimiento.
- **Registro rápido de ventas:** Transacciones ágiles con soporte para crédito y contado, generación de boletas y nota de venta.
- **Gestión de clientes:** Seguimiento de deudores, historial de compras y pagos.
- **Reportes detallados:** Ventas, productos más vendidos, lotes próximos a vencer e inventario general (exportables a PDF).
- **Notificaciones inteligentes:** Alertas cuando un producto esté por agotarse o caducar.
- **Escaneo de productos:** Cámara para leer códigos de barras.
- **Subida de imágenes:** Integración con Cloudinary para imágenes de productos.
- **Autenticación:** Login, registro y recuperación de PIN con verificación por correo.
- **Interfaz intuitiva:** Navegación por pestañas (Inventario, Ventas, Clientes, Reportes, Configuración).

## 🛠️ Tecnologías

- **Framework:** Flutter 3.44+ (Dart)
- **Base de datos:** PostgreSQL (Neon)
- **Arquitectura:** Feature-based con capas y Service Locator
- **State management:** Provider
- **Navegación:** GoRouter
- **Autenticación:** Login, registro y recuperación de PIN por correo
- **Almacenamiento de imágenes:** Cloudinary
- **Escaneo de códigos de barras**
- **Generación de PDF y boletas**
- **Notificaciones locales**
- **Backup en Google Drive**
- **Testing:** Unitarios, integración, widgets, páginas y E2E
- **CI/CD:** GitHub Actions (APK automático)
- **Targets:** Android, iOS, Linux, Windows, Web

## 🧪 Testing

- **Unit tests:** Services, controllers
- **Integration tests:** Persistencia contra DB real
- **Widget tests:** Componentes individuales
- **Page tests:** Páginas completas con GoRouter
- **E2E tests:** Flujos completos contra BD real con `integration_test`

## 📁 Estructura del proyecto

```
lib/
├── features/               # Módulos por feature
│   ├── auth/               # Autenticación
│   ├── clients/            # Clientes
│   ├── config/             # Configuración
│   ├── inventory/          # Inventario (productos, lotes, categorías, unidades)
│   ├── notifications/      # Notificaciones
│   ├── reports/            # Reportes
│   └── sales/              # Ventas (ventas, pagos)
└── shared/                 # Código compartido
    ├── di/                 # Service Locator + módulos
    ├── exceptions/         # Excepciones personalizadas
    ├── pages/              # Páginas compartidas (Home, ReportResults, PDFViewer)
    ├── services/           # Servicios compartidos (Cloudinary, Print, Mailer)
    ├── theme/              # Colores, botones, inputs
    ├── utils/              # PostgresDatasource, PgHelper, DialogMessages
    └── widgets/            # Widgets reutilizables
```

## ⚙️ Configuración local

Requisitos: Flutter 3.44+, JDK 17, Android SDK.

```bash
# 1. Clonar
git clone https://github.com/davguzm20/iVenti.git
cd iVenti

# 2. Variables de entorno
cp .env.example .env
# Editar .env con las credenciales reales

# 3. Instalar dependencias
flutter pub get

# 4. Ejecutar en modo debug
flutter run
```

## 📱 Generar APK

### APK de debug (para pruebas locales)

```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### APK de release (firma propia)

```bash
# 1. Generar keystore (solo la primera vez)
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# 2. Crear android/key.properties
# storePassword=...
# keyPassword=...
# keyAlias=release
# storeFile=../release-keystore.jks

# 3. Build release
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## 📦 Release

Descarga la ultima version del APK desde [GitHub Releases](https://github.com/davguzm20/iVenti/releases/tag/latest).

## 📲 Ejecutar en emulador

```bash
# Listar dispositivos disponibles
flutter devices

# Iniciar un emulador específico
flutter emulators --launch <nombre_emulador>

# Ejecutar la app en un dispositivo específico
flutter run -d <device_id>

# Build + instalar directamente en emulador conectado
flutter run --release

# Instalar APK ya generado en emulador/dispositivo conectado
flutter install
```

## 🔐 Variables de entorno (`.env`)

| Variable | Descripción | Valor `.env.example` |
|---|---|---|
| `PGHOST` | Host de PostgreSQL (Neon) | `example_host` |
| `PGPORT` | Puerto | `example_port` |
| `PGDATABASE` | Base de datos | `example_db` |
| `PGUSER` | Usuario BD | `example_user` |
| `PGPASSWORD` | Contraseña BD | `example_password` |
| `SMTP_EMAIL` | Correo SMTP | `example@gmail.com` |
| `SMTP_PASSWORD` | Contraseña de aplicación SMTP | `example_password` |
| `CLOUDINARY_URL` | URL Cloudinary | `example_cloudinary_url` |
