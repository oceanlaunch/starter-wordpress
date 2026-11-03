# WordPress starter

[WordPress](https://wordpress.org) ready to deploy on [OceanLaunch](https://oceanlaunch.cloud), from the official
WordPress image. Choosing it in the portal's **Templates** also makes everything it needs:

- a managed **MariaDB** database, connected to the app (`DATABASE_URL`);
- **storage** at `/data`; WordPress lives in `/data/wordpress`: your uploads, themes, plugins and updates survive deploys;
- a **cron job** that runs WordPress's scheduled tasks every 5 minutes, even when nobody visits.

When it's live, open its address and follow WordPress's five-minute setup (site title, your admin user).

## What's in it

- `Dockerfile`: the official image (pinned), run as its unprivileged user on port 8080 with the site in
  `/data/wordpress`; uploads up to 64 MB.
- `oceanlaunch-db.php`: added to WordPress's `wp-config.php`, it reads the connected database from `DATABASE_URL`.
- `oceanlaunch-start.sh`: makes `/data/wordpress` (as WordPress's user) and starts WordPress there.

## Make it yours

WordPress itself is managed from its dashboard (`/wp-admin`): themes, plugins and updates go into the storage. Change
this repository only to change the server: PHP settings, Apache modules, or the WordPress image. Then:

1. On GitHub, choose **Use this template** to get your own copy of this repository.
2. In the portal, open your app, and under **Make it yours** give your new repository's address.
3. Push to `main`: every push deploys a new version, and the site in `/data` stays as it is.

## A custom domain

Add it on the app's **Domains** tab, then in WordPress set **Settings › General › WordPress Address** and **Site
Address** to it.
