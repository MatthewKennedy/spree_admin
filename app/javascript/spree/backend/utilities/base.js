const SpreeAdmin = {}

if (!window.SpreeAdmin) { window.SpreeAdmin = SpreeAdmin }

const platformApiMountedAt = function () { return window.SpreeAdmin.paths.platform_api_mounted_at }

const pathFor = function (path) {
  const locationOrigin = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '')
  const queryParts = window.location.search
  const uri = `${locationOrigin + platformApiMountedAt() + path + queryParts}`

  return uri
}

SpreeAdmin.localizedPathFor = function (path) {
  const currentCurrency = this.localization.current_currency
  const currentLocale = this.localization.current_locale

  if (typeof currentCurrency !== 'undefined' && typeof currentLocale !== 'undefined') {
    const fullUrl = new URL(pathFor(path))
    const params = fullUrl.searchParams
    const pathName = fullUrl.pathname

    params.set('currency', currentCurrency)
    params.set('locale', currentLocale)

    return fullUrl.origin + pathName + '?' + params.toString()
  }
  return pathFor(path)
}
