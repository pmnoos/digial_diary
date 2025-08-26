// Minimal debug script for Trix editor initialization
document.addEventListener('DOMContentLoaded', function() {
  console.log('🔍 Debug: Checking Trix editor status...');
  
  // Check if Trix is available
  if (typeof Trix !== 'undefined') {
    console.log('✅ Trix is loaded and available');
  } else {
    console.log('❌ Trix is not loaded');
  }
  
  // Check for trix-editor elements
  const trixEditors = document.querySelectorAll('trix-editor');
  console.log(`🔍 Found ${trixEditors.length} trix-editor elements`);
  
  // Also check on Turbo navigation
  document.addEventListener('turbo:load', function() {
    console.log('🔄 Turbo load detected, re-checking Trix editor...');
    setTimeout(() => {
      const trixEditors = document.querySelectorAll('trix-editor');
      console.log(`📝 After Turbo load: Found ${trixEditors.length} trix-editor elements`);
    }, 100);
  });
});