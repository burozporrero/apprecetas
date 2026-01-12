// src/middleware/i18n.js
// Configuración con YAML para mayor legibilidad (Clean Code: configuración centralizada)

const i18next = require('i18next');
const Backend = require('i18next-fs-backend');
const middleware = require('i18next-http-middleware');
const path = require('node:path');
const yaml = require('js-yaml');
const fs = require('node:fs');

i18next
  .use(Backend)
  .use(middleware.LanguageDetector)
  .init({
    fallbackLng: 'en',
    lng: 'es',  // Idioma inicial
    ns: ['translation'],
    defaultNS: 'translation',
    backend: {
      loadPath: path.join(__dirname, '../locales/{{lng}}.yaml'),  // Cambia a .yaml
      parse: yaml.load  // Usa js-yaml para parsear YAML
    },
    detection: {
      order: ['header', 'querystring', 'cookie'],
      lookupHeader: 'accept-language',
      caches: ['cookie']
    },
    interpolation: {
      escapeValue: false  // Desactiva escape para HTML (seguro en API JSON)
    }
  });

module.exports = middleware.handle(i18next);
