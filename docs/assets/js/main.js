// Sidebar Mobile Toggle
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.querySelector('.sidebar');
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    
    if (sidebarToggle && sidebar && sidebarOverlay) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            sidebarOverlay.classList.toggle('active');
        });
        
        sidebarOverlay.addEventListener('click', function() {
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
        });
        
        // Close sidebar when clicking on a link (mobile)
        sidebar.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth < 1024) {
                    sidebar.classList.remove('active');
                    sidebarOverlay.classList.remove('active');
                }
            });
        });
    }
    
    // Theme Toggle
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = themeToggle?.querySelector('i');
    const themeText = themeToggle?.querySelector('span');
    
    if (themeToggle) {
        // Check for saved theme or prefer-color-scheme
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const savedTheme = localStorage.getItem('theme');
        
        if (savedTheme === 'dark' || (!savedTheme && prefersDark)) {
            document.body.classList.add('dark-theme');
            updateThemeButton(true);
        }
        
        themeToggle.addEventListener('click', function() {
            const isDark = document.body.classList.toggle('dark-theme');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
            updateThemeButton(isDark);
        });
        
        function updateThemeButton(isDark) {
            if (themeIcon) {
                themeIcon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
            }
            if (themeText) {
                themeText.textContent = isDark ? 'Light Mode' : 'Dark Mode';
            }
        }
    }
    
    // Back to Top Button
    const backToTop = document.getElementById('backToTop');
    
    if (backToTop) {
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTop.style.opacity = '1';
                backToTop.style.visibility = 'visible';
            } else {
                backToTop.style.opacity = '0';
                backToTop.style.visibility = 'hidden';
            }
        });
        
        backToTop.addEventListener('click', function(e) {
            e.preventDefault();
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
    
    // Search Functionality
    const searchInput = document.getElementById('docSearch');
    
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            
            // This would normally search through your content
            // For now, just highlight matching items
            document.querySelectorAll('.nav-links a').forEach(link => {
                const text = link.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    link.style.backgroundColor = 'rgba(57, 108, 112, 0.3)';
                } else {
                    link.style.backgroundColor = '';
                }
            });
        });
    }
    
    // Collapsible Sections (optional)
    const collapsibleSections = document.querySelectorAll('.nav-section.collapsible');
    
    collapsibleSections.forEach(section => {
        const header = section.querySelector('h3');
        header.addEventListener('click', function() {
            section.classList.toggle('collapsed');
        });
    });
    
    // Active link highlighting
    function setActiveNavItem() {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-links a').forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === currentPath || 
                currentPath.includes(link.getAttribute('href'))) {
                link.classList.add('active');
            }
        });
    }
    
    setActiveNavItem();
});