// Digital Diary PWA Service Worker - Enhanced Version
const CACHE_NAME = 'digital-diary-v2';
const OFFLINE_URL = '/';
const OFFLINE_ENTRIES_URL = '/diary_entries';

// Essential resources to cache
const urlsToCache = [
  '/',
  '/diary_entries',
  '/diary_entries/new',
  '/manifest.json',
  '/icon.png',
  // Add CSS and JS that are critical
  // These will be automatically added during runtime
];

// Install event - cache essential resources
self.addEventListener('install', (event) => {
  console.log('Service Worker installing...');
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Caching essential resources');
      return cache.addAll(urlsToCache).catch(error => {
        console.error('Failed to cache some resources:', error);
        // Continue even if some resources fail to cache
      });
    })
  );
  self.skipWaiting();
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('Service Worker activating...');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Fetch event - enhanced offline strategy
self.addEventListener('fetch', (event) => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') {
    return;
  }

  // Handle navigation requests (page loads)
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request)
        .then(response => {
          // If online, cache the response
          if (response.ok) {
            const responseClone = response.clone();
            caches.open(CACHE_NAME).then(cache => {
              cache.put(event.request, responseClone);
            });
          }
          return response;
        })
        .catch(() => {
          // If offline, try to serve from cache
          return caches.open(CACHE_NAME).then(cache => {
            return cache.match(event.request).then(cachedResponse => {
              if (cachedResponse) {
                return cachedResponse;
              }
              // Fallback to offline page
              if (event.request.url.includes('/diary_entries')) {
                return cache.match(OFFLINE_ENTRIES_URL) || cache.match(OFFLINE_URL);
              }
              return cache.match(OFFLINE_URL);
            });
          });
        })
    );
    return;
  }

  // Handle other requests (assets, API calls, etc.)
  event.respondWith(
    caches.match(event.request).then(cachedResponse => {
      if (cachedResponse) {
        return cachedResponse;
      }

      return fetch(event.request).then(response => {
        // Don't cache non-ok responses
        if (!response.ok) {
          return response;
        }

        // Cache successful responses
        const responseClone = response.clone();
        caches.open(CACHE_NAME).then(cache => {
          cache.put(event.request, responseClone);
        });

        return response;
      }).catch(error => {
        console.log('Fetch failed:', error);
        // For images, return a placeholder or nothing
        if (event.request.destination === 'image') {
          return new Response('', { status: 200, statusText: 'OK' });
        }
        throw error;
      });
    })
  );
});

// Background sync for offline form submissions (future enhancement)
self.addEventListener('sync', (event) => {
  if (event.tag === 'diary-entry-sync') {
    event.waitUntil(syncDiaryEntries());
  }
});

async function syncDiaryEntries() {
  // This would handle syncing offline-created entries when back online
  console.log('Background sync for diary entries');
}

// Push notification support
self.addEventListener('push', (event) => {
  const options = {
    body: event.data ? event.data.text() : 'New diary reminder',
    icon: '/icon.png',
    badge: '/icon.png',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    },
    actions: [
      {
        action: 'explore',
        title: 'Open Diary',
        icon: '/icon.png'
      },
      {
        action: 'close',
        title: 'Close',
        icon: '/icon.png'
      }
    ]
  };

  event.waitUntil(
    self.registration.showNotification('Digital Diary', options)
  );
});

// Handle notification clicks
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  if (event.action === 'explore') {
    event.waitUntil(
      clients.openWindow('/')
    );
  } else if (event.action === 'close') {
    // Just close the notification
  } else {
    // Default action - open the app
    event.waitUntil(
      clients.matchAll({ type: 'window' }).then((clientList) => {
        for (let i = 0; i < clientList.length; i++) {
          const client = clientList[i];
          if (client.url === '/' && 'focus' in client) {
            return client.focus();
          }
        }
        if (clients.openWindow) {
          return clients.openWindow('/');
        }
      })
    );
  }
});
