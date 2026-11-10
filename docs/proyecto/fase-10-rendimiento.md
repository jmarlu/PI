# Fase 10. Pruebas de rendimiento

[Guía de la práctica](practica.md) · **Al terminar:** medidas, interpretación y mejoras justificadas.

**Sesión de clase:** 31. Consulta el [calendario](../clases/index.md).

Comprueba cómo se comporta el laboratorio cuando lo utilizas. La idea es
averiguar si tu reparto de recursos permite trabajar con el servicio y
detectar qué lo limita. Guarda las pruebas en
`docs/09-rendimiento-seguridad.md`.

## 1. Prepara una prueba que puedas repetir

Anota la fecha, los recursos asignados y qué máquinas están encendidas.
En VirtualBox, registra también la carga del anfitrión: sus aplicaciones
comparten CPU, memoria y disco con todo el laboratorio.

Observa primero el sistema en reposo. Después realiza una operación
habitual desde `cli-linux`, como copiar y leer un fichero de prueba del
servicio. Usa el mismo fichero y recorrido si repites la prueba; anota
su tamaño y el tiempo aproximado. Evita datos personales y pruebas que
llenen el disco o saturen la red del aula.

## 2. Observa cada recurso

Ejecuta las consultas en el equipo que estés midiendo y anota cuál es.
Combina las salidas con los gráficos del panel de Proxmox.

| Qué observas | Dónde y con qué | Qué debes explicar |
|---|---|---|
| CPU y carga | Nodo y servidor: `uptime`, `top`, panel Proxmox | Si la carga cambia durante la operación y si dificulta trabajar |
| RAM | Nodo y servidor: `free -h`, panel Proxmox; también el anfitrión Linux | Memoria disponible, uso de swap y margen con ambas máquinas arrancadas |
| Disco | Nodo y servidor: `df -h`; copia del fichero de prueba | Espacio libre y tiempo de copia; en VirtualBox, también espacio real del anfitrión |
| Red | Cliente: `ping -c 4 IP_SRV_ASO`; `iperf3` opcional en el laboratorio | Latencia, pérdidas y recorrido probado; un ping no mide el rendimiento de Samba |
| Servicio | Desde `cli-linux`: copia y lectura del fichero | Si completa la operación y cuánto tarda en las condiciones registradas |

Una captura de uso de RAM o una carga de CPU aislada no basta para concluir
que falta capacidad. Relaciona lo que ves con la tarea que se estaba
ejecutando. `df -h` informa de espacio, no de velocidad del disco.

## 3. Compara y explica lo que ha ocurrido

Usa una tabla breve para reunir tus resultados. Escribe tus propias
medidas, con unidades y condiciones; no hay un valor universal que debas
copiar como resultado correcto.

| Prueba y equipo | En reposo | Durante la operación | Interpretación y evidencia |
|---|---|---|---|
| CPU y carga | | | |
| RAM y swap | | | |
| Espacio y copia de fichero | | | |
| Red y respuesta del servicio | | | |

Explica si el servidor y el cliente pueden funcionar a la vez sin dejar
al anfitrión sin recursos. Si detectas una limitación, propone un ajuste
concreto: reducir cargas simultáneas, revisar el espacio de copias o
cambiar el reparto de RAM, por ejemplo. Si lo aplicas, repite la misma
prueba y compara; si no, déjalo como mejora pendiente justificada.

Incluye una breve valoración de consumo y sostenibilidad de tu montaje.
Si has elegido la instalación opcional en un ordenador dedicado, explica
también si reutilizarlo compensa para el uso previsto.

## Antes de pasar a seguridad

Deja documentados el escenario, las medidas, las salidas o capturas
relevantes y una conclusión sobre el principal límite del laboratorio.
Indica qué funciona de forma aceptable para tu uso y qué mejorarías.
Un resultado lento también sirve como evidencia si lo has medido y sabes
explicarlo.

---

[Anterior](fase-9-copias.md) · [Fase 11: Pruebas de seguridad](fase-11-seguridad.md)
