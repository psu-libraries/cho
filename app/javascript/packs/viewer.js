// require('../uv/uv.css')
// import('../uv/lib/offline.js')
// import('../uv/helpers.js')
// import('../uv/uv.js')

/* eslint no-undef: 0 */
Blacklight.onLoad(function () {
  console.log('viewer loaded')
})

var myUV
window.addEventListener('uvLoaded', function (e) {
  myUV = createUV('#uv', {
    iiifResourceUri: 'http://wellcomelibrary.org/iiif/b18035723/manifest',
    configUri: 'uv-config.json'
  }, new UV.URLDataProvider())
  myUV.on('created', function (obj) {
    console.log('parsed metadata', myUV.extension.helper.manifest.getMetadata())
    console.log('raw jsonld', myUV.extension.helper.manifest.__jsonld)
  })
}, false)
/* eslint no-undef: 1 */
