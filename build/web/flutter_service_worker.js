'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "8ee40ca23b905a6c39b45f9138e04523",
"assets/AssetManifest.bin.json": "4d0efdeaa34580d642fac64c9aababcb",
"assets/AssetManifest.json": "ccaa12cf8697bcac4f0f05df13af7b64",
"assets/assets/fonts/sansserifflf-demibold.otf": "233d44963375e256fd3f1a6764050ca4",
"assets/assets/icons/back-arrow.svg": "9271e70143c908e85e21117562c15684",
"assets/assets/icons/bookmark-black-outline.svg": "e14bc8b095c52ef383e216119bfa272f",
"assets/assets/icons/bookmark-black-shape.svg": "835374d7a396af511d7d3298f97e0642",
"assets/assets/icons/comment-option-outline.svg": "ed3d78104e6d2f5b9d0bc490069cc479",
"assets/assets/icons/comment-option.svg": "31a4185cfa6ac16acaf0e592427f8f80",
"assets/assets/icons/comment.svg": "31a4185cfa6ac16acaf0e592427f8f80",
"assets/assets/icons/discover-outline.svg": "9bd61519d3baf902a78b257be89903e5",
"assets/assets/icons/discover.svg": "885407e524e14639ed244e59776ed61b",
"assets/assets/icons/dots.svg": "cd342ef2e50b214973e28e58ef099e91",
"assets/assets/icons/heart-shape-outine.svg": "662813b197486399f3bff41c1ac1e174",
"assets/assets/icons/heart-shape-silhouette.svg": "2945d64e61df3b7fa41673c5bb5f2eba",
"assets/assets/icons/home-outline.svg": "dc9d5d1f036e4f2e1ced2b324591954f",
"assets/assets/icons/home.svg": "e70892678e4750e011e8b3617dd72898",
"assets/assets/icons/mail-outline.svg": "90b81023431b0c07add3e6d246bb629b",
"assets/assets/icons/mail.svg": "4666efd01d6feef8c60acbaa82b876d0",
"assets/assets/icons/menu.svg": "5ea33d956ae519c8376aa2f7c1750cec",
"assets/assets/icons/notification.svg": "df7be42adae9d935efc0c27a29217d95",
"assets/assets/icons/plane.svg": "f0a12f9d4d4750ae9f0430126cc5c9ba",
"assets/assets/icons/plane_outline.svg": "f1ad5c5d1e1557b0fe71c58d134d711f",
"assets/assets/icons/profile-outline.svg": "61dc1aa5be19a801c058f57d1483469d",
"assets/assets/icons/profile.svg": "834f6a9b130a5c2a428147a99d6d7178",
"assets/assets/icons/search.svg": "9eac7b27e33f759fafe3a3612740ca56",
"assets/assets/icons/side-bar.svg": "be513e7aa31c3540b1acde889bc53bcf",
"assets/assets/icons/tick.svg": "90ab4ba2b47cdb6f43a5526b2d01bf82",
"assets/assets/icons/two%2520dots.svg": "208963ca740554a419211c516617dd1e",
"assets/assets/images/avtar.jpg": "ef3709aeb9ef12f9ed8772ecc65e5587",
"assets/assets/images/dm0.jpg": "8e9ee16ea72ea60025e00bdf11cdc2ff",
"assets/assets/images/dm1.jpg": "021feb74cb6efd68a3a442e03ee16576",
"assets/assets/images/dm2.jpg": "1bee1000295107c50a0786d96b9979a2",
"assets/assets/images/dm3.jpg": "6f94b9f011dc40d2d5d2971074249840",
"assets/assets/images/px0.jpg": "b5745f9a010156d06f211e102ba8af6d",
"assets/assets/images/px1.jpg": "8239f755769287d011d5cfcd9f837636",
"assets/assets/images/px2.jpg": "3cd780a301794776ead9bb81ec26f6db",
"assets/assets/images/px3.jpg": "d9e323cfd005848c515d41c10e9e207e",
"assets/assets/images/px4.jpg": "6dc96493faa3c4dfcaabad4460f89ac9",
"assets/assets/images/px5.jpg": "5ec7f644b7366c7cf0130f7f2be15908",
"assets/assets/images/px6.jpg": "a5912224121d6d794ba3c0f34d7827e6",
"assets/FontManifest.json": "3002d9886706d6276f0d8160ac9735b7",
"assets/fonts/MaterialIcons-Regular.otf": "5e1075e9ed87d3c4b487a9c428f46591",
"assets/NOTICES": "eb22f05c019fd11b21a1c73ae469e25b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "f692bdd6c40a36888d4986a60662e3af",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "882f7a0ad787bb994ac613ca14b3b6bb",
"/": "882f7a0ad787bb994ac613ca14b3b6bb",
"main.dart.js": "77c20c4a4ead3a87fdeda421d14c7722",
"manifest.json": "4ae21304872976a9b24b3a36943b2ccc",
"service_worker.js": "53b3c68a9d2bcbeb12e88a9aec107b09",
"version.json": "d5ab92c1f0b519d4a96e4841f64ceea8"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
