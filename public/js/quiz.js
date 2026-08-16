document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const level = urlParams.get('level') || 'n5';
    
    const levelTitle = document.getElementById('level-title');
    levelTitle.textContent = `JLPT ${level.toUpperCase()} Challenge`;

    let allVocab = [];
    let questions = [];
    let currentQuestionIndex = 0;
    let score = 0;
    const totalQuestions = 10;

    // Elements
    const spinner = document.getElementById('loading-spinner');
    const quizContainer = document.getElementById('quiz-container');
    const resultsContainer = document.getElementById('results-container');
    const quizWord = document.getElementById('quiz-word');
    const optionsGrid = document.getElementById('options-grid');
    const feedback = document.getElementById('feedback');
    const nextBtn = document.getElementById('next-btn');
    const scoreDisplay = document.getElementById('score');
    const totalDisplay = document.getElementById('total');
    const finalScoreDisplay = document.getElementById('final-score');
    const finalTotalDisplay = document.getElementById('final-total');
    const restartBtn = document.getElementById('restart-btn');

    totalDisplay.textContent = totalQuestions;
    finalTotalDisplay.textContent = totalQuestions;

    // Fetch vocabulary data
    fetch(`data/jlpt_${level}_vocab.json`)
        .then(response => {
            if (!response.ok) throw new Error('Data not found');
            return response.json();
        })
        .then(data => {
            allVocab = data;
            startQuiz();
        })
        .catch(error => {
            console.error('Error loading vocabulary:', error);
            spinner.textContent = 'Error loading quiz data. Please try again.';
        });

    function startQuiz() {
        score = 0;
        currentQuestionIndex = 0;
        scoreDisplay.textContent = score;
        
        // Generate random questions
        questions = [];
        const shuffled = [...allVocab].sort(() => 0.5 - Math.random());
        const selected = shuffled.slice(0, totalQuestions);
        
        selected.forEach(correctItem => {
            // Get 3 wrong options
            const wrongOptions = [];
            while(wrongOptions.length < 3) {
                const randomItem = allVocab[Math.floor(Math.random() * allVocab.length)];
                if (randomItem.word !== correctItem.word && !wrongOptions.includes(randomItem)) {
                    wrongOptions.push(randomItem);
                }
            }
            
            // Format options (using meaning)
            const options = [
                { text: correctItem.meaning.join(', '), isCorrect: true },
                ...wrongOptions.map(w => ({ text: w.meaning.join(', '), isCorrect: false }))
            ];
            
            // Shuffle options
            questions.push({
                word: correctItem.word,
                pronunciation: correctItem.pronunciation,
                options: options.sort(() => 0.5 - Math.random())
            });
        });

        spinner.classList.add('hidden');
        resultsContainer.classList.add('hidden');
        quizContainer.classList.remove('hidden');
        
        loadQuestion();
    }

    function loadQuestion() {
        feedback.classList.add('hidden');
        nextBtn.classList.add('hidden');
        optionsGrid.innerHTML = '';
        
        const q = questions[currentQuestionIndex];
        
        quizWord.innerHTML = `${q.word}<div style="font-size: 1.5rem; color: #6b7280; font-weight: normal; margin-top: 0.5rem">${q.pronunciation}</div>`;
        
        q.options.forEach(opt => {
            const btn = document.createElement('button');
            btn.className = 'option-btn';
            btn.textContent = opt.text;
            btn.addEventListener('click', () => selectOption(btn, opt.isCorrect));
            optionsGrid.appendChild(btn);
        });
    }

    function selectOption(selectedBtn, isCorrect) {
        // Disable all buttons
        const allBtns = optionsGrid.querySelectorAll('.option-btn');
        allBtns.forEach(btn => btn.disabled = true);
        
        feedback.classList.remove('hidden');
        feedback.classList.remove('success', 'error');
        
        if (isCorrect) {
            selectedBtn.classList.add('correct');
            feedback.textContent = 'Correct! 🎉';
            feedback.classList.add('success');
            score++;
            scoreDisplay.textContent = score;
        } else {
            selectedBtn.classList.add('wrong');
            feedback.textContent = 'Incorrect 😢';
            feedback.classList.add('error');
            
            // Highlight correct option
            allBtns.forEach(btn => {
                const q = questions[currentQuestionIndex];
                const correctOpt = q.options.find(o => o.isCorrect);
                if (btn.textContent === correctOpt.text) {
                    btn.classList.add('correct');
                }
            });
        }
        
        nextBtn.classList.remove('hidden');
    }

    nextBtn.addEventListener('click', () => {
        currentQuestionIndex++;
        if (currentQuestionIndex < totalQuestions) {
            loadQuestion();
        } else {
            showResults();
        }
    });

    function showResults() {
        quizContainer.classList.add('hidden');
        resultsContainer.classList.remove('hidden');
        finalScoreDisplay.textContent = score;
    }

    restartBtn.addEventListener('click', () => {
        spinner.classList.remove('hidden');
        resultsContainer.classList.add('hidden');
        startQuiz();
    });
});
