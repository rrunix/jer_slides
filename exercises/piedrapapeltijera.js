const readlineSync = require('readline-sync');

const opciones = ['piedra', 'papel', 'tijera'];
let puntosJugador = 0;
let puntosComputadora = 0;
let ronda = 0;

console.log('=== PIEDRA, PAPEL O TIJERA ===');
console.log('Mínimo 5 rondas. Para ganar debe haber diferencia de 1 punto');
console.log('');

while (ronda < 5 || Math.abs(puntosJugador - puntosComputadora) < 1) {
    ronda++;
    console.log(`--- RONDA ${ronda} ---`);
    console.log(`Marcador: Tú ${puntosJugador} - ${puntosComputadora} Computadora`);
    
    const jugadorEleccion = readlineSync.question('Elige: piedra, papel o tijera: ').toLowerCase();
    
    if (!opciones.includes(jugadorEleccion)) {
        console.log('Opción no válida. Pierdes esta ronda.');
        puntosComputadora++;
        continue;
    }
    
    const computadoraEleccion = opciones[Math.floor(Math.random() * 3)];
    
    console.log(`Tú: ${jugadorEleccion}`);
    console.log(`Computadora: ${computadoraEleccion}`);
    
    if (jugadorEleccion === computadoraEleccion) {
        console.log('¡Empate!');
    } else if (
        (jugadorEleccion === 'piedra' && computadoraEleccion === 'tijera') ||
        (jugadorEleccion === 'papel' && computadoraEleccion === 'piedra') ||
        (jugadorEleccion === 'tijera' && computadoraEleccion === 'papel')
    ) {
        console.log('¡Ganaste esta ronda!');
        puntosJugador++;
    } else {
        console.log('¡Perdiste esta ronda!');
        puntosComputadora++;
    }
    console.log('');
}

console.log('=== JUEGO TERMINADO ===');
console.log(`Marcador final: Tú ${puntosJugador} - ${puntosComputadora} Computadora`);
if (puntosJugador > puntosComputadora) {
    console.log('¡GANASTE EL JUEGO! 🎉');
} else {
    console.log('¡PERDISTE EL JUEGO! 😢');
}