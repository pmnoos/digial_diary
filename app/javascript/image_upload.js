// Image Upload Progress Enhancement
document.addEventListener('DOMContentLoaded', function() {
  const imageUpload = document.getElementById('image-upload');
  const uploadForm = document.querySelector('form');
  
  if (imageUpload && uploadForm) {
    // Create progress indicator
    const progressContainer = document.createElement('div');
    progressContainer.className = 'progress-container mt-3';
    progressContainer.style.display = 'none';
    progressContainer.innerHTML = `
      <div class="field">
        <label class="label">Upload Progress</label>
        <progress class="progress is-primary" value="0" max="100" id="upload-progress">0%</progress>
        <p class="help" id="upload-status">Preparing images...</p>
      </div>
    `;
    
    // Insert after the file input
    imageUpload.parentNode.insertBefore(progressContainer, imageUpload.parentNode.nextSibling);
    
    // File selection handler
    imageUpload.addEventListener('change', function(e) {
      const files = Array.from(e.target.files);
      if (files.length === 0) return;
      
      // Show file preview
      showFilePreview(files);
      
      // Validate files
      validateFiles(files);
    });
    
    // Form submission handler with progress
    uploadForm.addEventListener('submit', function(e) {
      const files = Array.from(imageUpload.files);
      if (files.length > 0) {
        showUploadProgress();
      }
    });
  }
  
  function showFilePreview(files) {
    // Remove existing preview
    const existingPreview = document.querySelector('.file-preview');
    if (existingPreview) {
      existingPreview.remove();
    }
    
    const previewContainer = document.createElement('div');
    previewContainer.className = 'file-preview mt-3';
    
    const previewTitle = document.createElement('p');
    previewTitle.className = 'has-text-weight-semibold';
    previewTitle.textContent = `Selected ${files.length} file(s):`;
    previewContainer.appendChild(previewTitle);
    
    files.forEach((file, index) => {
      const fileInfo = document.createElement('div');
      fileInfo.className = 'box is-small mb-2';
      
      const fileName = document.createElement('span');
      fileName.textContent = file.name;
      fileName.className = 'has-text-weight-medium';
      
      const fileSize = document.createElement('span');
      fileSize.textContent = ` (${formatFileSize(file.size)})`;
      fileSize.className = 'has-text-grey is-size-7';
      
      const fileType = document.createElement('span');
      fileType.className = 'tag is-light is-small ml-2';
      fileType.textContent = file.type.split('/')[1]?.toUpperCase() || 'Unknown';
      
      fileInfo.appendChild(fileName);
      fileInfo.appendChild(fileSize);
      fileInfo.appendChild(fileType);
      
      // Show thumbnail for images
      if (file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function(e) {
          const thumbnail = document.createElement('img');
          thumbnail.src = e.target.result;
          thumbnail.style.cssText = 'width: 60px; height: 60px; object-fit: cover; border-radius: 4px; margin-right: 10px; float: left;';
          fileInfo.insertBefore(thumbnail, fileName);
        };
        reader.readAsDataURL(file);
      }
      
      previewContainer.appendChild(fileInfo);
    });
    
    // Insert preview after upload field
    const uploadField = imageUpload.closest('.field');
    uploadField.parentNode.insertBefore(previewContainer, uploadField.nextSibling);
  }
  
  function validateFiles(files) {
    const maxSize = 10 * 1024 * 1024; // 10MB
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    const errors = [];
    
    files.forEach(file => {
      if (!allowedTypes.includes(file.type)) {
        errors.push(`${file.name}: Invalid file type. Only JPEG, PNG, GIF, and WebP are allowed.`);
      }
      
      if (file.size > maxSize) {
        errors.push(`${file.name}: File too large. Maximum size is 10MB.`);
      }
    });
    
    // Remove existing error messages
    const existingErrors = document.querySelector('.upload-errors');
    if (existingErrors) {
      existingErrors.remove();
    }
    
    if (errors.length > 0) {
      const errorContainer = document.createElement('div');
      errorContainer.className = 'upload-errors notification is-danger mt-3';
      
      const errorTitle = document.createElement('strong');
      errorTitle.textContent = 'Upload Errors:';
      errorContainer.appendChild(errorTitle);
      
      const errorList = document.createElement('ul');
      errorList.className = 'mt-2';
      
      errors.forEach(error => {
        const errorItem = document.createElement('li');
        errorItem.textContent = error;
        errorList.appendChild(errorItem);
      });
      
      errorContainer.appendChild(errorList);
      
      const uploadField = imageUpload.closest('.field');
      uploadField.parentNode.insertBefore(errorContainer, uploadField.nextSibling);
      
      // Disable submit button
      const submitButton = uploadForm.querySelector('input[type="submit"]');
      if (submitButton) {
        submitButton.disabled = true;
        submitButton.classList.add('is-loading');
      }
    } else {
      // Enable submit button
      const submitButton = uploadForm.querySelector('input[type="submit"]');
      if (submitButton) {
        submitButton.disabled = false;
        submitButton.classList.remove('is-loading');
      }
    }
  }
  
  function showUploadProgress() {
    const progressContainer = document.querySelector('.progress-container');
    const progressBar = document.getElementById('upload-progress');
    const statusText = document.getElementById('upload-status');
    
    if (progressContainer) {
      progressContainer.style.display = 'block';
      
      // Simulate upload progress
      let progress = 0;
      const interval = setInterval(() => {
        progress += Math.random() * 15;
        if (progress >= 95) {
          progress = 95;
          clearInterval(interval);
          statusText.textContent = 'Processing images...';
        }
        
        progressBar.value = progress;
        progressBar.textContent = Math.round(progress) + '%';
        
        if (progress < 50) {
          statusText.textContent = 'Uploading images...';
        } else if (progress < 90) {
          statusText.textContent = 'Validating files...';
        }
      }, 200);
    }
  }
  
  function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }
});

// Image modal functionality for gallery
document.addEventListener('DOMContentLoaded', function() {
  // Modal triggers
  const galleryImages = document.querySelectorAll('.gallery-image');
  const modals = document.querySelectorAll('.modal');
  const modalCloses = document.querySelectorAll('.modal-close, .modal-background');
  
  // Open modal when clicking gallery image
  galleryImages.forEach(image => {
    image.addEventListener('click', function() {
      const modalTarget = this.dataset.modalTarget;
      const modal = document.getElementById(modalTarget);
      if (modal) {
        modal.classList.add('is-active');
        document.body.classList.add('is-clipped'); // Prevent background scrolling
      }
    });
  });
  
  // Close modal handlers
  modalCloses.forEach(closeElement => {
    closeElement.addEventListener('click', function() {
      const modalId = this.dataset.modalClose || this.closest('.modal').id;
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.remove('is-active');
        document.body.classList.remove('is-clipped');
      }
    });
  });
  
  // Close modal with Escape key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      modals.forEach(modal => {
        if (modal.classList.contains('is-active')) {
          modal.classList.remove('is-active');
          document.body.classList.remove('is-clipped');
        }
      });
    }
  });
});
