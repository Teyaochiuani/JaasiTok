const CACHE_NAME = 'JasimpTok-v1';
const FIRESTORE_DYNAMIC_CACHE = 'firestore-dynamic-cache-v1';

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Caching static assets');
      return cache.addAll([
        './',
        './index.html',
        './main.dart.js',
        './assets/AssetManifest.json',
        './assets/FontManifest.json',
        './icons/icon-192.png',
        './icons/icon-512.png',
        './assets/icons/home.svg',
        './assets/icons/home-outline.svg',
        './assets/icons/discover.svg',
        './assets/icons/discover-outline.svg',
        './assets/icons/mail.svg',
        './assets/icons/mail-outline.svg',
        './assets/icons/profile.svg',
        './assets/icons/profile-outline.svg',
        './assets/icons/menu.svg',
      ]);
    })
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME && cache !== FIRESTORE_DYNAMIC_CACHE) {
            console.log('Deleting old cache:', cache);
            return caches.delete(cache);
          }
        })
      );
    })
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method === 'POST') {
    // No manejar solicitudes POST
    return;
  }

  if (event.request.url.includes('firestore.googleapis.com')) {
    event.respondWith(
      caches.open(FIRESTORE_DYNAMIC_CACHE).then((cache) => {
        return fetch(event.request)
          .then((response) => {
            if (response && response.status === 200) {
              cache.put(event.request, response.clone());
            }
            return response;
          })
          .catch(() => {
            return cache.match(event.request);
          });
      })
    );
  } else {
    event.respondWith(
      caches.match(event.request).then((response) => {
        return (
          response ||
          fetch(event.request).catch(() => {
            console.error('Failed to fetch:', event.request.url);
          })
        );
      })
    );
  }
});
