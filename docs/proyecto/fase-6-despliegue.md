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

## Qué guardar en tu repositorio

- Tabla de máquinas.
- Captura de Proxmox con ambas máquinas.
- Pruebas de conectividad.

Indica desde qué máquina has ejecutado cada prueba y cómo interpretas
el resultado. Un ping correcto acredita conectividad IP en ese recorrido;
en la fase siguiente comprobarás además el servicio desde el cliente.

---

[Anterior](fase-5-plantilla.md) · [Fase 7: Servicio ASO](fase-7-servicio.md)
