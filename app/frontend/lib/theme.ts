export type Theme = 'light' | 'dark';

export const getTheme = (): Theme =>
    document.documentElement.classList.contains('dark') ? 'dark' : 'light';

export const setTheme = (t: Theme) => {
    const html = document.documentElement;
    html.classList.toggle('dark', t === 'dark');
    html.setAttribute('data-theme', t);
    localStorage.setItem('theme', t);
    window.dispatchEvent(new CustomEvent('theme:change', { detail: t }));
};

export const toggleTheme = () => setTheme(getTheme() === 'dark' ? 'light' : 'dark');
