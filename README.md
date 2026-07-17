# The Garden Spot - Year Two question app (GS-Y2)

Post-class companion for the Year Two session. Students complete the Excel worksheets
in class, then play this app: 22 events + adjustments, a 5-case Detective Round, the
Inverse Mystery, and the Indirect Bridge. Max 635 points; target 80% (508). The final
screen is a personalized score certificate that students screenshot and email.

**Privacy by design:** student details (roll no, name, section, email; pair or
individual mode) are collected only to print on the certificate. Nothing is stored
or transmitted - the app has no backend at all when hosted via Shinylive.

## Repo layout
```
app/app.R                     the entire app (edit SUBMIT_EMAIL + DEADLINE_TXT!)
.github/workflows/deploy.yml  auto-builds and publishes to GitHub Pages
```

## Before deploying - two edits in app/app.R
- `SUBMIT_EMAIL <- "your.professor@institute.edu"`  -> your real address
- `DEADLINE_TXT <- "before midnight today"`         -> your real deadline

## Launch on GitHub Pages (free, no server, unlimited students)
1. Create a GitHub account; create a new **public** repository (e.g. `gardenspot-y2`).
2. Upload this folder's contents preserving structure (`app/app.R` and
   `.github/workflows/deploy.yml`). Easiest: repo page -> "Add file" -> "Upload files",
   drag the whole unzipped folder contents in, Commit.
3. Repo **Settings -> Pages -> Build and deployment -> Source: GitHub Actions**.
4. Go to the **Actions** tab - the "Deploy Shiny app" workflow runs (~3-5 min first time).
5. Your app is live at `https://USERNAME.github.io/gardenspot-y2/`.
6. To update: edit `app/app.R` on GitHub (pencil icon), Commit - it redeploys itself.

## How Shinylive hosting works (and its two trade-offs)
The workflow compiles the app to WebAssembly; it runs entirely INSIDE each student's
browser. No server, no active-hours limits, any number of simultaneous students.
Trade-offs: (1) first load downloads the R runtime (~15-20 MB) - allow 20-60 seconds
on the first open, faster after caching; warn students on slow mobile data.
(2) The app's source (including answers and feedback) ships to the browser, so a
technically determined student could read it - acceptable for a formative tool whose
answers were taught in class anyway.

## Alternative: shinyapps.io
If first-load time matters more than the hosting cap, deploy `app/` with
`rsconnect::deployApp("app", appName = "gardenspot-y2")` exactly as done for Year One -
instant loads, but 25 active hours/month on the free tier.

## Local test
```r
install.packages("shiny")
shiny::runApp("app")
```
