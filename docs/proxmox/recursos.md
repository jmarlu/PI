# CPU, memoria y dimensionamiento

## Capacidad, asignación y consumo

Al repartir los recursos conviene distinguir tres cantidades. La **capacidad** es lo que tiene el equipo; la **asignación** es lo que configuras para una máquina virtual; y el **consumo** es lo que esa máquina utiliza en un momento concreto. Por ejemplo, asignar un disco virtual de 40 GiB no significa que ya esté ocupando 40 GiB ni que el disco físico tenga todo ese espacio libre.

Si utilizas VirtualBox, haz dos cálculos relacionados. Primero decide cuánto puedes asignar a la VM de Proxmox sin dejar sin recursos al ordenador que la ejecuta. Después reparte esa asignación entre Proxmox, el servidor y el cliente. La memoria reservada al anfitrión queda fuera del segundo reparto.

## CPU: vCPU no significa núcleo dedicado

El planificador reparte tiempo de CPU entre cargas. Asignar cuatro vCPU a cada
una de dos VMs sobre cuatro hilos físicos no crea ocho núcleos. Puede funcionar
si las cargas no coinciden, pero aparecerán esperas cuando ambas los demanden.

Más vCPU no garantiza más velocidad: una tarea poco paralela puede no
aprovecharlas. También influyen el disco, la memoria y la sobrecarga de las
capas anidadas. Empieza con una asignación conservadora y aumenta solo si las
mediciones justifican la necesidad.

