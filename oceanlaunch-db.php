// OceanLaunch: the database connected to this app, from DATABASE_URL (mysql://user:password@host:port/name). Read on
// every request and in cron jobs alike; WORDPRESS_DB_* variables, if set, win.
if (!getenv('WORDPRESS_DB_HOST') && ($oceanlaunchDb = getenv('DATABASE_URL')) && ($oceanlaunchDb = parse_url($oceanlaunchDb))
		&& isset($oceanlaunchDb['host'])) {
	putenv('WORDPRESS_DB_HOST=' . $oceanlaunchDb['host'] . ':' . ($oceanlaunchDb['port'] ?? 3306));
	putenv('WORDPRESS_DB_USER=' . rawurldecode($oceanlaunchDb['user'] ?? ''));
	putenv('WORDPRESS_DB_PASSWORD=' . rawurldecode($oceanlaunchDb['pass'] ?? ''));
	putenv('WORDPRESS_DB_NAME=' . ltrim($oceanlaunchDb['path'] ?? '', '/'));
}
unset($oceanlaunchDb);
