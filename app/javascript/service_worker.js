self.addEventListener('install', function(e) {
  e.waitUntil(
    caches.open('journal-cache').then(function(cache) {
      return cache.addAll([
        '/',
        '/diary_entries',
        '/offline.html'
      ]).catch(function(error) {
        console.error('Failed to cache resources during install:', error);
      });
    }).catch(function(error) {
      console.error('Failed to open cache during install:', error);
    })
  );
});

self.addEventListener('fetch', function(e) {
  e.respondWith(
    fetch(e.request).catch(() =>
      caches.match(e.request).then(function(res) {
        if (res) {
          return res;
        }
        return caches.match('/offline.html');
      })
    )
  );
});
