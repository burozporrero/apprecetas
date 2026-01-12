# Node.js

<!-- TOC -->
* [Node.js](#nodejs)
  * [¿Qué es Node.js?](#qué-es-nodejs)
  * [Diferencias fundamentales con Java/Tomcat](#diferencias-fundamentales-con-javatomcat)
  * [¿Cómo funciona una aplicación Node.js?](#cómo-funciona-una-aplicación-nodejs)
  * [Instalación y despliegue](#instalación-y-despliegue)
  * [¿Qué "empaquetas"?](#qué-empaquetas)
  * [¿Cómo mantener el servidor corriendo?](#cómo-mantener-el-servidor-corriendo)
  * [Arquitectura Backend con Node.js](#arquitectura-backend-con-nodejs)
  * [¿Por qué Node.js para backend?](#por-qué-nodejs-para-backend)
<!-- TOC -->

## ¿Qué es Node.js?

Node.js **NO es un servidor de aplicaciones** como Tomcat. Es un **entorno de ejecución** que permite ejecutar JavaScript fuera del navegador. Es como la JVM para Java, pero para JavaScript.

## Diferencias fundamentales con Java/Tomcat

**Modelo Java tradicional:**
- Escribes tu aplicación (Servlets, Controllers, POJOs, DAOs)
- La empaquetas en un WAR/EAR
- La despliegas en un servidor de aplicaciones (Tomcat, JBoss, etc.)
- El servidor gestiona múltiples aplicaciones

**Modelo Node.js:**
- Tu aplicación **ES el servidor**
- No hay un contenedor externo que la ejecute
- Tú creas el servidor HTTP dentro de tu código JavaScript
- Cada aplicación corre como un proceso independiente

## ¿Cómo funciona una aplicación Node.js?

Tu aplicación incluye código como este (ejemplo simple):

```javascript
// server.js
const express = require('express');
const app = express();

app.get('/api/users', (req, res) => {
    res.json([{id: 1, name: 'Juan'}]);
});

app.listen(3000, () => {
    console.log('Servidor escuchando en puerto 3000');
});
```

Este código **crea y arranca el servidor HTTP**. No necesitas un servidor como JBoss o Tomcat.

## Instalación y despliegue

**En desarrollo (con IDE):**
```bash
node server.js
```

**En producción (sin IDE):**

1. **Instalas Node.js en el servidor** (como instalarías la JVM)
2. **Copias tu código** al servidor (todos los archivos .js y package.json)
3. **Instalas las dependencias:**
   ```bash
   npm install
   ```
4. **Arrancas la aplicación:**
   ```bash
   node server.js
   ```

## ¿Qué "empaquetas"?

A diferencia del WAR, en Node.js normalmente:
- Subes directamente los archivos fuente (.js)
- O creas un contenedor Docker
- No hay un "artefacto binario" como el WAR

**Archivo más importante:** `package.json` (equivalente al pom.xml), define dependencias y scripts.

## ¿Cómo mantener el servidor corriendo?

En producción, usas gestores de procesos como:
- **PM2** (el más popular)
- **systemd** (Linux)
- **Docker** con restart policies

Ejemplo con PM2:
```bash
npm install -g pm2
pm2 start server.js
pm2 startup  # Para que arranque con el sistema
pm2 save
```

## Arquitectura Backend con Node.js

Se pueden crear arquitecturas organizadas, con estructura de carpetas clara para separar responsabilidades (siguiendo principios SOLID como Single Responsibility y Dependency Inversion)

```
/proyecto
  /controllers   (Controllers)
  /models        (POJOs/Entidades)
  /dao o /repositories  (Acceso a datos)
  /routes        (Rutas/Endpoints)
  /services      (Lógica de negocio)
  server.js      (Punto de entrada)
  package.json   (Dependencias)
```

## ¿Por qué Node.js para backend?

- **JavaScript en todo el stack** (frontend y backend)
- **Muy eficiente para I/O** (operaciones de red, bases de datos)
- **Ecosistema npm** muy rico
- **Microservicios ligeros**
- **Bueno para APIs REST, WebSockets, streaming**
