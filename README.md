# Flutter Social App UI Kit

Este proyecto es una aplicación social desarrollada con Flutter que es compatible con web y dispositivos móviles. A continuación, se describen los pasos para configurar, ejecutar y desplegar el proyecto en cualquier entorno compatible.

## Requisitos previos

Antes de comenzar, asegúrate de tener lo siguiente instalado en tu sistema:

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versión recomendada: `3.x.x` o superior).
2. Un editor de código como [Visual Studio Code](https://code.visualstudio.com/).
3. [Node.js](https://nodejs.org/) (para servir la app web localmente, opcional).
4. Git (para clonar el proyecto desde un repositorio, si es necesario).

## Instalación

### Paso 1: Clonar el repositorio (opcional)
### Si estás obteniendo el código desde un repositorio remoto, usa:
```bash
git clone <URL_DEL_REPOSITORIO>
```

Cambia al directorio del proyecto:
```bash
cd flutter_social_app_ui_kit
```

### Paso 2: Configurar Flutter
Asegúrate de que Flutter esté correctamente instalado ejecutando:

```bash
flutter doctor
```

Verifica que todos los componentes necesarios estén instalados (Dart SDK, soporte para dispositivos web, etc.).
Si no tienes habilitado el soporte para web, actívalo con:
flutter config --enable-web

### Paso 3: Instalar las dependencias
En el directorio del proyecto, instala las dependencias ejecutando:

```bash
flutter pub get
```

### Paso 4: Ejecutar la aplicación
Puedes ejecutar la aplicación en diferentes entornos según tus necesidades:
En dispositivos móviles (Android/iOS):
Conecta un dispositivo físico o emulador y ejecuta:

```bash
flutter run
```
En la web:
Ejecuta el proyecto directamente en el navegador:
```bash
flutter run -d chrome
```
Construcción para producción
Para preparar la aplicación para un entorno de producción:
Compilar para Web
Compila la aplicación:
```bash
flutter build web
```
Los archivos generados estarán en la carpeta build/web.
Servir la app web localmente
Instala un servidor local como http-server:
```bash
npm install -g http-server
```
Sirve los archivos generados:
```bash
http-server build/web
```
Abre el navegador en la URL proporcionada, generalmente 
```bash
http://127.0.0.1:8080.
```
### Despliegue
Puedes usar cualquier servicio de hosting para desplegar la aplicación web. Aquí tienes algunas opciones:

### Netlify
Inicia sesión en Netlify.
Crea un nuevo proyecto y selecciona la carpeta build/web como tu directorio de salida.
### Vercel
Inicia sesión en Vercel.
Sube la carpeta build/web y sigue las instrucciones de configuración.
### GitHub Pages
Sube la carpeta build/web a un repositorio en GitHub.
Configura GitHub Pages para servir la aplicación desde la carpeta build/web.
Personalización
Cambiar íconos y estilos
Personaliza los íconos de tu app en el archivo web/manifest.json.
Modifica colores y estilos en web/index.html y en los temas definidos en Flutter.
Agregar funcionalidad offline
El archivo flutter_service_worker.js gestiona la funcionalidad offline de tu PWA.
Asegúrate de probarla desconectando la red para verificar que los recursos se cargan desde la caché.
### Recursos
Documentación de Flutter
Guía de Progressive Web Apps
### Contribuciones
Si deseas contribuir al proyecto, crea un fork del repositorio y envía un pull request con tus cambios.