Las opciones de topología, tipo de CPU y límites de Proxmox deben interpretarse
según la versión instalada. **CPU units** expresa prioridad relativa bajo
contención; no es lo mismo que una reserva de núcleos físicos.
[Configuración de CPU y memoria](https://pve.proxmox.com/pve-docs/chapter-qm.html).

## RAM: el recurso que no debes agotar

El anfitrión necesita memoria para su escritorio, navegador, editor y
VirtualBox. Proxmox necesita memoria para el sistema y servicios de gestión,
además de la que usan los invitados. Los requisitos oficiales de Proxmox
distinguen el sistema base de la memoria adicional para VMs y almacenamiento:
consulta la [página de requisitos](https://www.proxmox.com/en/products/proxmox-virtual-environment/requirements).

Ejemplo didáctico, **no mínimo oficial ni asignación obligatoria**:

| Nivel | Presupuesto de ejemplo |
|---|---|
| RAM física del equipo | 16 GiB |
| Reserva para anfitrión y margen de sus aplicaciones | 6 GiB |
| VM Proxmox en VirtualBox | 10 GiB |
| Dentro de Proxmox: base y margen | 3 GiB |
| Dentro de Proxmox: servidor | 3 GiB |
| Dentro de Proxmox: cliente | 2 GiB |
| Dentro de Proxmox: reserva restante | 2 GiB |

Las cuatro últimas cantidades suman los 10 GiB, no otros 10 GiB adicionales.
La reserva incluye una estimación que debes contrastar con consumo real.
Si el equipo solo tiene 8 GiB no puedes trasladar esta tabla sin rediseñarla.

El ballooning permite ajustar memoria utilizable por una VM cuando el invitado
lo soporta. No fabrica RAM y no garantiza que siempre pueda devolverla sin
impacto. La memoria caché no es necesariamente un desperdicio: puede acelerar
lecturas y liberarse en parte cuando hay demanda.

El intercambio a disco puede evitar un fallo inmediato, pero un sistema que
intercambia memoria intensamente puede quedar inutilizable para la clase.
No presentes “no se apagó” como prueba suficiente de viabilidad.

## Calcular el margen paso a paso {#ejemplo-presupuesto}

La tabla anterior usa una VM Proxmox de 10 GiB. Este segundo caso usa 8 GiB,
como punto de partida de la guía de VirtualBox; **son alternativas**, no
cantidades que debas sumar.

### Caso resuelto A: propuesta que deja margen

El equipo declara 16 GiB. Propones reservar 8 GiB al anfitrión y asignar 8 GiB
a Proxmox. Dentro de Proxmox estimas 2 GiB para su sistema, 2 GiB para el
servidor y 1 GiB para el cliente.

~~~text
Presupuesto exterior: 16 - 8 = 8 GiB para la VM Proxmox
Margen interior:       8 - 2 - 2 - 1 = 3 GiB
~~~

Los 3 GiB que quedan dentro de Proxmox pertenecen a los 8 GiB que ya le has asignado. No se añaden a la reserva del anfitrión. El cálculo indica que el reparto cabe sobre el papel; para comprobar si funciona bien, enciende servidor y cliente y observa también cómo responde el equipo anfitrión.

### Caso resuelto B: propuesta que no cabe

Con la misma VM Proxmox de 8 GiB, alguien propone nodo 2 GiB, servidor 4 GiB
y cliente 3 GiB:

~~~text
Demanda prevista: 2 + 4 + 3 = 9 GiB
Saldo:           8 - 9 = -1 GiB, antes de reservar margen
~~~

El reparto no es viable **tal como está planteado**. Las opciones son reducir
necesidades justificadamente, usar invitados más ligeros compatibles o revisar
la asignación exterior si el anfitrión puede permitírselo. Activar swap no
convierte ese saldo negativo en RAM suficiente.

Si propones no encender servidor y cliente a la vez, tampoco has demostrado
las pruebas cliente-servidor del proyecto. Esa restricción debe contrastarse
con el trabajo que realmente tienes que ejecutar.

### Caso resuelto C: la plantilla también puede consumir

Una plantilla preparada y apagada ocupa disco, pero no ejecuta la carga de una
VM arrancada. Su clon de ensayo sí consume memoria y CPU al iniciarse.

Planifica cuándo vas a encender el clon de ensayo y qué otros invitados seguirán funcionando. La plantilla apagada necesita espacio en disco; cuando arrancas un clon, este necesita además CPU y memoria.

## Interpretar medidas sin mezclar unidades

`2048 MiB = 2 GiB`. En cambio, MB/GB decimales y MiB/GiB binarios no son
unidades idénticas. Conserva la unidad que informa cada herramienta y convierte
antes de comparar.

Ejemplo original: un archivo de 600 MiB tarda 30 segundos en transferirse.
El promedio observado es `600 / 30 = 20 MiB/s`. Eso no demuestra por sí solo
la velocidad máxima de la tarjeta: pueden intervenir caché, disco, CPU,
protocolo y las capas virtuales.

Registra tamaño, duración, repeticiones y qué invitados estaban activos.
Si otro ensayo tarda 20 segundos, no atribuyas la mejora a más vCPU si también
cambiaste el disco o el archivo.

## Disco y doble aprovisionamiento

El archivo VDI del nodo ocupa espacio en el disco del anfitrión. Dentro de él,
Proxmox aloja sus volúmenes y, dentro de estos, los sistemas de archivos de los
invitados. Hay que vigilar todas las capas, especialmente cuando se usan discos
dinámicos o almacenamiento thin.

Ejemplo: un VDI con capacidad lógica de 120 GiB no puede crecer hasta ella si
al disco físico solo le quedan 25 GiB libres. La instalación inicial puede ir
bien y una copia de seguridad posterior provocar el agotamiento.

Presupuesta sistema del nodo, discos de invitados, ISO/plantillas, crecimiento
de datos, copias y margen. Anota qué elementos están en el mismo disco físico.
Una carpeta distinta dentro del mismo VDI no es un destino independiente.

## Qué componentes son críticos y por qué

No existe un ranking universal. Elabora el tuyo según la carga:

| Componente | Pregunta que permite justificarlo |
|---|---|
| CPU y firmware | ¿Puedo arrancar el nodo y disponer de KVM interno? |
| RAM | ¿Pueden coexistir anfitrión, nodo, servidor y cliente? |
| Disco | ¿Hay capacidad, salud y latencia adecuadas para escrituras concurrentes? |
| Red | ¿Puedo administrar y probar el servicio con una topología autorizada? |
| Refrigeración y alimentación | ¿Se mantiene estable durante la sesión completa? |

Explica si el problema impide utilizar el montaje, lo hace más lento o puede provocar una interrupción o pérdida de datos. Decir que un equipo «es antiguo» no aclara cuál de esos problemas has observado ni qué medida necesitas tomar.

## Medición y ajuste

1. Anota configuración y métricas en reposo con todos los sistemas necesarios.
2. Ejecuta una carga acotada, autorizada y comparable desde el cliente.
3. Observa a la vez anfitrión, nodo e invitados.
4. Cambia una única asignación y repite con la misma carga.
5. Explica mejora, coste y limitación pendiente.

No satures la red del aula ni escribas pruebas destructivas sobre discos.
Tiempo de arranque, transferencia de un archivo de prueba y tiempo de copia
son medidas útiles si registras tamaño, condiciones y unidades.

**Caso para tu memoria:** la CPU está al 20 %, el disco permanece ocupado y el
cliente tarda en responder. ¿Por qué asignar más vCPU podría no ayudar?
Usa tu respuesta para fundamentar el componente crítico elegido.
