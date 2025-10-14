const readlineSync = require('readline-sync');

const numeroSecreto = Math.floor(Math.random() * 100) + 1;
let intentos = 0;
let adivinado = false;

console.log('=== ADIVINA EL NÚMERO ===');
console.log('Piensa en un número entre 1 y 100');
console.log('');

while (!adivinado) {
    const intento = parseInt(readlineSync.question('Tu número: '));
    intentos++;
    
    if (isNaN(intento) || intento < 1 || intento > 100) {
        console.log('Por favor, ingresa un número válido entre 1 y 100');
        intentos--;
        continue;
    }
    
    if (intento === numeroSecreto) {
        console.log(`¡CORRECTO! 🎉`);
        console.log(`El número era ${numeroSecreto}`);
        console.log(`Lo adivinaste en ${intentos} intentos`);
        adivinado = true;
    } else if (intento < numeroSecreto) {
        console.log(`${intento} es muy BAJO. Intenta con uno más alto.`);
    } else {
        console.log(`${intento} es muy ALTO. Intenta con uno más bajo.`);
    }
}

console.log('¡Gracias por jugar!');