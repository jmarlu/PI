# Fase 6. Servidor y cliente

[Guía de la práctica](practica.md) · **Al terminar:** dos VM o LXC con conectividad comprobada.

**Sesiones de clase:** 17–20. Consulta el [calendario](../clases/index.md).

Despliega al menos estos dos sistemas:

| Nombre | Tipo | Función | Recursos orientativos |
|---|---|---|---|
| `srv-aso` | VM o LXC | Servidor del servicio ASO | 1-2 vCPU, 1-2 GB RAM |
| `cli-linux` | VM o LXC | Cliente de pruebas | 1 vCPU, 512 MB-1 GB RAM |

Créales una identidad y dirección propias a partir de la plantilla.
Ambos van dentro de Proxmox. Registra su ID, nombre, IP, tipo y recursos
en `docs/05-vms-lxc.md`, y actualiza el diagrama si cambias algo del diseño.

Ambos deben tener:

- Hostname correcto.
- IP documentada.
- Conexión entre ellos.
- Acceso SSH si procede.
- Actualizaciones aplicadas.

Pruebas mínimas:

```bash
ping -c 4 IP_DEL_OTRO_EQUIPO
ssh usuario@IP_DEL_SERVIDOR
hostnamectl
ip -br addr
```

## Comprueba los discos de cada invitado {#discos-invitados}

Recupera la [tabla de almacenamientos de la fase 4](fase-4-configuracion.md#1-revisa-donde-se-guardara-cada-cosa).
Ahora relaciona cada invitado con el volumen o archivo donde se guarda
su sistema. No confundas su capacidad virtual con el espacio físico consumido.

1. En Proxmox, selecciona `srv-aso`. Si es una VM, abre **Hardware** y localiza
   su disco, por ejemplo `scsi0`. Si es un LXC, abre **Resources** y localiza
   **Root Disk** (`rootfs`). Repite la revisión con `cli-linux`.
2. Anota el identificador del volumen, el almacenamiento y la capacidad
   configurada. Comprueba que coinciden con tu presupuesto y que servidor
   y cliente tienen volúmenes propios. Un clon enlazado puede depender además
   del disco de la plantilla; deja anotado si utilizaste ese tipo de clon.
3. Puedes contrastar la configuración desde la **consola del nodo** con la
   orden que corresponda al tipo de invitado. Sustituye el ID antes de ejecutarla:

   ```bash
   # Solo para una VM QEMU/KVM.
   qm config ID_VM
   # Solo para un contenedor LXC.
   pct config ID_CT
   ```

4. Dentro de **cada invitado**, ejecuta `df -h /` para consultar su sistema
   de archivos raíz. En una VM puedes añadir `lsblk -f` para ver particiones
   y volúmenes. En LXC, `lsblk` no representa del mismo modo los discos
   propios de una VM; utiliza la configuración de `rootfs` vista en el nodo.
5. Compara lo que ve el invitado con su capacidad configurada y con el espacio
   disponible en el almacenamiento. Las cifras pueden diferir por particiones,
   metadatos y espacio ya ocupado. Si falta espacio, identifica primero en qué
   capa ocurre antes de ampliar nada.

Completa esta tabla en `docs/05-vms-lxc.md` con tus valores:

| Invitado e ID | VM o LXC | Disco o rootfs | Almacenamiento y volumen | Capacidad configurada | Libre en `/` |
|---|---|---|---|---|---|
| `srv-aso` | | | | | |
| `cli-linux` | | | | | |

Ampliar un disco virtual no amplía automáticamente su partición y su sistema
de archivos. Si necesitas hacerlo, prepara el procedimiento con el profesor
según el diseño real y las copias disponibles.

## Qué guardar en tu repositorio

- Tabla de máquinas.
- Tabla de discos o rootfs, almacenamiento y espacio de los invitados.
- Captura de Proxmox con ambas máquinas.
- Pruebas de conectividad.

Indica desde qué máquina has ejecutado cada prueba y cómo interpretas
el resultado. Un ping correcto acredita conectividad IP en ese recorrido;
en la fase siguiente comprobarás además el servicio desde el cliente.

---

[Anterior](fase-5-plantilla.md) · [Fase 7: Servicio ASO](fase-7-servicio.md)
