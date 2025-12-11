// Mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const mobileMenu = document.getElementById('mobileMenu');
    
    if (mobileMenuBtn && mobileMenu) {
        mobileMenuBtn.addEventListener('click', function() {
            mobileMenu.classList.toggle('active');
        });
        
        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!mobileMenu.contains(event.target) && 
                !mobileMenuBtn.contains(event.target) && 
                mobileMenu.classList.contains('active')) {
                mobileMenu.classList.remove('active');
            }
        });
    }
    
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href === '#') return;
            
            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
                
                // Close mobile menu if open
                if (mobileMenu && mobileMenu.classList.contains('active')) {
                    mobileMenu.classList.remove('active');
                }
            }
        });
    });
    
    // Copy code blocks
    document.querySelectorAll('pre code').forEach(codeBlock => {
        const pre = codeBlock.parentElement;
        const copyBtn = document.createElement('button');
        copyBtn.className = 'copy-btn';
        copyBtn.innerHTML = '<i class="far fa-copy"></i>';
        copyBtn.title = 'Copy code';
        
        copyBtn.addEventListener('click', function() {
            navigator.clipboard.writeText(codeBlock.textContent).then(() => {
                copyBtn.innerHTML = '<i class="fas fa-check"></i>';
                copyBtn.style.color = 'var(--success-color)';
                setTimeout(() => {
                    copyBtn.innerHTML = '<i class="far fa-copy"></i>';
                    copyBtn.style.color = '';
                }, 2000);
            });
        });
        
        if (pre) {
            pre.style.position = 'relative';
            copyBtn.style.position = 'absolute';
            copyBtn.style.top = '10px';
            copyBtn.style.right = '10px';
            copyBtn.style.background = 'var(--primary-color)';
            copyBtn.style.color = 'white';
            copyBtn.style.border = 'none';
            copyBtn.style.borderRadius = '4px';
            copyBtn.style.padding = '5px 10px';
            copyBtn.style.cursor = 'pointer';
            copyBtn.style.fontSize = '12px';
            pre.appendChild(copyBtn);
        }
    });
    
    // Table of contents generation
    generateTOC();
});

// Generate Table of Contents
function generateTOC() {
    const content = document.querySelector('.content-inner');
    if (!content) return;
    
    const headings = content.querySelectorAll('h2, h3');
    if (headings.length < 3) return; // Only generate TOC if enough headings
    
    const tocContainer = document.createElement('div');
    tocContainer.className = 'toc-container';
    tocContainer.innerHTML = `
        <div class="toc-header">
            <i class="fas fa-list"></i> Table of Contents
        </div>
        <nav class="toc-nav"></nav>
    `;
    
    const tocNav = tocContainer.querySelector('.toc-nav');
    let currentList = tocNav;
    let lastLevel = 2;
    
    headings.forEach((heading, index) => {
        const level = heading.tagName === 'H2' ? 2 : 3;
        const id = heading.id || `heading-${index}`;
        heading.id = id;
        
        const listItem = document.createElement('a');
        listItem.href = `#${id}`;
        listItem.textContent = heading.textContent;
        listItem.className = `toc-item toc-level-${level}`;
        
        if (level === 2) {
            currentList = tocNav;
        } else if (level === 3 && lastLevel === 2) {
            const sublist = document.createElement('div');
            sublist.className = 'toc-sublist';
            currentList.appendChild(sublist);
            currentList = sublist;
        }
        
        currentList.appendChild(listItem);
        lastLevel = level;
    });
    
    // Insert TOC after first h1 or at the beginning
    const firstH1 = content.querySelector('h1');
    if (firstH1) {
        firstH1.parentNode.insertBefore(tocContainer, firstH1.nextSibling);
    } else {
        content.insertBefore(tocContainer, content.firstChild);
    }
}