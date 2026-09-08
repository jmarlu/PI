# Rendimiento y seguridad

**Sesiones 31-32.** Prueba únicamente tu laboratorio autorizado.
Registra qué mides, con qué versión, qué invitados están activos y durante cuánto
tiempo. No presentes una captura de un instante como una conclusión universal.

## Rendimiento

En el nodo propio y, cuando corresponda, dentro del servidor:

~~~bash
uptime
free -h
df -h
~~~

Revisa también el panel Proxmox. La RAM del invitado y la del nodo son medidas
de capas diferentes. La memoria disponible es más útil que observar únicamente
la columna de memoria libre. Relaciona los resultados con el presupuesto inicial.

Desde el cliente realiza una transferencia de tamaño limitado acordado con
el profesor. Mide tiempo y tamaño, comprueba el hash y repite tres veces sin
cambiar las condiciones. No llenes el disco ni ejecutes carga ilimitada.

| Ensayo | Condición | Medida y unidad | Interpretación |
|---|---|---|---|
| CPU | Reposo y transferencia | Carga y uso CPU | ¿Hay saturación sostenida? |
| RAM | Ambos invitados activos | Disponible y swap | ¿Se mantiene el margen previsto? |
| Disco | Antes/después de copia | Espacio libre y duración | ¿Cabe la siguiente copia? |
| Red | Cliente a servidor | Pérdida y latencia | ¿Se cumple la comunicación prevista? |
| Servicio | Transferencia repetida | Tiempo y MiB/s | ¿Permite el uso esperado? |

`MiB/s = tamaño en MiB / segundos`. No confundas bytes con bits ni MiB con MB.
Cachés, disco, CPU y carga exterior influyen en el resultado.
`iperf3` es opcional; usa una duración limitada y solo el servidor autorizado.
No es obligatorio instalar un benchmark intensivo.

## Seguridad

En `srv-aso`, con permisos adecuados:

~~~bash
sudo ss -tulpn
systemctl --failed
sudo journalctl -p warning -n 30 --no-pager
id alumno1
getfacl /srv/grupo_asir
~~~

Desde `cli-linux`, solo contra **la IP de tu servidor**:

~~~bash
nmap -sV -p 22,139,445 IP_SRV_ASO
~~~

El alcance acotado es suficiente para este ejemplo. Si elegiste otro servicio,
acuerda sus puertos. No escanees subredes, Internet, el host del centro o compañeros.
Un puerto filtrado no equivale a cerrado ni a servicio seguro.
[Referencia de estados de Nmap](https://nmap.org/book/man-port-scanning-basics.html).

## Aplicar una mejora y volver a probar

| Control | Evidencia |
|---|---|
| Administración | Cuenta no root; sudo limitado según indicación docente |
| SSH | Configuración justificada; prueba de acceso autorizada |
| Firewall | Reglas, origen permitido y acceso de consola para recuperar |
| Servicio | Usuarios válidos, ACL y denegación real a cuenta no autorizada |
| Actualizaciones | Versiones y resultado de actualización |
| Copias | Destino protegido y restauración demostrada |
| GitHub | Sin secretos, enlaces funcionales y acceso docente |

Antes de endurecer SSH o el firewall conserva la sesión y la consola.
Valida sintaxis, abre una segunda conexión autorizada y comprueba el acceso
antes de cerrar la original. No publiques claves ni desactives verificaciones
para evitar un error.

## Informe final

En `docs/09-rendimiento-seguridad.md` registra pruebas, resultados, criterio
de aceptación, medidas adoptadas y riesgos pendientes.
Cierra el inventario: ¿se confirmó el cuello de botella que habías previsto?
¿Qué cambiarías primero y con qué evidencia?

Continúa con [evaluación y defensa](../proyecto/evaluacion.md).
