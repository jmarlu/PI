# Fase 5. Plantilla Linux

[Guía de la práctica](practica.md) · **Al terminar:** plantilla reutilizable y prueba de clonado.

**Sesiones de clase:** 13–16. Consulta el [calendario](../clases/index.md).

Crea una base Linux ligera que puedas reutilizar para el servidor y el
cliente. Prepararla una vez te ahorra repetir la instalación y te permite
partir de una configuración conocida. Documenta las decisiones en
`docs/04-plantilla-linux.md` y consulta el
[taller de plantillas](../proxmox/plantillas.md) para el procedimiento.

Opciones válidas:

- VM Linux minimal con cloud-init.
- Contenedor LXC basado en plantilla Debian/Ubuntu.

Configuración mínima de la plantilla:

- Hostname base.
- Usuario administrativo no root.
- SSH instalado.
- Actualizaciones aplicadas.
- Zona horaria correcta.
- Paquetes útiles: `curl`, `vim` o `nano`, `sudo`, `rsync`, `acl`,
  `qemu-guest-agent` si es VM.
- Limpieza de datos específicos antes de convertir en plantilla.

## Qué guardar en tu repositorio

- Nombre de la plantilla.
- Recursos asignados.
- Comandos o capturas de creación.
- Prueba de clonado correcto.

Arranca el clon y comprueba su nombre, red y acceso. Revisa que no conserve
la identidad ni las claves de host SSH de la base. Explica qué has limpiado
y qué personalizas al crear una máquina nueva.

---

[Anterior](fase-4-configuracion.md) · [Fase 6: Servidor y cliente](fase-6-despliegue.md)
