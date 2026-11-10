# Presentación del proyecto

**Proyecto Intermodular · 2.º ASIR · 2026-2027**

## 1. El reto

Construir y administrar un nodo Proxmox individual con Linux, servicio ASO,
automatización, copias y pruebas. No se trata solo de instalar: debes justificar,
documentar, verificar y defender las decisiones.

## 2. La primera actividad

Antes de inventariar o instalar:

1. Crear tu repositorio individual en GitHub.
2. Iniciar README, ficha, bitácora y memoria en Markdown.
3. Publicar el primer commit y entregar la URL en Aules.
4. Comprobar el acceso del profesor.

## 3. El montaje de clase

Trabajaremos con **Proxmox en una VM de VirtualBox en tu equipo**. Conservas
LliureX u otro sistema anfitrión y repartes los recursos entre este y la VM.
El servidor y el cliente se crearán dentro de Proxmox.

No hay ordenadores dedicados para todo el grupo. Si dispones de uno propio,
la instalación directa queda como opción, con autorización del profesor
y permiso para borrar el disco. Se mantienen las mismas evidencias.
**El Proxmox del centro no forma parte de los recursos del proyecto.**

## 4. Investigar antes de instalar

El inventario debe responder con datos, fuentes y justificación:

- ¿Puedo instalar Proxmox y ejecutar el proyecto completo?
- ¿Qué limitaciones tiene este hardware para el laboratorio?
- ¿Qué componentes son los más críticos y por qué?

En VirtualBox investigas el host real además de la VM y reservas recursos para
LliureX, navegador, editor y Ansible.

## 5. Qué debes demostrar

Nodo, diagrama, plantilla Linux, servidor y cliente, servicio ASO, dos scripts Bash,
Ansible, backup real, restauración, rendimiento y seguridad. La memoria y el
historial se elaboran desde el inicio, no al final.

Un script no sustituye a Ansible. Un snapshot no sustituye al backup.
Una captura sin explicación no sustituye una prueba.

## 6. Cómo trabajaremos

Una clase semanal de **tres horas seguidas**:

Explicación → demostración → trabajo individual → validación → documentación.

Cada cierre deja un cambio significativo publicado y comprobado en GitHub.
Una incidencia se registra con pruebas y siguiente paso.

Consulta el [calendario de las 33 sesiones y sus hitos](index.md).

## 7. Límites del laboratorio

Solo equipos, red y cuentas autorizados. Sin datos personales reales, sin secretos
en GitHub y sin pruebas sobre compañeros. Los VDI, ISOs y backups permanecen en
el almacenamiento autorizado, no en el repositorio.

## 8. Defensa y entrega

Abres el README, localizas tus evidencias, muestras el funcionamiento y respondes
preguntas sobre límites, red, permisos, automatización y recuperación.
La entrega identifica URL y commit completo publicado.

[Comienza la primera sesión](../proyecto/primera-sesion.md) y conserva como
referencia la [guía de la práctica](../proyecto/practica.md).
