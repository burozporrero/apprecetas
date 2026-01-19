# Publicar tu Servidor Node.js en Internet de Forma Sencilla

Publicar un servidor que tienes en tu ordenador para acceder desde una app móvil es posible, aunque conviene hacerlo con cuidado. Una forma rápida de conseguirlo es usando **ngrok**, que crea un túnel seguro desde tu máquina local hacia una URL pública temporal. Es perfecto para pruebas y desarrollo, pero no debe usarse en entornos reales.

---

## Requisitos Previos

- Tu servidor Node.js debe estar ejecutándose localmente (por ejemplo, `http://localhost:3000` o `https://localhost:3000` si usas HTTPS).
- Tener Node.js instalado junto con las dependencias de tu proyecto.
- Conexión a internet estable.

---

## Método Más Sencillo: Usar ngrok

ngrok ofrece una URL pública HTTPS que apunta a tu servidor local, ideal para desarrollo.

### Instalación de ngrok

1. Descarga ngrok desde: https://ngrok.com/download
2. Extrae el ZIP y coloca `ngrok.exe` en una carpeta accesible (por ejemplo, `C:\ngrok`).
3. (Opcional) Añade esa carpeta al **PATH** de Windows.

### Obtener un Token (Opcional pero útil)

1. Crea una cuenta gratuita en ngrok.com.
2. En tu panel de usuario, copia tu **authtoken**.
3. En la terminal ejecuta:

```
ngrok config add-authtoken TU_TOKEN_AQUI
```

### Exponer tu Servidor

1. Abre una terminal nueva (tu servidor debe seguir ejecutándose en otra).
2. Ejecuta:

```
ngrok http 3000
```

3. ngrok mostrará algo parecido a:

```
Forwarding    https://abc123.ngrok.io -> http://localhost:3000
```

La URL pública será algo como `https://abc123.ngrok.io`.

---

## Acceso desde tu App Móvil

- Sustituye en tu app las rutas tipo `http://localhost:3000` por la URL de ngrok.  
  Ejemplo:

```
https://abc123.ngrok.io/api/auth/login
```

- Prueba tus endpoints desde el móvil como si estuvieras en local.

### Detener ngrok

- Pulsa **Ctrl + C** en la terminal.
- La URL dejará de funcionar al cerrarlo.

---

## HTTPS Local (Si lo Usas)

Si tu servidor local ya usa HTTPS con certificados auto-firmados, ngrok lo gestiona sin que tengas que hacer nada adicional.  
Para producción, lo recomendable es usar un dominio real con certificados válidos (por ejemplo, Let's Encrypt).

---

## Alternativas si ngrok No Funciona

### 1. Servicios Cloud Gratuitos

- Plataformas como **Heroku**, **Vercel** o **Railway** permiten desplegar tu proyecto y obtener una URL pública.
- Solo necesitas subir tu código a GitHub y desplegar.

---

## Advertencias de Seguridad

- Exponer tu servidor local implica que cualquiera con la URL puede intentar acceder.
- Asegúrate de tener autenticación robusta (por ejemplo, JWT).
- Mantén activo el firewall y cierra ngrok cuando no lo necesites.
- No es una solución para producción. Para proyectos reales, usa servicios como AWS, DigitalOcean o similares.
- Comprueba que no incumples las condiciones de tu proveedor de internet.
- Puedes añadir limitación de peticiones en Express:

```
npm install express-rate-limit
```
