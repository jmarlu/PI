# Fase 9. Copias y restauración

[Guía de la práctica](practica.md) · **Al terminar:** copias reales y recuperación verificada.

**Sesiones de clase:** 29–30. Consulta el [calendario](../clases/index.md).

Prepara copias del laboratorio y del servicio, y utilízalas para recuperar
un fichero de prueba. La fase termina cuando compruebas desde el cliente
que el dato recuperado vuelve a estar disponible.

Escribe el procedimiento en `docs/08-copias-restauracion.md`: debe permitirte
repetir la recuperación sin improvisar rutas ni adivinar qué contiene cada
copia.

## Copia a nivel Proxmox

Realiza al menos una copia de seguridad real desde Proxmox:

- Backup de `srv-aso`.
- Backup de `cli-linux`.

Una instantánea (snapshot) es opcional antes de un cambio, pero no
sustituye al backup. Una copia en el mismo disco tampoco protege frente
al fallo de ese disco. Usa el destino autorizado y documenta este riesgo
si no existe almacenamiento independiente.

Documenta:

- Tipo de copia.
- Ubicación.
- Fecha y hora.
- Tamaño.
- Qué incluye y qué no incluye.

## Copia a nivel de servicio

Tu script debe copiar como mínimo:

- Datos del servicio, por ejemplo `/srv/grupo_asir`.
- Configuración principal, por ejemplo `/etc/samba/smb.conf`.
- Fecha de la copia.
- Log de ejecución.

La copia de datos y `smb.conf` no incluye por sí sola las cuentas Linux,
la base de credenciales Samba ni todo el sistema. Explica cómo conservar
o reconstruir esas dependencias y protege las copias fuera de GitHub.

Ejemplo de estructura de destino:

```text
/backup/servicio-aso/
├── 2026-10-15_1200/
│   ├── datos/
│   ├── config/
│   └── backup.log
```

## Restauración obligatoria

1. Crea un fichero de prueba en el servicio.
2. Ejecuta la copia.
3. Borra o modifica el fichero.
4. Restaura desde la copia.
5. Comprueba desde el cliente que el servicio vuelve a funcionar.

## Qué guardar en tu repositorio

- Captura o salida antes del cambio.
- Backup creado.
- Incidencia simulada.
- Restauración.
- Prueba final correcta.
- Tiempo aproximado de recuperación.

---

[Anterior](fase-8-automatizacion.md) · [Fase 10: Pruebas de rendimiento](fase-10-rendimiento.md)
