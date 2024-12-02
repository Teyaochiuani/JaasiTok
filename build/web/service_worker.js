const CACHE_NAME = 'flutter-pwa-cache-v1';
const urlsToCache = [
  './',
  './index.html',
  './main.dart.js',
  './assets/AssetManifest.json',
  './assets/FontManifest.json',
  './icons/icon-192.png', // Ajusta según tus iconos
  './assets/assets/images/px6.jpg', 
];


// Al instalar el service worker, cacheamos las URLs necesarias
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Archivos cacheados');
        return cache.addAll(urlsToCache);
      })
  );
});

// Durante el fetch, servimos el contenido desde el cache si estamos offline
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Si se encuentra una respuesta en el cache, la devolvemos
        if (response) {
          return response;
        }
        
        // Si no hay conexión, se carga la página offline.html
        return fetch(event.request).catch(() => {
          return caches.match('/offline.html');
        });
      })
  );
});