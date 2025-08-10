// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Action Text support
import "trix"
import "@rails/actiontext"

// Import form enhancements
import "./form_enhancement.js"
import "./image_upload.js"

// PWA functionality
let deferredPrompt;
let updateAvailable = false;
let refreshing = false;

// Service Worker registration
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js')
      .then(reg => {
        console.log('✅ Service Worker registered:', reg);
        
        // Check for updates
        reg.addEventListener('updatefound', () => {
          const newWorker = reg.installing;
          console.log('New service worker found, installing...');
          
          newWorker.addEventListener('statechange', () => {
            console.log('Service worker state changed to:', newWorker.state);
            
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              // New content is available
              if (!updateAvailable) {
                updateAvailable = true;
                console.log('New content available, showing update notification');
                showUpdateAvailable();
              }
            }
          });
        });
        
        // Listen for the controlling service worker changing
        let refreshing = false;
        navigator.serviceWorker.addEventListener('controllerchange', () => {
          if (refreshing) return;
          refreshing = true;
          console.log('Service worker controller changed, reloading page');
          window.location.reload();
        });
        
      })
      .catch(err => console.error('❌ Service Worker registration failed:', err));
  });
}

function showUpdateAvailable() {
  // Remove any existing update notifications
  const existingNotifications = document.querySelectorAll('.update-notification');
  existingNotifications.forEach(notification => notification.remove());
  
  // Create new update notification
  const notification = document.createElement('div');
  notification.className = 'notification is-info update-notification';
  notification.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 350px;';
  notification.innerHTML = `
    <button class="delete" onclick="this.parentElement.remove()"></button>
    <div class="content">
      <strong>🔄 App Update Available!</strong>
      <p>A new version of Digital Diary is ready. Click below to update.</p>
      <div class="buttons">
        <button class="button is-primary is-small" onclick="updateApp()">
          <span class="icon"><i class="fas fa-sync-alt"></i></span>
          <span>Update Now</span>
        </button>
        <button class="button is-light is-small" onclick="this.closest('.notification').remove()">
          Later
        </button>
      </div>
    </div>
  `;
  
  document.body.appendChild(notification);
}

function updateApp() {
  // Send a message to the service worker to skip waiting
  if (navigator.serviceWorker.controller) {
    navigator.serviceWorker.controller.postMessage({action: 'skipWaiting'});
  }
  
  // Remove the notification
  const notification = document.querySelector('.update-notification');
  if (notification) {
    notification.remove();
  }
  
  // Show loading message
  showNetworkStatus('Updating app...', 'is-info');
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
        if (installBanner) {
          installBanner.style.display = 'none';
        }
      }
    });
  }
  
  if (dismissButton) {
    dismissButton.addEventListener('click', () => {
      if (installBanner) {
        installBanner.style.display = 'none';
      }
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
  showNetworkStatus('Back online! 🌐', 'is-success');
});

window.addEventListener('offline', () => {
  console.log('App is offline');
  // Show offline notification
  showNetworkStatus('Working offline 📡', 'is-warning');
});

function showNetworkStatus(message, type) {
  // Remove existing notifications of the same type
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
    if (notification.parentNode) {
      notification.remove();
    }
  }, 3000);
  
  // Manual dismiss
  notification.querySelector('.delete').addEventListener('click', () => {
    notification.remove();
  });
}

// Make updateApp function globally available
window.updateApp = updateApp;

// Request notification permission (optional)
if ('Notification' in window && 'serviceWorker' in navigator) {
  // You can add notification request logic here if needed for future features
}
