# Cybersecurity Portfolio

A high-performance, secure portfolio website built with Astro and Tailwind CSS featuring a Terminal/Cyber aesthetic.

## 🚀 Deployment

This site is configured for automatic deployment to GitHub Pages.

### Setup Instructions

1. **Create a new GitHub repository** named `rensschuil02.github.io` (replace with your username if different)

2. **Initialize and push your code:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Cybersecurity portfolio"
   git branch -M main
   git remote add origin https://github.com/rensschuil02/rensschuil02.github.io.git
   git push -u origin main
   ```

3. **Enable GitHub Pages:**
   - Go to your repository settings
   - Navigate to **Pages** (in the left sidebar)
   - Under **Source**, select **GitHub Actions**

4. **Wait for deployment:**
   - The GitHub Action will automatically run
   - Your site will be live at: `https://rensschuil02.github.io`

### Alternative: Deploy to a Project Repository

If you want to deploy to a project repository (e.g., `portfolio-website-project`):

1. In `astro.config.mjs`, uncomment and update:
   ```js
   base: '/portfolio-website-project',
   ```

2. Update the repository URL when pushing:
   ```bash
   git remote add origin https://github.com/rensschuil02/portfolio-website-project.git
   ```

3. Your site will be at: `https://rensschuil02.github.io/portfolio-website-project`

## 🧞 Commands

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |

## 🎨 Features

- ⚡ Built with Astro for optimal performance
- 🎯 View Transitions for smooth navigation
- 🎨 Terminal/Cyber aesthetic with Tailwind CSS
- 📱 Fully responsive design
- 🔒 Security-focused content
- 🚀 Optimized for GitHub Pages

## 📝 Customization

- Update your name in `/src/pages/index.astro`
- Add your projects in `/src/pages/projects.astro`
- Create writeups in `/src/pages/writeups/`
- Modify colors in Tailwind classes (cyan/green theme)
