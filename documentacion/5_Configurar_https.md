# ¿Es Recomendable Cambiar de HTTP a HTTPS?

Sí, **absolutamente recomendable**. HTTP (sin encriptación) envía datos en texto plano, lo que hace vulnerable tu 
aplicación a ataques como eavesdropping (interceptación de datos), man-in-the-middle, o robo de credenciales/tokens.
Dado que el backend maneja autenticación (usuarios, passwords, JWT), HTTPS protege la integridad 
y confidencialidad. En producción, es obligatorio para compliance (e.g., GDPR) y SEO (Google favorece HTTPS). En 
desarrollo local, puedes usar certificados auto-firmados para simular HTTPS.

#### Por Qué HTTPS es Crucial
- **Seguridad de Datos**: Passwords hasheadas y tokens JWT viajan encriptados, previniendo robos.
- **Confianza del Usuario**: Navegadores marcan HTTP como "no seguro".
- **Requisitos Modernos**: APIs modernas requieren HTTPS; herramientas como Postman o frontends rechazan HTTP en entornos seguros.
- **Riesgos sin HTTPS**: Ataques fáciles en redes públicas (e.g., WiFi de aula).

#### Cómo Implementar HTTPS en Node.js/Express
Express no incluye HTTPS por defecto, pero puedes habilitarlo fácilmente. Necesitas un certificado SSL/TLS. Aquí las opciones:

##### Opción 1: Certificado Auto-Firmado para Desarrollo Local (Recomendado para Pruebas)
- **Ventajas**: Rápido, gratuito, simula HTTPS sin costos.
- **Desventajas**: Navegadores muestran advertencias de "certificado no confiable" (ignóralas para desarrollo).
- **Pasos**:
    1. **Genera un Certificado Auto-Firmado**:
        - Instala OpenSSL (viene con Git Bash o descarga de https://slproweb.com/products/Win32OpenSSL.html).
        - Ejecuta en terminal (en la raíz de tu proyecto):
          ```
          openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
          ```
            - Responde las preguntas (e.g., país, organización). Esto crea `key.pem` (clave privada) y `cert.pem` (certificado).
        - **Nota**: No compartas `key.pem`; es sensible.

    2. **Configura Express para HTTPS**:
        - En `src/server.js`, importa `https` y configura:
          ```javascript
          const https = require('https');
          const fs = require('fs');
          const path = require('path');
   
          // Opciones SSL
          const sslOptions = {
            key: fs.readFileSync(path.join(__dirname, 'key.pem')),
            cert: fs.readFileSync(path.join(__dirname, 'cert.pem'))
          };
   
          // Cambia app.listen por https.createServer
          const server = https.createServer(sslOptions, app);
          server.listen(PORT, () => {
            console.log(`Servidor HTTPS corriendo en https://localhost:${PORT}`);
          });
          ```
        - Reinicia el servidor: `npm run dev`.
        - Accede con `https://localhost:3000` en navegador/Postman. Ignora la advertencia de certificado.

    3. **Prueba**:
        - Usa Postman: Cambia a HTTPS y acepta el certificado.
        - Si hay errores (e.g., "EACCES"), ejecuta como administrador o cambia permisos de archivos.

##### Opción 2: Certificado Gratuito de Let's Encrypt para Producción
- **Ventajas**: Confiable, gratuito, válido 90 días (renovable).
- **Desventajas**: Requiere dominio público; no para localhost.
- **Pasos** (Usa Certbot):
    1. Instala Certbot (https://certbot.eff.org/).
    2. Ejecuta: `certbot certonly --standalone -d tu-dominio.com`.
    3. Usa los archivos generados (`fullchain.pem`, `privkey.pem`) en `sslOptions` como arriba.
    4. Configura renovación automática: `certbot renew`.

##### Opción 3: Servicios de Hosting con HTTPS Integrado
- Si despliegas en Heroku, Vercel, o AWS, habilitan HTTPS automáticamente (e.g., Heroku con "SSL Certificate" gratuito).
- Para local, quédate con auto-firmado.

#### Consideraciones Adicionales
- **Redireccionamiento HTTP a HTTPS**: En producción, agrega middleware para forzar HTTPS:
  ```javascript
  app.use((req, res, next) => {
    if (req.header('x-forwarded-proto') !== 'https') {
      res.redirect(`https://${req.header('host')}${req.url}`);
    } else {
      next();
    }
  });
  ```
- **Costo y Mantenimiento**: Auto-firmado es gratis para desarrollo; Let's Encrypt para producción.
- **Seguridad Extra**: Usa Helmet (`npm install helmet`) para headers de seguridad: `app.use(helmet());`.
- **Advertencia**: En aula/desarrollo, HTTPS auto-firmado es suficiente. Para producción real, usa certificados válidos.

Implementa el auto-firmado primero y prueba. Si tienes errores o necesitas código específico, ¡dime! Tu app será mucho más segura. 🔒

## 1️⃣ Instalar mkcert en Windows

Con **Chocolatey** (lo más cómodo), ya que se suele instalar con Node.js

✅ Forma rápida de comprobar si tienes Chocolatey:

Abre **PowerShell** y escribe:

```powershell
choco -v
```

* Si devuelve un número (ej. `2.3.0`) → **sí tienes Chocolatey** ✅
* Si sale *“choco no se reconoce…”* → **no lo tienes** ❌

---

### 🔍 Alternativa (por si falla lo anterior)

```powershell
where choco
```

* Si muestra una ruta (`C:\ProgramData\chocolatey\...`) → instalado pero no en PATH
* Si no muestra nada → no está

Para instalar mkcert ejecuta: 

```powershell
choco install mkcert
```
---

#### 2️⃣ Crear la CA local (una sola vez)

Ejecuta **PowerShell como administrador**:

```powershell
mkcert -install
```

Esto hace que Windows y el navegador confíen en los certificados.

---

#### 3️⃣ Generar el certificado para Node

En la carpeta del proyecto:

```powershell
mkcert localhost
```

Se crean:

* `localhost.pem`
* `localhost-key.pem`

---

### 4️⃣ Usar HTTPS en Node (ejemplo básico)

```js
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('localhost-key.pem'),
  cert: fs.readFileSync('localhost.pem')
};

https.createServer(options, (req, res) => {
  res.writeHead(200);
  res.end('Servidor HTTPS funcionando');
}).listen(3000, () => {
  console.log('https://localhost:3000');
});
```

---

### ⚠️ Alternativa rápida (con aviso del navegador)

Si **no quieres instalar nada**:

```powershell
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
```

(El navegador avisará ⚠️).

---

### 🧠 Resumen tipo examen:

* **Node + Windows + desarrollo** → **mkcert**
* Evita warnings HTTPS
* Ideal para `localhost`

Si usas **Express**, **Vite**, **Next**, etc., dímelo y te adapto el ejemplo en 30 segundos 😉
