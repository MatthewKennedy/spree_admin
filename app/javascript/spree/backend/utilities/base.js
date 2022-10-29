const SpreeAdmin = {}

if (!window.SpreeAdmin) { window.SpreeAdmin = SpreeAdmin }

SpreeAdmin.mountedAt = function () { return window.SpreePaths.mounted_at }
SpreeAdmin.adminPath = function () { return window.SpreePaths.admin }

SpreeAdmin.pathFor = function (path) {
  const locationOrigin = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '')
  const queryParts = window.location.search
  const uri = `${locationOrigin + this.mountedAt() + path + queryParts}`

  return uri
}

SpreeAdmin.localizedPathFor = function (path) {
  const currentCurrency = this.localization.current_currency
  const currentLocale = this.localization.current_locale

  if (typeof currentCurrency !== 'undefined' && typeof currentLocale !== 'undefined') {
    const fullUrl = new URL(SpreeAdmin.pathFor(path))
    const params = fullUrl.searchParams
    let pathName = fullUrl.pathname

    params.set('currency', currentCurrency)

    if (pathName.match(/api\/v/)) {
      params.set('locale', currentLocale)
    } else {
      pathName = this.mountedAt() + currentLocale + '/' + path
    }
    return fullUrl.origin + pathName + '?' + params.toString()
  }
  return SpreeAdmin.pathFor(path)
}
