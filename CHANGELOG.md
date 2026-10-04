# Changelog

## 11.0.0 / 2026-10-04

This major release updates Rails to version 7.2, and updates supported Ruby
versions to 3.2 through 4.0. It also includes breaking changes to theming
support.

### Security

* Refuse attempts to upload a file detected as text with an html extension ([#268] by [mvz])

### Ruby support

PublifyCore 11.0 supports Ruby 3.2 through 4.0, dropping support for older versions:

* Support Ruby 3.0 and up ([#136] by [mvz])
* Add Ruby 3.4 to the GitHub Actions matrix ([#167] by [mvz])
* Drop support for Ruby 3.0 and 3.1 ([#189] by [mvz])
* Test with Ruby 4.0 in CI ([#221] by [mvz])

### Rails support

PublifyCore 11.0 supports Rails 7.1 and 7.2:

* Drop support for Rails 6.1 ([#195] by [mvz])
* Set explicit coder for serialized attributes ([#198] by [mvz])
* Support Rails 7.2 ([#261] by [mvz])
* Handle Rails 7.1 deprecation warnings ([#222] by [mvz])
* Drop support for Rails 7.0 ([#215] by [mvz])
* Make old migration work with Postgres in Rails 7.2 ([#262] by [mvz])

### Theming

This release includes breaking changes to theming. Themes must now use the
default Rails layout name, `application`. All theme assets are served via the
asset pipeline. To avoid asset name conflicts, themes must namespace their
assets with the theme name.

For example for a theme named 'foo', this results in the following setup:

* Layout in `themes/foo/views/layouts/application.html.erb`
* In the layout, links to style sheets and javascript files that automatically
  prefix the theme name:

  ```erb
  <%= themeable_stylesheet_link_tag :theme %>
  <%= themeable_javascript_include_tag :theme %>
  ```

* Asset files:
   * `themes/foo/javascripts/foo/theme.js`
   * `themes/foo/stylesheets/foo/theme.css`

Related pull requests:

* Simplify derivation of a theme's name from its path ([#240] by [mvz])
* Remove translation only used in Typographic theme ([#245] by [mvz])
* Always use the standard Rails layout name for the content pages ([#244] by [mvz])
* Use the asset pipeline for theme assets ([#247] by [mvz])

### Dependencies

* Port Admin views to Bootstrap 4 ([#178] by [mvz])
* Upgrade to commonmarker version 2.3 ([#193] by [mvz])
* Upgrade to bootstrap 5.3 ([#234] by [mvz])
* Update Devise to version 5.0.4 ([#226] by [mvz])

### Miscellaneous

* Upgrade `html_pipeline` to version 3.2 and port custom filters ([#211] by [mvz])
* Replace `devise_zxcvbn` with direct integration of `zxcvbn` ([#217] by [mvz])
* Add specs for `ContentBase#excerpt_text` ([#228] by [mvz])
* Remove monkey-patched `String#strip_html` method ([#231] by [mvz])
* Clean up deprecations ([#233] by [mvz])
* Remove EkkoLightbox ([#235] by [mvz])
* Remove old password fallback mechanism ([#236] by [mvz])
* Clean up textfilter macro methods ([#238] by [mvz])
* Replace ad-hoc excerpt code with `#excerpt_text` ([#239] by [mvz])
* Remove useless `Redirect#to_url` method ([#252] by [mvz])
* Remove html tags the Rails way when generating permalinks ([#249] by [mvz])

### Internal

* Allow starting the GitHub Actions workflow manually ([#140] by [mvz])
* Pull in latest changes from 10-0-stable ([#164] by [mvz])
* Pull in latest changes from 10-0-stable ([#152] by [mvz])
* Fix linting job in GitHub Actions ([#158] by [mvz])
* Provide needed graphics processing dependency in CI ([#169] by [mvz])
* Test with all supported Rails versions in CI ([#168] by [mvz])
* Use rake-manifest to generate the manifest ([#170] by [mvz])
* Prevent manifest task definition from being loaded in dependent projects
  ([11727f5] by [mvz])
* Update RuboCop dependencies and configuration and fix new offenses ([#173] by [mvz])
* Clarify logic in `CommentsController#recaptcha_ok_for?` ([#174] by [mvz])
* Switch to weekly dependabot updates ([#188] by [mvz])
* Use new official name for `erb_lint` ([#190] by [mvz])
* Remove scheduled CI runs ([#204] by [mvz])
* Pull in changelog for version 10.0.3 ([#194] by [mvz])
* Remove obsolete `before_action` ([#196] by [mvz])
* Remove exceptions from `login_required` before_action ([#197] by [mvz])
* Refactor notes rendering ([#210] by [mvz])
* Remove any permissions from `GITHUB_TOKEN` in CI ([#253] by [mvz])
* Remove dummy application layout view ([#246] by [mvz])
* Make 'rails server' work with the dummy test app ([#216] by [mvz])
* Update rubocop dependencies and handle new offenses ([#223] by [mvz])
* Remove dependency on pry ([#165] by [mvz])
* Loosen development dependencies ([#266] by [mvz])

[#136]: https://github.com/publify/publify_core/pull/136
[#140]: https://github.com/publify/publify_core/pull/140
[#152]: https://github.com/publify/publify_core/pull/152
[#158]: https://github.com/publify/publify_core/pull/158
[#164]: https://github.com/publify/publify_core/pull/164
[#165]: https://github.com/publify/publify_core/pull/165
[#167]: https://github.com/publify/publify_core/pull/167
[#168]: https://github.com/publify/publify_core/pull/168
[#169]: https://github.com/publify/publify_core/pull/169
[#170]: https://github.com/publify/publify_core/pull/170
[#173]: https://github.com/publify/publify_core/pull/173
[#174]: https://github.com/publify/publify_core/pull/174
[#178]: https://github.com/publify/publify_core/pull/178
[#188]: https://github.com/publify/publify_core/pull/188
[#189]: https://github.com/publify/publify_core/pull/189
[#190]: https://github.com/publify/publify_core/pull/190
[#193]: https://github.com/publify/publify_core/pull/193
[#194]: https://github.com/publify/publify_core/pull/194
[#195]: https://github.com/publify/publify_core/pull/195
[#196]: https://github.com/publify/publify_core/pull/196
[#197]: https://github.com/publify/publify_core/pull/197
[#198]: https://github.com/publify/publify_core/pull/198
[#204]: https://github.com/publify/publify_core/pull/204
[#210]: https://github.com/publify/publify_core/pull/210
[#211]: https://github.com/publify/publify_core/pull/211
[#215]: https://github.com/publify/publify_core/pull/215
[#216]: https://github.com/publify/publify_core/pull/216
[#217]: https://github.com/publify/publify_core/pull/217
[#221]: https://github.com/publify/publify_core/pull/221
[#222]: https://github.com/publify/publify_core/pull/222
[#223]: https://github.com/publify/publify_core/pull/223
[#226]: https://github.com/publify/publify_core/pull/226
[#228]: https://github.com/publify/publify_core/pull/228
[#231]: https://github.com/publify/publify_core/pull/231
[#233]: https://github.com/publify/publify_core/pull/233
[#234]: https://github.com/publify/publify_core/pull/234
[#235]: https://github.com/publify/publify_core/pull/235
[#236]: https://github.com/publify/publify_core/pull/236
[#238]: https://github.com/publify/publify_core/pull/238
[#239]: https://github.com/publify/publify_core/pull/239
[#240]: https://github.com/publify/publify_core/pull/240
[#244]: https://github.com/publify/publify_core/pull/244
[#245]: https://github.com/publify/publify_core/pull/245
[#246]: https://github.com/publify/publify_core/pull/246
[#247]: https://github.com/publify/publify_core/pull/247
[#249]: https://github.com/publify/publify_core/pull/249
[#252]: https://github.com/publify/publify_core/pull/252
[#253]: https://github.com/publify/publify_core/pull/253
[#261]: https://github.com/publify/publify_core/pull/261
[#262]: https://github.com/publify/publify_core/pull/262
[#266]: https://github.com/publify/publify_core/pull/266
[#268]: https://github.com/publify/publify_core/pull/268

[11727f5]: https://github.com/publify/publify_core/commit/11727f5a2826ea351964c2367d36a979dfab212d

## 10.0.4 / 2026-10-04

* Refuse attempts to upload a file detected as text with an html extension ([#267] by [mvz])

[#267]: https://github.com/publify/publify_core/pull/267

## 10.0.3 / 2025-03-28

* Limit accepted parameters for Sidebar update in Admin ([#159] by [mvz])
* Use known set of allowed attributes when autosaving an Article ([#160] by [mvz])
* Permit only valid settings keys when updating blog settings ([#161] by [mvz])
* Limit assigned attributes when creating and updating Notes ([#162] by [mvz])
* Limit allowed SEO settings params ([#163] by [mvz])

[#159]: https://github.com/publify/publify_core/pull/159
[#160]: https://github.com/publify/publify_core/pull/160
[#161]: https://github.com/publify/publify_core/pull/161
[#162]: https://github.com/publify/publify_core/pull/162
[#163]: https://github.com/publify/publify_core/pull/163

## 10.0.2 / 2024-06-28

### Security updates

* Safely link target URLs for Redirects in admin ([#148] by [mvz])
* Upgrade jquery-ui-rails to version 7.0 ([#149] by [mvz])

### Functional changes

* Use native datetime inputs in the Admin ([#121] by [mvz])
* Display Theme description nicely in the admin ([#151] by [mvz])

### Internal changes

* Stop using and depending on REXML ([#123] by [mvz])
* Remove inline javascript ([#124] by [mvz])
* Switch to no-trailing-comma style ([#127] by [mvz])
* Remove inline styles assigned in ERB templates ([#128] by [mvz])
* Make Content.searchstring scope code more transparent ([#150] by [mvz])
* Add erb-lint and fix initial warnings ([#125] by [mvz])

[#121]: https://github.com/publify/publify_core/pull/121
[#123]: https://github.com/publify/publify_core/pull/123
[#124]: https://github.com/publify/publify_core/pull/124
[#125]: https://github.com/publify/publify_core/pull/125
[#127]: https://github.com/publify/publify_core/pull/127
[#128]: https://github.com/publify/publify_core/pull/128
[#148]: https://github.com/publify/publify_core/pull/148
[#149]: https://github.com/publify/publify_core/pull/149
[#150]: https://github.com/publify/publify_core/pull/150
[#151]: https://github.com/publify/publify_core/pull/151

## 10.0.1 / 2023-10-28

* Update CarrierWave dependency to version 3.0 ([#102] by [mvz])
* Move String monkey-patches into a module under PublifyCore ([#115] by [mvz])
* Remove text filter plugin naming requirements ([#109], [#110], [#117] by [mvz])
* Fix name and description of Twitterfilter ([#118] by [mvz])
* Fix link to pull request in CHANGELOG ([#116] by [mvz])
* Provide proper validation feedback during setup ([#119] by [mvz])

[#102]: https://github.com/publify/publify_core/pull/102
[#109]: https://github.com/publify/publify_core/pull/109
[#110]: https://github.com/publify/publify_core/pull/110
[#115]: https://github.com/publify/publify_core/pull/115
[#116]: https://github.com/publify/publify_core/pull/116
[#117]: https://github.com/publify/publify_core/pull/117
[#118]: https://github.com/publify/publify_core/pull/118
[#119]: https://github.com/publify/publify_core/pull/119
[mvz]: https://github.com/mvz

## 10.0.0 / 2023-06-25

### Updated dependencies

* Upgrade to Rails 6.1 and Ruby 2.7 to 3.2
  [publify#987](https://github.com/publify/publify/pull/987),
  [publify#1014](https://github.com/publify/publify/pull/1014),
  [publify_core#71](https://github.com/publify/publify_core/pull/71), and
  [publify_core#78](https://github.com/publify/publify_core/pull/78)
* Update various other dependencies (various pull requests)

### Breaking changes

* Remove support for Textile as a text format
  [publify#1001](https://github.com/publify/publify/pull/1001)

### Other changes

* Improve feedback listings [publify#1005](https://github.com/publify/publify/pull/1005)
* Link to article from article feedback admin page
  [publify#1007](https://github.com/publify/publify/pull/1007)
* Link to blog from admin menu [publify#1008](https://github.com/publify/publify/pull/1008)
* Handle markdown links in notes correctly
  [publify#1009](https://github.com/publify/publify/pull/1009)
* Make notes twitterfilter robust
  [publify#1010](https://github.com/publify/publify/pull/1010)
* Miscellaneous admin fixes [publify#1012](https://github.com/publify/publify/pull/1012)
* Add arabic language to the project
  [publify#1060](https://github.com/publify/publify/pull/1060) by [ahmedhamid13](https://github.com/ahmedhamid13)

### Internal changes

* Remove use of 'notextile' [publify#1002](https://github.com/publify/publify/pull/1002)
* Remove `TextFilter.filter_text` in favor of `#filter_text`
  [publify#1003](https://github.com/publify/publify/pull/1003)
* Replace BlueCloth with CommonMarker for Markdown processing
  [publify#810](https://github.com/publify/publify/pull/810)
* Rename Admin::ContentController to Admin::ArticlesController
  [publify#1004](https://github.com/publify/publify/pull/1004)
* Remove unneeded wrapping elements from admin layout
  [publify#1006](https://github.com/publify/publify/pull/1006)
* Split the factories into individual files
  [publify#1031](https://github.com/publify/publify/pull/1031) by [VictorPS](https://github.com/VictorPS)
* Ensure `auto_link` helper is loaded on time
  [publify#1040](https://github.com/publify/publify/pull/1040)
* Remove `sitealizer` table
  [publify#1089](https://github.com/publify/publify/pull/1089) by [SupriyaMedankar](https://github.com/SupriyaMedankar)
* Remove itunes fields from resources
  [publify#1092](https://github.com/publify/publify/pull/1092) by [SupriyaMedankar](https://github.com/SupriyaMedankar)
* Remove `page_caches` table
  [publify#1090](https://github.com/publify/publify/pull/1090) by [SupriyaMedankar](https://github.com/SupriyaMedankar)
* Remove obsolete Sidebar code
  [publify_core#58](https://github.com/publify/publify_core/pull/58)

## 9.2.10 / 2023-01-08

* Bump Rails version to 5.2.8.1 [publify#1070](https://github.com/publify/publify/pull/1070)
* Limit length of settings values
  [publify#1072](https://github.com/publify/publify/pull/1072)
* Require login to stay unique when updating a User
  [publify#1073](https://github.com/publify/publify/pull/1073)
* Validate lengths of string attributes
  [publify#1077](https://github.com/publify/publify/pull/1077)
* Strip EXIF data from resource uploads
  [publify#1078](https://github.com/publify/publify/pull/1078)
* Require user passwords to be strong
  [publify#1086](https://github.com/publify/publify/pull/1086)

## 9.2.9 / 2022-05-22

* Fix admin article access control
  [publify#1065](https://github.com/publify/publify/pull/1065)
* Refuse html files as resources even if declared to be plain text
  [publify#1066](https://github.com/publify/publify/pull/1066)

## 9.2.8 / 2022-05-14

* Fix password protected article reveal
  [publify#1049](https://github.com/publify/publify/pull/1049)
* Disallow comments on draft articles
  [publify#1048](https://github.com/publify/publify/pull/1048)
* Clean up Feedback validation [publify#1051](https://github.com/publify/publify/pull/1051)
* Disallow images in comments [publify#1054](https://github.com/publify/publify/pull/1054)
* Fix password reset process [publify#1055](https://github.com/publify/publify/pull/1055)
* Hide bodies of password-protected articles in search results
  [publify#1057](https://github.com/publify/publify/pull/1057)
* Provide correct `article_id` input in bulkops form
  [publify#1058](https://github.com/publify/publify/pull/1058)
* Do not create article meta description for password-protected articles
  [publify#1061](https://github.com/publify/publify/pull/1061)

## 9.2.7 / 2022-02-07

* Fix setting the article password from the Admin
  [publify#1044](https://github.com/publify/publify/pull/1044)

## 9.2.6 / 2022-01-07

* Add documentation about use of the media library

## 9.2.5 / 2021-10-11

This release fixes several security issues:

* Block ability to switch themes using a GET request; use a POST instead
* Disallow user self-registration rather than hiding it
* Let the browser not cache admin pages
* Limit the set of allowed mime types for uploaded media
* Limit allowed HTML in articles, pages and notes

Additionally, it includes the following changes:

* Fix resource size display in admin resource list
* Trigger download of media in the Media Library in admin instead of displaying
  them directly

## 9.2.4 / 2021-10-02

* Explicitly require at least version 1.12.5 of nokogiri to avoid a security issue
* Drop support for Ruby 2.4 since it is incompatible with nokogiri 1.12.5

## 9.2.3 / 2021-05-22

* Bump Rails dependency to 5.2.6
* Replace mimemagic with marcel [publify#996](https://github.com/publify/publify/pull/996)

## 9.2.2 / 2021-03-21

* No changes

## 9.2.1 / 2021-03-20

* No changes

## 9.2.0 / 2021-01-17

* Upgrade to Rails 5.2 (mvz)
* Fix logic for rendering excerpts or whole posts (mvz)
* Drop support for Ruby 2.2 and 2.3 (mvz)
* Provide FactoryBot factories for general use (mvz)
* Fix comment preview (mvz)
* Drop support for humans.txt (mvz)
* Remove unused ability to view macro help text (mvz)
* Simplify the article editor: remove widearea and button fade-out (mvz)
* Remove unused `title_prefix` setting (mvz)
* Remove text filter definitions from the database. Text filters are now
  specified in code only (mvz)
* Remove broken inbound links feature from Admin dashboard (mvz)
* Always include a canonical URL in the header and remove `use_canonical_url`
  option (mvz)
* Update various dependencies (mvz)
* Use new way to render Devise error messages in view override (mvz)
* Fix broken page creation (cfis)
* Improve calculation of canonical URL (mvz)
* Replace use of deprecated URI.escape and URI.encode (mvz)
* Add support for Ruby 2.7 (mvz)
* Deprecate Textile text filter (mvz)
* Remove icons from Admin and replace them with text (mvz)
* Show text filter in content lists in Admin, plus various other Admin
  improvements (mvz)
* Warn about need to run task to convert textile to markdown (mvz)
* Update mimimum dependencies of Rails and Puma to avoid security issues (mvz)

## 9.1.0 / 2018-04-19

* Upgrade to Rails 5.1 (mvz)
* Update Danish translations (xy2z)
* Extend Polish translations (gergu)
* Remove outdated import tools (mvz)
* Fix a bunch of issues (e-tobi)
* Fix google analytics tag rendering (mvz)

## 9.0.1

* Remove `link_to_author` setting: author email is no longer shown. Whoever
  really wants to have it shown should create a new theme (mvz)
* Update dependencies (mvz)
* Make Devise use the correct layout (mvz)
* Ensure email parameter is processed correctly on sign up (mvz)
* Correctly serve js files from themes (cantin)

## 9.0.0

* Replace page caching with fragment caching (mvz)
* Replace home-grown state machine with aasm (mvz)
* Remove automigration. Users should run db:migrate themselves (mvz)
* Let first-run users pick their own password instead of generating one (mvz)

* Dependencies
   * Update dependencies (mvz)
   * Drop support for Ruby 2.1 (mvz)

* Removing of old/outdated functionality
   * Remove support for feedburner (mvz)
   * Drop old redirects (mvz)
   * Remove RSD end point (mvz)

* Feedback
   * Stop sending trackbacks and pingbacks (mvz)
   * Stop accepting trackbacks (mvz)

* Improve Atom/RSS feeds
   * Fix URLs used for resources (mvz)
   * Fix URL/alternate links to not just point to the site root (mvz)
   * Unify comment and trackback feeds into feedback feed (mvz)
   * Add caching for feeds (mvz)
   * Fix atom entry publication date (mvz)
   * Fix ordering of feedback feed by using created_at (mvz)

* Bug fixes
   * Fix user resource image display when using Fog (mvz)
   * Fix sending of welcome email (mvz)
   * Fix Tag page description (mvz)
   * Handle setting published_at to blank (mvz)
   * Handle preview of articles without publication date (mvz)
   * Include CSRF meta tag so remote forms work (mvz)
   * Fix sidebar field rendering in admin (mvz)
   * Fix formatting of settings forms in admin (mvz)

* Code improvements
   * Performance improvements (mvz)
   * Improve tags controller (mvz)
   * Clean up archives and authors page code (mvz)
   * Unify content models more to improve performance when mixing models (mvz)

## 9.0.0.pre6 / 2016-12-23

* Remove now-broken caching of theme assets (mvz)
* Remove cache invalidation support code from content (mvz)

## 9.0.0.pre5 / 2016-12-17

* Update dependencies (mvz)
* Remove activerecord-session_store. The main application should decide on the
  store to use (mvz)
* Remove unused translations (mvz)

## 9.0.0.pre4

* Ensure theme files are part of the gem (mvz)

## 9.0.0.pre3

* Update to Rails 5.0 (mvz)
* Remove page caching since the released version of actionpack-page_caching is
  incompatible with Rails 5 (mvz)

## 9.0.0.pre2

* Ensure PublifyCore::VERSION is available (mvz)

## 9.0.0.pre1

* Initial pre-release of Publify Core as a separate gem.
