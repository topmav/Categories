// app/javascript/keywords.js

function addKeyword() {
  const keywordInput = document.querySelector('input[name="keyword[keyword]"]');
  const volumeInput = document.querySelector('input[name="keyword[monthly_search_volume]"]');
  const tbody = document.getElementById('keywords-table-body');

  if (!keywordInput.value || !volumeInput.value) {
    alert('Please fill in both keyword and monthly search volume');
    return;
  }

  const formData = new FormData();
  formData.append('keyword[keyword]', keywordInput.value);
  formData.append('keyword[monthly_search_volume]', volumeInput.value);

  fetch(`/categories/${categoryId}/keywords`, {
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
        // Add new row to table
        const newRow = document.createElement('tr');
        newRow.dataset.keywordId = data.id;
        newRow.classList.add('keyword-row');
        newRow.innerHTML = `
          <td data-view-mode="display" class="px-4 py-2 text-sm text-gray-700">
            <span class="keyword-text">${keywordInput.value}</span>
          </td>
          <td data-view-mode="display" class="px-4 py-2 text-sm text-gray-700">
            <span class="volume-text">${volumeInput.value}</span>
          </td>
          <td data-view-mode="edit" class="px-4 py-2 hidden">
            <input type="text" class="edit-keyword w-2/3 mr-1 px-2 py-1 border rounded" value="${keywordInput.value}">
            <input type="number" class="edit-volume w-1/3 px-2 py-1 border rounded" value="${volumeInput.value}">
          </td>
          <td class="px-4 py-2 text-right">
            <div data-view-mode="display">
              <a href="#" onclick="toggleEditKeyword(${data.id}); return false;" class="text-blue-600 hover:underline">✏️</a>
              <a href="#" onclick="deleteKeyword(${data.id}); return false;" class="text-red-600 hover:underline ml-2">❌</a>
            </div>
            <div data-view-mode="edit" class="hidden">
              <button onclick="saveKeyword(${data.id})" class="px-3 py-1 bg-green-600 text-white text-sm rounded hover:bg-green-700 mr-1">Save</button>
              <button onclick="cancelKeywordEdit(${data.id})" class="px-3 py-1 bg-gray-300 text-sm rounded hover:bg-gray-400">Cancel</button>
            </div>
          </td>
        `;
        const inputRow = document.getElementById('new-keyword-row');
        tbody.insertBefore(newRow, inputRow);

        // Clear inputs
        keywordInput.value = '';
        volumeInput.value = '';
      } else {
        alert('Error adding keyword: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error adding keyword. Please try again.');
    });
}

function deleteKeyword(keywordId) {
  fetch(`/categories/${categoryId}/keywords/${keywordId}`, {
    method: 'DELETE',
    headers: {
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
      'Accept': 'application/json'
    }
  })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        const row = document.querySelector(`tr[data-keyword-id="${keywordId}"]`);
        if (row) row.remove();
      } else {
        alert('Error deleting keyword: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error deleting keyword. Please try again.');
    });
}

function toggleEditKeyword(keywordId) {
  const row = document.querySelector(`tr[data-keyword-id="${keywordId}"]`);
  if (!row) return;
  row.querySelectorAll('[data-view-mode="display"]').forEach(el => el.classList.add('hidden'));
  row.querySelectorAll('[data-view-mode="edit"]').forEach(el => el.classList.remove('hidden'));
}

function cancelKeywordEdit(keywordId) {
  const row = document.querySelector(`tr[data-keyword-id="${keywordId}"]`);
  if (!row) return;
  // Hide edit fields
  row.querySelectorAll('[data-view-mode="edit"]').forEach(el => el.classList.add('hidden'));
  row.querySelectorAll('[data-view-mode="display"]').forEach(el => el.classList.remove('hidden'));
}

function saveKeyword(keywordId) {
  const row = document.querySelector(`tr[data-keyword-id="${keywordId}"]`);
  if (!row) return;

  const newKeyword = row.querySelector('.edit-keyword').value.trim();
  const newVolume = row.querySelector('.edit-volume').value.trim();

  const formData = new FormData();
  formData.append('keyword[keyword]', newKeyword);
  formData.append('keyword[monthly_search_volume]', newVolume);

  fetch(`/categories/${categoryId}/keywords/${keywordId}`, {
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
        row.querySelector('.keyword-text').textContent = newKeyword;
        row.querySelector('.volume-text').textContent = newVolume;
        // Toggle back to display mode
        cancelKeywordEdit(keywordId);
      } else {
        alert('Error updating keyword: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error updating keyword. Please try again.');
    });
}

// Attach functions to window so inline event handlers can access them
window.addKeyword = addKeyword;
window.deleteKeyword = deleteKeyword;
window.toggleEditKeyword = toggleEditKeyword;
window.cancelKeywordEdit = cancelKeywordEdit;
window.saveKeyword = saveKeyword;