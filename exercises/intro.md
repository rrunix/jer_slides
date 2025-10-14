# Instrucciones para los juegos en Node.js

## Instalación previa

Antes de ejecutar los juegos, instala el paquete necesario:

```bash
npm install readline-sync
```

## Juego 1: Piedra, Papel o Tijera

**Reglas:**
- Mínimo 5 rondas
- Para ganar el juego debe haber una diferencia de al menos 1 punto
- Usa números aleatorios: `Math.floor(Math.random() * 3)`
- Lee entrada con: `readlineSync.question('Elige: piedra, papel o tijera: ')`. Hacer un `const readlineSync = require('readline-sync');` al principio del archivo.


## Juego 2: Adivina el Número

**Reglas:**
- Adivina un número entre 1 y 100 (incluidos)
- El juego da pistas: "muy alto" o "muy bajo"
- Cuenta los intentos hasta acertar

## Ejecución

```bash
node piedrapapeltijera.js
node adivinanumero.js
```

¡Listo para jugar! 🎮