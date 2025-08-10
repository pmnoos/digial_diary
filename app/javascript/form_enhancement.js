// Form enhancement for better UX
document.addEventListener('DOMContentLoaded', function() {
  // Handle form submissions with loading states
  const forms = document.querySelectorAll('form[action*="diary_entries"]');
  
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      const submitButton = form.querySelector('input[type="submit"], button[type="submit"]');
      
      if (submitButton) {
        // Store original text
        const originalText = submitButton.value || submitButton.textContent;
        
        // Show loading state
        submitButton.disabled = true;
        if (submitButton.type === 'submit' && submitButton.tagName === 'INPUT') {
          submitButton.value = submitButton.dataset.turboSubmitsWith || 'Processing...';
        } else {
          submitButton.textContent = submitButton.dataset.turboSubmitsWith || 'Processing...';
        }
        
        // Add loading spinner
        submitButton.classList.add('is-loading');
        
        // Re-enable after timeout as fallback
        setTimeout(() => {
          submitButton.disabled = false;
          submitButton.classList.remove('is-loading');
          if (submitButton.type === 'submit' && submitButton.tagName === 'INPUT') {
            submitButton.value = originalText;
          } else {
            submitButton.textContent = originalText;
          }
        }, 10000); // 10 second timeout
      }
    });
  });
  
  // Handle rich text editor validation
  const richTextAreas = document.querySelectorAll('trix-editor');
  richTextAreas.forEach(editor => {
    editor.addEventListener('trix-change', function() {
      // Clear any previous validation errors when user starts typing
      const errorDiv = document.querySelector('.notification.is-danger');
      if (errorDiv && editor.editor.getDocument().toString().trim().length > 0) {
        errorDiv.style.display = 'none';
      }
    });
  });
  
  // Enhanced image preview with validation feedback
  const imageInputs = document.querySelectorAll('input[type="file"][accept*="image"]');
  imageInputs.forEach(input => {
    input.addEventListener('change', function(e) {
      const files = Array.from(e.target.files);
      let hasErrors = false;
      let errorMessages = [];
      
      files.forEach(file => {
        // Validate file type
        if (!file.type.match(/^image\/(jpeg|jpg|png|gif|webp)$/)) {
          hasErrors = true;
          errorMessages.push(`"${file.name}" is not a supported image format.`);
          return;
        }
        
        // Validate file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
          hasErrors = true;
          errorMessages.push(`"${file.name}" is too large. Please use images under 10MB.`);
          return;
        }
      });
      
      // Show validation errors
      if (hasErrors) {
        const existingError = document.querySelector('.image-upload-error');
        if (existingError) {
          existingError.remove();
        }
        
        const errorDiv = document.createElement('div');
        errorDiv.className = 'notification is-warning image-upload-error mt-2';
        errorDiv.innerHTML = `
          <button class="delete" onclick="this.parentElement.remove()"></button>
          <strong>Image Upload Issues:</strong>
          <ul class="mt-2">
            ${errorMessages.map(msg => `<li>${msg}</li>`).join('')}
          </ul>
        `;
        
        input.parentElement.insertAdjacentElement('afterend', errorDiv);
        
        // Clear the invalid files
        input.value = '';
      } else {
        // Remove any existing error messages
        const existingError = document.querySelector('.image-upload-error');
        if (existingError) {
          existingError.remove();
        }
      }
    });
  });
});
