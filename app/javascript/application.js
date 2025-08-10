// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Action Text support
import "trix"
import "@rails/actiontext"

// PWA functionality
let deferredPrompt;

// Service Worker registration
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js')
      .then(reg => {
        console.log('✅ Service Worker registered:', reg);
        
        // Check for updates
        reg.addEventListener('updatefound', () => {
          const newWorker = reg.installing;
          newWorker.addEventListener('statechange', () => {
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              // New content is available, ask user to refresh
              if (confirm('New version available! Click OK to update.')) {
                window.location.reload();
              }
            }
          });
        });
      })
      .catch(err => console.error('❌ Service Worker registration failed:', err));
  });
}

// PWA Install functionality
window.addEventListener('beforeinstallprompt', (e) => {
  console.log('PWA install prompt triggered');
  e.preventDefault();
  deferredPrompt = e;
  
  // Show install banner
  const installBanner = document.getElementById('pwa-install-banner');
  if (installBanner) {
    installBanner.style.display = 'block';
  }
});

// Install button functionality
document.addEventListener('DOMContentLoaded', () => {
  const installButton = document.getElementById('install-pwa-button');
  const dismissButton = document.getElementById('dismiss-install-banner');
  const installBanner = document.getElementById('pwa-install-banner');
  
  if (installButton) {
    installButton.addEventListener('click', async () => {
      if (deferredPrompt) {
        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;
        console.log(`PWA install ${outcome}`);
        deferredPrompt = null;
        installBanner.style.display = 'none';
      }
    });
  }
  
  if (dismissButton) {
    dismissButton.addEventListener('click', () => {
      installBanner.style.display = 'none';
      // Remember that user dismissed the banner
      localStorage.setItem('pwa-install-dismissed', 'true');
    });
  }
  
  // Check if user previously dismissed the banner
  if (localStorage.getItem('pwa-install-dismissed') === 'true') {
    if (installBanner) {
      installBanner.style.display = 'none';
    }
  }
  
  // Hide banner if already installed
  if (window.matchMedia('(display-mode: standalone)').matches || 
      window.navigator.standalone === true) {
    if (installBanner) {
      installBanner.style.display = 'none';
    }
  }
});

// Online/Offline status handling
window.addEventListener('online', () => {
  console.log('App is online');
  // Show a subtle notification that we're back online
  showNetworkStatus('Online', 'is-success');
});

window.addEventListener('offline', () => {
  console.log('App is offline');
  // Show offline notification
  showNetworkStatus('Offline - Working in offline mode', 'is-warning');
});

function showNetworkStatus(message, type) {
  // Remove existing notifications
  const existingNotifications = document.querySelectorAll('.network-status-notification');
  existingNotifications.forEach(notification => notification.remove());
  
  // Create new notification
  const notification = document.createElement('div');
  notification.className = `notification ${type} network-status-notification`;
  notification.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 300px;';
  notification.innerHTML = `
    <button class="delete"></button>
    <strong>${message}</strong>
  `;
  
  document.body.appendChild(notification);
  
  // Auto-dismiss after 3 seconds
  setTimeout(() => {
    notification.remove();
  }, 3000);
  
  // Manual dismiss
  notification.querySelector('.delete').addEventListener('click', () => {
    notification.remove();
  });
}

// Request notification permission (optional)
if ('Notification' in window && 'serviceWorker' in navigator) {
  // You can add notification request logic here if needed for future features
}
