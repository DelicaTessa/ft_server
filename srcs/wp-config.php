<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpressuser' );

/** MySQL database password */
define( 'DB_PASSWORD', 'mysql' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'MVefd hR3v ~oHeMLf:;L~yM.BYO7R3+xh*pT]2Cz#vf+,#~3@=_?&49_:Ec1&y`');
define('SECURE_AUTH_KEY',  ';HWA9)n;/hAr%}}u@X2+,~-&5{+MwM`J$6iLw[xvC6?R6ZY*,R-irQ1_T<v;Zi%r');
define('LOGGED_IN_KEY',    'S]W$H#.(q1OxY^*RvYUr:ir-_.-P(fo+hV9<N5}B;iJ+LE_|B3+%~_T9JTYB7DLh');
define('NONCE_KEY',        '@s/$*I=r8NipSMDzOOY_HlOJ-s*~zdx#S<*[G3)1U^p$1m93`+dGPjC=-^RO_SaZ');
define('AUTH_SALT',        'N+lzC%g8La( RTMMCieKJ@7G_aK5H-8$qBzG%,;56kq4}HNK9Mwm9%p9q*u% naa');
define('SECURE_AUTH_SALT', 'RCRx[TtD.+!)ag=$A9>vgBqos+!113OHr##Z>WDLghL~f#@dMMcs0*I}B11pd9|9');
define('LOGGED_IN_SALT',   'Z+(/iWhi1L30s<M;VE+t:tEQ+Pmb{}d#H!p0ibM~aq&ZfiTmQ*s3[n/$WTeRD?6Y');
define('NONCE_SALT',       '+Ro2s&iz#RSp*iX-=l?X36b#Sb..R)zXX2I{Gk!kl`7o(##&-A]DMClI]:l7t|Pp');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';