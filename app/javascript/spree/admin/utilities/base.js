import Uri from 'jsuri'

const SpreeAdmin = {}

if (!window.SpreeAdmin) { window.SpreeAdmin = SpreeAdmin }

SpreeAdmin.mountedAt = function () { return window.SpreePaths.mounted_at }
SpreeAdmin.adminPath = function () { return window.SpreePaths.admin }

SpreeAdmin.pathFor = function (path) {
  const locationOrigin = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '')
  return this.url('' + locationOrigin + this.mountedAt() + path, this.url_params).toString()
}

SpreeAdmin.localizedPathFor = function (path) {
  if (typeof SPREE_LOCALE !== 'undefined' && typeof SPREE_CURRENCY !== 'undefined') {
    const fullUrl = new URL(SpreeAdmin.pathFor(path))
    const params = fullUrl.searchParams
    let pathName = fullUrl.pathname

    params.set('currency', SPREE_CURRENCY)

    if (pathName.match(/api\/v/)) {
      params.set('locale', SPREE_LOCALE)
    } else {
      pathName = this.mountedAt() + SPREE_LOCALE + '/' + path
    }
    return fullUrl.origin + pathName + '?' + params.toString()
  }
  return SpreeAdmin.pathFor(path)
}

SpreeAdmin.url = function (uri, query) {
  if (uri.path === undefined) { uri = new Uri(uri) }
  if (query) { Object.keys(query).forEach(key => { return uri.addQueryParam(key, query[key]) }) }
  return uri
}

SpreeAdmin.routes = {}
SpreeAdmin.url_params = { }
