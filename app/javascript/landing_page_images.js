function handleDrop(event) {
    event.preventDefault();
    event.stopPropagation();
  
    const droppedFiles = event.dataTransfer.files;
    if (!droppedFiles.length) return;
  
    uploadFiles(droppedFiles);
  }
  
  function handleDragOver(event) {
    event.preventDefault();
    event.stopPropagation();
  }
  
  /**
   * Iterates over dropped files to upload them one by one.
   */
  function uploadFiles(files) {
    for (const file of files) {
      const formData = new FormData();
      // Clean filename by replacing spaces with underscores and removing periods except for extension
      const fileNameParts = file.name.split('.');
      const extension = fileNameParts.pop();
      const cleanedName = fileNameParts.join('').replace(/[\s.]+/g, '_');
      const cleanedFile = new File([file], `${cleanedName}.${extension}`, { type: file.type });
      formData.append("file", cleanedFile);

      fetch(`/categories/${categoryId}/landing_page_images`, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
          "Accept": "application/json",
        },
        body: formData
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            addImageToGallery(data.filename, data.url);
          } else {
            alert(`Failed to upload image: ${data.error}`);
          }
        })
        .catch(error => {
          console.error("Error uploading:", error);
          alert("Error uploading file. Please try again.");
        });
    }
  }
  
  /**
   * Dynamically adds a newly uploaded image to the page.
   */
  function addImageToGallery(filename, url) {
    const container = document.createElement("div");
    container.classList.add("relative", "group");
  
    container.innerHTML = `
      <button
        onclick="deleteImage('${filename}', this.parentElement)"
        class="absolute top-0 right-0 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center font-bold z-10 opacity-0 group-hover:opacity-100 transition-opacity"
      >
        ×
      </button>
      <img
        src="${url}"
        alt="${filename}"
        title="${filename}"
        class="w-32 h-32 object-cover border rounded hover:border-blue-500 transition-colors cursor-pointer"
        onclick="showFullImage('${url}', '${filename}')"
      />
      <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white text-xs p-1 truncate">
        ${filename}
      </div>
    `;
  
    const imagesContainer = document.getElementById("landing-page-images-container");
    if (imagesContainer) {
      imagesContainer.appendChild(container);
    }
  }
  
  // Attach drag events
  const dropZone = document.getElementById("landing-page-drop-zone");
  if (dropZone) {
    dropZone.addEventListener("dragover", handleDragOver);
    dropZone.addEventListener("drop", handleDrop);
  }