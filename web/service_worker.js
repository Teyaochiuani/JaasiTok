const CACHE_NAME = 'jasiTok-cache-v2';
const urlsToCache = [
  '/', // Página principal
  '/index.html', // Archivo principal
  '/manifest.json', // Manifest
  '/service_worker.js', // Service Worker
  '/icons/Icon-192.png', // Íconos
  '/icons/Icon-512.png',
  '/icons/Icon-maskable-192.png',
  '/icons/Icon-maskable-512.png',
  '/icons/favicon.png',
  '/flutter.js', // Archivo generado por Flutter para web
  '/flutter_service_worker.js', // Service Worker de Flutter
  '/assets/NOTICES', // Archivos de Flutter
  '/assets/AssetManifest.json',
  '/assets/FontManifest.json',
  '/assets/fonts/MaterialIcons-Regular.otf',
  '/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf',
  '/assets/packages/flutter_icons/fonts/MaterialIcons.ttf',
  '/assets/shaders/ink_sparkle.frag', // Si usas efectos de shader
  // Agrega cualquier otro archivo que estés usando en tu app Flutter
];

// Instalación del Service Worker
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Archivos cacheados con éxito');
      return cache.addAll(urlsToCache);
    })
  );
});

// Activación del Service Worker
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Eliminando cache antiguo:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  return self.clients.claim();
});

// Interceptar solicitudes de red
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      // Devuelve los archivos cacheados si están disponibles
      if (response) {
        return response;
      }

      // Si no están cacheados, intenta buscarlos en la red
      return fetch(event.request).catch(() => {
        // Si no hay conexión a internet, muestra un recurso alternativo
        if (event.request.destination === 'document') {
          return caches.match('/index.html');
        }
      });
    })
  );
});
