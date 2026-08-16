document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const level = urlParams.get('level') || 'n5';
    
    const levelTitle = document.getElementById('level-title');
    levelTitle.textContent = `JLPT ${level.toUpperCase()} Vocabulary`;

    const vocabList = document.getElementById('vocab-list');
    const spinner = document.getElementById('loading-spinner');
    const searchInput = document.getElementById('search-input');
    const template = document.getElementById('vocab-card-template');

    let allVocab = [];

    // Fetch vocabulary data
    fetch(`data/jlpt_${level}_vocab.json`)
        .then(response => {
            if (!response.ok) throw new Error('Data not found');
            return response.json();
        })
        .then(data => {
            allVocab = data;
            renderVocab(allVocab);
            spinner.classList.add('hidden');
        })
        .catch(error => {
            console.error('Error loading vocabulary:', error);
            spinner.textContent = 'Error loading vocabulary. Please try again.';
        });

    // Search functionality
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = allVocab.filter(v => 
            v.word.toLowerCase().includes(query) || 
            (v.pronunciation && v.pronunciation.toLowerCase().includes(query)) ||
            (v.meaning && v.meaning.some(m => m.toLowerCase().includes(query)))
        );
        renderVocab(filtered);
    });

    function renderVocab(items) {
        vocabList.innerHTML = '';
        
        // Show max 500 items to prevent lag, we could add pagination if needed
        const displayItems = items.slice(0, 500);

        displayItems.forEach(item => {
            const clone = template.content.cloneNode(true);
            
            clone.querySelector('.vocab-word').textContent = item.word || '';
            clone.querySelector('.vocab-pronunciation').textContent = item.pronunciation || '';
            clone.querySelector('.vocab-meaning').textContent = item.meaning ? item.meaning.join(', ') : '';
            
            vocabList.appendChild(clone);
        });

        if (items.length === 0) {
            vocabList.innerHTML = '<p style="grid-column: 1/-1; text-align: center;">No vocabulary found.</p>';
        } else if (items.length > 500) {
            const msg = document.createElement('p');
            msg.style.gridColumn = '1/-1';
            msg.style.textAlign = 'center';
            msg.style.marginTop = '2rem';
            msg.textContent = `Showing 500 of ${items.length} items. Use search to find more.`;
            vocabList.appendChild(msg);
        }
    }
});
