# Fase 11. Pruebas de seguridad

[Guía de la práctica](practica.md) · **Al terminar:** puertos, permisos, riesgos y medidas documentados.

**Sesión de clase:** 32. Consulta el [calendario](../clases/index.md).

Revisa qué has dejado accesible y si los permisos coinciden con lo que
necesita el servicio. Realiza las pruebas solo dentro de tu laboratorio
autorizado y completa `docs/09-rendimiento-seguridad.md` con los resultados.

Pruebas obligatorias:

```bash
ss -tulpn
systemctl --failed
journalctl -p warning -n 30
```

Desde `cli-linux`, prueba puertos del servidor:

```bash
nmap -sV IP_SRV_ASO
```

Comprueba además:

- SSH sin acceso directo de root si procede.
- Usuarios y grupos del servicio.
- Permisos del directorio compartido.
- Firewall activo si lo has configurado.
- Actualizaciones aplicadas.
- Secretos fuera del repositorio.

## Qué guardar en tu repositorio

- Puertos abiertos y justificación.
- Medidas aplicadas.
- Riesgos pendientes.
- Mejoras propuestas.

Relaciona cada puerto con un proceso y con una necesidad del servicio.
Si corriges un permiso o una configuración, repite la prueba afectada y
guarda el resultado. Cierra indicando qué riesgo sigue pendiente y por qué.

---

[Anterior](fase-10-rendimiento.md) · [Memoria, entrega y defensa](entrega.md)
