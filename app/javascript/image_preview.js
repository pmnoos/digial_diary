// Simple image preview functionality for diary entries
document.addEventListener('DOMContentLoaded', function() {
  const imageUpload = document.getElementById('image-upload');
  const imagePreview = document.getElementById('image-preview');
  const imageThumbnails = document.getElementById('image-thumbnails');

  if (imageUpload && imagePreview && imageThumbnails) {
    imageUpload.addEventListener('change', function(e) {
      const files = Array.from(e.target.files);
      
      if (files.length > 0) {
        imagePreview.style.display = 'block';
        imageThumbnails.innerHTML = '';
        
        files.forEach((file, index) => {
          if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
              const column = document.createElement('div');
              column.className = 'column is-one-quarter';
              
              column.innerHTML = `
                <div class="card">
                  <div class="card-image">
                    <figure class="image is-4by3">
                      <img src="${e.target.result}" class="is-rounded" alt="Preview">
                    </figure>
                  </div>
                  <div class="card-content">
                    <div class="content">
                      <p class="is-size-7">${file.name}</p>
                      <p class="is-size-7 has-text-grey">${(file.size / 1024 / 1024).toFixed(2)} MB</p>
                    </div>
                  </div>
                </div>
              `;
              
              imageThumbnails.appendChild(column);
            };
            
            reader.readAsDataURL(file);
          }
        });
      } else {
        imagePreview.style.display = 'none';
      }
    });
  }
});
