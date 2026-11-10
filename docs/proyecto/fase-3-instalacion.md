# Fase 3. Instalación de Proxmox

[Guía de la práctica](practica.md) · **Al terminar:** nodo accesible y pruebas de instalación.

**Sesiones de clase:** 7–9. Consulta el [calendario](../clases/index.md).

El montaje de clase utiliza VirtualBox. Sigue la
[guía de montaje local](../proxmox/virtualbox.md), especialmente la
[comprobación de virtualización anidada](../proxmox/virtualbox.md#3-comprobar-la-virtualizacion-anidada).
Si aparece un error, conserva el mensaje para poder diagnosticarlo.

## Instala Proxmox en VirtualBox

1. Abre VirtualBox en tu equipo y registra su versión.
2. Crea una VM Linux de 64 bits para Proxmox con CPU, RAM y VDI del diseño.
3. Reserva recursos para el sistema anfitrión; no uses toda su RAM para la VM.
4. Configura los adaptadores NAT y solo-anfitrión conforme al diseño local.
5. Con la VM apagada, habilita virtualización anidada si está disponible y
   necesitas VMs KVM internas; comprueba luego su funcionamiento real.
6. Monta la ISO autorizada e instala Proxmox dentro del VDI, no sobre el host.
7. Configura IP de gestión, hostname y DNS; abre el panel desde el navegador
   del mismo equipo anfitrión.
8. Comprueba si KVM está disponible para los invitados que crearás en las
   fases siguientes. Si necesitas la alternativa LXC, valídala con el profesor.
   Tanto `srv-aso` como `cli-linux` se crearán dentro de Proxmox.

## Qué guardar en tu repositorio

Documenta la instalación en `docs/03-instalacion-proxmox.md` e incluye:

- Captura del panel Proxmox.
- Captura de red y almacenamiento.
- Salida de:

```bash
hostnamectl
ip -br addr
pveversion
df -h
```

## Si tienes autorización para la instalación opcional

Puedes instalar directamente en un ordenador propio dedicado si el profesor
ha validado la propuesta y tienes permiso para borrar el disco. Sigue el
[procedimiento opcional en equipo físico](../proxmox/instalacion.md#modalidad-a-equipo-fisico-autorizado)
y documenta las mismas comprobaciones. No necesitas un segundo ordenador
para completar el proyecto de clase.

---

[Anterior](fase-2-red.md) · [Fase 4: Configuración base del nodo](fase-4-configuracion.md)
