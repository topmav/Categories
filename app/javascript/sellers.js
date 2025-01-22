function addSeller() {
  const nameInput = document.querySelector('input[name="seller[name]"]');
  const websiteInput = document.querySelector('input[name="seller[website]"]');
  const sizeInput = document.querySelector('input[name="seller[size]"]');
  const noteInput = document.querySelector('input[name="seller[note]"]');
  const tbody = document.getElementById('sellers-table-body');

  if (!nameInput.value) {
    alert('Please enter a seller name');
    return;
  }

  const formData = new FormData();
  formData.append('seller[name]', nameInput.value);
  formData.append('seller[website]', websiteInput.value);
  formData.append('seller[size]', sizeInput.value);
  formData.append('seller[note]', noteInput.value);

  fetch(`/categories/${categoryId}/sellers`, {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
      'Accept': 'application/json'
    },
    body: formData
  })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        const newRow = document.createElement('tr');
        newRow.dataset.sellerId = data.id;
        newRow.classList.add('seller-row');
        newRow.innerHTML = `
          <td data-view-mode="display" class="px-4 py-2 text-sm text-gray-700">
            <span class="seller-name">${nameInput.value}</span>
          </td>
          <td data-view-mode="display" class="px-4 py-2 text-sm text-gray-700">
            <span class="seller-website">${websiteInput.value}</span>
          </td>
          <td data-view-mode="display" class="px-4 py-2 text-sm text-gray-700">
            <span class="seller-size">${sizeInput.value}</span>
          </td>
          <td data-view-mode="display" class="px-4 py-2 text-sm text-gray-700">
            <span class="seller-note">${noteInput.value}</span>
          </td>
          <td data-view-mode="edit" class="px-4 py-2 hidden" colspan="4">
            <div class="flex flex-wrap items-center gap-2">
              <input type="text" class="edit-seller-name border rounded px-2 py-1" value="${nameInput.value}" placeholder="Name">
              <input type="text" class="edit-seller-website border rounded px-2 py-1" value="${websiteInput.value}" placeholder="Website">
              <input type="text" class="edit-seller-size border rounded px-2 py-1" value="${sizeInput.value}" placeholder="Size">
              <input type="text" class="edit-seller-note border rounded px-2 py-1" value="${noteInput.value}" placeholder="Note">
            </div>
          </td>
          <td class="px-4 py-2 text-right">
            <div data-view-mode="display">
              <a href="#" onclick="toggleEditSeller(${data.id}); return false;" class="text-blue-600 hover:underline">✏️</a>
              <a href="#" onclick="deleteSeller(${data.id}); return false;" class="text-red-600 hover:underline ml-2">❌</a>
            </div>
            <div data-view-mode="edit" class="hidden">
              <button onclick="saveSeller(${data.id})" class="px-3 py-1 bg-green-600 text-white text-sm rounded hover:bg-green-700 mr-1">Save</button>
              <button onclick="cancelSellerEdit(${data.id})" class="px-3 py-1 bg-gray-300 text-sm rounded hover:bg-gray-400">Cancel</button>
            </div>
          </td>
        `;
        const inputRow = document.getElementById('new-seller-row');
        tbody.insertBefore(newRow, inputRow);

        // Clear inputs
        nameInput.value = '';
        websiteInput.value = '';
        sizeInput.value = '';
        noteInput.value = '';
      } else {
        alert('Error adding seller: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error adding seller. Please try again.');
    });
}

function deleteSeller(sellerId) {
  fetch(`/categories/${categoryId}/sellers/${sellerId}`, {
    method: 'DELETE',
    headers: {
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
      'Accept': 'application/json'
    }
  })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        const row = document.querySelector(`tr[data-seller-id="${sellerId}"]`);
        if (row) row.remove();
      } else {
        alert('Error deleting seller: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error deleting seller. Please try again.');
    });
}

function toggleEditSeller(sellerId) {
  const row = document.querySelector(`tr[data-seller-id="${sellerId}"]`);
  if (!row) return;
  row.querySelectorAll('[data-view-mode="display"]').forEach(el => el.classList.add('hidden'));
  row.querySelectorAll('[data-view-mode="edit"]').forEach(el => el.classList.remove('hidden'));
}

function cancelSellerEdit(sellerId) {
  const row = document.querySelector(`tr[data-seller-id="${sellerId}"]`);
  if (!row) return;
  // Hide edit fields
  row.querySelectorAll('[data-view-mode="edit"]').forEach(el => el.classList.add('hidden'));
  row.querySelectorAll('[data-view-mode="display"]').forEach(el => el.classList.remove('hidden'));
}

function saveSeller(sellerId) {
  const row = document.querySelector(`tr[data-seller-id="${sellerId}"]`);
  if (!row) return;

  const newName = row.querySelector('.edit-seller-name').value.trim();
  const newWebsite = row.querySelector('.edit-seller-website').value.trim();
  const newSize = row.querySelector('.edit-seller-size').value.trim();
  const newNote = row.querySelector('.edit-seller-note').value.trim();

  const formData = new FormData();
  formData.append('seller[name]', newName);
  formData.append('seller[website]', newWebsite);
  formData.append('seller[size]', newSize);
  formData.append('seller[note]', newNote);

  fetch(`/categories/${categoryId}/sellers/${sellerId}`, {
    method: 'PATCH',
    headers: {
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
      'Accept': 'application/json'
    },
    body: formData
  })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Update display
        row.querySelector('.seller-name').textContent = newName;
        row.querySelector('.seller-website').textContent = newWebsite;
        row.querySelector('.seller-size').textContent = newSize;
        row.querySelector('.seller-note').textContent = newNote;
        // Toggle back to display mode
        cancelSellerEdit(sellerId);
      } else {
        alert('Error updating seller: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error updating seller. Please try again.');
    });
}

// Attach functions to window so inline event handlers can access them
window.addSeller = addSeller;
window.deleteSeller = deleteSeller;
window.toggleEditSeller = toggleEditSeller;
window.cancelSellerEdit = cancelSellerEdit;
window.saveSeller = saveSeller;