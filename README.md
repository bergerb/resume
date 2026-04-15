# Resume site

Custom Jekyll resume site for Brent Berger.

## Open locally

This repo is set up as a Jekyll site for GitHub Pages.

### Build with Ruby

```powershell
bundle install
bundle exec rake build
```

This generates:

- `_site\` - the Jekyll site
- `resume-compliance.md` - a plain Markdown resume generated from `_data\data.yml`

If you only want the Markdown artifact:

```powershell
bundle exec rake markdown_resume
```

### Build with Docker

```powershell
docker run --rm `
  --volume "${PWD}:/srv/jekyll" `
  jekyll/jekyll:4 `
  jekyll build
```

## GitHub Pages

This repo is set up for GitHub Pages with a GitHub Actions deployment workflow and a custom domain:

- Pages source: **GitHub Actions**
- Custom domain: **resume.bergerb.net**
- `CNAME` is committed so GitHub Pages will publish to that hostname
- The workflow builds the Jekyll site before publishing

### DNS

Create a DNS `CNAME` record for `resume` that points to your GitHub Pages host:

`resume.bergerb.net -> <your-github-pages-host>`

If this is a user/organization site, that host is typically:

`bbber.github.io`

If this is a project site and you are still using GitHub Pages with a custom domain, GitHub will provide the correct target during setup.

## Files

- `_config.yml` - Jekyll site configuration
- `_data/data.yml` - resume content source of truth
- `_layouts/default.html` - page layout
- `_includes/` - reusable resume sections
- `scripts/build_resume_md.rb` - generator for the Markdown upload/compliance resume
- `resume-compliance.md` - generated Markdown resume artifact
- `assets/css/main.css` - custom responsive and print styles
- `assets/js/app.js` - print button behavior
- `assets/resume.pdf` - downloadable PDF resume
- `.github/workflows/deploy-pages.yml` - GitHub Pages deployment workflow
- `CNAME` - custom domain for GitHub Pages
