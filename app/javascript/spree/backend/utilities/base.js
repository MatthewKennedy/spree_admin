const SpreeAdmin = {}

if (!window.SpreeAdmin) { window.SpreeAdmin = SpreeAdmin }

const platformApiMountedAt = function () { return window.SpreeAdmin.paths.platform_api_mounted_at }

const pathFor = function (path) {
  const locationOrigin = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '')
  const queryParts = window.location.search
  const uri = `${locationOrigin + platformApiMountedAt() + path + queryParts}`

  return uri
}

// For the platform API we only need to localize the language.
// The currency is set on a per order basic from the order_currency
// setting and therefor not based on a global setting.
SpreeAdmin.localizedPathFor = function (path) {
  const defaultLocale = this.localization.default_locale
  const currentLocale = this.localization.current_locale

  if (defaultLocale !== currentLocale) {
    const fullUrl = new URL(pathFor(path))
    const params = fullUrl.searchParams
    const pathName = fullUrl.pathname

    params.set('locale', currentLocale)

    return fullUrl.origin + pathName + '?' + params.toString()
  }
  return pathFor(path)
}
